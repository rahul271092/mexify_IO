using Mexify.Web.User;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class LicenseHistoryItem
    {
        public long LicenseId { get; set; }  // ✅ Must match the stored procedure column name
        public string PackageName { get; set; }
        public decimal PurchasePrice { get; set; }
        public decimal DailyROI { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public decimal TotalEarned { get; set; }
        public int Status { get; set; }
        public string StatusName { get; set; }
        public string StatusSlug { get; set; }
        public int TotalDays { get; set; }
        public int DaysRemaining { get; set; }
        public int DaysElapsed { get; set; }
        public decimal ProgressPercent { get; set; }
        public decimal DailyEarning { get; set; }
        public decimal ProjectedTotalReturn { get; set; }
        public decimal ROIAchieved { get; set; }
        public decimal ProfitLoss { get; set; }
        public DateTime? NextPayoutDate { get; set; }
        public DateTime CreatedDate { get; set; }
        public long HistoryId { get; internal set; }
        public string LicenseType { get; internal set; }
        public string LicenseName { get; internal set; }
        public DateTime ExpiryDate { get; internal set; }
        public decimal Amount { get; internal set; }
        public bool IsActive { get; internal set; }
        public DateTime PurchaseDate { get; internal set; }
    }


    public class LicensePayout
    {
        public long WalletTransactionId { get; set; }
        public decimal Amount { get; set; }
        public string CurrencyCode { get; set; }
        public DateTime CreatedDate { get; set; }
        public string TimeAgo { get; set; }
        public string IconClass { get; set; }
        public string CategoryClass { get; set; }
    }

    public class LicenseMonthlyEarning
    {
        public string MonthLabel { get; set; }
        public decimal MonthlyEarnings { get; set; }
        public int PayoutCount { get; set; }
        public string ChartColor { get; set; }
    }

    public class LicenseHistoryResult
    {
        public LicenseHistorySummary Summary { get; set; } = new LicenseHistorySummary();
        public List<LicenseHistoryItem> Licenses { get; set; } = new List<LicenseHistoryItem>();
        public List<LicensePayout> RecentPayouts { get; set; } = new List<LicensePayout>();
        public List<LicenseMonthlyEarning> MonthlyEarnings { get; set; } = new List<LicenseMonthlyEarning>();
        public int TotalCount { get; set; }
        public int PageNumber { get; set; }
        public int PageSize { get; set; }
        public int TotalPages => PageSize > 0 ? (int)Math.Ceiling((double)TotalCount / PageSize) : 0;
    }


    public class ActiveLicense
    {
        public long LicenseId { get; set; }
        public string PackageName { get; set; }
        public decimal PurchasePrice { get; set; }
        public decimal DailyROI { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public decimal TotalEarned { get; set; }
        public int Status { get; set; }
        public string StatusName { get; set; }
        public int TotalDays { get; set; }
        public int DaysRemaining { get; set; }
        public decimal ProgressPercent { get; set; }
        public decimal DailyEarning { get; set; }
        public decimal ProjectedTotalReturn { get; set; }
        public DateTime NextPayoutDate { get; set; }
        public int DaysElapsed { get; set; }

        public string ProgressClass => ProgressPercent >= 100 ? "text-success" : (ProgressPercent >= 50 ? "text-gold" : "text-muted");
    }


    public class LicenseResult
    {
        public List<ActiveLicense> Licenses { get; set; } = new List<ActiveLicense>();
        public List<LicensePayout> RecentPayouts { get; set; } = new List<LicensePayout>();
        public bool HasActiveLicense => Licenses.Count > 0;
    }

}