using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class SalaryTier
    {
        public int TierId { get; set; }
        public string TierCode { get; set; }
        public string TierName { get; set; }
        public string Description { get; set; }
        public decimal MonthlySalary { get; set; }
        public decimal MinSelfBusiness { get; set; }
        public decimal MinTeamBusiness { get; set; }
        public string IconClass { get; set; }
        public string ColorClass { get; set; }
        public bool HasQualified { get; set; }
    }
}