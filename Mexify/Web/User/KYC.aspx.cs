using System;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Mexify.Business.Services;
using Mexify.Models;
using Mexify.Utilities;
using Mexify.DataAccess.Repositories;

namespace Mexify.Web.User
{
    public partial class KYC : System.Web.UI.Page
    {
        private KYCService _kycService;
        private int _userId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Web/meta-login.aspx");
                return;
            }

            _userId = Convert.ToInt32(Session["UserId"]);
            _kycService = new KYCService();

            if (!IsPostBack)
            {
                LoadKYCStatus();
            }
        }

        private void LoadKYCStatus()
        {
            try
            {
                var kyc = _kycService.GetUserKYC(_userId);

                if (kyc == null)
                {
                    // No KYC started - pre-fill from user profile
                    PreFillUserInfo();
                    UpdateStatusBanner("not-started", "Verification Not Started",
                        "Complete the steps below to verify your identity and unlock full access to deposits, withdrawals, and trading.");
                    return;
                }

                hfKYCId.Value = kyc.KYCId.ToString();

                switch (kyc.Status)
                {
                    case 0: // Pending
                        UpdateStatusBanner("pending", "Verification In Progress",
                            "Your documents are being reviewed. This usually takes 24-48 hours. We'll notify you by email once complete.");
                        DisableForm();
                        break;

                    case 1: // Approved
                        UpdateStatusBanner("approved", "Verification Approved ✓",
                            "Congratulations! Your identity has been verified. You now have full access to all platform features including withdrawals.");
                        DisableForm();
                        break;

                    case 2: // Rejected
                        UpdateStatusBanner("rejected", "Verification Rejected",
                            "Unfortunately, we could not verify your identity with the provided documents. Please review the reason below and resubmit.");
                        pnlRejectionReason.Visible = true;
                        litRejectionReason.Text = kyc.RejectionReason ?? "Documents were unclear or did not meet requirements.";
                        PreFillFromExisting(kyc);
                        break;

                    default:
                        PreFillUserInfo();
                        break;
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load KYC status for user " + _userId, ex);
                ShowError("Failed to load KYC status. Please try again.");
            }
        }

        private void PreFillUserInfo()
        {
            try
            {
                var authService = new AuthService();
                var user = authService.GetUserById(_userId);
                if (user != null)
                {
                    txtFirstName.Text = user.FirstName;
                    txtLastName.Text = user.LastName;
                    txtPhone.Text = user.Phone ?? "";
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to prefill user info", ex);
            }
        }

        private void PreFillFromExisting(KYCVerification kyc)
        {
            txtFirstName.Text = kyc.FirstName;
            txtLastName.Text = kyc.LastName;
            txtDOB.Text = kyc.DateOfBirth.HasValue ? kyc.DateOfBirth.Value.ToString("yyyy-MM-dd") : "";
            txtAddress.Text = kyc.Address;
            txtCity.Text = kyc.City;
            txtState.Text = kyc.State;
            txtPostalCode.Text = kyc.PostalCode;
            txtPhone.Text = kyc.Phone;

            try
            {
                ddlNationality.SelectedValue = kyc.Nationality;
                ddlOccupation.SelectedValue = kyc.Occupation ?? "";
                hfDocType.Value = kyc.DocumentType ?? "passport";
            }
            catch { }
        }

        private void UpdateStatusBanner(string statusClass, string title, string message)
        {
            var banner = FindControl("statusBanner") as System.Web.UI.HtmlControls.HtmlGenericControl;
            var icon = FindControl("statusIcon") as System.Web.UI.HtmlControls.HtmlGenericControl;

            litStatusTitle.Text = title;
            litStatusMessage.Text = message;

            // Use JavaScript to update the classes dynamically
            string script = $@"
                document.getElementById('statusBanner').className = 'kyc-status-banner {statusClass}';
                document.getElementById('statusIcon').className = 'status-icon {statusClass}';
            ";
            ScriptManager.RegisterStartupScript(this, GetType(), "statusUpdate", script, true);
        }

        private void DisableForm()
        {
            txtFirstName.Enabled = false;
            txtLastName.Enabled = false;
            txtDOB.Enabled = false;
            ddlNationality.Enabled = false;
            txtAddress.Enabled = false;
            txtCity.Enabled = false;
            txtState.Enabled = false;
            txtPostalCode.Enabled = false;
            txtPhone.Enabled = false;
            ddlOccupation.Enabled = false;
            fuIdFront.Enabled = false;
            fuIdBack.Enabled = false;
            fuSelfie.Enabled = false;
            fuProofOfAddress.Enabled = false;
            btnSubmit.Enabled = false;
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            HideAllMessages();

            try
            {
                // Validate all fields
                if (string.IsNullOrWhiteSpace(txtFirstName.Text) ||
                    string.IsNullOrWhiteSpace(txtLastName.Text) ||
                    string.IsNullOrWhiteSpace(txtDOB.Text) ||
                    string.IsNullOrWhiteSpace(ddlNationality.SelectedValue) ||
                    string.IsNullOrWhiteSpace(txtAddress.Text) ||
                    string.IsNullOrWhiteSpace(txtCity.Text) ||
                    string.IsNullOrWhiteSpace(txtPostalCode.Text) ||
                    string.IsNullOrWhiteSpace(txtPhone.Text))
                {
                    ShowError("Please fill in all required fields.");
                    return;
                }

                // Validate file uploads
                if (!fuIdFront.HasFile || !fuIdBack.HasFile || !fuSelfie.HasFile)
                {
                    ShowError("Please upload all required documents (ID front, back, and selfie).");
                    return;
                }

                // Validate file sizes (5MB max)
                const int maxSize = 5 * 1024 * 1024;
                if (fuIdFront.PostedFile.ContentLength > maxSize ||
                    fuIdBack.PostedFile.ContentLength > maxSize ||
                    fuSelfie.PostedFile.ContentLength > maxSize ||
                    (fuProofOfAddress.HasFile && fuProofOfAddress.PostedFile.ContentLength > maxSize))
                {
                    ShowError("Each file must be less than 5MB.");
                    return;
                }

                // Validate file types
                string[] allowedTypes = { "image/jpeg", "image/png", "image/jpg", "application/pdf" };
                if (!IsValidFileType(fuIdFront.PostedFile.ContentType) ||
                    !IsValidFileType(fuIdBack.PostedFile.ContentType) ||
                    !IsValidFileType(fuSelfie.PostedFile.ContentType))
                {
                    ShowError("Invalid file type. Please upload JPG, PNG, or PDF files only.");
                    return;
                }

                // Create KYC object
                var kyc = new KYCVerification
                {
                    UserId = _userId,
                    FirstName = txtFirstName.Text.Trim(),
                    LastName = txtLastName.Text.Trim(),
                    DateOfBirth = DateTime.Parse(txtDOB.Text),
                    Nationality = ddlNationality.SelectedValue,
                    Address = txtAddress.Text.Trim(),
                    City = txtCity.Text.Trim(),
                    State = txtState.Text.Trim(),
                    PostalCode = txtPostalCode.Text.Trim(),
                    Phone = txtPhone.Text.Trim(),
                    Occupation = ddlOccupation.SelectedValue,
                    DocumentType = hfDocType.Value,
                    Status = 0, // Pending
                    SubmittedDate = DateTime.UtcNow
                };

                // Save files
                string uploadFolder = Server.MapPath("~/Uploads/KYC/" + _userId + "/");
                if (!Directory.Exists(uploadFolder))
                    Directory.CreateDirectory(uploadFolder);

                kyc.IdFrontPath = SaveFile(fuIdFront, uploadFolder, "id_front");
                kyc.IdBackPath = SaveFile(fuIdBack, uploadFolder, "id_back");
                kyc.SelfiePath = SaveFile(fuSelfie, uploadFolder, "selfie");

                if (fuProofOfAddress.HasFile)
                    kyc.ProofOfAddressPath = SaveFile(fuProofOfAddress, uploadFolder, "proof_address");

                // Save to database
               int kycId = _kycService.SubmitKYC(kyc);

                if (kycId > 0)
                {
                    // Update user's KYC status
                    var authService = new AuthService();
                    authService.UpdateUserKYCStatus(_userId, 0); // 0 = Pending

                    // Log activity
                    string ipAddress = Request.ServerVariables["REMOTE_ADDR"] ?? "unknown";
                    _kycService.LogActivity(_userId, "KYC_SUBMITTED",
                        "KYC verification submitted", ipAddress);

                    ShowSuccess("Your KYC application has been submitted successfully! We'll review your documents within 24-48 hours and notify you by email.");
                    DisableForm();
                    UpdateStatusBanner("pending", "Verification In Progress",
                        "Your documents are being reviewed. This usually takes 24-48 hours.");
                }
                else
                {
                    ShowError("Failed to submit KYC. Please try again.");
                }
            }
            catch (Exception ex)
            {
                Logger.Error("KYC submission failed for user " + _userId, ex);
                ShowError("An error occurred: " + ex.Message);
            }
        }

        private string SaveFile(FileUpload fu, string folder, string prefix)
        {
            string extension = Path.GetExtension(fu.FileName).ToLower();
            string fileName = prefix + "_" + DateTime.UtcNow.Ticks + extension;
            string fullPath = Path.Combine(folder, fileName);
            fu.SaveAs(fullPath);
            return "~/Uploads/KYC/" + _userId + "/" + fileName;
        }

        private bool IsValidFileType(string contentType)
        {
            return contentType == "image/jpeg" ||
                   contentType == "image/jpg" ||
                   contentType == "image/png" ||
                   contentType == "application/pdf";
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

        private void HideAllMessages()
        {
            pnlError.Visible = false;
            pnlSuccess.Visible = false;
        }
    }
}