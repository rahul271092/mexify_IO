using Mexify.Business.Services;
using Mexify.Utilities;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Mexify.Web.api
{
    public partial class AuthAPI : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // CORS headers
            Response.AddHeader("Access-Control-Allow-Origin", "*");
            Response.AddHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
            Response.AddHeader("Access-Control-Allow-Headers", "Content-Type");

            if (Request.HttpMethod == "OPTIONS")
            {
                Response.StatusCode = 200;
                Response.End();
            }
        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string VerifyLogin(string wallet, string signature, string nonce)
        {
            try
            {
                var authService = new AuthService();
                var result = authService.VerifyMetaMaskLogin(wallet, signature, nonce);

                return JsonConvert.SerializeObject(new
                {
                    success = result.Success,
                    userId = result.UserId,
                    message = result.ErrorMessage ?? "Login successful"
                });
            }
            catch (Exception ex)
            {
                Logger.Error("VerifyLogin error", ex);
                return JsonConvert.SerializeObject(new
                {
                    success = false,
                    message = "Verification error: " + ex.Message
                });
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
        public static string GetNonce(string wallet)
        {
            try
            {
                if (string.IsNullOrEmpty(wallet))
                    return JsonConvert.SerializeObject(new { success = false, message = "Wallet required" });

                var authService = new AuthService();
                var nonce = authService.GetOrCreateNonce(wallet);

                return JsonConvert.SerializeObject(new { success = true, nonce = nonce });
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new { success = false, message = ex.Message });
            }
        }
    }
}