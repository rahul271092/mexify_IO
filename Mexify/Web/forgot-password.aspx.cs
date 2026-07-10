using System;
using System.Web.UI;
using Mexify.Business.Services;
using Mexify.Utilities;

namespace Mexify.Web
{
    public partial class forgot_password : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Clear any cached values
                txtEmail.Text = "";
            }
        }

        protected void btnSendReset_Click(object sender, EventArgs e)
        {
            // Hide any previous messages
            pnlError.Visible = false;

            // Simple server-side validation (no ASP.NET validators)
            string email = txtEmail.Text.Trim();

            if (string.IsNullOrWhiteSpace(email))
            {
                pnlError.Visible = true;
                litError.Text = "Please enter your email address.";
                return;
            }

            // Basic email format check
            if (!IsValidEmail(email))
            {
                pnlError.Visible = true;
                litError.Text = "Please enter a valid email address.";
                return;
            }

            try
            {
                string ipAddress = GetUserIpAddress();
                var authService = new AuthService();

                // Generate reset token (always returns token if email exists)
                string token = authService.InitiatePasswordReset(email, ipAddress);

                // Show success view (same response for valid/invalid emails - prevents email enumeration)
                pnlForm.Visible = false;
                pnlSuccess.Visible = true;
                litEmailUsed.Text = MaskEmail(email);

                if (token != null)
                {
                    // TODO: Send reset email
                    // EmailService.SendPasswordResetEmail(email, token);

                    Logger.Info("Password reset token generated for: " + email + " from IP: " + ipAddress);
                }
                else
                {
                    // Email not found, but still show success to prevent enumeration
                    Logger.Info("Password reset requested for non-existent email: " + email);
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Password reset request failed", ex);
                pnlError.Visible = true;
                litError.Text = "An error occurred. Please try again later.";
            }
        }

        protected void btnResend_Click(object sender, EventArgs e)
        {
            // Re-show the form so user can resend
            pnlSuccess.Visible = false;
            pnlForm.Visible = true;
            pnlError.Visible = false;
        }

        /// <summary>
        /// Simple email validation (no regex validator needed)
        /// </summary>
        private bool IsValidEmail(string email)
        {
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return addr.Address == email && email.Contains("@") && email.Contains(".");
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Masks email for security display (e.g., "j***@example.com")
        /// </summary>
        private string MaskEmail(string email)
        {
            try
            {
                int atIndex = email.IndexOf('@');
                if (atIndex <= 2) return email;
                return email.Substring(0, 1) + "***" + email.Substring(atIndex);
            }
            catch
            {
                return email;
            }
        }

        private string GetUserIpAddress()
        {
            string ip = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            if (string.IsNullOrEmpty(ip))
            {
                ip = Request.ServerVariables["REMOTE_ADDR"];
            }
            return ip ?? "unknown";
        }
    }
}