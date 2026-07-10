using System;
using System.Web;
using Mexify.Business.Services;
using Mexify.Utilities;

namespace Mexify.Web.api
{
    public partial class getnonce : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                Response.ContentType = "application/json";

                string walletAddress = Request.QueryString["wallet"];

                if (string.IsNullOrEmpty(walletAddress))
                {
                    Response.Write("{\"success\": false, \"message\": \"Wallet address required\"}");
                    Response.End();
                    return;
                }

                var authService = new AuthService();
                string nonce = authService.GetOrCreateNonce(walletAddress);

                if (!string.IsNullOrEmpty(nonce))
                {
                    Response.Write("{\"success\": true, \"nonce\": \"" + nonce + "\"}");
                }
                else
                {
                    Response.Write("{\"success\": false, \"message\": \"Failed to generate nonce\"}");
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Nonce API error: " + ex.Message);
                Response.Write("{\"success\": false, \"message\": \"Server error: " + ex.Message.Replace("\"", "'") + "\"}");
            }

            Response.End();
        }
    }
}