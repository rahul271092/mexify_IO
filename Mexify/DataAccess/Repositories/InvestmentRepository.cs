using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Mexify.Web.Models;
using System.Data.SqlClient;
using Mexify.Models;
using Mexify.Utilities;

namespace Mexify.DataAccess.Repositories
{
    public class InvestmentRepository : BaseRepository
    {
       



        public List<InvestmentPlan> GetActivePlans()
        {
            return ExecuteStoredProcedure(
                "usp_GetActiveInvestmentPlans",
                MapInvestmentPlan
            );
        }


        public InvestmentStats GetUserInvestmentStats(int userId)
        {
            var results = ExecuteStoredProcedure<InvestmentStats>(
                "usp_GetUserInvestmentStats",
                reader => new InvestmentStats
                {
                    TotalInvested = GetSafeDecimal(reader, "TotalInvested"),
                    ActivePlans = GetSafeInt(reader, "ActivePlans"),
                    MaturedPlans = GetSafeInt(reader, "MaturedPlans"),
                    TotalEarned = GetSafeDecimal(reader, "TotalEarned"),
                    TodayROI = GetSafeDecimal(reader, "TodayROI")
                },
                CreateParameter("@UserId", userId)
            );
            return results.Count > 0 ? results[0] : new InvestmentStats();
        }


        public List<Models.ActiveInvestment> GetUserActiveInvestments(int userId)
        {
            try
            {
                return ExecuteStoredProcedure<Models.ActiveInvestment>(
                    "usp_GetUserActiveInvestments",
                    reader => new Models.ActiveInvestment
                    {
                // ✅ Map to the EXACT column names returned by the stored procedure
                InvestmentId = GetSafeLong(reader, "InvestmentId"),
                        InvestmentType = GetSafeString(reader, "InvestmentType") ?? "",
                        PlanName = GetSafeString(reader, "PlanName") ?? "",
                        PrincipalAmount = GetSafeDecimal(reader, "PrincipalAmount"), // ✅ Changed from InvestedAmount
                DailyRatePercent = GetSafeDecimal(reader, "DailyRatePercent"),
                        TotalEarned = GetSafeDecimal(reader, "TotalEarned"),
                        StartDate = GetSafeDateTime(reader, "StartDate"),
                        EndDate = GetSafeDateTime(reader, "EndDate"),
                        ProgressPercent = GetSafeInt(reader, "ProgressPercent")
                    },
                    CreateParameter("@UserId", userId)
                );
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get user active investments", ex);
                return new List<Models.ActiveInvestment>();
            }
        }

        //public List<UserInvestment> GetUserActiveInvestments(int userId)
        //{
        //    try
        //    {
        //        Logger.Info("Get User Active Investment code executed");

        //        return ExecuteStoredProcedure<UserInvestment>(
        //        "usp_GetUserActiveInvestments",
        //        reader => new UserInvestment
        //        {
        //            InvestmentId = GetSafeLong(reader, "InvestmentId"),
        //            PlanName = GetSafeString(reader, "PlanName") ?? "Investment",
        //            InvestedAmount = GetSafeDecimal(reader, "InvestedAmount"),
        //            DailyROI = GetSafeDecimal(reader, "DailyRatePercent"),
        //            TotalEarned = GetSafeDecimal(reader, "TotalEarned"),
        //            CurrentDay = GetSafeInt(reader, "CurrentDay"),
        //           // TotalDays = GetSafeInt(reader, "TotalDays"),
        //            ProgressPercent = GetSafeDecimal(reader, "ProgressPercent"),
        //           // Status = GetSafeInt(reader, "Status"),
        //            StartDate = GetSafeDateTime(reader, "StartDate"),
        //            EndDate = GetSafeDateTime(reader, "EndDate"),
        //            //EndDateIso = GetSafeString(reader, "EndDateIso")
        //        },
        //        CreateParameter("@UserId", userId)
        //    );

        //    }
        //    catch (Exception ex)
        //    {
        //        Logger.Error("Exception Generated in Get User Active Investments function", ex);
        //        Logger.Info("Exception " + ex.ToString());
        //        return new List<UserInvestment>();

        //    }

        //}

        public List<UserInvestment> GetUserMaturedInvestments(int userId)
        {
            return ExecuteStoredProcedure<UserInvestment>(
                "usp_GetUserMaturedInvestments",
                reader => new UserInvestment
                {
                    InvestmentId = GetSafeLong(reader, "InvestmentId"),
                    PlanName = GetSafeString(reader, "PlanName") ?? "Investment",
                    InvestedAmount = GetSafeDecimal(reader, "InvestedAmount"),
                    DailyROI = GetSafeDecimal(reader, "DailyROI"),
                    TotalEarned = GetSafeDecimal(reader, "TotalEarned"),
                    CurrentDay = GetSafeInt(reader, "CurrentDay"),
                    TotalDays = GetSafeInt(reader, "TotalDays"),
                    ProgressPercent = GetSafeDecimal(reader, "ProgressPercent"),
                    Status = GetSafeInt(reader, "Status"),
                    StartDate = GetSafeDateTime(reader, "StartDate"),
                    EndDate = GetSafeDateTime(reader, "EndDate"),
                    EndDateIso = GetSafeString(reader, "EndDateIso")
                },
                CreateParameter("@UserId", userId)
            );
        }

        public List<UserInvestment> GetUserAllInvestments(int userId)
        {
            return ExecuteStoredProcedure<UserInvestment>(
                "usp_GetUserAllInvestments",
                reader => new UserInvestment
                {
                    InvestmentId = GetSafeLong(reader, "InvestmentId"),
                    PlanName = GetSafeString(reader, "PlanName") ?? "Investment",
                    InvestedAmount = GetSafeDecimal(reader, "InvestedAmount"),
                    TotalEarned = GetSafeDecimal(reader, "TotalEarned"),
                    Status = GetSafeInt(reader, "Status"),
                    StartDate = GetSafeDateTime(reader, "StartDate")
                },
                CreateParameter("@UserId", userId)
            );
        }
        /// <summary>
        /// Gets a specific investment plan by ID.
        /// </summary>
        public InvestmentPlan GetPlanById(int planId)
        {
            var results = ExecuteStoredProcedure(
                "usp_GetInvestmentPlanById",
                MapInvestmentPlan,
                CreateParameter("@PlanId", planId)
            );

            return results.Count > 0 ? results[0] : null;
        }

        /// <summary>
        /// Creates a new investment.
        /// </summary>
        public long CreateInvestment(int userId, int planId, decimal amount)
        {
            var outputParam = CreateOutputParameter("@InvestmentId", System.Data.SqlDbType.BigInt);

            ExecuteStoredProcedureNonQuery(
                "usp_CreateInvestment",
                CreateParameter("@UserId", userId),
                CreateParameter("@PlanId", planId),
                CreateParameter("@Amount", amount),
                outputParam
            );

            return (long)outputParam.Value;
        }

        /// <summary>
        /// Maps SqlDataReader to InvestmentPlan object.
        /// </summary>
        private InvestmentPlan MapInvestmentPlan(SqlDataReader reader)
        {
                 return new InvestmentPlan
                 {
                     PlanId = GetSafeInt(reader, "PlanId"),
                     PlanName = GetSafeString(reader, "PlanName") ?? "Plan",
                     MinAmount = GetSafeDecimal(reader, "MinAmount"),
                     MaxAmount = GetSafeDecimal(reader, "MaxAmount"),
                     DailyROI = GetSafeDecimal(reader, "DailyROI"),
                     DurationDays = GetSafeInt(reader, "DurationDays"),
                     CapitalReturnPercent = GetSafeDecimal(reader, "CapitalReturnPercent"),
                     RiskLevel = GetSafeInt(reader, "RiskLevel"),
                     CompoundingFrequency = GetSafeInt(reader, "CompoundingFrequency"),
                     IsActive = GetSafeBool(reader, "IsActive"),
                     CreatedDate = GetSafeDateTime(reader, "CreatedDate"),

                     // Calculated fields from stored procedure
                     TotalROIPercent = GetSafeDecimal(reader, "TotalROIPercent"),
                     TotalPayoutPercent = GetSafeDecimal(reader, "TotalPayoutPercent"),
                     MinInvestmentProfit = GetSafeDecimal(reader, "MinInvestmentProfit"),
                     MaxInvestmentProfit = GetSafeDecimal(reader, "MaxInvestmentProfit"),
                     ActiveInvestorCount = GetSafeInt(reader, "ActiveInvestorCount"),
                     TotalInvestedAmount = GetSafeDecimal(reader, "TotalInvestedAmount"),
                     RiskLevelLabel = GetSafeString(reader, "RiskLevelLabel")
                 };
       
        }

    }
}