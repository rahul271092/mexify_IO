using System;
using System.Collections.Generic;

namespace Mexify.Models
{
    public class StakingCommission
    {
        public long CommissionId { get; set; }
        public int FromUserId { get; set; }
        public string FromUserName { get; set; }
        public string FromUserEmail { get; set; }
        public int Level { get; set; }
        public decimal StakedAmount { get; set; }
        public decimal CommissionPercent { get; set; }
        public decimal CommissionAmount { get; set; }
        public int DirectReferralsAtTime { get; set; }
        public string CurrencyCode { get; set; }
        public DateTime CreatedDate { get; set; }
    }

    public class StakingCommissionLevelSummary
    {
        public int Level { get; set; }
        public decimal CommissionPercent { get; set; }
        public int RequiredDirects { get; set; }
        public int TimesEarned { get; set; }
        public decimal LevelTotal { get; set; }
        public int CurrentDirects { get; set; }
        public bool IsQualified { get; set; }
    }

    public class StakingCommissionStats
    {
        public decimal TotalEarned { get; set; }
        public int TotalCommissions { get; set; }
        public int UniqueDownlines { get; set; }
        public List<StakingCommissionLevelSummary> LevelBreakdown { get; set; }
        public List<StakingCommission> RecentCommissions { get; set; }
    }
}