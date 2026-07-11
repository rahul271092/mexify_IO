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
    public partial class Mmining : System.Web.UI.Page
    {
        private  MiningService _miningService;
        private int _userId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Web/meta-login.aspx");
                return;
            }

            _userId = Convert.ToInt32(Session["UserId"]);
            _miningService = new MiningService();

            if (!IsPostBack)
            {
                LoadMiningData();
            }
        }

        private void LoadMiningData()
        {
            try
            {
                // Get mining stats
                var stats = _miningService.GetUserMiningStats(_userId);
                
                litTotalHashrate.Text = stats.TotalHashrate.ToString("0.00");
                litDailyEarning.Text = stats.DailyEarning.ToString("0.0000");
                litActiveRigs.Text = stats.ActiveRigs.ToString();
                litTotalEarned.Text = stats.TotalEarned.ToString("0.0000");
                litTodayEarnings.Text = stats.TodayEarnings.ToString("0.0000");
                litPendingPayout.Text =  stats.PendingPayout.ToString();
                litRigCount.Text = stats.ActiveRigs.ToString();

                // Load active rigs
                var rigs = _miningService.GetUserMiningContracts(_userId);
                if (rigs != null && rigs.Count > 0)
                {
                    rptRigs.DataSource = rigs;
                    rptRigs.DataBind();
                    pnlNoRigs.Visible = false;
                }
                else
                {
                    pnlNoRigs.Visible = true;
                }

                // Load mining plans
                var plans = _miningService.GetActiveMiningPlans();
                if (plans != null && plans.Count > 0)
                {
                    rptPlans.DataSource = plans;
                    rptPlans.DataBind();
                    pnlNoPlans.Visible = false;
                }
                else
                {
                    pnlNoPlans.Visible = true;
                }

                // Load earnings history
                var earnings = _miningService.GetUserMiningEarnings(_userId, 50);
                if (earnings != null && earnings.Count > 0)
                {
                    rptEarnings.DataSource = earnings;
                    rptEarnings.DataBind();
                    pnlNoEarnings.Visible = false;

                    // Calculate summary stats
                    litLifetimeEarnings.Text = stats.TotalEarned.ToString("0.0000");
                    litMonthEarnings.Text = stats.ThisMonthEarnings.ToString("0.0000");
                    litTotalPayouts.Text = earnings.Count.ToString();
                }
                else
                {
                    pnlNoEarnings.Visible = true;
                    litLifetimeEarnings.Text = "0.0000";
                    litMonthEarnings.Text = "0.0000";
                    litTotalPayouts.Text = "0";
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Mining page load failed for user " + _userId, ex);
            }
        }

        // Helper Methods for Repeaters
        public string GetRigStatusClass(object status)
        {
            int s = 0;
            if (status != null && status != DBNull.Value) int.TryParse(status.ToString(), out s);
            switch (s)
            {
                case 1: return "mining";
                case 2: return "expired";
                case 3: return "stopped";
                default: return "stopped";
            }
        }

        public string GetRigStatusName(object status)
        {
            int s = 0;
            if (status != null && status != DBNull.Value) int.TryParse(status.ToString(), out s);
            switch (s)
            {
                case 1: return "Active Mining";
                case 2: return "Contract Expired";
                case 3: return "Stopped";
                default: return "Unknown";
            }
        }

        public string GetRigIcon(object planName)
        {
            if (planName == null) return "fas fa-server";
            string name = planName.ToString().ToLower();
            if (name.Contains("asic")) return "fas fa-microchip";
            if (name.Contains("gpu")) return "fas fa-desktop";
            if (name.Contains("eth")) return "fab fa-ethereum";
            if (name.Contains("btc")) return "fab fa-bitcoin";
            return "fas fa-server";
        }

        public string GetEarningStatusClass(object status)
        {
            int s = 0;
            if (status != null && status != DBNull.Value) int.TryParse(status.ToString(), out s);
            switch (s)
            {
                case 1: return "status-completed";
                case 0: return "status-pending";
                case 2: return "status-failed";
                default: return "status-pending";
            }
        }

        public string GetTxHashShort(object txHash)
        {
            if (txHash == null || string.IsNullOrEmpty(txHash.ToString())) return "—";
            string hash = txHash.ToString();
            return hash.Length > 10 ? hash.Substring(0, 10) + "..." : hash;
        }

        // Chart Data Methods
        public string GetMiningChartData()
        {
            try
            {
                var data = _miningService.GetMiningPerformanceHistory(_userId, 30);
                var labels = new List<string>();
                var values = new List<string>();

                foreach (var point in data)
                {
                    labels.Add("\"" + point.Date.ToString("MMM dd") + "\"");
                    values.Add(point.Value.ToString("0.0000"));
                }

                return "{ labels: [" + string.Join(",", labels) + "], values: [" + string.Join(",", values) + "] }";
            }
            catch
            {
                return "{ labels: [], values: [] }";
            }
        }

        public string GetRigDistributionData()
        {
            try
            {
                var rigs = _miningService.GetUserMiningContracts(_userId);
                var grouped = new Dictionary<string, decimal>();
                
                foreach (var rig in rigs)
                {
                    if (rig.Status == 1) // Active only
                    {
                        string name = rig.PlanName ?? "Other";
                        if (!grouped.ContainsKey(name))
                            grouped[name] = 0;
                        grouped[name] += rig.Hashrate;
                    }
                }

                var labels = new List<string>();
                var values = new List<string>();
                var colors = new List<string>();
                string[] colorPalette = { "#C77DFF", "#9D4EDD", "#7B2CBF", "#FFD700", "#00FFB2", "#00D4FF" };
                int i = 0;

                foreach (var kvp in grouped)
                {
                    labels.Add("\"" + kvp.Key + "\"");
                    values.Add(kvp.Value.ToString("0.00"));
                    colors.Add("\"" + colorPalette[i % colorPalette.Length] + "\"");
                    i++;
                }

                return "{ labels: [" + string.Join(",", labels) + "], values: [" + string.Join(",", values) + "], colors: [" + string.Join(",", colors) + "] }";
            }
            catch
            {
                return "{ labels: [], values: [], colors: [] }";
            }
        }
    }
}