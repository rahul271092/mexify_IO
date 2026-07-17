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
    public partial class Salary2 : System.Web.UI.Page
    {
        private readonly SalaryService _salaryService = new SalaryService();
        private int _userId => Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (_userId <= 0)
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadSalaryData();
            }
        }

        private void LoadSalaryData()
        {
            try
            {
                // Set master page header
                var master = this.Master as Mexify.Web.MasterPages.UserMaster;
                if (master != null)
                {
                    master.SetPageTitle("My Salary");
                    master.SetBreadcrumb("Salary");
                }

                // ============================================
                // 1. GET USER SALARY DETAILS (qualification check)
                // ============================================
                var details = _salaryService.GetUserSalaryDetails(_userId);

                if (details.IsQualified)
                {
                    // ✅ USER IS QUALIFIED
                    pnlQualified.Visible = true;
                    pnlNotQualified.Visible = false;

                    litCurrentTier.Text = details.TierCode + " - " + details.TierName;
                    litMonthlySalary.Text = details.CurrentMonthlySalary.ToString("N0");

                    lblQualifiedBadge.Text = "<i class='fas fa-check-circle'></i> Qualified: " + details.TierName;
                    lblQualifiedBadge.CssClass = "badge bg-success fs-6 px-3 py-2";
                }
                else
                {
                    // ❌ USER IS NOT QUALIFIED
                    pnlQualified.Visible = false;
                    pnlNotQualified.Visible = true;

                    // Show first tier requirements if user has no tier yet
                    var firstTier = _salaryService.GetFirstTierRequirements();
                    if (firstTier != null)
                    {
                        litRequiredSelf.Text = "$" + firstTier.SelfInvestment.ToString("N0");
                        litRequiredStrong.Text = "$" + firstTier.StrongLegVolume.ToString("N0");
                        litRequiredWeaker.Text = "$" + firstTier.WeakerLegVolume.ToString("N0");
                    }
                    else
                    {
                        litRequiredSelf.Text = "$" + details.RequiredSelfInvestment.ToString("N0");
                        litRequiredStrong.Text = "$" + details.RequiredStrongLeg.ToString("N0");
                        litRequiredWeaker.Text = "$" + details.RequiredWeakerLeg.ToString("N0");
                    }

                    lblQualifiedBadge.Text = "<i class='fas fa-lock'></i> Not Qualified";
                    lblQualifiedBadge.CssClass = "badge bg-warning text-dark fs-6 px-3 py-2";

                    // Show what user currently has
                    litSelfInvestment.Text = "$" + details.SelfInvestment.ToString("N0");
                    litStrongLeg.Text = "$" + details.StrongLegVolume.ToString("N0");
                    litWeakerLeg.Text = "$" + details.WeakerLegVolume.ToString("N0");

                    // Show what's missing
                    if (Int32.Parse( details.SelfMissing.ToString()) > 0)
                    {
                        pnlSelfMissing.Visible = true;
                        litSelfMissing.Text = "$" + details.SelfMissing.ToString();
                    }
                    else pnlSelfMissing.Visible = false;

                    if (details.StrongMissing > 0)
                    {
                        pnlStrongMissing.Visible = true;
                        litStrongMissing.Text = "$" + details.StrongMissing.ToString();
                    }
                    else pnlStrongMissing.Visible = false;

                    if (details.WeakerMissing > 0)
                    {
                        pnlWeakerMissing.Visible = true;
                        litWeakerMissing.Text = "$" + details.WeakerMissing.ToString("N0");
                    }
                    else pnlWeakerMissing.Visible = false;
                }

                // Qualified date
                litQualifiedDate.Text = details.QualifiedDate.HasValue
                    ? details.QualifiedDate.Value.ToString("MMM dd, yyyy")
                    : "Not yet";

                // ============================================
                // 2. GET SALARY STATS
                // ============================================
                var stats = _salaryService.GetUserSalaryStats(_userId);
                litTotalEarned.Text = "$" + stats.TotalEarned.ToString("N0");
                litPaymentsReceived.Text = stats.PaymentsCount.ToString();

                // Next payment date (15th or last day of month)
                var today = DateTime.UtcNow;
                var nextPayment = today.Day < 15
                    ? new DateTime(today.Year, today.Month, 15)
                    : new DateTime(today.Year, today.Month, DateTime.DaysInMonth(today.Year, today.Month));
                litNextPayment.Text = nextPayment.ToString("MMM dd");

                // ============================================
                // 3. RECENT SALARIES (last 5)
                // ============================================
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

                // ============================================
                // 4. ALL TIERS WITH USER STATUS
                // ============================================
                var allTiers = _salaryService.GetAllTiersWithUserStatus(_userId);
                if (allTiers != null && allTiers.Count > 0)
                {
                    rptAllTiers.DataSource = allTiers;
                    rptAllTiers.DataBind();
                }

                // ============================================
                // 5. NEXT TIER PROGRESS
                // ============================================
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

                // ============================================
                // 6. FULL SALARY HISTORY (last 100)
                // ============================================
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

                // Show friendly error
                pnlQualified.Visible = false;
                pnlNotQualified.Visible = true;
            }
        }
    }
}