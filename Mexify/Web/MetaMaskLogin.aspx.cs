using Mexify.Business.Services;
using Mexify.Utilities;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Mexify.Web
{
    public partial class MetaMaskLogin : System.Web.UI.Page
    {
        private AuthService _authService;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] != null)
            {
                Response.Redirect("~/Web/User/Dashboard.aspx");
                return;
            }

            _authService = new AuthService();

            if (!IsPostBack)
            {
                ClientScript.GetPostBackEventReference(this, "");

                // Pre-fill referral code from URL if provided
                string urlReferral = Request.QueryString["ref"];
                if (!string.IsNullOrEmpty(urlReferral))
                {
                    // Will be set via JavaScript
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "setReferral",
                        $"document.getElementById('txtReferralCode').value = '{Server.HtmlEncode(urlReferral)}';", true);
                }
            }
        }

        /// <summary>
        /// WebMethod called by JavaScript to get a nonce
        /// </summary>
        [WebMethod]
        public static string GetNonce(string wallet)
        {
            try
            {
                if (string.IsNullOrEmpty(wallet))
                    return JsonConvert.SerializeObject(new { success = false, message = "Wallet required" });

                var authService = new AuthService();
                var nonce = authService.GetOrCreateNonce(wallet);

                return JsonConvert.SerializeObject(new { success = true, nonce = nonce });
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new { success = false, message = ex.Message });
            }
        }

        /// <summary>
        /// Handles the server-side postback after MetaMask signature
        /// </summary>
        protected void btnMetaMaskLogin_Click(object sender, EventArgs e)
        {
            HideMessages();

            string walletAddress = hfWalletAddress.Value?.Trim();
            string signature = hfSignature.Value?.Trim();
            string nonce = hfNonce.Value?.Trim();
            string referralCode = hfReferralCode.Value?.Trim();

            // Validate required fields
            if (string.IsNullOrEmpty(walletAddress))
            {
                ShowError("Wallet address is missing. Please connect your MetaMask wallet.");
                return;
            }

            if (string.IsNullOrEmpty(signature))
            {
                ShowError("Signature is missing. Please sign the message in MetaMask.");
                return;
            }

            if (string.IsNullOrEmpty(nonce))
            {
                ShowError("Nonce is missing. Please refresh the page and try again.");
                return;
            }

            if (!IsValidEthereumAddress(walletAddress))
            {
                ShowError("Invalid wallet address format.");
                return;
            }

            try
            {
                // =========================================
                // ATTEMPT 1: LOGIN (Existing User)
                // =========================================
                var loginResult = _authService.VerifyMetaMaskLogin(walletAddress, signature, nonce);

                if (loginResult.Success)
                {
                    // User exists - Log them in
                    SetUserSession(loginResult.UserId, walletAddress);
                    RedirectAfterLogin();
                    return;
                }

                // =========================================
                // ATTEMPT 2: AUTO-REGISTER (New User)
                // =========================================
                // If the error is "not registered", auto-register the user
                string errorMsg = loginResult.ErrorMessage ?? "";

                if (errorMsg.IndexOf("not registered", StringComparison.OrdinalIgnoreCase) >= 0 ||
                    errorMsg.IndexOf("no account", StringComparison.OrdinalIgnoreCase) >= 0 ||
                    errorMsg.IndexOf("not found", StringComparison.OrdinalIgnoreCase) >= 0)
                {
                    Logger.Info($"Auto-registering new Web3 user: {walletAddress}");

                    var registerResult = _authService.RegisterWithWallet(
                        walletAddress, signature, nonce, referralCode);

                    if (registerResult.Success)
                    {
                        Logger.Info($"Auto-registered User ID: {registerResult.UserId}");
                        SetUserSession(registerResult.UserId, walletAddress);
                        RedirectAfterLogin();
                        return;
                    }
                    else
                    {
                        ShowError("Registration failed: " + registerResult.ErrorMessage);
                        return;
                    }
                }

                // =========================================
                // OTHER ERRORS (Signature failure, expired nonce, etc.)
                // =========================================
                if (errorMsg.IndexOf("nonce", StringComparison.OrdinalIgnoreCase) >= 0 ||
                    errorMsg.IndexOf("expired", StringComparison.OrdinalIgnoreCase) >= 0)
                {
                    ShowError("Your session has expired. Please refresh the page and try again.");
                }
                else if (errorMsg.IndexOf("signature", StringComparison.OrdinalIgnoreCase) >= 0)
                {
                    ShowError("Signature verification failed. Please try signing again.");
                }
                else
                {
                    ShowError(errorMsg);
                }
            }
            catch (Exception ex)
            {
                Logger.Error("MetaMask login/register error for wallet: " + walletAddress, ex);
                ShowError("An error occurred. Please try again later.");
            }
        }

        /// <summary>
        /// Sets all session variables for the logged-in user
        /// </summary>
        private void SetUserSession(int userId, string walletAddress)
        {
            Session["UserId"] = userId;
            Session["WalletAddress"] = walletAddress;
            Session["LoginMethod"] = "MetaMask";
            Session["LoginTime"] = DateTime.UtcNow;
            Session["IsWeb3Login"] = true;

            var user = _authService.GetUserById(userId);
            if (user != null)
            {
                Session["UserName"] = (user.FirstName ?? "Web3") + " " + (user.LastName ?? "User");
                Session["UserEmail"] = user.Email ?? "";
                Session["UserPhoto"] = user.PhotoUrl ?? "";
                Session["UserTier"] = user.Tier ?? "Standard";
                Session["IsAdmin"] = user.IsAdmin;
            }
            else
            {
                Session["UserName"] = "Web3 User";
                Session["UserEmail"] = "";
                Session["UserPhoto"] = "";
                Session["UserTier"] = "Standard";
                Session["IsAdmin"] = false;
            }

            // Log the login activity
            try
            {
                string ipAddress = GetUserIpAddress();
                _authService.LogUserActivity(userId, "METAMASK_LOGIN",
                    "MetaMask login successful from " + walletAddress, ipAddress);
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to log login activity", ex);
            }

            // Set auth cookie
            try
            {
                System.Web.Security.FormsAuthentication.SetAuthCookie(userId.ToString(), false);
            }
            catch { }
        }

        /// <summary>
        /// Redirects user to dashboard or return URL
        /// </summary>
        private void RedirectAfterLogin()
        {
            string returnUrl = Request.QueryString["ReturnUrl"];
            if (!string.IsNullOrEmpty(returnUrl) && returnUrl.StartsWith("~/"))
                Response.Redirect(returnUrl);
            else
                Response.Redirect("~/Web/User/Dashboard.aspx");
        }

        // =========================================
        // HELPERS
        // =========================================

        private bool IsValidEthereumAddress(string address)
        {
            if (string.IsNullOrEmpty(address)) return false;
            return Regex.IsMatch(address, @"^0x[a-fA-F0-9]{40}$");
        }

        private string GetUserIpAddress()
        {
            try
            {
                string ip = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
                if (string.IsNullOrEmpty(ip)) ip = Request.ServerVariables["REMOTE_ADDR"];
                return ip ?? "unknown";
            }
            catch { return "unknown"; }
        }

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