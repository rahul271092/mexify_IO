using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Mexify.Web.Models;

namespace Mexify.DataAccess.Repositories
{
    public class PortfolioRepository : BaseRepository
    {
        public PortfolioSummary GetPortfolioSummary(int userId)
        {
            var results = ExecuteStoredProcedure<PortfolioSummary>(
                "usp_GetPortfolioSummary",
                reader => new PortfolioSummary
                {
                    TotalValue = GetSafeDecimal(reader, "TotalValue"),
                    TotalInvested = GetSafeDecimal(reader, "TotalInvested"),
                    TotalEarnings = GetSafeDecimal(reader, "TotalEarnings"),
                    ActiveInvestments = GetSafeInt(reader, "ActiveInvestments"),
                    DailyIncome = GetSafeDecimal(reader, "DailyIncome"),
                    OverallROI = GetSafeDecimal(reader, "OverallROI"),
                    ChangePercent = GetSafeDecimal(reader, "ChangePercent"),
                    ChangeAmount = GetSafeDecimal(reader, "ChangeAmount")
                },
                CreateParameter("@UserId", userId)
            );
            return results.Count > 0 ? results[0] : new PortfolioSummary();
        }

        public List<WalletHolding> GetWalletHoldings(int userId)
        {
            return ExecuteStoredProcedure<WalletHolding>(
                "usp_GetWalletHoldings",
                reader => new WalletHolding
                {
                    WalletId = GetSafeInt(reader, "WalletId"),
                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "PNC",
                    CurrencyName = GetSafeString(reader, "CurrencyName") ?? "Pinnacle",
                    Balance = GetSafeDecimal(reader, "Balance"),
                    AvailableBalance = GetSafeDecimal(reader, "AvailableBalance"),
                    LockedBalance = GetSafeDecimal(reader, "LockedBalance"),
                    ValuePNC = GetSafeDecimal(reader, "ValuePNC"),
                    AllocationPercent = GetSafeDecimal(reader, "AllocationPercent")
                },
                CreateParameter("@UserId", userId)
            );
        }

        public List<PortfolioHolding> GetHoldings(int userId)
        {
            return ExecuteStoredProcedure<PortfolioHolding>(
                "usp_GetPortfolioHoldings",
                reader => new PortfolioHolding
                {
                    Id = Convert.ToInt64(reader["Id"]),
                    Name = GetSafeString(reader, "Name") ?? "Investment",
                    TypeName = GetSafeString(reader, "TypeName") ?? "ROI Plan",
                    TypeClass = GetSafeString(reader, "TypeClass") ?? "roi",
                    Icon = GetSafeString(reader, "Icon") ?? "fas fa-chart-line",
                    Invested = GetSafeDecimal(reader, "Invested"),
                    Value = GetSafeDecimal(reader, "Value"),
                    Earned = GetSafeDecimal(reader, "Earned"),
                    DailyIncome = GetSafeDecimal(reader, "DailyIncome"),
                    ChangePercent = GetSafeDecimal(reader, "ChangePercent"),
                    Status = GetSafeString(reader, "Status") ?? "Active",
                    Progress = GetSafeInt(reader, "Progress"),
                    CurrentDay = GetSafeInt(reader, "CurrentDay"),
                    TotalDays = GetSafeInt(reader, "TotalDays")
                },
                CreateParameter("@UserId", userId)
            );
        }

        public List<PerformancePoint> GetPerformanceHistory(int userId, int days)
        {
            return ExecuteStoredProcedure<PerformancePoint>(
                "usp_GetPortfolioPerformance",
                reader => new PerformancePoint
                {
                    Date = GetSafeDateTime(reader, "Date"),
                    Value = GetSafeDecimal(reader, "Value")
                },
                CreateParameter("@UserId", userId),
                CreateParameter("@Days", days)
            );
        }
    }
}