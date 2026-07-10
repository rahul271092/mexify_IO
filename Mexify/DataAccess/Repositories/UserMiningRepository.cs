using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Mexify.Web.Models;
using Mexify.Models;

namespace Mexify.DataAccess.Repositories
{
    public class UserMiningRepository : BaseRepository
    {
        public UserMiningSummary GetUserMiningSummary(int userId)
        {
            var results = ExecuteStoredProcedure<UserMiningSummary>(
                "usp_GetUserMiningSummary",
                reader => new UserMiningSummary
                {
                    TotalHashrate = GetSafeDecimal(reader, "TotalHashrate"),
                    ActiveContracts = GetSafeInt(reader, "ActiveContracts"),
                    DailyRewards = GetSafeDecimal(reader, "DailyRewards"),
                    TotalEarned = GetSafeDecimal(reader, "TotalEarned"),
                    TotalInvested = GetSafeDecimal(reader, "TotalInvested"),
                    MonthRewards = GetSafeDecimal(reader, "MonthRewards"),
                    TodayRewards = GetSafeDecimal(reader, "TodayRewards")
                },
                CreateParameter("@UserId", userId)
            );
            return results.Count > 0 ? results[0] : new UserMiningSummary();
        }

        public List<Web.Models.MiningPlanViewModel> GetActiveContracts()
        {
            return ExecuteStoredProcedure<Web.Models.MiningPlanViewModel>(
                "usp_GetActiveMiningContracts",
                reader => new Web.Models.MiningPlanViewModel
                {
                    MiningPlanId = GetSafeInt(reader, "MiningPlanId"),
                    PlanName = GetSafeString(reader, "PlanName") ?? "Mining Contract",
                    Algorithm = GetSafeString(reader, "Algorithm") ?? "SHA-256",
                    Hashrate = GetSafeString(reader, "Hashrate"),
                    HashrateFormatted = GetSafeString(reader, "HashrateFormatted") ?? "0 TH/s",
                    DurationDays = GetSafeInt(reader, "DurationDays"),
                    ExpectedDailyReward = GetSafeDecimal(reader, "ExpectedDailyReward"),
                    RewardCurrency = GetSafeString(reader, "RewardCurrency") ?? "BTC",
                    Price = GetSafeDecimal(reader, "Price"),
                    RoiDays = GetSafeInt(reader, "RoiDays"),
                    IsFeatured = GetSafeBool(reader, "IsFeatured")
                }
            );
        }

        public List<UserMiningContract> GetUserActiveContracts(int userId)
        {
            return ExecuteStoredProcedure<UserMiningContract>(
                "usp_GetUserActiveMiningContracts",
                reader => new UserMiningContract
                {
                    MiningInvestmentId = GetSafeLong(reader, "MiningInvestmentId"),
                    PlanName = GetSafeString(reader, "PlanName") ?? "Contract",
                    Algorithm = GetSafeString(reader, "Algorithm") ?? "SHA-256",
                    HashrateFormatted = GetSafeString(reader, "HashrateFormatted") ?? "0 TH/s",
                    Hashrate = GetSafeDecimal(reader, "Hashrate"),
                    DurationDays = GetSafeInt(reader, "DurationDays"),
                    Price = GetSafeDecimal(reader, "Price"),
                    TotalRewards = GetSafeDecimal(reader, "TotalRewards"),
                    DailyReward = GetSafeDecimal(reader, "DailyReward"),
                    ProgressPercent = GetSafeInt(reader, "ProgressPercent"),
                    Status = GetSafeInt(reader, "Status"),
                    StartDate = GetSafeDateTime(reader, "StartDate"),
                    EndDate = GetSafeDateTime(reader, "EndDate"),
                    EndDateIso = GetSafeString(reader, "EndDateIso")
                },
                CreateParameter("@UserId", userId)
            );
        }

        public List<UserMiningContract> GetUserMiningHistory(int userId)
        {
            return ExecuteStoredProcedure<UserMiningContract>(
                "usp_GetUserMiningHistory",
                reader => new UserMiningContract
                {
                    MiningInvestmentId = GetSafeLong(reader, "MiningInvestmentId"),
                    PlanName = GetSafeString(reader, "PlanName") ?? "Contract",
                    HashrateFormatted = GetSafeString(reader, "HashrateFormatted") ?? "0 TH/s",
                    Price = GetSafeDecimal(reader, "Price"),
                    TotalRewards = GetSafeDecimal(reader, "TotalRewards"),
                    Status = GetSafeInt(reader, "Status"),
                    StartDate = GetSafeDateTime(reader, "StartDate")
                },
                CreateParameter("@UserId", userId)
            );
        }

        public List<MiningReward> GetUserRewards(int userId, int count)
        {
            return ExecuteStoredProcedure<MiningReward>(
                "usp_GetUserMiningRewards",
                reader => new MiningReward
                {
                    RewardId = GetSafeLong(reader, "RewardId"),
                    MiningInvestmentId = GetSafeLong(reader, "MiningInvestmentId"),
                    PlanName = GetSafeString(reader, "PlanName") ?? "Contract",
                    Amount = GetSafeDecimal(reader, "Amount"),
                    DistributedDate = GetSafeDateTime(reader, "DistributedDate")
                },
                CreateParameter("@UserId", userId),
                CreateParameter("@Count", count)
            );
        }

        public List<MiningRewardsHistoryPoint> GetRewardsHistory(int userId, int days)
        {
            return ExecuteStoredProcedure<MiningRewardsHistoryPoint>(
                "usp_GetUserMiningRewardsHistory",
                reader => new MiningRewardsHistoryPoint
                {
                    Date = GetSafeDateTime(reader, "Date"),
                    Value = GetSafeDecimal(reader, "Value")
                },
                CreateParameter("@UserId", userId),
                CreateParameter("@Days", days)
            );
        }

        public List<HashrateDistributionItem> GetHashrateDistribution(int userId)
        {
            return ExecuteStoredProcedure<HashrateDistributionItem>(
                "usp_GetUserHashrateDistribution",
                reader => new HashrateDistributionItem
                {
                    Name = GetSafeString(reader, "Name") ?? "Unknown",
                    Value = GetSafeDecimal(reader, "Value")
                },
                CreateParameter("@UserId", userId)
            );
        }
    }
}