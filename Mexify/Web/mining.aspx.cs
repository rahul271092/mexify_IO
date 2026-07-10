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
    public partial class mining : System.Web.UI.Page
    {
        private MiningService _service;

        protected void Page_Load(object sender, EventArgs e)
        {
            _service = new MiningService();

            if (!IsPostBack)
            {
                LoadPlans();
                PopulateContractDropdown();
                CalculateMining(null, null);
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
                Logger.Error("Failed to load mining plans", ex);
            }
        }

        private void PopulateContractDropdown()
        {
            try
            {
                var plans = _service.GetActivePlans();
                ddlContract.DataSource = plans;
                ddlContract.DataValueField = "MiningPlanId";
                ddlContract.DataTextField = "DisplayName";
                ddlContract.DataBind();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to populate contract dropdown", ex);
            }
        }

        public void CalculateMining(object sender, EventArgs e)
        {
            try
            {
                int contracts;
                int planId;
                decimal rewardPrice;

                int.TryParse(txtContracts.Text, out contracts);
                int.TryParse(ddlContract.SelectedValue, out planId);
                decimal.TryParse(txtRewardPrice.Text, out rewardPrice);

                if (contracts <= 0) contracts = 1;
                if (rewardPrice <= 0) rewardPrice = 57500;

                var plan = _service.GetPlanById(planId);
                if (plan == null) return;

                // Calculate daily revenue in PNC
                decimal dailyRewardCurrency = plan.ExpectedDailyReward * contracts;
                decimal dailyRevenuePNC = dailyRewardCurrency * rewardPrice;
                decimal dailyCostPNC = plan.MaintenanceFee * contracts;
                decimal dailyProfitPNC = dailyRevenuePNC - dailyCostPNC;

                decimal totalRevenue = dailyRevenuePNC * plan.DurationDays;
                decimal totalCost = plan.Price * contracts + (dailyCostPNC * plan.DurationDays);
                decimal totalProfit = totalRevenue - totalCost;
                decimal roiPercent = totalCost > 0 ? (totalProfit / totalCost) * 100 : 0;
                int breakEvenDays = dailyProfitPNC > 0 ? (int)Math.Ceiling((plan.Price * contracts) / dailyProfitPNC) : 0;

                litTotalProfit.Text = totalProfit.ToString("0.00") + " PNC";
                litROI.Text = roiPercent.ToString("0.00") + "%";
                litDailyRevenue.Text = dailyRevenuePNC.ToString("0.00") + " PNC";
                litDailyCost.Text = dailyCostPNC.ToString("0.00") + " PNC";
                litDailyProfit.Text = dailyProfitPNC.ToString("0.00") + " PNC";
                litBreakEven.Text = breakEvenDays + " days";
            }
            catch (Exception ex)
            {
                Logger.Error("Mining calculation failed", ex);
            }
        }

        public string GetMiningIconClass(object algorithm)
        {
            if (algorithm == null || algorithm == DBNull.Value) return "mining-icon-pnc";
            string alg = algorithm.ToString().ToUpper();
            if (alg.Contains("SHA")) return "mining-icon-btc";
            if (alg.Contains("ETH") || alg.Contains("ETC")) return "mining-icon-eth";
            if (alg.Contains("PNC")) return "mining-icon-pnc";
            return "mining-icon-cloud";
        }

        public string GetMiningIcon(object algorithm)
        {
            if (algorithm == null || algorithm == DBNull.Value) return "fas fa-server";
            string alg = algorithm.ToString().ToUpper();
            if (alg.Contains("SHA")) return "fab fa-bitcoin";
            if (alg.Contains("ETH") || alg.Contains("ETC")) return "fab fa-ethereum";
            if (alg.Contains("PNC")) return "fas fa-coins";
            return "fas fa-server";
        }

        public string GetChartLabels()
        {
            try
            {
                int planId;
                int.TryParse(ddlContract.SelectedValue, out planId);
                var plan = _service.GetPlanById(planId);
                if (plan == null) return "[]";

                var labels = new List<string>();
                int steps = Math.Min(plan.DurationDays, 10);
                if (steps == 0) steps = 1;
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

        public string GetChartData()
        {
            try
            {
                int contracts;
                int planId;
                decimal rewardPrice;

                int.TryParse(txtContracts.Text, out contracts);
                int.TryParse(ddlContract.SelectedValue, out planId);
                decimal.TryParse(txtRewardPrice.Text, out rewardPrice);

                if (contracts <= 0) contracts = 1;
                if (rewardPrice <= 0) rewardPrice = 57500;

                var plan = _service.GetPlanById(planId);
                if (plan == null) return "[]";

                var data = new List<string>();
                int steps = Math.Min(plan.DurationDays, 10);
                if (steps == 0) steps = 1;
                int stepSize = plan.DurationDays / steps;

                decimal dailyRevenue = plan.ExpectedDailyReward * rewardPrice * contracts;
                decimal dailyCost = plan.MaintenanceFee * contracts;
                decimal dailyProfit = dailyRevenue - dailyCost;
                decimal cumulative = -(plan.Price * contracts); // Start with negative (investment)

                for (int i = 0; i <= steps; i++)
                {
                    decimal currentDay = i * stepSize;
                    decimal value = cumulative + (dailyProfit * currentDay);
                    data.Add(value.ToString("0.00"));
                }

                return "[" + string.Join(",", data) + "]";
            }
            catch
            {
                return "[]";
            }
        }
    }
}