using System;
using System.Collections.Generic;
using System.Data.SqlClient;

using Mexify.Utilities;
using System.Data;
using Mexify.Web.Models;

namespace Mexify.DataAccess.Repositories
{
    public class PortfolioRepository : BaseRepository
    {

        public PortfolioHoldingsResult GetPortfolioHoldings(
            int userId,
            string holdingType = null,
            string statusFilter = null,
            string sortBy = "value_desc",
            int pageNumber = 1,
            int pageSize = 20)
        {
            var result = new PortfolioHoldingsResult
            {
                PageNumber = pageNumber,
                PageSize = pageSize
            };

            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_GetPortfolioHoldings", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@HoldingType", string.IsNullOrEmpty(holdingType) || holdingType == "all" ? (object)DBNull.Value : holdingType);
                    cmd.Parameters.AddWithValue("@StatusFilter", string.IsNullOrEmpty(statusFilter) || statusFilter == "all" ? (object)DBNull.Value : statusFilter);
                    cmd.Parameters.AddWithValue("@SortBy", sortBy);
                    cmd.Parameters.AddWithValue("@PageNumber", pageNumber);
                    cmd.Parameters.AddWithValue("@PageSize", pageSize);

                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        // Result Set 1: Summary
                        if (reader.Read())
                        {
                            result.Summary = new PortfolioHoldingsSummary
                            {
                                TotalInvested = GetSafeDecimal(reader, "TotalInvested"),
                                TotalCurrentValue = GetSafeDecimal(reader, "TotalCurrentValue"),
                                TotalProfitLoss = GetSafeDecimal(reader, "TotalProfitLoss"),
                                OverallROI = GetSafeDecimal(reader, "OverallROI"),
                                TotalHoldings = GetSafeInt(reader, "TotalHoldings"),
                                ActiveCount = GetSafeInt(reader, "ActiveCount"),
                                InvestmentValue = GetSafeDecimal(reader, "InvestmentValue"),
                                MiningValue = GetSafeDecimal(reader, "MiningValue"),
                                StakingValue = GetSafeDecimal(reader, "StakingValue"),
                                LicenseValue = GetSafeDecimal(reader, "LicenseValue"),
                                NFTValue = GetSafeDecimal(reader, "NFTValue"),
                                CashValue = GetSafeDecimal(reader, "CashValue")
                            };
                        }

                        // Result Set 2: Holdings List
                        if (reader.NextResult())
                        {
                            while (reader.Read())
                            {
                                result.Holdings.Add(new PortfolioHolding
                                {
                                    HoldingId = GetSafeLong(reader, "HoldingId"),
                                    HoldingType = GetSafeString(reader, "HoldingType") ?? "",
                                    HoldingName = GetSafeString(reader, "HoldingName") ?? "",
                                    SubTitle = GetSafeString(reader, "SubTitle") ?? "",
                                    InvestedAmount = GetSafeDecimal(reader, "InvestedAmount"),
                                    CurrentValue = GetSafeDecimal(reader, "CurrentValue"),
                                    ProfitLoss = GetSafeDecimal(reader, "ProfitLoss"),
                                    ROIPercent = GetSafeDecimal(reader, "ROIPercent"),
                                  //  Status = GetSafeInt(reader, "Status"),
                                    StatusName = GetSafeString(reader, "StatusName") ?? "",
                                    StartDate = reader["StartDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["StartDate"]),
                                    EndDate = reader["EndDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["EndDate"]),
                                    IconClass = GetSafeString(reader, "IconClass") ?? "fas fa-circle",
                                    ColorClass = GetSafeString(reader, "ColorClass") ?? "muted",
                                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "PNC"
                                });
                            }
                        }

                        // Result Set 3: Total Count
                        if (reader.NextResult() && reader.Read())
                        {
                            result.TotalCount = GetSafeInt(reader, "TotalCount");
                        }

                        // Result Set 4: Allocation Breakdown
                        if (reader.NextResult())
                        {
                            while (reader.Read())
                            {
                                result.Allocations.Add(new PortfolioAllocation
                                {
                                    CategoryName = GetSafeString(reader, "CategoryName") ?? "",
                                    CategorySlug = GetSafeString(reader, "CategorySlug") ?? "",
                                    CategoryValue = GetSafeDecimal(reader, "CategoryValue"),
                                    AllocationPercent = GetSafeDecimal(reader, "AllocationPercent")
                                });
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Error($"Failed to get portfolio holdings for User {userId}", ex);
            }

            return result;
        }

        public PortfolioSummary GetPortfolioSummary(int userId)
        {
            var summary = new PortfolioSummary();

            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_GetPortfolioSummary", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            summary.TotalWalletBalance = GetSafeDecimal(reader, "TotalWalletBalance");
                            summary.TotalInvested = GetSafeDecimal(reader, "TotalInvested");
                            summary.TotalEarnings = GetSafeDecimal(reader, "TotalEarnings");
                            summary.TotalWithdrawn = GetSafeDecimal(reader, "TotalWithdrawn");
                            summary.TotalDeposited = GetSafeDecimal(reader, "TotalDeposited");
                          //  summary.NetWorth = GetSafeDecimal(reader, "NetWorth");
                            summary.ProfitLoss = GetSafeDecimal(reader, "ProfitLoss");
                            summary.TodayEarnings = GetSafeDecimal(reader, "TodayEarnings");
                            summary.MonthEarnings = GetSafeDecimal(reader, "MonthEarnings");
                            summary.ActiveInvestments = GetSafeInt(reader, "ActiveInvestments");  // ✅ Use GetSafeInt for counts
                            summary.TotalReferrals = GetSafeInt(reader, "TotalReferrals");
                            summary.USDEquivalent = GetSafeDecimal(reader, "USDEquivalent");
                            summary.ROIPercent = GetSafeDecimal(reader, "ROIPercent");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Error($"Failed to get portfolio summary for User {userId}", ex);
            }

            return summary;
        }

        //public PortfolioSummary GetPortfolioSummary(int userId)
        //{
        //    var results = ExecuteStoredProcedure<PortfolioSummary>(
        //        "usp_GetPortfolioSummary",
        //        reader => new PortfolioSummary
        //        {
        //            TotalValue = GetSafeDecimal(reader, "TotalValue"),
        //            TotalInvested = GetSafeDecimal(reader, "TotalInvested"),
        //            TotalEarnings = GetSafeDecimal(reader, "TotalEarnings"),
        //            ActiveInvestments = GetSafeInt(reader, "ActiveInvestments"),
        //            DailyIncome = GetSafeDecimal(reader, "DailyIncome"),
        //            OverallROI = GetSafeDecimal(reader, "OverallROI"),
        //            ChangePercent = GetSafeDecimal(reader, "ChangePercent"),
        //            ChangeAmount = GetSafeDecimal(reader, "ChangeAmount")
        //        },
        //        CreateParameter("@UserId", userId)
        //    );
        //    return results.Count > 0 ? results[0] : new PortfolioSummary();
        //}


        public PortfolioViewModel GetUserPortfolioHistory(int userId, string timeframe = "30d")
        {
            var model = new PortfolioViewModel();

            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_GetUserPortfolioHistory", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@Timeframe", timeframe);

                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        // Result Set 1: Summary Stats
                        if (reader.Read())
                        {
                            model.Summary = new PortfolioSummary
                            {
                                TotalWalletBalance = GetSafeDecimal(reader, "TotalWalletBalance"),
                                TotalInvested = GetSafeDecimal(reader, "TotalInvested"),
                                TotalEarnings = GetSafeDecimal(reader, "TotalEarnings"),
                                //TotalWithdrawn = GetSafeDecimal(reader, "TotalWithdrawn"),
                                TotalDeposited = GetSafeDecimal(reader, "TotalDeposited"),
                                ActiveInvestments=GetSafeInt(reader,"ActiveInvestments"),
                                TodayProfit=GetSafeDecimal(reader,"TodayProfit")
                            };
                        }

                        // Result Set 2: Daily History
                        if (reader.NextResult())
                        {
                            while (reader.Read())
                            {
                                model.History.Add(new PortfolioHistoryPoint
                                {
                                    Date = GetSafeDateTime(reader, "Date"),
                                    Inflow = GetSafeDecimal(reader, "Inflow"),
                                    Outflow = GetSafeDecimal(reader, "Outflow")
                                });
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Error($"Failed to get portfolio history for User {userId}", ex);
            }

            return model;
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
                    Status = GetSafeInt(reader, "Status"),
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