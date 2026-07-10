using System;
using System.Collections.Generic;

namespace Mexify.Models
{
    public class TransactionFilter
    {
        public int UserId { get; set; }
        public string Search { get; set; }
        public int? Type { get; set; }
        public int? Status { get; set; }
        public string Currency { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public int Page { get; set; } = 1;
        public int PageSize { get; set; } = 20;
    }

    public class TransactionPagedResult
    {
        public List<UserTransaction> Transactions { get; set; }
        public int TotalCount { get; set; }
        public int TotalPages { get; set; }
        public int CurrentPage { get; set; }
    }

    public class UserTransaction
    {
        public long TransactionId { get; set; }
        public int TransactionType { get; set; }
        public string TypeName { get; set; }
        public string TypeClass { get; set; }
        public string Icon { get; set; }
        public string SubType { get; set; }
        public decimal Amount { get; set; }
        public decimal Fee { get; set; }
        public decimal NetAmount { get; set; }
        public string CurrencyCode { get; set; }
        public string Address { get; set; }
        public string TxHash { get; set; }
        public int Status { get; set; }
        public string StatusName { get; set; }
        public DateTime CreatedDate { get; set; }
    }

    public class TransactionSummary
    {
        public decimal TotalVolume { get; set; }
        public int TotalCount { get; set; }
        public decimal SuccessRate { get; set; }
        public decimal TotalInflow { get; set; }
        public decimal TotalOutflow { get; set; }
        public decimal NetBalance { get; set; }
        public int PendingCount { get; set; }
    }

    public class TransactionStatsByType
    {
        public decimal TotalAmount { get; set; }
        public int Count { get; set; }
        public decimal AverageAmount { get; set; }
        public decimal TotalFees { get; set; }
    }

    public class EarningsBreakdown
    {
        public decimal Total { get; set; }
        public decimal ROI { get; set; }
        public decimal Staking { get; set; }
        public decimal Mining { get; set; }
        public decimal Referral { get; set; }
    }

    public class VolumeHistoryPoint
    {
        public DateTime Date { get; set; }
        public decimal Inflow { get; set; }
        public decimal Outflow { get; set; }
    }

    public class TypeDistributionItem
    {
        public string Name { get; set; }
        public int Value { get; set; }
    }
}