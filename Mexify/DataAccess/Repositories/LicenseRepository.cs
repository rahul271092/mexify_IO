using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Mexify.Models;
using System.Data;
using Mexify.Utilities;

namespace Mexify.DataAccess.Repositories
{
    public class LicenseRepository : BaseRepository
    {
        public UserLicense GetUserActiveLicense(int userId)
        {
            var results = ExecuteStoredProcedure<UserLicense>(
                "usp_GetUserActiveLicense",
                reader => new UserLicense
                {
                    LicenseId = GetSafeLong(reader, "LicenseId"),
                    LicenseType = GetSafeString(reader, "LicenseType") ?? "",
                    LicenseName = GetSafeString(reader, "LicenseName") ?? "",
                    IsActive = GetSafeBool(reader, "IsActive"),
                    StartDate = GetSafeDateTime(reader, "StartDate"),
                    ExpiryDate = GetSafeDateTime(reader, "ExpiryDate"),
                    Price = GetSafeDecimal(reader, "Price")
                },
                CreateParameter("@UserId", userId)
            );
            return results.Count > 0 ? results[0] : null;
        }

        public List<LicenseHistoryItem> GetLicenseHistory(int userId)
        {
            return ExecuteStoredProcedure<LicenseHistoryItem>(
                "usp_GetLicenseHistory",
                reader => new LicenseHistoryItem
                {
                    HistoryId = GetSafeLong(reader, "HistoryId"),
                    LicenseType = GetSafeString(reader, "LicenseType") ?? "",
                    LicenseName = GetSafeString(reader, "LicenseName") ?? "",
                    Amount = GetSafeDecimal(reader, "Amount"),
                    PurchaseDate = GetSafeDateTime(reader, "PurchaseDate"),
                    ExpiryDate = GetSafeDateTime(reader, "ExpiryDate"),
                    IsActive = GetSafeBool(reader, "IsActive")
                },
                CreateParameter("@UserId", userId)
            );
        }

        public LicensePurchaseResult PurchaseLicense(int userId, string licenseType, decimal amount, DateTime expiryDate)
        {
            var result = new LicensePurchaseResult();
            try
            {
                var outputId = new SqlParameter("@LicenseId", System.Data.SqlDbType.BigInt)
                {
                    Direction = System.Data.ParameterDirection.Output
                };
                var outputSuccess = new SqlParameter("@Success", System.Data.SqlDbType.Bit)
                {
                    Direction = System.Data.ParameterDirection.Output
                };
                var outputMessage = new SqlParameter("@Message", System.Data.SqlDbType.NVarChar, 500)
                {
                    Direction = System.Data.ParameterDirection.Output
                };

                ExecuteStoredProcedureNonQuery(
                    "usp_PurchaseLicense",
                    CreateParameter("@UserId", userId),
                    CreateParameter("@LicenseType", licenseType),
                    CreateParameter("@Amount", amount),
                    CreateParameter("@ExpiryDate", expiryDate),
                    outputId,
                    outputSuccess,
                    outputMessage
                );

                result.Success = outputSuccess.Value != DBNull.Value && Convert.ToBoolean(outputSuccess.Value);
                result.ErrorMessage = outputMessage.Value != DBNull.Value ? outputMessage.Value.ToString() : "";
                result.NewLicenseId = outputId.Value != DBNull.Value ? Convert.ToInt64(outputId.Value) : 0;
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.ErrorMessage = "Database error: " + ex.Message;
            }
            return result;
        }



        public List<LicensePackage> GetActivePackages()
        {
            try
            {
                return ExecuteStoredProcedure<LicensePackage>(
                    "usp_GetActiveLicensePackages",
                    reader => new LicensePackage
                    {
                        PackageId = GetSafeInt(reader, "PackageId"),
                        PackageName = GetSafeString(reader, "PackageName") ?? "",
                        Price = GetSafeDecimal(reader, "Price"),
                        DailyROI = GetSafeDecimal(reader, "DailyROI"),
                        DurationDays = GetSafeInt(reader, "DurationDays"),
                        TotalReturn = GetSafeDecimal(reader, "TotalReturn"),
                        CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "USDT",
                        Benefits = GetSafeString(reader, "Benefits"),
                        IsActive = GetSafeBool(reader, "IsActive"),
                        CreatedDate = GetSafeDateTime(reader, "CreatedDate"),
                        ActivePartners = GetSafeInt(reader, "ActivePartners")
                    }
                );
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get license packages", ex);
                return new List<LicensePackage>();
            }
        }

        public List<LicenseCommissionTier> GetCommissionTiers()
        {
            try
            {
                return ExecuteStoredProcedure<LicenseCommissionTier>(
                    "usp_GetLicenseCommissionTiers",
                    reader => new LicenseCommissionTier
                    {
                        Level = GetSafeInt(reader, "Level"),
                        CommissionPercent = GetSafeDecimal(reader, "CommissionPercent"),
                        IsActive = GetSafeBool(reader, "IsActive")
                    }
                );
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get commission tiers", ex);
                return new List<LicenseCommissionTier>();
            }
        }

        public LicenseStats GetUserLicenseStats(int userId)
        {
            var stats = new LicenseStats();

            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_GetUserLicenseStats", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    conn.Open();

                    using (var reader = cmd.ExecuteReader())
                    {
                        // Result Set 1: Summary
                        if (reader.Read())
                        {
                            stats.ActiveLicenses = GetSafeInt(reader, "ActiveLicenses");
                            stats.TotalROIEarned = GetSafeDecimal(reader, "TotalROIEarned");
                            stats.TotalDirectIncome = GetSafeDecimal(reader, "TotalDirectIncome");
                            stats.TotalCommissionEarned = GetSafeDecimal(reader, "TotalCommissionEarned");
                            stats.TodayROI = GetSafeDecimal(reader, "TodayROI");
                            stats.DailyProjectedROI = GetSafeDecimal(reader, "DailyProjectedROI");
                            stats.DirectReferrals = GetSafeInt(reader, "DirectReferrals");
                        }

                        // Result Set 2: User's licenses
                        if (reader.NextResult())
                        {
                            while (reader.Read())
                            {
                                stats.MyLicenses.Add(new UserLicense
                                {
                                    LicenseId = GetSafeLong(reader, "LicenseId"),
                                    PackageId = GetSafeInt(reader, "PackageId"),
                                    PackageName = GetSafeString(reader, "PackageName") ?? "",
                                    PurchasePrice = GetSafeDecimal(reader, "PurchasePrice"),
                                    DailyROI = GetSafeDecimal(reader, "DailyROI"),
                                    DurationDays = GetSafeInt(reader, "DurationDays"),
                                    TotalReturn = GetSafeDecimal(reader, "TotalReturn"),
                                    TotalEarned = GetSafeDecimal(reader, "TotalEarned"),
                                    DirectIncomeEarned = GetSafeDecimal(reader, "DirectIncomeEarned"),
                                    StartDate = GetSafeDateTime(reader, "StartDate"),
                                    EndDate = GetSafeDateTime(reader, "EndDate"),
                                    Status = GetSafeInt(reader, "Status"),
                                    DaysElapsed = GetSafeInt(reader, "DaysElapsed"),
                                    DaysRemaining = GetSafeInt(reader, "DaysRemaining"),
                                    ProgressPercent = GetSafeInt(reader, "ProgressPercent")
                                });
                            }
                        }

                        // Result Set 3: Level breakdown
                        if (reader.NextResult())
                        {
                            while (reader.Read())
                            {
                                stats.LevelBreakdown.Add(new LicenseCommissionTier
                                {
                                    Level = GetSafeInt(reader, "Level"),
                                    CommissionPercent = GetSafeDecimal(reader, "CommissionPercent"),
                                    TimesEarned = GetSafeInt(reader, "TimesEarned"),
                                    LevelTotal = GetSafeDecimal(reader, "LevelTotal")
                                });
                            }
                        }

                        // Result Set 4: Recent commissions
                        if (reader.NextResult())
                        {
                            while (reader.Read())
                            {
                                stats.RecentCommissions.Add(new LicenseCommission
                                {
                                    CommissionId = GetSafeLong(reader, "CommissionId"),
                                    FromUserId = GetSafeInt(reader, "FromUserId"),
                                    FromUserName = GetSafeString(reader, "FromUserName") ?? "",
                                    Level = GetSafeInt(reader, "Level"),
                                    PurchaseAmount = GetSafeDecimal(reader, "PurchaseAmount"),
                                    CommissionPercent = GetSafeDecimal(reader, "CommissionPercent"),
                                    CommissionAmount = GetSafeDecimal(reader, "CommissionAmount"),
                                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "USDT",
                                    CreatedDate = GetSafeDateTime(reader, "CreatedDate")
                                });
                            }
                        }

                        // Result Set 5: Recent ROI
                        if (reader.NextResult())
                        {
                            while (reader.Read())
                            {
                                stats.RecentROI.Add(new LicenseDailyReturn
                                {
                                    ReturnId = GetSafeLong(reader, "ReturnId"),
                                    LicenseId = GetSafeLong(reader, "LicenseId"),
                                    PackageName = GetSafeString(reader, "PackageName") ?? "",
                                    ReturnAmount = GetSafeDecimal(reader, "ReturnAmount"),
                                    ROIPercent = GetSafeDecimal(reader, "ROIPercent"),
                                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "USDT",
                                    EarnedDate = GetSafeDateTime(reader, "EarnedDate")
                                });
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get user license stats", ex);
            }

            return stats;
        }

        public LicensePurchaseResult PurchaseLicense(int userId, int packageId)
        {
            var result = new LicensePurchaseResult();
            try
            {
                var outputSuccess = new SqlParameter("@Success", SqlDbType.Bit) { Direction = ParameterDirection.Output };
                var outputMessage = new SqlParameter("@Message", SqlDbType.NVarChar, 500) { Direction = ParameterDirection.Output };
                var outputLicenseId = new SqlParameter("@LicenseId", SqlDbType.BigInt) { Direction = ParameterDirection.Output };

                ExecuteStoredProcedureNonQuery(
                    "usp_PurchaseLicense",
                    CreateParameter("@UserId", userId),
                    CreateParameter("@PackageId", packageId),
                    outputSuccess, outputMessage, outputLicenseId
                );

                result.Success = outputSuccess.Value != DBNull.Value && Convert.ToBoolean(outputSuccess.Value);
                result.ErrorMessage = outputMessage.Value != DBNull.Value ? outputMessage.Value.ToString() : "";
                result.LicenseId = outputLicenseId.Value != DBNull.Value ? Convert.ToInt64(outputLicenseId.Value) : 0;
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.ErrorMessage = "System error: " + ex.Message;
                Logger.Error("Failed to purchase license", ex);
            }
            return result;
        }
    }
}