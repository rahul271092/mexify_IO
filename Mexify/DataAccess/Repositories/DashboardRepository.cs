using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Mexify.Web.Models;

namespace Mexify.DataAccess.Repositories
{
    public class DashboardRepository : BaseRepository
    {
        public PortfolioStats GetPortfolioStats(int userId)
        {
            var results = ExecuteStoredProcedure<PortfolioStats>(
                "usp_GetUserPortfolioStats",
                reader => new PortfolioStats
                {
                    TotalBalance = GetSafeDecimal(reader, "TotalBalance"),
                    TotalInvested = GetSafeDecimal(reader, "TotalInvested"),
                    TotalEarnings = GetSafeDecimal(reader, "TotalEarnings"),
                    TodayProfit = GetSafeDecimal(reader, "TodayProfit"),
                    TotalWithdrawn = GetSafeDecimal(reader, "TotalWithdrawn")
                },
                CreateParameter("@UserId", userId)
            );
            return results.Count > 0 ? results[0] : new PortfolioStats();
        }

        public List<WalletSummary> GetUserWallets(int userId)
        {
            return ExecuteStoredProcedure<WalletSummary>(
                "usp_GetUserWallets",
                reader => new WalletSummary
                {
                    WalletId = GetSafeInt(reader, "WalletId"),
                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "USDT",
                    CurrencyName = GetSafeString(reader, "CurrencyName") ?? "Pinnacle",
                    Balance = GetSafeDecimal(reader, "Balance"),
                    LockedBalance = GetSafeDecimal(reader, "LockedBalance"),
                    ValuePNC = GetSafeDecimal(reader, "ValuePNC")
                },
                CreateParameter("@UserId", userId)
            );
        }

        public List<ActiveInvestment> GetActiveInvestments(int userId)
        {
            return ExecuteStoredProcedure<ActiveInvestment>(
                "usp_GetUserActiveInvestments",
                reader => new ActiveInvestment
                {
                    InvestmentId = Convert.ToInt64(reader["InvestmentId"]),
                    PlanName = GetSafeString(reader, "PlanName") ?? "Investment",
                    InvestedAmount = GetSafeDecimal(reader, "InvestedAmount"),
                    DailyROI = GetSafeDecimal(reader, "DailyROI"),
                    TotalEarned = GetSafeDecimal(reader, "TotalEarned"),
                    CurrentDay = GetSafeInt(reader, "CurrentDay"),
                    TotalDays = GetSafeInt(reader, "TotalDays"),
                    ProgressPercent = GetSafeDecimal(reader, "ProgressPercent"),
                    Status = GetSafeInt(reader, "Status"),
                    StartDate = GetSafeDateTime(reader, "StartDate"),
                    EndDate = GetSafeDateTime(reader, "EndDate")
                },
                CreateParameter("@UserId", userId)
            );
        }

        public List<RecentTransaction> GetRecentTransactions(int userId, int count)
        {
            return ExecuteStoredProcedure<RecentTransaction>(
                "usp_GetUserRecentTransactions",
                reader => new RecentTransaction
                {
                    TransactionId = Convert.ToInt64(reader["TransactionId"]),
                    TransactionType = GetSafeInt(reader, "TransactionType"),
                    Title = GetSafeString(reader, "Title") ?? "Transaction",
                    Amount = GetSafeDecimal(reader, "Amount"),
                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "USDT",
                    CreatedDate = GetSafeDateTime(reader, "CreatedDate"),
                    DateFormatted = GetSafeDateTime(reader, "CreatedDate").ToString("MMM dd, HH:mm")
                },
                CreateParameter("@UserId", userId),
                CreateParameter("@Count", count)
            );
        }

        public ReferralStats GetReferralStats(int userId)
        {
            var results = ExecuteStoredProcedure<ReferralStats>(
                "usp_GetUserReferralStats",
                reader => new ReferralStats
                {
                    DirectReferrals = GetSafeInt(reader, "DirectReferrals"),
                    TotalTeam = GetSafeInt(reader, "TotalTeam"),
                    TotalCommission = GetSafeDecimal(reader, "TotalCommission"),
                    ThisMonthCommission = GetSafeDecimal(reader, "ThisMonthCommission")
                },
                CreateParameter("@UserId", userId)
            );
            return results.Count > 0 ? results[0] : new ReferralStats();
        }

        public List<PortfolioPoint> GetPortfolioHistory(int userId, int days)
        {
            return ExecuteStoredProcedure<PortfolioPoint>(
                "usp_GetUserPortfolioHistory",
                reader => new PortfolioPoint
                {
                    Date = GetSafeDateTime(reader, "Date"),
                    Value = GetSafeDecimal(reader, "Value")
                },
                CreateParameter("@UserId", userId),
                CreateParameter("@Days", days)
            );
        }

        public EarningsBreakdown GetEarningsBreakdown(int userId)
        {
            var results = ExecuteStoredProcedure<EarningsBreakdown>(
                "usp_GetUserEarningsBreakdown",
                reader => new EarningsBreakdown
                {
                    ROI = GetSafeDecimal(reader, "ROI"),
                    Staking = GetSafeDecimal(reader, "Staking"),
                    Mining = GetSafeDecimal(reader, "Mining"),
                    Referrals = GetSafeDecimal(reader, "Referrals"),
                    Royalties = GetSafeDecimal(reader, "Royalties")
                },
                CreateParameter("@UserId", userId)
            );
            return results.Count > 0 ? results[0] : new EarningsBreakdown();
        }
    }
}