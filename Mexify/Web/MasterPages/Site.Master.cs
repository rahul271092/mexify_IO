using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Mexify.Business.Services;
using System.Web.Security;

namespace Mexify.Web.MasterPages
{
    public partial class Site : System.Web.UI.MasterPage
    {

        // Expose properties so child pages can override the Title and Meta tags
        public string PageTitle
        {
            get { return litPageTitle.Text; }
            set { litPageTitle.Text = value; Page.Title = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Default Title if not overridden by child page
                if (string.IsNullOrEmpty(litPageTitle.Text))
                {
                    PageTitle = "MEXIFY | Institutional-Grade Crypto Asset Management";
                    ClearSession();
                }
            }
        }


        public void ClearSession()
        {
            // Log the logout event
            if (Session["UserId"] != null)
            {
                try
                {
                    Mexify.Utilities.Logger.Info($"User {Session["UserId"]} logged out");
                }
                catch { }
            }

            // Clear all session data
            Session.Clear();
            Session.Abandon();

            // Clear authentication cookie
            if (Request.Cookies["ASP.NET_SessionId"] != null)
            {
                HttpCookie cookie = new HttpCookie("ASP.NET_SessionId", "");
                cookie.Expires = DateTime.Now.AddYears(-1);
                Response.Cookies.Add(cookie);
            }

            // Clear Forms Authentication cookie (if used)
            if (Request.Cookies[FormsAuthentication.FormsCookieName] != null)
            {
                HttpCookie authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, "");
                authCookie.Expires = DateTime.Now.AddYears(-1);
                Response.Cookies.Add(authCookie);
            }

            // Redirect to login
            Response.Redirect("~/Web/MetaMaskLogin.aspx?logout=1", false);

        }

        protected void btnSubscribe_Click(object sender, EventArgs e)
        {
            string email = txtNewsletterEmail.Text.Trim();

            if (string.IsNullOrEmpty(email) || !email.Contains("@"))
            {
         //       lblNewsletterMsg1.Text = "Please enter a valid email address.";
          //      lblNewsletterMsg1.CssClass = "text-danger mt-2 d-block";
                return;
            }

            try
            {
                // Call Business Layer to save subscriber
                var cmsService = new CMSService();
                cmsService.AddNewsletterSubscriber(email);

            //    lblNewsletterMsg1.Text = "Thank you for subscribing!";
             //   lblNewsletterMsg1.CssClass = "text-success mt-2 d-block";
                txtNewsletterEmail.Text = string.Empty;
            }
            catch (Exception ex)
            {
                // Log error
                Mexify.Utilities.Logger.Error("Newsletter Subscription Failed", ex);
               // lblNewsletterMsg1.Text = "An error occurred. Please try again later.";
              //  lblNewsletterMsg1.CssClass = "text-danger mt-2 d-block";
            }
        }

    }
}