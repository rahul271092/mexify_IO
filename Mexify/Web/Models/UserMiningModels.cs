using System;
using System.Collections.Generic;

namespace Mexify.Models
{
    public class UserMiningSummary
    {
        public decimal TotalHashrate { get; set; }
        public int ActiveContracts { get; set; }
        public decimal DailyRewards { get; set; }
        public decimal TotalEarned { get; set; }
        public decimal TotalInvested { get; set; }
        public decimal MonthRewards { get; set; }
        public decimal TodayRewards { get; set; }
    }

    public class UserMiningContract
    {
        public long MiningInvestmentId { get; set; }
        public string PlanName { get; set; }
        public string Algorithm { get; set; }
        public string HashrateFormatted { get; set; }
        public decimal Hashrate { get; set; }
        public int DurationDays { get; set; }
        public decimal Price { get; set; }
        public decimal TotalRewards { get; set; }
        public decimal DailyReward { get; set; }
        public int ProgressPercent { get; set; }
        public int Status { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string EndDateIso { get; set; }
    }

    public class MiningReward
    {
        public long RewardId { get; set; }
        public long MiningInvestmentId { get; set; }
        public string PlanName { get; set; }
        public decimal Amount { get; set; }
        public DateTime DistributedDate { get; set; }
    }

    public class HashrateDistributionItem
    {
        public string Name { get; set; }
        public decimal Value { get; set; }
    }

    public class MiningRewardsHistoryPoint
    {
        public DateTime Date { get; set; }
        public decimal Value { get; set; }
    }

    public class DistributionItem
    {
        public string Name { get; set; }
        public decimal Value { get; set; }
    }
}