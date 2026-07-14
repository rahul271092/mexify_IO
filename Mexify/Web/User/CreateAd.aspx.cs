using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Mexify.DataAccess;
using Mexify.Utilities;
using Mexify.Web.Models;
namespace Mexify.Web.User
{
    public partial class CreateAd : System.Web.UI.Page
    {
        private int _userId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Web/login.aspx", false);
                return;
            }

            _userId = Convert.ToInt32(Session["UserId"]);

            if (!IsPostBack)
            {
                LoadUserBalance();
                SetPreviewMerchant();
            }
        }

        /// <summary>
        /// Loads the user's balance for the selected cryptocurrency
        /// </summary>
        private void LoadUserBalance()
        {
            try
            {
                string currency = ddlCryptoCurrency.SelectedValue;
                decimal balance = GetUserBalance(_userId, currency);

                litAvailableBalance.Text = balance.ToString("0.00000000");
                litBalanceCurrency.Text = currency;

                // Only show balance panel for SELL ads
                UpdateBalanceVisibility();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load user balance", ex);
            }
        }

        /// <summary>
        /// Gets user's balance for a specific currency
        /// </summary>
        private decimal GetUserBalance(int userId, string currencyCode)
        {
            try
            {
                using (SqlCommand cmd = Connection.SqlQuery(@"
                    SELECT ISNULL(w.Balance, 0) 
                    FROM Wallets w
                    INNER JOIN Currencies c ON w.CurrencyId = c.CurrencyId
                    WHERE w.UserId = @UserId AND c.CurrencyCode = @CurrencyCode"))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@CurrencyCode", currencyCode);

                    object result = cmd.ExecuteScalar();
                    return result != null && result != DBNull.Value ? Convert.ToDecimal(result) : 0;
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get user balance", ex);
                return 0;
            }
            finally
            {
                Connection.CloseConnection();
            }
        }

        /// <summary>
        /// Shows/hides balance panel based on ad type
        /// </summary>
        private void UpdateBalanceVisibility()
        {
            string adType = hfAdType.Value ?? "BUY";
            pnlBalanceDisplay.Visible = (adType == "SELL");
        }

        /// <summary>
        /// Sets the merchant name in the preview
        /// </summary>
        private void SetPreviewMerchant()
        {
            try
            {
                string userName = Session["UserName"]?.ToString() ?? "You";
                litPreviewMerchant.Text = userName.Split(' ')[0]; // First name only
            }
            catch
            {
                litPreviewMerchant.Text = "You";
            }
        }

        /// <summary>
        /// Handles crypto currency dropdown change
        /// </summary>
        protected void ddlCryptoCurrency_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadUserBalance();
        }

        /// <summary>
        /// Main submit handler - creates the P2P ad
        /// </summary>
        protected void btnCreateAd_Click(object sender, EventArgs e)
        {
            pnlError.Visible = false;

            try
            {
                // Gather form data
                string adType = hfAdType.Value ?? "BUY";
                string cryptoCurrency = ddlCryptoCurrency.SelectedValue;
                string fiatCurrency = ddlFiatCurrency.SelectedValue;
                string paymentMethods = hfPaymentMethods.Value;
                string terms = txtTerms.Text?.Trim();

                // Parse numeric values
                decimal price;
                if (!decimal.TryParse(txtPrice.Text, out  price) || price <= 0)
                {
                    ShowError("Please enter a valid price greater than zero.");
                    return;
                }
                decimal minLimit;
                if (!decimal.TryParse(txtMinLimit.Text, out  minLimit) || minLimit <= 0)
                {
                    ShowError("Please enter a valid minimum limit.");
                    return;
                }
                decimal maxLimit;
                if (!decimal.TryParse(txtMaxLimit.Text, out  maxLimit) || maxLimit <= 0)
                {
                    ShowError("Please enter a valid maximum limit.");
                    return;
                }

                // Validate min < max
                if (minLimit >= maxLimit)
                {
                    ShowError("Minimum limit must be less than maximum limit.");
                    return;
                }

                // Validate payment methods
                if (string.IsNullOrWhiteSpace(paymentMethods))
                {
                    ShowError("Please select at least one payment method.");
                    return;
                }

                // For SELL ads, verify user has enough balance
                if (adType == "SELL")
                {
                    decimal balance = GetUserBalance(_userId, cryptoCurrency);
                    decimal cryptoRequired = maxLimit / price;

                    if (balance < cryptoRequired)
                    {
                        ShowError($"Insufficient balance. You need at least {cryptoRequired:0.0000} {cryptoCurrency} to cover the maximum limit, but you only have {balance:0.0000} {cryptoCurrency}.");
                        return;
                    }
                }

                // Execute stored procedure
                long adId;
                bool success;
                string message;

                using (SqlCommand cmd =  Connection.SqlQuery("EXEC mexify_user.usp_CreateP2PAd @UserId, @AdType, @CurrencyCode, @FiatCurrency, @Price, @MinLimit, @MaxLimit, @PaymentMethods, @Terms, @AdId OUT, @Success OUT, @Message OUT"))
                {
                    cmd.Parameters.AddWithValue("@UserId", _userId);
                    cmd.Parameters.AddWithValue("@AdType", adType);
                    cmd.Parameters.AddWithValue("@CurrencyCode", cryptoCurrency);
                    cmd.Parameters.AddWithValue("@FiatCurrency", fiatCurrency);
                    cmd.Parameters.AddWithValue("@Price", price);
                    cmd.Parameters.AddWithValue("@MinLimit", minLimit);
                    cmd.Parameters.AddWithValue("@MaxLimit", maxLimit);
                    cmd.Parameters.AddWithValue("@PaymentMethods", paymentMethods);
                    cmd.Parameters.AddWithValue("@Terms", (object)terms ?? DBNull.Value);

                    var outAdId = new SqlParameter("@AdId", SqlDbType.BigInt) { Direction = ParameterDirection.Output };
                    var outSuccess = new SqlParameter("@Success", SqlDbType.Bit) { Direction = ParameterDirection.Output };
                    var outMessage = new SqlParameter("@Message", SqlDbType.NVarChar, 500) { Direction = ParameterDirection.Output };
                    cmd.Parameters.AddRange(new[] { outAdId, outSuccess, outMessage });

                    cmd.ExecuteNonQuery();

                    adId = outAdId.Value != DBNull.Value ? Convert.ToInt64(outAdId.Value) : 0;
                    success = outSuccess.Value != DBNull.Value && Convert.ToBoolean(outSuccess.Value);
                    message = outMessage.Value != DBNull.Value ? outMessage.Value.ToString() : "";
                }

                if (success)
                {
                    Logger.Info($"User {_userId} created P2P ad #{adId} ({adType} {cryptoCurrency}/{fiatCurrency})");
                    pnlForm.Visible = false;
                    pnlSuccess.Visible = true;
                }
                else
                {
                    ShowError(message);
                }
            }
            catch (SqlException sqlEx)
            {
                Logger.Error("SQL error creating P2P ad", sqlEx);
                ShowError("Database error: " + sqlEx.Message);
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to create P2P ad", ex);
                ShowError("An error occurred: " + ex.Message);
            }
            finally
            {
                Connection.CloseConnection();
            }
        }

        /// <summary>
        /// Displays an error message to the user
        /// </summary>
        private void ShowError(string message)
        {
            litErrorMessage.Text = message;
            pnlError.Visible = true;

            // Scroll to error
            ClientScript.RegisterStartupScript(this.GetType(), "scrollToError",
                "window.scrollTo({ top: document.getElementById('" + pnlError.ClientID + "').offsetTop - 100, behavior: 'smooth' });", true);
        }
    }
}