using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Mexify.Models;

namespace Mexify.DataAccess.Repositories
{
    public class UserICORepository : BaseRepository
    {
        public UserICOSummary GetUserICOSummary(int userId)
        {
            var results = ExecuteStoredProcedure<UserICOSummary>(
                "usp_GetUserICOSummary",
                reader => new UserICOSummary
                {
                    TotalInvested = GetSafeDecimal(reader, "TotalInvested"),
                    TotalParticipations = GetSafeInt(reader, "TotalParticipations"),
                    ActiveProjects = GetSafeInt(reader, "ActiveProjects"),
                    TokensReceived = GetSafeDecimal(reader, "TokensReceived"),
                    TokensVesting = GetSafeDecimal(reader, "TokensVesting"),
                    TokensClaimed = GetSafeDecimal(reader, "TokensClaimed"),
                    CurrentROI = GetSafeDecimal(reader, "CurrentROI"),
                    TotalRefunded = GetSafeDecimal(reader, "TotalRefunded")
                },
                CreateParameter("@UserId", userId)
            );
            return results.Count > 0 ? results[0] : new UserICOSummary();
        }

        public List<ICOProject> GetLiveProjects(int count)
        {
            return ExecuteStoredProcedure<ICOProject>(
                "usp_GetLiveICOProjects",
                reader => MapICOProject(reader),
                CreateParameter("@Count", count)
            );
        }

        public List<ICOProject> GetActiveProjects()
        {
            return ExecuteStoredProcedure<ICOProject>(
                "usp_GetActiveICOProjects",
                reader => MapICOProject(reader)
            );
        }

        public List<ICOParticipation> GetUserParticipations(int userId)
        {
            return ExecuteStoredProcedure<ICOParticipation>(
                "usp_GetUserICOParticipations",
                reader => new ICOParticipation
                {
                    ParticipationId = GetSafeLong(reader, "ParticipationId"),
                    ICOProjectId = GetSafeInt(reader, "ICOProjectId"),
                    ProjectName = GetSafeString(reader, "ProjectName") ?? "ICO Project",
                    TokenSymbol = GetSafeString(reader, "TokenSymbol") ?? "TOKEN",
                    InvestedAmount = GetSafeDecimal(reader, "InvestedAmount"),
                    TokenPrice = GetSafeDecimal(reader, "TokenPrice"),
                    TokensAllocated = GetSafeDecimal(reader, "TokensAllocated"),
                    TokensReleased = GetSafeDecimal(reader, "TokensReleased"),
                    TokensVesting = GetSafeDecimal(reader, "TokensVesting"),
                    CurrentValue = GetSafeDecimal(reader, "CurrentValue"),
                    Status = GetSafeInt(reader, "Status"),
                    StatusName = GetSafeString(reader, "StatusName") ?? "Active",
                    ParticipatedDate = GetSafeDateTime(reader, "ParticipatedDate"),
                    VestingSchedule = new List<VestingScheduleItem>()
                },
                CreateParameter("@UserId", userId)
            );
        }

        public List<ICOTokenHistory> GetUserTokenHistory(int userId, int count)
        {
            return ExecuteStoredProcedure<ICOTokenHistory>(
                "usp_GetUserICOTokenHistory",
                reader => new ICOTokenHistory
                {
                    HistoryId = GetSafeLong(reader, "HistoryId"),
                    ProjectName = GetSafeString(reader, "ProjectName") ?? "ICO",
                    TokenType = GetSafeString(reader, "TokenType") ?? "Distribution",
                    TokenSymbol = GetSafeString(reader, "TokenSymbol") ?? "TOKEN",
                    Amount = GetSafeDecimal(reader, "Amount"),
                    DistributedDate = GetSafeDateTime(reader, "DistributedDate")
                },
                CreateParameter("@UserId", userId),
                CreateParameter("@Count", count)
            );
        }

        public List<ICOPerformancePoint> GetPerformanceHistory(int userId, int days)
        {
            return ExecuteStoredProcedure<ICOPerformancePoint>(
                "usp_GetUserICOPerformanceHistory",
                reader => new ICOPerformancePoint
                {
                    Date = GetSafeDateTime(reader, "Date"),
                    Value = GetSafeDecimal(reader, "Value")
                },
                CreateParameter("@UserId", userId),
                CreateParameter("@Days", days)
            );
        }

        public List<ICODistributionItem> GetPortfolioDistribution(int userId)
        {
            return ExecuteStoredProcedure<ICODistributionItem>(
                "usp_GetUserICOPortfolioDistribution",
                reader => new ICODistributionItem
                {
                    Name = GetSafeString(reader, "Name") ?? "Unknown",
                    Value = GetSafeDecimal(reader, "Value")
                },
                CreateParameter("@UserId", userId)
            );
        }

        private ICOProject MapICOProject(SqlDataReader reader)
        {
            return new ICOProject
            {
                ICOProjectId = GetSafeInt(reader, "ICOProjectId"),
                ProjectName = GetSafeString(reader, "ProjectName") ?? "ICO Project",
                Category = GetSafeString(reader, "Category") ?? "Blockchain",
                ImageUrl = GetSafeString(reader, "ImageUrl") ?? "",
                TokenSymbol = GetSafeString(reader, "TokenSymbol") ?? "TOKEN",
                TokenPrice = GetSafeDecimal(reader, "TokenPrice"),
                MinInvestment = GetSafeDecimal(reader, "MinInvestment"),
                HardCap = GetSafeDecimal(reader, "HardCap"),
                RaisedAmount = GetSafeDecimal(reader, "RaisedAmount"),
                FundingPercent = GetSafeDecimal(reader, "FundingPercent"),
                TotalSupplyFormatted = GetSafeString(reader, "TotalSupplyFormatted") ?? "1,000,000",
                VestingPeriod = GetSafeString(reader, "VestingPeriod") ?? "6 months",
                IsHot = GetSafeBool(reader, "IsHot"),
                StatusClass = GetSafeString(reader, "StatusClass") ?? "status-live",
                StatusName = GetSafeString(reader, "StatusName") ?? "Live",
                EndDate = GetSafeDateTime(reader, "EndDate"),
                EndDateIso = GetSafeString(reader, "EndDateIso")
            };
        }
    }
}