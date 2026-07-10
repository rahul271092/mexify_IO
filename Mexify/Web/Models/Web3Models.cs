using System;

namespace Mexify.Models
{
    public class Web3Deposit
    {
        public long DepositId { get; set; }
        public int UserId { get; set; }
        public string WalletAddress { get; set; }
        public string CurrencyCode { get; set; }
        public int CurrencyId { get; set; }
        public decimal Amount { get; set; }
        public string Network { get; set; }
        public string TxHash { get; set; }
        public long? BlockNumber { get; set; }
        public string FromAddress { get; set; }
        public string ToAddress { get; set; }
        public decimal? GasUsed { get; set; }
        public decimal? GasPrice { get; set; }
        public int Status { get; set; }
        public int Confirmations { get; set; }
        public int RequiredConfirmations { get; set; }
        public string StatusName { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime? ConfirmedDate { get; set; }
    }

    public class UserWeb3Wallet
    {
        public long WalletId { get; set; }
        public int UserId { get; set; }
        public string WalletAddress { get; set; }
        public string WalletType { get; set; }
        public string Network { get; set; }
        public bool IsPrimary { get; set; }
        public bool IsVerified { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime? LastUsedDate { get; set; }
    }

    public class PlatformDepositAddress
    {
        public int AddressId { get; set; }
        public string CurrencyCode { get; set; }
        public string Network { get; set; }
        public string DepositAddress { get; set; }
        public decimal MinDeposit { get; set; }
        public bool IsActive { get; set; }
    }

    public class Web3DepositRequest
    {
        public int UserId { get; set; }
        public string WalletAddress { get; set; }
        public string CurrencyCode { get; set; }
        public decimal Amount { get; set; }
        public string Network { get; set; }
        public string TxHash { get; set; }
        public string FromAddress { get; set; }
        public string ToAddress { get; set; }
    }

    public class Web3DepositResult
    {
        public bool Success { get; set; }
        public string ErrorMessage { get; set; }
        public long DepositId { get; set; }
        public string TxHash { get; set; }
    }

    public class Web3TransactionInfo
    {
        public string TxHash { get; set; }
        public long BlockNumber { get; set; }
        public decimal GasUsed { get; set; }
        public decimal GasPrice { get; set; }
        public int Confirmations { get; set; }
        public bool IsConfirmed { get; set; }
        public string FromAddress { get; set; }
        public string ToAddress { get; set; }
        public decimal Value { get; set; }
    }
}