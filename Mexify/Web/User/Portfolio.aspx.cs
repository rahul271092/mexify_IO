using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using Mexify.Business.Services;
using Mexify.Web.Models;
using Mexify.Utilities;

namespace Mexify.Web.User
{
    public partial class Portfolio : System.Web.UI.Page
    {
        private PortfolioService _portfolioService;
        private int _userId;

        public bool IsPositiveChange { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.IsAuthenticated || Session["UserId"] == null)
            {
                Response.Redirect(ResolveUrl("~/Web/login.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl)));
                return;
            }

            _userId = Convert.ToInt32(Session["UserId"]);
            _portfolioService = new PortfolioService();

            if (!IsPostBack)
            {
                LoadPortfolio();
            }
        }

        private void LoadPortfolio()
        {
            try
            {

                Logger.Info("LoadPortfolio function UserId:" + _userId.ToString());
                var master = this.Master as Mexify.Web.MasterPages.UserMaster;
                if (master != null)
                {
                    master.SetPageTitle("Portfolio");
                    master.SetBreadcrumb("Portfolio");
                }

                // Portfolio summary
                PortfolioService _portfolioService = new PortfolioService();
                var summary = _portfolioService.GetPortfolioSummary(_userId);


                if (summary != null)
                {
                    Logger.Info("portfolio summary:" + summary.TotalValue.ToString());
                    // 1. Total Value & USD Conversion (Assuming 1 PNC = $0.042 USD)
                    
                    decimal totalValue = Convert.ToDecimal( summary.TotalValue);
                    decimal tv = totalValue * 0.042m;
                    litTotalValue.Text = summary.TotalValue.ToString();
                    litTotalUSD.Text = tv.ToString(); // 'm' suffix makes it a decimal literal

                    // 2. Earnings & Stats
                    Logger.Info("Total Earning:" + summary.TotalEarnings.ToString());
                    litTotalEarnings.Text = summary.TotalEarnings.ToString("0.00");
                  //  litActiveCount.Text = summary.ActiveInvestments.ToString();
                  //  litDailyIncome.Text = summary.DailyIncome.ToString("0.00");
                   // litROI.Text = summary.OverallROI.ToString("0.00") + "%";

                    // 3. Change Indicators (Up/Down arrows)
                 //   litChangePercent.Text = Math.Abs(summary.ChangePercent).ToString("0.00");
                  //  litChangeAmount.Text = Math.Abs(summary.ChangeAmount).ToString("0.00");

                    // Determine if the change is positive or negative for UI styling
                   // IsPositiveChange = summary.ChangePercent >= 0;

                    // Optional: Apply CSS classes based on IsPositiveChange
                    // pnlChangeIndicator.CssClass = IsPositiveChange ? "stat-change up" : "stat-change down";
                }


                //litTotalValue.Text = summary.TotalValue.ToString("0.00");
                //litTotalUSD.Text = (summary.TotalValue * 0.042m).ToString("0.00");
                //litTotalEarnings.Text = summary.TotalEarnings.ToString("0.00");
                litActiveCount.Text = summary.ActiveInvestments.ToString();
                litDailyIncome.Text = summary.TodayProfit.ToString("0.00");
                //litROI.Text = summary.OverallROI.ToString("0.00");
                //litChangePercent.Text = Math.Abs(summary.ChangePercent).ToString("0.00");
                //litChangeAmount.Text = Math.Abs(summary.ChangeAmount).ToString("0.00");
                //IsPositiveChange = summary.ChangePercent >= 0;

                // Wallet holdings
                var wallets = _portfolioService.GetWalletHoldings(_userId);
                if (wallets != null && wallets.Count > 0)
                {
                    rptWalletHoldings.DataSource = wallets;
                    rptWalletHoldings.DataBind();
                }

                // Investment holdings
                var holdings = _portfolioService.GetHoldings(_userId);
                if (holdings != null && holdings.Count > 0)
                {
                    rptHoldings.DataSource = holdings;
                    rptHoldings.DataBind();
                    pnlEmpty.Visible = false;
                }
                else
                {
                    pnlEmpty.Visible = (wallets == null || wallets.Count == 0);
                }

                // Allocation legend
                var allocation = _portfolioService.GetAllocation(_userId);
                rptAllocationLegend.DataSource = allocation;
                rptAllocationLegend.DataBind();
            }
            catch (Exception ex)
            {
                Logger.Error("Portfolio load failed for user " + _userId, ex);
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

        public string GetPerformanceChartData()
        {
            try
            {
                var data = _portfolioService.GetPerformanceHistory(_userId, 7);
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

        public string GetAllocationChartData()
        {
            try
            {
                var allocation = _portfolioService.GetAllocation(_userId);
                var labels = new List<string>();
                var values = new List<string>();
                var colors = new List<string>();

                foreach (var item in allocation)
                {
                    labels.Add("\"" + item.Name + "\"");
                    values.Add(item.Value.ToString("0.00"));
                    colors.Add("\"" + item.Color + "\"");
                }

                return "{ labels: [" + string.Join(",", labels) + "], values: [" + string.Join(",", values) + "], colors: [" + string.Join(",", colors) + "] }";
            }
            catch { return "{ labels: [], values: [], colors: [] }"; }
        }
    }
}