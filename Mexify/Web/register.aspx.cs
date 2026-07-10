using Mexify.Business.Services;
using Mexify.DataAccess.Repositories;
using Mexify.Utilities;
using Mexify.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Mexify.Web
{
    public partial class register : System.Web.UI.Page
    {
        private string _referralCode;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Redirect if already logged in
            if (Request.IsAuthenticated && Session["UserId"] != null)
            {
                Response.Redirect(ResolveUrl("~/User/Dashboard.aspx"));
                return;
            }

            if (!IsPostBack)
            {
                // Clear cached values
                txtFirstName.Text = "";
                txtLastName.Text = "";
                txtEmail.Text = "";
                txtPhone.Text = "";
                txtPassword.Text = "";
                txtConfirmPassword.Text = "";

                LoadCountries();
                HandleReferralCode();
            }
        }

        private void LoadCountries()
        {
            try
            {
                var repo = new CountryRepository();
                var countries = repo.GetActiveCountries();

                ddlCountry.DataSource = countries;
                ddlCountry.DataValueField = "CountryId";
                ddlCountry.DataTextField = "CountryName";
                ddlCountry.DataBind();

                // Add default "Select" option at the top
                ddlCountry.Items.Insert(0, new ListItem("Select your country", ""));
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load countries", ex);
                // Fallback: add a few common countries
                ddlCountry.Items.Clear();
                ddlCountry.Items.Add(new ListItem("Select your country", ""));
                ddlCountry.Items.Add(new ListItem("United States", "1"));
                ddlCountry.Items.Add(new ListItem("United Kingdom", "2"));
                ddlCountry.Items.Add(new ListItem("Canada", "3"));
                ddlCountry.Items.Add(new ListItem("Australia", "4"));
                ddlCountry.Items.Add(new ListItem("India", "5"));

            }
        }


        private void HandleReferralCode()
        {
            _referralCode = Request.QueryString["ref"];
            if (string.IsNullOrEmpty(_referralCode)) return;

            hfReferralCode.Value = _referralCode;

            try
            {
                var repo = new UserRepository();
                var referrer = repo.GetUserByReferralCode(_referralCode);
                if (referrer != null)
                {
                    pnlReferral.Visible = true;
                    litReferrerName.Text = referrer.FirstName + " " +
                        (string.IsNullOrEmpty(referrer.LastName) ? "" : referrer.LastName.Substring(0, 1) + ".");
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load referrer info", ex);
            }
        }


        protected void btnRegister_Click(object sender, EventArgs e)
        {
            // Hide any previous errors
            pnlError.Visible = false;

            try
            {
                // Collect values
                string firstName = txtFirstName.Text.Trim();
                string lastName = txtLastName.Text.Trim();
                string email = txtEmail.Text.Trim();
                string phone = txtPhone.Text.Trim();
                string countryIdStr = ddlCountry.SelectedValue;
                string password = txtPassword.Text;
                string confirmPassword = txtConfirmPassword.Text;
                string refCode = hfReferralCode.Value;

                // ========= SERVER-SIDE VALIDATION =========

                // 1. First name
                if (string.IsNullOrWhiteSpace(firstName))
                {
                    ShowError("Please enter your first name.");
                    return;
                }
                if (firstName.Length < 2 || firstName.Length > 100)
                {
                    ShowError("First name must be between 2 and 100 characters.");
                    return;
                }

                // 2. Last name
                if (string.IsNullOrWhiteSpace(lastName))
                {
                    ShowError("Please enter your last name.");
                    return;
                }
                if (lastName.Length < 2 || lastName.Length > 100)
                {
                    ShowError("Last name must be between 2 and 100 characters.");
                    return;
                }

                // 3. Email
                if (string.IsNullOrWhiteSpace(email))
                {
                    ShowError("Please enter your email address.");
                    return;
                }
                if (!IsValidEmail(email))
                {
                    ShowError("Please enter a valid email address.");
                    return;
                }

                // 4. Country
                if (string.IsNullOrEmpty(countryIdStr))
                {
                    ShowError("Please select your country.");
                    return;
                }

                // 5. Password
                if (string.IsNullOrWhiteSpace(password))
                {
                    ShowError("Please enter a password.");
                    return;
                }
                if (password.Length < 8)
                {
                    ShowError("Password must be at least 8 characters long.");
                    return;
                }
                if (!System.Text.RegularExpressions.Regex.IsMatch(password, "[A-Z]"))
                {
                    ShowError("Password must contain at least one uppercase letter.");
                    return;
                }
                if (!System.Text.RegularExpressions.Regex.IsMatch(password, "[0-9]"))
                {
                    ShowError("Password must contain at least one number.");
                    return;
                }
                if (!System.Text.RegularExpressions.Regex.IsMatch(password, @"[!@#$%^&*(),.?""':{}|<>_\-+=\[\]\\\/]"))
                {
                    ShowError("Password must contain at least one special character.");
                    return;
                }

                // 6. Confirm password
                if (password != confirmPassword)
                {
                    ShowError("Passwords do not match.");
                    return;
                }

                // 7. Terms acceptance
                if (!chkTerms.Checked)
                {
                    ShowError("You must accept the Terms of Service and Privacy Policy to continue.");
                    return;
                }

                // ========= CREATE USER =========

                int? countryId = null;
                int countryIdParsed;
                if (int.TryParse(countryIdStr, out countryIdParsed))
                {
                    countryId = countryIdParsed;
                }

                var user = new Mexify.Web.Models.User
                   {
                    FirstName = firstName,
                    LastName = lastName,
                    Email = email,
                    PasswordHash = password, // Will be hashed in service
                    Phone = string.IsNullOrWhiteSpace(phone) ? null : phone,
                    CountryId = countryId
                };

                string ipAddress = GetUserIpAddress();
                var authService = new AuthService();
                int result = authService.RegisterUser(user, refCode, ipAddress);

                if (result == -2)
                {
                    ShowError("An account with this email already exists. Please login or use a different email.");
                    return;
                }
                else if (result == -1 || result <= 0)
                {
                    ShowError("Registration failed. Please try again later.");
                    return;
                }

                // TODO: Send verification email
                // EmailService.SendVerificationEmail(user.Email, user.VerificationToken);

                Logger.Info("New user registered: " + email + " (ID: " + result + ")");

                // Redirect to login with success message
                Response.Redirect(ResolveUrl("~/Web/login.aspx?registered=1"));
            }
            catch (Exception ex)
            {
                Logger.Error("Registration failed", ex);
                ShowError("An error occurred during registration. Please try again.");
            }
        }


        private void ShowError(string message)
        {
            pnlError.Visible = true;
            litError.Text = message;
        }


        private bool IsValidEmail(string email)
        {
            try
            {
                var addr = new MailAddress(email);
                return addr.Address == email && email.Contains("@") && email.Contains(".");
            }
            catch
            {
                return false;
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


    public class CountryRepository : Mexify.DataAccess.BaseRepository
    {
        public List<Country> GetActiveCountries()
        {
            return ExecuteStoredProcedure<Country>(
                "usp_GetActiveCountries",
                reader => new Country
                {
                    CountryId = GetSafeInt(reader, "CountryId"),
                    CountryName = GetSafeString(reader, "CountryName") ?? ""
                }
            );
        }
    }

    public class Country
    {
        public int CountryId { get; set; }
        public string CountryName { get; set; }
    }
}