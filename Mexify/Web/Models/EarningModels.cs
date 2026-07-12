using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class UserEarningsBreakdown
    {
        // Lifetime Earnings
        public decimal InvestmentLifetime { get; set; }
        public decimal MiningLifetime { get; set; }
        public decimal StakingLifetime { get; set; }
        public decimal RoyaltyLifetime { get; set; }
        public decimal CommissionLifetime { get; set; }
        public decimal TotalLifetime { get; set; }

        // Today's Earnings
        public decimal InvestmentToday { get; set; }
        public decimal MiningToday { get; set; }
        public decimal StakingToday { get; set; }
        public decimal RoyaltyToday { get; set; }
        public decimal CommissionToday { get; set; }
        public decimal TotalToday { get; set; }
    }
}