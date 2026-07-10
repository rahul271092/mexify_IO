using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Mexify.Models;
using Mexify.Utilities;

namespace Mexify.DataAccess.Repositories
{
    public class TransactionRepository : BaseRepository
    {
        public TransactionPagedResult GetUserTransactionsPaged(TransactionFilter filter)
        {
            var result = new TransactionPagedResult
            {
                Transactions = new List<UserTransaction>(),
                CurrentPage = filter.Page
            };

            try
            {
                var outputTotal = new SqlParameter("@TotalCount", System.Data.SqlDbType.Int)
                {
                    Direction = System.Data.ParameterDirection.Output
                };

                var transactions = ExecuteStoredProcedure<UserTransaction>(
                    "usp_GetUserTransactionsPaged",
                    reader => MapTransaction(reader),
                    CreateParameter("@UserId", filter.UserId),
                    CreateParameter("@Search", filter.Search ?? (object)DBNull.Value),
                    CreateParameter("@Type", filter.Type ?? (object)DBNull.Value),
                    CreateParameter("@Status", filter.Status ?? (object)DBNull.Value),
                    CreateParameter("@Currency", filter.Currency ?? (object)DBNull.Value),
                    CreateParameter("@DateFrom", filter.DateFrom ?? (object)DBNull.Value),
                    CreateParameter("@DateTo", filter.DateTo ?? (object)DBNull.Value),
                    CreateParameter("@Page", filter.Page),
                    CreateParameter("@PageSize", filter.PageSize),
                    outputTotal
                );

                result.Transactions = transactions;
                result.TotalCount = outputTotal.Value != DBNull.Value ? Convert.ToInt32(outputTotal.Value) : 0;
                result.TotalPages = (int)Math.Ceiling((double)result.TotalCount / filter.PageSize);
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get paged transactions", ex);
            }

            return result;
        }

        public TransactionSummary GetUserTransactionSummary(int userId)
        {
            var results = ExecuteStoredProcedure<TransactionSummary>(
                "usp_GetUserTransactionSummary",
                reader => new TransactionSummary
                {
                    TotalVolume = GetSafeDecimal(reader, "TotalVolume"),
                    TotalCount = GetSafeInt(reader, "TotalCount"),
                    SuccessRate = GetSafeDecimal(reader, "SuccessRate"),
                    TotalInflow = GetSafeDecimal(reader, "TotalInflow"),
                    TotalOutflow = GetSafeDecimal(reader, "TotalOutflow"),
                    NetBalance = GetSafeDecimal(reader, "NetBalance"),
                    PendingCount = GetSafeInt(reader, "PendingCount")
                },
                CreateParameter("@UserId", userId)
            );
            return results.Count > 0 ? results[0] : new TransactionSummary();
        }

        public List<UserTransaction> GetUserTransactionsByType(int userId, int type, int count)
        {
            return ExecuteStoredProcedure<UserTransaction>(
                "usp_GetUserTransactionsByType",
                reader => MapTransaction(reader),
                CreateParameter("@UserId", userId),
                CreateParameter("@Type", type),
                CreateParameter("@Count", count)
            );
        }

        public TransactionStatsByType GetTransactionStatsByType(int userId, int type)
        {
            var results = ExecuteStoredProcedure<TransactionStatsByType>(
                "usp_GetTransactionStatsByType",
                reader => new TransactionStatsByType
                {
                    TotalAmount = GetSafeDecimal(reader, "TotalAmount"),
                    Count = GetSafeInt(reader, "Count"),
                    AverageAmount = GetSafeDecimal(reader, "AverageAmount"),
                    TotalFees = GetSafeDecimal(reader, "TotalFees")
                },
                CreateParameter("@UserId", userId),
                CreateParameter("@Type", type)
            );
            return results.Count > 0 ? results[0] : new TransactionStatsByType();
        }

        public List<UserTransaction> GetUserEarnings(int userId, int count)
        {
            return ExecuteStoredProcedure<UserTransaction>(
                "usp_GetUserEarnings",
                reader => MapTransaction(reader),
                CreateParameter("@UserId", userId),
                CreateParameter("@Count", count)
            );
        }

        public EarningsBreakdown GetEarningsBreakdown(int userId)
        {
            var results = ExecuteStoredProcedure<EarningsBreakdown>(
                "usp_GetEarningsBreakdown",
                reader => new EarningsBreakdown
                {
                    Total = GetSafeDecimal(reader, "Total"),
                    ROI = GetSafeDecimal(reader, "ROI"),
                    Staking = GetSafeDecimal(reader, "Staking"),
                    Mining = GetSafeDecimal(reader, "Mining"),
                    Referral = GetSafeDecimal(reader, "Referral")
                },
                CreateParameter("@UserId", userId)
            );
            return results.Count > 0 ? results[0] : new EarningsBreakdown();
        }

        public List<VolumeHistoryPoint> GetVolumeHistory(int userId, int days)
        {
            return ExecuteStoredProcedure<VolumeHistoryPoint>(
                "usp_GetTransactionVolumeHistory",
                reader => new VolumeHistoryPoint
                {
                    Date = GetSafeDateTime(reader, "Date"),
                    Inflow = GetSafeDecimal(reader, "Inflow"),
                    Outflow = GetSafeDecimal(reader, "Outflow")
                },
                CreateParameter("@UserId", userId),
                CreateParameter("@Days", days)
            );
        }

        public List<TypeDistributionItem> GetTypeDistribution(int userId)
        {
            return ExecuteStoredProcedure<TypeDistributionItem>(
                "usp_GetTransactionTypeDistribution",
                reader => new TypeDistributionItem
                {
                    Name = GetSafeString(reader, "Name") ?? "Unknown",
                    Value = GetSafeInt(reader, "Value")
                },
                CreateParameter("@UserId", userId)
            );
        }

        private UserTransaction MapTransaction(SqlDataReader reader)
        {
            int txType = GetSafeInt(reader, "TransactionType");
            return new UserTransaction
            {
                TransactionId = GetSafeLong(reader, "TransactionId"),
                TransactionType = txType,
                TypeName = GetSafeString(reader, "TypeName") ?? "Transaction",
                TypeClass = GetTypeClass(txType),
                Icon = GetTypeIcon(txType),
                SubType = GetSafeString(reader, "SubType") ?? "",
                Amount = GetSafeDecimal(reader, "Amount"),
                Fee = GetSafeDecimal(reader, "Fee"),
                NetAmount = GetSafeDecimal(reader, "NetAmount"),
                CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "PNC",
                Address = GetSafeString(reader, "Address") ?? "",
                TxHash = GetSafeString(reader, "TxHash") ?? "",
                Status = GetSafeInt(reader, "Status"),
                StatusName = GetSafeString(reader, "StatusName") ?? "Pending",
                CreatedDate = GetSafeDateTime(reader, "CreatedDate")
            };
        }

        private string GetTypeClass(int type)
        {
            switch (type)
            {
                case 1: return "deposit";
                case 2: return "withdraw";
                case 3: return "transfer";
                case 4: return "roi";
                case 5: return "invest";
                case 6: return "staking";
                case 7: return "mining";
                case 8: return "referral";
                default: return "fee";
            }
        }

        private string GetTypeIcon(int type)
        {
            switch (type)
            {
                case 1: return "fas fa-arrow-down";
                case 2: return "fas fa-arrow-up";
                case 3: return "fas fa-exchange-alt";
                case 4: return "fas fa-chart-line";
                case 5: return "fas fa-piggy-bank";
                case 6: return "fas fa-coins";
                case 7: return "fas fa-hammer";
                case 8: return "fas fa-users";
                default: return "fas fa-circle";
            }
        }
    }
}