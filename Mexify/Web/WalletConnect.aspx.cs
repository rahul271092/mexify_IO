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
    public partial class WalletConnect : System.Web.UI.Page
    {
        private WalletService _walletService;
        private int _userId;

        // Properties for client-side access
        protected bool HasExistingWallet { get; private set; }
        protected string ShortWalletAddress { get; private set; } = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            _userId = GetCurrentUserId();

            //if (_userId <= 0)
            //{
            //    Response.Redirect("~/Web/MetaMaskLogin.aspx");
            //    return;
            //}

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

                if (!string.IsNullOrEmpty(wallet))
                {
                    HasExistingWallet = true;
                    ShortWalletAddress = wallet.Substring(0, 6) + "..." + wallet.Substring(wallet.Length - 4);
                    hfWalletAddress.Value = wallet;
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
                string provider = hfWalletProvider.Value?.Trim() ?? "WalletConnect";
                string chainId = hfChainId.Value?.Trim();

                // Validate wallet address format (Ethereum-style)
                if (string.IsNullOrEmpty(walletAddress) || !walletAddress.StartsWith("0x") || walletAddress.Length != 42)
                {
                    ShowAlert("Invalid wallet address format.", "danger");
                    return;
                }

                // Check if wallet is already linked to another user
                var existingUser = _walletService.GetUserIdByWalletAddress(walletAddress);
                if (existingUser > 0 && existingUser != _userId)
                {
                    ShowAlert("This wallet is already linked to another account.", "danger");
                    return;
                }

                // Save wallet
                bool success = _walletService.SaveUserWallet(_userId, walletAddress, provider, chainId);

                if (success)
                {
                    ShowAlert("Wallet connected and saved to your account successfully!", "success");
                    LoadExistingWallet();
                }
                else
                {
                    ShowAlert("Failed to save wallet. Please try again.", "danger");
                }
            }
            catch (Exception ex)
            {
                Logger.Error($"Error saving wallet for user {_userId}", ex);
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