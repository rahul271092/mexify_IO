using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.WebControls;
using Mexify.Business.Services;
using Mexify.Models;
using Mexify.Utilities;

namespace Mexify.Web.User
{
    public partial class Security : System.Web.UI.Page
    {
        private SecurityService _securityService;
        private int _userId;

        public int SecurityScorePercent { get; private set; } = 0;
        public bool Is2FAEnabled { get; private set; }
        public bool IsEmailVerified { get; private set; }
        public bool HasAntiPhishing { get; private set; }
        public bool HasPasswordRecentlyChanged { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.IsAuthenticated || Session["UserId"] == null)
            {
                Response.Redirect(ResolveUrl("~/Web/login.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl)));
                return;
            }

            _userId = Convert.ToInt32(Session["UserId"]);
            _securityService = new SecurityService();

            if (!IsPostBack)
            {
                LoadSecurityData();
            }
        }

        private void LoadSecurityData()
        {
            try
            {
                var master = this.Master as Mexify.Web.MasterPages.UserMaster;
                if (master != null)
                {
                    master.SetPageTitle("Security");
                    master.SetBreadcrumb("Security");
                }

                var securityInfo = _securityService.GetUserSecurityInfo(_userId);

                Is2FAEnabled = securityInfo.Is2FAEnabled;
                IsEmailVerified = securityInfo.IsEmailVerified;
                HasAntiPhishing = !string.IsNullOrEmpty(securityInfo.AntiPhishingCode);
                HasPasswordRecentlyChanged = securityInfo.PasswordAgeDays <= 90;

                // Calculate security score
                int score = 0;
                if (Is2FAEnabled) score += 30;
                if (IsEmailVerified) score += 20;
                if (HasAntiPhishing) score += 15;
                if (HasPasswordRecentlyChanged) score += 20;
                if (securityInfo.HasWhitelist) score += 15;
                SecurityScorePercent = score;

                litSecurityScore.Text = score.ToString();

                if (score >= 80)
                {
                    litSecurityLevel.Text = "Excellent";
                    litSecurityDesc.Text = "Your account is well-protected with strong security measures.";
                }
                else if (score >= 60)
                {
                    litSecurityLevel.Text = "Good";
                    litSecurityDesc.Text = "Your account has good protection. Consider enabling additional features.";
                }
                else if (score >= 40)
                {
                    litSecurityLevel.Text = "Fair";
                    litSecurityDesc.Text = "Your account needs more security features. Enable 2FA for better protection.";
                }
                else
                {
                    litSecurityLevel.Text = "Poor";
                    litSecurityDesc.Text = "Your account is at risk. Please enable security features immediately.";
                }

                // Build checklist
                var checklist = new StringBuilder();
                checklist.Append(CheckItem("2FA Enabled", Is2FAEnabled));
                checklist.Append(CheckItem("Email Verified", IsEmailVerified));
                checklist.Append(CheckItem("Anti-Phishing", HasAntiPhishing));
                checklist.Append(CheckItem("Recent Password", HasPasswordRecentlyChanged));
                litChecklist.Text = checklist.ToString();

                // Password info
                litPasswordAge.Text = securityInfo.PasswordAgeDays + " days ago";
                litLastPasswordChange.Text = securityInfo.LastPasswordChange.HasValue
                    ? securityInfo.LastPasswordChange.Value.ToString("MMM dd, yyyy")
                    : "Never";
                litPasswordAgeDetail.Text = securityInfo.PasswordAgeDays + " days";
                litPasswordStrength.Text = securityInfo.PasswordStrength;

                // Notification settings
                chkLoginAlerts.Checked = securityInfo.LoginAlerts;
                chkWithdrawAlerts.Checked = securityInfo.WithdrawAlerts;
                chkFailedLoginAlerts.Checked = securityInfo.FailedLoginAlerts;
                chkSettingsAlerts.Checked = securityInfo.SettingsAlerts;

                // 2FA setup
                if (!Is2FAEnabled)
                {
                    var setup = _securityService.Generate2FASecret(_userId);
                    lit2FASecret.Text = setup.SecretKey;

                    string qrData = string.Format("otpauth://totp/MEXIFY:{0}?secret={1}&issuer=MEXIFY",
                        Server.UrlEncode(securityInfo.Email), setup.SecretKey);

                    string qrUrl = "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=" + Server.UrlEncode(qrData);
                  //  qrCode2FA.Src = qrUrl;

                    pnl2FANotEnabled.Visible = true;
                    pnl2FAEnabled.Visible = false;
                }
                else
                {
                    pnl2FANotEnabled.Visible = false;
                    pnl2FAEnabled.Visible = true;
                    lit2FAEnabledDate.Text = securityInfo.TwoFAEnabledDate.HasValue
                        ? securityInfo.TwoFAEnabledDate.Value.ToString("MMMM dd, yyyy")
                        : "Unknown";
                    lit2FADaysActive.Text = securityInfo.TwoFADaysActive.ToString();
                }

                // Sessions
                var sessions = _securityService.GetActiveSessions(_userId);
                if (sessions != null && sessions.Count > 0)
                {
                    rptSessions.DataSource = sessions;
                    rptSessions.DataBind();
                    litSessionCount.Text = sessions.Count.ToString();
                    pnlNoSessions.Visible = false;
                }
                else
                {
                    pnlNoSessions.Visible = true;
                }

                // Whitelist
                var whitelist = _securityService.GetWhitelist(_userId);
                if (whitelist != null && whitelist.Count > 0)
                {
                    rptWhitelist.DataSource = whitelist;
                    rptWhitelist.DataBind();
                    pnlNoWhitelist.Visible = false;
                }
                else
                {
                    pnlNoWhitelist.Visible = true;
                }

                // Load currencies for whitelist
                LoadWhitelistCurrencies();

                // Activity log
                var activity = _securityService.GetSecurityActivity(_userId, 50);
                if (activity != null && activity.Count > 0)
                {
                    rptActivity.DataSource = activity;
                    rptActivity.DataBind();
                    pnlNoActivity.Visible = false;
                }
                else
                {
                    pnlNoActivity.Visible = true;
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Security page load failed for user " + _userId, ex);
            }
        }

        private string CheckItem(string label, bool isDone)
        {
            string className = isDone ? "done" : "failed";
            string icon = isDone ? "fas fa-check-circle" : "fas fa-times-circle";
            return string.Format("<span class='check-item {0}'><i class='{1}'></i> {2}</span>", className, icon, label);
        }

        private void LoadWhitelistCurrencies()
        {
            try
            {
                var walletService = new WalletService();
                var currencies = walletService.GetSupportedCurrencies();
                ddlWhitelistCurrency.DataSource = currencies;
                ddlWhitelistCurrency.DataValueField = "CurrencyId";
                ddlWhitelistCurrency.DataTextField = "CurrencyCode";
                ddlWhitelistCurrency.DataBind();
                ddlWhitelistCurrency.Items.Insert(0, new ListItem("Select currency", ""));
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load currencies", ex);
            }
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

        // ============ 2FA HANDLERS ============

        protected void btnEnable2FA_Click(object sender, EventArgs e)
        {
            pnl2FAError.Visible = false;
            pnl2FASuccess.Visible = false;

            string code = txt2FACode.Text.Trim();
            if (string.IsNullOrEmpty(code) || code.Length != 6)
            {
                Show2FAError("Please enter a valid 6-digit code.");
                return;
            }

            var result = _securityService.Enable2FA(_userId, code);
            if (result.Success)
            {
                Show2FASuccess("Two-factor authentication has been enabled successfully!");
                hfActiveTab.Value = "twofa";
                LoadSecurityData();
            }
            else
            {
                Show2FAError(result.ErrorMessage);
            }
        }

        protected void btnDisable2FA_Click(object sender, EventArgs e)
        {
            pnl2FAError.Visible = false;
            pnl2FASuccess.Visible = false;

            var result = _securityService.Disable2FA(_userId);
            if (result.Success)
            {
                Show2FASuccess("Two-factor authentication has been disabled.");
                hfActiveTab.Value = "twofa";
                LoadSecurityData();
            }
            else
            {
                Show2FAError(result.ErrorMessage);
            }
        }

        protected void btnGenerateBackupCodes_Click(object sender, EventArgs e)
        {
            var codes = _securityService.GenerateBackupCodes(_userId);
            if (codes != null && codes.Count > 0)
            {
                string codesText = string.Join("\n", codes);
                ClientScript.RegisterStartupScript(this.GetType(), "backupCodes",
                    "alert('Your backup codes:\\n\\n" + codesText.Replace("\n", "\\n") + "\\n\\nSave these codes in a secure place!');", true);
            }
        }

        private void Show2FAError(string msg) { pnl2FAError.Visible = true; lit2FAError.Text = msg; }
        private void Show2FASuccess(string msg) { pnl2FASuccess.Visible = true; lit2FASuccess.Text = msg; }

        // ============ PASSWORD HANDLERS ============

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            pnlPasswordError.Visible = false;
            pnlPasswordSuccess.Visible = false;

            string current = txtCurrentPassword.Text;
            string newPass = txtNewPassword.Text;
            string confirm = txtConfirmPassword.Text;

            if (string.IsNullOrWhiteSpace(current))
            {
                ShowPasswordError("Current password is required.");
                return;
            }
            if (string.IsNullOrWhiteSpace(newPass))
            {
                ShowPasswordError("New password is required.");
                return;
            }
            if (newPass.Length < 8)
            {
                ShowPasswordError("New password must be at least 8 characters long.");
                return;
            }
            if (!Regex.IsMatch(newPass, "[A-Z]"))
            {
                ShowPasswordError("New password must contain at least one uppercase letter.");
                return;
            }
            if (!Regex.IsMatch(newPass, "[a-z]"))
            {
                ShowPasswordError("New password must contain at least one lowercase letter.");
                return;
            }
            if (!Regex.IsMatch(newPass, "[0-9]"))
            {
                ShowPasswordError("New password must contain at least one number.");
                return;
            }
            if (!Regex.IsMatch(newPass, @"[!@#$%^&*(),.?"":{ }|<>]"))
            {
                ShowPasswordError("New password must contain at least one special character.");
                return;
            }
            if (newPass != confirm)
            {
                ShowPasswordError("Passwords do not match.");
                return;
            }
            if (current == newPass)
            {
                ShowPasswordError("New password must be different from current password.");
                return;
            }

            var result = _securityService.ChangePassword(_userId, current, newPass);
            if (result.Success)
            {
                ShowPasswordSuccess("Password changed successfully! You'll be logged out of other devices.");
                txtCurrentPassword.Text = "";
                txtNewPassword.Text = "";
                txtConfirmPassword.Text = "";
                hfActiveTab.Value = "password";
            }
            else
            {
                ShowPasswordError(result.ErrorMessage);
            }
        }

        private void ShowPasswordError(string msg) { pnlPasswordError.Visible = true; litPasswordError.Text = msg; }
        private void ShowPasswordSuccess(string msg) { pnlPasswordSuccess.Visible = true; litPasswordSuccess.Text = msg; }

        // ============ NOTIFICATION HANDLERS ============

        protected void btnSaveNotifications_Click(object sender, EventArgs e)
        {
            var prefs = new NotificationPreferences
            {
                LoginAlerts = chkLoginAlerts.Checked,
                WithdrawAlerts = chkWithdrawAlerts.Checked,
                FailedLoginAlerts = chkFailedLoginAlerts.Checked,
                SettingsAlerts = chkSettingsAlerts.Checked
            };

            var result = _securityService.UpdateNotificationPreferences(_userId, prefs);
            if (result.Success)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "notifSuccess",
                    "alert('Notification preferences saved!');", true);
            }
        }

        // ============ SESSION HANDLERS ============

        protected void btnLogoutAll_Click(object sender, EventArgs e)
        {
            var result = _securityService.LogoutAllSessions(_userId, GetCurrentSessionId());
            if (result.Success)
            {
                pnlSessionSuccess.Visible = true;
                litSessionSuccess.Text = "All other sessions have been logged out.";
                LoadSecurityData();
            }
        }

        protected void lnkRevokeSession_Command(object sender, CommandEventArgs e)
        {
            long sessionId;
            if (long.TryParse(e.CommandArgument.ToString(), out sessionId))
            {
                var result = _securityService.RevokeSession(_userId, sessionId);
                if (result.Success)
                {
                    pnlSessionSuccess.Visible = true;
                    litSessionSuccess.Text = "Session revoked successfully.";
                    LoadSecurityData();
                }
            }
        }

        private string GetCurrentSessionId()
        {
            return Session.SessionID;
        }

        // ============ WHITELIST HANDLERS ============

        protected void btnAddWhitelist_Click(object sender, EventArgs e)
        {
            pnlWhitelistError.Visible = false;
            pnlWhitelistSuccess.Visible = false;

            string label = txtWhitelistLabel.Text.Trim();
            string address = txtWhitelistAddress.Text.Trim();
            string twoFA = txtWhitelist2FA.Text.Trim();

            if (string.IsNullOrWhiteSpace(label))
            {
                ShowWhitelistError("Label is required.");
                return;
            }
            if (string.IsNullOrWhiteSpace(ddlWhitelistCurrency.SelectedValue))
            {
                ShowWhitelistError("Please select a currency.");
                return;
            }
            if (string.IsNullOrWhiteSpace(address))
            {
                ShowWhitelistError("Wallet address is required.");
                return;
            }
            if (string.IsNullOrWhiteSpace(twoFA) || twoFA.Length != 6)
            {
                ShowWhitelistError("Please enter a valid 2FA code.");
                return;
            }

            int currencyId = int.Parse(ddlWhitelistCurrency.SelectedValue);
            var result = _securityService.AddToWhitelist(_userId, label, address, currencyId, twoFA);

            if (result.Success)
            {
                ShowWhitelistSuccess("Address added to whitelist! It will be active in 24 hours.");
                txtWhitelistLabel.Text = "";
                txtWhitelistAddress.Text = "";
                txtWhitelist2FA.Text = "";
                hfActiveTab.Value = "whitelist";
                LoadSecurityData();
            }
            else
            {
                ShowWhitelistError(result.ErrorMessage);
            }
        }

        protected void lnkRemoveWhitelist_Command(object sender, CommandEventArgs e)
        {
            long whitelistId;
            if (long.TryParse(e.CommandArgument.ToString(), out whitelistId))
            {
                var result = _securityService.RemoveFromWhitelist(_userId, whitelistId);
                if (result.Success)
                {
                    pnlWhitelistSuccess.Visible = true;
                    litWhitelistSuccess.Text = "Address removed from whitelist.";
                    LoadSecurityData();
                }
            }
        }

        private void ShowWhitelistError(string msg) { pnlWhitelistError.Visible = true; litWhitelistError.Text = msg; }
        private void ShowWhitelistSuccess(string msg) { pnlWhitelistSuccess.Visible = true; litWhitelistSuccess.Text = msg; }

        // ============ ACTIVITY HANDLERS ============

        protected void btnExportActivity_Click(object sender, EventArgs e)
        {
            try
            {
                var activity = _securityService.GetSecurityActivity(_userId, 1000);
                if (activity == null || activity.Count == 0)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "noActivity",
                        "alert('No activity to export.');", true);
                    return;
                }

                StringBuilder csv = new StringBuilder();
                csv.AppendLine("Date,Type,Title,Location,Device");

                foreach (var item in activity)
                {
                    csv.AppendLine(string.Format("{0},{1},{2},{3},{4}",
                        item.CreatedDate.ToString("yyyy-MM-dd HH:mm:ss"),
                        item.TypeClass,
                        item.Title.Replace(",", " "),
                        item.Location,
                        item.Device));
                }

                Response.Clear();
                Response.ContentType = "text/csv";
                Response.AddHeader("Content-Disposition", "attachment; filename=security_activity_" + DateTime.Now.ToString("yyyyMMdd") + ".csv");
                Response.Write(csv.ToString());
                Response.End();
            }
            catch (Exception ex)
            {
                Logger.Error("Activity export failed", ex);
            }
        }
    }
}