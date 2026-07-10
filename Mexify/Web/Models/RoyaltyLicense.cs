using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class RoyaltyLicense
    {
        public int LicenseId { get; set; }
        public string Title { get; set; }
        public string AssetType { get; set; }
        public string Description { get; set; }
        public decimal SharePrice { get; set; }
        public int TotalShares { get; set; }
        public int SharesAvailable { get; set; }
        public decimal RoyaltyRate { get; set; }
        public string CurrencyCode { get; set; }
        public bool IsPremium { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }

        public decimal Price { get; set; }


        public string DisplayName
        {
            get { return Title + " (" + RoyaltyRate.ToString("0.##") + "% Yield)"; }
        }

        public string LicenseName { get; internal set; }
        public int DurationDays { get; internal set; }
        public decimal MinInvestment { get; internal set; }
        public decimal CommissionPercent { get; internal set; }
        public decimal? MaxInvestment { get; internal set; }
    }
}