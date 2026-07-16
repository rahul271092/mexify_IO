using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{

    public class WalletTransaction
    {
        public int TransactionId { get; set; }
        public int WalletId { get; set; }
        public int UserId { get; set; }
        public int TransactionType { get; set; }
        public string TypeName { get; set; }
        public string TypeSlug { get; set; }
        public int CurrencyId { get; set; }
        public string CurrencyCode { get; set; }
        public decimal Amount { get; set; }
        public decimal Fee { get; set; }
        public decimal NetAmount { get; set; }
        public int Status { get; set; }
        public string StatusName { get; set; }
        public string StatusSlug { get; set; }
        public DateTime CreatedDate { get; set; }
        public string Direction { get; set; }
        public string IconClass { get; set; }
        public string CategoryClass { get; set; }
        public decimal CurrentWalletBalance { get; set; }
        public string CurrencyName { get; internal set; }
        public decimal Balance { get; internal set; }
        public decimal LockedBalance { get; internal set; }
        public string Address { get; internal set; }
        public string TxHash { get; internal set; }
    }

    public class TransactionSummary
    {
        public decimal TotalDeposits { get; set; }
        public decimal TotalWithdrawals { get; set; }
        public decimal TotalROIEarned { get; set; }
        public decimal TotalCommissions { get; set; }
        public decimal TotalFeesPaid { get; set; }
        public int TotalTransactionCount { get; set; }
        public int PendingCount { get; set; }
        public int FailedCount { get; set; }
    }

    public class TransactionListResult
    {
        public int TotalCount { get; set; }
        public int PageSize { get; set; }
        public int CurrentPage { get; set; }
        public int TotalPages { get; set; }
        public List<WalletTransaction> Transactions { get; set; } = new List<WalletTransaction>();
        public TransactionSummary Summary { get; set; } = new TransactionSummary();
    }
   
   
   

    public class WalletInfo
    {
        public int WalletId { get; set; }
        public int CurrencyId { get; set; }
        public string CurrencyCode { get; set; }
        public string CurrencyName { get; set; }
        public decimal Balance { get; set; }
        public decimal LockedBalance { get; set; }
        public decimal ValuePNC { get; set; }
    }

    public class CurrencyInfo
    {
        public int CurrencyId { get; set; }
        public string CurrencyCode { get; set; }
        public string CurrencyName { get; set; }
        public string Network { get; set; }
        public decimal MinDeposit { get; set; }
        public decimal WithdrawalFee { get; set; }
        public decimal MinWithdrawal { get; set; }
        public bool IsActive { get; set; }
    }


    public class DepositAddressInfo
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public string DepositAddress { get; set; }
        public string Network { get; set; }
        public string Memo { get; set; }
        public string QRCodeData { get; set; }
        public string CurrencyCode { get; set; }
        public string CurrencyName { get; set; }
        public decimal MinDeposit { get; set; }
        public decimal MaxDeposit { get; set; }
        public decimal NetworkFee { get; set; }
        public string EstimatedTime { get; set; }
        public string Warning { get; set; }

        // Calculated
        public bool HasMemo => !string.IsNullOrEmpty(Memo);
        public string ShortAddress => DepositAddress?.Length > 20
            ? DepositAddress.Substring(0, 10) + "..." + DepositAddress.Substring(DepositAddress.Length - 8)
            : DepositAddress;
    }

    public class WithdrawalResult
    {
        public bool Success { get; set; }
        public string ErrorMessage { get; set; }
        public long TransactionId { get; set; }
        public string CurrencyCode { get; set; }
    }

}