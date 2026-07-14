using Mexify.DataAccess.Repositories;
using Mexify.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Mexify.Web.User
{
    public partial class P2P : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Web/MetaMaskLogin.aspx", false);
                return;
            }

            if (!IsPostBack)
            {
                LoadP2PAds();
            }
        }

        private void LoadP2PAds()
        {
            try
            {
                var repo = new P2PRepository();
                // Default to showing SELL ads (so user can BUY)
                var ads = repo.GetActiveP2PAds("USDT", "SELL");

                rptP2PAds.DataSource = ads;
                rptP2PAds.DataBind();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load P2P ads", ex);
            }
        }

        protected void btnTrade_Command(object sender, CommandEventArgs e)
        {
            long adId = Convert.ToInt64(e.CommandArgument);
            // Redirect to trade execution page with AdId
            Response.Redirect($"Trade.aspx?adId={adId}", false);
        }
    }
}