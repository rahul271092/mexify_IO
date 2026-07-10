using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Mexify.Models;

namespace Mexify.DataAccess.Repositories
{
    public class SalaryRepository : BaseRepository
    {
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
                    SelfProgress = 0,
                    StrongProgress = 0,
                    WeakerProgress = 0
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
              //  TotalEarned = history.Sum(h => h.SalaryAmount),
                PaymentsCount = history.Count,
       //         AveragePayment = history.Count > 0 ? history.Sum(h => h.SalaryAmount) / history.Count : 0
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
    }
}