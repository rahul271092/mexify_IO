using System;

namespace Mexify.Models
{
    public class InvestmentStats
    {
        public decimal TotalInvested { get; set; }
        public int ActivePlans { get; set; }
        public int MaturedPlans { get; set; }
        public decimal TotalEarned { get; set; }
        public decimal TodayROI { get; set; }
    }

    public class UserInvestment
    {
        public long InvestmentId { get; set; }
        public string PlanName { get; set; }
        public decimal InvestedAmount { get; set; }
        public decimal DailyROI { get; set; }
        public decimal TotalEarned { get; set; }
        public decimal RemainingProfit { get; set; }
        public decimal FinalPayout { get; set; }
        public int CurrentDay { get; set; }
        public int TotalDays { get; set; }
        public decimal ProgressPercent { get; set; }
        public int Status { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string EndDateIso { get; set; }
    }
}