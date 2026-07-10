using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    // ✅ RENAMED to avoid ambiguity
    public class MiningPlanViewModel
    {
        public int MiningPlanId { get; set; }
        public string PlanName { get; set; }
        public string Algorithm { get; set; }
        public string Hashrate { get; set; }
        public string HashrateFormatted { get; set; }
        public string PowerConsumption { get; set; }
        public decimal Price { get; set; }
        public int DurationDays { get; set; }
        public decimal ExpectedDailyReward { get; set; }
        public string RewardCurrency { get; set; }
        public decimal MaintenanceFee { get; set; }
        public string MaintenanceFeeFormatted { get; set; }
        public int RoiDays { get; set; }
        public bool IsFeatured { get; set; }
        public bool IsActive { get; set; }


        public int ContractDays { get; set; }  // Was DurationDays
        public decimal DailyOutput { get; set; }  // Was ExpectedDailyReward
        public bool IsPopular { get; set; }  // Was IsFeatured

        public DateTime CreatedDate { get; set; }

        public string DisplayName
        {
            get
            {
                return PlanName + " (" + HashrateFormatted + " / " + DurationDays + " days)";
            }
        }
    }
}