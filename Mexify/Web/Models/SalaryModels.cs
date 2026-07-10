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
        public int SelfProgress { get; set; }
        public int StrongProgress { get; set; }
        public int WeakerProgress { get; set; }
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