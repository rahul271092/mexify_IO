using Mexify.Business.Services;
using Mexify.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Mexify.Web.User
{
    public partial class Salary3 : System.Web.UI.Page
    {
        private SalaryService _salaryService;
        private int _userId;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Get current user ID (replace with your authentication logic)
            _userId = GetCurrentUserId();

            if (_userId <= 0)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            _salaryService = new SalaryService();

            if (!IsPostBack)
            {
                LoadPageData();
            }
        }

        private void LoadPageData()
        {
            try
            {
                LoadUserSalaryDetails();
                LoadSalaryStats();
                LoadTierProgress();
                LoadAllTiers();
                LoadActivePlans();
                LoadSalaryHistory();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading salary data: " + ex.Message, "danger");
            }
        }

        private void LoadUserSalaryDetails()
        {
            var details = _salaryService.GetUserSalaryDetails(_userId);

            lblCurrentSalary.Text = $"${details.CurrentMonthlySalary:N2}";
            lblCurrentTier.Text = string.IsNullOrEmpty(details.TierName) ? "None" : details.TierName;
        }

        private void LoadSalaryStats()
        {
            var stats = _salaryService.GetUserSalaryStats(_userId);

            lblTotalEarned.Text = $"${stats.TotalEarned:N2}";
            lblPaymentsCount.Text = stats.PaymentsCount.ToString();
            lblAveragePayment.Text = $"${stats.AveragePayment:N2}";
        }

        private void LoadTierProgress()
        {
            var progressList = _salaryService.GetNextTierProgress(_userId);

            if (progressList.Any())
            {
                rptProgress.DataSource = progressList;
                rptProgress.DataBind();
                pnlNoProgress.Visible = false;
            }
            else
            {
                pnlNoProgress.Visible = true;
            }
        }

        private void LoadAllTiers()
        {
            var tiers = _salaryService.GetAllTiersWithUserStatus(_userId);

            // Get current tier ID to mark it
            var currentDetails = _salaryService.GetUserSalaryDetails(_userId);
            foreach (var tier in tiers)
            {
                tier.IsCurrentTier = (tier.TierId == currentDetails.CurrentTierId);
                tier.IsQualified = CheckTierQualification(tier, currentDetails);
            }

            rptTiers.DataSource = tiers;
            rptTiers.DataBind();
        }

        private void LoadActivePlans()
        {
            var plans = _salaryService.GetActivePlans(_userId);
            rptPlans.DataSource = plans;
            rptPlans.DataBind();
        }

        private void LoadSalaryHistory()
        {
            var history = _salaryService.GetUserSalaryHistory(_userId, 20);

            if (history.Any())
            {
                rptHistory.DataSource = history;
                rptHistory.DataBind();
                pnlNoHistory.Visible = false;
            }
            else
            {
                pnlNoHistory.Visible = true;
            }
        }



        public string GetStatusClass(string status)
        {
            switch (status)
            {
                case "1": return "pending";
                case "2": return "paid";
                case "3": return "failed";
                default: return "pending";
            }
        }

        public string GetStatusName(string status)
        {
            switch (status)
            {
                case "1": return "Pending";
                case "2": return "Paid";
                case "3": return "Failed";
                default: return "Unknown";
            }
        }

        protected void rptPlans_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Subscribe")
            {
                try
                {
                    int planId = Convert.ToInt32(e.CommandArgument);
                    var result = _salaryService.Subscribe(_userId, planId);

                    if (result.Item1)
                    {
                        ShowAlert(result.Item2, "success");
                    }
                    else
                    {
                        ShowAlert(result.Item2, "danger");
                    }

                    // Reload plans to update eligibility
                    LoadActivePlans();
                }
                catch (Exception ex)
                {
                    ShowAlert("Error subscribing to plan: " + ex.Message, "danger");
                }
            }
        }

        private bool CheckTierQualification(InvestorTier tier, UserSalaryDetails currentDetails)
        {
            return currentDetails.SelfInvestment >= tier.SelfInvestment
                && currentDetails.StrongLegVolume >= tier.StrongLegVolume
                && currentDetails.WeakerLegVolume >= tier.WeakerLegVolume;
        }

        private int GetCurrentUserId()
        {
            // TODO: Replace with your actual authentication logic
            // Example: return Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 0;
            // For now, using a hardcoded value for testing
            return 1;
        }

        private void ShowAlert(string message, string type)
        {
            pnlAlert.Visible = true;
            pnlAlert.CssClass = $"alert alert-{type} alert-dismissible fade show";
            lblAlertMessage.Text = message;
        }

        // Helper methods for status display
        //public string GetStatusClass(string status)
        //{
        //    switch (status)
        //    {
        //        case "1": return "pending";
        //        case "2": return "paid";
        //        case "3": return "failed";
        //        default: return "pending";
        //    }
        //}

        //public string GetStatusName(string status)
        //{
        //    switch (status)
        //    {
        //        case "1": return "Pending";
        //        case "2": return "Paid";
        //        case "3": return "Failed";
        //        default: return "Unknown";
        //    }
        //}

    }
}