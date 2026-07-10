using System;

namespace Mexify.Models
{
    public class MiningPlan
    {
        public int MiningPlanId { get; set; }
        public string PlanName { get; set; }
        public decimal Hashrate { get; set; }          // TH/s
        public decimal Price { get; set; }             // USD
        public int ContractDays { get; set; }
        public decimal DailyOutput { get; set; }       // PNC per day
        public decimal PowerConsumption { get; set; }  // Watts
        public bool IsPopular { get; set; }
        public bool IsActive { get; set; }
    }

    public class MiningContract
    {
        public long MiningContractId { get; set; }
        public int UserId { get; set; }
        public int MiningPlanId { get; set; }
        public string PlanName { get; set; }
        public decimal Hashrate { get; set; }
        public decimal DailyOutput { get; set; }
        public decimal PowerConsumption { get; set; }
        public decimal TotalEarned { get; set; }
        public int ContractDays { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int Status { get; set; } // 1=Active, 2=Expired, 3=Stopped
        public int DaysElapsed { get; set; }
        public int DaysRemaining { get; set; }
        public int ProgressPercent { get; set; }
    }

    public class MiningEarning
    {
        public long EarningId { get; set; }
        public long MiningContractId { get; set; }
        public string PlanName { get; set; }
        public decimal Hashrate { get; set; }
        public decimal Amount { get; set; }
        public int Status { get; set; }
        public string StatusName { get; set; }
        public string TxHash { get; set; }
        public DateTime EarnedDate { get; set; }
    }

    public class MiningStats
    {
        public decimal TotalHashrate { get; set; }
        public decimal DailyEarning { get; set; }
        public int ActiveRigs { get; set; }
        public decimal TotalEarned { get; set; }
        public decimal TodayEarnings { get; set; }
        public decimal PendingPayout { get; set; }
        public decimal ThisMonthEarnings { get; set; }
    }

    public class ChartDataPoint
    {
        public DateTime Date { get; set; }
        public decimal Value { get; set; }
    }
}