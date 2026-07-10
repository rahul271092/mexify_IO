using Mexify.Utilities;
using Mexify.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.DataAccess.Repositories
{
    public class WalletRepository : BaseRepository
    {
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

        public string GetDepositAddress(int userId, int currencyId)
        {
            var results = ExecuteStoredProcedure<string>(
                "usp_GetUserDepositAddress",
                reader => reader.GetString(0),
                CreateParameter("@UserId", userId),
                CreateParameter("@CurrencyId", currencyId)
            );
            return results.Count > 0 ? results[0] : "";
        }

        public List<WalletTransaction> GetUserTransactions(int userId, int count)
        {
            return ExecuteStoredProcedure<WalletTransaction>(
                "usp_GetUserWalletTransactions",
                reader => new WalletTransaction
                {
                    TransactionId = Convert.ToInt64(reader["TransactionId"]),
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