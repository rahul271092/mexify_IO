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
    public partial class StakeNow : System.Web.UI.Page
    {
        private StakingService _stakingService;
        private WalletService _walletService;
        private int _userId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.IsAuthenticated || Session["UserId"] == null)
            {
                Response.Redirect(ResolveUrl("~/Web/login.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl)));
                return;
            }

            _userId = Convert.ToInt32(Session["UserId"]);
            _stakingService = new StakingService();
            _walletService = new WalletService();

            if (!IsPostBack)
            {
                // Handle actions from query string
                HandleActions();
               
                LoadStakingData();
                PopulateLevelCommission();

            }
        }




        public void PopulateLevelCommission()
        {
            try
            {
                string sql = "SELECT u.*, s.* FROM Users uINNER JOIN StakingCommissions s ON u.UserId = s.BeneficiaryId; ";
                SqlCommand cmd = Web.Models.Connection.SqlQuery(sql);
                SqlDataAdapter sda = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                sda.Fill(dt);
                if (dt.Rows.Count > 0)
                {
                    levelCommissionRepeater.DataSource = dt;
                    levelCommissionRepeater.DataBind();
                    Panel1.Visible = true;
                    LevelPanel1.Visible = true;
                }
                else
                {
                    LevelPanel1.Visible = true;
                    Panel1.Visible = true;
                }
                
            }
            catch(Exception ef)
            {
                Logger.Error("PopulateLevelCommission Error;", ef);
            }
        }

        //private void HandleActions()
        //{
        //    Logger.Info("Handle Actions Executed !!");
        //    string action = Request.QueryString["action"];
        //    if (string.IsNullOrEmpty(action)) return;

        //    try
        //    {
        //        switch (action.ToLower())
        //        {
        //            case "stake":
        //                int poolId = int.Parse(Request.QueryString["pool"] ?? "0");
        //                decimal amount = decimal.Parse(Request.QueryString["amount"] ?? "0");
        //                var stakeResult = _stakingService.StakeTokens(_userId, poolId, amount);
        //                if (stakeResult.Success)
        //                {
        //                    hfActiveTab.Value = "active";
        //                }
        //                else
        //                {
        //                    Logger.Error("Stake failed: " + stakeResult.ErrorMessage);
        //                }
        //                break;

        //            case "claim":
        //                long claimStakeId = long.Parse(Request.QueryString["stake"] ?? "0");
        //                var claimResult = _stakingService.ClaimRewards(_userId, claimStakeId);
        //                if (claimResult.Success)
        //                {
        //                    hfActiveTab.Value = "rewards";
        //                }
        //                break;

        //            case "unstake":
        //                long unstakeStakeId = long.Parse(Request.QueryString["stake"] ?? "0");
        //                var unstakeResult = _stakingService.UnstakeTokens(_userId, unstakeStakeId);
        //                if (unstakeResult.Success)
        //                {
        //                    hfActiveTab.Value = "history";
        //                }
        //                break;
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Logger.Error("Staking action failed", ex);
        //    }
        //}

        private void LoadStakingData()
        {
            try
            {

                Logger.Info("Load Staking Data Function Executed !!");

                var master = this.Master as Mexify.Web.MasterPages.UserMaster;
                if (master != null)
                {
                    master.SetPageTitle("Stake Now");
                    master.SetBreadcrumb("Staking");
                }

                Logger.Info("GetUserWallet Function Execution started now !!");

                // Get user's PNC balance
                 var wallet = _walletService.GetUserWallet(_userId, 6); // Assuming PNC is CurrencyId 1

                //string sql = "usp_GetUserWallets";
                //using (SqlCommand cmd = Web.Models.Connection.Sql(sql))
                //{
                //    cmd.Parameters.AddWithValue("@UserId", Session["UserId"].ToString());
                //    SqlDataReader sdr = cmd.ExecuteReader();
                //    if(sdr.HasRows && sdr.Read())
                //    {
                //        hfUserBalance.Value = sdr["Balance"].ToString();
                //    }
                //    sdr.Close();
                //}



                //    decimal balance = wallet != null ? wallet.Balance : 0;
                hfUserBalance.Value = wallet.Balance.ToString();
                
                Logger.Info("GetUserStakingStats Function execution is started now !!");

                // Stats
                var stats = _stakingService.GetUserStakingStats(_userId);
                litTotalStaked.Text = stats.TotalStaked.ToString("0.00");
                litTotalStakedUSD.Text = (stats.TotalStaked * 0.042m).ToString("0.00");
                litActiveStakes.Text = stats.ActiveStakes.ToString();
                litTotalEarned.Text = stats.TotalEarned.ToString("0.00");
                litActiveCount.Text = stats.ActiveStakes.ToString();

                // Rewards tab
                litTotalRewards.Text = stats.TotalEarned.ToString("0.00");
                litMonthRewards.Text = stats.ThisMonthEarned.ToString("0.00");
                litPendingRewards.Text = stats.PendingRewards.ToString("0.00");

                // Load pools

                //string poolQuery = "select * from StakingPools order by PlanId asc";
                //using (SqlCommand cmd= Web.Models.Connection.SqlQuery(poolQuery))
                //{
                //    SqlDataAdapter sda = new SqlDataAdapter(cmd);
                //    DataTable dt = new DataTable();
                //    sda.Fill(dt);

                //    if (dt.Rows.Count>0)
                //    {
                //        rptPools.DataSource = dt;
                //        rptPools.DataBind();
                //        pnlNoPools.Visible = false;
                //    }
                //    else
                //    {
                //        pnlNoPools.Visible = true;
                //    }
                //}


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

                // Load active stakes



                var activeStakes = _stakingService.GetActiveStakes(_userId);
                if (activeStakes != null && activeStakes.Count > 0)
                {
                    rptActiveStakes.DataSource = activeStakes;
                    rptActiveStakes.DataBind();
                    pnlNoActiveStakes.Visible = false;
                }
                else
                {
                    pnlNoActiveStakes.Visible = true;
                }

                // Load reward claims
                var claims = _stakingService.GetRewardClaims(_userId, 20);
                if (claims != null && claims.Count > 0)
                {
                    rptRewardClaims.DataSource = claims;
                    rptRewardClaims.DataBind();
                    pnlNoClaims.Visible = false;
                }
                else
                {
                    pnlNoClaims.Visible = true;
                }

                // Load history
                var history = _stakingService.GetStakingHistory(_userId, 100);
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
            }
            catch (Exception ex)
            {
                Logger.Error("StakeNow page load failed for user " + _userId, ex);
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
            switch (s)
            {
                case 1: return "status-active";
                case 2: return "status-matured";
                case 3: return "status-unstaked";
                case 4: return "status-pending";
                default: return "status-pending";
            }
        }
        private void HandleActions()
        {
            string action = Request.QueryString["action"];
            if (string.IsNullOrEmpty(action)) return;

            try
            {
                switch (action.ToLower())
                {
                    case "stake":
                        int poolId = int.Parse(Request.QueryString["pool"] ?? "0");
                        decimal amount = decimal.Parse(Request.QueryString["amount"] ?? "0");

                        // ✅ Now you can use GetPoolById to validate
                        var pool = _stakingService.GetPoolById(poolId);
                        if (pool == null)
                        {
                            Logger.Error("Invalid pool ID: " + poolId);
                            return;
                        }

                        if (!pool.IsActive)
                        {
                            Logger.Error("Pool is not active: " + poolId);
                            return;
                        }

                        if (amount < pool.MinStake)
                        {
                            Logger.Error("Amount below minimum: " + amount + " < " + pool.MinStake);
                            return;
                        }

                        var stakeResult = _stakingService.StakeTokens(_userId, poolId, amount);
                        if (stakeResult.Success)
                        {
                            hfActiveTab.Value = "active";
                        }
                        break;

                    case "claim":
                        long claimStakeId = long.Parse(Request.QueryString["stake"] ?? "0");
                        var claimResult = _stakingService.ClaimRewards(_userId, claimStakeId);
                        if (claimResult.Success)
                        {
                            hfActiveTab.Value = "rewards";
                        }
                        break;

                    case "unstake":
                        long unstakeStakeId = long.Parse(Request.QueryString["stake"] ?? "0");
                        var unstakeResult = _stakingService.UnstakeTokens(_userId, unstakeStakeId);
                        if (unstakeResult.Success)
                        {
                            hfActiveTab.Value = "history";
                        }
                        break;
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Staking action failed", ex);
            }
        }
        public string GetRewardsChartData()
        {
            try
            {
                Logger.Info("GetReward Chart Data Function Executed !!");
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
    }
}