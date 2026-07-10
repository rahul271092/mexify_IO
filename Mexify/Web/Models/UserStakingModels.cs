using System;
using System.Collections.Generic;

namespace Mexify.Models
{
    public class UserStakingSummary
    {
        public decimal TotalStaked { get; set; }
        public int ActiveStakes { get; set; }
        public decimal TotalRewards { get; set; }
        public decimal DailyRewards { get; set; }
        public decimal AverageAPY { get; set; }
        public decimal MonthRewards { get; set; }
        public decimal PendingRewards { get; set; }
    }

    public class UserStake
    {
        public long StakingInvestmentId { get; set; }
        public string PlanName { get; set; }
        public string CurrencyCode { get; set; }
        public decimal Amount { get; set; }
        public decimal APY { get; set; }
        public int LockPeriodDays { get; set; }
        public decimal TotalRewards { get; set; }
        public decimal DailyReward { get; set; }
        public int ProgressPercent { get; set; }
        public int Status { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string EndDateIso { get; set; }
        public bool AutoCompound { get; set; }
    }

    public class StakeReward
    {
        public long RewardId { get; set; }
        public long StakingInvestmentId { get; set; }
        public string PlanName { get; set; }
        public decimal Amount { get; set; }
        public DateTime DistributedDate { get; set; }
    }

    public class StakeDistributionItem
    {
        public string Name { get; set; }
        public decimal Value { get; set; }
    }

    public class RewardsHistoryPoint
    {
        public DateTime Date { get; set; }
        public decimal Value { get; set; }
    }
}