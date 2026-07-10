using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class ICOInvestment
    {
        public long ICOInvestmentId { get; set; }
        public int ProjectId { get; set; }
        public string ProjectName { get; set; }
        public int UserId { get; set; }
        public decimal TokenAmount { get; set; }
        public decimal InvestedAmount { get; set; }
        public int CurrencyId { get; set; }
        public string CurrencyCode { get; set; }
        public int Status { get; set; } // 1: Active, 2: Refunded
        public DateTime CreatedDate { get; set; }
    }
}