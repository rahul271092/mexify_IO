using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class TierRequirement
    {
        public string TierCode { get; set; }
        public string TierName { get; set; }
        public decimal SelfInvestment { get; set; }
        public decimal StrongLegVolume { get; set; }
        public decimal WeakerLegVolume { get; set; }
    }
}