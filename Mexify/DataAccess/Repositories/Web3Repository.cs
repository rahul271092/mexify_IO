using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Mexify.Models;
using Mexify.Utilities;
using Mexify.Web.Models;

namespace Mexify.DataAccess.Repositories
{
    public class Web3Repository : BaseRepository
    {

        public bool ProcessWeb3Deposit(int userId, int currencyId, decimal amount, string txHash)
        {
            try
            {
                Web3Repository _web3Repo;
                _web3Repo = new Web3Repository();

                WalletRepository _walletRepo;
                _walletRepo = new WalletRepository();

                // 1. Calculate 15% Fee
                decimal feePercent = 0.15m;
                decimal feeAmount = amount * feePercent;
                decimal netAmount = amount - feeAmount;

                // 2. Get User Wallet
                var wallet = _walletRepo.GetUserWalletByCurrency(userId, currencyId);
                if (wallet == null) return false;

                // 3. Credit ONLY the net amount
                wallet.Balance += netAmount;
                _walletRepo.UpdateWalletBalance(wallet);

                // 4. Record Transaction
                var transaction = new WalletTransaction
                {
                    WalletId = wallet.WalletId,
                    UserId = userId,
                    CurrencyId = currencyId,
                    Amount = amount,          // Gross amount
                    Fee = feeAmount,          // 15% Fee
                    NetAmount = netAmount,    // Amount actually credited
                    TransactionType = 1,
                    TypeName = "Web3 Deposit",
                    TypeSlug = "web3_deposit",
                    Status = 1,
                    CreatedDate = DateTime.UtcNow
                };

               // _walletRepo.RecordTransaction(transaction);

                // 5. Update Web3Deposits table status
              //  _web3Repo.MarkDepositAsProcessed(txHash);

                return true;
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to process Web3 deposit", ex);
                return false;
            }
        }



        public long RecordWeb3Deposit(Web3DepositRequest request)
        {
            var outputParam = CreateOutputParameter("@DepositId", SqlDbType.BigInt);

            ExecuteStoredProcedureNonQuery(
                "usp_RecordWeb3Deposit",
                CreateParameter("@UserId", request.UserId),
                CreateParameter("@WalletAddress", request.WalletAddress),
                CreateParameter("@CurrencyCode", request.CurrencyCode),
                CreateParameter("@Amount", request.Amount),
                CreateParameter("@Network", request.Network),
                CreateParameter("@TxHash", request.TxHash),
                CreateParameter("@FromAddress", request.FromAddress),
                CreateParameter("@ToAddress", request.ToAddress),
                outputParam
            );

            return outputParam.Value != DBNull.Value ? Convert.ToInt64(outputParam.Value) : -1;
        }

        public bool ConfirmWeb3Deposit(string txHash, long blockNumber, decimal gasUsed, decimal gasPrice, int confirmations, out string message)
        {
            var outputSuccess = CreateOutputParameter("@Success", SqlDbType.Bit);
            var outputMessage = CreateOutputParameter("@Message", SqlDbType.NVarChar, 500);

            ExecuteStoredProcedureNonQuery(
                "usp_ConfirmWeb3Deposit",
                CreateParameter("@TxHash", txHash),
                CreateParameter("@BlockNumber", blockNumber),
                CreateParameter("@GasUsed", gasUsed),
                CreateParameter("@GasPrice", gasPrice),
                CreateParameter("@Confirmations", confirmations),
                outputSuccess,
                outputMessage
            );

            message = outputMessage.Value?.ToString() ?? "";
            return outputSuccess.Value != DBNull.Value && Convert.ToBoolean(outputSuccess.Value);
        }

        public List<Web3Deposit> GetUserWeb3Deposits(int userId, int count = 50)
        {
            return ExecuteStoredProcedure<Web3Deposit>(
                "usp_GetUserWeb3Deposits",
                reader => new Web3Deposit
                {
                    DepositId = GetSafeLong(reader, "DepositId"),
                    WalletAddress = GetSafeString(reader, "WalletAddress") ?? "",
                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "",
                    Amount = GetSafeDecimal(reader, "Amount"),
                    Network = GetSafeString(reader, "Network") ?? "",
                    TxHash = GetSafeString(reader, "TxHash") ?? "",
                    BlockNumber = reader["BlockNumber"] == DBNull.Value ? (long?)null : Convert.ToInt64(reader["BlockNumber"]),
                    FromAddress = GetSafeString(reader, "FromAddress") ?? "",
                    ToAddress = GetSafeString(reader, "ToAddress") ?? "",
                    GasUsed = reader["GasUsed"] == DBNull.Value ? (decimal?)null : Convert.ToDecimal(reader["GasUsed"]),
                    GasPrice = reader["GasPrice"] == DBNull.Value ? (decimal?)null : Convert.ToDecimal(reader["GasPrice"]),
                    Status = GetSafeInt(reader, "Status"),
                    Confirmations = GetSafeInt(reader, "Confirmations"),
                    RequiredConfirmations = GetSafeInt(reader, "RequiredConfirmations"),
                    StatusName = GetSafeString(reader, "StatusName") ?? "Pending",
                    CreatedDate = GetSafeDateTime(reader, "CreatedDate"),
                    ConfirmedDate = reader["ConfirmedDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["ConfirmedDate"])
                },
                CreateParameter("@UserId", userId),
                CreateParameter("@Count", count)
            );
        }

        public PlatformDepositAddress GetPlatformDepositAddress(string currencyCode, string network)
        {
            var results = ExecuteStoredProcedure<PlatformDepositAddress>(
                "usp_GetPlatformDepositAddress",
                reader => new PlatformDepositAddress
                {
                    DepositAddress = GetSafeString(reader, "DepositAddress") ?? "",
                    MinDeposit = GetSafeDecimal(reader, "MinDeposit"),
                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "",
                    Network = GetSafeString(reader, "Network") ?? ""
                },
                CreateParameter("@CurrencyCode", currencyCode),
                CreateParameter("@Network", network)
            );

            return results.Count > 0 ? results[0] : null;
        }
    }
}