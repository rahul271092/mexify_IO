using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class StakingPlan
    {


        public int PoolId { get; set; }
        public int StakingPlanId { get; set; }
        public string PoolName { get; set; }
        public string PlanName { get; set; }
        public string DisplayName { get; set; }
        public string CurrencyCode { get; set; }
        public decimal MinAmount { get; set; }
        public decimal MaxAmount { get; set; }
        public decimal APY { get; set; }
        public int LockPeriodDays { get; set; }
        public bool AutoCompound { get; set; }
        public bool IsHot { get; set; }
        public decimal TotalStaked { get; set; }

        public decimal MinStake { get; set; }

        public decimal MaxStake { get; set; }
        public string TotalStakedFormatted { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; internal set; }
    }
}