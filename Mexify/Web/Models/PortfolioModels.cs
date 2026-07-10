using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class PortfolioSummary
    {
        public decimal TotalValue { get; set; }
        public decimal TotalInvested { get; set; }
        public decimal TotalEarnings { get; set; }
        public int ActiveInvestments { get; set; }
        public decimal DailyIncome { get; set; }
        public decimal OverallROI { get; set; }
        public decimal ChangePercent { get; set; }
        public decimal ChangeAmount { get; set; }
    }

    public class WalletHolding
    {
        public int WalletId { get; set; }
        public string CurrencyCode { get; set; }
        public string CurrencyName { get; set; }
        public decimal Balance { get; set; }
        public decimal AvailableBalance { get; set; }
        public decimal LockedBalance { get; set; }
        public decimal ValuePNC { get; set; }
        public decimal AllocationPercent { get; set; }
    }

    public class PortfolioHolding
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public string TypeName { get; set; }
        public string TypeClass { get; set; }
        public string Icon { get; set; }
        public decimal Invested { get; set; }
        public decimal Value { get; set; }
        public decimal Earned { get; set; }
        public decimal DailyIncome { get; set; }
        public decimal ChangePercent { get; set; }
        public string Status { get; set; }
        public int Progress { get; set; }
        public int CurrentDay { get; set; }
        public int TotalDays { get; set; }
    }

    public class AllocationItem
    {
        public string Name { get; set; }
        public decimal Value { get; set; }
        public decimal Percent { get; set; }
        public string Color { get; set; }
    }

    public class PerformancePoint
    {
        public DateTime Date { get; set; }
        public decimal Value { get; set; }
    }
}