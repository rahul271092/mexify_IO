using Mexify.Business.Services;
using Mexify.Models;
using Mexify.Utilities;
using System;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Mexify.Web
{
    public partial class login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.IsAuthenticated && Session["UserId"] != null)
            {
                Response.Redirect(ResolveUrl("~/Web/User/Dashboard.aspx"));
                return;
            }

            if (!IsPostBack)
            {
                if (Request.QueryString["registered"] == "1")
                    ShowSuccess("Account created successfully! Please login.");
                else if (Request.QueryString["reset"] == "1")
                    ShowSuccess("Password reset successful! Please login with your new password.");
                else if (Request.QueryString["logout"] == "1")
                    ShowSuccess("You have been successfully logged out.");
            }
        }



        protected void btnLogin_Click(object sender, EventArgs e)
        {
            HideAllMessages();

            try
            {
                string email = txtEmail.Text.Trim();
                string password = txtPassword.Text;
                string ipAddress = GetUserIpAddress();

                if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
                {
                    ShowError("Please enter both email and password.");
                    return;
                }

                var authService = new AuthService();
                var user = authService.ValidateLogin(email, password, ipAddress);

                if (user == null)
                {
                    ShowError("Invalid email or password. Please try again.");
                    return;
                }

                if (!user.IsEmailVerified)
                {
                    ShowWarning("Please verify your email address before logging in.");
                    return;
                }

                if (user.Status != 1)
                {
                    string statusMessage = user.Status == 2
                        ? "Your account has been suspended."
                        : user.Status == 3 ? "Your account has been banned."
                        : "Your account is not active.";
                    ShowError(statusMessage);
                    return;
                }

                // ✅ FIX: Skip wallet loading if it causes errors
                decimal totalBalance = 0;
                decimal pncBalance = 0;
                try
                {
                    var walletService = new WalletService();
                    var allWallets = walletService.GetUserWallets(user.UserId);

                    if (allWallets != null && allWallets.Count > 0)
                    {
                        foreach (var wallet in allWallets)
                        {
                            totalBalance += wallet.Balance;
                            if (wallet.CurrencyCode == "PNC" || wallet.CurrencyId == 1)
                            {
                                pncBalance = wallet.Balance;
                            }
                        }
                    }
                }
                catch (Exception walletEx)
                {
                    // Log but don't fail login
                    Logger.Error("Wallet load failed: " + walletEx.Message);
                }

                FormsAuthentication.SetAuthCookie(user.UserId.ToString(), chkRemember.Checked);

                Session["UserId"] = user.UserId;
                Session["UserName"] = (user.FirstName ?? "") + " " + (user.LastName ?? "");
                Session["Email"] = user.Email ?? "";
                Session["UserTier"] = user.Tier ?? "Standard";
                Session["UserPhoto"] = user.PhotoUrl ?? "";
                Session["TotalBalance"] = totalBalance;
                Session["PNCBalance"] = pncBalance;
                Session["LoginTime"] = DateTime.UtcNow;
         //       Session["IsAdmin"] = user.IsAdmin ?? false;

                Logger.Info("User " + user.UserId + " logged in");

                string returnUrl = Request.QueryString["ReturnUrl"];
                if (!string.IsNullOrEmpty(returnUrl) && returnUrl.StartsWith("/"))
                    Response.Redirect(returnUrl, false);
                else
                    Response.Redirect(ResolveUrl("~/Web/User/Dashboard.aspx"), false);

                Context.ApplicationInstance.CompleteRequest();
            }
            catch (System.Data.SqlClient.SqlException sqlEx)
            {
                // ✅ SHOW EXACT SQL ERROR
                ShowError("SQL ERROR: " + sqlEx.Message + "<br><br>Procedure: " + sqlEx.Procedure + "<br>Line: " + sqlEx.LineNumber);
                Logger.Error("SQL Error during login", sqlEx);
            }
            catch (Exception ex)
            {
                ShowError("ERROR: " + ex.Message);
                Logger.Error("Login error", ex);
            }
        }

        // protected void btnLogin_Click(object sender, EventArgs e)
        // {
        //     // Validate the form
        //     if (Page.IsValid == false)
        //     {
        //         Page.Validate();
        //         if (!Page.IsValid) return;
        //     }

        //     HideAllMessages();

        //     try
        //     {
        //         string email = txtEmail.Text.Trim();
        //         string password = txtPassword.Text;
        //         string ipAddress = GetUserIpAddress();

        //         if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
        //         {
        //             ShowError("Please enter both email and password.");
        //             return;
        //         }

        //         var authService = new AuthService();

        //         // ✅ FIX: Call ValidateLogin with correct parameters
        //         var user = authService.ValidateLogin(email, password, ipAddress);

        //         if (user == null)
        //         {
        //             ShowError("Invalid email or password. Please try again.");
        //             return;
        //         }

        //         // ✅ FIX: Safe check for email verification
        //         if (user.IsEmailVerified == false)
        //         {
        //             ShowWarning("Please verify your email address before logging in.");
        //             return;
        //         }

        //         // ✅ FIX: Safe check for account status
        //         if (user.Status != 1)
        //         {
        //             string statusMessage = user.Status == 2
        //                 ? "Your account has been suspended."
        //                 : user.Status == 3 ? "Your account has been banned."
        //                 : "Your account is not active.";
        //             ShowError(statusMessage);
        //             return;
        //         }

        //         // ✅ FIX: Get wallets with proper error handling
        //         decimal totalBalance = 0;
        //         decimal pncBalance = 0;
        //         try
        //         {
        //             var walletService = new WalletService();
        //             var allWallets = walletService.GetUserWallets(user.UserId);

        //             if (allWallets != null && allWallets.Count > 0)
        //             {
        //                 foreach (var wallet in allWallets)
        //                 {
        //                     if (wallet != null)
        //                     {
        //                         totalBalance += wallet.Balance;

        //                         if (wallet.CurrencyCode == "PNC" || wallet.CurrencyId == 1)
        //                         {
        //                             pncBalance = wallet.Balance;
        //                         }
        //                     }
        //                 }
        //             }

        //             Logger.Info("User " + user.UserId + " has " + (allWallets?.Count ?? 0) + " wallets, total balance: " + totalBalance);
        //         }
        //         catch (Exception walletEx)
        //         {
        //             Logger.Error("Failed to get wallets for user " + user.UserId + ": " + walletEx.Message);
        //             // Continue login even if wallet fetch fails
        //         }

        //         // Create authentication ticket
        //         FormsAuthentication.SetAuthCookie(user.UserId.ToString(), chkRemember.Checked);

        //         // ✅ FIX: Safely store user info in session with null checks
        //         Session["UserId"] = user.UserId;
        //         Session["UserName"] = (user.FirstName ?? "") + " " + (user.LastName ?? "");
        //         Session["Email"] = user.Email ?? "";
        //         Session["UserTier"] = user.Tier ?? "Standard";
        //         Session["UserPhoto"] = user.PhotoUrl ?? "";
        //         Session["TotalBalance"] = totalBalance;
        //         Session["PNCBalance"] = pncBalance;
        //         Session["LoginTime"] = DateTime.UtcNow;

        //         // ✅ FIX: Handle nullable IsAdmin
        ////         Session["IsAdmin"] = user.IsAdmin ?? false;

        //         Logger.Info("User " + user.UserId + " (" + email + ") logged in from " + ipAddress);

        //         // Redirect
        //         string returnUrl = Request.QueryString["ReturnUrl"];
        //         if (!string.IsNullOrEmpty(returnUrl) && returnUrl.StartsWith("/"))
        //             Response.Redirect(returnUrl, false);
        //         else
        //             Response.Redirect(ResolveUrl("~/Web/User/Dashboard.aspx"), false);

        //         Context.ApplicationInstance.CompleteRequest();
        //     }
        //     catch (Exception ex)
        //     {
        //         Logger.Error("Login failed for " + (txtEmail?.Text ?? "unknown"), ex);
        //         ShowError("An error occurred during login: " + ex.Message);
        //     }
        // }

        #region Helper Methods

        private string GetUserIpAddress()
        {
            try
            {
                string ip = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
                if (string.IsNullOrEmpty(ip))
                    ip = Request.ServerVariables["REMOTE_ADDR"];
                return ip ?? "unknown";
            }
            catch { return "unknown"; }
        }

        private void ShowError(string message)
        {
            if (pnlError != null && litError != null)
            {
                pnlError.Visible = true;
                litError.Text = message;
            }
        }

        private void ShowWarning(string message)
        {
            if (pnlWarning != null && litWarning != null)
            {
                pnlWarning.Visible = true;
                litWarning.Text = message;
            }
        }

        private void ShowSuccess(string message)
        {
            if (pnlSuccess != null && litSuccess != null)
            {
                pnlSuccess.Visible = true;
                litSuccess.Text = message;
            }
        }

        private void HideAllMessages()
        {
            if (pnlError != null) pnlError.Visible = false;
            if (pnlWarning != null) pnlWarning.Visible = false;
            if (pnlSuccess != null) pnlSuccess.Visible = false;
        }

        #endregion
    }
}