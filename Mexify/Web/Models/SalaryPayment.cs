using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class SalaryPayment
    {
        public long PaymentId { get; set; }
        public DateTime PaymentDate { get; set; }
        public decimal Amount { get; set; }
        public string TierName { get; set; }
        public string StatusName { get; set; }
        public string StatusColor { get; set; }
        public string TimeAgo { get; set; }
        public string Notes { get; set; }
    }
}