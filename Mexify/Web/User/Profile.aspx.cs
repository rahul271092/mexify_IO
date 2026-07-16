using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.WebControls;
using Mexify.Business.Services;
using Mexify.Models;
using Mexify.Utilities;

namespace Mexify.Web.User
{
    public partial class Profile : System.Web.UI.Page
    {
        private UserProfileService _profileService;
        private int _userId;

        public string ProfilePhotoUrl { get; private set; } = "";
        public string UserFullName { get; private set; } = "";
        public string TierClass { get; private set; } = "tier-standard";
        public string TierIcon { get; private set; } = "fas fa-id-card";
        public string KYCStatusClass { get; private set; } = "unverified";
        public string KYCStatusIcon { get; private set; } = "fas fa-times-circle";
        public bool Is2FAEnabled { get; private set; }
        public bool IsEmailVerified { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.IsAuthenticated || Session["UserId"] == null)
            {
                Response.Redirect(ResolveUrl("~/Web/login.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl)));
                return;
            }

            _userId = Convert.ToInt32(Session["UserId"]);
            _profileService = new UserProfileService();

            if (!IsPostBack)
            {
                LoadProfileData();
            }
        }

        private void LoadProfileData()
        {
            try
            {
                var master = this.Master as Mexify.Web.MasterPages.UserMaster;
                if (master != null)
                {
                    master.SetPageTitle("My Profile");
                    master.SetBreadcrumb("Profile");
                }

                var profile = _profileService.GetUserProfile(_userId);
                if (profile == null)
                {
                    Logger.Error("Profile not found for user " + _userId);
                    return;
                }

                // Basic info
                UserFullName = profile.FirstName + " " + profile.LastName;
                ProfilePhotoUrl = !string.IsNullOrEmpty(profile.PhotoUrl)
                    ? profile.PhotoUrl
                    : "https://ui-avatars.com/api/?name=" + Server.UrlEncode(UserFullName) + "&background=14B8A6&color=fff&size=200";

                // Overview tab
                litFullName.Text = UserFullName;
                litEmail.Text = profile.Email;
                litInfoName.Text = UserFullName;
                litInfoEmail.Text = profile.Email;
                litInfoPhone.Text = string.IsNullOrEmpty(profile.Phone) ? "Not provided" : profile.Phone;
                litInfoCountry.Text = string.IsNullOrEmpty(profile.CountryName) ? "Not provided" : profile.CountryName;
                litReferralCode.Text = string.IsNullOrEmpty(profile.ReferralCode) ? "—" : profile.ReferralCode;
                litUserId.Text = profile.UserId.ToString();
                litInfoTier.Text = profile.Tier ?? "Standard";
                litJoinDate.Text = profile.CreatedDate.ToString("MMMM dd, yyyy");
                litLastLogin.Text = profile.LastLoginDate.HasValue
                    ? profile.LastLoginDate.Value.ToString("MMM dd, yyyy HH:mm")
                    : "—";

                // Member days
                int memberDays = (DateTime.UtcNow - profile.CreatedDate).Days;
                litMemberDays.Text = memberDays.ToString();

                // Tier styling
                SetTierStyle(profile.Tier);

                // KYC status
                SetKYCStatus(profile.KYCStatus);

                // Email verification
                IsEmailVerified = profile.IsEmailVerified;
                pnlEmailVerified.Visible = IsEmailVerified;
                pnlEmailNotVerified.Visible = !IsEmailVerified;

                // Stats
                var stats = _profileService.GetUserProfileStats(_userId);
                litTotalInvested.Text = stats.TotalInvested.ToString("0.00");
                litTotalEarned.Text = stats.TotalEarned.ToString("0.00");
                litTeamSize.Text = stats.TeamSize.ToString();

                // Edit form
                txtFirstName.Text = profile.FirstName;
                txtLastName.Text = profile.LastName;
                txtEmail.Text = profile.Email;
                txtPhone.Text = profile.Phone ?? "";

                // Load countries
                LoadCountries(profile.CountryId);

                // Referral link
                string baseUrl = Request.Url.GetLeftPart(UriPartial.Authority);
                litReferralLink.Text = baseUrl + ResolveUrl("~/Web/MetaMaskLogin.aspx?ref=" + (profile.ReferralCode ?? ""));

                // Security
                Is2FAEnabled = profile.Is2FAEnabled;

                // Login history
                var loginHistory = _profileService.GetLoginHistory(_userId, 10);
                if (loginHistory != null && loginHistory.Count > 0)
                {
                    rptLoginHistory.DataSource = loginHistory;
                    rptLoginHistory.DataBind();
                    pnlNoLogins.Visible = false;
                }
                else
                {
                    pnlNoLogins.Visible = true;
                }

                // Account activity
                var activity = _profileService.GetAccountActivity(_userId, 10);
                if (activity != null && activity.Count > 0)
                {
                    rptAccountActivity.DataSource = activity;
                    rptAccountActivity.DataBind();
                    pnlNoActivity.Visible = false;
                }
                else
                {
                    pnlNoActivity.Visible = true;
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Profile page load failed for user " + _userId, ex);
            }
        }

        private void SetTierStyle(string tier)
        {
            if (string.IsNullOrEmpty(tier)) tier = "Standard";

            switch (tier.ToLower())
            {
                case "silver":
                    TierClass = "tier-silver";
                    TierIcon = "fas fa-medal";
                    break;
                case "gold":
                    TierClass = "tier-gold";
                    TierIcon = "fas fa-crown";
                    break;
                case "platinum":
                    TierClass = "tier-platinum";
                    TierIcon = "fas fa-gem";
                    break;
                default:
                    TierClass = "tier-standard";
                    TierIcon = "fas fa-id-card";
                    break;
            }
            litTierName.Text = tier;
        }

        private void SetKYCStatus(string status)
        {
            if (string.IsNullOrEmpty(status)) status = "Unverified";

            switch (status.ToLower())
            {
                case "verified":
                case "approved":
                    KYCStatusClass = "verified";
                    KYCStatusIcon = "fas fa-check-circle";
                    litKYCTitle.Text = "✓ KYC Verified";
                    litKYCDesc.Text = "Your identity has been verified. All features are unlocked.";
                    pnlKYCButton.Visible = false;
                    break;
                case "pending":
                    KYCStatusClass = "pending";
                    KYCStatusIcon = "fas fa-clock";
                    litKYCTitle.Text = "⏳ KYC Pending Review";
                    litKYCDesc.Text = "Your documents are being reviewed. This usually takes 24-48 hours.";
                    pnlKYCButton.Visible = false;
                    break;
                default:
                    KYCStatusClass = "unverified";
                    KYCStatusIcon = "fas fa-times-circle";
                    litKYCTitle.Text = "⚠ KYC Not Verified";
                    litKYCDesc.Text = "Verify your identity to unlock higher limits and premium features.";
                    pnlKYCButton.Visible = true;
                    break;
            }
        }

        private void LoadCountries(int? selectedCountryId)
        {
            try
            {
                var countries = _profileService.GetCountries();
                ddlCountry.DataSource = countries;
                ddlCountry.DataValueField = "CountryId";
                ddlCountry.DataTextField = "CountryName";
                ddlCountry.DataBind();
                ddlCountry.Items.Insert(0, new ListItem("Select country", ""));

                if (selectedCountryId.HasValue)
                {
                    ddlCountry.SelectedValue = selectedCountryId.Value.ToString();
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load countries", ex);
            }
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            pnlEditError.Visible = false;
            pnlEditSuccess.Visible = false;

            try
            {
                string firstName = txtFirstName.Text.Trim();
                string lastName = txtLastName.Text.Trim();
                string phone = txtPhone.Text.Trim();
                int? countryId = string.IsNullOrEmpty(ddlCountry.SelectedValue) ? (int?)null : int.Parse(ddlCountry.SelectedValue);

                // Validation
                if (string.IsNullOrWhiteSpace(firstName))
                {
                    ShowEditError("First name is required.");
                    return;
                }
                if (firstName.Length < 2 || firstName.Length > 100)
                {
                    ShowEditError("First name must be between 2 and 100 characters.");
                    return;
                }
                if (string.IsNullOrWhiteSpace(lastName))
                {
                    ShowEditError("Last name is required.");
                    return;
                }
                if (lastName.Length < 2 || lastName.Length > 100)
                {
                    ShowEditError("Last name must be between 2 and 100 characters.");
                    return;
                }

                // Handle photo upload
                string photoUrl = null;
                if (fuPhoto.HasFile)
                {
                    if (fuPhoto.PostedFile.ContentLength > 2 * 1024 * 1024)
                    {
                        ShowEditError("Photo must be less than 2MB.");
                        return;
                    }

                    string ext = Path.GetExtension(fuPhoto.FileName).ToLower();
                    if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".gif")
                    {
                        ShowEditError("Only JPG, PNG, and GIF files are allowed.");
                        return;
                    }

                    string fileName = "user_" + _userId + "_" + DateTime.UtcNow.Ticks + ext;
                    string uploadPath = Server.MapPath("~/Assets/uploads/profiles/");

                    if (!Directory.Exists(uploadPath))
                    {
                        Directory.CreateDirectory(uploadPath);
                    }

                    string fullPath = Path.Combine(uploadPath, fileName);
                    fuPhoto.SaveAs(fullPath);
                    photoUrl = "~/Assets/uploads/profiles/" + fileName;
                }

                // Update profile
                var result = _profileService.UpdateProfile(_userId, firstName, lastName, phone, countryId, photoUrl);

                if (result.Success)
                {
                    ShowEditSuccess("Profile updated successfully!");

                    // Update session
                    Session["UserName"] = firstName + " " + lastName;
                    if (!string.IsNullOrEmpty(photoUrl))
                    {
                        Session["UserPhoto"] = ResolveUrl(photoUrl);
                    }

                    // Reload data
                    LoadProfileData();
                }
                else
                {
                    ShowEditError(result.ErrorMessage);
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Profile update failed", ex);
                ShowEditError("An error occurred. Please try again.");
            }
        }

        protected void btnCancelEdit_Click(object sender, EventArgs e)
        {
            LoadProfileData();
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            pnlSecurityError.Visible = false;
            pnlSecuritySuccess.Visible = false;

            try
            {
                string currentPassword = txtCurrentPassword.Text;
                string newPassword = txtNewPassword.Text;
                string confirmPassword = txtConfirmPassword.Text;

                // Validation
                if (string.IsNullOrWhiteSpace(currentPassword))
                {
                    ShowSecurityError("Current password is required.");
                    return;
                }
                if (string.IsNullOrWhiteSpace(newPassword))
                {
                    ShowSecurityError("New password is required.");
                    return;
                }
                if (newPassword.Length < 8)
                {
                    ShowSecurityError("New password must be at least 8 characters long.");
                    return;
                }
                if (!Regex.IsMatch(newPassword, "[A-Z]"))
                {
                    ShowSecurityError("New password must contain at least one uppercase letter.");
                    return;
                }
                if (!Regex.IsMatch(newPassword, "[0-9]"))
                {
                    ShowSecurityError("New password must contain at least one number.");
                    return;
                }
                if (!Regex.IsMatch(newPassword, @"[!@#$%^&*(),.?"":{ }|<>]"))
                {
                    ShowSecurityError("New password must contain at least one special character.");
                    return;
                }
                if (newPassword != confirmPassword)
                {
                    ShowSecurityError("New passwords do not match.");
                    return;
                }
                if (currentPassword == newPassword)
                {
                    ShowSecurityError("New password must be different from current password.");
                    return;
                }

                var result = _profileService.ChangePassword(_userId, currentPassword, newPassword);

                if (result.Success)
                {
                    ShowSecuritySuccess("Password changed successfully!");
                    txtCurrentPassword.Text = "";
                    txtNewPassword.Text = "";
                    txtConfirmPassword.Text = "";
                }
                else
                {
                    ShowSecurityError(result.ErrorMessage);
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Password change failed", ex);
                ShowSecurityError("An error occurred. Please try again.");
            }
        }

        private void ShowEditError(string message)
        {
            pnlEditError.Visible = true;
            litEditError.Text = message;
        }

        private void ShowEditSuccess(string message)
        {
            pnlEditSuccess.Visible = true;
            litEditSuccess.Text = message;
        }

        private void ShowSecurityError(string message)
        {
            pnlSecurityError.Visible = true;
            litSecurityError.Text = message;
        }

        private void ShowSecuritySuccess(string message)
        {
            pnlSecuritySuccess.Visible = true;
            litSecuritySuccess.Text = message;
        }
    }
}