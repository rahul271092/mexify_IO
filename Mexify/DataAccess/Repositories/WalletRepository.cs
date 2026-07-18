using Mexify.Utilities;
using Mexify.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Mexify.Models;
using System.Data.SqlClient;
using System.Data;

namespace Mexify.DataAccess.Repositories
{
    public class WalletRepository : BaseRepository
    {

        public TransactionListResult GetUserWalletTransactions(
            int userId,
            string typeSlug = null,
            string currencyCode = null,
            string statusSlug = null,
            string searchTerm = null,
            DateTime? dateFrom = null,
            DateTime? dateTo = null,
            int pageNumber = 1,
            int pageSize = 25,
            string sortBy = "date_desc")
        {
            var result = new TransactionListResult();

            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_GetUserWalletTransactions", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@TypeSlug", string.IsNullOrEmpty(typeSlug) ? (object)DBNull.Value : typeSlug);
                    cmd.Parameters.AddWithValue("@CurrencyCode", string.IsNullOrEmpty(currencyCode) ? (object)DBNull.Value : currencyCode);
                    cmd.Parameters.AddWithValue("@StatusSlug", string.IsNullOrEmpty(statusSlug) ? (object)DBNull.Value : statusSlug);
                    cmd.Parameters.AddWithValue("@SearchTerm", string.IsNullOrEmpty(searchTerm) ? (object)DBNull.Value : searchTerm);
                    cmd.Parameters.AddWithValue("@DateFrom", dateFrom.HasValue ? (object)dateFrom.Value : DBNull.Value);
                    cmd.Parameters.AddWithValue("@DateTo", dateTo.HasValue ? (object)dateTo.Value : DBNull.Value);
                    cmd.Parameters.AddWithValue("@PageNumber", pageNumber);
                    cmd.Parameters.AddWithValue("@PageSize", pageSize);
                    cmd.Parameters.AddWithValue("@SortBy", sortBy);

                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        // Result Set 1: Pagination Info
                        if (reader.Read())
                        {
                            result.TotalCount = GetSafeInt(reader, "TotalCount");
                            result.PageSize = GetSafeInt(reader, "PageSize");
                            result.CurrentPage = GetSafeInt(reader, "CurrentPage");
                            result.TotalPages = reader["TotalPages"] != DBNull.Value
                                ? Convert.ToInt32(reader["TotalPages"]) : 1;
                        }

                        // Result Set 2: Transactions List
                        if (reader.NextResult())
                        {
                            while (reader.Read())
                            {
                                result.Transactions.Add(new WalletTransaction
                                {
                                 //   TransactionId = GetSafeInt(reader, "WalletTransactionId"),

                                    // ✅ FIX: Match the exact column name returned by SQL
                                    TransactionId = reader.GetInt32(reader.GetOrdinal("WalletTransactionId")),
                                    WalletId = GetSafeInt(reader, "WalletId"),
                                    UserId = GetSafeInt(reader, "UserId"),
                                    TransactionType = GetSafeInt(reader, "TransactionType"),
                                    TypeName = GetSafeString(reader, "TypeName") ?? "",
                                    TypeSlug = GetSafeString(reader, "TypeSlug") ?? "",
                                    CurrencyId = GetSafeInt(reader, "CurrencyId"),
                                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "",
                                    Amount = GetSafeDecimal(reader, "Amount"),
                                    Fee = GetSafeDecimal(reader, "Fee"),
                                    NetAmount = GetSafeDecimal(reader, "NetAmount"),
                                    Status = GetSafeInt(reader, "Status"),
                                    StatusName = GetSafeString(reader, "StatusName") ?? "",
                                    StatusSlug = GetSafeString(reader, "StatusSlug") ?? "",
                                    CreatedDate = GetSafeDateTime(reader, "CreatedDate"),
                                    Direction = GetSafeString(reader, "Direction") ?? "neutral",
                                    IconClass = GetSafeString(reader, "IconClass") ?? "fas fa-exchange-alt",
                                    CategoryClass = GetSafeString(reader, "CategoryClass") ?? "other",
                                    CurrentWalletBalance = GetSafeDecimal(reader, "CurrentWalletBalance")
                                });
                            }
                        }

                        // Result Set 3: Summary Stats
                        if (reader.NextResult())
                        {
                            if (reader.Read())
                            {
                                result.Summary = new Web.Models.TransactionSummary
                                {
                                    TotalDeposits = GetSafeDecimal(reader, "TotalDeposits"),
                                    TotalWithdrawals = GetSafeDecimal(reader, "TotalWithdrawals"),
                                    TotalROIEarned = GetSafeDecimal(reader, "TotalROIEarned"),
                                    TotalCommissions = GetSafeDecimal(reader, "TotalCommissions"),
                                    TotalFeesPaid = GetSafeDecimal(reader, "TotalFeesPaid"),
                                    TotalTransactionCount = GetSafeInt(reader, "TotalTransactionCount"),
                                    PendingCount = GetSafeInt(reader, "PendingCount"),
                                    FailedCount = GetSafeInt(reader, "FailedCount")
                                };
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Error($"Failed to get wallet transactions for User {userId}", ex);
            }

            return result;
        }



        public List<WalletInfo> GetUserWallets(int userId)
        {
            return ExecuteStoredProcedure<WalletInfo>(
                "usp_GetUserWallets",
                reader => new WalletInfo
                {
                    WalletId = GetSafeInt(reader, "WalletId"),
                    CurrencyId = GetSafeInt(reader, "CurrencyId"),
                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "USDT",
                    CurrencyName = GetSafeString(reader, "CurrencyName") ?? "TETHER",
                    Balance = GetSafeDecimal(reader, "Balance"),
                    LockedBalance = GetSafeDecimal(reader, "LockedBalance"),
                    ValuePNC = GetSafeDecimal(reader, "ValuePNC")
                },
                CreateParameter("@UserId", userId)
            );
        }


      
        public WalletInfo GetUserWallet(int userId, int currencyId)
        {
            var results = ExecuteStoredProcedure<WalletInfo>(
                "usp_GetUserWalletByCurrency",
                reader => new WalletInfo
                {
                    WalletId = GetSafeInt(reader, "WalletId"),
                    CurrencyId = GetSafeInt(reader, "CurrencyId"),
                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "USDT",
                    CurrencyName = GetSafeString(reader, "CurrencyName") ?? "USDT",
                    Balance = GetSafeDecimal(reader, "Balance"),
                    LockedBalance = GetSafeDecimal(reader, "LockedBalance"),
                    ValuePNC = GetSafeDecimal(reader, "ValuePNC")
                },
                CreateParameter("@UserId", userId),
                CreateParameter("@CurrencyId", currencyId)
            );
            return results.Count > 0 ? results[0] : null;
        }

        public List<CurrencyInfo> GetSupportedCurrencies()
        {
            return ExecuteStoredProcedure<CurrencyInfo>(
                "usp_GetSupportedCurrencies",
                reader => new CurrencyInfo
                {
                    CurrencyId = GetSafeInt(reader, "CurrencyId"),
                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "",
                    CurrencyName = GetSafeString(reader, "CurrencyName") ?? "",
                    Network = GetSafeString(reader, "Network") ?? "",
                    MinDeposit = GetSafeDecimal(reader, "MinDeposit"),
                    WithdrawalFee = GetSafeDecimal(reader, "WithdrawalFee"),
                    MinWithdrawal = GetSafeDecimal(reader, "MinWithdrawal"),
                    IsActive = GetSafeBool(reader, "IsActive")
                }
            );
        }

        public CurrencyInfo GetCurrencyById(int currencyId)
        {
            var results = ExecuteStoredProcedure<CurrencyInfo>(
                "usp_GetCurrencyById",
                reader => new CurrencyInfo
                {
                    CurrencyId = GetSafeInt(reader, "CurrencyId"),
                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "",
                    CurrencyName = GetSafeString(reader, "CurrencyName") ?? "",
                    Network = GetSafeString(reader, "Network") ?? "",
                    MinDeposit = GetSafeDecimal(reader, "MinDeposit"),
                    WithdrawalFee = GetSafeDecimal(reader, "WithdrawalFee"),
                    MinWithdrawal = GetSafeDecimal(reader, "MinWithdrawal"),
                    IsActive = GetSafeBool(reader, "IsActive")
                },
                CreateParameter("@CurrencyId", currencyId)
            );
            return results.Count > 0 ? results[0] : null;
        }


        /// <summary>
        /// Gets a specific wallet for a user based on Currency ID
        /// </summary>
        public WalletTransaction GetUserWalletByCurrency(int userId, int currencyId)
        {
            try
            {
                var results = ExecuteStoredProcedure<WalletTransaction>(
                    "usp_GetUserWalletByCurrency",
                    reader => new WalletTransaction
                    {
                        WalletId = GetSafeInt(reader, "WalletId"),
                        UserId = GetSafeInt(reader, "UserId"),
                        CurrencyId = GetSafeInt(reader, "CurrencyId"),
                        CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "",
                        CurrencyName = GetSafeString(reader, "CurrencyName") ?? "",
                        Balance = GetSafeDecimal(reader, "Balance"),
                        LockedBalance = GetSafeDecimal(reader, "LockedBalance"),
                        Status = GetSafeInt(reader, "Status"),
                        CreatedDate = GetSafeDateTime(reader, "CreatedDate"),
              //          UpdatedDate = GetSafeDateTime(reader, "UpdatedDate")
                    },
                    CreateParameter("@UserId", userId),
                    CreateParameter("@CurrencyId", currencyId)
                );

                // Return the first wallet found, or null if it doesn't exist
                return results.Count > 0 ? results[0] : null;
            }
            catch (Exception ex)
            {
                Logger.Error($"Failed to get wallet for User {userId}, Currency {currencyId}", ex);
                return null;
            }
        }


        //public TransactionListResult GetUserWalletTransactions(
        //   int userId,
        //   string typeSlug = null,
        //   string currencyCode = null,
        //   string statusSlug = null,
        //   string searchTerm = null,
        //   DateTime? dateFrom = null,
        //   DateTime? dateTo = null,
        //   int pageNumber = 1,
        //   int pageSize = 25,
        //   string sortBy = "date_desc")
        //{
        //    var result = new TransactionListResult();

        //    try
        //    {
        //        using (var conn = ConnectionManager.GetConnection())
        //        using (var cmd = new SqlCommand("usp_GetUserWalletTransactions", conn))
        //        {
        //            cmd.CommandType = CommandType.StoredProcedure;
        //            cmd.Parameters.AddWithValue("@UserId", userId);
        //            cmd.Parameters.AddWithValue("@TypeSlug", string.IsNullOrEmpty(typeSlug) ? (object)DBNull.Value : typeSlug);
        //            cmd.Parameters.AddWithValue("@CurrencyCode", string.IsNullOrEmpty(currencyCode) ? (object)DBNull.Value : currencyCode);
        //            cmd.Parameters.AddWithValue("@StatusSlug", string.IsNullOrEmpty(statusSlug) ? (object)DBNull.Value : statusSlug);
        //            cmd.Parameters.AddWithValue("@SearchTerm", string.IsNullOrEmpty(searchTerm) ? (object)DBNull.Value : searchTerm);
        //            cmd.Parameters.AddWithValue("@DateFrom", dateFrom.HasValue ? (object)dateFrom.Value : DBNull.Value);
        //            cmd.Parameters.AddWithValue("@DateTo", dateTo.HasValue ? (object)dateTo.Value : DBNull.Value);
        //            cmd.Parameters.AddWithValue("@PageNumber", pageNumber);
        //            cmd.Parameters.AddWithValue("@PageSize", pageSize);
        //            cmd.Parameters.AddWithValue("@SortBy", sortBy);
        //            conn.Open();

        //            using (var reader = cmd.ExecuteReader())
        //            {
        //                // Result Set 1: Pagination Info
        //                if (reader.Read())
        //                {
        //                    result.TotalCount = GetSafeInt(reader, "TotalCount");
        //                    result.PageSize = GetSafeInt(reader, "PageSize");
        //                    result.CurrentPage = GetSafeInt(reader, "CurrentPage");
        //                    result.TotalPages = reader["TotalPages"] != DBNull.Value
        //                        ? Convert.ToInt32(reader["TotalPages"]) : 1;
        //                }

        //                // Result Set 2: Transactions
        //                if (reader.NextResult())
        //                {
        //                    while (reader.Read())
        //                    {
        //                        result.Transactions.Add(new WalletTransaction
        //                        {
        //                            TransactionId = GetSafeLong(reader, "TransactionId"),
        //                            WalletId = GetSafeInt(reader, "WalletId"),
        //                            UserId = GetSafeInt(reader, "UserId"),
        //                            TransactionType = GetSafeInt(reader, "TransactionType"),
        //                            TypeName = GetSafeString(reader, "TypeName") ?? "",
        //                            TypeSlug = GetSafeString(reader, "TypeSlug") ?? "",
        //                            CurrencyId = GetSafeInt(reader, "CurrencyId"),
        //                            CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "",
        //                            Amount = GetSafeDecimal(reader, "Amount"),
        //                            Fee = GetSafeDecimal(reader, "Fee"),
        //                            NetAmount = GetSafeDecimal(reader, "NetAmount"),
        //                            Status = GetSafeInt(reader, "Status"),
        //                            StatusName = GetSafeString(reader, "StatusName") ?? "",
        //                            StatusSlug = GetSafeString(reader, "StatusSlug") ?? "",
        //                            CreatedDate = GetSafeDateTime(reader, "CreatedDate"),
        //                            Direction = GetSafeString(reader, "Direction") ?? "neutral",
        //                            IconClass = GetSafeString(reader, "IconClass") ?? "fas fa-exchange-alt",
        //                            CategoryClass = GetSafeString(reader, "CategoryClass") ?? "other",
        //                            CurrentWalletBalance = GetSafeDecimal(reader, "CurrentWalletBalance")
        //                        });
        //                    }
        //                }

        //                // Result Set 3: Summary Stats
        //                if (reader.NextResult())
        //                {
        //                    if (reader.Read())
        //                    {
        //                        result.Summary = new Web.Models.TransactionSummary
        //                        {
        //                            TotalDeposits = GetSafeDecimal(reader, "TotalDeposits"),
        //                            TotalWithdrawals = GetSafeDecimal(reader, "TotalWithdrawals"),
        //                            TotalROIEarned = GetSafeDecimal(reader, "TotalROIEarned"),
        //                            TotalCommissions = GetSafeDecimal(reader, "TotalCommissions"),
        //                            TotalFeesPaid = GetSafeDecimal(reader, "TotalFeesPaid"),
        //                            TotalTransactionCount = GetSafeInt(reader, "TotalTransactionCount"),
        //                            PendingCount = GetSafeInt(reader, "PendingCount"),
        //                            FailedCount = GetSafeInt(reader, "FailedCount")
        //                        };
        //                    }
        //                }
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Logger.Error($"Failed to get wallet transactions for User {userId}", ex);
        //    }

        //    return result;
        //}


        public List<CurrencyInfo> GetActiveCurrencies()
        {
            var currencies = new List<CurrencyInfo>();
            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("SELECT CurrencyId, CurrencyCode, CurrencyName FROM Currencies WHERE Status = 1 ORDER BY CurrencyCode", conn))
                {
                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            currencies.Add(new CurrencyInfo
                            {
                                CurrencyId = GetSafeInt(reader, "CurrencyId"),
                                CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "",
                                CurrencyName = GetSafeString(reader, "CurrencyName") ?? ""
                            });
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get active currencies", ex);
            }
            return currencies;
        }

        /// <summary>
        /// Updates the wallet balance in the database
        /// </summary>
        public void UpdateWalletBalance(WalletTransaction wallet)
        {
            try
            {
                ExecuteStoredProcedureNonQuery(
                    "usp_UpdateWalletBalance",
                    CreateParameter("@WalletId", wallet.WalletId),
                    CreateParameter("@NewBalance", wallet.Balance)
                );
            }
            catch (Exception ex)
            {
                Logger.Error($"Failed to update balance for WalletId {wallet.WalletId}", ex);
                throw;
            }
        }

        public string GetDepositAddress(int userId, int currencyId=0)
        {
            var results = ExecuteStoredProcedure<string>(
                "usp_GetUserDepositAddress",
                reader => reader.GetString(0),
                CreateParameter("@UserId", userId),
                CreateParameter("@CurrencyId", currencyId)
            );
            return results.Count > 0 ? results[0] : "";
        }


        /// <summary>
        /// Gets or generates a deposit address for the user
        /// </summary>
        public DepositAddressInfo GetUserDepositAddress(int userId, string currencyCode = "PNC")
        {
            var result = new DepositAddressInfo();

            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_GetUserDepositAddress", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@CurrencyCode", string.IsNullOrEmpty(currencyCode) ? "PNC" : currencyCode);

                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            result.Success = GetSafeBool(reader, "Success");
                            result.Message = GetSafeString(reader, "Message") ?? "";
                            result.DepositAddress = GetSafeString(reader, "DepositAddress") ?? "";
                            result.Network = GetSafeString(reader, "Network") ?? "";
                            result.Memo = GetSafeString(reader, "Memo");
                            result.QRCodeData = GetSafeString(reader, "QRCodeData") ?? "";
                            result.CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "";
                            result.CurrencyName = GetSafeString(reader, "CurrencyName") ?? "";
                            result.MinDeposit = GetSafeDecimal(reader, "MinDeposit");
                            result.MaxDeposit = GetSafeDecimal(reader, "MaxDeposit");
                            result.NetworkFee = GetSafeDecimal(reader, "NetworkFee");
                            result.EstimatedTime = GetSafeString(reader, "EstimatedTime") ?? "";
                            result.Warning = GetSafeString(reader, "Warning") ?? "";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Error($"Failed to get deposit address for User {userId}", ex);
                result.Success = false;
                result.Message = "Failed to generate deposit address.";
            }

            return result;
        }


        public List<WalletTransaction> GetUserTransactions(int userId, int count)
        {
            return ExecuteStoredProcedure<WalletTransaction>(
                "usp_GetUserWalletTransactions",
                reader => new WalletTransaction
                {
                    TransactionId = Int32.Parse(reader["TransactionId"].ToString()),
                    TransactionType = GetSafeInt(reader, "TransactionType"),
                    TypeName = GetSafeString(reader, "TypeName") ?? "Transaction",
                    TypeSlug = GetSafeString(reader, "TypeSlug") ?? "other",
                    CurrencyId = GetSafeInt(reader, "CurrencyId"),
                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "PNC",
                    Amount = GetSafeDecimal(reader, "Amount"),
                    Fee = GetSafeDecimal(reader, "Fee"),
                    NetAmount = GetSafeDecimal(reader, "NetAmount"),
                    Address = GetSafeString(reader, "Address") ?? "",
                    TxHash = GetSafeString(reader, "TxHash") ?? "",
                    Status = GetSafeInt(reader, "Status"),
                    StatusName = GetSafeString(reader, "StatusName") ?? "Pending",
                    StatusSlug = GetSafeString(reader, "StatusSlug") ?? "pending",
                    CreatedDate = GetSafeDateTime(reader, "CreatedDate")
                },
                CreateParameter("@UserId", userId),
                CreateParameter("@Count", count)
            );
        }

        public WithdrawalResult ProcessWithdrawal(int userId, int currencyId, string address, decimal amount, string twoFACode)
        {
            var result = new WithdrawalResult();
            try
            {
                var outputSuccess = CreateOutputParameter("@Success", System.Data.SqlDbType.Bit);
                var outputMessage = CreateOutputParameter("@Message", System.Data.SqlDbType.NVarChar, 500);
                var outputTxId = CreateOutputParameter("@TransactionId", System.Data.SqlDbType.BigInt);

                ExecuteStoredProcedureNonQuery(
                    "usp_ProcessWithdrawal",
                    CreateParameter("@UserId", userId),
                    CreateParameter("@CurrencyId", currencyId),
                    CreateParameter("@Address", address),
                    CreateParameter("@Amount", amount),
                    CreateParameter("@TwoFACode", twoFACode),
                    outputSuccess,
                    outputMessage,
                    outputTxId
                );

                result.Success = Convert.ToBoolean(outputSuccess.Value);
                result.ErrorMessage = outputMessage.Value as string ?? "";
                result.TransactionId = outputTxId.Value != DBNull.Value ? Convert.ToInt64(outputTxId.Value) : 0;

                if (result.Success)
                {
                    var currency = GetCurrencyById(currencyId);
                    result.CurrencyCode = currency?.CurrencyCode ?? "PNC";
                }
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.ErrorMessage = "An error occurred: " + ex.Message;
                Logger.Error("Withdrawal processing failed", ex);
            }
            return result;
        }
    }
}