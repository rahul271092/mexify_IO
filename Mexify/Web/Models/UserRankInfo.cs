using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class UserRankInfo
    {
        public decimal RankClass;
        public string RankIcon;
        public string RankName;
        public string Requirement;

        public decimal CurrentCommissionRate { get; set; }
        public string CurrentRankColor { get; set; }
        public string CurrentRankIcon { get;  set; }
        public int CurrentRankLevel { get; set; }
        public string CurrentRankName { get;  set; }
        public decimal DirectProgressPercent { get; set; }
        public string DirectProgressText { get;  set; }
        public int DirectReferrals { get; set; }
        public bool HasNextRank { get;  set; }
        public decimal MonthCommission { get;  set; }
        public object MonthlyBonus { get;  set; }
        public int NextRankDirectRequired { get;  set; }
        public int NextRankLevel { get;  set; }
        public string NextRankName { get;  set; }
        public int NextRankTeamRequired { get; set; }
        public decimal PersonalInvestment { get;  set; }
        public decimal ProgressPercent { get; set; }
        public string ProgressText { get; set; }
        public decimal TeamProgressPercent { get;  set; }
        public string TeamProgressText { get;  set; }
        public int TeamSize { get;  set; }
        public decimal TotalCommission { get;  set; }
        public int UserId { get;  set; }
        public string UserName { get;  set; }
    }
}