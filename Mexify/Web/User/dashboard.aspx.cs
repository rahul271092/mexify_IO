using System;
using System.Collections.Generic;
using System.Web.UI;
using Mexify.Business.Services;
using Mexify.Web.Models;
using Mexify.Utilities;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using Mexify.DataAccess.Repositories;

namespace Mexify.Web.User
{
    public partial class Dashboard : System.Web.UI.Page
    {
        private DashboardService _dashboardService;
        private int _userId;



        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Web/login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                _userId = Int32.Parse( Session["UserID"].ToString());
                try
                {
                    LoadDashboardData();
                }
                catch (System.Data.SqlClient.SqlException sqlEx)
                {
                    Logger.Error("Load Dashboard Data Function: ", sqlEx);
                    // This will show you the EXACT SQL error on the screen
                    Response.Write("<div style='color:red; padding:20px; background:#fff;'><b>SQL ERROR:</b> " + sqlEx.Message + "</div>");
                    Response.End();
                }
                catch (Exception ex)
                {
                    Logger.Error("Load Dashboard Data Function: ", ex);

                    Response.Write("<div style='color:red; padding:20px; background:#fff;'><b>GENERAL ERROR:</b> " + ex.Message + "</div>");
                    Response.End();
                }
            }
        }

        //protected void Page_Load(object sender, EventArgs e)
        //{

        //    _dashboardService = new DashboardService();

        //    if (Session["UserId"] == null)
        //    {
        //        Response.Redirect("~/Web/login.aspx");
        //        return;
        //    }

        //    _userId = Convert.ToInt32(Session["UserId"]);

        //    if (!IsPostBack)
        //    {
        //        // ✅ DEBUG: Log session values
        //        Logger.Info("=== DASHBOARD DEBUG ===");
        //        Logger.Info("UserId: " + Session["UserId"]);
        //        Logger.Info("TotalBalance in session: " + Session["TotalBalance"]);
        //        Logger.Info("PNCBalance in session: " + Session["PNCBalance"]);


        //      //  Response.Write("TotalBalance:" + Session["TotalBalance"].ToString());


        //        // Check if user has wallets in database
        //        try
        //        {
        //            var walletService = new WalletService();
        //            var wallets = walletService.GetUserWallets(_userId);
        //            Logger.Info("Wallets count from DB: " + (wallets?.Count ?? 0));

        //            if (wallets != null)
        //            {
        //                foreach (var w in wallets)
        //                {
        //                    Logger.Info("Wallet: " + w.CurrencyCode + " = " + w.Balance);
        //                }
        //            }
        //        }
        //        catch (Exception ex)
        //        {
        //            Logger.Error("Debug wallet fetch failed", ex);
        //        }

        //        //                LoadDashboardData();


        //        try
        //        {
        //            // Your database code here (e.g., loading dashboard data)
        //            LoadDashboardData();
        //        }
        //        catch (SqlException sqlEx)
        //        {
        //            // This will show you the EXACT SQL error in a popup
        //            Response.Write("<div style='color:red; padding:20px; background:#fff;'><b>SQL ERROR:</b> " + sqlEx.Message + "</div>");
        //            Response.End();
        //        }
        //        catch (Exception ex)
        //        {
        //            Response.Write("<div style='color:red; padding:20px; background:#fff;'><b>GENERAL ERROR:</b> " + ex.Message + "</div>");
        //            Response.End();
        //        }


        //    }
        //}


        //protected void Page_Load(object sender, EventArgs e)
        //{
        //    // Authentication check
        //    if (!Request.IsAuthenticated || Session["UserId"] == null)
        //    {
        //        Response.Redirect(ResolveUrl("~/Web/login.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl)));
        //        return;
        //    }

        //    _userId = Convert.ToInt32(Session["UserId"]);
        //    _dashboardService = new DashboardService();

        //    if (!IsPostBack)
        //    {
        //        Response.Write("USER ID:" + _userId+" Balance: "+Session["TotalBalance"].ToString());

        //        LoadDashboardData();
        //    }
        //}


        private void LoadDashboardData()
        {
            try
            {

                DashboardRepository repo = new DashboardRepository();

                _dashboardService = new DashboardService();

                // ✅ Display Welcome Name
                string userName = Session["UserName"]?.ToString() ?? "User";
                litWelcomeName.Text = userName;

                // Display Current Date
                litDate.Text = DateTime.UtcNow.ToString("dddd, MMMM dd, yyyy");

                // ✅ FIX: Get balance from session OR fetch fresh
                decimal totalBalance = 0;

                // Try session first
                if (Session["TotalBalance"] != null)
                {
                    totalBalance = Convert.ToDecimal(Session["TotalBalance"]);
                }


                int userId = Convert.ToInt32(Session["UserId"]);
//                var repo = new DashboardRepository();

                // Default timeframe
                string timeframe = Request.QueryString["tf"] ?? "30d";

                // Fetch Portfolio Data
                var portfolio = repo.GetUserPortfolioHistory(userId, timeframe);

                // Bind Summary Cards
                litNetWorth.Text = portfolio.Summary.NetWorth.ToString("N2");
                litWalletBalance.Text = portfolio.Summary.TotalWalletBalance.ToString("N2");
                litTotalInvested.Text = portfolio.Summary.TotalInvested.ToString("N2");
                litTotalEarnings.Text = portfolio.Summary.TotalEarnings.ToString("N2");

                // Serialize History for Chart.js
                var jsSerializer = new JavaScriptSerializer();

                var labels = new string[portfolio.History.Count];
                var inflows = new decimal[portfolio.History.Count];
                var outflows = new decimal[portfolio.History.Count];

                for (int i = 0; i < portfolio.History.Count; i++)
                {
                    labels[i] = portfolio.History[i].Date.ToString("MMM dd");
                    inflows[i] = portfolio.History[i].Inflow;
                    outflows[i] = portfolio.History[i].Outflow;
                }

                // Expose to Client-Side via hidden fields or Page Properties
                hidChartLabels.Value = jsSerializer.Serialize(labels);
                hidChartInflow.Value = jsSerializer.Serialize(inflows);
                hidChartOutflow.Value = jsSerializer.Serialize(outflows);


                // If session is empty, fetch from database
                if (totalBalance == 0)
                {
                    try
                    {
                        var walletService = new WalletService();
                        var allWallets = walletService.GetUserWallets(_userId);
                        if (allWallets != null && allWallets.Count > 0)
                        {
                            foreach (var wallet in allWallets)
                            {
                                totalBalance += wallet.Balance;
                            }
                        }

                        // Update session
                        Session["TotalBalance"] = totalBalance;
                        Logger.Info("Load Dashboad Balance success");
                    }
                    catch (Exception ex)
                    {
                        Logger.Error("Failed to fetch wallets on dashboard", ex);
                        Logger.Info("Exception:" + ex.ToString());
                    }
                }

                // ✅ Display balance
                litTotalBalance.Text = totalBalance.ToString("0.00");

                // Load Wallets
                try
                {
                    var walletService = new WalletService();
                    var wallets = walletService.GetUserWallets(_userId);
                    if (wallets != null && wallets.Count > 0)
                    {
                        rptWallets.DataSource = wallets;
                        rptWallets.DataBind();
                        pnlNoWallets.Visible = false;
                    }
                    else
                    {
                        pnlNoWallets.Visible = true;
                    }
                }
                catch (Exception ex)
                {


                    Logger.Error("Failed to load wallets", ex);
                    Logger.Info("Exception " + ex.ToString());
                    pnlNoWallets.Visible = true;
                }

                // Load Investments
                try
                {
                    var investmentService = new InvestmentService();
                    var investments = investmentService.GetUserActiveInvestments(_userId);
                    if (investments != null && investments.Count > 0)
                    {
                        rptInvestments.DataSource = investments;
                        rptInvestments.DataBind();
                        pnlNoInvestments.Visible = false;

                        decimal totalInvested = 0;
                        decimal totalEarnings = 0;
                        foreach (var inv in investments)
                        {
                            totalInvested += inv.PrincipalAmount;
                            totalEarnings += inv.TotalEarned;
                        }
                        litTotalInvested.Text = totalInvested.ToString("0.00");
                        litTotalEarnings.Text = totalEarnings.ToString("0.00");
                    }
                    else
                    {
                        pnlNoInvestments.Visible = true;
                        litTotalInvested.Text = "0.00";
                        litTotalEarnings.Text = "0.00";
                    }
                }
                catch (Exception ex)
                {
                    Logger.Error("Failed to load investments", ex);
                    Logger.Info("Exception :" + ex.ToString());
                    pnlNoInvestments.Visible = true;
                }

                // Load Today's ROI
                decimal todayROI = CalculateTodayROI(_userId);
                litTodayROI.Text = todayROI.ToString("0.00") + " PNC";
                litTodayProfit.Text = todayROI.ToString("0.00");

                // Load Transactions
                try
                {
                    var walletService = new WalletService();
                    var transactions = walletService.GetUserTransactions(_userId, 10);
                    if (transactions != null && transactions.Count > 0)
                    {
                        rptTransactions.DataSource = transactions;
                        rptTransactions.DataBind();
                        pnlNoTransactions.Visible = false;
                    }
                    else
                    {
                        pnlNoTransactions.Visible = true;
                    }
                }
                catch (Exception ex)
                {
                    Logger.Error("Failed to load transactions", ex);
                    Logger.Info("Exception:" + ex.ToString());
                    pnlNoTransactions.Visible = true;
                }

                // Load Referral Stats
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
                    Logger.Info(ex.ToString());
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Dashboard load failed for user " + _userId, ex);
                Logger.Info(ex.ToString());
            }
        }

        private decimal CalculateTodayROI(int userId)
        {
            try
            {

                var investmentService = new InvestmentService();
                var investments = investmentService.GetUserActiveInvestments(userId);
                decimal totalDailyROI = 0;
                if (investments != null)
                {
                    foreach (var inv in investments)
                    {
                        totalDailyROI += inv.DailyRatePercent;
                    }
                }
                return totalDailyROI;
            }
            catch { return 0; }
        }

        //private void LoadDashboard()
        //{
        //    try
        //    {
        //        // Set page title and breadcrumb via master page
        //        var master = this.Master as Mexify.Web.MasterPages.UserMaster;
        //        if (master != null)
        //        {
        //            master.SetPageTitle("Dashboard");
        //            master.SetBreadcrumb("Dashboard");
        //        }

        //        // Welcome info
        //        litDate.Text = DateTime.Now.ToString("dddd, MMMM dd, yyyy");
        //        litWelcomeName.Text = (Session["UserName"] as string ?? "Investor").Split(' ')[0];

        //        // Portfolio stats
        //        var stats = _dashboardService.GetPortfolioStats(_userId);
        //        litTotalBalance.Text = stats.TotalBalance.ToString("0.00");
        //        litTotalInvested.Text = stats.TotalInvested.ToString("0.00");
        //        litTotalEarnings.Text = stats.TotalEarnings.ToString("0.00");
        //        litTodayProfit.Text = stats.TodayProfit.ToString("0.00");
        //        litTodayROI.Text = stats.TodayProfit.ToString("0.00") + " USDT";

        //        // Update session balance for sidebar
        //        Session["PNCBalance"] = stats.TotalBalance;

        //        // Wallets
        //        var wallets = _dashboardService.GetUserWallets(_userId);
        //        if (wallets.Count > 0)
        //        {
        //            rptWallets.DataSource = wallets;
        //            rptWallets.DataBind();
        //            pnlNoWallets.Visible = false;
        //        }
        //        else
        //        {
        //            pnlNoWallets.Visible = true;
        //        }

        //        // Active investments
        //        var investments = _dashboardService.GetActiveInvestments(_userId);
        //        if (investments.Count > 0)
        //        {
        //            rptInvestments.DataSource = investments;
        //            rptInvestments.DataBind();
        //            pnlNoInvestments.Visible = false;
        //        }
        //        else
        //        {
        //            pnlNoInvestments.Visible = true;
        //        }

        //        // Recent transactions
        //        var transactions = _dashboardService.GetRecentTransactions(_userId, 5);
        //        if (transactions.Count > 0)
        //        {
        //            rptTransactions.DataSource = transactions;
        //            rptTransactions.DataBind();
        //            pnlNoTransactions.Visible = false;
        //        }
        //        else
        //        {
        //           pnlNoTransactions.Visible = true;
        //        }

        //        // Referral stats
        //        var referralStats = _dashboardService.GetReferralStats(_userId);
        //        litDirectReferrals.Text = referralStats.DirectReferrals.ToString();
        //        litTotalTeam.Text = referralStats.TotalTeam.ToString();
        //        litTotalCommission.Text = referralStats.TotalCommission.ToString("0.00");
        //    }
        //    catch (Exception ex)
        //    {
        //        Logger.Error("Dashboard load failed for user " + _userId, ex);
        //    }
        //}

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
                case "PNC": return "fas fa-coins";
                case "BTC": return "fab fa-bitcoin";
                case "ETH": return "fab fa-ethereum";
                case "USDT": return "fas fa-dollar-sign";
                default: return "fas fa-coins";
            }
        }

        public string GetInvestmentStatusClass(object status)
        {
            int s = 0;
            if (status != null && status != DBNull.Value) int.TryParse(status.ToString(), out s);
            if (s == 1) return "status-active";
            if (s == 2) return "status-matured";
            return "status-pending";
        }

        public static string GetInvestmentStatusLabel(object status)
        {
            int s = 0;
            if (status != null && status != DBNull.Value) int.TryParse(status.ToString(), out s);
            if (s == 1) return "Active";
            if (s == 2) return "Matured";
            return "Pending";
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

        public string GetPortfolioChartData()
        {
            try
            {
                var data = _dashboardService.GetPortfolioHistory(_userId, 7);
                var labels = new List<string>();
                var values = new List<string>();

                foreach (var point in data)
                {
                    labels.Add("\"" + point.Date.ToString("MMM dd") + "\"");
                    values.Add(point.Value.ToString("0.00"));
                }

                return "{ labels: [" + string.Join(",", labels) + "], values: [" + string.Join(",", values) + "] }";
            }
            catch
            {
                return "{ labels: [], values: [] }";
            }
        }

        public string GetEarningsBreakdown()
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

        private void InitializeComponent()
        {

        }

        private void fileSystemWatcher1_Changed(object sender, System.IO.FileSystemEventArgs e)
        {

        }
    }
}