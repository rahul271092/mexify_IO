using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Mexify.Utilities;
using Mexify.Business.Services;


namespace Mexify.Web
{
    public partial class nft : System.Web.UI.Page
    {

        private NFTService _nftService;
        private int _currentPage = 1;
        private const int PageSize = 12;

        protected void Page_Load(object sender, EventArgs e)
        {

            _nftService = new NFTService();

            if (!IsPostBack)
            {
                InitializePage();
            }

        }

        private void InitializePage()
        {
            try
            {
                LoadCollections();
                LoadNFTs();
            }
            catch (Exception ex)
            {
                Logger.Error("NFT Page Initialization Failed", ex);
            }
        }

        private void LoadCollections()
        {
            try
            {
                var collections = _nftService.GetTrendingCollections(8);
                rptCollections.DataSource = collections;
                rptCollections.DataBind();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load collections", ex);
            }
        }

        private void LoadNFTs()
        {
            try
            {
                string category = ddlCategory.SelectedValue;
                string sortBy = ddlSort.SelectedValue;
                string search = txtSearch.Text.Trim();

                var nfts = _nftService.GetNFTs(category, sortBy, search, _currentPage, PageSize);
                rptNFTs.DataSource = nfts;
                rptNFTs.DataBind();

                btnLoadMore.Visible = nfts.Count == PageSize;
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load NFTs", ex);
            }
        }

        protected void FilterNFTs(object sender, EventArgs e)
        {
            _currentPage = 1;
            LoadNFTs();
        }

        protected void btnLoadMore_Click(object sender, EventArgs e)
        {
            _currentPage++;
            LoadNFTs();
        }

        /// <summary>
        /// Renders auction countdown HTML for NFT cards.
        /// </summary>
        protected string RenderCountdown(object endDateObj)
        {
            if (endDateObj == null || endDateObj == DBNull.Value) return "";

            DateTime endDate;
            if (!DateTime.TryParse(endDateObj.ToString(), out endDate)) return "";

            TimeSpan remaining = endDate - DateTime.UtcNow;
            if (remaining.TotalSeconds <= 0) return "";

            return $@"
                <div class='auction-countdown'>
                    <div class='countdown-unit'>
                        <span class='countdown-value'>{remaining.Days:D2}</span>
                        <span class='countdown-label'>Days</span>
                    </div>
                    <div class='countdown-unit'>
                        <span class='countdown-value'>{remaining.Hours:D2}</span>
                        <span class='countdown-label'>Hours</span>
                    </div>
                    <div class='countdown-unit'>
                        <span class='countdown-value'>{remaining.Minutes:D2}</span>
                        <span class='countdown-label'>Minutes</span>
                    </div>
                    <div class='countdown-unit'>
                        <span class='countdown-value'>{remaining.Seconds:D2}</span>
                        <span class='countdown-label'>Seconds</span>
                    </div>
                </div>";
        }

        /// <summary>
        /// Returns Font Awesome icon class for crypto currency.
        /// </summary>
        public string GetCryptoIcon(object currencyCode)
        {
            if (currencyCode == null || currencyCode == DBNull.Value) return "fab fa-ethereum";

            string code = currencyCode.ToString().ToUpper();
            switch (code)
            {
                case "BTC": return "fab fa-bitcoin";
                case "ETH": return "fab fa-ethereum";
                case "USDT": return "fas fa-dollar-sign";
                case "BNB": return "fas fa-coins";
                case "SOL": return "fas fa-sun";
                default: return "fas fa-coins";
            }
        }
    }
}