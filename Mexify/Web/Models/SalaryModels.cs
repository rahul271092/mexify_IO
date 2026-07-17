using System;
using System.Collections.Generic;

namespace Mexify.Models
{
    public class UserSalaryDetails
    {
        public int? CurrentTierId { get; set; }
        public string TierCode { get; set; }
        public string TierName { get; set; }
        public int TierLevel { get; set; }
        public decimal SelfInvestment { get; set; }
        public decimal StrongLegVolume { get; set; }
        public decimal WeakerLegVolume { get; set; }
        public decimal CurrentMonthlySalary { get; set; }
        public DateTime? QualifiedDate { get; set; }
        public decimal RequiredSelfInvestment { get; set; }
        public decimal RequiredStrongLeg { get; set; }
        public decimal RequiredWeakerLeg { get; set; }
        public bool IsQualified { get; set; }
        public int StrongMissing { get;  set; }
        public object SelfMissing { get;  set; }
        public int WeakerMissing { get; set; }
    }

    public class InvestorTier
    {
        public int TierId { get; set; }
        public string TierCode { get; set; }
        public string TierName { get; set; }
        public int TierLevel { get; set; }
        public decimal SelfInvestment { get; set; }
        public decimal StrongLegVolume { get; set; }
        public decimal WeakerLegVolume { get; set; }
        public decimal MonthlySalary { get; set; }
        public string Requirements { get; set; }
        public bool IsActive { get; set; }
        public bool IsCurrentTier { get; set; }
        public bool IsQualified { get; set; }
        public decimal MinInvestment { get;  set; }
        public string Description { get;  set; }
        public decimal MaxInvestment { get;  set; }
        public decimal ReturnPercent { get;  set; }
        public int DurationDays { get;  set; }
        public decimal DailyReturn { get; set; }
        public string CurrencyCode { get;  set; }
        public string IconClass { get;  set; }
        public string Features { get;  set; }
        public string BadgeText { get;  set; }
        public string ColorClass { get;  set; }
        public bool IsFeatured { get;  set; }
        public string FormattedMinInvestment { get;  set; }
        public string InvestmentRange { get;  set; }
        public string ReturnDisplay { get;  set; }
        public string DurationDisplay { get;  set; }
        public string FormattedMaxInvestment { get;  set; }
        public decimal EstimatedReturn { get;  set; }
        public string ROIDisplay { get; set; }
    }

    public class SalaryPayment
    {
        public decimal Amount { get; internal set; }
        public string CurrencyCode { get; internal set; }
        public int DayNumber { get; internal set; }
        public string FormattedAmount { get;  set; }
        public string FormattedDate { get;  set; }
        public string FormattedTime { get;  set; }
        public string IconClass { get; set; }
        public DateTime PaymentDate { get;  set; }
        public long PaymentId { get;  set; }
        public string PlanName { get;  set; }
        public decimal SalaryAmount { get;  set; }
        public int Status { get;  set; }
        public string StatusColor { get;  set; }
        public string StatusName { get;  set; }
        public string StatusSlug { get;  set; }
        public string TimeAgo { get; set; }
        public int UserId { get;  set; }
        public long UserSalaryId { get;  set; }
    }


    public class TierProgress
    {
        public string TierCode { get; set; }
        public string TierName { get; set; }
        public int TierLevel { get; set; }
        public decimal RequiredSelf { get; set; }
        public decimal RequiredStrong { get; set; }
        public decimal RequiredWeaker { get; set; }
        public decimal NextSalary { get; set; }
        public decimal CurrentSelf { get; set; }
        public decimal CurrentStrong { get; set; }
        public decimal CurrentWeaker { get; set; }
        public decimal SelfProgress { get; set; }
        public decimal StrongProgress { get; set; }
        public decimal WeakerProgress { get; set; }

        public decimal OverallProgress { get; set; }
        public bool IsQualified { get; set; }
        public bool IsCurrentTier { get; set; }
        public bool IsNextTier { get; set; }
        public decimal SelfRemaining { get; set; }
        public decimal StrongRemaining { get; set; }
        public decimal WeakerRemaining { get; set; }
        public string IconClass { get; set; }
        public string ColorClass { get; set; }


    }

    public class SalaryRecord
    {
        public long SalaryId { get; set; }
        public int SalaryMonth { get; set; }
        public int SalaryYear { get; set; }
        public decimal SalaryAmount { get; set; }
        public DateTime PaymentDate { get; set; }
        public int PaymentStatus { get; set; }
        public string TierName { get; set; }
        public string MonthName { get; set; }
    }

    public class SalaryStats
    {
        public decimal TotalEarned { get; set; }
        public int PaymentsCount { get; set; }
        public decimal AveragePayment { get; set; }
    }
}