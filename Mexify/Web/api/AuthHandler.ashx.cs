using System;
using System.IO;
using System.Web;
using Newtonsoft.Json;
using Mexify.Business.Services;

namespace Mexify.Web.Api
{
    public class AuthHandler : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            context.Response.AddHeader("Access-Control-Allow-Origin", "*");
            context.Response.AddHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
            context.Response.AddHeader("Access-Control-Allow-Headers", "Content-Type");

            if (context.Request.HttpMethod == "OPTIONS")
            {
                context.Response.StatusCode = 200;
                context.Response.End();
                return;
            }

            string action = context.Request["action"] ?? "";

            try
            {
                string result = "";

                if (action.ToLower() == "getnonce")
                {
                    result = HandleGetNonce(context);
                }
                else
                {
                    result = JsonConvert.SerializeObject(new { success = false, message = "Invalid action" });
                }

                context.Response.Write(result);
            }
            catch (Exception ex)
            {
                context.Response.Write(JsonConvert.SerializeObject(new
                {
                    success = false,
                    message = "Server error: " + ex.Message
                }));
            }
        }

        private string HandleGetNonce(HttpContext context)
        {
            string wallet = "";

            if (context.Request.HttpMethod == "POST")
            {
                context.Request.InputStream.Position = 0;
                using (var reader = new StreamReader(context.Request.InputStream))
                {
                    string body = reader.ReadToEnd();
                    try
                    {
                        dynamic data = JsonConvert.DeserializeObject(body);
                        wallet = data.wallet ?? "";
                    }
                    catch
                    {
                        wallet = context.Request["wallet"] ?? "";
                    }
                }
            }
            else
            {
                wallet = context.Request["wallet"] ?? "";
            }

            if (string.IsNullOrEmpty(wallet))
            {
                return JsonConvert.SerializeObject(new { success = false, message = "Wallet address required" });
            }

            try
            {
                var authService = new AuthService();
                var nonce = authService.GetOrCreateNonce(wallet);

                return JsonConvert.SerializeObject(new
                {
                    success = true,
                    nonce = nonce,
                    message = "Nonce generated"
                });
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new
                {
                    success = false,
                    message = "Error: " + ex.Message
                });
            }
        }

        public bool IsReusable => false;
    }
}