using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Mexify.Models;
using Mexify.Utilities;
using Mexify.Web.Models;
using Mexify.Business.Services;
using static Mexify.Web.Models.MiningResultModels;

namespace Mexify.DataAccess.Repositories
{
    /// <summary>
    /// Data access layer for all mining-related database operations.
    /// Handles mining plans, contracts, earnings, and purchases.
    /// </summary>
    public class MiningRepository : BaseRepository
    {
        // =========================================
        // 1. MINING PLANS
        // =========================================

        /// <summary>
        /// Gets all active mining plans available for purchase.
        /// Returns MiningPlanViewModel for UI display.
        /// </summary>
        public List<MiningPlanViewModel> GetActiveMiningPlans()
        {
            try
            {
                return ExecuteStoredProcedure<MiningPlanViewModel>(
                    "usp_GetActiveMiningPlans",
                    reader => new MiningPlanViewModel
                    {
                        MiningPlanId = GetSafeInt(reader, "MiningPlanId"),
                        PlanName = GetSafeString(reader, "PlanName") ?? "Mining Plan",
                        Algorithm = GetSafeString(reader, "Algorithm") ?? "SHA-256",
                        Hashrate = GetSafeDecimal(reader, "Hashrate").ToString("0.00"),
                        HashrateFormatted = GetSafeDecimal(reader, "Hashrate").ToString("0.00") + " TH/s",
                        PowerConsumption = GetSafeDecimal(reader, "PowerConsumption").ToString("0"),
                        Price = GetSafeDecimal(reader, "Price"),
                        ContractDays = GetSafeInt(reader, "ContractDays"),
                        DailyOutput = GetSafeDecimal(reader, "DailyOutput"),
                        MaintenanceFee = 0,
                        MaintenanceFeeFormatted = "Included",
                        RewardCurrency = "PNC",
                        RoiDays = CalculateRoiDays(
                            GetSafeDecimal(reader, "Price"),
                            GetSafeDecimal(reader, "DailyOutput")),
                        IsPopular = GetSafeBool(reader, "IsPopular"),
                        IsActive = GetSafeBool(reader, "IsActive"),
                        CreatedDate = GetSafeDateTime(reader, "CreatedDate")
                    }
                );
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get active mining plans", ex);
                return new List<MiningPlanViewModel>();
            }
        }

        /// <summary>
        /// Gets a specific mining plan by its ID.
        /// </summary>
        public MiningPlanViewModel GetMiningPlanById(int planId)
        {
            try
            {
                var results = ExecuteStoredProcedure<MiningPlanViewModel>(
                    "usp_GetMiningPlanById",
                    reader => new MiningPlanViewModel
                    {
                        MiningPlanId = GetSafeInt(reader, "MiningPlanId"),
                        PlanName = GetSafeString(reader, "PlanName") ?? "Mining Plan",
                        Algorithm = GetSafeString(reader, "Algorithm") ?? "SHA-256",
                        Hashrate = GetSafeDecimal(reader, "Hashrate").ToString("0.00"),
                        HashrateFormatted = GetSafeDecimal(reader, "Hashrate").ToString("0.00") + " TH/s",
                        PowerConsumption = GetSafeDecimal(reader, "PowerConsumption").ToString("0"),
                        Price = GetSafeDecimal(reader, "Price"),
                        ContractDays = GetSafeInt(reader, "ContractDays"),
                        DailyOutput = GetSafeDecimal(reader, "DailyOutput"),
                        IsPopular = GetSafeBool(reader, "IsPopular"),
                        IsActive = GetSafeBool(reader, "IsActive"),
                        CreatedDate = GetSafeDateTime(reader, "CreatedDate")
                    },
                    CreateParameter("@MiningPlanId", planId)
                );
                return results.Count > 0 ? results[0] : null;
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get mining plan by ID: " + planId, ex);
                return null;
            }
        }

        // =========================================
        // 2. USER MINING CONTRACTS
        // =========================================

        /// <summary>
        /// Gets all mining contracts for a specific user.
        /// </summary>
        public List<MiningContract> GetUserMiningContracts(int userId)
        {
            try
            {
                return ExecuteStoredProcedure<MiningContract>(
                    "usp_GetUserMiningContracts",
                    reader => new MiningContract
                    {
                        MiningContractId = GetSafeLong(reader, "MiningContractId"),
                        UserId = GetSafeInt(reader, "UserId"),
                        MiningPlanId = GetSafeInt(reader, "MiningPlanId"),
                        PlanName = GetSafeString(reader, "PlanName") ?? "Mining Plan",
                        Hashrate = GetSafeDecimal(reader, "Hashrate"),
                        DailyOutput = GetSafeDecimal(reader, "DailyOutput"),
                        PowerConsumption = GetSafeDecimal(reader, "PowerConsumption"),
                        TotalEarned = GetSafeDecimal(reader, "TotalEarned"),
                        ContractDays = GetSafeInt(reader, "ContractDays"),
                        StartDate = GetSafeDateTime(reader, "StartDate"),
                        EndDate = GetSafeDateTime(reader, "EndDate"),
                        Status = GetSafeInt(reader, "Status"),
                        DaysElapsed = GetSafeInt(reader, "DaysElapsed"),
                        DaysRemaining = GetSafeInt(reader, "DaysRemaining"),
                        ProgressPercent = GetSafeInt(reader, "ProgressPercent")
                    },
                    CreateParameter("@UserId", userId)
                );
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get mining contracts for user " + userId, ex);
                return new List<MiningContract>();
            }
        }

        // =========================================
        // 3. MINING STATS
        // =========================================

        /// <summary>
        /// Gets comprehensive mining statistics for a user.
        /// </summary>
        public MiningStats GetUserMiningStats(int userId)
        {
            try
            {
                var results = ExecuteStoredProcedure<MiningStats>(
                    "usp_GetUserMiningStats",
                    reader => new MiningStats
                    {
                        TotalHashrate = GetSafeDecimal(reader, "TotalHashrate"),
                        DailyEarning = GetSafeDecimal(reader, "DailyEarning"),
                        ActiveRigs = GetSafeInt(reader, "ActiveRigs"),
                        TotalEarned = GetSafeDecimal(reader, "TotalEarned"),
                        TodayEarnings = GetSafeDecimal(reader, "TodayEarnings"),
                        ThisMonthEarnings = GetSafeDecimal(reader, "ThisMonthEarnings"),
                        PendingPayout = GetSafeDecimal(reader, "PendingPayout")
                    },
                    CreateParameter("@UserId", userId)
                );
                return results.Count > 0 ? results[0] : new MiningStats();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get mining stats for user " + userId, ex);
                return new MiningStats();
            }
        }

        // =========================================
        // 4. EARNINGS & REWARDS
        // =========================================

        /// <summary>
        /// Gets mining earnings history for a user.
        /// </summary>
        public List<MiningEarning> GetUserMiningEarnings(int userId, int count)
        {
            try
            {
                return ExecuteStoredProcedure<MiningEarning>(
                    "usp_GetUserMiningEarnings",
                    reader => new MiningEarning
                    {
                        EarningId = GetSafeLong(reader, "EarningId"),
                        MiningContractId = GetSafeLong(reader, "MiningContractId"),
                        PlanName = GetSafeString(reader, "PlanName") ?? "Mining Plan",
                        Hashrate = GetSafeDecimal(reader, "Hashrate"),
                        Amount = GetSafeDecimal(reader, "Amount"),
                        Status = GetSafeInt(reader, "Status"),
                        StatusName = GetSafeString(reader, "StatusName") ?? "Pending",
                        TxHash = GetSafeString(reader, "TxHash"),
                        EarnedDate = GetSafeDateTime(reader, "EarnedDate")
                    },
                    CreateParameter("@UserId", userId),
                    CreateParameter("@Count", count)
                );
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get mining earnings for user " + userId, ex);
                return new List<MiningEarning>();
            }
        }

        // =========================================
        // 5. CHART DATA
        // =========================================

        /// <summary>
        /// Gets mining performance history for charts (last N days).
        /// </summary>
        public List<ChartDataPoint> GetMiningPerformanceHistory(int userId, int days)
        {
            try
            {
                return ExecuteStoredProcedure<ChartDataPoint>(
                    "usp_GetMiningPerformanceHistory",
                    reader => new ChartDataPoint
                    {
                        Date = GetSafeDateTime(reader, "Date"),
                        Value = GetSafeDecimal(reader, "Value")
                    },
                    CreateParameter("@UserId", userId),
                    CreateParameter("@Days", days)
                );
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get mining performance history for user " + userId, ex);
                return new List<ChartDataPoint>();
            }
        }

        // =========================================
        // 6. PURCHASE CONTRACT
        // =========================================

        /// <summary>
        /// Purchases a new mining contract for a user.
        /// Deducts payment from USDT wallet and creates contract record.
        /// </summary>
        public PurchaseResult PurchaseMiningContract(int userId, int planId)
        {
            var result = new PurchaseResult();
            try
            {
                var outputSuccess = new SqlParameter("@Success", SqlDbType.Bit)
                {
                    Direction = ParameterDirection.Output
                };
                var outputMessage = new SqlParameter("@Message", SqlDbType.NVarChar, 500)
                {
                    Direction = ParameterDirection.Output
                };
                var outputContractId = new SqlParameter("@ContractId", SqlDbType.BigInt)
                {
                    Direction = ParameterDirection.Output
                };

                ExecuteStoredProcedureNonQuery(
                    "usp_PurchaseMiningContract",
                    CreateParameter("@UserId", userId),
                    CreateParameter("@MiningPlanId", planId),
                    outputSuccess,
                    outputMessage,
                    outputContractId
                );

                result.Success = outputSuccess.Value != DBNull.Value
                    && Convert.ToBoolean(outputSuccess.Value);
                result.ErrorMessage = outputMessage.Value != DBNull.Value
                    ? outputMessage.Value.ToString()
                    : "";
                result.ContractId = outputContractId.Value != DBNull.Value
                    ? Convert.ToInt64(outputContractId.Value)
                    : 0;

                return result;
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to purchase mining contract for user " + userId, ex);
                result.Success = false;
                result.ErrorMessage = "System error: " + ex.Message;
                return result;
            }
        }

        // =========================================
        // 7. CLAIM REWARDS
        // =========================================

        /// <summary>
        /// Claims pending rewards from an active mining contract.
        /// </summary>
        public Business.Services.ClaimResult ClaimMiningRewards(int userId, long contractId)
        {
            var result = new Business.Services.ClaimResult();
            try
            {
                var outputSuccess = new SqlParameter("@Success", SqlDbType.Bit)
                {
                    Direction = ParameterDirection.Output
                };
                var outputMessage = new SqlParameter("@Message", SqlDbType.NVarChar, 500)
                {
                    Direction = ParameterDirection.Output
                };
                var outputAmount = new SqlParameter("@ClaimedAmount", SqlDbType.Decimal)
                {
                    Direction = ParameterDirection.Output
                };

                ExecuteStoredProcedureNonQuery(
                    "usp_ClaimMiningRewards",
                    CreateParameter("@UserId", userId),
                    CreateParameter("@ContractId", contractId),
                    outputSuccess,
                    outputMessage,
                    outputAmount
                );

                result.Success = outputSuccess.Value != DBNull.Value
                    && Convert.ToBoolean(outputSuccess.Value);
                result.ErrorMessage = outputMessage.Value != DBNull.Value
                    ? outputMessage.Value.ToString()
                    : "";
                result.Amount = outputAmount.Value != DBNull.Value
                    ? Convert.ToDecimal(outputAmount.Value)
                    : 0;

                return result;
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to claim mining rewards for contract " + contractId, ex);
                result.Success = false;
                result.ErrorMessage = "System error: " + ex.Message;
                return result;
            }
        }

        // =========================================
        // 8. UNSTAKE CONTRACT
        // =========================================

        /// <summary>
        /// Unstakes from an expired mining contract and returns principal.
        /// </summary>
        public Business.Services.ClaimResult UnstakeMiningContract(int userId, long contractId)
        {
            var result = new Business.Services.ClaimResult();
            try
            {
                var outputSuccess = new SqlParameter("@Success", SqlDbType.Bit)
                {
                    Direction = ParameterDirection.Output
                };
                var outputMessage = new SqlParameter("@Message", SqlDbType.NVarChar, 500)
                {
                    Direction = ParameterDirection.Output
                };
                var outputAmount = new SqlParameter("@ReturnedAmount", SqlDbType.Decimal)
                {
                    Direction = ParameterDirection.Output
                };

                ExecuteStoredProcedureNonQuery(
                    "usp_UnstakeMiningContract",
                    CreateParameter("@UserId", userId),
                    CreateParameter("@ContractId", contractId),
                    outputSuccess,
                    outputMessage,
                    outputAmount
                );

                result.Success = outputSuccess.Value != DBNull.Value
                    && Convert.ToBoolean(outputSuccess.Value);
                result.ErrorMessage = outputMessage.Value != DBNull.Value
                    ? outputMessage.Value.ToString()
                    : "";
                result.Amount = outputAmount.Value != DBNull.Value
                    ? Convert.ToDecimal(outputAmount.Value)
                    : 0;

                return result;
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to unstake mining contract " + contractId, ex);
                result.Success = false;
                result.ErrorMessage = "System error: " + ex.Message;
                return result;
            }
        }

        // =========================================
        // HELPER METHODS
        // =========================================

        /// <summary>
        /// Calculates ROI days based on price and daily output.
        /// </summary>
        private int CalculateRoiDays(decimal price, decimal dailyOutput)
        {
            if (dailyOutput <= 0) return 0;
            // Assume PNC to USD rate of 0.042 for ROI calculation
            decimal dailyUsd = dailyOutput * 0.042m;
            if (dailyUsd <= 0) return 0;
            return (int)Math.Ceiling(price / dailyUsd);
        }
    }
}