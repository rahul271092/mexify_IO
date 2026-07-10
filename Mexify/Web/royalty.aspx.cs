using Mexify.Business.Services;
using Mexify.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Mexify.Web
{
    public partial class royalty : System.Web.UI.Page
    {
        private RoyaltyService _service;
        private CMSService _cmsService;

        protected void Page_Load(object sender, EventArgs e)
        {
            _service = new RoyaltyService();
            _cmsService = new CMSService();

            if (!IsPostBack)
            {
                LoadLicenses();
                PopulateLicenseDropdown();
                LoadFAQs();
                CalculateRoyalty(null, null);
            }
        }

        private void LoadLicenses()
        {
            try
            {
                rptLicenses.DataSource = _service.GetActiveLicenses();
                rptLicenses.DataBind();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load royalty licenses", ex);
            }
        }

        private void PopulateLicenseDropdown()
        {
            try
            {
                var licenses = _service.GetActiveLicenses();
                ddlLicense.DataSource = licenses;
                ddlLicense.DataValueField = "LicenseId";
                ddlLicense.DataTextField = "DisplayName";
                ddlLicense.DataBind();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to populate license dropdown", ex);
            }
        }

        private void LoadFAQs()
        {
            try
            {
                rptFAQs.DataSource = _cmsService.GetActiveFAQs();
                rptFAQs.DataBind();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load FAQs", ex);
            }
        }

        public void CalculateRoyalty(object sender, EventArgs e)
        {
            try
            {
                int shares;
                int licenseId;

                int.TryParse(txtShares.Text, out shares);
                int.TryParse(ddlLicense.SelectedValue, out licenseId);

                if (shares <= 0) shares = 1;

                var license = _service.GetLicenseById(licenseId);
                if (license == null) return;

                decimal totalInvestment = shares * license.SharePrice;
                decimal annualIncome = totalInvestment * (license.RoyaltyRate / 100m);
                decimal quarterlyIncome = annualIncome / 4m;

                litAnnual.Text = annualIncome.ToString("0.00") + " PNC";
                litQuarterly.Text = quarterlyIncome.ToString("0.00") + " PNC";
            }
            catch (Exception ex)
            {
                Logger.Error("Royalty calculation failed", ex);
            }
        }

        public string GetLicenseIcon(object assetType)
        {
            if (assetType == null || assetType == DBNull.Value) return "fas fa-file-contract";
            string type = assetType.ToString().ToLower();
            if (type.Contains("patent")) return "fas fa-lightbulb";
            if (type.Contains("software")) return "fas fa-code";
            if (type.Contains("media") || type.Contains("music")) return "fas fa-music";
            if (type.Contains("real estate") || type.Contains("property")) return "fas fa-building";
            return "fas fa-certificate";
        }

        public string GetChartLabels()
        {
            try
            {
                int licenseId;
                int.TryParse(ddlLicense.SelectedValue, out licenseId);
                var license = _service.GetLicenseById(licenseId);
                if (license == null) return "[]";

                var labels = new List<string>();
                string[] quarters = { "Q1 2026", "Q2 2026", "Q3 2026", "Q4 2026", "Q1 2027", "Q2 2027", "Q3 2027", "Q4 2027" };
                foreach (var q in quarters) labels.Add("\"" + q + "\"");
                return "[" + string.Join(",", labels) + "]";
            }
            catch { return "[]"; }
        }

        public string GetChartData()
        {
            try
            {
                int shares;
                int licenseId;
                int.TryParse(txtShares.Text, out shares);
                int.TryParse(ddlLicense.SelectedValue, out licenseId);

                var license = _service.GetLicenseById(licenseId);
                if (license == null) return "[]";

                var data = new List<string>();
                decimal totalInvestment = shares * license.SharePrice;
                decimal annualIncome = totalInvestment * (license.RoyaltyRate / 100m);
                decimal quarterlyIncome = annualIncome / 4m;

                for (int i = 0; i < 8; i++)
                {
                    data.Add(quarterlyIncome.ToString("0.00"));
                }

                return "[" + string.Join(",", data) + "]";
            }
            catch { return "[]"; }
        }
    }
}