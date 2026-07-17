using System;
using System.Web.UI;
using Mexify.Business.Services;
using Mexify.Utilities;
using System.Data.SqlClient;
using System.Data;
using Mexify.DataAccess;

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


        public string GetOrCreateWalletAddress(int userId, string currencyCode)
        {
            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_GetOrCreateWalletAddress", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@CurrencyCode", currencyCode);      
                    conn.Open();
                    cmd.ExecuteNonQuery();

                    Response.Redirect("~/Web/User/Receive.aspx?message=1");

                  
                }
            }
            catch (Exception ex) { Logger.Error("Failed to get wallet address", ex); }
            return null;
        }


        protected void CreateWalletLinkButton_Click(object sender, EventArgs e)
        {
            int _userId = Int32.Parse(Session["UserId"].ToString());
            string CurrencyCode = "USDT";
            GetOrCreateWalletAddress(_userId, CurrencyCode);

        }
    }
}