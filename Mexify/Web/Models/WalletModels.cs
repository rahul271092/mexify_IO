using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
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

    public class WalletTransaction

    {

        public int WalletId { get; set; }




        public decimal LockedBalance { get; set; }

        public long TransactionId { get; set; }
        public int TransactionType { get; set; }
        public string TypeName { get; set; }
        public string TypeSlug { get; set; }
        public int CurrencyId { get; set; }
        public string CurrencyCode { get; set; }
        public decimal Amount { get; set; }
        public decimal Fee { get; set; }
        public decimal NetAmount { get; set; }
        public string Address { get; set; }
        public string TxHash { get; set; }
        public int Status { get; set; }
        public string StatusName { get; set; }
        public string StatusSlug { get; set; }
        public DateTime CreatedDate { get; set; }
        public int UserId { get; internal set; }
        public string CurrencyName { get; internal set; }
        public decimal Balance { get; internal set; }
    }

    public class WithdrawalResult
    {
        public bool Success { get; set; }
        public string ErrorMessage { get; set; }
        public long TransactionId { get; set; }
        public string CurrencyCode { get; set; }
    }

}