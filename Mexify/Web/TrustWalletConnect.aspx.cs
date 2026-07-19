using Mexify.Business.Services;
using Mexify.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Mexify.Web
{
    public partial class TrustWalletConnect : System.Web.UI.Page
    {
        private WalletService _walletService;
        private int _userId;

        protected bool HasExistingWallet { get; private set; }
        protected string ExistingWalletAddress { get; private set; } = "";
        protected string ExistingConnectionMethod { get; private set; } = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            _userId = GetCurrentUserId();

            if (_userId <= 0)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            _walletService = new WalletService();

            if (!IsPostBack)
            {
                LoadExistingWallet();
            }
        }

        private void LoadExistingWallet()
        {
            try
            {
                var wallet = _walletService.GetUserWalletAddress(_userId);
                var provider = _walletService.GetUserWalletProvider(_userId);

                if (!string.IsNullOrEmpty(wallet))
                {
                    HasExistingWallet = true;
                    ExistingWalletAddress = wallet.Substring(0, 8) + "..." + wallet.Substring(wallet.Length - 6);
                    ExistingConnectionMethod = provider ?? "TrustWallet";
                    hfWalletAddress.Value = wallet;
                    hfWalletProvider.Value = provider ?? "TrustWallet";
                }
                else
                {
                    HasExistingWallet = false;
                }
            }
            catch (Exception ex)
            {
                Logger.Error($"Error loading wallet for user {_userId}", ex);
            }
        }

        protected void btnSaveToServer_Click(object sender, EventArgs e)
        {
            try
            {
                string walletAddress = hfWalletAddress.Value?.Trim();
                string provider = "TrustWallet";
                string chainId = hfChainId.Value?.Trim();

                if (string.IsNullOrEmpty(walletAddress) ||
                    !walletAddress.StartsWith("0x", StringComparison.OrdinalIgnoreCase) ||
                    walletAddress.Length != 42)
                {
                    ShowAlert("Invalid wallet address format.", "danger");
                    return;
                }

                var existingUser = _walletService.GetUserIdByWalletAddress(walletAddress);
                if (existingUser > 0 && existingUser != _userId)
                {
                    ShowAlert("This Trust Wallet is already linked to another account.", "danger");
                    return;
                }

                bool success = _walletService.SaveUserWallet(_userId, walletAddress, provider, chainId);

                if (success)
                {
                    ShowAlert("Trust Wallet connected and saved successfully!", "success");
                    LoadExistingWallet();
                }
                else
                {
                    ShowAlert("Failed to save wallet. Please try again.", "danger");
                }
            }
            catch (Exception ex)
            {
                Logger.Error($"Error saving Trust Wallet for user {_userId}", ex);
                ShowAlert("An error occurred. Please try again.", "danger");
            }
        }

        private int GetCurrentUserId()
        {
            if (Session["UserId"] != null)
            {
                return Convert.ToInt32(Session["UserId"]);
            }
            return 0;
        }

        private void ShowAlert(string message, string type)
        {
            pnlAlert.Visible = true;
            pnlAlert.CssClass = $"alert-custom alert-{type}";
            lblAlertMessage.Text = $"<i class='fas fa-info-circle me-2'></i>{message}";
        }

    }
}