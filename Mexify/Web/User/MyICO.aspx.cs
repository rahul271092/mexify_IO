using Mexify.Business.Services;
using Mexify.Models;
using Mexify.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Mexify.Web.User
{
    public partial class MyICO : System.Web.UI.Page
    {
        private ICOService _icoService;
        private WalletService _walletService;
        private int _userId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Web/meta-login.aspx");
                return;
            }

            _userId = Convert.ToInt32(Session["UserId"]);
            _icoService = new ICOService();
            _walletService = new WalletService();

            if (!IsPostBack)
            {
                LoadICOData();
            }
        }

        private void LoadICOData()
        {
            try
            {
                // Load active ICOs
                var icos = _icoService.GetActiveICOs();
                if (icos != null && icos.Count > 0)
                {
                    rptICOProjects.DataSource = icos;
                    rptICOProjects.DataBind();
                    pnlNoICO.Visible = false;

                    // Set first ICO as default
                    hfICOId.Value = icos[0].ICOId.ToString();
                    hfPricePerToken.Value = icos[0].PricePerToken.ToString();
                    litPricePerToken.Text = icos[0].PricePerToken.ToString("0.00");
                }
                else
                {
                    pnlNoICO.Visible = true;
                }

                // Load commission tiers
                var tiers = _icoService.GetCommissionTiers();
                if (tiers != null && tiers.Count > 0)
                {
                    var stats = _icoService.GetUserICOStats(_userId);

                    // Merge tier data with user qualification
                    var tierData = tiers.Select(t => new
                    {
                        t.Level,
                        t.CommissionPercent,
                        t.RequiredDirects,
                        t.IsActive,
                        TimesEarned = stats.LevelBreakdown.FirstOrDefault(l => l.Level == t.Level)?.TimesEarned ?? 0,
                        LevelTotal = stats.LevelBreakdown.FirstOrDefault(l => l.Level == t.Level)?.LevelTotal ?? 0,
                        CurrentDirects = stats.DirectReferrals,
                        IsQualified = stats.DirectReferrals >= t.RequiredDirects
                    }).ToList();

                    rptTiers.DataSource = tierData;
                    rptTiers.DataBind();

                    rptCommissionLevels.DataSource = tierData;
                    rptCommissionLevels.DataBind();
                }

                // Load user stats
                LoadUserStats();

                // Load user balance
                LoadUserBalance();
            }
            catch (Exception ex)
            {
                Logger.Error("ICO page load failed for user " + _userId, ex);
            }
        }

        private void LoadUserStats()
        {
            try
            {
                var stats = _icoService.GetUserICOStats(_userId);

                litMyTokens.Text = stats.TotalTokensPurchased.ToString("0.00");
                litMyInvested.Text = stats.TotalInvested.ToString("0.00");
                litMyCommission.Text = stats.TotalCommissionEarned.ToString("0.00");
                litMyReferrals.Text = stats.DirectReferrals.ToString();
                litMyPurchases.Text = stats.TotalPurchases.ToString();
                litMyDownlines.Text = stats.UniqueDownlines.ToString();

                if (stats.RecentPurchases != null && stats.RecentPurchases.Count > 0)
                {
                    rptMyPurchases.DataSource = stats.RecentPurchases;
                    rptMyPurchases.DataBind();
                }

                if (stats.RecentCommissions != null && stats.RecentCommissions.Count > 0)
                {
                    rptCommissionHistory.DataSource = stats.RecentCommissions;
                    rptCommissionHistory.DataBind();
                    pnlNoCommissions.Visible = false;
                }
                else
                {
                    pnlNoCommissions.Visible = true;
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load user ICO stats", ex);
            }
        }

        private void LoadUserBalance()
        {
            try
            {
                decimal usdtBalance = 0;
                var wallets = _walletService.GetUserWallets(_userId);

                if (wallets != null)
                {
                    var usdtWallet = wallets.FirstOrDefault(w => w.CurrencyCode == "USDT");
                    if (usdtWallet != null)
                    {
                        usdtBalance = usdtWallet.Balance;
                    }
                }

                litUserBalance.Text = usdtBalance.ToString("0.00");
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load user balance", ex);
            }
        }

        protected void btnPurchase_Click(object sender, EventArgs e)
        {
            HideMessages();

            try
            {
                decimal amount;
                if (!decimal.TryParse(txtAmount.Text, out amount) || amount <= 0)
                {
                    ShowError("Please enter a valid amount.");
                    return;
                }

                int icoId;
                if (!int.TryParse(hfICOId.Value, out icoId) || icoId == 0)
                {
                    ShowError("No active ICO found.");
                    return;
                }

                var result = _icoService.PurchaseTokens(new ICOPurchaseRequest
                {
                    UserId = _userId,
                    ICOId = icoId,
                    Amount = amount
                });

                if (result.Success)
                {
                    ShowSuccess($"Successfully purchased {result.TokensPurchased:0.00} PNC tokens! 15-level commissions distributed to your upline.");
                    txtAmount.Text = "";
                    LoadICOData();
                    LoadUserBalance();
                }
                else
                {
                    ShowError(result.ErrorMessage ?? "Failed to purchase tokens.");
                }
            }
            catch (Exception ex)
            {
                Logger.Error("ICO purchase failed for user " + _userId, ex);
                ShowError("An error occurred: " + ex.Message);
            }
        }

        // Helper methods
        public string GetDaysRemaining(object endDate)
        {
            if (endDate == null || endDate == DBNull.Value) return "0";
            DateTime end = Convert.ToDateTime(endDate);
            int days = (int)(end - DateTime.Now).TotalDays;
            return days > 0 ? days.ToString() : "0";
        }

        public string GetTxHashShort(object txHash)
        {
            if (txHash == null || string.IsNullOrEmpty(txHash.ToString())) return "—";
            string hash = txHash.ToString();
            return hash.Length > 10 ? hash.Substring(0, 10) + "..." : hash;
        }

        public string PricePerToken => hfPricePerToken.Value ?? "0.10";

        private void ShowError(string message)
        {
            pnlError.Visible = true;
            litError.Text = message;
        }

        private void ShowSuccess(string message)
        {
            pnlSuccess.Visible = true;
            litSuccess.Text = message;
        }

        private void HideMessages()
        {
            pnlError.Visible = false;
            pnlSuccess.Visible = false;
        }
    }
}