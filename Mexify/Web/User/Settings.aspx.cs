using System;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;
using Mexify.Utilities;
using System.Web.UI.WebControls;

namespace Mexify.Web.User
{
    public partial class Settings : System.Web.UI.Page
    {
        private int _userId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Web/login.aspx", false);
                return;
            }

            _userId = Convert.ToInt32(Session["UserId"]);

            if (!IsPostBack)
            {
                LoadUserData();
            }
        }

        private void LoadUserData()
        {
            try
            {
                using (SqlCommand cmd = Web.Models.Connection.SqlQuery(
                    "SELECT FirstName, LastName, Email, Phone, WalletAddress, EmailNotifications, SmsNotifications, PushNotifications, Language, DisplayCurrency FROM Users WHERE UserId = @UserId"))
                {
                    cmd.Parameters.AddWithValue("@UserId", _userId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            txtFirstName.Text = reader["FirstName"]?.ToString() ?? "";
                            txtLastName.Text = reader["LastName"]?.ToString() ?? "";
                            txtEmail.Text = reader["Email"]?.ToString() ?? "";
                            txtPhone.Text = reader["Phone"]?.ToString() ?? "";
                            litWalletAddress.Text = reader["WalletAddress"]?.ToString() ?? "Not connected";

                            chkEmailNotif.Checked = reader["EmailNotifications"] != DBNull.Value && Convert.ToBoolean(reader["EmailNotifications"]);
                            chkSmsNotif.Checked = reader["SmsNotifications"] != DBNull.Value && Convert.ToBoolean(reader["SmsNotifications"]);
                            chkPushNotif.Checked = reader["PushNotifications"] != DBNull.Value && Convert.ToBoolean(reader["PushNotifications"]);

                            ddlLanguage.SelectedValue = reader["Language"]?.ToString() ?? "en";
                            ddlCurrency.SelectedValue = reader["DisplayCurrency"]?.ToString() ?? "USD";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load user settings", ex);
            }
            finally
            {
                Web.Models.Connection.CloseConnection();
            }
        }

        // ================= PROFILE SAVE =================
        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                using (SqlCommand cmd = Web.Models.Connection.SqlQuery(
                    "UPDATE Users SET FirstName = @FirstName, LastName = @LastName, Email = @Email, Phone = @Phone, UpdatedDate = GETDATE() WHERE UserId = @UserId"))
                {
                    cmd.Parameters.AddWithValue("@UserId", _userId);
                    cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text.Trim());
                    cmd.Parameters.AddWithValue("@LastName", txtLastName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim().ToLower());
                    cmd.Parameters.AddWithValue("@Phone", string.IsNullOrWhiteSpace(txtPhone.Text) ? (object)DBNull.Value : txtPhone.Text.Trim());

                    cmd.ExecuteNonQuery();

                    // Update session
                    Session["UserName"] = $"{txtFirstName.Text.Trim()} {txtLastName.Text.Trim()}";
                }

                ShowMessage("pnlProfileMsg", "litProfileMsg", "alert-success", "Profile updated successfully!");
            }
            catch (Exception ex)
            {
                ShowMessage("pnlProfileMsg", "litProfileMsg", "alert-danger", "Failed to update profile: " + ex.Message);
                Logger.Error("Profile save failed", ex);
            }
            finally { Web.Models.Connection.CloseConnection(); }
        }

        // ================= PASSWORD CHANGE =================
        protected void btnChangePwd_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                // 1. Verify current password
                string currentHash = null, currentSalt = null;
                using (SqlCommand cmd = Web.Models.Connection.SqlQuery(
                    "SELECT PasswordHash, Salt FROM Users WHERE UserId = @UserId"))
                {
                    cmd.Parameters.AddWithValue("@UserId", _userId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            currentHash = reader["PasswordHash"]?.ToString();
                            currentSalt = reader["Salt"]?.ToString();
                        }
                    }
                }

                if (string.IsNullOrEmpty(currentHash) || currentHash != HashPassword(txtCurrentPwd.Text, currentSalt))
                {
                    ShowMessage("pnlPwdMsg", "litPwdMsg", "alert-danger", "Current password is incorrect.");
                    return;
                }

                // 2. Generate new salt & hash
                string newSalt = GenerateSalt();
                string newHash = HashPassword(txtNewPwd.Text, newSalt);

                // 3. Update
                using (SqlCommand cmd = Web.Models.Connection.SqlQuery(
                    "UPDATE Users SET PasswordHash = @Hash, Salt = @Salt, UpdatedDate = GETDATE() WHERE UserId = @UserId"))
                {
                    cmd.Parameters.AddWithValue("@UserId", _userId);
                    cmd.Parameters.AddWithValue("@Hash", newHash);
                    cmd.Parameters.AddWithValue("@Salt", newSalt);
                    cmd.ExecuteNonQuery();
                }

                // Clear fields
                txtCurrentPwd.Text = txtNewPwd.Text = txtConfirmPwd.Text = "";
                ShowMessage("pnlPwdMsg", "litPwdMsg", "alert-success", "Password updated successfully! Please login again.");
                Logger.Info($"User {_userId} changed password");
            }
            catch (Exception ex)
            {
                ShowMessage("pnlPwdMsg", "litPwdMsg", "alert-danger", "Failed to update password: " + ex.Message);
                Logger.Error("Password change failed", ex);
            }
            finally { Web.Models.Connection.CloseConnection(); }
        }

        // ================= NOTIFICATIONS SAVE =================
        protected void btnSaveNotif_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlCommand cmd = Web.Models.Connection.SqlQuery(
                    "UPDATE Users SET EmailNotifications = @Email, SmsNotifications = @Sms, PushNotifications = @Push, UpdatedDate = GETDATE() WHERE UserId = @UserId"))
                {
                    cmd.Parameters.AddWithValue("@UserId", _userId);
                    cmd.Parameters.AddWithValue("@Email", chkEmailNotif.Checked);
                    cmd.Parameters.AddWithValue("@Sms", chkSmsNotif.Checked);
                    cmd.Parameters.AddWithValue("@Push", chkPushNotif.Checked);

                    cmd.ExecuteNonQuery();
                }
                ShowMessage("pnlNotifMsg", "litNotifMsg", "alert-success", "Notification preferences updated!");
            }
            catch (Exception ex)
            {
                ShowMessage("pnlNotifMsg", "litNotifMsg", "alert-danger", "Failed to save preferences: " + ex.Message);
                Logger.Error("Notification save failed", ex);
            }
            finally { Web.Models.Connection.CloseConnection(); }
        }

        // ================= PREFERENCES SAVE =================
        protected void btnSavePrefs_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlCommand cmd = Web.Models.Connection.SqlQuery(
                    "UPDATE Users SET Language = @Lang, DisplayCurrency = @Currency, UpdatedDate = GETDATE() WHERE UserId = @UserId"))
                {
                    cmd.Parameters.AddWithValue("@UserId", _userId);
                    cmd.Parameters.AddWithValue("@Lang", ddlLanguage.SelectedValue);
                    cmd.Parameters.AddWithValue("@Currency", ddlCurrency.SelectedValue);

                    cmd.ExecuteNonQuery();
                }
                ShowMessage("pnlPrefMsg", "litPrefMsg", "alert-success", "Display preferences updated!");
            }
            catch (Exception ex)
            {
                ShowMessage("pnlPrefMsg", "litPrefMsg", "alert-danger", "Failed to save preferences: " + ex.Message);
                Logger.Error("Preferences save failed", ex);
            }
            finally { Web.Models.Connection.CloseConnection(); }
        }

        // ================= HELPERS =================
        private void ShowMessage(string panelId, string litId, string alertClass, string message)
        {
            ((Panel)FindControl(panelId)).Visible = true;
            ((Literal)FindControl(litId)).Text = message;
            ClientScript.RegisterStartupScript(
                GetType(),
                "showToast",
                $"showToast('{message.Replace("'", "\\'")}', '{(alertClass.Contains("success") ? "success" : "danger")}');",
                true
            );
        }

        private string GenerateSalt()
        {
            byte[] bytes = new byte[16];
            using (var rng = RandomNumberGenerator.Create())
                rng.GetBytes(bytes);
            return Convert.ToBase64String(bytes);
        }

        private string HashPassword(string password, string salt)
        {
            using (var sha = SHA256.Create())
            {
                byte[] combined = Encoding.UTF8.GetBytes(password + salt);
                byte[] hash = sha.ComputeHash(combined);
                return Convert.ToBase64String(hash);
            }
        }

        public string ProfileMessageClass => "alert-success";
    }
}