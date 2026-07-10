using System;
using System.Collections.Generic;
using System.Web.UI;
using Mexify.Business.Services;
using Mexify.Models;
using Mexify.Utilities;

namespace Mexify.Web.User
{
    public partial class ICO : System.Web.UI.Page
    {
        private UserICOService _icoService;
        private int _userId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.IsAuthenticated || Session["UserId"] == null)
            {
                Response.Redirect(ResolveUrl("~/Web/login.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl)));
                return;
            }

            _userId = Convert.ToInt32(Session["UserId"]);
            _icoService = new UserICOService();

            if (!IsPostBack)
            {
                LoadICOData();
            }
        }

        private void LoadICOData()
        {
            try
            {
                var master = this.Master as Mexify.Web.MasterPages.UserMaster;
                if (master != null)
                {
                    master.SetPageTitle("ICO Launchpad");
                    master.SetBreadcrumb("ICO");
                }

                // Summary stats
                var summary = _icoService.GetUserICOSummary(_userId);
                litTotalInvested.Text = summary.TotalInvested.ToString("0.00");
                litTotalUSD.Text = (summary.TotalInvested * 0.042m).ToString("0.00");
                litTotalParticipations.Text = summary.TotalParticipations.ToString();
                litTokensReceived.Text = summary.TokensReceived.ToString("0.##");
                litTokensVesting.Text = summary.TokensVesting.ToString("0.##");
                litCurrentROI.Text = summary.CurrentROI.ToString("0.00");
                litActiveCount.Text = summary.ActiveProjects.ToString();
                litParticipationCount.Text = summary.TotalParticipations.ToString();

                // History stats
                litTotalTokensReceived.Text = summary.TokensReceived.ToString("0.##");
                litTotalTokensClaimed.Text = summary.TokensClaimed.ToString("0.##");
                litTotalRefunded.Text = summary.TotalRefunded.ToString("0.00");

                // Live projects (overview)
                var liveProjects = _icoService.GetLiveProjects(3);
                if (liveProjects != null && liveProjects.Count > 0)
                {
                    rptLiveProjects.DataSource = liveProjects;
                    rptLiveProjects.DataBind();
                }

                // Active projects
                var activeProjects = _icoService.GetActiveProjects();
                if (activeProjects != null && activeProjects.Count > 0)
                {
                    rptActiveProjects.DataSource = activeProjects;
                    rptActiveProjects.DataBind();
                    pnlNoActive.Visible = false;
                }
                else
                {
                    pnlNoActive.Visible = true;
                }

                // Participations
                var participations = _icoService.GetUserParticipations(_userId);
                if (participations != null && participations.Count > 0)
                {
                    rptParticipations.DataSource = participations;
                    rptParticipations.DataBind();
                    pnlNoParticipations.Visible = false;
                }
                else
                {
                    pnlNoParticipations.Visible = true;
                }

                // Token history
                var tokenHistory = _icoService.GetUserTokenHistory(_userId, 50);
                if (tokenHistory != null && tokenHistory.Count > 0)
                {
                    rptTokenHistory.DataSource = tokenHistory;
                    rptTokenHistory.DataBind();
                    pnlNoHistory.Visible = false;
                }
                else
                {
                    pnlNoHistory.Visible = true;
                }
            }
            catch (Exception ex)
            {
                Logger.Error("ICO page load failed for user " + _userId, ex);
            }
        }

        public bool HasClaimableTokens(object tokensVesting)
        {
            decimal tokens = 0;
            if (tokensVesting != null && tokensVesting != DBNull.Value)
            {
                decimal.TryParse(tokensVesting.ToString(), out tokens);
            }
            return tokens > 0;
        }

        public string GetStatusClass(object status)
        {
            int s = 0;
            if (status != null && status != DBNull.Value) int.TryParse(status.ToString(), out s);
            switch (s)
            {
                case 1: return "status-active";
                case 2: return "status-vesting";
                case 3: return "status-completed";
                case 4: return "status-refunded";
                default: return "status-active";
            }
        }

        public string GetPerformanceChartData()
        {
            try
            {
                var data = _icoService.GetPerformanceHistory(_userId, 30);
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
                var distribution = _icoService.GetPortfolioDistribution(_userId);
                var labels = new List<string>();
                var values = new List<string>();
                var colors = new List<string>();

                string[] colorPalette = { "#ff3b5c", "#ff6b6b", "#FFD700", "#00FFB2", "#00D4FF", "#9C27B0", "#2563EB" };
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