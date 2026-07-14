using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class UserRankInfo
    {
        internal object RankClass;
        internal string RankIcon;
        internal string RankName;
        internal string Requirement;

        public decimal CurrentCommissionRate { get; internal set; }
        public string CurrentRankColor { get; internal set; }
        public string CurrentRankIcon { get; internal set; }
        public int CurrentRankLevel { get; internal set; }
        public string CurrentRankName { get; internal set; }
        public decimal DirectProgressPercent { get; internal set; }
        public string DirectProgressText { get; internal set; }
        public int DirectReferrals { get; internal set; }
        public bool HasNextRank { get; internal set; }
        public decimal MonthCommission { get; internal set; }
        public object MonthlyBonus { get; internal set; }
        public int NextRankDirectRequired { get; internal set; }
        public int NextRankLevel { get; internal set; }
        public string NextRankName { get; internal set; }
        public int NextRankTeamRequired { get; internal set; }
        public decimal PersonalInvestment { get; internal set; }
        public decimal ProgressPercent { get; internal set; }
        public string ProgressText { get; internal set; }
        public decimal TeamProgressPercent { get; internal set; }
        public string TeamProgressText { get; internal set; }
        public int TeamSize { get; internal set; }
        public decimal TotalCommission { get; internal set; }
        public int UserId { get; internal set; }
        public string UserName { get; internal set; }
    }
}