using Mexify.Models;
using Mexify.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Mexify.DataAccess.Repositories
{
    public class MyMiningRepository : BaseRepository
    {


        public List<MiningPlan> GetActiveMiningPlans()
        {
            return ExecuteStoredProcedure<MiningPlan>(
                "usp_GetActiveMiningPlans",
                reader => new MiningPlan
                {
                    MiningPlanId = GetSafeInt(reader, "MiningPlanId"),
                    PlanName = GetSafeString(reader, "PlanName") ?? "",
                    Hashrate = GetSafeDecimal(reader, "Hashrate"),
                    Price = GetSafeDecimal(reader, "Price"),
                    ContractDays = GetSafeInt(reader, "ContractDays"),
                    DailyOutput = GetSafeDecimal(reader, "DailyOutput"),
                    PowerConsumption = GetSafeDecimal(reader, "PowerConsumption"),
                    IsPopular = GetSafeBool(reader, "IsPopular"),
                    IsActive = GetSafeBool(reader, "IsActive")
                }
            );
        }

        public List<MiningContract> GetUserMiningContracts(int userId)
        {
            return ExecuteStoredProcedure<MiningContract>(
                "usp_GetUserMiningContracts",
                reader => new MiningContract
                {
                    MiningContractId = GetSafeLong(reader, "MiningContractId"),
                    UserId = GetSafeInt(reader, "UserId"),
                    MiningPlanId = GetSafeInt(reader, "MiningPlanId"),
                    PlanName = GetSafeString(reader, "PlanName") ?? "",
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

        public MiningStats GetUserMiningStats(int userId)
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

        public List<MiningEarning> GetUserMiningEarnings(int userId, int count)
        {
            return ExecuteStoredProcedure<MiningEarning>(
                "usp_GetUserMiningEarnings",
                reader => new MiningEarning
                {
                    EarningId = GetSafeLong(reader, "EarningId"),
                    MiningContractId = GetSafeLong(reader, "MiningContractId"),
                    PlanName = GetSafeString(reader, "PlanName") ?? "",
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

        public List<ChartDataPoint> GetMiningPerformanceHistory(int userId, int days)
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

        public PurchaseResult PurchaseMiningContract(int userId, int planId)
        {
            var result = new PurchaseResult();
            try
            {
                var outputSuccess = new SqlParameter("@Success", SqlDbType.Bit) { Direction = ParameterDirection.Output };
                var outputMessage = new SqlParameter("@Message", SqlDbType.NVarChar, 500) { Direction = ParameterDirection.Output };
                var outputContractId = new SqlParameter("@ContractId", SqlDbType.BigInt) { Direction = ParameterDirection.Output };

                ExecuteStoredProcedureNonQuery(
                    "usp_PurchaseMiningContract",
                    CreateParameter("@UserId", userId),
                    CreateParameter("@MiningPlanId", planId),
                    outputSuccess, outputMessage, outputContractId
                );

                result.Success = outputSuccess.Value != DBNull.Value && Convert.ToBoolean(outputSuccess.Value);
                result.ErrorMessage = outputMessage.Value != DBNull.Value ? outputMessage.Value.ToString() : "";
                result.ContractId = outputContractId.Value != DBNull.Value ? Convert.ToInt64(outputContractId.Value) : 0;
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.ErrorMessage = ex.Message;
                Logger.Error("Failed to purchase mining contract", ex);
            }
            return result;
        }
    }

    public class PurchaseResult
    {
        public bool Success { get; set; }
        public string ErrorMessage { get; set; }
        public long ContractId { get; set; }
    }
}