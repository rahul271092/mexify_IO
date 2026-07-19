using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class SalaryPlan
    {
        public int PlanId { get; set; }
        public string PlanName { get; set; }
        public string PlanSlug { get; set; }
        public string Description { get; set; }
        public string ShortDescription { get; set; }
        public decimal InvestmentAmount { get; set; }
        public string CurrencyCode { get; set; }
        public decimal DailySalary { get; set; }
        public int DurationDays { get; set; }
        public decimal TotalEarning { get; set; }
        public int? RequiredTierId { get; set; }
        public string RequiredTierCode { get; set; }
        public decimal MinSelfInvestment { get; set; }
        public decimal MinTeamBusiness { get; set; }
        public string IconClass { get; set; }
        public string ColorClass { get; set; }
        public string BadgeText { get; set; }
        public bool IsPopular { get; set; }
        public bool IsFeatured { get; set; }
        public int? MaxUsers { get; set; }
        public int CurrentUsers { get; set; }
        public int AvailableSlots { get; set; }
        public bool IsEligible { get; set; }
        public bool HasRequiredTier { get; set; }

        // Display
        public string FormattedInvestment { get; set; }
        public string FormattedDailySalary { get; set; }
        public string FormattedTotalEarning { get; set; }
        public string RequirementText { get; set; }
        public string AvailabilityText { get; set; }

        // Features (loaded separately)
        public List<SalaryPlanFeature> Features { get; set; } = new List<SalaryPlanFeature>();
    }

    public class SalaryPlanFeature
    {
        public int FeatureId { get; set; }
        public int PlanId { get; set; }
        public string FeatureText { get; set; }
        public string IconClass { get; set; }
        public bool IsIncluded { get; set; }
    }

    public class UserSalarySubscription
    {
        public long SubscriptionId { get; set; }
        public int UserId { get; set; }
        public int PlanId { get; set; }
        public string PlanName { get; set; }
        public decimal InvestmentAmount { get; set; }
        public decimal DailySalary { get; set; }
        public int DurationDays { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public DateTime? LastPaymentDate { get; set; }
        public DateTime? NextPaymentDate { get; set; }
        public decimal TotalEarned { get; set; }
        public int TotalDaysPaid { get; set; }
        public int Status { get; set; }
        public string StatusName { get; set; }
    }
}