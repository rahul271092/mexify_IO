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


        //protected void Page_Load(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        // ==========================================
        //        // 1. AUTHENTICATION CHECK (with safe redirect)
        //        // ==========================================
        //        if (!Request.IsAuthenticated || Session == null || Session["UserId"] == null)
        //        {
        //            string returnUrl = Request.RawUrl ?? "~/Web/User/Dashboard.aspx";
        //            Response.Redirect(ResolveUrl("~/Web/MetaMaskLogin.aspx?returnUrl=" + Server.UrlEncode(returnUrl)), true);
        //            return; // Stop execution after redirect
        //        }

        //        // ==========================================
        //        // 2. INITIALIZE USER INFO (wrapped in try-catch)
        //        // ==========================================
        //        LoadUserInfo();
        //    }
        //    catch (Exception ex)
        //    {
        //        Logger.Error("UserMaster Page_Load failed", ex);

        //        // Don't crash the entire page — just show defaults
        //        try { SetDefaultUserInfo(); } catch { }
        //    }
        //}


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

        // ✅ Initialize with safe defaults so they're never null

        //private void LoadUserInfo()
        //{
        //    try
        //    {
        //        // ==========================================
        //        // 1. SAFELY GET USER ID FROM SESSION
        //        // ==========================================
        //        if (Session == null || Session["UserId"] == null)
        //        {
        //            Logger.Warn("Session[UserId] is null in UserMaster.LoadUserInfo");
        //            SetDefaultUserInfo();
        //            return;
        //        }

        //        int userId;
        //        if (!int.TryParse(Session["UserId"].ToString(), out userId) || userId <= 0)
        //        {
        //            Logger.Warn("Invalid UserId in session: " + Session["UserId"]);
        //            SetDefaultUserInfo();
        //            return;
        //        }

        //        // ==========================================
        //        // 2. FETCH USER FROM DATABASE (with null checks)
        //        // ==========================================
        //        Models.User user = null;
        //        try
        //        {
        //            var userService = new Business.Services.UserService();
        //            user = userService.GetUserById(userId);
        //        }
        //        catch (Exception ex)
        //        {
        //            Logger.Error("Failed to fetch user " + userId, ex);
        //        }

        //        // If user not found, use defaults
        //        if (user == null)
        //        {
        //            Logger.Warn("User not found in DB for UserId: " + userId);
        //            SetDefaultUserInfo();
        //            return;
        //        }

        //        // ==========================================
        //        // 3. SAFELY POPULATE UI CONTROLS
        //        // ==========================================

        //        // Full name (handle null first/last names)
        //        string firstName = user.FirstName ?? "User";
        //        string lastName = user.LastName ?? "";
        //        string fullName = (firstName + " " + lastName).Trim();
        //        if (string.IsNullOrWhiteSpace(fullName)) fullName = "User";

        //        // Email
        //        string email = user.Email ?? "";

        //        // Photo URL (with fallback)
        //        string photoUrl = !string.IsNullOrWhiteSpace(user.ProfilePhoto)
        //            ? ResolveUrl(user.ProfilePhoto)
        //            : "https://ui-avatars.com/api/?name=" + Server.UrlEncode(fullName) + "&background=D4AF37&color=000&size=100";

        //        // Tier (with fallback)
        //        string tier = !string.IsNullOrWhiteSpace(user.Tier) ? user.Tier : "Standard";

        //        // ==========================================
        //        // 4. SET LITERAL CONTROLS (with null checks)
        //        // ==========================================
        //        if (litUserName != null) litUserName.Text = fullName;
        //        if (litUserTier != null) litUserTier.Text = tier;
        //        if (litTopbarName != null) litTopbarName.Text = firstName;
        //        if (litTopbarEmail != null) litTopbarEmail.Text = email;
        //        if (litDropdownName != null) litDropdownName.Text = fullName;
        //        if (litDropdownEmail != null) litDropdownEmail.Text = email;
        //        if (litPageTitle != null && string.IsNullOrWhiteSpace(litPageTitle.Text))
        //            litPageTitle.Text = "Dashboard";
        //        if (litBreadcrumb != null && string.IsNullOrWhiteSpace(litBreadcrumb.Text))
        //            litBreadcrumb.Text = "Dashboard";

        //        // ==========================================
        //        // 5. SET PUBLIC PROPERTIES (for <img> onerror fallbacks)
        //        // ==========================================
        //        UserName = fullName;
        //        UserPhotoUrl = photoUrl;

        //        // ==========================================
        //        // 6. LOAD SIDEBAR BALANCE (defensive)
        //        // ==========================================
        //        try
        //        {
        //            var walletService = new Business.Services.WalletService();
        //            var wallets = walletService.GetUserWallets(userId);

        //            decimal usdtBalance = 0;
        //            if (wallets != null && wallets.Count > 0)
        //            {
        //                var usdtWallet = wallets.Find(w => w != null && w.CurrencyCode == "USDT");
        //                if (usdtWallet != null)
        //                {
        //                    usdtBalance = usdtWallet.Balance;
        //                }
        //                else
        //                {
        //                    // Fallback: sum all wallet values
        //                    foreach (var w in wallets)
        //                    {
        //                        if (w != null) usdtBalance += w.ValuePNC;
        //                    }
        //                }
        //            }

        //            if (litSidebarPNC != null)
        //            {
        //                litSidebarPNC.Text = usdtBalance.ToString("0.00");
        //            }
        //        }
        //        catch (Exception ex)
        //        {
        //            Logger.Error("Failed to load sidebar balance for user " + userId, ex);
        //            if (litSidebarPNC != null) litSidebarPNC.Text = "0.00";
        //        }

        //        // ==========================================
        //        // 7. LOAD NOTIFICATION COUNT (defensive)
        //        // ==========================================
        //        try
        //        {
        //            int notifCount = 0;
        //            // TODO: Replace with actual notification count query
        //            // notifCount = new NotificationService().GetUnreadCount(userId);

        //            if (litNotificationCount != null)
        //            {
        //                litNotificationCount.Text = notifCount.ToString();
        //            }
        //        }
        //        catch (Exception ex)
        //        {
        //            Logger.Error("Failed to load notification count", ex);
        //            if (litNotificationCount != null) litNotificationCount.Text = "0";
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Logger.Error("CRITICAL: UserMaster.LoadUserInfo failed", ex);
        //        SetDefaultUserInfo();
        //    }
        //}

        /// <summary>
        /// Sets safe default values for all UI controls when user data is unavailable
        /// </summary>
        private void SetDefaultUserInfo()
        {
            try
            {
                UserName = "Guest";
                UserPhotoUrl = "https://ui-avatars.com/api/?name=Guest&background=D4AF37&color=000&size=100";

                if (litUserName != null) litUserName.Text = "Guest";
                if (litUserTier != null) litUserTier.Text = "Standard";
                if (litTopbarName != null) litTopbarName.Text = "Guest";
                if (litTopbarEmail != null) litTopbarEmail.Text = "";
                if (litDropdownName != null) litDropdownName.Text = "Guest";
                if (litDropdownEmail != null) litDropdownEmail.Text = "";
                if (litSidebarPNC != null) litSidebarPNC.Text = "0.00";
                if (litNotificationCount != null) litNotificationCount.Text = "0";
            }
            catch (Exception ex)
            {
                Logger.Error("SetDefaultUserInfo also failed", ex);
            }
        }

        private void LoadUserInfo()
        {
            // Get from session (fastest)
            UserName = Session["UserName"] as string ?? "User";
            UserEmail = Session["Email"] as string ?? "";
            UserPhotoUrl = Session["UserPhoto"] as string ?? "";

            // Populate literals
            litUserName.Text = UserName;
            litTopbarName.Text = UserName.Split(' ')[0];
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

        protected void LogoutButton_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Session.Clear();
            Response.Redirect("~/Web/Default.aspx");
        }

        protected void Logout2Button_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Session.Clear();
            Response.Redirect("~/Web/Default.aspx");

        }
    }
}