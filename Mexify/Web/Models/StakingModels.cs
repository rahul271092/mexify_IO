using System;
using System.Collections.Generic;

namespace Mexify.Models
{
    public class StakingPool
    {
        public int PoolId { get; set; }
        public string PoolName { get; set; }
        public string CurrencyCode { get; set; }
        public int CurrencyId { get; set; }
        public decimal APY { get; set; }
        public decimal MinStake { get; set; }
        public decimal MaxStake { get; set; }
        public int LockPeriodDays { get; set; }
        public decimal TotalStaked { get; set; }
        public string TotalStakedFormatted { get; set; }
        public int StakersCount { get; set; }
        public bool IsHot { get; set; }
        public bool IsNew { get; set; }
        public bool IsActive { get; set; }
    }

    public class ActiveStake
    {
        public long StakeId { get; set; }
        public int PoolId { get; set; }
        public string PoolName { get; set; }
        public string CurrencyCode { get; set; }
        public decimal StakedAmount { get; set; }
        public decimal APY { get; set; }
        public int LockPeriodDays { get; set; }
        public DateTime StakedDate { get; set; }
        public DateTime MaturityDate { get; set; }
        public int DaysStaked { get; set; }
        public int DaysRemaining { get; set; }
        public int ProgressPercent { get; set; }
        public decimal EarnedRewards { get; set; }
        public decimal PendingRewards { get; set; }
        public int Status { get; set; }
    }

    public class StakingHistory
    {
        public long StakeId { get; set; }
        public string PoolName { get; set; }
        public string CurrencyCode { get; set; }
        public decimal StakedAmount { get; set; }
        public decimal APY { get; set; }
        public int LockPeriodDays { get; set; }
        public DateTime StakedDate { get; set; }
        public decimal TotalRewards { get; set; }
        public int Status { get; set; }
        public string StatusName { get; set; }
    }

    public class RewardClaim
    {
        public long ClaimId { get; set; }
        public string PoolName { get; set; }
        public string CurrencyCode { get; set; }
        public decimal Amount { get; set; }
        public DateTime ClaimDate { get; set; }
    }

    public class StakingStats
    {
        public decimal TotalStaked { get; set; }
        public int ActiveStakes { get; set; }
        public decimal TotalEarned { get; set; }
        public decimal ThisMonthEarned { get; set; }
        public decimal PendingRewards { get; set; }
    }

    public class StakingActionResult
    {
        public bool Success { get; set; }
        public string ErrorMessage { get; set; }
        public long StakeId { get; set; }
    }

    //public class RewardsHistoryPoint
    //{
    //    public DateTime Date { get; set; }
    //    public decimal Value { get; set; }
    //}
}