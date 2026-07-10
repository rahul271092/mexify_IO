using Mexify.Business.Services;
using Mexify.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Mexify.Web
{
    public partial class roi : System.Web.UI.Page
    {
        private InvestmentService _service;

        protected void Page_Load(object sender, EventArgs e)
        {
            _service = new InvestmentService();

            if (!IsPostBack)
            {
                LoadPlans();
                PopulatePlanDropdown();
                CalculateROI(null, null);
            }
        }

        private void LoadFAQs()
        {
            try
            {
                var cmsService = new CMSService();
               // rptFAQs.DataSource = cmsService.GetFAQsByPage("roi");
               //ptFAQs.DataBind();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load ROI FAQs", ex);
            }
        }


        private void LoadPlans()
        {
            try
            {
                rptPlans.DataSource = _service.GetActivePlans();
                rptPlans.DataBind();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load ROI plans", ex);
            }
        }

        private void PopulatePlanDropdown()
        {
            try
            {
                var plans = _service.GetActivePlans();
                ddlPlan.DataSource = plans;
                ddlPlan.DataValueField = "PlanId";
                ddlPlan.DataTextField = "DisplayName";
                ddlPlan.DataBind();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to populate plan dropdown", ex);
            }
        }

        protected void CalculateROI(object sender, EventArgs e)
        {
            try
            {
                decimal amount;
                int planId;

                decimal.TryParse(txtAmount.Text, out amount);
                int.TryParse(ddlPlan.SelectedValue, out planId);

                if (amount <= 0) return;

                var plan = _service.GetPlanById(planId);
                if (plan == null) return;

                decimal dailyProfit = amount * (plan.DailyROI / 100m);
                decimal totalProfit = dailyProfit * plan.DurationDays;
                decimal totalPayout = amount + totalProfit;
                decimal monthlyProfit = dailyProfit * 30;

                // Format as PNC
                litProfit.Text = totalProfit.ToString("0.00") + " PNC";
                litTotal.Text = totalPayout.ToString("0.00") + " PNC";
                litDaily.Text = dailyProfit.ToString("0.00") + " PNC";
                litMonthly.Text = monthlyProfit.ToString("0.00") + " PNC";
            }
            catch (Exception ex)
            {
                Logger.Error("ROI calculation failed", ex);
            }
        }

        protected string GetChartData()
        {
            try
            {
                decimal amount;
                int planId;
                decimal.TryParse(txtAmount.Text, out amount);
                int.TryParse(ddlPlan.SelectedValue, out planId);

                var plan = _service.GetPlanById(planId);
                if (plan == null) return "[]";

                var data = new List<string>();
                int steps = Math.Min(plan.DurationDays, 10);
                int stepSize = plan.DurationDays / steps;
                decimal dailyProfit = amount * (plan.DailyROI / 100m);

                for (int i = 0; i <= steps; i++)
                {
                    decimal value = amount + (dailyProfit * i * stepSize);
                    data.Add(value.ToString("0.00"));
                }

                return "[" + string.Join(",", data) + "]";
            }
            catch
            {
                return "[]";
            }
        }

        protected string GetPlanIcon(string planName)
        {
            if (planName == null) return "fas fa-star";
            planName = planName.ToLower();
            if (planName.Contains("starter")) return "fas fa-seedling";
            if (planName.Contains("silver")) return "fas fa-coins";
            if (planName.Contains("gold")) return "fas fa-trophy";
            if (planName.Contains("platinum")) return "fas fa-gem";
            if (planName.Contains("vip")) return "fas fa-crown";
            return "fas fa-star";
        }

        protected string GetRiskClass(object riskLevel)
        {
            int level = 1;
            if (riskLevel != null && riskLevel != DBNull.Value)
            {
                int.TryParse(riskLevel.ToString(), out level);
            }

            if (level == 1) return "risk-low";
            if (level == 2) return "risk-medium";
            return "risk-high";
        }

        protected string GetRiskLabel(object riskLevel)
        {
            int level = 1;
            if (riskLevel != null && riskLevel != DBNull.Value)
            {
                int.TryParse(riskLevel.ToString(), out level);
            }

            if (level == 1) return "Low";
            if (level == 2) return "Medium";
            return "High";
        }

        protected string GetChartLabels()
        {
            try
            {
                int planId;
                int.TryParse(ddlPlan.SelectedValue, out planId);
                var plan = _service.GetPlanById(planId);
                if (plan == null) return "[]";

                var labels = new List<string>();
                int steps = Math.Min(plan.DurationDays, 10);
                int stepSize = plan.DurationDays / steps;

                for (int i = 0; i <= steps; i++)
                {
                    labels.Add(string.Format("\"Day {0}\"", i * stepSize));
                }

                return "[" + string.Join(",", labels) + "]";
            }
            catch
            {
                return "[]";
            }
        }

        
    }
}