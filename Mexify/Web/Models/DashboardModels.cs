using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class PortfolioStats
    {
        public decimal TotalBalance { get; set; }
        public decimal TotalInvested { get; set; }
        public decimal TotalEarnings { get; set; }
        public decimal TodayProfit { get; set; }
        public decimal TotalWithdrawn { get; set; }
    }

    public class WalletSummary
    {
        public int WalletId { get; set; }
        public string CurrencyCode { get; set; }
        public string CurrencyName { get; set; }
        public decimal Balance { get; set; }
        public decimal LockedBalance { get; set; }
        public decimal ValuePNC { get; set; }
    }

    public class ActiveInvestment
    {
        public long InvestmentId { get; set; }
        public string PlanName { get; set; }
        public decimal InvestedAmount { get; set; }
        public decimal DailyROI { get; set; }
        public decimal TotalEarned { get; set; }
        public int CurrentDay { get; set; }
        public int TotalDays { get; set; }
        public decimal ProgressPercent { get; set; }
        public int Status { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string InvestmentType { get; internal set; }
        public decimal PrincipalAmount { get; internal set; }
        public decimal DailyRatePercent { get; internal set; }
    }

    public class RecentTransaction
    {
        public long TransactionId { get; set; }
        public int TransactionType { get; set; }
        public string Title { get; set; }
        public decimal Amount { get; set; }
        public string CurrencyCode { get; set; }
        public DateTime CreatedDate { get; set; }
        public string DateFormatted { get; set; }
    }

    public class ReferralStats
    {
        public int DirectReferrals { get; set; }
        public int TotalTeam { get; set; }
        public decimal TotalCommission { get; set; }
        public decimal ThisMonthCommission { get; set; }
    }

    public class PortfolioPoint
    {
        public DateTime Date { get; set; }
        public decimal Value { get; set; }
    }

    public class EarningsBreakdown
    {
        public decimal ROI { get; set; }
        public decimal Staking { get; set; }
        public decimal Mining { get; set; }
        public decimal Referrals { get; set; }
        public decimal Royalties { get; set; }
    }
}