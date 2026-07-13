using Mexify.Business.Services;
using Mexify.Utilities;
using Newtonsoft.Json;
using System;
using System.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Mexify.Web
{
    public partial class meta_login : System.Web.UI.Page
    {
        private AuthService _authService;

        protected void Page_Load(object sender, EventArgs e)
        {

            Logger.Info("Page: Meta-login.aspx");
            // Redirect if already logged in
            if (Session["UserId"] != null)
            {
                Response.Redirect("~/Web/User/Dashboard.aspx");
                return;
            }

            _authService = new AuthService();

            if (!IsPostBack)
            {
                // ✅ Force __doPostBack generation (just in case)
                ClientScript.GetPostBackEventReference(this, "");

                // Don't generate initial nonce - it will be fetched via API when user connects
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetNonce(string wallet)
        {
            try
            {
                if (string.IsNullOrEmpty(wallet))
                {
                    return JsonConvert.SerializeObject(new { success = false, message = "Wallet required" });
                }

                var authService = new AuthService();
                var nonce = authService.GetOrCreateNonce(wallet);

                return JsonConvert.SerializeObject(new
                {
                    success = true,
                    nonce = nonce,
                    message = "Nonce generated"
                });
            }
            catch (Exception ex)
            {

                Logger.Error("Get Nonce Function Error:", ex);
                return JsonConvert.SerializeObject(new
                {
                    success = false,
                    message = "Server error: " + ex.Message
                });
            }
        }

        protected void btnMetaMaskLogin_Click(object sender, EventArgs e)
        {
            HideMessages();

            string walletAddress = hfWalletAddress.Value?.Trim();
            string signature = hfSignature.Value?.Trim();
            string nonce = hfNonce.Value?.Trim();

            // ✅ Validate all required fields
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

            // ✅ Validate wallet address format (Ethereum address)
            if (!IsValidEthereumAddress(walletAddress))
            {
                ShowError("Invalid wallet address format. Please use a valid Ethereum address.");
                return;
            }

            // ✅ Validate signature format
            if (!IsValidSignature(signature))
            {
                ShowError("Invalid signature format. Please try signing again.");
                return;
            }

            try
            {
                Logger.Info("My Wallet Address:" + walletAddress + ", My Signature: " + signature + ", My Nonce:" + nonce);
                var _authService = new AuthService();
                // 1. Verify the signature and nonce on the server

                bool isNewUser = true;

                string sql = "  SELECT COUNT(*) FROM Users WHERE WalletAddress = @WalletAddress;";
                using (SqlCommand cmd = Web.Models.Connection.SqlQuery(sql))
                {
                    cmd.Parameters.AddWithValue("@WalletAddress", walletAddress);
                    int count = Convert.ToInt32(cmd.ExecuteScalar());
                    isNewUser = count == 0;

                }



                    var result = _authService.VerifyMetaMaskLogin(walletAddress, signature, nonce);
                Logger.Info($"MetaMask Login Result -> Success: {result.Success}, UserId: {result.UserId}, Message: '{result.ErrorMessage}'");

                if (result.Success)
                {
                    // 2. Create Session Variables
                    Session["UserId"] = result.UserId;
                    Session["WalletAddress"] = walletAddress;
                    Session["LoginMethod"] = "MetaMask";
                    Session["LoginTime"] = DateTime.UtcNow;
                    Session["IsWeb3Login"] = true;

                    // Fetch user details to store in session
                    var user = _authService.GetUserById(result.UserId);
                    if (user != null)
                    {
                        Session["UserName"] = (user.FirstName ?? "") + " " + (user.LastName ?? "");
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

                    // 3. Log the login activity
                    string ipAddress = GetUserIpAddress();
                    try
                    {
                        _authService.LogUserActivity(result.UserId, "METAMASK_LOGIN",
                            "MetaMask login successful from " + walletAddress, ipAddress);
                    }
                    catch (Exception logEx)
                    {
                        Logger.Error("Failed to log login activity", logEx);
                    }

                    // 4. Set authentication cookie
                    try
                    {
                        System.Web.Security.FormsAuthentication.SetAuthCookie(result.UserId.ToString(), false);
                    }
                    catch { }

                    // 5. Redirect to dashboard
                    string returnUrl = Request.QueryString["ReturnUrl"];
                    if (!string.IsNullOrEmpty(returnUrl) && returnUrl.StartsWith("~/"))
                    {
                        Response.Redirect(returnUrl);
                    }
                    else
                    {
                        Response.Redirect("~/Web/User/Dashboard.aspx",false);
                    }
                }
                else
                {
                    // ✅ FIXED: Handle specific error cases using IndexOf
                    string errorMsg = result.ErrorMessage ?? "Login failed";

                    if (errorMsg.IndexOf("not registered", StringComparison.OrdinalIgnoreCase) >= 0 ||
                        errorMsg.IndexOf("no account", StringComparison.OrdinalIgnoreCase) >= 0 ||
                        errorMsg.IndexOf("not found", StringComparison.OrdinalIgnoreCase) >= 0)
                    {
                        ShowError("This wallet is not registered. Please register first or contact support.");
                    }
                    else if (errorMsg.IndexOf("nonce", StringComparison.OrdinalIgnoreCase) >= 0 ||
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
            }
            catch (Exception ex)
            {
                Logger.Error("MetaMask login error for wallet: " + walletAddress, ex);
                Logger.Info("Exception:" + ex.ToString());
                ShowError("An error occurred during login. Please try again later.");
            }
        }

        //protected void btnMetaMaskLogin_Click(object sender, EventArgs e)
        //{
        //    HideMessages();

        //    string walletAddress = hfWalletAddress.Value?.Trim();
        //    string signature = hfSignature.Value?.Trim();
        //    string nonce = hfNonce.Value?.Trim();

        //    // ✅ Validate all required fields
        //    if (string.IsNullOrEmpty(walletAddress))
        //    {
        //        ShowError("Wallet address is missing. Please connect your MetaMask wallet.");
        //        return;
        //    }

        //    if (string.IsNullOrEmpty(signature))
        //    {
        //        ShowError("Signature is missing. Please sign the message in MetaMask.");
        //        return;
        //    }

        //    if (string.IsNullOrEmpty(nonce))
        //    {
        //        ShowError("Nonce is missing. Please refresh the page and try again.");
        //        return;
        //    }

        //    // ✅ Validate wallet address format (Ethereum address)
        //    if (!IsValidEthereumAddress(walletAddress))
        //    {
        //        ShowError("Invalid wallet address format. Please use a valid Ethereum address.");
        //        return;
        //    }

        //    // ✅ Validate signature format
        //    if (!IsValidSignature(signature))
        //    {
        //        ShowError("Invalid signature format. Please try signing again.");
        //        return;
        //    }

        //    try
        //    {
        //        // 1. Verify the signature and nonce on the server
        //        var result = _authService.VerifyMetaMaskLogin(walletAddress, signature, nonce);

        //        if (result.Success)
        //        {
        //            // 2. Create Session Variables
        //            Session["UserId"] = result.UserId;
        //            Session["WalletAddress"] = walletAddress;
        //            Session["LoginMethod"] = "MetaMask";
        //            Session["LoginTime"] = DateTime.UtcNow;
        //            Session["IsWeb3Login"] = true;

        //            // Fetch user details to store in session
        //            var user = _authService.GetUserById(result.UserId);
        //            if (user != null)
        //            {
        //                Session["UserName"] = (user.FirstName ?? "") + " " + (user.LastName ?? "");
        //                Session["UserEmail"] = user.Email ?? "";
        //                Session["UserPhoto"] = user.PhotoUrl ?? "";
        //                Session["UserTier"] = user.Tier ?? "Standard";
        //                Session["IsAdmin"] = user.IsAdmin;
        //            }
        //            else
        //            {
        //                Session["UserName"] = "Web3 User";
        //                Session["UserEmail"] = "";
        //                Session["UserPhoto"] = "";
        //                Session["UserTier"] = "Standard";
        //                Session["IsAdmin"] = false;
        //            }

        //            // 3. Log the login activity
        //            string ipAddress = GetUserIpAddress();
        //            try
        //            {
        //                _authService.LogUserActivity(result.UserId, "METAMASK_LOGIN",
        //                    "MetaMask login successful from " + walletAddress, ipAddress);
        //            }
        //            catch (Exception logEx)
        //            {
        //                // Don't fail login if logging fails
        //                Logger.Error("Failed to log login activity", logEx);
        //            }

        //            // 4. Set authentication cookie (optional)
        //            try
        //            {
        //                System.Web.Security.FormsAuthentication.SetAuthCookie(result.UserId.ToString(), false);
        //            }
        //            catch { }

        //            // 5. Redirect to dashboard
        //            string returnUrl = Request.QueryString["ReturnUrl"];
        //            if (!string.IsNullOrEmpty(returnUrl) && returnUrl.StartsWith("~/"))
        //            {
        //                Response.Redirect(returnUrl);
        //            }
        //            else
        //            {
        //                Response.Redirect("~/Web/User/Dashboard.aspx");
        //            }
        //        }
        //        else
        //        {
        //            // ✅ UNCOMMENTED: Handle specific error cases
        //            string errorMsg = result.ErrorMessage ?? "Login failed";

        //            if (errorMsg.Contains("not registered", StringComparison.OrdinalIgnoreCase) ||
        //                errorMsg.Contains("No account", StringComparison.OrdinalIgnoreCase) ||
        //                errorMsg.Contains("not found", StringComparison.OrdinalIgnoreCase))
        //            {
        //                ShowError("This wallet is not registered. Please register first or contact support.");
        //            }
        //            else if (errorMsg.Contains("nonce", StringComparison.OrdinalIgnoreCase) ||
        //                     errorMsg.Contains("expired", StringComparison.OrdinalIgnoreCase))
        //            {
        //                ShowError("Your session has expired. Please refresh the page and try again.");
        //            }
        //            else if (errorMsg.Contains("signature", StringComparison.OrdinalIgnoreCase))
        //            {
        //                ShowError("Signature verification failed. Please try signing again.");
        //            }
        //            else
        //            {
        //                ShowError(errorMsg);
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Logger.Error("MetaMask login error for wallet: " + walletAddress, ex);
        //        ShowError("An error occurred during login. Please try again later.");
        //    }
        //}

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            // Traditional email/password login (if needed)
            HideMessages();
            ShowError("Please use MetaMask to login.");
        }

        // =========================================
        // VALIDATION HELPERS
        // =========================================

        /// <summary>
        /// Validates Ethereum wallet address format
        /// </summary>
        private bool IsValidEthereumAddress(string address)
        {
            if (string.IsNullOrEmpty(address)) return false;

            // Ethereum address: 0x followed by 40 hex characters
            string pattern = @"^0x[a-fA-F0-9]{40}$";
            return Regex.IsMatch(address, pattern);
        }

        /// <summary>
        /// Validates signature format
        /// </summary>
        private bool IsValidSignature(string signature)
        {
            if (string.IsNullOrEmpty(signature)) return false;

            // Signature: 0x followed by 130 hex characters (65 bytes)
            string pattern = @"^0x[a-fA-F0-9]{130}$";
            return Regex.IsMatch(signature, pattern);
        }

        /// <summary>
        /// Gets user's IP address
        /// </summary>
        private string GetUserIpAddress()
        {
            try
            {
                string ip = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
                if (string.IsNullOrEmpty(ip))
                    ip = Request.ServerVariables["REMOTE_ADDR"];
                return ip ?? "unknown";
            }
            catch
            {
                return "unknown";
            }
        }

        // =========================================
        // MESSAGE HELPERS
        // =========================================

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