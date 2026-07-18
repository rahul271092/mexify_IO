using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Mexify.Models;
using Mexify.Utilities;
using System.Configuration;
using System.Data;

namespace Mexify.DataAccess.Repositories
{
    public class StakingRepository : BaseRepository
    {

        private string _connStr = ConfigurationManager.ConnectionStrings["MexifyDB"].ConnectionString;

        public StakingViewModel GetUserStakingRewards(int userId, int? status = null, int pageNumber = 1, int pageSize = 10)
        {
            var model = new StakingViewModel { PageNumber = pageNumber, PageSize = pageSize };

            using (var conn = new SqlConnection(_connStr))
            {
                using (var cmd = new SqlCommand("usp_GetUserStakingRewards", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@Status", status.HasValue ? (object)status.Value : DBNull.Value);
                    cmd.Parameters.AddWithValue("@PageNumber", pageNumber);
                    cmd.Parameters.AddWithValue("@PageSize", pageSize);

                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        // 1. Summary Stats
                        if (reader.Read())
                        {
                            model.Summary = new StakingSummary
                            {
                                TotalStaked = reader["TotalStaked"] != DBNull.Value ? Convert.ToDecimal(reader["TotalStaked"]) : 0,
                                TotalEarned = reader["TotalEarned"] != DBNull.Value ? Convert.ToDecimal(reader["TotalEarned"]) : 0,
                                TotalRewardsPaid = reader["TotalRewardsPaid"] != DBNull.Value ? Convert.ToDecimal(reader["TotalRewardsPaid"]) : 0,
                                ActivePlans = reader["ActivePlans"] != DBNull.Value ? Convert.ToInt32(reader["ActivePlans"]) : 0,
                                CompletedPlans = reader["CompletedPlans"] != DBNull.Value ? Convert.ToInt32(reader["CompletedPlans"]) : 0,
                                TodayEarnings = reader["TodayEarnings"] != DBNull.Value ? Convert.ToDecimal(reader["TodayEarnings"]) : 0,
                                AverageAPY = reader["AverageAPY"] != DBNull.Value ? Convert.ToDecimal(reader["AverageAPY"]) : 0,
                                NextExpiryDate = reader["NextExpiryDate"] != DBNull.Value ? Convert.ToDateTime(reader["NextExpiryDate"]) : (DateTime?)null
                            };
                        }

                        // 2. Staking Investments List
                        if (reader.NextResult())
                        {
                            while (reader.Read())
                            {
                                model.Investments.Add(new StakingInvestmentItem
                                {
                                    StakingInvestmentId = Convert.ToInt64(reader["StakingInvestmentId"]),
                                    PlanName = reader["PlanName"].ToString(),
                                    APY = Convert.ToDecimal(reader["APY"]),
                                    DurationDays = Convert.ToInt32(reader["DurationDays"]),
                                    Amount = Convert.ToDecimal(reader["Amount"]),
                                    StartDate = Convert.ToDateTime(reader["StartDate"]),
                                    EndDate = Convert.ToDateTime(reader["EndDate"]),
                                    TotalEarned = Convert.ToDecimal(reader["TotalEarned"]),
                                    Status = Convert.ToInt32(reader["Status"]),
                                    StatusName = reader["StatusName"].ToString(),
                                    DailyReward = Convert.ToDecimal(reader["DailyReward"]),
                                    DaysRemaining = Convert.ToInt32(reader["DaysRemaining"]),
                                    ProgressPercent = Convert.ToDecimal(reader["ProgressPercent"]),
                                    ProjectedTotal = Convert.ToDecimal(reader["ProjectedTotal"])
                                });
                            }
                        }

                        // 3. Total Count
                        if (reader.NextResult() && reader.Read())
                        {
                            model.TotalCount = Convert.ToInt32(reader["TotalCount"]);
                        }
                    }
                }
            }
            return model;
        }

        public List<StakingPool> GetAvailablePools()
        {
            return ExecuteStoredProcedure<StakingPool>(
                "usp_GetStakingPools",
                reader => new StakingPool
                {
                    PoolId = GetSafeInt(reader, "PoolId"),
                    PoolName = GetSafeString(reader, "PoolName") ?? "Staking Pool",
                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "USDT",
                    CurrencyId = GetSafeInt(reader, "CurrencyId"),
                    APY = GetSafeDecimal(reader, "APY"),
                    MinStake = GetSafeDecimal(reader, "MinStake"),
                    MaxStake = GetSafeDecimal(reader, "MaxStake"),
                    LockPeriodDays = GetSafeInt(reader, "LockPeriodDays"),
                    TotalStaked = GetSafeDecimal(reader, "TotalStaked"),
                    TotalStakedFormatted = GetSafeString(reader, "TotalStakedFormatted") ?? "0",
                    StakersCount = GetSafeInt(reader, "StakersCount"),
                    IsHot = GetSafeBool(reader, "IsHot"),
                    IsNew = GetSafeBool(reader, "IsNew"),
                    IsActive = GetSafeBool(reader, "IsActive")
                }
            );
        }

        /// <summary>
        /// ✅ NEW: Gets a specific staking pool by its ID
        /// </summary>
        public StakingPool GetPoolById(int poolId)
        {
            var results = ExecuteStoredProcedure<StakingPool>(
                "usp_GetStakingPoolById",
                reader => new StakingPool
                {
                    PoolId = GetSafeInt(reader, "PoolId"),
                    PoolName = GetSafeString(reader, "PoolName") ?? "Staking Pool",
                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "USDT",
                    CurrencyId = GetSafeInt(reader, "CurrencyId"),
                    APY = GetSafeDecimal(reader, "APY"),
                    MinStake = GetSafeDecimal(reader, "MinStake"),
                    MaxStake = GetSafeDecimal(reader, "MaxStake"),
                    LockPeriodDays = GetSafeInt(reader, "LockPeriodDays"),
                    TotalStaked = GetSafeDecimal(reader, "TotalStaked"),
                    TotalStakedFormatted = GetSafeString(reader, "TotalStakedFormatted") ?? "0",
                    StakersCount = GetSafeInt(reader, "StakersCount"),
                    IsHot = GetSafeBool(reader, "IsHot"),
                    IsNew = GetSafeBool(reader, "IsNew"),
                    IsActive = GetSafeBool(reader, "IsActive")
                },
                CreateParameter("@StakingPlanId", poolId)
            );
            return results.Count > 0 ? results[0] : null;
        }
        public List<ActiveStake> GetActiveStakes(int userId)
        {
            return ExecuteStoredProcedure<ActiveStake>(
                "usp_GetUserActiveStakes",
                reader => new ActiveStake
                {
                    StakeId = GetSafeLong(reader, "StakeId"),
                    PoolId = GetSafeInt(reader, "PoolId"),
                    PoolName = GetSafeString(reader, "PoolName") ?? "",
                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "PNC",
                    StakedAmount = GetSafeDecimal(reader, "StakedAmount"),
                    APY = GetSafeDecimal(reader, "APY"),
                    LockPeriodDays = GetSafeInt(reader, "LockPeriodDays"),
                    StakedDate = GetSafeDateTime(reader, "StakedDate"),
                    MaturityDate = GetSafeDateTime(reader, "MaturityDate"),
                    DaysStaked = GetSafeInt(reader, "DaysStaked"),
                    DaysRemaining = GetSafeInt(reader, "DaysRemaining"),
                    ProgressPercent = GetSafeInt(reader, "ProgressPercent"),
                    EarnedRewards = GetSafeDecimal(reader, "EarnedRewards"),
                    PendingRewards = GetSafeDecimal(reader, "PendingRewards"),
                    Status = GetSafeInt(reader, "Status")
                },
                CreateParameter("@UserId", userId)
            );
        }

        public List<StakingHistory> GetStakingHistory(int userId, int count)
        {
            return ExecuteStoredProcedure<StakingHistory>(
                "usp_GetUserStakingHistory",
                reader => new StakingHistory
                {
                    StakeId = GetSafeLong(reader, "StakeId"),
                    PoolName = GetSafeString(reader, "PoolName") ?? "",
                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "PNC",
                    StakedAmount = GetSafeDecimal(reader, "StakedAmount"),
                    APY = GetSafeDecimal(reader, "APY"),
                    LockPeriodDays = GetSafeInt(reader, "LockPeriodDays"),
                    StakedDate = GetSafeDateTime(reader, "StakedDate"),
                    TotalRewards = GetSafeDecimal(reader, "TotalRewards"),
                    Status = GetSafeInt(reader, "Status"),
                    StatusName = GetSafeString(reader, "StatusName") ?? "Active"
                },
                CreateParameter("@UserId", userId),
                CreateParameter("@Count", count)
            );
        }

        public List<RewardClaim> GetRewardClaims(int userId, int count)
        {
            return ExecuteStoredProcedure<RewardClaim>(
                "usp_GetUserRewardClaims",
                reader => new RewardClaim
                {
                    ClaimId = GetSafeLong(reader, "ClaimId"),
                    PoolName = GetSafeString(reader, "PoolName") ?? "",
                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "PNC",
                    Amount = GetSafeDecimal(reader, "Amount"),
                    ClaimDate = GetSafeDateTime(reader, "ClaimDate")
                },
                CreateParameter("@UserId", userId),
                CreateParameter("@Count", count)
            );
        }

        public StakingStats GetUserStakingStats(int userId)
        {
            var results = ExecuteStoredProcedure<StakingStats>(
                "usp_GetUserStakingStats",
                reader => new StakingStats
                {
                    TotalStaked = GetSafeDecimal(reader, "TotalStaked"),
                    ActiveStakes = GetSafeInt(reader, "ActiveStakes"),
                    TotalEarned = GetSafeDecimal(reader, "TotalEarned"),
                    ThisMonthEarned = GetSafeDecimal(reader, "ThisMonthEarned"),
                    PendingRewards = GetSafeDecimal(reader, "PendingRewards")
                },
                CreateParameter("@UserId", userId)
            );
            return results.Count > 0 ? results[0] : new StakingStats();
        }

        public StakingActionResult StakeTokens(int userId, int poolId, decimal amount)
        {
            var result = new StakingActionResult();
            try
            {
                var outputSuccess = new SqlParameter("@Success", System.Data.SqlDbType.Bit) { Direction = System.Data.ParameterDirection.Output };
                var outputMessage = new SqlParameter("@Message", System.Data.SqlDbType.NVarChar, 500) { Direction = System.Data.ParameterDirection.Output };
                var outputStakeId = new SqlParameter("@StakeId", System.Data.SqlDbType.BigInt) { Direction = System.Data.ParameterDirection.Output };

                ExecuteStoredProcedureNonQuery(
                    "usp_StakeTokens",
                    CreateParameter("@UserId", userId),
                    CreateParameter("@PoolId", poolId),
                    CreateParameter("@Amount", amount),
                    outputSuccess,
                    outputMessage,
                    outputStakeId
                );

                result.Success = outputSuccess.Value != DBNull.Value && Convert.ToBoolean(outputSuccess.Value);
                result.ErrorMessage = outputMessage.Value != DBNull.Value ? outputMessage.Value.ToString() : "";
                result.StakeId = outputStakeId.Value != DBNull.Value ? Convert.ToInt64(outputStakeId.Value) : 0;
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.ErrorMessage = ex.Message;
            }
            return result;
        }

        public StakingActionResult ClaimRewards(int userId, long stakeId)
        {
            var result = new StakingActionResult();
            try
            {
                var outputSuccess = new SqlParameter("@Success", System.Data.SqlDbType.Bit) { Direction = System.Data.ParameterDirection.Output };
                var outputMessage = new SqlParameter("@Message", System.Data.SqlDbType.NVarChar, 500) { Direction = System.Data.ParameterDirection.Output };

                ExecuteStoredProcedureNonQuery(
                    "usp_ClaimStakingRewards",
                    CreateParameter("@UserId", userId),
                    CreateParameter("@StakeId", stakeId),
                    outputSuccess,
                    outputMessage
                );

                result.Success = outputSuccess.Value != DBNull.Value && Convert.ToBoolean(outputSuccess.Value);
                result.ErrorMessage = outputMessage.Value != DBNull.Value ? outputMessage.Value.ToString() : "";
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.ErrorMessage = ex.Message;
            }
            return result;
        }

        public StakingActionResult UnstakeTokens(int userId, long stakeId)
        {
            var result = new StakingActionResult();
            try
            {
                var outputSuccess = new SqlParameter("@Success", System.Data.SqlDbType.Bit) { Direction = System.Data.ParameterDirection.Output };
                var outputMessage = new SqlParameter("@Message", System.Data.SqlDbType.NVarChar, 500) { Direction = System.Data.ParameterDirection.Output };

                ExecuteStoredProcedureNonQuery(
                    "usp_UnstakeTokens",
                    CreateParameter("@UserId", userId),
                    CreateParameter("@StakeId", stakeId),
                    outputSuccess,
                    outputMessage
                );

                result.Success = outputSuccess.Value != DBNull.Value && Convert.ToBoolean(outputSuccess.Value);
                result.ErrorMessage = outputMessage.Value != DBNull.Value ? outputMessage.Value.ToString() : "";
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.ErrorMessage = ex.Message;
            }
            return result;
        }


        /// <summary>
        /// ✅ Gets all active staking pools from the database
        /// </summary>
        public List<StakingPool> GetActivePools()
        {
            try
            {

            Logger.Info("GetActive Pools code Executed !!");
            return ExecuteStoredProcedure<StakingPool>(
                "usp_GetStakingPools",
                reader => new StakingPool
                {
                    PoolId = GetSafeInt(reader, "PoolId"),
                    PoolName = GetSafeString(reader, "PoolName") ?? "Staking Pool",
                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "USDT",
                    CurrencyId = GetSafeInt(reader, "CurrencyId"),
                    APY = GetSafeDecimal(reader, "APY"),
                    MinStake = GetSafeDecimal(reader, "MinStake"),
                    MaxStake = GetSafeDecimal(reader, "MaxStake"),
                    LockPeriodDays = GetSafeInt(reader, "LockPeriodDays"),
                    TotalStaked = GetSafeDecimal(reader, "TotalStaked"),
                    TotalStakedFormatted = GetSafeString(reader, "TotalStakedFormatted") ?? "0",
                    StakersCount = GetSafeInt(reader, "StakersCount"),
                    IsHot = GetSafeBool(reader, "IsHot"),
                    IsNew = GetSafeBool(reader, "IsNew"),
                    IsActive = GetSafeBool(reader, "IsActive")
                }
            );

            }
            catch (Exception ex)
            {
                Logger.Error("Get Active Pools Function Error is: ", ex);
                Logger.Info("Exception : " + ex.ToString());
                return new List<StakingPool>();
            }

        }


        /// <summary>
        /// ✅ Gets all active staking pools available for users
        /// </summary>
        //public List<StakingPool> GetActivePools()
        //{
        //    try
        //    {
        //        return _repository.GetActivePools();
        //    }
        //    catch (Exception ex)
        //    {
        //        Logger.Error("Failed to get active staking pools", ex);
        //        return new List<StakingPool>();
        //    }
        //}
        ////public StakingPool GetPoolById(int poolId)
        //{
        //    try { return _repository.GetPoolById(poolId); }
        //    catch (Exception ex)
        //    {
        //        Logger.Error("Failed to get staking pool by ID: " + poolId, ex);
        //        return null;
        //    }
        //}


        public StakingCommissionStats GetUserStakingCommissionStats(int userId)
        {
            var stats = new StakingCommissionStats
            {
                LevelBreakdown = new List<StakingCommissionLevelSummary>(),
                RecentCommissions = new List<StakingCommission>()
            };

            try
            {
                using (var conn = Mexify.DataAccess.ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_GetStakingCommissionSummary", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    conn.Open();

                    using (var reader = cmd.ExecuteReader())
                    {
                        // First result set: Totals
                        if (reader.Read())
                        {
                            stats.TotalEarned = GetSafeDecimal(reader, "TotalEarned");
                            stats.TotalCommissions = GetSafeInt(reader, "TotalCommissions");
                            stats.UniqueDownlines = GetSafeInt(reader, "UniqueDownlines");
                        }

                        // Second result set: Level breakdown
                        if (reader.NextResult())
                        {
                            while (reader.Read())
                            {
                                stats.LevelBreakdown.Add(new StakingCommissionLevelSummary
                                {
                                    Level = GetSafeInt(reader, "Level"),
                                    CommissionPercent = GetSafeDecimal(reader, "CommissionPercent"),
                                    RequiredDirects = GetSafeInt(reader, "RequiredDirects"),
                                    TimesEarned = GetSafeInt(reader, "TimesEarned"),
                                    LevelTotal = GetSafeDecimal(reader, "LevelTotal"),
                                    CurrentDirects = GetSafeInt(reader, "CurrentDirects"),
                                    IsQualified = GetSafeBool(reader, "IsQualified")
                                });
                            }
                        }
                    }
                }

                // Get recent commissions
                stats.RecentCommissions = ExecuteStoredProcedure<StakingCommission>(
                    "usp_GetUserStakingCommissions",
                    reader => new StakingCommission
                    {
                        CommissionId = GetSafeLong(reader, "CommissionId"),
                        FromUserId = GetSafeInt(reader, "FromUserId"),
                        FromUserName = GetSafeString(reader, "FromUserName") ?? "",
                        FromUserEmail = GetSafeString(reader, "FromUserEmail") ?? "",
                        Level = GetSafeInt(reader, "Level"),
                        StakedAmount = GetSafeDecimal(reader, "StakedAmount"),
                        CommissionPercent = GetSafeDecimal(reader, "CommissionPercent"),
                        CommissionAmount = GetSafeDecimal(reader, "CommissionAmount"),
                        DirectReferralsAtTime = GetSafeInt(reader, "DirectReferralsAtTime"),
                        CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "USDT",
                        CreatedDate = GetSafeDateTime(reader, "CreatedDate")
                    },
                    CreateParameter("@UserId", userId),
                    CreateParameter("@Count", 20)
                );
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get staking commission stats", ex);
            }

            return stats;
        }


        public List<RewardsHistoryPoint> GetRewardsHistory(int userId, int days)
        {
            return ExecuteStoredProcedure<RewardsHistoryPoint>(
                "usp_GetRewardsHistory",
                reader => new RewardsHistoryPoint
                {
                    Date = GetSafeDateTime(reader, "Date"),
                    Value = GetSafeDecimal(reader, "Value")
                },
                CreateParameter("@UserId", userId),
                CreateParameter("@Days", days)
            );
        }
    }
}