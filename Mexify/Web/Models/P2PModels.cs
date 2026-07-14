using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class P2PAd
    {
        public long AdId { get; set; }
        public int UserId { get; set; }
        public string UserName { get; set; }
        public string AdType { get; set; } // "BUY" or "SELL"
        public string CurrencyCode { get; set; }
        public string FiatCurrency { get; set; }
        public decimal Price { get; set; }
        public decimal MinLimit { get; set; }
        public decimal MaxLimit { get; set; }
        public string PaymentMethods { get; set; }
        public string Terms { get; set; }
        public int Status { get; set; }
        public DateTime CreatedDate { get; set; }

        public string TypeClass => AdType == "BUY" ? "text-success" : "text-danger";
        public string TypeBadge => AdType == "BUY" ? "badge-accent" : "badge-danger";
    }

    public class P2PTrade
    {
        public long TradeId { get; set; }
        public long AdId { get; set; }
        public int BuyerId { get; set; }
        public string BuyerName { get; set; }
        public int SellerId { get; set; }
        public string SellerName { get; set; }
        public string CurrencyCode { get; set; }
        public decimal CryptoAmount { get; set; }
        public decimal FiatAmount { get; set; }
        public decimal Price { get; set; }
        public string PaymentMethod { get; set; }
        public int Status { get; set; } // 0=Pending, 1=Paid, 2=Released, 3=Cancelled, 4=Disputed
        public string BuyerPaymentProof { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime? CompletedDate { get; set; }

        public string StatusName
        {
            get
            {
                switch (Status)
                {
                    case 0: return "Pending Payment";
                    case 1: return "Paid (Awaiting Release)";
                    case 2: return "Completed";
                    case 3: return "Cancelled";
                    case 4: return "Disputed";
                    default: return "Unknown";
                }
            }
        }





        public class P2PTradeDetails
        {
            public long TradeId { get; set; }
            public long AdId { get; set; }
            public int BuyerId { get; set; }
            public int SellerId { get; set; }
            public string CurrencyCode { get; set; }
            public decimal CryptoAmount { get; set; }
            public decimal FiatAmount { get; set; }
            public decimal Price { get; set; }
            public string PaymentMethod { get; set; }
            public int Status { get; set; }
            public string StatusName { get; set; }
            public string BuyerPaymentProof { get; set; }
            public DateTime CreatedDate { get; set; }
            public DateTime? UpdatedDate { get; set; }
            public DateTime? CompletedDate { get; set; }

            public string UserRole { get; set; } // BUYER, SELLER, NONE

            // Counterparty Info
            public int CounterpartyId { get; set; }
            public string CounterpartyName { get; set; }
            public string CounterpartyWallet { get; set; }
            public int CounterpartyCompletedTrades { get; set; }
            public int? CounterpartyAvgCompletionMinutes { get; set; }

            // Timing
            public int MinutesRemaining { get; set; }
            public string AdTerms { get; set; }
            public string AvailablePaymentMethods { get; set; }

            // Computed
            public bool IsBuyer => UserRole == "BUYER";
            public bool IsSeller => UserRole == "SELLER";
            public bool CanMarkAsPaid => IsBuyer && Status == 0 && MinutesRemaining > 0;
            public bool CanReleaseFunds => IsSeller && Status == 1;
            public bool CanCancel => Status == 0 || Status == 1;
            public bool IsCompleted => Status == 2;
            public bool IsCancelled => Status == 3;
            public bool IsDisputed => Status == 4;
           



        public string StatusBadgeClass
        {
            get
            {
                if (Status == 0) return "badge-warning";
                if (Status == 1) return "badge-info";
                if (Status == 2) return "badge-success";
                if (Status == 3) return "badge-secondary";
                if (Status == 4) return "badge-danger";
                return "badge-muted";
            }
        }
    }

    public class P2PTradeTimeline
    {
        public int StepNumber { get; set; }
        public string StepTitle { get; set; }
        public string StepDescription { get; set; }
        public string StepIcon { get; set; }
        public DateTime? StepDate { get; set; }
        public bool IsCompleted { get; set; }
    }
}


}