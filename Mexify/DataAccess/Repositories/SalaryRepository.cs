using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Mexify.Models;
using System.Data;
using Mexify.Utilities;
using System.Linq;

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


        public UserSalaryDetails GetUserSalaryDetails(int userId)
        {
            var results = ExecuteStoredProcedure<UserSalaryDetails>(
                "usp_GetUserSalaryDetails",
                reader => new UserSalaryDetails
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
            return results.Count > 0 ? results[0] : new UserSalaryDetails();
        }

        //internal SalaryStats GetUserSalaryStats(int userId)
        //{
        //    throw new NotImplementedException();
        //}

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

        public SalaryStats GetUserSalaryStats(int userId)
        {
            var history = GetUserSalaryHistory(userId, 1000);
            return new SalaryStats
            {
                  TotalEarned = history.Sum(h => h.SalaryAmount),
                PaymentsCount = history.Count,
                         AveragePayment = history.Count > 0 ? history.Sum(h => h.SalaryAmount) / history.Count : 0
            };
        }



        //public List<SalaryPayment> GetUserSalaryHistory(int userId)
        //{
        //    var payments = new List<SalaryPayment>();

        //    try
        //    {
        //        using (var conn = ConnectionManager.GetConnection())
        //        using (var cmd = new SqlCommand("usp_GetUserSalaryDetails", conn))
        //        {
        //            cmd.CommandType = CommandType.StoredProcedure;
        //            cmd.Parameters.AddWithValue("@UserId", userId);

        //            conn.Open();
        //            using (var reader = cmd.ExecuteReader())
        //            {
        //                // Skip Result Set 1 (Summary)
        //                if (reader.Read()) { /* read or skip */ }

        //                // Skip Result Set 2 (Active Plans)
        //                if (reader.NextResult())
        //                {
        //                    while (reader.Read()) { /* read or skip */ }
        //                }

        //                // ✅ Result Set 3: Payment History (with PaymentDate)
        //                if (reader.NextResult())
        //                {
        //                    while (reader.Read())
        //                    {
        //                        payments.Add(new SalaryPayment
        //                        {
        //                            PaymentId = GetSafeLong(reader, "PaymentId"),
        //                            UserSalaryId = GetSafeLong(reader, "UserSalaryId"),
        //                            UserId = GetSafeInt(reader, "UserId"),
        //                            PaymentDate = GetSafeDateTime(reader, "PaymentDate"),  // ✅ Now exists
        //                            Amount = GetSafeDecimal(reader, "Amount"),
        //                            CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "USDT",
        //                            DayNumber = GetSafeInt(reader, "DayNumber"),
        //                            Status = GetSafeInt(reader, "Status"),
        //                            StatusName = GetSafeString(reader, "StatusName") ?? "",
        //                            StatusSlug = GetSafeString(reader, "StatusSlug") ?? "",
        //                            StatusColor = GetSafeString(reader, "StatusColor") ?? "",
        //                            PlanName = GetSafeString(reader, "PlanName") ?? "",
        //                            IconClass = GetSafeString(reader, "IconClass") ?? "",
        //                            FormattedAmount = GetSafeString(reader, "FormattedAmount") ?? "",
        //                            TimeAgo = GetSafeString(reader, "TimeAgo") ?? "",
        //                            FormattedDate = GetSafeString(reader, "FormattedDate") ?? "",
        //                            FormattedTime = GetSafeString(reader, "FormattedTime") ?? ""
        //                        });
        //                    }
        //                }
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Logger.Error($"Failed to get salary history for User {userId}", ex);
        //    }

        //    return payments;
        //}



        public List<SalaryPayment> GetUserSalaryHistory(int userId)
        {
            var payments = new List<SalaryPayment>();

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
                                payments.Add(new SalaryPayment
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
    }
}