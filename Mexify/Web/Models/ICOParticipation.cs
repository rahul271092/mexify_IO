using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class ICOParticipation
    {
        public long ParticipationId { get; set; }
        public int UserId { get; set; }
        public int ICOId { get; set; }
        public decimal TokensPurchased { get; set; }
        public decimal AmountPaid { get; set; }
        public string CurrencyCode { get; set; }
        public decimal PricePerToken { get; set; }
        public string TxHash { get; set; }
        public int Status { get; set; }
        public DateTime PurchaseDate { get; set; }
        public DateTime CreatedDate { get; set; }

    }
}