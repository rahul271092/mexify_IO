using Mexify.Business.Services;
using Mexify.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Mexify.Web.User
{
    public partial class Transfer : System.Web.UI.Page
    {
        private int _userId;
        private TransferService _service;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Web/MetaMaskLogin.aspx", false);
                return;
            }

            _userId = Convert.ToInt32(Session["UserId"]);
            _service = new TransferService();

            if (!IsPostBack)
            {
                LoadCurrencies();
                LoadMyAddresses();
            }
        }

        private void LoadCurrencies()
        {
            try
            {
                var addresses = _service.GetUserWalletAddresses(_userId);
                ddlCurrency.DataSource = addresses;
                ddlCurrency.DataValueField = "CurrencyCode";
                ddlCurrency.DataTextField = "CurrencyCode";
                ddlCurrency.DataBind();
                ddlCurrency.Items.Insert(0, new ListItem("-- Select Currency --", ""));

                UpdateBalanceDisplay();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load currencies", ex);
            }
        }

        private void LoadMyAddresses()
        {
            try
            {
                var addresses = _service.GetUserWalletAddresses(_userId);
                rptMyAddresses.DataSource = addresses;
                rptMyAddresses.DataBind();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load addresses", ex);
            }
        }

        protected void ddlCurrency_SelectedIndexChanged(object sender, EventArgs e)
        {
            UpdateBalanceDisplay();
        }

        private void UpdateBalanceDisplay()
        {
            string currency = ddlCurrency.SelectedValue;
            litCurrencyCode.Text = string.IsNullOrEmpty(currency) ? "USDT" : currency;

            if (!string.IsNullOrEmpty(currency))
            {
                try
                {
                    var addresses = _service.GetUserWalletAddresses(_userId);
                    var addr = addresses.FirstOrDefault(a => a.CurrencyCode == currency);
                    litAvailableBalance.Text = addr?.Balance.ToString("0.00") ?? "0.00";
                }
                catch { litAvailableBalance.Text = "0.00"; }
            }
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            pnlError.Visible = false;
            pnlSuccess.Visible = false;

            string currency = ddlCurrency.SelectedValue;
            string toAddress = txtRecipientAddress.Text.Trim().ToUpper();
            decimal amount;
            if (!decimal.TryParse(txtAmount.Text, out amount) || amount <= 0)
            {
                ShowError("Please enter a valid amount.");
                return;
            }

            if (string.IsNullOrWhiteSpace(toAddress))
            {
                ShowError("Please enter a recipient address.");
                return;
            }

            try
            {
                var result = _service.SendTransfer(_userId, toAddress, currency, amount, txtMemo.Text);

                if (result.Success)
                {
                    pnlForm.Visible = false;
                    pnlSuccess.Visible = true;
                    litSuccessMessage.Text = result.Message;
                    Logger.Info($"User {_userId} sent {amount} {currency} to {toAddress}");
                }
                else
                {
                    ShowError(result.Message);
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Transfer failed", ex);
                ShowError("An error occurred. Please try again.");
            }
        }

        private void ShowError(string message)
        {
            litErrorMessage.Text = message;
            pnlError.Visible = true;
        }

    }
}