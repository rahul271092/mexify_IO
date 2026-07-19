using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

using Mexify.Utilities;
using Mexify.Models;

namespace Mexify.DataAccess.Repositories
{
    public class ICORepository : BaseRepository
    {
        public List<ICOProject> GetActiveICOs()
        {
            try
            {
                return ExecuteStoredProcedure<Models.ICOProject>(
                    "usp_GetActiveICO",
                    reader => new ICOProject
                    {
                        ICOId = GetSafeInt(reader, "ICOId"),
                        ProjectName = GetSafeString(reader, "ProjectName") ?? "",
                        TokenSymbol = GetSafeString(reader, "TokenSymbol") ?? "PNC",
                        TokenName = GetSafeString(reader, "ProjectName") ?? "PNC Token",
                        TotalSupply = GetSafeDecimal(reader, "TotalSupply"),
                        TokensSold = GetSafeDecimal(reader, "TokensSold"),
                        TokensRemaining = GetSafeDecimal(reader, "TokensRemaining"),
                        PricePerToken = GetSafeDecimal(reader, "PricePerToken"),
                        CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "USDT",
                        MinPurchase = GetSafeDecimal(reader, "MinPurchase"),
                        MaxPurchase = GetSafeDecimal(reader,"MaxPurchase"),
                        SoftCap = 0,
                        SoftCapFormatted = "0 USDT",
                        HardCap = GetSafeDecimal(reader, "TotalSupply") * GetSafeDecimal(reader, "PricePerToken"),
                        HardCapFormatted = (GetSafeDecimal(reader, "TotalSupply") * GetSafeDecimal(reader, "PricePerToken")).ToString("N0") + " USDT",
                        RaisedAmount = GetSafeDecimal(reader, "TokensSold") * GetSafeDecimal(reader, "PricePerToken"),
                        RaisedFormatted = (GetSafeDecimal(reader, "TokensSold") * GetSafeDecimal(reader, "PricePerToken")).ToString("N0") + " USDT",
                        StartDate = GetSafeDateTime(reader, "StartDate"),
                        EndDate = GetSafeDateTime(reader, "EndDate"),
                        Status = GetSafeInt(reader, "Status"),
                        Description = GetSafeString(reader, "Description"),
                        ShortDescription = GetSafeString(reader, "Description"),
                        LogoUrl = "",
                        BannerUrl = "",
                        ProgressPercent = GetSafeDecimal(reader, "ProgressPercent"),
                        IsActive = GetSafeBool(reader, "IsActive"),
                        CreatedDate = GetSafeDateTime(reader, "CreatedDate")
                    }
                );
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get active ICOs", ex);
                return new List<Models.ICOProject>();
            }
        }



        // =========================================
        // GET ALL PROJECTS (Active + Inactive)
        // =========================================
        public List<ICOProject> GetAllProjects()
        {
            try
            {
                return ExecuteStoredProcedure<ICOProject>(
                    "usp_GetAllICOProjects",
                    reader => new ICOProject
                    {
                        ICOId = GetSafeInt(reader, "ICOId"),
                        ProjectName = GetSafeString(reader, "ProjectName") ?? "",
                        TokenSymbol = GetSafeString(reader, "TokenSymbol") ?? "PNC",
                        TokenName = GetSafeString(reader, "ProjectName") ?? "PNC Token",
                        TotalSupply = GetSafeDecimal(reader, "TotalSupply"),
                        TokensSold = GetSafeDecimal(reader, "TokensSold"),
                        TokensRemaining = GetSafeDecimal(reader, "TokensRemaining"),
                        PricePerToken = GetSafeDecimal(reader, "PricePerToken"),
                        CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "USDT",
                        MinPurchase = GetSafeDecimal(reader, "MinPurchase"),
                        MaxPurchase = reader["MaxPurchase"] == DBNull.Value ? (decimal?)null : Convert.ToDecimal(reader["MaxPurchase"]),
                        SoftCap = 0,
                        SoftCapFormatted = "0 USDT",
                        HardCap = GetSafeDecimal(reader, "TotalSupply") * GetSafeDecimal(reader, "PricePerToken"),
                        HardCapFormatted = (GetSafeDecimal(reader, "TotalSupply") * GetSafeDecimal(reader, "PricePerToken")).ToString("N0") + " USDT",
                        RaisedAmount = GetSafeDecimal(reader, "TokensSold") * GetSafeDecimal(reader, "PricePerToken"),
                        RaisedFormatted = (GetSafeDecimal(reader, "TokensSold") * GetSafeDecimal(reader, "PricePerToken")).ToString("N0") + " USDT",
                        StartDate = GetSafeDateTime(reader, "StartDate"),
                        EndDate = GetSafeDateTime(reader, "EndDate"),
                        Status = GetSafeInt(reader, "Status"),
                        Description = GetSafeString(reader, "Description"),
                        ShortDescription = GetSafeString(reader, "Description"),
                        LogoUrl = "",
                        BannerUrl = "",
                        ProgressPercent = GetSafeDecimal(reader, "ProgressPercent"),
                        IsActive = GetSafeBool(reader, "IsActive"),
                        CreatedDate = GetSafeDateTime(reader, "CreatedDate")
                    }
                );
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get all ICO projects", ex);
                return new List<ICOProject>();
            }
        }






        // =========================================
        // GET FEATURED PROJECTS (Active Only)
        // =========================================
        public List<ICOProject> GetFeaturedProjects()
        {
            try
            {
                return ExecuteStoredProcedure<ICOProject>(
                    "usp_GetFeaturedICOProjects",
                    reader => new ICOProject
                    {
                        ICOId = GetSafeInt(reader, "ICOId"),
                        ProjectName = GetSafeString(reader, "ProjectName") ?? "",
                        TokenSymbol = GetSafeString(reader, "TokenSymbol") ?? "PNC",
                        TokenName = GetSafeString(reader, "ProjectName") ?? "PNC Token",
                        TotalSupply = GetSafeDecimal(reader, "TotalSupply"),
                        TokensSold = GetSafeDecimal(reader, "TokensSold"),
                        TokensRemaining = GetSafeDecimal(reader, "TokensRemaining"),
                        PricePerToken = GetSafeDecimal(reader, "PricePerToken"),
                        CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "USDT",
                        MinPurchase = GetSafeDecimal(reader, "MinPurchase"),
                        MaxPurchase = reader["MaxPurchase"] == DBNull.Value ? (decimal?)null : Convert.ToDecimal(reader["MaxPurchase"]),
                        SoftCap = 0,
                        SoftCapFormatted = "0 USDT",
                        HardCap = GetSafeDecimal(reader, "TotalSupply") * GetSafeDecimal(reader, "PricePerToken"),
                        HardCapFormatted = (GetSafeDecimal(reader, "TotalSupply") * GetSafeDecimal(reader, "PricePerToken")).ToString("N0") + " USDT",
                        RaisedAmount = GetSafeDecimal(reader, "TokensSold") * GetSafeDecimal(reader, "PricePerToken"),
                        RaisedFormatted = (GetSafeDecimal(reader, "TokensSold") * GetSafeDecimal(reader, "PricePerToken")).ToString("N0") + " USDT",
                        StartDate = GetSafeDateTime(reader, "StartDate"),
                        EndDate = GetSafeDateTime(reader, "EndDate"),
                        Status = GetSafeInt(reader, "Status"),
                        Description = GetSafeString(reader, "Description"),
                        ShortDescription = GetSafeString(reader, "Description"),
                        LogoUrl = "",
                        BannerUrl = "",
                        ProgressPercent = GetSafeDecimal(reader, "ProgressPercent"),
                        IsActive = GetSafeBool(reader, "IsActive"),
                        CreatedDate = GetSafeDateTime(reader, "CreatedDate")
                    }
                );
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get featured ICO projects", ex);
                return new List<ICOProject>();
            }
        }
        public List<Models.ICOCommissionTier> GetCommissionTiers()
        {
            try
            {
                return ExecuteStoredProcedure<ICOCommissionTier>(
                    "usp_GetICOCommissionTiers",
                    reader => new ICOCommissionTier
                    {
                        Level = GetSafeInt(reader, "Level"),
                        CommissionPercent = GetSafeDecimal(reader, "CommissionPercent"),
                        RequiredDirects = GetSafeInt(reader, "RequiredDirects"),
                        IsActive = GetSafeBool(reader, "IsActive")
                    }
                );
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get commission tiers", ex);
                return new List<Models.ICOCommissionTier>();
            }
        }

        public ICOStats GetUserICOStats(int userId)
        {
            var stats = new ICOStats();

            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_GetUserICOStats", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    conn.Open();

                    using (var reader = cmd.ExecuteReader())
                    {
                        // Result Set 1: Summary
                        if (reader.Read())
                        {
                            stats.TotalTokensPurchased = GetSafeDecimal(reader, "TotalTokensPurchased");
                            stats.TotalInvested = GetSafeDecimal(reader, "TotalInvested");
                            stats.TotalCommissionEarned = GetSafeDecimal(reader, "TotalCommissionEarned");
                            stats.TotalPurchases = GetSafeInt(reader, "TotalPurchases");
                            stats.TotalCommissions = GetSafeInt(reader, "TotalCommissions");
                            stats.UniqueDownlines = GetSafeInt(reader, "UniqueDownlines");
                            stats.DirectReferrals = GetSafeInt(reader, "DirectReferrals");
                        }

                        // Result Set 2: Level breakdown
                        if (reader.NextResult())
                        {
                            while (reader.Read())
                            {
                                stats.LevelBreakdown.Add(new ICOCommissionLevelSummary
                                {
                                    Level = GetSafeInt(reader, "Level"),
                                    CommissionPercent = GetSafeDecimal(reader, "CommissionPercent"),
                                    RequiredDirects = GetSafeInt(reader, "RequiredDirects"),
                                    TimesEarned = GetSafeInt(reader, "TimesEarned"),
                                    LevelTotal = GetSafeDecimal(reader, "LevelTotal"),
                                    CurrentDirects = GetSafeInt(reader, "CurrentDirects"),
                                    IsQualified = GetSafeBool(reader, "IsQualified")
                                });
                            }
                        }

                        // Result Set 3: Recent purchases
                        if (reader.NextResult())
                        {
                            while (reader.Read())
                            {
                                stats.RecentPurchases.Add(new ICOPurchase
                                {
                                    PurchaseId = GetSafeLong(reader, "PurchaseId"),
                                    TokensPurchased = GetSafeDecimal(reader, "TokensPurchased"),
                                    AmountPaid = GetSafeDecimal(reader, "AmountPaid"),
                                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "USDT",
                                    PricePerToken = GetSafeDecimal(reader, "PricePerToken"),
                                    TxHash = GetSafeString(reader, "TxHash"),
                                    PurchaseDate = GetSafeDateTime(reader, "PurchaseDate")
                                });
                            }
                        }

                        // Result Set 4: Recent commissions
                        if (reader.NextResult())
                        {
                            while (reader.Read())
                            {
                                stats.RecentCommissions.Add(new ICOCommission
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
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get user ICO stats", ex);
            }

            return stats;
        }

        public ICOPurchaseResult PurchaseTokens(ICOPurchaseRequest request)
        {
            var result = new ICOPurchaseResult();
            try
            {
                var outputSuccess = new SqlParameter("@Success", SqlDbType.Bit) { Direction = ParameterDirection.Output };
                var outputMessage = new SqlParameter("@Message", SqlDbType.NVarChar, 500) { Direction = ParameterDirection.Output };
                var outputPurchaseId = new SqlParameter("@PurchaseId", SqlDbType.BigInt) { Direction = ParameterDirection.Output };
                var outputTokens = new SqlParameter("@TokensPurchased", SqlDbType.Decimal) { Direction = ParameterDirection.Output };

                ExecuteStoredProcedureNonQuery(
                    "usp_PurchaseICOTokens",
                    CreateParameter("@UserId", request.UserId),
                    CreateParameter("@ICOId", request.ICOId),
                    CreateParameter("@Amount", request.Amount),
                    outputSuccess, outputMessage, outputPurchaseId, outputTokens
                );

                result.Success = outputSuccess.Value != DBNull.Value && Convert.ToBoolean(outputSuccess.Value);
                result.ErrorMessage = outputMessage.Value != DBNull.Value ? outputMessage.Value.ToString() : "";
                result.PurchaseId = outputPurchaseId.Value != DBNull.Value ? Convert.ToInt64(outputPurchaseId.Value) : 0;
                result.TokensPurchased = outputTokens.Value != DBNull.Value ? Convert.ToDecimal(outputTokens.Value) : 0;
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.ErrorMessage = "System error: " + ex.Message;
                Logger.Error("Failed to purchase ICO tokens", ex);
            }
            return result;
        }
    }
}