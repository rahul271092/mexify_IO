using System;
using System.Collections.Generic;

namespace Mexify.Models
{
    public class ReferralStats
    {
        public int DirectReferrals { get; set; }
        public int TotalTeam { get; set; }
        public decimal TotalCommission { get; set; }
        public decimal ThisMonthCommission { get; set; }
        public decimal TodayCommission { get; set; }
    }

    public class UserRank
    {
        public string RankName { get; set; }
        public string RankClass { get; set; }
        public string RankIcon { get; set; }
        public string Requirement { get; set; }
        public decimal ProgressPercent { get; set; }
        public string ProgressText { get; set; }
        public decimal MonthlyBonus { get; set; }
    }

    public class LevelBreakdown
    {
        public int Level { get; set; }
        public decimal CommissionPercent { get; set; }
        public int TeamCount { get; set; }
        public decimal Earned { get; set; }
        public bool IsEligible { get; set; }
    }

    public class TeamMember
    {
        public int UserId { get; set; }
        public string Name { get; set; }
        public string PhotoUrl { get; set; }
        public int Level { get; set; }
        public decimal InvestedAmount { get; set; }
        public decimal YourEarnings { get; set; }
        public bool IsActive { get; set; }
        public DateTime JoinDate { get; set; }
    }

    public class CommissionHistory
    {
        public long CommissionId { get; set; }
        public int Level { get; set; }
        public string ReferralName { get; set; }
        public decimal Amount { get; set; }
        public string SourceType { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}