using System;
using System.Collections.Generic;

namespace Mexify.Models
{
    //public class UserLicense
    //{
    //    public long LicenseId { get; set; }
    //    public string LicenseType { get; set; } // Silver, Gold, Platinum
    //    public string LicenseName { get; set; }
    //    public bool IsActive { get; set; }
    //    public DateTime StartDate { get; set; }
    //    public DateTime ExpiryDate { get; set; }
    //    public decimal Price { get; set; }
    //}

    public class LicensePurchaseResult
    {
        internal long LicenseId;

        public bool Success { get; set; }
        public string ErrorMessage { get; set; }
        public long NewLicenseId { get; set; }
    }

    public class LicenseHistoryItem
    {
        public long HistoryId { get; set; }
        public string LicenseType { get; set; }
        public string LicenseName { get; set; }
        public decimal Amount { get; set; }
        public DateTime PurchaseDate { get; set; }
        public DateTime ExpiryDate { get; set; }
        public bool IsActive { get; set; }
    }



    public class LicensePackage
    {
        public int PackageId { get; set; }
        public string PackageName { get; set; }
        public decimal Price { get; set; }
        public decimal DailyROI { get; set; }
        public int DurationDays { get; set; }
        public decimal TotalReturn { get; set; }
        public string CurrencyCode { get; set; }
        public string Benefits { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }
        public int ActivePartners { get; set; }
    }

    public class LicenseCommissionTier
    {
        public int Level { get; set; }
        public decimal CommissionPercent { get; set; }
        public bool IsActive { get; set; }
        public int TimesEarned { get; set; }
        public decimal LevelTotal { get; set; }
    }

    public class UserLicense
    {
        public long LicenseId { get; set; }
        public int UserId { get; set; }
        public int PackageId { get; set; }
        public string PackageName { get; set; }
        public decimal PurchasePrice { get; set; }
        public decimal DailyROI { get; set; }
        public int DurationDays { get; set; }
        public decimal TotalReturn { get; set; }
        public decimal TotalEarned { get; set; }
        public decimal DirectIncomeEarned { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int Status { get; set; }
        public int DaysElapsed { get; set; }
        public int DaysRemaining { get; set; }
        public int ProgressPercent { get; set; }
        public string LicenseType { get; internal set; }
        public string LicenseName { get; internal set; }
        public bool IsActive { get; internal set; }
        public DateTime ExpiryDate { get; internal set; }
        public decimal Price { get; internal set; }
    }

    public class LicenseCommission
    {
        public long CommissionId { get; set; }
        public int BeneficiaryUserId { get; set; }
        public int FromUserId { get; set; }
        public string FromUserName { get; set; }
        public long LicenseId { get; set; }
        public int Level { get; set; }
        public decimal PurchaseAmount { get; set; }
        public decimal CommissionPercent { get; set; }
        public decimal CommissionAmount { get; set; }
        public string CurrencyCode { get; set; }
        public int Status { get; set; }
        public DateTime CreatedDate { get; set; }
    }

    public class LicenseDailyReturn
    {
        public long ReturnId { get; set; }
        public long LicenseId { get; set; }
        public string PackageName { get; set; }
        public decimal ReturnAmount { get; set; }
        public decimal ROIPercent { get; set; }
        public string CurrencyCode { get; set; }
        public DateTime EarnedDate { get; set; }
    }

    public class LicenseStats
    {
        public int ActiveLicenses { get; set; }
        public decimal TotalROIEarned { get; set; }
        public decimal TotalDirectIncome { get; set; }
        public decimal TotalCommissionEarned { get; set; }
        public decimal TodayROI { get; set; }
        public decimal DailyProjectedROI { get; set; }
        public int DirectReferrals { get; set; }
        public List<UserLicense> MyLicenses { get; set; }
        public List<LicenseCommissionTier> LevelBreakdown { get; set; }
        public List<LicenseCommission> RecentCommissions { get; set; }
        public List<LicenseDailyReturn> RecentROI { get; set; }

        public LicenseStats()
        {
            MyLicenses = new List<UserLicense>();
            LevelBreakdown = new List<LicenseCommissionTier>();
            RecentCommissions = new List<LicenseCommission>();
            RecentROI = new List<LicenseDailyReturn>();
        }
    }

   
}