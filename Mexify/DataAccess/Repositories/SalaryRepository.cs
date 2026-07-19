using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Mexify.Models;
using System.Data;
using Mexify.Utilities;
using System.Linq;
using Mexify.Web.Models;

namespace Mexify.DataAccess.Repositories
{
    public class SalaryRepository : BaseRepository
    {

        public List<InvestorTier> GetAllTiers()
        {
            var tiers = new List<InvestorTier>();

            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_GetAllInvestorTiers", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@IsActiveOnly", 1);

                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            tiers.Add(new InvestorTier
                            {
                                TierId = GetSafeInt(reader, "TierId"),
                                TierCode = GetSafeString(reader, "TierCode") ?? "",          // ✅ Now exists
                                TierName = GetSafeString(reader, "TierName") ?? "",
                                Description = GetSafeString(reader, "Description") ?? "",
                                MinInvestment = GetSafeDecimal(reader, "MinInvestment"),
                                MaxInvestment = GetSafeDecimal(reader, "MaxInvestment"),
                                ReturnPercent = GetSafeDecimal(reader, "ReturnPercent"),
                                DurationDays = GetSafeInt(reader, "DurationDays"),
                                DailyReturn = GetSafeDecimal(reader, "DailyReturn"),
                                CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "USDT",
                                IconClass = GetSafeString(reader, "IconClass") ?? "fas fa-star",
                                ColorClass = GetSafeString(reader, "ColorClass") ?? "gold",
                                BadgeText = GetSafeString(reader, "BadgeText") ?? "",
                                Features = GetSafeString(reader, "Features") ?? "",
                                IsActive = GetSafeBool(reader, "IsActive"),
                                IsFeatured = GetSafeBool(reader, "IsFeatured"),
                                InvestmentRange = GetSafeString(reader, "InvestmentRange") ?? "",
                                ReturnDisplay = GetSafeString(reader, "ReturnDisplay") ?? "",
                                DurationDisplay = GetSafeString(reader, "DurationDisplay") ?? "",
                                FormattedMinInvestment = GetSafeString(reader, "FormattedMinInvestment") ?? "",
                                FormattedMaxInvestment = GetSafeString(reader, "FormattedMaxInvestment") ?? "",
                                EstimatedReturn = GetSafeDecimal(reader, "EstimatedReturn"),
                                ROIDisplay = GetSafeString(reader, "ROIDisplay") ?? ""
                            });
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get investor tiers", ex);
            }

            return tiers;
        }

     

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
                "usp_GetUserSalaryDetails",
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
                CreateParameter("@UserId", userId)
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



        public List<Models.SalaryPayment> GetUserSalaryHistory(int userId)
        {
            var payments = new List<Models.SalaryPayment>();

            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_GetUserSalaryDetails", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        // Skip Result Set 1 (Summary)
                        if (reader.Read()) { /* read or skip */ }

                        // Skip Result Set 2 (Active Plans)
                        if (reader.NextResult())
                        {
                            while (reader.Read()) { /* read or skip */ }
                        }

                        // ✅ Result Set 3: Payment History (with PaymentDate)
                        if (reader.NextResult())
                        {
                            while (reader.Read())
                            {
                                payments.Add(new Models.SalaryPayment
                                {
                                    PaymentId = GetSafeLong(reader, "PaymentId"),
                                    UserSalaryId = GetSafeLong(reader, "UserSalaryId"),
                                    UserId = GetSafeInt(reader, "UserId"),
                                    PaymentDate = GetSafeDateTime(reader, "PaymentDate"),  // ✅ Now exists
                                    Amount = GetSafeDecimal(reader, "Amount"),
                                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "USDT",
                                    DayNumber = GetSafeInt(reader, "DayNumber"),
                                    Status = GetSafeInt(reader, "Status"),
                                    StatusName = GetSafeString(reader, "StatusName") ?? "",
                                    StatusSlug = GetSafeString(reader, "StatusSlug") ?? "",
                                    StatusColor = GetSafeString(reader, "StatusColor") ?? "",
                                    PlanName = GetSafeString(reader, "PlanName") ?? "",
                                    IconClass = GetSafeString(reader, "IconClass") ?? "",
                                    FormattedAmount = GetSafeString(reader, "FormattedAmount") ?? "",
                                    TimeAgo = GetSafeString(reader, "TimeAgo") ?? "",
                                    FormattedDate = GetSafeString(reader, "FormattedDate") ?? "",
                                    FormattedTime = GetSafeString(reader, "FormattedTime") ?? ""
                                });
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Error($"Failed to get salary history for User {userId}", ex);
            }

            return payments;
        }



        public List<Models.SalaryPayment> GetUserSalaryHistory(int userId, out int Count)
        {
            var payments = new List<Models.SalaryPayment>();
            Count = 20;
            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_GetUserSalaryDetails", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        // Skip Result Set 1 (Summary)
                        if (reader.Read()) { /* read or skip */ }

                        // Skip Result Set 2 (Active Plans)
                        if (reader.NextResult())
                        {
                            while (reader.Read()) { /* read or skip */ }
                        }

                        // ✅ Result Set 3: Payment History (with PaymentDate and SalaryAmount)
                        if (reader.NextResult())
                        {
                            while (reader.Read())
                            {
                                payments.Add(new Models.SalaryPayment
                                {
                                    PaymentId = GetSafeLong(reader, "PaymentId"),
                                    UserSalaryId = GetSafeLong(reader, "UserSalaryId"),
                                    UserId = GetSafeInt(reader, "UserId"),
                                    PaymentDate = GetSafeDateTime(reader, "PaymentDate"),  // ✅ Now exists
                                    Amount = GetSafeDecimal(reader, "Amount"),
                                    SalaryAmount = GetSafeDecimal(reader, "SalaryAmount"),  // ✅ Now exists
                                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "USDT",
                                    DayNumber = GetSafeInt(reader, "DayNumber"),
                                    Status = GetSafeInt(reader, "Status"),
                                    StatusName = GetSafeString(reader, "StatusName") ?? "",
                                    StatusSlug = GetSafeString(reader, "StatusSlug") ?? "",
                                    StatusColor = GetSafeString(reader, "StatusColor") ?? "",
                                    PlanName = GetSafeString(reader, "PlanName") ?? "",
                                    IconClass = GetSafeString(reader, "IconClass") ?? "",
                                    FormattedAmount = GetSafeString(reader, "FormattedAmount") ?? "",
                                    TimeAgo = GetSafeString(reader, "TimeAgo") ?? "",
                                    FormattedDate = GetSafeString(reader, "FormattedDate") ?? "",
                                    FormattedTime = GetSafeString(reader, "FormattedTime") ?? ""
                                });
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Error($"Failed to get salary history for User {userId}", ex);
            }

            return payments;
        }


        //public List<InvestorTier> GetAllTiers()
        //{
        //    return ExecuteStoredProcedure<InvestorTier>(
        //        "usp_GetAllInvestorTiers",
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
        //    );
        //}



        public List<SalaryPlan> GetActivePlans(int? userId = null)
        {
            var plans = new Dictionary<int, SalaryPlan>();
            var features = new List<SalaryPlanFeature>();

            try
            {
                // ✅ FIX: Use standard ADO.NET to safely handle multiple result sets
                // The previous lambda approach incremented resultSet per ROW, causing crashes.
                using (var conn =  ConnectionManager.GetConnection())
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
                        // ✅ FIX: reader.NextResult() correctly moves to the 2nd result set
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

        // ✅ FIX: Changed from (bool, string, long) to Tuple<bool, string, long> 
        // to prevent "multiple arguments not allowed" compiler errors in older .NET Frameworks.
        public Tuple<bool, string, long> Subscribe(int userId, int planId)
        {
            try
            {

                using (var conn =ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_SubscribeToSalaryPlan", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@PlanId", planId);

                    var successParam = new SqlParameter("@Success", SqlDbType.Bit) { Direction = ParameterDirection.Output };
                    var messageParam = new SqlParameter("@Message", SqlDbType.NVarChar, 500) { Direction = ParameterDirection.Output };
                    var subscriptionIdParam = new SqlParameter("@SubscriptionId", SqlDbType.BigInt) { Direction = ParameterDirection.Output };

                    cmd.Parameters.Add(successParam);
                    cmd.Parameters.Add(messageParam);
                    cmd.Parameters.Add(subscriptionIdParam);

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    bool success = successParam.Value != DBNull.Value && (bool)successParam.Value;
                    string message = messageParam.Value?.ToString() ?? "";
                    long subId = subscriptionIdParam.Value != DBNull.Value ? Convert.ToInt64(subscriptionIdParam.Value) : 0;

                    return new Tuple<bool, string, long>(success, message, subId);
                }
            }
            catch (Exception ex)
            {
                Logger.Error($"Failed to subscribe user {userId} to plan {planId}", ex);
                return new Tuple<bool, string, long>(false, ex.Message, 0);
            }
        }


    }
}