using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class RankInfo
    {
        private int Level { get; set; }
        private decimal CommissionPercent { get; set; }
        private int TeamCount { get; set; }
        private decimal Earned { get; set; }

        private int IsEligible { get; set; }
    }
}