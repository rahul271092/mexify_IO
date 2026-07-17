using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.Script.Serialization;
using Mexify.Business.Services;
using Mexify.DataAccess.Repositories;
using Mexify.Models;
using Mexify.Utilities;
using Mexify.Web.Models;
using System.Data.SqlClient;
using System.Data;

namespace Mexify.Web.User
{
    public partial class Dashboard : System.Web.UI.Page
    {
        private DashboardService _dashboardService;
        private int _userId;

        protected void Page_Load(object sender, EventArgs e)
        {
            // ✅ FIX: Use correct case "UserId"
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Web/login.aspx", false);
                return;
            }

            if (!IsPostBack)
            {
                _userId = Convert.ToInt32(Session["UserId"]);
                _dashboardService = new DashboardService();

                // Check entry fee status (optional, adjust logic as needed)
                if (Session["EntryFee"] != null && Session["EntryFee"].ToString() == "0")
                {
                    pnlEntryFeeModal.Visible = true;
                }

                try
                {
                    LoadDashboardData();
                }
                catch (System.Data.SqlClient.SqlException sqlEx)
                {
                    Logger.Error("Load Dashboard Data SQL Error: ", sqlEx);
                    Response.Write("<div style='color:red; padding:20px; background:#fff;'><b>SQL ERROR:</b> " + sqlEx.Message + "</div>");
                    Response.End();
                }
                catch (Exception ex)
                {
                    Logger.Error("Load Dashboard Data General Error: ", ex);
                    Response.Write("<div style='color:red; padding:20px; background:#fff;'><b>GENERAL ERROR:</b> " + ex.Message + "</div>");
                    Response.End();
                }
            }
        }


        public void LoadRecentTransaction(int UserId,int count)
        {
            try
            {

                //var walletService = new WalletService();
                //// ✅ FIX: Use the service method instead of broken raw SQL
                //var transactions = walletService.GetUserTransactions(_userId, 10);
                //if(walletService!=null)
                //{
                //    rptTransactions.DataSource = transactions;
                //    rptTransactions.DataBind();
                //    pnlNoTransactions.Visible = false;
                //}
                //else
                //{
                //    pnlNoTransactions.Visible = true;
                //}




                string sql = "usp_GetRecentTransactions";
                using (SqlCommand cmd = Web.Models.Connection.Sql(sql))
                {
                    cmd.Parameters.AddWithValue("@UserId", UserId);
                    cmd.Parameters.AddWithValue("@Count", count);

                    SqlDataAdapter sda = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();

                    sda.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        rptTransactions.DataSource = dt;
                        rptTransactions.DataBind();
                        pnlNoTransactions.Visible = false;

                    }
                    else
                    {
                        pnlNoTransactions.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load transactions", ex);
                pnlNoTransactions.Visible = true;
            }
            finally
            {
                Web.Models.Connection.CloseConnection();
            }
        }


        private void LoadDashboardData()
        {
            // Display Welcome Info
            string userName = Session["UserName"]?.ToString() ?? "User";
            litWelcomeName.Text = userName;
            litDate.Text = DateTime.UtcNow.ToString("dddd, MMMM dd, yyyy");

            // Get Timeframe
            string timeframe = Request.QueryString["tf"] ?? "30d";
            string[] validTimeframes = { "7d", "30d", "90d", "1y", "all" };
            if (!validTimeframes.Contains(timeframe)) timeframe = "30d";

            // 1. Load Portfolio History & Summary
            var portfolio = _dashboardService.GetPortfolioHistory(_userId, timeframe);
            litNetWorth.Text = portfolio.Summary.NetWorth.ToString("N2");
            litWalletBalance.Text = portfolio.Summary.TotalWalletBalance.ToString("N2");
            litTotalInvested.Text = portfolio.Summary.TotalInvested.ToString("N2");
            litTotalEarnings.Text = portfolio.Summary.TotalEarnings.ToString("N2");

            BindPortfolioChart(portfolio.History);

            // 2. Load Wallets
            try
            {
                var walletService = new WalletService();
                var wallets = walletService.GetUserWallets(_userId);

                if (wallets != null && wallets.Count > 0)
                {
                    rptWallets.DataSource = wallets;
                    rptWallets.DataBind();
                    pnlNoWallets.Visible = false;

                    // Update session balance
                    decimal totalBalance = wallets.Sum(w => w.Balance);
                    Session["TotalBalance"] = totalBalance;
                    litWalletBalance.Text = totalBalance.ToString("0.00"); // If you have this literal
                }
                else
                {
                    pnlNoWallets.Visible = true;
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load wallets", ex);
                pnlNoWallets.Visible = true;
            }

            // 3. Load Active Investments
            try
            {
                var investmentService = new InvestmentService();
                var investments = investmentService.GetUserActiveInvestments(_userId);

                if (investments != null && investments.Count > 0)
                {
                    rptInvestments.DataSource = investments;
                    rptInvestments.DataBind();
                    pnlNoInvestments.Visible = false;

                    decimal totalInv = investments.Sum(i => i.PrincipalAmount);
                    decimal totalEarn = investments.Sum(i => i.TotalEarned);

                    litTotalInvested.Text = totalInv.ToString("0.00");
                    litTotalEarnings.Text = totalEarn.ToString("0.00");
                }
                else
                {
                    pnlNoInvestments.Visible = true;
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load investments", ex);
                pnlNoInvestments.Visible = true;
            }

            // 4. Load Today's ROI
            decimal todayROI = CalculateTodayROI(_userId);
            litTodayROI.Text = todayROI.ToString("0.00") + " USDT";

            // 5. Load Recent Transactions


            LoadRecentTransaction(_userId, 10);

            // 6. Load Referral Stats
            try
            {
                var referralService = new ReferralService();
                var referralStats = referralService.GetUserReferralStats(_userId);
                litDirectReferrals.Text = referralStats.DirectReferrals.ToString();
                litTotalTeam.Text = referralStats.TotalTeam.ToString();
                litTotalCommission.Text = referralStats.TotalCommission.ToString("0.00");
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load referral stats", ex);
            }
        }

        private void BindPortfolioChart(List<PortfolioHistoryPoint> history)
        {
            if (history == null) history = new List<PortfolioHistoryPoint>();

            var jsSerializer = new JavaScriptSerializer();
            var labels = new string[history.Count];
            var inflows = new decimal[history.Count];
            var outflows = new decimal[history.Count];

            for (int i = 0; i < history.Count; i++)
            {
                labels[i] = history[i].Date.ToString("MMM dd");
                inflows[i] = history[i].Inflow;
                outflows[i] = history[i].Outflow;
            }

            hidChartLabels.Value = jsSerializer.Serialize(labels);
            hidChartInflows.Value = jsSerializer.Serialize(inflows);
            hidChartOutflows.Value = jsSerializer.Serialize(outflows);
        }

        private decimal CalculateTodayROI(int userId)
        {
            try
            {
                var investmentService = new InvestmentService();
                var investments = investmentService.GetUserActiveInvestments(userId);
                return investments?.Sum(inv => inv.DailyRatePercent) ?? 0;
            }
            catch
            {
                return 0;
            }
        }

        // ==========================================
        // ✅ CHART DATA HELPER METHODS (No Duplicates)
        // ==========================================

        protected string GetPortfolioChartData()
        {
            try
            {
                if (string.IsNullOrEmpty(hidChartLabels.Value))
                {
                    return "{\"labels\":[],\"inflows\":[],\"outflows\":[]}";
                }
                return string.Format(
                    "{{\"labels\":{0},\"inflows\":{1},\"outflows\":{2}}}",
                    hidChartLabels.Value,
                    hidChartInflows.Value,
                    hidChartOutflows.Value
                );
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get portfolio chart data", ex);
                return "{\"labels\":[],\"inflows\":[],\"outflows\":[]}";
            }
        }

        protected string GetChartLabels()
        {
            return string.IsNullOrEmpty(hidChartLabels.Value) ? "[]" : hidChartLabels.Value;
        }

        protected string GetChartInflows()
        {
            return string.IsNullOrEmpty(hidChartInflows.Value) ? "[]" : hidChartInflows.Value;
        }

        protected string GetChartOutflows()
        {
            return string.IsNullOrEmpty(hidChartOutflows.Value) ? "[]" : hidChartOutflows.Value;
        }

        protected string GetEarningsBreakdown()
        {
            try
            {
                var breakdown = _dashboardService.GetEarningsBreakdown(_userId);
                return string.Join(",", new[] {
                    breakdown.ROI.ToString("0.00"),
                    breakdown.Staking.ToString("0.00"),
                    breakdown.Mining.ToString("0.00"),
                    breakdown.Referrals.ToString("0.00"),
                    breakdown.Royalties.ToString("0.00")
                });
            }
            catch
            {
                return "0,0,0,0,0";
            }
        }

        // ==========================================
        // REPEATER HELPER METHODS
        // ==========================================

        public string GetCurrencyIconClass(object code)
        {
            if (code == null) return "pnc";
            return code.ToString().ToLower();
        }

        public string GetCurrencyIcon(object code)
        {
            if (code == null) return "fas fa-coins";
            string c = code.ToString().ToUpper();

            switch (c)
            {
                case "USDT": return "fas fa-dollar-sign";
                case "BTC": return "fab fa-bitcoin";
                case "ETH": return "fab fa-ethereum";
                default: return "fas fa-coins";
            }
        }

        public string GetInvestmentStatusClass(object status)
        {
            int s = 0;
            if (status != null && status != DBNull.Value) int.TryParse(status.ToString(), out s);

            switch (s)
            {
                case 1: return "status-active";
                case 2: return "status-matured";
                default: return "status-pending";
            }
        }

        public static string GetInvestmentStatusLabel(object status)
        {
            int s = 0;
            if (status != null && status != DBNull.Value) int.TryParse(status.ToString(), out s);

            switch (s)
            {
                case 1: return "Active";
                case 2: return "Matured";
                default: return "Pending";
            }
        }

        public string GetTransactionIconClass(object type)
        {
            int t = 0;
            if (type != null && type != DBNull.Value) int.TryParse(type.ToString(), out t);

            switch (t)
            {
                case 1: return "deposit";
                case 2: return "withdraw";
                case 4: return "roi";
                case 5: return "invest";
                default: return "deposit";
            }
        }

        public string GetTransactionIcon(object type)
        {
            int t = 0;
            if (type != null && type != DBNull.Value) int.TryParse(type.ToString(), out t);

            switch (t)
            {
                case 1: return "fas fa-arrow-down";
                case 2: return "fas fa-arrow-up";
                case 4: return "fas fa-chart-line";
                case 5: return "fas fa-piggy-bank";
                default: return "fas fa-exchange-alt";
            }
        }




    }
  
}