using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class UserSalaryDetails
    {
        public bool IsQualified { get; set; }
        public string TierCode { get; set; }
        public string TierName { get; set; }
        public int TierLevel { get; set; }
        public decimal CurrentMonthlySalary { get; set; }
        public decimal RequiredSelfInvestment { get; set; }
        public decimal RequiredStrongLeg { get; set; }
        public decimal RequiredWeakerLeg { get; set; }
        public decimal SelfInvestment { get; set; }
        public decimal StrongLegVolume { get; set; }
        public decimal WeakerLegVolume { get; set; }
        public DateTime? QualifiedDate { get; set; }
        public decimal SelfMissing { get; set; }
        public decimal StrongMissing { get; set; }
        public decimal WeakerMissing { get; set; }
    }
}