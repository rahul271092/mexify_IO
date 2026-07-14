using System;
using System.Web.UI;
using Mexify.DataAccess.Repositories;
using Mexify.Models;
using Mexify.Utilities;
using static Mexify.Web.Models.P2PTrade;

namespace Mexify.Web.User
{
    public partial class Trade : System.Web.UI.Page
    {
        private int _userId;
        private long _tradeId;
        private P2PRepository _repo;
        private P2PTradeDetails _trade;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Web/login.aspx", false);
                return;
            }

            _userId = Convert.ToInt32(Session["UserId"]);
            _repo = new P2PRepository();

            if (!long.TryParse(Request.QueryString["id"], out _tradeId))
            {
                ShowUnauthorized();
                return;
            }

            if (!IsPostBack)
            {
                LoadTradeDetails();
            }
        }

        private void LoadTradeDetails()
        {
            try
            {
                _trade = _repo.GetTradeDetails(_tradeId, _userId);

                if (_trade == null || _trade.UserRole == "NONE")
                {
                    ShowUnauthorized();
                    return;
                }

                // Store in hidden fields for JS
                hfTradeId.Value = _tradeId.ToString();
                hfUserRole.Value = _trade.UserRole;
                hfMinutesRemaining.Value = _trade.MinutesRemaining.ToString();

                // Populate header
                litTradeId.Text = _tradeId.ToString();
                litStatusName.Text = _trade.StatusName;
                litUserRole.Text = _trade.UserRole;
                litStatusBadge.Text = _trade.StatusName;
             //   badgeStatus.CssClass = "badge " + _trade.StatusBadgeClass;

                // Trade summary
                litFiatAmount.Text = _trade.FiatAmount.ToString("0.00");
                litCryptoAmount.Text = _trade.CryptoAmount.ToString("0.0000");
                litCurrency.Text = _trade.CurrencyCode;
                litCurrency2.Text = _trade.CurrencyCode;
                litPrice.Text = _trade.Price.ToString("0.00");
                litPaymentMethod.Text = _trade.PaymentMethod;
                litCreatedDate.Text = _trade.CreatedDate.ToString("MMM dd, yyyy HH:mm");

                // Counterparty
                litCounterpartyName.Text = _trade.CounterpartyName;
                litCounterpartyTrades.Text = _trade.CounterpartyCompletedTrades.ToString();
                litCounterpartyAvg.Text = _trade.CounterpartyAvgCompletionMinutes?.ToString("0") ?? "N/A";

                // Terms
                if (!string.IsNullOrWhiteSpace(_trade.AdTerms))
                {
                    litAdTerms.Text = _trade.AdTerms;
                    pnlTerms.Visible = true;
                }

                // Countdown (only for buyer, status 0)
                if (_trade.IsBuyer && _trade.Status == 0 && _trade.MinutesRemaining > 0)
                {
                    pnlCountdown.Visible = true;
                }

                // Load timeline
                LoadTimeline();

                // Role-specific UI
                if (_trade.IsBuyer)
                {
                    LoadBuyerUI();
                }
                else if (_trade.IsSeller)
                {
                    LoadSellerUI();
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load trade", ex);
                ShowUnauthorized();
            }
        }

        private void LoadBuyerUI()
        {
            pnlBuyerActions.Visible = true;
            litFiatAmount2.Text = _trade.FiatAmount.ToString("0.00");
            litPaymentMethod2.Text = _trade.PaymentMethod;

            switch (_trade.Status)
            {
                case 0: // Pending
                    pnlMarkAsPaid.Visible = true;
                    pnlPaymentProof.Visible = true;
                    pnlCancelTrade.Visible = true;
                    break;
                case 1: // Paid
                    pnlBuyerWaiting.Visible = true;
                    pnlCancelTrade.Visible = true;
                    break;
                case 2: // Completed
                    pnlBuyerCompleted.Visible = true;
                    litCryptoReceived.Text = _trade.CryptoAmount.ToString("0.0000");
                    litCurrencyReceived.Text = _trade.CurrencyCode;
                    break;
                default:
                    pnlFinalState.Visible = true;
                    litFinalStatus.Text = _trade.StatusName;
                    break;
            }
        }

        private void LoadSellerUI()
        {
            pnlSellerActions.Visible = true;
            litFiatAmount3.Text = _trade.FiatAmount.ToString("0.00");

            switch (_trade.Status)
            {
                case 0: // Pending
                    pnlSellerWaitingPayment.Visible = true;
                    pnlCancelTrade.Visible = true;
                    break;
                case 1: // Paid - show proof and release button
                    pnlReleaseFunds.Visible = true;
                    pnlViewProof.Visible = true;
                    litPaymentProof.Text = !string.IsNullOrWhiteSpace(_trade.BuyerPaymentProof)
                        ? _trade.BuyerPaymentProof.Replace("\n", "<br>")
                        : "<em class='text-muted'>No proof provided</em>";
                    break;
                case 2: // Completed
                    pnlSellerCompleted.Visible = true;
                    litFiatReceived.Text = _trade.FiatAmount.ToString("0.00");
                    break;
                default:
                    pnlFinalState.Visible = true;
                    litFinalStatus.Text = _trade.StatusName;
                    break;
            }
        }

        private void LoadTimeline()
        {
            try
            {
                // Get timeline from separate result set
                var timeline = new System.Collections.Generic.List<P2PTradeTimeline>();

                using (var conn = Mexify.DataAccess.ConnectionManager.GetConnection())
                using (var cmd = new System.Data.SqlClient.SqlCommand("usp_GetP2PTradeDetails", conn))
                {
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@TradeId", _tradeId);
                    cmd.Parameters.AddWithValue("@UserId", _userId);
                    conn.Open();

                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read()) reader.Read(); // Skip first result set
                        if (reader.NextResult())
                        {
                            while (reader.Read())
                            {
                                timeline.Add(new P2PTradeTimeline
                                {
                                    StepNumber = Convert.ToInt32(reader["StepNumber"]),
                                    StepTitle = reader["StepTitle"].ToString(),
                                    StepDescription = reader["StepDescription"].ToString(),
                                    StepIcon = reader["StepIcon"].ToString(),
                                    StepDate = reader["StepDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["StepDate"]),
                                    IsCompleted = Convert.ToBoolean(reader["IsCompleted"])
                                });
                            }
                        }
                    }
                }

                rptTimeline.DataSource = timeline;
                rptTimeline.DataBind();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load timeline", ex);
            }
        }

        // ==========================================
        // ACTION HANDLERS
        // ==========================================

        protected void btnMarkAsPaid_Click(object sender, EventArgs e)
        {
            string message;
            bool success = _repo.BuyerMarkAsPaid(_tradeId, _userId, txtPaymentProof.Text, out message);

            if (success)
            {
                Logger.Info($"User {_userId} marked trade {_tradeId} as paid");
                Response.Redirect($"Trade.aspx?id={_tradeId}&success=1", false);
            }
            else
            {
                ShowError(message);
            }
        }

        protected void btnReleaseFunds_Click(object sender, EventArgs e)
        {
            string message;
            bool success = _repo.SellerReleaseFunds(_tradeId, _userId, out message);

            if (success)
            {
                Logger.Info($"User {_userId} released funds for trade {_tradeId}");
                Response.Redirect($"Trade.aspx?id={_tradeId}&success=1", false);
            }
            else
            {
                ShowError(message);
            }
        }

        protected void btnCancelTrade_Click(object sender, EventArgs e)
        {
            string message;
            bool success = _repo.CancelTrade(_tradeId, _userId, out message);

            if (success)
            {
                Logger.Info($"User {_userId} cancelled trade {_tradeId}");
                Response.Redirect($"Trade.aspx?id={_tradeId}&cancelled=1", false);
            }
            else
            {
                ShowError(message);
            }
        }

        private void ShowUnauthorized()
        {
            pnlUnauthorized.Visible = true;
            pnlTrade.Visible = false;
        }

        private void ShowError(string message)
        {
            // Could add a literal for error display
            ClientScript.RegisterStartupScript(this.GetType(), "error",
                $"alert('{message.Replace("'", "\\'")}');", true);
        }
    }
}