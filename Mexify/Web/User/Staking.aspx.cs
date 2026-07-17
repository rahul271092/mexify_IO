using System;
using System.Collections.Generic;
using System.Web.UI;
using Mexify.Business.Services;
using Mexify.Models;
using Mexify.Utilities;
using System.Data.SqlClient;
using System.Data;

namespace Mexify.Web.User
{
    public partial class Staking : System.Web.UI.Page
    {
        private StakingService _stakingService;
        private UserStakingService _userstakingService;
        private int _userId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.IsAuthenticated || Session["UserId"] == null)
            {
                Response.Redirect(ResolveUrl("~/Web/login.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl)));
                return;
            }

            _userId = Convert.ToInt32(Session["UserId"]);
            _userstakingService = new UserStakingService();
            _stakingService = new StakingService();

            if (!IsPostBack)
            {
                LoadStakingData();
            }
        }

      
        private void LoadStakingData()
        {
            try
            {
                var master = this.Master as Mexify.Web.MasterPages.UserMaster;
                if (master != null)
                {
                    master.SetPageTitle("My Staking");
                    master.SetBreadcrumb("Staking");
                }

                int userId = Convert.ToInt32(Session["UserId"]);
                // Summary stats




//                var summary = _stakingService.GetUserStakingSummary(_userId);

                //using (SqlCommand cmd = Web.Models.Connection.Sql("usp_GetActiveStakingPools"))
                //{
                //    SqlDataAdapter sda = new SqlDataAdapter(cmd);
                //    DataTable dt = new DataTable();
                //    sda.Fill(dt);
                //    if(dt.Rows.Count>0)
                //    {
                //        litTotalStaked.Text = dt.Rows[0]["TotalStaked"].ToString();
                //        litTotalUSD.Text = (Decimal.Parse(dt.Rows[0]["TotalStaked"].ToString()) * 0.042m).ToString();
                //        litActiveStakes.Text=dt.Rows[0][""]
                //    }
                //}


                //    litTotalStaked.Text = summary.TotalStaked.ToString("0.00");
                //litTotalUSD.Text = (summary.TotalStaked * 0.042m).ToString("0.00");
                //litActiveStakes.Text = summary.ActiveStakes.ToString();
                //litTotalRewards.Text = summary.TotalRewards.ToString("0.00");
                //litDailyRewards.Text = summary.DailyRewards.ToString("0.00");
                //litAvgAPY.Text = summary.AverageAPY.ToString("0.00");
                //litActiveCount.Text = summary.ActiveStakes.ToString();

                // Reward stats

                //var model = _stakingService.GetUserStakingRewards(_userId, statusFilter, page, 10);

                //// Bind Summary Cards
                //litTotalStaked.Text = model.Summary.TotalStaked.ToString("N2");
                //litTotalEarned.Text = model.Summary.TotalEarned.ToString("N2");
                //litTodayEarnings.Text = model.Summary.TodayEarnings.ToString("N2");
                //litActivePlans.Text = model.Summary.ActivePlans.ToString();
                //litAvgAPY.Text = model.Summary.AverageAPY.ToString("N2") + "%";
                //litNextExpiry.Text = model.Summary.NextExpiryDate.HasValue
                //    ? model.Summary.NextExpiryDate.Value.ToString("MMM dd, yyyy")
                //    : "N/A";

                //// Bind Repeater
                //rptStakingList.DataSource = model.Investments;
                //rptStakingList.DataBind();



                //litLifetimeRewards.Text = summary.TotalRewards.ToString("0.00");
                //litMonthRewards.Text = summary.MonthRewards.ToString("0.00");
                //litPendingRewards.Text = summary.PendingRewards.ToString("0.00");

                // Available pools

                string stakingpoolsql= "select * from StakingPools order by PoolID asc";
                using (SqlCommand cmd = Web.Models.Connection.SqlQuery(stakingpoolsql))
                {
                    SqlDataAdapter sda = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();

                    sda.Fill(dt);
                    rptPools.DataSource = dt;
                    rptPools.DataBind();

                }


                StakingService _stakingService;
                _stakingService = new StakingService();
                var pools = _stakingService.GetAvailablePools();


                if (pools != null && pools.Count > 0)
                {
                    rptPools.DataSource = pools;
                    rptPools.DataBind();
                    pnlNoPools.Visible = false;
                }
                else
                {
                    pnlNoPools.Visible = true;
                }




                //    rptPools.DataSource = _stakingService.GetActivePools();
                //rptPools.DataBind();

                // Active stakes
                var activeStakes = _userstakingService.GetUserActiveStakes(_userId);
                if (activeStakes != null && activeStakes.Count > 0)
                {
                    rptActiveStakes.DataSource = activeStakes;
                    rptActiveStakes.DataBind();
                    pnlNoActive.Visible = false;
                }
                else
                {
                    pnlNoActive.Visible = true;
                }





                // History
                //var history = _userstakingService.GetUserStakingHistory(_userId);
                //if (history != null && history.Count > 0)
                //{
                //    rptHistory.DataSource = history;
                //    rptHistory.DataBind();
                //    pnlNoHistory.Visible = false;
                //}
                //else
                //{
                //    pnlNoHistory.Visible = true;
                //}

                if(Session["UserId"]!=null)
                {
                    int _userId = Int32.Parse(Session["UserId"].ToString());

                    string sql = "usp_GetUserStakingHistory";
                    using (SqlCommand cmd = Web.Models.Connection.Sql(sql))
                    {
                        cmd.Parameters.AddWithValue("@UserId", Session["UserId"]);
                        SqlDataAdapter sda = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        if(dt.Rows.Count>0)
                        {
                            rptHistory.DataSource = dt;
                            rptHistory.DataBind();
                            pnlNoHistory.Visible = false;
                        }
                        else
                        {
                            pnlNoHistory.Visible = true;
                        }

                    }

                }
                else
                {
                    Session.Abandon();
                    Session.Clear();
                    Response.Redirect("~/Web/MetaMaskLogin.aspx", false);
                }


                    // Rewards
                    var rewards = _userstakingService.GetUserRewards(_userId, 20);
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
                Logger.Error("Staking page load failed for user " + _userId, ex);
            }
        }

        public string GetCurrencyIcon(object code)
        {
            if (code == null) return "fas fa-coins";
            string c = code.ToString().ToUpper();
            switch (c)
            {
                case "PNC": return "fas fa-coins";
                case "BTC": return "fab fa-bitcoin";
                case "ETH": return "fab fa-ethereum";
                case "USDT": return "fas fa-dollar-sign";
                default: return "fas fa-coins";
            }
        }

        public string GetStatusClass(object status)
        {
            int s = 0;
            if (status != null && status != DBNull.Value) int.TryParse(status.ToString(), out s);
            if (s == 1) return "status-active";
            if (s == 2) return "status-matured";
            return "status-pending";
        }

        public string GetStatusName(object status)
        {
            int s = 0;
            if (status != null && status != DBNull.Value) int.TryParse(status.ToString(), out s);
            if (s == 1) return "Active";
            if (s == 2) return "Matured";
            return "Pending";
        }

        public string GetRewardsChartData()
        {
            try
            {
                var data = _stakingService.GetRewardsHistory(_userId, 30);
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
                var distribution = _userstakingService.GetStakeDistribution(_userId);
                var labels = new List<string>();
                var values = new List<string>();
                var colors = new List<string>();

                string[] colorPalette = { "#00FFB2", "#00D4FF", "#2563EB", "#FFD700", "#9C27B0", "#ff3b5c" };
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