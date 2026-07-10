using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using Mexify.Business.Services;
using Mexify.Web.Models;
using Mexify.Utilities;

namespace Mexify.Web.User
{
    public partial class Wallet : System.Web.UI.Page
    {
        private WalletService _walletService;
        private int _userId;

        // Public properties for JavaScript access
        public decimal AvailableBalance { get; private set; }
        public decimal NetworkFee { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Authentication check
            if (!Request.IsAuthenticated || Session["UserId"] == null)
            {
                Response.Redirect(ResolveUrl("~/Web/login.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl)));
                return;
            }

            _userId = Convert.ToInt32(Session["UserId"]);
            _walletService = new WalletService();

            if (!IsPostBack)
            {

                try
                {

                }
                catch(Exception ef)
                {

                }
                SetPageMetadata();
                LoadWallets();
                LoadDepositCurrencies();
                LoadWithdrawCurrencies();
                LoadTransactions();
                HandleActionFromUrl();
            }
        }

        private void SetPageMetadata()
        {
            var master = this.Master as Mexify.Web.MasterPages.UserMaster;
            if (master != null)
            {
                master.SetPageTitle("My Wallet");
                master.SetBreadcrumb("My Wallet");
            }
        }

        private void LoadWallets()
        {
            try
            {
                var wallets = _walletService.GetUserWallets(_userId);
                decimal totalPNC = 0;

                if (wallets != null && wallets.Count > 0)
                {
                    rptWallets.DataSource = wallets;
                    rptWallets.DataBind();
                    pnlNoWallets.Visible = false;

                    // Calculate total PNC value
                    foreach (var w in wallets)
                    {
                        totalPNC += w.ValuePNC;
                    }
                }
                else
                {
                    pnlNoWallets.Visible = true;
                }

                litTotalBalance.Text = totalPNC.ToString("0.00");
                litTotalUSD.Text = (totalPNC * 0.042m).ToString("0.00"); // PNC to USD rate
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load wallets", ex);
            }
        }

        private void LoadDepositCurrencies()
        {
            try
            {
                var currencies = _walletService.GetSupportedCurrencies();
                ddlDepositCurrency.DataSource = currencies;
                ddlDepositCurrency.DataValueField = "CurrencyId";
                ddlDepositCurrency.DataTextField = "CurrencyName";
                ddlDepositCurrency.DataBind();

                // Select default or from URL
                string currencyCode = Request.QueryString["currency"];
                if (!string.IsNullOrEmpty(currencyCode))
                {
                    foreach (ListItem item in ddlDepositCurrency.Items)
                    {
                        if (item.Text.Contains(currencyCode.ToUpper()))
                        {
                            ddlDepositCurrency.SelectedValue = item.Value;
                            break;
                        }
                    }
                }

                LoadDepositAddress();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load deposit currencies", ex);
            }
        }

        private void LoadWithdrawCurrencies()
        {
            try
            {
                var currencies = _walletService.GetSupportedCurrencies();
                ddlWithdrawCurrency.DataSource = currencies;
                ddlWithdrawCurrency.DataValueField = "CurrencyId";
                ddlWithdrawCurrency.DataTextField = "CurrencyName";
                ddlWithdrawCurrency.DataBind();

                // Select default or from URL
                string currencyCode = Request.QueryString["currency"];
                if (!string.IsNullOrEmpty(currencyCode))
                {
                    foreach (ListItem item in ddlWithdrawCurrency.Items)
                    {
                        if (item.Text.Contains(currencyCode.ToUpper()))
                        {
                            ddlWithdrawCurrency.SelectedValue = item.Value;
                            break;
                        }
                    }
                }

                LoadWithdrawInfo();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load withdraw currencies", ex);
            }
        }

        private void LoadTransactions()
        {
            try
            {
                var transactions = _walletService.GetUserTransactions(_userId, 50);
                if (transactions != null && transactions.Count > 0)
                {
                    rptTransactions.DataSource = transactions;
                    rptTransactions.DataBind();
                    pnlNoTransactions.Visible = false;
                }
                else
                {
                    pnlNoTransactions.Visible = true;
                }

                // Load filter currencies
                rptFilterCurrencies.DataSource = _walletService.GetSupportedCurrencies();
                rptFilterCurrencies.DataBind();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load transactions", ex);
            }
        }

        private void HandleActionFromUrl()
        {
            string action = Request.QueryString["action"];
            if (string.IsNullOrEmpty(action)) return;

            // The JavaScript will auto-open the correct tab
        }

        protected void ddlDepositCurrency_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDepositAddress();
        }

        private void LoadDepositAddress()
        {
            try
            {
                int currencyId;
                if (!int.TryParse(ddlDepositCurrency.SelectedValue, out currencyId)) return;

                var currency = _walletService.GetCurrencyById(currencyId);
                if (currency == null) return;

                litDepositCurrencyName.Text = currency.CurrencyName;
                litDepositCurrencyName2.Text = currency.CurrencyName;
                litMinDeposit.Text = currency.MinDeposit.ToString("0.########") + " " + currency.CurrencyCode;

                // Get or generate deposit address
                string address = _walletService.GetDepositAddress(_userId, currencyId);
                litDepositAddress.Text = address;

                // Update QR code via JavaScript (will be set in Page_Load via ClientScript)
                string qrUrl = "https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=" + Server.UrlEncode(address);
                ClientScript.RegisterStartupScript(this.GetType(), "setQR",
                    "document.getElementById('depositQR').src='" + qrUrl + "';", true);
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load deposit address", ex);
                litDepositAddress.Text = "Error loading address";
            }
        }

        protected void ddlWithdrawCurrency_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadWithdrawInfo();
        }

        private void LoadWithdrawInfo()
        {
            try
            {
                int currencyId;
                if (!int.TryParse(ddlWithdrawCurrency.SelectedValue, out currencyId)) return;

                var wallet = _walletService.GetUserWallet(_userId, currencyId);
                var currency = _walletService.GetCurrencyById(currencyId);

                if (wallet != null && currency != null)
                {
                    AvailableBalance = wallet.Balance;
                    NetworkFee = currency.WithdrawalFee;

                    litAvailableBalance.Text = wallet.Balance.ToString("0.########");
                    litWithdrawCurrencyCode.Text = currency.CurrencyCode;
                    litNetworkFee.Text = currency.WithdrawalFee.ToString("0.########");
                    litFeeCurrency.Text = currency.CurrencyCode;
                    litReceiveCurrency.Text = currency.CurrencyCode;
                    litYouReceive.Text = "0.00";
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load withdraw info", ex);
            }
        }

        protected void btnWithdraw_Click(object sender, EventArgs e)
        {
            pnlWithdrawError.Visible = false;
            pnlWithdrawSuccess.Visible = false;

            try
            {
                int currencyId;
                if (!int.TryParse(ddlWithdrawCurrency.SelectedValue, out currencyId))
                {
                    ShowWithdrawError("Please select a currency.");
                    return;
                }

                string address = txtWithdrawAddress.Text.Trim();
                if (string.IsNullOrWhiteSpace(address))
                {
                    ShowWithdrawError("Please enter a destination address.");
                    return;
                }

                decimal amount;
                if (!decimal.TryParse(txtWithdrawAmount.Text, out amount) || amount <= 0)
                {
                    ShowWithdrawError("Please enter a valid amount.");
                    return;
                }

                string twoFACode = txt2FACode.Text.Trim();
                if (string.IsNullOrWhiteSpace(twoFACode) || twoFACode.Length != 6)
                {
                    ShowWithdrawError("Please enter a valid 6-digit 2FA code.");
                    return;
                }

                // Validate 2FA (simplified - in production, verify against user's 2FA secret)
                // For now, accept any 6-digit code for testing
                // TODO: Implement proper 2FA verification

                // Process withdrawal
                var result = _walletService.ProcessWithdrawal(_userId, currencyId, address, amount, twoFACode);

                if (result.Success)
                {
                    pnlWithdrawForm.Visible = false;
                    pnlWithdrawSuccess.Visible = true;
                    litWithdrawSuccess.Text = string.Format(
                        "Withdrawal of {0:0.########} {1} submitted successfully. Transaction ID: {2}",
                        amount, result.CurrencyCode, result.TransactionId);

                    // Clear form
                    txtWithdrawAddress.Text = "";
                    txtWithdrawAmount.Text = "";
                    txt2FACode.Text = "";

                    // Reload wallets
                    LoadWallets();
                }
                else
                {
                    ShowWithdrawError(result.ErrorMessage);
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Withdrawal failed", ex);
                ShowWithdrawError("An error occurred. Please try again later.");
            }
        }

        private void ShowWithdrawError(string message)
        {
            pnlWithdrawError.Visible = true;
            litWithdrawError.Text = message;
        }

        public string GetCurrencyIcon(object code)
        {
            if (code == null) return "fas fa-coins";
            string c = code.ToString().ToUpper();
            switch (c)
            {
                case "PNC": return "fas fa-coins";
                case "BTC": return "fab fa-bitcoin";
                case "ETH": return "fab fa-ethereum";
                case "USDT": return "fas fa-dollar-sign";
                default: return "fas fa-coins";
            }
        }

        public string GetTransactionTypeIcon(object type)
        {
            int t = 0;
            if (type != null && type != DBNull.Value) int.TryParse(type.ToString(), out t);
            switch (t)
            {
                case 1: return "fas fa-arrow-down text-accent";
                case 2: return "fas fa-arrow-up text-secondary";
                case 3: return "fas fa-exchange-alt text-warning";
                default: return "fas fa-circle text-muted";
            }
        }

        public string GetStatusClass(object status)
        {
            int s = 0;
            if (status != null && status != DBNull.Value) int.TryParse(status.ToString(), out s);
            switch (s)
            {
                case 1: return "status-completed";
                case 2: return "status-pending";
                case 3: return "status-failed";
                default: return "status-pending";
            }
        }
    }
}