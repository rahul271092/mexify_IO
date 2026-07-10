using System;
using System.Collections.Generic;
using System.Web.UI;
using Mexify.Business.Services;
using Mexify.Models;
using Mexify.Utilities;

namespace Mexify.Web.User
{
    public partial class Salary : System.Web.UI.Page
    {
        private SalaryService _salaryService;
        private int _userId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.IsAuthenticated || Session["UserId"] == null)
            {
                Response.Redirect(ResolveUrl("~/Web/login.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl)));
                return;
            }

            _userId = Convert.ToInt32(Session["UserId"]);
            _salaryService = new SalaryService();

            if (!IsPostBack)
            {
                LoadSalaryData();
            }
        }

        private void LoadSalaryData()
        {
            try
            {
                var master = this.Master as Mexify.Web.MasterPages.UserMaster;
                if (master != null)
                {
                    master.SetPageTitle("My Salary");
                    master.SetBreadcrumb("Salary");
                }

                var details = _salaryService.GetUserSalaryDetails(_userId);

                if (details.IsQualified)
                {
                    pnlQualified.Visible = true;
                    pnlNotQualified.Visible = false;

                    litCurrentTier.Text = details.TierCode + " - " + details.TierName;
                    litMonthlySalary.Text = details.CurrentMonthlySalary.ToString("0");
                    litRequiredSelf.Text = details.RequiredSelfInvestment.ToString("0");
                    litRequiredStrong.Text = details.RequiredStrongLeg.ToString("0");
                    litRequiredWeaker.Text = details.RequiredWeakerLeg.ToString("0");
                }
                else
                {
                    pnlQualified.Visible = false;
                    pnlNotQualified.Visible = true;

                    // Show first tier requirements
                    var firstTier = _salaryService.GetFirstTierRequirements();
                    if (firstTier != null)
                    {
                        litRequiredSelf.Text = firstTier.SelfInvestment.ToString("0");
                        litRequiredStrong.Text = firstTier.StrongLegVolume.ToString("0");
                        litRequiredWeaker.Text = firstTier.WeakerLegVolume.ToString("0");
                    }
                }

                litSelfInvestment.Text = details.SelfInvestment.ToString("0");
                litStrongLeg.Text = details.StrongLegVolume.ToString("0");
                litWeakerLeg.Text = details.WeakerLegVolume.ToString("0");
                litQualifiedDate.Text = details.QualifiedDate.HasValue
                    ? details.QualifiedDate.Value.ToString("MMM dd, yyyy")
                    : "--";

                // Stats
                var stats = _salaryService.GetUserSalaryStats(_userId);
                litTotalEarned.Text = "$" + stats.TotalEarned.ToString("0");
                litPaymentsReceived.Text = stats.PaymentsCount.ToString();

                // Next payment date
                var today = DateTime.UtcNow;
                var nextPayment = today.Day < 15
                    ? new DateTime(today.Year, today.Month, 15)
                    : new DateTime(today.Year, today.Month, DateTime.DaysInMonth(today.Year, today.Month));
                litNextPayment.Text = nextPayment.ToString("MMM dd");

                // Recent salaries
                var recentSalaries = _salaryService.GetUserSalaryHistory(_userId, 5);
                if (recentSalaries != null && recentSalaries.Count > 0)
                {
                    rptRecentSalaries.DataSource = recentSalaries;
                    rptRecentSalaries.DataBind();
                    pnlNoRecentSalaries.Visible = false;
                }
                else
                {
                    pnlNoRecentSalaries.Visible = true;
                }

                // All tiers
                var allTiers = _salaryService.GetAllTiersWithUserStatus(_userId);
                if (allTiers != null && allTiers.Count > 0)
                {
                    rptAllTiers.DataSource = allTiers;
                    rptAllTiers.DataBind();
                }

                // Next tiers progress
                var nextTiers = _salaryService.GetNextTierProgress(_userId);
                if (nextTiers != null && nextTiers.Count > 0)
                {
                    rptNextTiers.DataSource = nextTiers;
                    rptNextTiers.DataBind();
                    pnlNoProgress.Visible = false;
                }
                else
                {
                    pnlNoProgress.Visible = true;
                }

                // Full history
                var fullHistory = _salaryService.GetUserSalaryHistory(_userId, 100);
                if (fullHistory != null && fullHistory.Count > 0)
                {
                    rptSalaryHistory.DataSource = fullHistory;
                    rptSalaryHistory.DataBind();
                    pnlNoHistory.Visible = false;
                }
                else
                {
                    pnlNoHistory.Visible = true;
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Salary page load failed for user " + _userId, ex);
            }
        }
    }
}