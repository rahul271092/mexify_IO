using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class SalaryStats
    {
        public decimal TotalEarned { get; set; }
        public int PaymentsCount { get; set; }
        public DateTime? NextPaymentDate { get; set; }
    }
}