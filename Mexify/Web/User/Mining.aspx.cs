using System;
using System.Collections.Generic;
using System.Web.UI;
using Mexify.Business.Services;
using Mexify.Models;
using Mexify.Utilities;
using System.Data.SqlClient;

namespace Mexify.Web.User
{
    public partial class Mining : System.Web.UI.Page
    {
        private MiningService _miningService;
        private int _userId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.IsAuthenticated || Session["UserId"] == null)
            {
                Response.Redirect(ResolveUrl("~/Web/MetaMaskLogin.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl)));
                return;
            }
            Logger.Info("Mining Page");
          

            if (!IsPostBack)
            {
                LoadMiningData();
            }
        }

        private void LoadMiningData()
        {
            try
            {

                _userId = Convert.ToInt32(Session["UserId"]);
                _miningService = new MiningService();
                var master = this.Master as Mexify.Web.MasterPages.UserMaster;
                if (master != null)
                {
                    master.SetPageTitle("My Mining");
                    master.SetBreadcrumb("Mining");
                }

                // Summary stats

                string sql = "usp_GetUserMiningStats";
                try
                {
                    using (SqlCommand cmd = Web.Models.Connection.Sql(sql))
                    {
                        cmd.Parameters.AddWithValue("@UserId", Session["UserId"].ToString());
                        SqlDataReader sdr = cmd.ExecuteReader();
                        if (sdr.HasRows && sdr.Read())
                        {
                            litTotalHashrate.Text = sdr["TotalHashRate"].ToString();
                            litContractCount.Text = sdr["ActiveRigs"].ToString();
                            litDailyRewards.Text = sdr["DailyEarning"].ToString();
                            litTotalEarned.Text = sdr["TotalEarned"].ToString();

                            litActiveContracts.Text = sdr["ActiveRigs"].ToString();
                            // litTotalInvested.Text = summary.TotalInvested.ToString("0.00");
                            litLifetimeRewards.Text = sdr["TotalEarned"].ToString();

                            litMonthRewards.Text = sdr["ThisMonthEarnings"].ToString();

                            litTodayRewards.Text = sdr["TodayEarnings"].ToString();


                            litActiveCount.Text = sdr["ActiveRigs"].ToString();
                        }
                        sdr.Close();
                    }
                }
                catch (Exception ex)
                {
                    Logger.Error("GetUserMiningStats Error:", ex);

                }
                var summary = _miningService.GetUserMiningSummary(_userId);
                litTotalHashrate.Text = summary.TotalHashrate.ToString("0.##");
                litContractCount.Text = summary.ActiveContracts.ToString();
                litDailyRewards.Text = summary.DailyRewards.ToString("0.00");
                litTotalEarned.Text = summary.TotalEarned.ToString("0.00");
                litActiveContracts.Text = summary.ActiveContracts.ToString();
                litTotalInvested.Text = summary.TotalInvested.ToString("0.00");
                litActiveCount.Text = summary.ActiveContracts.ToString();

                // Reward stats

                // Available contracts
                rptContracts.DataSource = _miningService.GetActiveContracts();
                rptContracts.DataBind();

                // Active contracts
                var activeContracts = _miningService.GetUserActiveContracts(_userId);
                if (activeContracts != null && activeContracts.Count > 0)
                {
                    rptActiveContracts.DataSource = activeContracts;
                    rptActiveContracts.DataBind();
                    pnlNoActive.Visible = false;
                }
                else
                {
                    pnlNoActive.Visible = true;
                }

                // History
                var history = _miningService.GetUserMiningHistory(_userId);
                if (history != null && history.Count > 0)
                {
                    rptHistory.DataSource = history;
                    rptHistory.DataBind();
                    pnlNoHistory.Visible = false;
                }
                else
                {
                    pnlNoHistory.Visible = true;
                }

                // Rewards
                var rewards = _miningService.GetUserRewards(_userId, 20);
                if (rewards != null && rewards.Count > 0)
                {
                    rptRewards.DataSource = rewards;
                    rptRewards.DataBind();
                    pnlNoRewards.Visible = false;
                }
                else
                {
                    pnlNoRewards.Visible = true;
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Mining page load failed for user " + _userId, ex);
                Logger.Info("Exception:" + ex.ToString());
            }
        }

        public string GetStatusClass(object status)
        {
            int s = 0;
            if (status != null && status != DBNull.Value) int.TryParse(status.ToString(), out s);
            if (s == 1) return "status-active";
            if (s == 2) return "status-expired";
            return "status-pending";
        }

        public string GetStatusName(object status)
        {
            int s = 0;
            if (status != null && status != DBNull.Value) int.TryParse(status.ToString(), out s);
            if (s == 1) return "Active";
            if (s == 2) return "Expired";
            return "Pending";
        }

        public string GetRewardsChartData()
        {
            try
            {
                var data = _miningService.GetRewardsHistory(_userId, 30);
                var labels = new List<string>();
                var values = new List<string>();

                foreach (var point in data)
                {
                    labels.Add("\"" + point.Date.ToString("MMM dd") + "\"");
                    values.Add(point.Value.ToString("0.00"));
                }

                return "{ labels: [" + string.Join(",", labels) + "], values: [" + string.Join(",", values) + "] }";
            }
            catch { return "{ labels: [], values: [] }"; }
        }

        public string GetDistributionData()
        {
            try
            {
                var distribution = _miningService.GetHashrateDistribution(_userId);
                var labels = new List<string>();
                var values = new List<string>();
                var colors = new List<string>();

                string[] colorPalette = { "#FFD700", "#FFA500", "#00FFB2", "#00D4FF", "#2563EB", "#9C27B0" };
                int colorIndex = 0;

                foreach (var item in distribution)
                {
                    labels.Add("\"" + item.Name + "\"");
                    values.Add(item.Value.ToString("0.00"));
                    colors.Add("\"" + colorPalette[colorIndex % colorPalette.Length] + "\"");
                    colorIndex++;
                }

                return "{ labels: [" + string.Join(",", labels) + "], values: [" + string.Join(",", values) + "], colors: [" + string.Join(",", colors) + "] }";
            }
            catch { return "{ labels: [], values: [], colors: [] }"; }
        }
    }
}