using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Mexify.Models;
using Mexify.Utilities;
using Mexify.Web.Models;
using static Mexify.Web.Models.P2PTrade;

namespace Mexify.DataAccess.Repositories
{
    public class P2PRepository : BaseRepository
    {

        public P2PTrade.P2PTradeDetails GetTradeDetails(long tradeId, int userId)
        {
            P2PTradeDetails trade = null;
            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_GetP2PTradeDetails", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@TradeId", tradeId);
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    conn.Open();

                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            trade = new P2PTradeDetails
                            {
                                TradeId = GetSafeLong(reader, "TradeId"),
                                AdId = GetSafeLong(reader, "AdId"),
                                BuyerId = GetSafeInt(reader, "BuyerId"),
                                SellerId = GetSafeInt(reader, "SellerId"),
                                CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "",
                                CryptoAmount = GetSafeDecimal(reader, "CryptoAmount"),
                                FiatAmount = GetSafeDecimal(reader, "FiatAmount"),
                                Price = GetSafeDecimal(reader, "Price"),
                                PaymentMethod = GetSafeString(reader, "PaymentMethod") ?? "",
                                Status = GetSafeInt(reader, "Status"),
                                StatusName = GetSafeString(reader, "StatusName") ?? "",
                                BuyerPaymentProof = GetSafeString(reader, "BuyerPaymentProof"),
                                CreatedDate = GetSafeDateTime(reader, "CreatedDate"),
                                UpdatedDate = reader["UpdatedDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["UpdatedDate"]),
                                CompletedDate = reader["CompletedDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["CompletedDate"]),
                                UserRole = GetSafeString(reader, "UserRole") ?? "NONE",
                                CounterpartyId = trade?.UserRole == "BUYER" ? GetSafeInt(reader, "SellerUserId") : GetSafeInt(reader, "BuyerUserId"),
                                CounterpartyName = trade?.UserRole == "BUYER" ? GetSafeString(reader, "SellerName") : GetSafeString(reader, "BuyerName"),
                                CounterpartyWallet = trade?.UserRole == "BUYER" ? GetSafeString(reader, "SellerWallet") : GetSafeString(reader, "BuyerWallet"),
                                CounterpartyCompletedTrades = trade?.UserRole == "BUYER" ? GetSafeInt(reader, "SellerCompletedTrades") : GetSafeInt(reader, "BuyerCompletedTrades"),
                                CounterpartyAvgCompletionMinutes = trade?.UserRole == "BUYER" ? (reader["SellerAvgCompletionMinutes"] == DBNull.Value ? (int?)null : Convert.ToInt32(reader["SellerAvgCompletionMinutes"])) : (reader["BuyerAvgCompletionMinutes"] == DBNull.Value ? (int?)null : Convert.ToInt32(reader["BuyerAvgCompletionMinutes"])),
                                MinutesRemaining = GetSafeInt(reader, "MinutesRemaining"),
                                AdTerms = GetSafeString(reader, "AdTerms"),
                                AvailablePaymentMethods = GetSafeString(reader, "AvailablePaymentMethods")
                            };

                            // Fix counterparty info (since we didn't know role when reading)
                            if (trade.UserRole == "BUYER")
                            {
                                trade.CounterpartyId = GetSafeInt(reader, "SellerUserId");
                                trade.CounterpartyName = GetSafeString(reader, "SellerName");
                                trade.CounterpartyWallet = GetSafeString(reader, "SellerWallet");
                                trade.CounterpartyCompletedTrades = GetSafeInt(reader, "SellerCompletedTrades");
                            }
                            else if (trade.UserRole == "SELLER")
                            {
                                trade.CounterpartyId = GetSafeInt(reader, "BuyerUserId");
                                trade.CounterpartyName = GetSafeString(reader, "BuyerName");
                                trade.CounterpartyWallet = GetSafeString(reader, "BuyerWallet");
                                trade.CounterpartyCompletedTrades = GetSafeInt(reader, "BuyerCompletedTrades");
                            }
                        }
                    }
                }
            }
            catch (Exception ex) { Logger.Error("Failed to get trade details", ex); }
            return trade;
        }

        public bool BuyerMarkAsPaid(long tradeId, int buyerId, string paymentProof, out string message)
        {
            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_BuyerMarkAsPaid", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@TradeId", tradeId);
                    cmd.Parameters.AddWithValue("@BuyerId", buyerId);
                    cmd.Parameters.AddWithValue("@PaymentProof", (object)paymentProof ?? DBNull.Value);

                    var outSuccess = new SqlParameter("@Success", SqlDbType.Bit) { Direction = ParameterDirection.Output };
                    var outMessage = new SqlParameter("@Message", SqlDbType.NVarChar, 500) { Direction = ParameterDirection.Output };
                    cmd.Parameters.AddRange(new[] { outSuccess, outMessage });

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    message = outMessage.Value.ToString();
                    return Convert.ToBoolean(outSuccess.Value);
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Mark as paid failed", ex);
                message = "Error: " + ex.Message;
                return false;
            }
        }

        public bool SellerReleaseFunds(long tradeId, int sellerId, out string message)
        {
            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_SellerReleaseFunds", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@TradeId", tradeId);
                    cmd.Parameters.AddWithValue("@SellerId", sellerId);

                    var outSuccess = new SqlParameter("@Success", SqlDbType.Bit) { Direction = ParameterDirection.Output };
                    var outMessage = new SqlParameter("@Message", SqlDbType.NVarChar, 500) { Direction = ParameterDirection.Output };
                    cmd.Parameters.AddRange(new[] { outSuccess, outMessage });

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    message = outMessage.Value.ToString();
                    return Convert.ToBoolean(outSuccess.Value);
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Release funds failed", ex);
                message = "Error: " + ex.Message;
                return false;
            }
        }

        public bool CancelTrade(long tradeId, int userId, out string message)
        {
            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_CancelP2PTrade", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@TradeId", tradeId);
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    var outSuccess = new SqlParameter("@Success", SqlDbType.Bit) { Direction = ParameterDirection.Output };
                    var outMessage = new SqlParameter("@Message", SqlDbType.NVarChar, 500) { Direction = ParameterDirection.Output };
                    cmd.Parameters.AddRange(new[] { outSuccess, outMessage });

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    message = outMessage.Value.ToString();
                    return Convert.ToBoolean(outSuccess.Value);
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Cancel trade failed", ex);
                message = "Error: " + ex.Message;
                return false;
            }
        }


        public List<P2PAd> GetActiveP2PAds(string currencyCode = "USDT", string adType = "SELL")
        {
            var ads = new List<P2PAd>();
            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_GetActiveP2PAds", conn)) // Create this SP to SELECT * FROM P2PAds WHERE Status=1 AND CurrencyCode=@Currency AND AdType=@AdType
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CurrencyCode", currencyCode);
                    cmd.Parameters.AddWithValue("@AdType", adType);
                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            ads.Add(new P2PAd
                            {
                                AdId = GetSafeLong(reader, "AdId"),
                                UserName = GetSafeString(reader, "UserName") ?? "User",
                                AdType = GetSafeString(reader, "AdType"),
                                CurrencyCode = GetSafeString(reader, "CurrencyCode"),
                                FiatCurrency = GetSafeString(reader, "FiatCurrency"),
                                Price = GetSafeDecimal(reader, "Price"),
                                MinLimit = GetSafeDecimal(reader, "MinLimit"),
                                MaxLimit = GetSafeDecimal(reader, "MaxLimit"),
                                PaymentMethods = GetSafeString(reader, "PaymentMethods"),
                                CreatedDate = GetSafeDateTime(reader, "CreatedDate")
                            });
                        }
                    }
                }
            }
            catch (Exception ex) { Logger.Error("Failed to get P2P ads", ex); }
            return ads;
        }




        //public P2PTrade GetTradeDetails(long tradeId, int userId)
        //{
        //    // Implement SELECT * FROM P2PTrades WHERE TradeId = @TradeId AND (BuyerId = @UserId OR SellerId = @UserId)
        //    return new P2PTrade(); // Placeholder
        //}
    }
}