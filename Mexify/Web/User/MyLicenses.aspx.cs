using Mexify.Business.Services;
using Mexify.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Mexify.Web.User
{
    public partial class MyLicenses : System.Web.UI.Page
    {
        private LicenseService _licenseService;
        private int _userId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Web/meta-login.aspx");
                return;
            }

            _userId = Convert.ToInt32(Session["UserId"]);
            _licenseService = new LicenseService();

            if (!IsPostBack)
            {
                LoadLicenseData();
            }
            else
            {
                // Handle postback for license purchase
                string eventTarget = Request["__EVENTTARGET"] ?? "";
                string eventArg = Request["__EVENTARGUMENT"] ?? "";

                if (eventTarget == "purchaseLicense" && !string.IsNullOrEmpty(eventArg))
                {
                    int packageId;
                    if (int.TryParse(eventArg, out packageId))
                    {
                        PurchaseLicense(packageId);
                    }
                }
            }
        }

        private void LoadLicenseData()
        {
            try
            {
                // Load packages
                var packages = _licenseService.GetActivePackages();
                if (packages != null && packages.Count > 0)
                {
                    rptPackages.DataSource = packages;
                    rptPackages.DataBind();
                    pnlNoPackages.Visible = false;
                }
                else
                {
                    pnlNoPackages.Visible = true;
                }

                // Load user stats
                var stats = _licenseService.GetUserLicenseStats(_userId);

                litMyLicenseCount.Text = stats.ActiveLicenses.ToString();
                litTotalROI.Text = stats.TotalROIEarned.ToString("0.00");
                litTodayROI.Text = stats.TodayROI.ToString("0.00");
                litDailyProjection.Text = stats.DailyProjectedROI.ToString("0.00");
                litDirectIncome.Text = stats.TotalDirectIncome.ToString("0.00");

                // Load user's licenses
                if (stats.MyLicenses != null && stats.MyLicenses.Count > 0)
                {
                    rptMyLicenses.DataSource = stats.MyLicenses;
                    rptMyLicenses.DataBind();
                    pnlNoLicenses.Visible = false;
                }
                else
                {
                    pnlNoLicenses.Visible = true;
                }

                // Load commission levels
                if (stats.LevelBreakdown != null && stats.LevelBreakdown.Count > 0)
                {
                    rptCommissionLevels.DataSource = stats.LevelBreakdown;
                    rptCommissionLevels.DataBind();
                }

                // Load recent commissions
                if (stats.RecentCommissions != null && stats.RecentCommissions.Count > 0)
                {
                    rptCommissionHistory.DataSource = stats.RecentCommissions;
                    rptCommissionHistory.DataBind();
                    pnlNoCommissions.Visible = false;
                }
                else
                {
                    pnlNoCommissions.Visible = true;
                }

                // Load recent ROI
                if (stats.RecentROI != null && stats.RecentROI.Count > 0)
                {
                    rptRecentROI.DataSource = stats.RecentROI;
                    rptRecentROI.DataBind();
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Licenses page load failed for user " + _userId, ex);
            }
        }

        private void PurchaseLicense(int packageId)
        {
            HideMessages();

            try
            {
                var result = _licenseService.PurchaseLicense(_userId, packageId);

                if (result.Success)
                {
                    ShowSuccess("Congratulations! You are now a Royalty Partner! 10-level direct income has been distributed to your upline.");
                    LoadLicenseData();
                }
                else
                {
                    ShowError(result.ErrorMessage ?? "Failed to purchase license.");
                }
            }
            catch (Exception ex)
            {
                Logger.Error("License purchase failed for user " + _userId, ex);
                ShowError("An error occurred: " + ex.Message);
            }
        }

        // Helper methods
        public string GetLicenseIcon(object packageName)
        {
            if (packageName == null) return "<i class='fas fa-gem'></i>";
            string name = packageName.ToString().ToLower();
            switch (name)
            {
                case "silver": return "<i class='fas fa-medal'></i>";
                case "gold": return "<i class='fas fa-crown'></i>";
                case "platinum": return "<i class='fas fa-gem'></i>";
                default: return "<i class='fas fa-gem'></i>";
            }
        }

        public string GetLicenseColor(object packageName)
        {
            if (packageName == null) return "rgba(157, 78, 221, 0.2), rgba(0, 212, 255, 0.1)";
            string name = packageName.ToString().ToLower();
            switch (name)
            {
                case "silver": return "rgba(192, 192, 192, 0.2), rgba(192, 192, 192, 0.1)";
                case "gold": return "rgba(255, 215, 0, 0.2), rgba(255, 165, 0, 0.1)";
                case "platinum": return "rgba(229, 228, 226, 0.2), rgba(192, 192, 192, 0.1)";
                default: return "rgba(157, 78, 221, 0.2), rgba(0, 212, 255, 0.1)";
            }
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