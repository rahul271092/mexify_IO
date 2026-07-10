using System;
using System.Collections.Generic;

namespace Mexify.Models
{
    public class UserICOSummary
    {
        public decimal TotalInvested { get; set; }
        public int TotalParticipations { get; set; }
        public int ActiveProjects { get; set; }
        public decimal TokensReceived { get; set; }
        public decimal TokensVesting { get; set; }
        public decimal TokensClaimed { get; set; }
        public decimal CurrentROI { get; set; }
        public decimal TotalRefunded { get; set; }
    }

    //public class ICOProject
    //{
    //    public int ICOProjectId { get; set; }
    //    public string ProjectName { get; set; }
    //    public string Category { get; set; }
    //    public string ImageUrl { get; set; }
    //    public string TokenSymbol { get; set; }
    //    public decimal TokenPrice { get; set; }
    //    public decimal MinInvestment { get; set; }
    //    public decimal HardCap { get; set; }
    //    public decimal RaisedAmount { get; set; }
    //    public decimal FundingPercent { get; set; }
    //    public string TotalSupplyFormatted { get; set; }
    //    public string VestingPeriod { get; set; }
    //    public bool IsHot { get; set; }
    //    public string StatusClass { get; set; }
    //    public string StatusName { get; set; }
    //    public DateTime EndDate { get; set; }
    //    public string EndDateIso { get; set; }
    //}

    public class ICOParticipation
    {
        public long ParticipationId { get; set; }
        public int ICOProjectId { get; set; }
        public string ProjectName { get; set; }
        public string TokenSymbol { get; set; }
        public decimal InvestedAmount { get; set; }
        public decimal TokenPrice { get; set; }
        public decimal TokensAllocated { get; set; }
        public decimal TokensReleased { get; set; }
        public decimal TokensVesting { get; set; }
        public decimal CurrentValue { get; set; }
        public int Status { get; set; }
        public string StatusName { get; set; }
        public DateTime ParticipatedDate { get; set; }
        public List<VestingScheduleItem> VestingSchedule { get; set; }
    }

    public class VestingScheduleItem
    {
        public DateTime ReleaseDate { get; set; }
        public decimal ReleasePercent { get; set; }
        public decimal ReleaseAmount { get; set; }
        public bool IsReleased { get; set; }
    }

    public class ICOTokenHistory
    {
        public long HistoryId { get; set; }
        public string ProjectName { get; set; }
        public string TokenType { get; set; }
        public string TokenSymbol { get; set; }
        public decimal Amount { get; set; }
        public DateTime DistributedDate { get; set; }
    }

    public class ICODistributionItem
    {
        public string Name { get; set; }
        public decimal Value { get; set; }
    }

    public class ICOPerformancePoint
    {
        public DateTime Date { get; set; }
        public decimal Value { get; set; }
    }
}