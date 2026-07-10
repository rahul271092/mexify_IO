using System;
using System.Collections.Generic;
using System.Web.UI;
using Mexify.Business.Services;
using Mexify.Web.Models;
using Mexify.Utilities;

namespace Mexify.Web.User
{
    public partial class NFTs : System.Web.UI.Page
    {
        private UserNFTService _nftService;
        private int _userId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.IsAuthenticated || Session["UserId"] == null)
            {
                Response.Redirect(ResolveUrl("~/Web/login.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl)));
                return;
            }

            _userId = Convert.ToInt32(Session["UserId"]);
            _nftService = new UserNFTService();

            if (!IsPostBack)
            {
                LoadNFTData();
            }
        }

        private void LoadNFTData()
        {
            try
            {
                var master = this.Master as Mexify.Web.MasterPages.UserMaster;
                if (master != null)
                {
                    master.SetPageTitle("My NFTs");
                    master.SetBreadcrumb("My NFTs");
                }

                // Summary stats
                var summary = _nftService.GetUserNFTSummary(_userId);
                litTotalValue.Text = summary.TotalValue.ToString("0.00");
                litTotalUSD.Text = (summary.TotalValue * 0.042m).ToString("0.00");
                litTotalOwned.Text = summary.TotalOwned.ToString();
                litTotalCreated.Text = summary.TotalCreated.ToString();
                litTotalSales.Text = summary.TotalSales.ToString("0.00");
                litRoyalties.Text = summary.RoyaltiesEarned.ToString("0.00");
                litOwnedCount.Text = summary.TotalOwned.ToString();
                litCreatedCount.Text = summary.TotalCreated.ToString();

                // Activity stats
                litTotalPurchases.Text = summary.TotalPurchases.ToString("0.00");
                litTotalSalesActivity.Text = summary.TotalSales.ToString("0.00");
                litMintingFees.Text = summary.MintingFees.ToString("0.00");

                // Owned NFTs
                var ownedNFTs = _nftService.GetUserOwnedNFTs(_userId);
                if (ownedNFTs != null && ownedNFTs.Count > 0)
                {
                    rptOwnedNFTs.DataSource = ownedNFTs;
                    rptOwnedNFTs.DataBind();
                    pnlNoOwned.Visible = false;
                }
                else
                {
                    pnlNoOwned.Visible = true;
                }

                // Created NFTs
                var createdNFTs = _nftService.GetUserCreatedNFTs(_userId);
                if (createdNFTs != null && createdNFTs.Count > 0)
                {
                    rptCreatedNFTs.DataSource = createdNFTs;
                    rptCreatedNFTs.DataBind();
                    pnlNoCreated.Visible = false;
                }
                else
                {
                    pnlNoCreated.Visible = true;
                }

                // Recent activity (overview)
                var recentActivity = _nftService.GetUserNFTActivity(_userId, 5);
                if (recentActivity != null && recentActivity.Count > 0)
                {
                    rptRecentActivity.DataSource = recentActivity;
                    rptRecentActivity.DataBind();
                }

                // All activity
                var allActivity = _nftService.GetUserNFTActivity(_userId, 50);
                if (allActivity != null && allActivity.Count > 0)
                {
                    rptAllActivity.DataSource = allActivity;
                    rptAllActivity.DataBind();
                    pnlNoActivity.Visible = false;
                }
                else
                {
                    pnlNoActivity.Visible = true;
                }

                // Filter collections
                rptFilterCollections.DataSource = _nftService.GetUserCollections(_userId);
                rptFilterCollections.DataBind();
            }
            catch (Exception ex)
            {
                Logger.Error("NFTs page load failed for user " + _userId, ex);
            }
        }

        public string GetStatusClass(object status)
        {
            int s = 0;
            if (status != null && status != DBNull.Value) int.TryParse(status.ToString(), out s);
            if (s == 1) return "status-listed";
            if (s == 2) return "status-owned";
            if (s == 3) return "status-sold";
            return "status-owned";
        }

        public string GetValueChartData()
        {
            try
            {
                var data = _nftService.GetPortfolioValueHistory(_userId, 30);
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

        public string GetCollectionChartData()
        {
            try
            {
                var distribution = _nftService.GetCollectionDistribution(_userId);
                var labels = new List<string>();
                var values = new List<string>();
                var colors = new List<string>();

                string[] colorPalette = { "#9C27B0", "#E91E63", "#FF5722", "#FFD700", "#00D4FF", "#00FFB2", "#2563EB" };
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