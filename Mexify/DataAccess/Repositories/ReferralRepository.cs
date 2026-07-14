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


        public Models.ReferralStats GetUserReferralStats(int userId)
        {
            var results = ExecuteStoredProcedure<Models.ReferralStats>(
                "usp_GetUserReferralStats",
                reader => new Models.ReferralStats
                {
                    DirectReferrals = GetSafeInt(reader, "DirectReferrals"),
                    TotalTeam = GetSafeInt(reader, "TotalTeam"),
                    TotalCommission = GetSafeDecimal(reader, "TotalCommission"),
                 //   ThisMonthCommission = GetSafeDecimal(reader, "ThisMonthCommission"),
                  //  TodayCommission = GetSafeDecimal(reader, "TodayCommission")
                },
                CreateParameter("@UserId", userId)
            );
            return results.Count > 0 ? results[0] : new Models.ReferralStats();
        }

        public List<LevelBreakdown> GetLevelBreakdown(int userId)
        {
            return ExecuteStoredProcedure<LevelBreakdown>(
                "usp_GetUserLevelBreakdown",
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


        public UserRankInfo GetUserRank(int userId)
        {
            var result = new UserRankInfo();

            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_GetUserRank", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            result.UserId = GetSafeInt(reader, "UserId");
                            result.UserName = GetSafeString(reader, "UserName") ?? "";

                            // ✅ Numeric columns use GetSafeInt/GetSafeDecimal
                            result.DirectReferrals = GetSafeInt(reader, "DirectReferrals");
                            result.TeamSize = GetSafeInt(reader, "TeamSize");
                            result.PersonalInvestment = GetSafeDecimal(reader, "PersonalInvestment");
                            result.TotalCommission = GetSafeDecimal(reader, "TotalCommission");
                            result.MonthCommission = GetSafeDecimal(reader, "MonthCommission");

                            result.CurrentRankLevel = GetSafeInt(reader, "CurrentRankLevel");
                            result.CurrentRankName = GetSafeString(reader, "CurrentRankName") ?? "";
                            result.CurrentRankIcon = GetSafeString(reader, "CurrentRankIcon") ?? "";
                            result.CurrentRankColor = GetSafeString(reader, "CurrentRankColor") ?? "";
                            result.CurrentCommissionRate = GetSafeDecimal(reader, "CurrentCommissionRate");

                            result.NextRankLevel = GetSafeInt(reader, "NextRankLevel");
                            result.NextRankName = GetSafeString(reader, "NextRankName") ?? "";
                            result.NextRankDirectRequired = GetSafeInt(reader, "NextRankDirectRequired");
                            result.NextRankTeamRequired = GetSafeInt(reader, "NextRankTeamRequired");

                            result.DirectProgressPercent = GetSafeDecimal(reader, "DirectProgressPercent");
                            result.TeamProgressPercent = GetSafeDecimal(reader, "TeamProgressPercent");

                            // ✅ Display strings use GetSafeString
                            result.DirectProgressText = GetSafeString(reader, "DirectProgressText") ?? "";
                            result.TeamProgressText = GetSafeString(reader, "TeamProgressText") ?? "";

                            result.HasNextRank = GetSafeBool(reader, "HasNextRank");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Error($"Failed to get user rank for User {userId}", ex);
            }

            return result;
        }

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