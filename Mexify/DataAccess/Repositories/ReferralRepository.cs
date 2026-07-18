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
    public class ReferralRepository : BaseRepository
    {
        public int UserId { get; private set; }
        public string UserName { get; private set; }
        public int DirectReferrals { get; private set; }
        public int TeamSize { get; private set; }
        public decimal PersonalInvestment { get; private set; }
        public decimal TotalCommission { get; private set; }
        public decimal MonthCommission { get; private set; }
        public int CurrentRankLevel { get; private set; }
        public string CurrentRankName { get; private set; }
        public string CurrentRankIcon { get; private set; }
        public string CurrentRankColor { get; private set; }
        public decimal CurrentCommissionRate { get; private set; }
        public int NextRankLevel { get; private set; }
        public string NextRankName { get; private set; }
        public int NextRankDirectRequired { get; private set; }
        public int NextRankTeamRequired { get; private set; }
        public decimal DirectProgressPercent { get; private set; }
        public decimal TeamProgressPercent { get; private set; }
        public bool HasNextRank { get; private set; }

        public Models.ReferralStats GetUserReferralStats(int userId)
        {
            var results = ExecuteStoredProcedure<Models.ReferralStats>(
     "usp_GetReferralStats", // ✅ Procedure name is now correct
     reader => new Models.ReferralStats
     {
         DirectReferrals = GetSafeInt(reader, "DirectReferrals"),
         TotalTeam = GetSafeInt(reader, "TotalTeam"),
         TotalCommission = GetSafeDecimal(reader, "TotalCommission"),
         ThisMonthCommission = GetSafeDecimal(reader, "ThisMonthCommission"),
         TodayCommission = GetSafeDecimal(reader, "TodayCommission")
     },
     CreateParameter("@UserId", userId)
 );

            return results.Count > 0 ? results[0] : new Models.ReferralStats();
        }

        public List<LevelBreakdown> GetLevelBreakdown(int userId)
        {
            return ExecuteStoredProcedure<LevelBreakdown>(
                "usp_GetUserLevelBreakdown2",
                reader => new LevelBreakdown
                {
                    Level = GetSafeInt(reader, "Level"),
                    CommissionPercent = GetSafeDecimal(reader, "CommissionPercent"),
                    TeamCount = GetSafeInt(reader, "TeamCount"),
                    Earned = GetSafeDecimal(reader, "Earned"),
                   IsEligible = GetSafeBool(reader, "IsEligible")
                },
                CreateParameter("@UserId", userId)

               
                

            );
        }

        public List<Models.TeamMember> GetUserTeam(int userId, int count)
        {
            return ExecuteStoredProcedure<Models.TeamMember>(
                "usp_GetUserTeamMembers",
                reader => new Models.TeamMember
                {
                    UserId = GetSafeInt(reader, "UserId"),
                    Name = GetSafeString(reader, "Name") ?? "Unknown",
                    PhotoUrl = GetSafeString(reader, "PhotoUrl") ?? "",
                    Level = GetSafeInt(reader, "Level"),
                    InvestedAmount = GetSafeDecimal(reader, "InvestedAmount"),
                    YourEarnings = GetSafeDecimal(reader, "YourEarnings"),
                    IsActive = GetSafeBool(reader, "IsActive"),
                    JoinDate = GetSafeDateTime(reader, "JoinDate")
                },
                CreateParameter("@UserId", userId),
                CreateParameter("@Count", count)
            );
        }

        public List<CommissionHistory> GetRecentCommissions(int userId, int count)
        {
            return ExecuteStoredProcedure<CommissionHistory>(
                "usp_GetUserRecentCommissions",
                reader => new CommissionHistory
                {
                    CommissionId = GetSafeLong(reader, "CommissionId"),
                    Level = GetSafeInt(reader, "Level"),
                    ReferralName = GetSafeString(reader, "ReferralName") ?? "Anonymous",
                    Amount = GetSafeDecimal(reader, "Amount"),
                    SourceType = GetSafeString(reader, "SourceType") ?? "Staking",
                    CreatedDate = GetSafeDateTime(reader, "CreatedDate")
                },
                CreateParameter("@UserId", userId),
                CreateParameter("@Count", count)
            );
        }

        public List<CommissionHistory> GetCommissionHistory(int userId, int count)
        {
            return GetRecentCommissions(userId, count);
        }



        //public UserRankInfo GetUserRank(int userId)
        //{
        //    return ExecuteStoredProcedure<UserRankInfo>(
        //        "usp_GetUserRank",
        //        reader => new UserRankInfo
        //        {
        //            UserId = GetSafeInt(reader, "UserId"),
        //            UserName = GetSafeString(reader, "UserName") ?? "",

        //    // Numeric values
        //    DirectReferrals = GetSafeInt(reader, "DirectReferrals"),
        //            TeamSize = GetSafeInt(reader, "TeamSize"),
        //            PersonalInvestment = GetSafeDecimal(reader, "PersonalInvestment"),
        //            TotalCommission = GetSafeDecimal(reader, "TotalCommission"),
        //            MonthCommission = GetSafeDecimal(reader, "MonthCommission"),

        //    // Current rank
        //    CurrentRankLevel = GetSafeInt(reader, "CurrentRankLevel"),
        //            CurrentRankName = GetSafeString(reader, "CurrentRankName") ?? "",
        //            CurrentRankIcon = GetSafeString(reader, "CurrentRankIcon") ?? "",
        //            CurrentRankColor = GetSafeString(reader, "CurrentRankColor") ?? "",
        //            CurrentCommissionRate = GetSafeDecimal(reader, "CurrentCommissionRate"),

        //    // Next rank
        //    NextRankLevel = GetSafeInt(reader, "NextRankLevel"),
        //            NextRankName = GetSafeString(reader, "NextRankName") ?? "",
        //            NextRankDirectRequired = GetSafeInt(reader, "NextRankDirectRequired"),
        //            NextRankTeamRequired = GetSafeInt(reader, "NextRankTeamRequired"),

        //    // Progress percentages (numeric)
        //    DirectProgressPercent = GetSafeDecimal(reader, "DirectProgressPercent"),
        //            TeamProgressPercent = GetSafeDecimal(reader, "TeamProgressPercent"),

        //    // ❌ REMOVED: DirectProgressText and TeamProgressText

        //    HasNextRank = GetSafeBool(reader, "HasNextRank")
        //        },
        //        CreateParameter("@UserId", userId)
        //    );
        //}


        //public UserRankInfo GetUserRank(int userId)
        //{
        //    var result = new UserRankInfo();

        //    try
        //    {
        //        using (var conn = ConnectionManager.GetConnection())
        //        using (var cmd = new SqlCommand("usp_GetUserRank", conn))
        //        {
        //            cmd.CommandType = CommandType.StoredProcedure;
        //            cmd.Parameters.AddWithValue("@UserId", userId);

        //            conn.Open();
        //            using (var reader = cmd.ExecuteReader())
        //            {
        //                if (reader.Read())
        //                {
        //                    UserId = GetSafeInt(reader, "UserId"),
        //                   UserName = GetSafeString(reader, "UserName") ?? "",
            
        //    // Numeric values
        //    DirectReferrals = GetSafeInt(reader, "DirectReferrals"),
        //    TeamSize = GetSafeInt(reader, "TeamSize"),
        //    PersonalInvestment = GetSafeDecimal(reader, "PersonalInvestment"),
        //    TotalCommission = GetSafeDecimal(reader, "TotalCommission"),
        //    MonthCommission = GetSafeDecimal(reader, "MonthCommission"),
            
        //    // Current rank
        //    CurrentRankLevel = GetSafeInt(reader, "CurrentRankLevel"),
        //    CurrentRankName = GetSafeString(reader, "CurrentRankName") ?? "",
        //    CurrentRankIcon = GetSafeString(reader, "CurrentRankIcon") ?? "",
        //    CurrentRankColor = GetSafeString(reader, "CurrentRankColor") ?? "",
        //    CurrentCommissionRate = GetSafeDecimal(reader, "CurrentCommissionRate"),
            
        //    // Next rank
        //    NextRankLevel = GetSafeInt(reader, "NextRankLevel"),
        //    NextRankName = GetSafeString(reader, "NextRankName") ?? "",
        //    NextRankDirectRequired = GetSafeInt(reader, "NextRankDirectRequired"),
        //    NextRankTeamRequired = GetSafeInt(reader, "NextRankTeamRequired"),
            
        //    DirectProgressPercent = GetSafeDecimal(reader, "DirectProgressPercent"),
        //    TeamProgressPercent = GetSafeDecimal(reader, "TeamProgressPercent"),
            
            
        //    HasNextRank = GetSafeBool(reader, "HasNextRank"),
        //                    UserId = GetSafeInt(reader, "UserId"),
        //    UserName = GetSafeString(reader, "UserName") ?? "",
            
        //    // Numeric values
        //    DirectReferrals = GetSafeInt(reader, "DirectReferrals"),
        //    TeamSize = GetSafeInt(reader, "TeamSize"),
        //    PersonalInvestment = GetSafeDecimal(reader, "PersonalInvestment"),
        //    TotalCommission = GetSafeDecimal(reader, "TotalCommission"),
        //    MonthCommission = GetSafeDecimal(reader, "MonthCommission"),
            
        //    // Current rank
        //    CurrentRankLevel = GetSafeInt(reader, "CurrentRankLevel"),
        //    CurrentRankName = GetSafeString(reader, "CurrentRankName") ?? "",
        //    CurrentRankIcon = GetSafeString(reader, "CurrentRankIcon") ?? "",
        //    CurrentRankColor = GetSafeString(reader, "CurrentRankColor") ?? "",
        //    CurrentCommissionRate = GetSafeDecimal(reader, "CurrentCommissionRate"),
            
        //    // Next rank
        //    NextRankLevel = GetSafeInt(reader, "NextRankLevel"),
        //    NextRankName = GetSafeString(reader, "NextRankName") ?? "",
        //    NextRankDirectRequired = GetSafeInt(reader, "NextRankDirectRequired"),
        //    NextRankTeamRequired = GetSafeInt(reader, "NextRankTeamRequired"),
            
        //    // Progress percentages (numeric)
        //    DirectProgressPercent = GetSafeDecimal(reader, "DirectProgressPercent"),
        //    TeamProgressPercent = GetSafeDecimal(reader, "TeamProgressPercent"),
            
           
        //    HasNextRank = GetSafeBool(reader, "HasNextRank")
        //                }
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Logger.Error($"Failed to get user rank for User {userId}", ex);
        //    }

        //    return result;
        //}

        //public UserRank GetUserRank(int userId)
        //{
        //    var results = ExecuteStoredProcedure<UserRank>(
        //        "usp_GetUserRank",
        //        reader => new UserRank
        //        {
        //            RankName = GetSafeString(reader, "RankName") ?? "Bronze",
        //            RankClass = GetSafeString(reader, "RankClass") ?? "bronze",
        //            RankIcon = GetSafeString(reader, "RankIcon") ?? "fas fa-medal",
        //            Requirement = GetSafeString(reader, "Requirement") ?? "",
        //            ProgressPercent = GetSafeDecimal(reader, "ProgressPercent"),
        //            ProgressText = GetSafeString(reader, "ProgressText") ?? "",
        //            MonthlyBonus = GetSafeDecimal(reader, "MonthlyBonus")
        //        },
        //        CreateParameter("@UserId", userId)
        //    );
        //    return results.Count > 0 ? results[0] : new UserRank();
        //}

        public string GetUserReferralCode(int userId)
        {
            var result = ExecuteStoredProcedureScalar<string>(
                "usp_GetUserReferralCode",
                CreateParameter("@UserId", userId)
            );
            return result;
        }

        public string GenerateReferralCode(int userId)
        {
            string code = "REF" + userId.ToString().PadLeft(6, '0').ToUpper();
            ExecuteStoredProcedureNonQuery(
                "usp_UpdateUserReferralCode",
                CreateParameter("@UserId", userId),
                CreateParameter("@ReferralCode", code)
            );
            return code;
        }
    }
}