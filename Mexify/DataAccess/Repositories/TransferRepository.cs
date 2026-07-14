using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Mexify.Models;
using Mexify.Utilities;

namespace Mexify.DataAccess.Repositories
{
    public class TransferRepository : BaseRepository
    {
        public List<UserWalletAddress> GetUserWalletAddresses(int userId)
        {
            var addresses = new List<UserWalletAddress>();
            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_GetUserWalletAddresses", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            addresses.Add(new UserWalletAddress
                            {
                                AddressId = GetSafeLong(reader, "AddressId"),
                                UserId = GetSafeInt(reader, "UserId"),
                                CurrencyId = GetSafeInt(reader, "CurrencyId"),
                                WalletAddress = GetSafeString(reader, "WalletAddress") ?? "",
                                Label = GetSafeString(reader, "Label"),
                                Status = GetSafeInt(reader, "Status"),
                                CreatedDate = GetSafeDateTime(reader, "CreatedDate"),
                                CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "",
                                CurrencyName = GetSafeString(reader, "CurrencyName") ?? "",
                                Balance = GetSafeDecimal(reader, "Balance"),
                                QRCodeData = GetSafeString(reader, "QRCodeData") ?? ""
                            });
                        }
                    }
                }
            }
            catch (Exception ex) { Logger.Error("Failed to get wallet addresses", ex); }
            return addresses;
        }

        public string GetOrCreateWalletAddress(int userId, string currencyCode)
        {
            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_GetOrCreateWalletAddress", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@CurrencyCode", currencyCode);

                    var outAddress = new SqlParameter("@WalletAddress", SqlDbType.NVarChar, 50) { Direction = ParameterDirection.Output };
                    var outSuccess = new SqlParameter("@Success", SqlDbType.Bit) { Direction = ParameterDirection.Output };
                    var outMessage = new SqlParameter("@Message", SqlDbType.NVarChar, 500) { Direction = ParameterDirection.Output };

                    cmd.Parameters.AddRange(new[] { outAddress, outSuccess, outMessage });
                    conn.Open();
                    cmd.ExecuteNonQuery();

                    if (Convert.ToBoolean(outSuccess.Value))
                        return outAddress.Value.ToString();
                }
            }
            catch (Exception ex) { Logger.Error("Failed to get wallet address", ex); }
            return null;
        }

        public TransferResult ExecuteTransfer(int fromUserId, string toAddress, string currencyCode, decimal amount, string memo = null)
        {
            var result = new TransferResult();
            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_InternalTransfer", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@FromUserId", fromUserId);
                    cmd.Parameters.AddWithValue("@ToAddress", toAddress.Trim().ToUpper());
                    cmd.Parameters.AddWithValue("@CurrencyCode", currencyCode);
                    cmd.Parameters.AddWithValue("@Amount", amount);
                    cmd.Parameters.AddWithValue("@Memo", (object)memo ?? DBNull.Value);

                    var outId = new SqlParameter("@TransferId", SqlDbType.BigInt) { Direction = ParameterDirection.Output };
                    var outSuccess = new SqlParameter("@Success", SqlDbType.Bit) { Direction = ParameterDirection.Output };
                    var outMessage = new SqlParameter("@Message", SqlDbType.NVarChar, 500) { Direction = ParameterDirection.Output };

                    cmd.Parameters.AddRange(new[] { outId, outSuccess, outMessage });
                    conn.Open();
                    cmd.ExecuteNonQuery();

                    result.Success = Convert.ToBoolean(outSuccess.Value);
                    result.Message = outMessage.Value.ToString();
                    result.TransferId = outId.Value != DBNull.Value ? Convert.ToInt64(outId.Value) : 0;
                }
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.Message = "Transfer failed: " + ex.Message;
                Logger.Error("Transfer failed", ex);
            }
            return result;
        }

        public List<InternalTransfer> GetTransferHistory(int userId, int count = 20)
        {
            var transfers = new List<InternalTransfer>();
            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_GetInternalTransferHistory", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@Count", count);
                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            transfers.Add(new InternalTransfer
                            {
                                TransferId = GetSafeLong(reader, "TransferId"),
                                FromUserId = GetSafeInt(reader, "FromUserId"),
                                ToUserId = GetSafeInt(reader, "ToUserId"),
                                FromAddress = GetSafeString(reader, "FromAddress") ?? "",
                                ToAddress = GetSafeString(reader, "ToAddress") ?? "",
                                CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "",
                                Amount = GetSafeDecimal(reader, "Amount"),
                                Fee = GetSafeDecimal(reader, "Fee"),
                                NetAmount = GetSafeDecimal(reader, "NetAmount"),
                                Memo = GetSafeString(reader, "Memo"),
                                Status = GetSafeInt(reader, "Status"),
                                StatusName = GetSafeString(reader, "StatusName") ?? "",
                                CreatedDate = GetSafeDateTime(reader, "CreatedDate"),
                                Direction = GetSafeString(reader, "Direction") ?? "sent",
                                CounterpartyName = GetSafeString(reader, "CounterpartyName") ?? "Unknown",
                                CounterpartyAddress = GetSafeString(reader, "CounterpartyAddress") ?? "",
                                TimeAgo = GetSafeString(reader, "TimeAgo") ?? "",
                                IconClass = GetSafeString(reader, "IconClass") ?? "fas fa-exchange-alt",
                                ColorClass = GetSafeString(reader, "ColorClass") ?? "muted"
                            });
                        }
                    }
                }
            }
            catch (Exception ex) { Logger.Error("Failed to get transfer history", ex); }
            return transfers;
        }
    }
}