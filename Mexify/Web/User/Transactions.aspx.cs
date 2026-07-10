using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using Mexify.Business.Services;
using Mexify.Models;
using Mexify.Utilities;

namespace Mexify.Web.User
{
    public partial class Transactions : System.Web.UI.Page
    {
        private TransactionService _transactionService;
        private int _userId;

        // Pagination
        private int _currentPage = 1;
        private int _pageSize = 20;
        private int _totalRecords = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.IsAuthenticated || Session["UserId"] == null)
            {
                Response.Redirect(ResolveUrl("~/Web/login.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl)));
                return;
            }

            _userId = Convert.ToInt32(Session["UserId"]);
            _transactionService = new TransactionService();

            if (!IsPostBack)
            {
                // Check for page parameter
                if (!string.IsNullOrEmpty(Request.QueryString["page"]))
                {
                    int.TryParse(Request.QueryString["page"], out _currentPage);
                    if (_currentPage < 1) _currentPage = 1;
                }

                LoadCurrencies();
                LoadTransactions();
                LoadTabData();
            }
        }

        private void LoadCurrencies()
        {
            try
            {
                var walletService = new WalletService();
                var currencies = walletService.GetSupportedCurrencies();
                ddlCurrency.DataSource = currencies;
                ddlCurrency.DataValueField = "CurrencyCode";
                ddlCurrency.DataTextField = "CurrencyCode";
                ddlCurrency.DataBind();
                ddlCurrency.Items.Insert(0, new ListItem("All Currencies", ""));
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load currencies", ex);
            }
        }

        private void LoadTransactions()
        {
            try
            {
                var master = this.Master as Mexify.Web.MasterPages.UserMaster;
                if (master != null)
                {
                    master.SetPageTitle("Transactions");
                    master.SetBreadcrumb("Transactions");
                }

                // Build filter
                var filter = new TransactionFilter
                {
                    UserId = _userId,
                    Search = txtSearch.Text.Trim(),
                    Type = string.IsNullOrEmpty(ddlType.SelectedValue) ? (int?)null : int.Parse(ddlType.SelectedValue),
                    Status = string.IsNullOrEmpty(ddlStatus.SelectedValue) ? (int?)null : int.Parse(ddlStatus.SelectedValue),
                    Currency = ddlCurrency.SelectedValue,
                    DateFrom = string.IsNullOrEmpty(txtDateFrom.Text) ? (DateTime?)null : DateTime.Parse(txtDateFrom.Text),
                    DateTo = string.IsNullOrEmpty(txtDateTo.Text) ? (DateTime?)null : DateTime.Parse(txtDateTo.Text).AddDays(1).AddSeconds(-1),
                    Page = _currentPage,
                    PageSize = _pageSize
                };

                // Get paginated results
                var result = _transactionService.GetUserTransactionsPaged(filter);
                _totalRecords = result.TotalCount;

                if (result.Transactions != null && result.Transactions.Count > 0)
                {
                    rptTransactions.DataSource = result.Transactions;
                    rptTransactions.DataBind();
                    pnlNoTransactions.Visible = false;

                    // Update pagination info
                    int from = (_currentPage - 1) * _pageSize + 1;
                    int to = Math.Min(_currentPage * _pageSize, _totalRecords);
                    litShowingFrom.Text = from.ToString();
                    litShowingTo.Text = to.ToString();
                    litTotalRecords.Text = _totalRecords.ToString("N0");

                    // Build pagination buttons
                    BuildPagination(result.TotalPages);
                }
                else
                {
                    pnlNoTransactions.Visible = true;
                    rptTransactions.DataSource = null;
                    rptTransactions.DataBind();
                }

                // Load summary stats
                var summary = _transactionService.GetUserTransactionSummary(_userId);
                litTotalVolume.Text = summary.TotalVolume.ToString("0.00");
                litTotalVolumeUSD.Text = (summary.TotalVolume * 0.042m).ToString("0.00");
                litTotalCount.Text = summary.TotalCount.ToString("N0");
                litSuccessRate.Text = summary.SuccessRate.ToString("0");
                litTotalInflow.Text = summary.TotalInflow.ToString("0.00");
                litTotalOutflow.Text = summary.TotalOutflow.ToString("0.00");
                litNetBalance.Text = summary.NetBalance.ToString("0.00");
                litPendingCount.Text = summary.PendingCount.ToString();
            }
            catch (Exception ex)
            {
                Logger.Error("Transactions page load failed for user " + _userId, ex);
            }
        }

        private void LoadTabData()
        {
            try
            {
                // Deposits
                var deposits = _transactionService.GetUserTransactionsByType(_userId, 1, 20);
                if (deposits != null && deposits.Count > 0)
                {
                    rptDeposits.DataSource = deposits;
                    rptDeposits.DataBind();
                    pnlNoDeposits.Visible = false;
                }
                else
                {
                    pnlNoDeposits.Visible = true;
                }

                var depositStats = _transactionService.GetTransactionStatsByType(_userId, 1);
                litTotalDeposits.Text = depositStats.TotalAmount.ToString("0.00");
                litDepositCount.Text = depositStats.Count.ToString();
                litAvgDeposit.Text = depositStats.AverageAmount.ToString("0.00");

                // Withdrawals
                var withdrawals = _transactionService.GetUserTransactionsByType(_userId, 2, 20);
                if (withdrawals != null && withdrawals.Count > 0)
                {
                    rptWithdrawals.DataSource = withdrawals;
                    rptWithdrawals.DataBind();
                    pnlNoWithdrawals.Visible = false;
                }
                else
                {
                    pnlNoWithdrawals.Visible = true;
                }

                var withdrawalStats = _transactionService.GetTransactionStatsByType(_userId, 2);
                litTotalWithdrawals.Text = Math.Abs(withdrawalStats.TotalAmount).ToString("0.00");
                litWithdrawalCount.Text = withdrawalStats.Count.ToString();
                litTotalFees.Text = withdrawalStats.TotalFees.ToString("0.00");

                // Earnings (ROI + Staking + Mining + Referral)
                var earnings = _transactionService.GetUserEarnings(_userId, 50);
                if (earnings != null && earnings.Count > 0)
                {
                    rptEarnings.DataSource = earnings;
                    rptEarnings.DataBind();
                    pnlNoEarnings.Visible = false;
                }
                else
                {
                    pnlNoEarnings.Visible = true;
                }

                var earningsBreakdown = _transactionService.GetEarningsBreakdown(_userId);
                litTotalEarnings.Text = earningsBreakdown.Total.ToString("0.00");
                litROIEarnings.Text = earningsBreakdown.ROI.ToString("0.00");
                litStakingEarnings.Text = earningsBreakdown.Staking.ToString("0.00");
                litReferralEarnings.Text = earningsBreakdown.Referral.ToString("0.00");

                // Investments
                var investments = _transactionService.GetUserTransactionsByType(_userId, 5, 20);
                if (investments != null && investments.Count > 0)
                {
                    rptInvestments.DataSource = investments;
                    rptInvestments.DataBind();
                    pnlNoInvestments.Visible = false;
                }
                else
                {
                    pnlNoInvestments.Visible = true;
                }

                var investStats = _transactionService.GetTransactionStatsByType(_userId, 5);
                litTotalInvested.Text = Math.Abs(investStats.TotalAmount).ToString("0.00");
                litInvestmentCount.Text = investStats.Count.ToString();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load tab data", ex);
            }
        }

        private void BuildPagination(int totalPages)
        {
            var html = new StringBuilder();

            // Previous button
            html.AppendFormat("<button class='page-btn' {0} onclick='goToPage({1})'>",
                _currentPage == 1 ? "disabled" : "",
                _currentPage - 1);
            html.Append("<i class='fas fa-chevron-left'></i>");
            html.Append("</button>");

            // Page numbers
            int startPage = Math.Max(1, _currentPage - 2);
            int endPage = Math.Min(totalPages, _currentPage + 2);

            if (startPage > 1)
            {
                html.AppendFormat("<button class='page-btn' onclick='goToPage(1)'>1</button>");
                if (startPage > 2) html.Append("<span class='text-muted px-2'>...</span>");
            }

            for (int i = startPage; i <= endPage; i++)
            {
                html.AppendFormat("<button class='page-btn {0}' onclick='goToPage({1})'>{1}</button>",
                    i == _currentPage ? "active" : "", i);
            }

            if (endPage < totalPages)
            {
                if (endPage < totalPages - 1) html.Append("<span class='text-muted px-2'>...</span>");
                html.AppendFormat("<button class='page-btn' onclick='goToPage({0})'>{0}</button>", totalPages);
            }

            // Next button
            html.AppendFormat("<button class='page-btn' {0} onclick='goToPage({1})'>",
                _currentPage == totalPages ? "disabled" : "",
                _currentPage + 1);
            html.Append("<i class='fas fa-chevron-right'></i>");
            html.Append("</button>");

            // Add JavaScript for pagination
            html.Append("<script>function goToPage(page) { window.location.href = 'Transactions.aspx?page=' + page; }</script>");

            // Inject into placeholder (using Literal or Panel)
            var paginationLiteral = new Literal();
            paginationLiteral.Text = html.ToString();
            // Note: In production, add a Literal control to the pagination-buttons div
        }

        protected void btnApply_Click(object sender, EventArgs e)
        {
            _currentPage = 1;
            LoadTransactions();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlType.SelectedIndex = 0;
            ddlStatus.SelectedIndex = 0;
            ddlCurrency.SelectedIndex = 0;
            txtDateFrom.Text = "";
            txtDateTo.Text = "";
            _currentPage = 1;
            LoadTransactions();
        }

        protected void btnExportCSV_Click(object sender, EventArgs e)
        {
            try
            {
                var filter = new TransactionFilter
                {
                    UserId = _userId,
                    Search = txtSearch.Text.Trim(),
                    Type = string.IsNullOrEmpty(ddlType.SelectedValue) ? (int?)null : int.Parse(ddlType.SelectedValue),
                    Status = string.IsNullOrEmpty(ddlStatus.SelectedValue) ? (int?)null : int.Parse(ddlStatus.SelectedValue),
                    Currency = ddlCurrency.SelectedValue,
                    DateFrom = string.IsNullOrEmpty(txtDateFrom.Text) ? (DateTime?)null : DateTime.Parse(txtDateFrom.Text),
                    DateTo = string.IsNullOrEmpty(txtDateTo.Text) ? (DateTime?)null : DateTime.Parse(txtDateTo.Text).AddDays(1).AddSeconds(-1),
                    Page = 1,
                    PageSize = 10000 // Export all
                };

                var result = _transactionService.GetUserTransactionsPaged(filter);

                if (result.Transactions == null || result.Transactions.Count == 0)
                {
                    // Show alert - no data to export
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('No transactions to export.');", true);
                    return;
                }

                StringBuilder csv = new StringBuilder();
                csv.AppendLine("Date,Type,Amount,Fee,Net Amount,Currency,Status,TX Hash");

                foreach (var tx in result.Transactions)
                {
                    csv.AppendLine(string.Format("{0},{1},{2},{3},{4},{5},{6},{7}",
                        tx.CreatedDate.ToString("yyyy-MM-dd HH:mm:ss"),
                        tx.TypeName.Replace(",", " "),
                        tx.Amount.ToString("0.########"),
                        tx.Fee.ToString("0.########"),
                        tx.NetAmount.ToString("0.########"),
                        tx.CurrencyCode,
                        tx.StatusName,
                        tx.TxHash ?? ""));
                }

                Response.Clear();
                Response.ContentType = "text/csv";
                Response.AddHeader("Content-Disposition", "attachment; filename=transactions_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".csv");
                Response.Write(csv.ToString());
                Response.End();
            }
            catch (Exception ex)
            {
                Logger.Error("CSV export failed", ex);
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Export failed. Please try again.');", true);
            }
        }

        // Helper methods for Repeater binding
        public string GetAmountClass(object amount)
        {
            decimal a = 0;
            if (amount != null && amount != DBNull.Value) decimal.TryParse(amount.ToString(), out a);
            if (a > 0) return "positive";
            if (a < 0) return "negative";
            return "neutral";
        }

        public string GetStatusClass(object status)
        {
            int s = 0;
            if (status != null && status != DBNull.Value) int.TryParse(status.ToString(), out s);
            switch (s)
            {
                case 1: return "status-completed";
                case 2: return "status-pending";
                case 3: return "status-failed";
                case 4: return "status-cancelled";
                default: return "status-pending";
            }
        }

        public string GetVolumeChartData()
        {
            try
            {
                var data = _transactionService.GetVolumeHistory(_userId, 30);
                var labels = new List<string>();
                var inflow = new List<string>();
                var outflow = new List<string>();

                foreach (var point in data)
                {
                    labels.Add("\"" + point.Date.ToString("MMM dd") + "\"");
                    inflow.Add(point.Inflow.ToString("0.00"));
                    outflow.Add(Math.Abs(point.Outflow).ToString("0.00"));
                }

                return "{ labels: [" + string.Join(",", labels) + "], inflow: [" + string.Join(",", inflow) + "], outflow: [" + string.Join(",", outflow) + "] }";
            }
            catch { return "{ labels: [], inflow: [], outflow: [] }"; }
        }

        public string GetTypeChartData()
        {
            try
            {
                var distribution = _transactionService.GetTypeDistribution(_userId);
                var labels = new List<string>();
                var values = new List<string>();
                var colors = new List<string>();

                string[] colorPalette = { "#00FFB2", "#ff3b5c", "#6366F1", "#00D4FF", "#FFD700", "#FFA500", "#10B981", "#9C27B0" };
                int colorIndex = 0;

                foreach (var item in distribution)
                {
                    labels.Add("\"" + item.Name + "\"");
                    values.Add(item.Value.ToString());
                    colors.Add("\"" + colorPalette[colorIndex % colorPalette.Length] + "\"");
                    colorIndex++;
                }

                return "{ labels: [" + string.Join(",", labels) + "], values: [" + string.Join(",", values) + "], colors: [" + string.Join(",", colors) + "] }";
            }
            catch { return "{ labels: [], values: [], colors: [] }"; }
        }
    }
}