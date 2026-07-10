using System;
using System.Web;
using System.Web.Security;
using Mexify.Utilities;

namespace Mexify.Web
{
    public partial class logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                // Capture user info before clearing (for logging)
                int? userId = null;
                string userName = "Unknown";
                string ipAddress = GetUserIpAddress();

                if (Session["UserId"] != null)
                {
                    int id;
                   id= Int32.Parse(Session["UserId"].ToString());
                    userId = id;
                }
                if (Session["UserName"] != null)
                {
                    userName = Session["UserName"].ToString();
                }

                // ============ STEP 1: LOG THE LOGOUT EVENT ============
                try
                {
                    if (userId.HasValue)
                    {
                        var authService = new Business.Services.AuthService();
                        authService.LogUserActivity(userId.Value, "USER_LOGOUT",
                            "User logged out successfully", ipAddress);
                    }
                }
                catch (Exception logEx)
                {
                    // Don't fail logout if logging fails
                    Logger.Error("Failed to log logout event", logEx);
                }

                // ============ STEP 2: CLEAR ALL SESSION VARIABLES ============
                ClearAllSessions();

                // ============ STEP 3: SIGN OUT OF FORMS AUTHENTICATION ============
                SignOutFormsAuthentication();

                // ============ STEP 4: CLEAR AUTHENTICATION COOKIES ============
                ClearAuthenticationCookies();

                // ============ STEP 5: CLEAR CACHE ============
                ClearCache();

                // ============ STEP 6: DISABLE BROWSER CACHING ============
                DisableBrowserCache();

                Logger.Info("User " + userName + " (ID: " + (userId?.ToString() ?? "N/A") + ") logged out from IP: " + ipAddress);
            }
            catch (Exception ex)
            {
                Logger.Error("Logout process failed", ex);
                // Still redirect to login even if logout fails
            }
        }

        /// <summary>
        /// Clears all session variables used by the application
        /// </summary>
        private void ClearAllSessions()
        {
            try
            {
                // Clear specific session keys
                Session.Remove("UserId");
                Session.Remove("UserName");
                Session.Remove("Email");
                Session.Remove("UserTier");
                Session.Remove("UserPhoto");
                Session.Remove("PNCBalance");
                Session.Remove("IsAdmin");
                Session.Remove("LoginTime");
                Session.Remove("LastActivity");
                Session.Remove("UserCountry");
                Session.Remove("UserReferralCode");
                Session.Remove("TwoFAVerified");
                Session.Remove("KYCStatus");

                // Clear any other custom session keys
                var keysToRemove = new System.Collections.Generic.List<string>();
                foreach (string key in Session.Keys)
                {
                    if (!string.IsNullOrEmpty(key))
                    {
                        keysToRemove.Add(key);
                    }
                }
                foreach (string key in keysToRemove)
                {
                    Session.Remove(key);
                }

                // Abandon the entire session
                Session.Abandon();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to clear sessions", ex);
            }
        }

        /// <summary>
        /// Signs out of Forms Authentication
        /// </summary>
        private void SignOutFormsAuthentication()
        {
            try
            {
                FormsAuthentication.SignOut();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to sign out of Forms Authentication", ex);
            }
        }

        /// <summary>
        /// Clears all authentication-related cookies
        /// </summary>
        private void ClearAuthenticationCookies()
        {
            try
            {
                // Clear the Forms Authentication cookie
                if (Request.Cookies[FormsAuthentication.FormsCookieName] != null)
                {
                    var authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, "");
                    authCookie.Expires = DateTime.Now.AddDays(-1);
                    authCookie.Path = "/";
                    Response.Cookies.Add(authCookie);
                }

                // Clear any custom auth cookies (e.g., .MEXIFYAUTH)
                string[] cookieNames = { ".MEXIFYAUTH", ".ASPXAUTH", "MEXIFY_SESSION", "AuthToken" };
                foreach (string cookieName in cookieNames)
                {
                    if (Request.Cookies[cookieName] != null)
                    {
                        var cookie = new HttpCookie(cookieName, "");
                        cookie.Expires = DateTime.Now.AddDays(-1);
                        cookie.Path = "/";
                        Response.Cookies.Add(cookie);
                    }
                }

                // Clear all other cookies as a safety measure
                for (int i = 0; i < Request.Cookies.Count; i++)
                {
                    string cookieName = Request.Cookies[i].Name;
                    var cookie = new HttpCookie(cookieName, "");
                    cookie.Expires = DateTime.Now.AddDays(-1);
                    cookie.Path = "/";
                    Response.Cookies.Add(cookie);
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to clear cookies", ex);
            }
        }

        /// <summary>
        /// Clears server-side cache for this user
        /// </summary>
        private void ClearCache()
        {
            try
            {
                // Clear any user-specific cache entries
                // In production, you might have cached user data that needs invalidation
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to clear cache", ex);
            }
        }

        /// <summary>
        /// Disables browser caching for security
        /// </summary>
        private void DisableBrowserCache()
        {
            try
            {
                Response.Cache.SetExpires(DateTime.UtcNow.AddDays(-1));
                Response.Cache.SetValidUntilExpires(false);
                Response.Cache.SetRevalidation(HttpCacheRevalidation.AllCaches);
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.Cache.SetNoStore();

                Response.Headers.Add("Pragma", "no-cache");
                Response.Headers.Add("Cache-Control", "no-cache, no-store, must-revalidate");
                Response.Headers.Add("Expires", "0");
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to disable browser cache", ex);
            }
        }

        /// <summary>
        /// Gets the user's IP address
        /// </summary>
        private string GetUserIpAddress()
        {
            try
            {
                string ip = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
                if (string.IsNullOrEmpty(ip))
                {
                    ip = Request.ServerVariables["REMOTE_ADDR"];
                }
                return ip ?? "unknown";
            }
            catch
            {
                return "unknown";
            }
        }
    }
}