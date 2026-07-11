using System;
using System.Web.UI;
using Mexify.Utilities;

namespace Mexify.Web.MasterPages
{
    public partial class UserMaster : MasterPage
    {
        // Public properties for use in ASPX markup
        public string UserName { get; private set; }
        public string UserPhotoUrl { get; private set; }
        public string UserEmail { get; private set; }

        public string WalletAddress { get; private set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            // Authentication check
            if (!Request.IsAuthenticated || Session["UserId"] == null)
            {
                string returnUrl = Server.UrlEncode(Request.RawUrl);
                Response.Redirect(ResolveUrl("~/Web/login.aspx?returnUrl=" + returnUrl));
                return;
            }

            if (!IsPostBack)
            {
                try
                {
                    LoadUserInfo();
                    LoadSidebarStats();
                }
                catch (Exception ex)
                {
                    Logger.Error("UserMaster initialization failed", ex);
                }
            }
        }

        private void LoadUserInfo()
        {
            // Get from session (fastest)
            UserName = Session["UserName"] as string ?? "User";
            UserEmail = Session["Email"] as string ?? "";
            UserPhotoUrl = Session["UserPhoto"] as string ?? "";
            WalletAddress = Session["WalletAddress"] as string;
            // Populate literals
            litUserName.Text = UserName;
            litTopbarName.Text = WalletAddress;
            litTopbarEmail.Text = UserEmail;
            litDropdownName.Text = UserName;
            litDropdownEmail.Text = UserEmail;
            litUserTier.Text = Session["UserTier"] as string ?? "Standard";

            litSidebarPNC.Text = Session["TotalBalance"].ToString() + " USDT";
        }

        private void LoadSidebarStats()
        {
            try
            {
                // PNC Balance from session
                decimal pncBalance = 0;
                if (Session["TotalBalance"] != null)
                {
                    decimal.TryParse(Session["TotalBalance"].ToString(), out pncBalance);
                }
                litSidebarPNC.Text = pncBalance.ToString("0.00 USDT");
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load sidebar stats", ex);
                litSidebarPNC.Text = "0.00";
            }
        }

        /// <summary>
        /// Returns "active" class if current page matches the menu item.
        /// Used for highlighting the current navigation link.
        /// </summary>
        protected string IsActive(string pageName)
        {
            try
            {
                string current = System.IO.Path.GetFileNameWithoutExtension(Request.Path);
                return string.Equals(current, pageName, StringComparison.OrdinalIgnoreCase) ? "active" : "";
            }
            catch
            {
                return "";
            }
        }

        /// <summary>
        /// Sets the page title for the browser tab
        /// </summary>
        public void SetPageTitle(string title)
        {
            litPageTitle.Text = title;
            Page.Title = title + " | MEXIFY";
        }

        /// <summary>
        /// Sets the breadcrumb text
        /// </summary>
        public void SetBreadcrumb(string text)
        {
            litBreadcrumb.Text = text;
        }
    }
}