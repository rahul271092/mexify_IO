using Mexify.Business.Services;
using Mexify.Utilities;
using System;
using System.Collections.Generic;
using Mexify.Web.Models;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

namespace Mexify.Web
{
    public partial class staking : System.Web.UI.Page
    {
        private StakingService _service;
        protected void Page_Load(object sender, EventArgs e)
        {
            _service = new StakingService();


            if (!IsPostBack)
            {
                LoadPools();
                PopulatePoolDropdown();
                CalculateStaking(null, null);
            }
        }

        private void LoadPools()
        {
            try
            {
                rptPools.DataSource = _service.GetActivePools();
                rptPools.DataBind();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load staking pools", ex);
            }
        }

        private void PopulatePoolDropdown()
        {
            try
            {
                var pools = _service.GetActivePools();
                string sql = "usp_GetStakingPools";
                try
                {
                    using (SqlCommand cmd = Web.Models.Connection.SqlQuery(sql))
                    {
                        SqlDataAdapter sda = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        ddlPool.DataSource = dt;
                        ddlPool.DataTextField = "PoolName";
                        ddlPool.DataValueField = "PoolId";
                        ddlPool.DataBind();

                    }

                }
                catch (Exception ex)
                {
                    Logger.Error("Staking Pool Error:", ex);

                }
                finally
                {
                    Web.Models.Connection.CloseConnection();
                }

              
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to populate pool dropdown", ex);
            }
        }

        public void CalculateStaking(object sender, EventArgs e)
        {
            decimal amount,dailyRate,dailyReward;
            int days;
            int poolId;
            decimal weeklyReward = 0;
            decimal monthlyReward =0;
            decimal yearlyReward = 0;
            decimal totalReward = 0;
            string currency = string.Empty;
            dailyRate = 0;
            dailyReward=0;
            try
            {

                decimal.TryParse(txtStakeAmount.Text, out amount);
                int.TryParse(txtDays.Text, out days);
                int.TryParse(ddlPool.SelectedValue, out poolId);

              
                if (amount <= 0 || days <= 0) return;

                var pool = _service.GetPoolById(poolId);


                try
                {

                    string sql = "usp_GetStakingPoolById";
                    using (SqlCommand cmd = Web.Models.Connection.Sql(sql))
                    {

                        cmd.Parameters.AddWithValue("@StakingPlanId", Int32.Parse(ddlPool.SelectedValue.ToString()));
                        SqlDataReader sdr = cmd.ExecuteReader();
                        if (sdr.HasRows)
                        {
                            sdr.Read();

                           
                             dailyRate = Decimal.Parse(sdr["APY"].ToString());
                            dailyReward = amount * dailyRate;
                             dailyReward = amount * dailyRate;
                            totalReward = dailyReward * Decimal.Parse( days.ToString());
                             weeklyReward = dailyReward * 7;
                             monthlyReward = dailyReward * 30;
                             yearlyReward = dailyReward * 365;









                            // currency = sdr["CurrencyCode"].ToString() ?? "USDT";

                            currency = "USDT";

                            litReward.Text = totalReward.ToString("0.####") + " " + currency;
                            litAPY.Text = sdr["APY"].ToString() + "%";

                            litDaily.Text = dailyReward.ToString("0.####");
                            litDailyCurrency.Text = currency;

                            litWeekly.Text = weeklyReward.ToString("0.####");
                            litWeeklyCurrency.Text = currency;

                            litMonthly.Text = monthlyReward.ToString("0.####");
                            litMonthlyCurrency.Text = currency;

                            litYearly.Text = yearlyReward.ToString("0.####");
                            litYearlyCurrency.Text = currency;

                        }
                    }
                }
                catch(Exception ef)
                {
                    Logger.Error("Staking Error:", ef);
                }
                finally
                {
                    Models.Connection.CloseConnection();
                }


              //  APY calculation: (amount * APY / 100 * days / 365)
                //decimal dailyRate = pool.APY / 100m / 365m;
                //decimal dailyReward = amount * dailyRate;
                //decimal totalReward = dailyReward * days;
                //decimal weeklyReward = dailyReward * 7;
                //decimal monthlyReward = dailyReward * 30;
                //decimal yearlyReward = dailyReward * 365;

                // Format as PNC (or the pool's currency)

            }
            catch (Exception ex)
            {
                Logger.Error("Staking calculation failed", ex);
            }
        }

        public  string GetCryptoClass(object code)
        {
            if (code == null) return "crypto-pnc";
            string c = code.ToString().ToUpper();
            switch (c)
            {
                case "PNC": return "crypto-pnc";
                case "BTC": return "crypto-btc";
                case "ETH": return "crypto-eth";
                case "USDT": return "crypto-usdt";
                case "SOL": return "crypto-sol";
                default: return "crypto-pnc";
            }
        }

        public string GetCryptoIcon(object code)
        {
            if (code == null) return "fas fa-coins";
            string c = code.ToString().ToUpper();
            switch (c)
            {
                case "PNC": return "fas fa-coins";
                case "BTC": return "fab fa-bitcoin";
                case "ETH": return "fab fa-ethereum";
                case "USDT": return "fas fa-dollar-sign";
                case "SOL": return "fas fa-sun";
                default: return "fas fa-coins";
            }
        }

        public  string GetChartLabels()
        {
            try
            {
                int days;
                days = Int32.Parse(txtDays.Text.ToString());
//                int.TryParse(txtDays.Text, out days);
                if (days <= 0) days = 90;

                var labels = new List<string>();
                int steps = Math.Min(days, 10);
                int stepSize = days / steps;

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

        public  string GetChartData()
        {
            try
            {
                decimal amount;
                int days;
                int poolId;
                amount = Decimal.Parse(txtStakeAmount.Text.ToString());
                decimal.TryParse(txtStakeAmount.Text, out amount);
                int.TryParse(txtDays.Text, out days);
                int.TryParse(ddlPool.SelectedValue, out poolId);

                var pool = _service.GetPoolById(poolId);
                if (pool == null) return "[]";

                var data = new List<string>();
                int steps = Math.Min(days, 10);
                int stepSize = days / steps;
                decimal dailyRate = pool.APY / 100m / 365m;

                for (int i = 0; i <= steps; i++)
                {
                    decimal currentDay = i * stepSize;
                    decimal value = amount + (amount * dailyRate * currentDay);
                    data.Add(value.ToString("0.####"));
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