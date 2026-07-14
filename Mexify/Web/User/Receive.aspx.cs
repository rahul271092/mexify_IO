using System;
using System.Web.UI;
using Mexify.Business.Services;
using Mexify.Utilities;

namespace Mexify.Web.User
{
    public partial class Receive : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Web/login.aspx", false);
                return;
            }

            if (!IsPostBack)
            {
                LoadAddresses();
            }
        }

        private void LoadAddresses()
        {
            try
            {
                int userId = Convert.ToInt32(Session["UserId"]);
                var service = new TransferService();
                var addresses = service.GetUserWalletAddresses(userId);

                if (addresses.Count > 0)
                {
                    rptAddresses.DataSource = addresses;
                    rptAddresses.DataBind();
                    pnlNoAddresses.Visible = false;
                }
                else
                {
                    pnlNoAddresses.Visible = true;
                    rptAddresses.Visible = false;
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load addresses", ex);
            }
        }
    }
}