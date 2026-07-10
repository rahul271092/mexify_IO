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
    public partial class meta_login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] != null)
            {
                Response.Redirect("~/Web/User/Dashboard.aspx");
            }
        }

        protected void btnMetaMaskLogin_Click(object sender, EventArgs e)
        {
            string walletAddress = hfWalletAddress.Value;
            string signature = hfSignature.Value;
            string nonce = hfNonce.Value;

            // Validate that JavaScript successfully captured the data
            if (string.IsNullOrEmpty(walletAddress) || string.IsNullOrEmpty(signature) || string.IsNullOrEmpty(nonce))
            {
                ShowError("Missing login data. Please connect your wallet again.");
                return;
            }

            try
            {
                var authService = new AuthService();

                // 1. Verify the signature and nonce on the server
                var result = authService.VerifyMetaMaskLogin(walletAddress, signature, nonce);

                if (result.Success)
                {
                    // 2. Create Session Variables
                    Session["UserId"] = result.UserId;
                    Session["WalletAddress"] = walletAddress;
                    Session["LoginMethod"] = "MetaMask";

                    // Fetch user details to store in session
                    var user = authService.GetUserById(result.UserId);
                    if (user != null)
                    {
                        Session["UserName"] = user.FirstName + " " + user.LastName;
                        Session["UserEmail"] = user.Email;
                        Session["UserPhoto"] = user.PhotoUrl;
                        Session["IsAdmin"] = user.IsAdmin; // If you have an admin flag
                    }

                    // 3. Log the login activity
                    string ipAddress = Request.ServerVariables["REMOTE_ADDR"];
                    authService.LogUserActivity(result.UserId, "METAMASK_LOGIN",
                        "MetaMask login successful from " + walletAddress, ipAddress);

                    // ✅ 4. REDIRECT TO USER DASHBOARD
                    Response.Redirect("~/Web/User/Dashboard.aspx");
                }
                else
                {
                    // Handle specific error cases
                    if (result.ErrorMessage.Contains("not registered") || result.ErrorMessage.Contains("No account"))
                    {
                        ShowError("This wallet is not registered. Please register first.");
                        // Optional: Redirect to register page with wallet pre-filled
                        // Response.Redirect("~/register.aspx?wallet=" + Server.UrlEncode(walletAddress));
                    }
                    else
                    {
                        ShowError(result.ErrorMessage);
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Error("MetaMask login error", ex);
                ShowError("An error occurred during login. Please try again.");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {

        }


        private void ShowError(string message)
        {
            pnlError.Visible = true;
            litError.Text = message;
        }
    }
}