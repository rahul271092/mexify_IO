using System;
using System.Collections.Generic;
using System.Data.SqlClient;

using Mexify.Web.Models;
using Mexify.Models;

namespace Mexify.DataAccess.Repositories
{
    public class UserStakingRepository : BaseRepository
    {
        public UserStakingSummary GetUserStakingSummary(int userId)
        {
            var results = ExecuteStoredProcedure<UserStakingSummary>(
                "usp_GetUserStakingSummary",
                reader => new UserStakingSummary
                {
                    TotalStaked = GetSafeDecimal(reader, "TotalStaked"),
                    ActiveStakes = GetSafeInt(reader, "ActiveStakes"),
                    TotalRewards = GetSafeDecimal(reader, "TotalRewards"),
                    DailyRewards = GetSafeDecimal(reader, "DailyRewards"),
                    AverageAPY = GetSafeDecimal(reader, "AverageAPY"),
                    MonthRewards = GetSafeDecimal(reader, "MonthRewards"),
                    PendingRewards = GetSafeDecimal(reader, "PendingRewards")
                },
                CreateParameter("@UserId", userId)
            );
            return results.Count > 0 ? results[0] : new UserStakingSummary();
        }

        public List<StakingPlan> GetActivePools()
        {
            return ExecuteStoredProcedure<StakingPlan>(
                "usp_GetActiveStakingPools",
                reader => new StakingPlan
                {
                    StakingPlanId = GetSafeInt(reader, "StakingPlanId"),
                    PlanName = GetSafeString(reader, "PlanName") ?? "Staking Pool",
                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "PNC",
                    MinAmount = GetSafeDecimal(reader, "MinAmount"),
                    MaxAmount = GetSafeDecimal(reader, "MaxAmount"),
                    APY = GetSafeDecimal(reader, "APY"),
                    LockPeriodDays = GetSafeInt(reader, "LockPeriodDays"),
                    AutoCompound = GetSafeBool(reader, "AutoCompound"),
                    IsHot = GetSafeDecimal(reader, "APY") >= 12m,
                    TotalStaked = GetSafeDecimal(reader, "TotalStaked")
                }
            );
        }

        public List<UserStake> GetUserActiveStakes(int userId)
        {
            return ExecuteStoredProcedure<UserStake>(
                "usp_GetUserActiveStakes",
                reader => new UserStake
                {
                    StakingInvestmentId = GetSafeLong(reader, "StakeId"),
                    PlanName = GetSafeString(reader, "PlanName") ?? "Stake",
                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "PNC",
                    Amount = GetSafeDecimal(reader, "StakedAmount"),
                    APY = GetSafeDecimal(reader, "APY"),
                    LockPeriodDays = GetSafeInt(reader, "LockPeriodDays"),
                    TotalRewards = GetSafeDecimal(reader, "TotalRewards"),
                    DailyReward = GetSafeDecimal(reader, "DailyReward"),
                    ProgressPercent = GetSafeInt(reader, "ProgressPercent"),
                    Status = GetSafeInt(reader, "Status"),
                    StartDate = GetSafeDateTime(reader, "StartDate"),
                    EndDate = GetSafeDateTime(reader, "EndDate"),
                    EndDateIso = GetSafeString(reader, "EndDateIso"),
                    AutoCompound = GetSafeBool(reader, "AutoCompound")
                },
                CreateParameter("@UserId", userId)
            );
        }

        public List<UserStake> GetUserStakingHistory(int userId)
        {
            return ExecuteStoredProcedure<UserStake>(
                "usp_GetUserStakingHistory",
                reader => new UserStake
                {
                    StakingInvestmentId = GetSafeLong(reader, "StakeId"),
                    PlanName = GetSafeString(reader, "PoolName") ?? "Stake",
                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "PNC",
                    Amount = GetSafeDecimal(reader, "StakedAmount"),
                    APY = GetSafeDecimal(reader, "APY"),
                    TotalRewards = GetSafeDecimal(reader, "TotalRewards"),
                    Status = GetSafeInt(reader, "Status"),
                    StartDate = GetSafeDateTime(reader, "StakedDate")
                },
                CreateParameter("@UserId", userId)
            );
        }

        public List<StakeReward> GetUserRewards(int userId, int count)
        {
            return ExecuteStoredProcedure<StakeReward>(
                "usp_GetUserStakingRewards",
                reader => new StakeReward
                {
                    RewardId = GetSafeLong(reader, "RewardId"),
                    StakingInvestmentId = GetSafeLong(reader, "StakingInvestmentId"),
                    PlanName = GetSafeString(reader, "PlanName") ?? "Stake",
                    Amount = GetSafeDecimal(reader, "Amount"),
                    DistributedDate = GetSafeDateTime(reader, "DistributedDate")
                },
                CreateParameter("@UserId", userId),
                CreateParameter("@Count", count)
            );
        }

        public List<RewardsHistoryPoint> GetRewardsHistory(int userId, int days)
        {
            return ExecuteStoredProcedure<RewardsHistoryPoint>(
                "usp_GetUserRewardsHistory",
                reader => new RewardsHistoryPoint
                {
                    Date = GetSafeDateTime(reader, "Date"),
                    Value = GetSafeDecimal(reader, "Value")
                },
                CreateParameter("@UserId", userId),
                CreateParameter("@Days", days)
            );
        }

        public List<StakeDistributionItem> GetStakeDistribution(int userId)
        {
            return ExecuteStoredProcedure<StakeDistributionItem>(
                "usp_GetUserStakeDistribution",
                reader => new StakeDistributionItem
                {
                    Name = GetSafeString(reader, "Name") ?? "Unknown",
                    Value = GetSafeDecimal(reader, "Value")
                },
                CreateParameter("@UserId", userId)
            );
        }
    }
}