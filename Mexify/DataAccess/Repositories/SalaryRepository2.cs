using Mexify.Models;
using Mexify.Utilities;
using Mexify.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Mexify.DataAccess.Repositories
{
    public class SalaryRepository2 : BaseRepository
    {


      
        // ✅ ADD THIS: Subscribe to a Salary Plan
     

        public Models.UserSalaryDetails GetUserSalaryDetails(int userId)
        {
            var results = ExecuteStoredProcedure<Models.UserSalaryDetails>(
                "usp_GetUserSalaryDetails",
                reader => new Models.UserSalaryDetails
                {
                    CurrentTierId = reader.IsDBNull(reader.GetOrdinal("CurrentTierId")) ? (int?)null : GetSafeInt(reader, "CurrentTierId"),
                    TierCode = GetSafeString(reader, "TierCode"),
                    TierName = GetSafeString(reader, "TierName"),
                    TierLevel = GetSafeInt(reader, "TierLevel"),
                    SelfInvestment = GetSafeDecimal(reader, "SelfInvestment"),
                    StrongLegVolume = GetSafeDecimal(reader, "StrongLegVolume"),
                    WeakerLegVolume = GetSafeDecimal(reader, "WeakerLegVolume"),
                    CurrentMonthlySalary = GetSafeDecimal(reader, "CurrentMonthlySalary"),
                    QualifiedDate = reader.IsDBNull(reader.GetOrdinal("QualifiedDate")) ? (DateTime?)null : GetSafeDateTime(reader, "QualifiedDate"),
                    RequiredSelfInvestment = GetSafeDecimal(reader, "RequiredSelfInvestment"),
                    RequiredStrongLeg = GetSafeDecimal(reader, "RequiredStrongLeg"),
                    RequiredWeakerLeg = GetSafeDecimal(reader, "RequiredWeakerLeg"),
                    IsQualified = GetSafeBool(reader, "IsQualified")
                },
                CreateParameter("@UserId", userId)
            );
            return results.Count > 0 ? results[0] : new Models.UserSalaryDetails();
        }

        public List<InvestorTier> GetAllTiersWithUserStatus(int userId)
        {
            return ExecuteStoredProcedure<InvestorTier>(
                "usp_GetAllInvestorTiers",
                reader => new InvestorTier
                {
                    TierId = GetSafeInt(reader, "TierId"),
                    TierCode = GetSafeString(reader, "TierCode") ?? "",
                    TierName = GetSafeString(reader, "TierName") ?? "",
                    TierLevel = GetSafeInt(reader, "TierLevel"),
                    SelfInvestment = GetSafeDecimal(reader, "SelfInvestment"),
                    StrongLegVolume = GetSafeDecimal(reader, "StrongLegVolume"),
                    WeakerLegVolume = GetSafeDecimal(reader, "WeakerLegVolume"),
                    MonthlySalary = GetSafeDecimal(reader, "MonthlySalary"),
                    Requirements = GetSafeString(reader, "Requirements"),
                    IsActive = GetSafeBool(reader, "IsActive"),
                    IsCurrentTier = false,
                    IsQualified = false
                }
            );
        }

        public List<TierProgress> GetNextTierProgress(int userId)
        {
            return ExecuteStoredProcedure<TierProgress>(
                "usp_GetUserSalaryDetails",
                reader => new TierProgress
                {
                    TierCode = GetSafeString(reader, "TierCode") ?? "",
                    TierName = GetSafeString(reader, "TierName") ?? "",
                    TierLevel = GetSafeInt(reader, "TierLevel"),
                    RequiredSelf = GetSafeDecimal(reader, "RequiredSelfInvestment"),
                    RequiredStrong = GetSafeDecimal(reader, "RequiredStrongLeg"),
                    RequiredWeaker = GetSafeDecimal(reader, "RequiredWeakerLeg"),
                    NextSalary = GetSafeDecimal(reader, "CurrentMonthlySalary"),
                    CurrentSelf = GetSafeDecimal(reader, "SelfInvestment"),
                    CurrentStrong = GetSafeDecimal(reader, "StrongLegVolume"),
                    CurrentWeaker = GetSafeDecimal(reader, "WeakerLegVolume"),

                    // ✅ Now populated from SQL directly
                    SelfProgress = GetSafeDecimal(reader, "SelfProgress"),
                    StrongProgress = GetSafeDecimal(reader, "StrongProgress"),
                    WeakerProgress = GetSafeDecimal(reader, "WeakerProgress"),

                    // Extra fields now available
                    OverallProgress = GetSafeDecimal(reader, "OverallProgress"),
                    IsQualified = GetSafeBool(reader, "IsQualified"),
                    IsCurrentTier = GetSafeBool(reader, "IsCurrentTier"),
                    IsNextTier = GetSafeBool(reader, "IsNextTier"),
                    SelfRemaining = GetSafeDecimal(reader, "SelfRemaining"),
                    StrongRemaining = GetSafeDecimal(reader, "StrongRemaining"),
                    WeakerRemaining = GetSafeDecimal(reader, "WeakerRemaining")
                },
                CreateParameter("@UserId", userId)
            );
        }

        public List<SalaryRecord> GetUserSalaryHistory(int userId, int count)
        {
            return ExecuteStoredProcedure<SalaryRecord>(
                // ✅ FIX: Changed from "usp_GetUserSalaryDetails" to "usp_GetUserSalaryHistory"
                // (Ensure this matches the exact name of your history stored procedure in SQL Server)
                "usp_GetUserSalaryHistory",
                reader => new SalaryRecord
                {
                    SalaryId = GetSafeLong(reader, "SalaryId"),
                    SalaryMonth = GetSafeInt(reader, "SalaryMonth"),
                    SalaryYear = GetSafeInt(reader, "SalaryYear"),
                    SalaryAmount = GetSafeDecimal(reader, "SalaryAmount"),
                    PaymentDate = GetSafeDateTime(reader, "PaymentDate"),
                    PaymentStatus = GetSafeInt(reader, "PaymentStatus"),
                    TierName = GetSafeString(reader, "TierName") ?? "",
                    MonthName = GetSafeString(reader, "MonthName") ?? ""
                },
                CreateParameter("@UserId", userId),
                CreateParameter("@Count", count) // ✅ Added @Count parameter to match the method signature
            );
        }

        public Models.SalaryStats GetUserSalaryStats(int userId)
        {
            var history = GetUserSalaryHistory(userId, 1000);
            return new Models.SalaryStats
            {
                TotalEarned = history.Sum(h => h.SalaryAmount),
                PaymentsCount = history.Count,
                AveragePayment = history.Count > 0 ? history.Sum(h => h.SalaryAmount) / history.Count : 0
            };
        }

        public List<InvestorTier> GetAllTiers()
        {
            return ExecuteStoredProcedure<InvestorTier>(
                "usp_GetAllInvestorTiers",
                reader => new InvestorTier
                {
                    TierId = GetSafeInt(reader, "TierId"),
                    TierCode = GetSafeString(reader, "TierCode") ?? "",
                    TierName = GetSafeString(reader, "TierName") ?? "",
                    TierLevel = GetSafeInt(reader, "TierLevel"),
                    SelfInvestment = GetSafeDecimal(reader, "SelfInvestment"),
                    StrongLegVolume = GetSafeDecimal(reader, "StrongLegVolume"),
                    WeakerLegVolume = GetSafeDecimal(reader, "WeakerLegVolume"),
                    MonthlySalary = GetSafeDecimal(reader, "MonthlySalary"),
                    Requirements = GetSafeString(reader, "Requirements"),
                    IsActive = GetSafeBool(reader, "IsActive")
                }
            );
        }

        public List<SalaryPlan> GetActivePlans(int? userId = null)
        {
            var plans = new Dictionary<int, SalaryPlan>();
            var features = new List<SalaryPlanFeature>();

            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_GetActiveSalaryPlans", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId.HasValue ? (object)userId.Value : DBNull.Value);

                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        // ==========================================
                        // RESULT SET 1: PLANS
                        // ==========================================
                        while (reader.Read())
                        {
                            var plan = new SalaryPlan
                            {
                                PlanId = GetSafeInt(reader, "PlanId"),
                                PlanName = GetSafeString(reader, "PlanName"),
                                PlanSlug = GetSafeString(reader, "PlanSlug"),
                                Description = GetSafeString(reader, "Description"),
                                ShortDescription = GetSafeString(reader, "ShortDescription"),
                                InvestmentAmount = GetSafeDecimal(reader, "InvestmentAmount"),
                                CurrencyCode = GetSafeString(reader, "CurrencyCode"),
                                DailySalary = GetSafeDecimal(reader, "DailySalary"),
                                DurationDays = GetSafeInt(reader, "DurationDays"),
                                TotalEarning = GetSafeDecimal(reader, "TotalEarning"),
                                RequiredTierId = reader["RequiredTierId"] == DBNull.Value ? (int?)null : GetSafeInt(reader, "RequiredTierId"),
                                RequiredTierCode = GetSafeString(reader, "RequiredTierCode"),
                                MinSelfInvestment = GetSafeDecimal(reader, "MinSelfInvestment"),
                                MinTeamBusiness = GetSafeDecimal(reader, "MinTeamBusiness"),
                                IconClass = GetSafeString(reader, "IconClass"),
                                ColorClass = GetSafeString(reader, "ColorClass"),
                                BadgeText = GetSafeString(reader, "BadgeText"),
                                IsPopular = GetSafeBool(reader, "IsPopular"),
                                IsFeatured = GetSafeBool(reader, "IsFeatured"),
                                MaxUsers = reader["MaxUsers"] == DBNull.Value ? (int?)null : GetSafeInt(reader, "MaxUsers"),
                                CurrentUsers = GetSafeInt(reader, "CurrentUsers"),
                                AvailableSlots = GetSafeInt(reader, "AvailableSlots"),
                                IsEligible = GetSafeBool(reader, "IsEligible"),
                                HasRequiredTier = GetSafeBool(reader, "HasRequiredTier"),
                                FormattedInvestment = GetSafeString(reader, "FormattedInvestment"),
                                FormattedDailySalary = GetSafeString(reader, "FormattedDailySalary"),
                                FormattedTotalEarning = GetSafeString(reader, "FormattedTotalEarning"),
                                RequirementText = GetSafeString(reader, "RequirementText"),
                                AvailabilityText = GetSafeString(reader, "AvailabilityText")
                            };

                            plans[plan.PlanId] = plan;
                        }

                        // ==========================================
                        // RESULT SET 2: FEATURES
                        // ==========================================
                        if (reader.NextResult())
                        {
                            while (reader.Read())
                            {
                                var feature = new SalaryPlanFeature
                                {
                                    PlanId = GetSafeInt(reader, "PlanId"),
                                    FeatureId = GetSafeInt(reader, "FeatureId"),
                                    FeatureText = GetSafeString(reader, "FeatureText"),
                                    IconClass = GetSafeString(reader, "IconClass"),
                                    IsIncluded = GetSafeBool(reader, "IsIncluded")
                                };

                                features.Add(feature);
                            }
                        }
                    }
                }

                // Assign features to their respective plans
                foreach (var feature in features)
                {
                    if (plans.ContainsKey(feature.PlanId))
                    {
                        plans[feature.PlanId].Features.Add(feature);
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get active salary plans", ex);
            }

            return plans.Values.ToList();
        }

        //public InvestorTier GetFirstTierRequirements()
        //{
        //    return ExecuteStoredProcedure<InvestorTier>(
        //        "usp_GetFirstTierRequirements",
        //        reader => new InvestorTier
        //        {
        //            TierId = GetSafeInt(reader, "TierId"),
        //            TierCode = GetSafeString(reader, "TierCode") ?? "",
        //            TierName = GetSafeString(reader, "TierName") ?? "",
        //            TierLevel = GetSafeInt(reader, "TierLevel"),
        //            SelfInvestment = GetSafeDecimal(reader, "SelfInvestment"),
        //            StrongLegVolume = GetSafeDecimal(reader, "StrongLegVolume"),
        //            WeakerLegVolume = GetSafeDecimal(reader, "WeakerLegVolume"),
        //            MonthlySalary = GetSafeDecimal(reader, "MonthlySalary"),
        //            Requirements = GetSafeString(reader, "Requirements"),
        //            IsActive = GetSafeBool(reader, "IsActive")
        //        }
        //    ).FirstOrDefault();
        //}


        //public Tuple<bool, string, long> Subscribe(int userId, int planId)
        //{
        //    try
        //    {
        //        using (var conn = ConnectionManager.GetConnection())
        //        using (var cmd = new SqlCommand("usp_SubscribeToSalaryPlan", conn))
        //        {
        //            cmd.CommandType = CommandType.StoredProcedure;
        //            cmd.Parameters.AddWithValue("@UserId", userId);
        //            cmd.Parameters.AddWithValue("@PlanId", planId);

        //            var successParam = new SqlParameter("@Success", SqlDbType.Bit) { Direction = ParameterDirection.Output };
        //            var messageParam = new SqlParameter("@Message", SqlDbType.NVarChar, 500) { Direction = ParameterDirection.Output };
        //            var subscriptionIdParam = new SqlParameter("@SubscriptionId", SqlDbType.BigInt) { Direction = ParameterDirection.Output };

        //            cmd.Parameters.Add(successParam);
        //            cmd.Parameters.Add(messageParam);
        //            cmd.Parameters.Add(subscriptionIdParam);

        //            conn.Open();
        //            cmd.ExecuteNonQuery();

        //            bool success = successParam.Value != DBNull.Value && (bool)successParam.Value;
        //            string message = messageParam.Value?.ToString() ?? "";
        //            long subId = subscriptionIdParam.Value != DBNull.Value ? Convert.ToInt64(subscriptionIdParam.Value) : 0;

        //            return new Tuple<bool, string, long>(success, message, subId);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Logger.Error($"Failed to subscribe user {userId} to plan {planId}", ex);
        //        return new Tuple<bool, string, long>(false, ex.Message, 0);
        //    }
        //}

    }
}