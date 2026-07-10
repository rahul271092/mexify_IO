using System;
using System.Web.UI;
using Mexify.Business.Services;
using Mexify.Utilities;

namespace Mexify.Web.User
{
    public partial class Licenses : System.Web.UI.Page
    {
        private LicenseService _licenseService;
        private int _userId;

        // Properties for Markup binding
        public string CurrentLicenseClass { get; private set; } = "silver";
        public string CurrentLicenseIcon { get; private set; } = "fas fa-medal";
        public string CurrentLicenseExpiryIso { get; private set; } = "";

        public bool IsSilverActive { get; private set; }
        public bool IsGoldActive { get; private set; }
        public bool IsPlatinumActive { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.IsAuthenticated || Session["UserId"] == null)
            {
                Response.Redirect(ResolveUrl("~/Web/login.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl)));
                return;
            }

            _userId = Convert.ToInt32(Session["UserId"]);
            _licenseService = new LicenseService();

            if (!IsPostBack)
            {
                LoadLicenseData();
            }
        }

        private void LoadLicenseData()
        {
            try
            {
                var master = this.Master as Mexify.Web.MasterPages.UserMaster;
                if (master != null)
                {
                    master.SetPageTitle("My Licenses");
                    master.SetBreadcrumb("Licenses");
                }

                var userLicense = _licenseService.GetUserActiveLicense(_userId);

                if (userLicense == null || !userLicense.IsActive)
                {
                    pnlNoLicense.Visible = true;
                    pnlActiveLicense.Visible = false;
                    CurrentLicenseClass = "silver"; // Default
                }
                else
                {
                    pnlNoLicense.Visible = false;
                    pnlActiveLicense.Visible = true;

                    CurrentLicenseClass = userLicense.LicenseType.ToLower();
                    CurrentLicenseExpiryIso = userLicense.ExpiryDate.ToString("yyyy-MM-ddTHH:mm:ss");

                    litCurrentTierName.Text = userLicense.LicenseName;
                    litExpiryDate.Text = userLicense.ExpiryDate.ToString("MMMM dd, yyyy");

                    var daysRemaining = (userLicense.ExpiryDate - DateTime.UtcNow).Days;
                    litDaysRemaining.Text = daysRemaining > 0 ? daysRemaining.ToString() : "0";
                    litLicenseStatus.Text = daysRemaining > 0 ? "Active" : "Expired";

                    // Set Icons
                    switch (userLicense.LicenseType)
                    {
                        case "Silver": CurrentLicenseIcon = "fas fa-medal"; break;
                        case "Gold": CurrentLicenseIcon = "fas fa-crown"; break;
                        case "Platinum": CurrentLicenseIcon = "fas fa-gem"; break;
                        default: CurrentLicenseIcon = "fas fa-id-card"; break;
                    }

                    // Check which tiers are active for buttons
                    string activeType = userLicense.LicenseType;
                    IsSilverActive = activeType == "Silver";
                    IsGoldActive = activeType == "Gold";
                    IsPlatinumActive = activeType == "Platinum";

                    // Generate Benefits HTML
                    litBenefits.Text = GenerateBenefitsHtml(userLicense.LicenseType);
                }

                // Load History
                var history = _licenseService.GetLicenseHistory(_userId);
                if (history != null && history.Count > 0)
                {
                    rptHistory.DataSource = history;
                    rptHistory.DataBind();
                    pnlNoHistory.Visible = false;
                }
                else
                {
                    pnlNoHistory.Visible = true;
                }
            }
            catch (Exception ex)
            {
                Logger.Error("License page load failed for user " + _userId, ex);
            }
        }

        private string GenerateBenefitsHtml(string licenseType)
        {
            string benefits = "<div class='benefits-grid'>";

            switch (licenseType)
            {
                case "Silver":
                    benefits += BenefitItem("fas fa-check", "5% Referral Bonus");
                    benefits += BenefitItem("fas fa-lock", "Standard Fees", locked: true);
                    benefits += BenefitItem("fas fa-lock", "Premium Pools", locked: true);
                    break;
                case "Gold":
                    benefits += BenefitItem("fas fa-check", "10% Referral Bonus");
                    benefits += BenefitItem("fas fa-check", "15% Fee Discount");
                    benefits += BenefitItem("fas fa-check", "2 Premium Pools");
                    break;
                case "Platinum":
                    benefits += BenefitItem("fas fa-check", "15% Referral Bonus");
                    benefits += BenefitItem("fas fa-check", "50% Fee Discount");
                    benefits += BenefitItem("fas fa-check", "All Premium Pools");
                    benefits += BenefitItem("fas fa-check", "Dedicated Manager");
                    break;
            }
            benefits += "</div>";
            return benefits;
        }

        private string BenefitItem(string icon, string text, bool locked = false)
        {
            return $"<div class='benefit-item {(locked ? "locked" : "")}'>< i class='{icon}'></i><span class='benefit-text'>{text}</span></div>";
        }

protected void btnBuySilver_Click(object sender, EventArgs e) => PurchaseLicense("Silver", 500);
protected void btnBuyGold_Click(object sender, EventArgs e) => PurchaseLicense("Gold", 1500);
protected void btnBuyPlatinum_Click(object sender, EventArgs e) => PurchaseLicense("Platinum", 5000);
protected void btnRenew_Click(object sender, EventArgs e)
{
    // Logic to renew current tier
    var current = _licenseService.GetUserActiveLicense(_userId);
    if (current != null && current.IsActive)
    {
        // Map tier name to price
        decimal price = 500; // Default Silver
        switch (current.LicenseType)
        {
            case "Silver": price = 500; break;
            case "Gold": price = 1500; break;
            case "Platinum": price = 5000; break;
        }
        PurchaseLicense(current.LicenseType, price);
    }
}

private void PurchaseLicense(string tier, decimal amount)
{
    pnlUpgradeError.Visible = false;
    pnlUpgradeSuccess.Visible = false;

    try
    {
        // Check wallet balance (simplified for UI demo)
        var walletService = new WalletService();
        var wallet = walletService.GetUserWallet(_userId, 1); // Assuming ID 1 is PNC
        if (wallet == null || wallet.Balance < amount)
        {
            pnlUpgradeError.Visible = true;
            litUpgradeError.Text = $"Insufficient PNC balance. Required: {amount} PNC.";
            return;
        }

        var result = _licenseService.PurchaseLicense(_userId, tier, amount);
        if (result.Success)
        {
            pnlUpgradeSuccess.Visible = true;
            litUpgradeSuccess.Text = $"Successfully upgraded to {tier} License!";
            LoadLicenseData(); // Refresh data
        }
        else
        {
            pnlUpgradeError.Visible = true;
            litUpgradeError.Text = result.ErrorMessage;
        }
    }
    catch (Exception ex)
    {
        pnlUpgradeError.Visible = true;
        litUpgradeError.Text = "Transaction failed: " + ex.Message;
    }
}

public string GetLicenseIcon(object type)
{
    if (type == null) return "fas fa-id-card";
    string t = type.ToString();
    if (t == "Silver") return "fas fa-medal";
    if (t == "Gold") return "fas fa-crown";
    if (t == "Platinum") return "fas fa-gem";
    return "fas fa-id-card";
}

public string GetLicenseColor(object type)
{
    if (type == null) return "#6B758D";
    string t = type.ToString();
    if (t == "Silver") return "#C0C0C0";
    if (t == "Gold") return "#FFD700";
    if (t == "Platinum") return "#E5E4E2";
    return "#6B758D";
}
    }
}