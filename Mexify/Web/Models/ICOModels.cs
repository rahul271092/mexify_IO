using System;
using System.Collections.Generic;

namespace Mexify.Models
{
    // =========================================
    // ICO PROJECT
    // =========================================
    public class ICOProject
    {
        public int ICOId { get; set; }
        public int ProjectId { get { return ICOId; } set { ICOId = value; } } // Alias
        public string ProjectName { get; set; }
        public string TokenSymbol { get; set; }
        public string TokenName { get; set; }
        public decimal TotalSupply { get; set; }
        public decimal TokensSold { get; set; }
        public decimal TokensRemaining { get; set; }
        public decimal PricePerToken { get; set; }
        public string CurrencyCode { get; set; }
        public decimal MinPurchase { get; set; }
        public decimal? MaxPurchase { get; set; }
        public decimal SoftCap { get; set; }
        public string SoftCapFormatted { get; set; }
        public decimal HardCap { get; set; }
        public string HardCapFormatted { get; set; }
        public decimal RaisedAmount { get; set; }
        public string RaisedFormatted { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int Status { get; set; }
        public string Description { get; set; }
        public string ShortDescription { get; set; }
        public string LogoUrl { get; set; }
        public string BannerUrl { get; set; }
        public decimal ProgressPercent { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }

        public string DisplayName => $"{ProjectName} ({TokenSymbol})";
    }

    // =========================================
    // ICO COMMISSION TIER
    // =========================================
    public class ICOCommissionTier
    {
        public int Level { get; set; }
        public decimal CommissionPercent { get; set; }
        public int RequiredDirects { get; set; }
        public bool IsActive { get; set; }
    }

    // =========================================
    // ICO PURCHASE
    // =========================================
    public class ICOPurchase
    {
        public long PurchaseId { get; set; }
        public int UserId { get; set; }
        public int ICOId { get; set; }
        public decimal TokensPurchased { get; set; }
        public decimal AmountPaid { get; set; }
        public string CurrencyCode { get; set; }
        public decimal PricePerToken { get; set; }
        public string TxHash { get; set; }
        public int Status { get; set; }
        public DateTime PurchaseDate { get; set; }
    }

    // =========================================
    // ICO COMMISSION
    // =========================================
    public class ICOCommission
    {
        public long CommissionId { get; set; }
        public int BeneficiaryUserId { get; set; }
        public int FromUserId { get; set; }
        public string FromUserName { get; set; }
        public long PurchaseId { get; set; }
        public int Level { get; set; }
        public decimal PurchaseAmount { get; set; }
        public decimal CommissionPercent { get; set; }
        public decimal CommissionAmount { get; set; }
        public int DirectReferralsAtTime { get; set; }
        public string CurrencyCode { get; set; }
        public int Status { get; set; }
        public DateTime CreatedDate { get; set; }
    }

    // =========================================
    // ICO COMMISSION LEVEL SUMMARY
    // =========================================
    public class ICOCommissionLevelSummary
    {
        public int Level { get; set; }
        public decimal CommissionPercent { get; set; }
        public int RequiredDirects { get; set; }
        public int TimesEarned { get; set; }
        public decimal LevelTotal { get; set; }
        public int CurrentDirects { get; set; }
        public bool IsQualified { get; set; }
    }

    // =========================================
    // ICO STATS
    // =========================================
    public class ICOStats
    {
        public decimal TotalTokensPurchased { get; set; }
        public decimal TotalInvested { get; set; }
        public decimal TotalCommissionEarned { get; set; }
        public int TotalPurchases { get; set; }
        public int TotalCommissions { get; set; }
        public int UniqueDownlines { get; set; }
        public int DirectReferrals { get; set; }
        public List<ICOCommissionLevelSummary> LevelBreakdown { get; set; }
        public List<ICOPurchase> RecentPurchases { get; set; }
        public List<ICOCommission> RecentCommissions { get; set; }

        public ICOStats()
        {
            LevelBreakdown = new List<ICOCommissionLevelSummary>();
            RecentPurchases = new List<ICOPurchase>();
            RecentCommissions = new List<ICOCommission>();
        }
    }

    // =========================================
    // ICO PURCHASE REQUEST/RESULT
    // =========================================
    public class ICOPurchaseRequest
    {
        public int UserId { get; set; }
        public int ICOId { get; set; }
        public decimal Amount { get; set; }
    }

    public class ICOPurchaseResult
    {
        public bool Success { get; set; }
        public string ErrorMessage { get; set; }
        public long PurchaseId { get; set; }
        public decimal TokensPurchased { get; set; }
    }
}