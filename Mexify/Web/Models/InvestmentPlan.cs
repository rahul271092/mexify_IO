using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class InvestmentPlan
    {
        // Core fields from InvestmentPlans table
        public int PlanId { get; set; }
        public string PlanName { get; set; }
        public decimal MinAmount { get; set; }
        public decimal MaxAmount { get; set; }
        public decimal DailyROI { get; set; }
        public int DurationDays { get; set; }
        public decimal CapitalReturnPercent { get; set; }
        public int RiskLevel { get; set; }
        public int CompoundingFrequency { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }

        // Display helper property (used in dropdown)
        public string DisplayName
        {
            get
            {
                return PlanName + " (" + DailyROI.ToString("0.##") + "% Daily / " + DurationDays + " Days)";
            }
        }

        // Calculated fields from stored procedure usp_GetActiveInvestmentPlans
        public decimal TotalROIPercent { get; set; }
        public decimal TotalPayoutPercent { get; set; }
        public decimal MinInvestmentProfit { get; set; }
        public decimal MaxInvestmentProfit { get; set; }
        public int ActiveInvestorCount { get; set; }
        public decimal TotalInvestedAmount { get; set; }
        public string RiskLevelLabel { get; set; }
        public decimal DepositFeePercent { get; internal set; }
        public decimal WithdrawalFeePercent { get; internal set; }
        public decimal DirectReferralPercent { get; internal set; }
        public decimal AdminFeePercent { get; internal set; }
        public decimal RoyaltyPercent { get; internal set; }
    }
}