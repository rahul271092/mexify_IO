using System;
using System.Collections.Generic;

namespace Mexify.Models
{
    public class UserWalletAddress
    {
        public long AddressId { get; set; }
        public int UserId { get; set; }
        public int CurrencyId { get; set; }
        public string WalletAddress { get; set; }
        public string Label { get; set; }
        public int Status { get; set; }
        public DateTime CreatedDate { get; set; }
        public string CurrencyCode { get; set; }
        public string CurrencyName { get; set; }
        public decimal Balance { get; set; }
        public string QRCodeData { get; set; }

        // Calculated
        public string ShortAddress => WalletAddress?.Length > 15
            ? WalletAddress.Substring(0, 8) + "..." + WalletAddress.Substring(WalletAddress.Length - 4)
            : WalletAddress;
    }

    public class InternalTransfer
    {
        public long TransferId { get; set; }
        public int FromUserId { get; set; }
        public int ToUserId { get; set; }
        public string FromAddress { get; set; }
        public string ToAddress { get; set; }
        public string CurrencyCode { get; set; }
        public decimal Amount { get; set; }
        public decimal Fee { get; set; }
        public decimal NetAmount { get; set; }
        public string Memo { get; set; }
        public int Status { get; set; }
        public string StatusName { get; set; }
        public DateTime CreatedDate { get; set; }
        public string Direction { get; set; }
        public string CounterpartyName { get; set; }
        public string CounterpartyAddress { get; set; }
        public string TimeAgo { get; set; }
        public string IconClass { get; set; }
        public string ColorClass { get; set; }

        // Calculated
        public bool IsSent => Direction == "sent";
        public string AmountDisplay => (IsSent ? "- " : "+ ") + Amount.ToString("N4") + " " + CurrencyCode;
        public string AmountClass => IsSent ? "text-danger" : "text-success";
    }

    public class TransferResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public long TransferId { get; set; }
    }
}