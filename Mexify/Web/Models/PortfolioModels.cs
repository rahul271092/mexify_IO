using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{

    public class PortfolioHolding
    {
        public long HoldingId { get; set; }
        public string HoldingType { get; set; }
        public string HoldingName { get; set; }
        public string SubTitle { get; set; }
        public decimal InvestedAmount { get; set; }
        public decimal CurrentValue { get; set; }
        public decimal ProfitLoss { get; set; }
        public decimal ROIPercent { get; set; }
        public int Status { get; set; }
        public string StatusName { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string IconClass { get; set; }
        public string ColorClass { get; set; }
        public string CurrencyCode { get; set; }

        // Calculated
        public string ProfitLossClass => ProfitLoss >= 0 ? "positive" : "negative";
        public string ROIClass => ROIPercent >= 0 ? "text-success" : "text-danger";
        public string FormattedPL => (ProfitLoss >= 0 ? "+" : "") + ProfitLoss.ToString("N2");

        public string TypeClass { get;  set; }
        public decimal Value { get;  set; }
        public long Id { get;  set; }
        public string Name { get;  set; }
        public string TypeName { get;  set; }
        public string Icon { get; set; }
        public decimal Invested { get; set; }
        public decimal Earned { get;  set; }
        public decimal DailyIncome { get;  set; }
        public decimal ChangePercent { get;  set; }
        public int Progress { get;  set; }
        public int CurrentDay { get;  set; }
        public int TotalDays { get;  set; }
    }

    public class PortfolioAllocation
    {
        public string CategoryName { get; set; }
        public string CategorySlug { get; set; }
        public decimal CategoryValue { get; set; }
        public decimal AllocationPercent { get; set; }
    }

    public class PortfolioHoldingsSummary
    {
        public decimal TotalInvested { get; set; }
        public decimal TotalCurrentValue { get; set; }
        public decimal TotalProfitLoss { get; set; }
        public decimal OverallROI { get; set; }
        public int TotalHoldings { get; set; }
        public int ActiveCount { get; set; }
        public decimal InvestmentValue { get; set; }
        public decimal MiningValue { get; set; }
        public decimal StakingValue { get; set; }
        public decimal LicenseValue { get; set; }
        public decimal NFTValue { get; set; }
        public decimal CashValue { get; set; }
    }

    public class PortfolioHoldingsResult
    {
        public PortfolioHoldingsSummary Summary { get; set; } = new PortfolioHoldingsSummary();
        public List<PortfolioHolding> Holdings { get; set; } = new List<PortfolioHolding>();
        public List<PortfolioAllocation> Allocations { get; set; } = new List<PortfolioAllocation>();
        public int TotalCount { get; set; }
        public int PageNumber { get; set; }
        public int PageSize { get; set; }
        public int TotalPages => PageSize > 0 ? (int)Math.Ceiling((double)TotalCount / PageSize) : 0;
    }


    public class PortfolioSummary
    {


        public decimal TotalValue { get; set; }

        public decimal TotalWalletBalance { get; set; }
        public decimal TotalInvested { get; set; }
        public decimal TotalEarnings { get; set; }
        public decimal TotalWithdrawn { get; set; }
        public decimal TotalDeposited { get; set; }

        // Calculated Property
        public decimal NetWorth => TotalWalletBalance + TotalInvested;

        public int ActiveInvestments { get; internal set; }
        public decimal DailyIncome { get; internal set; }
        public decimal OverallROI { get; internal set; }
        public decimal ChangePercent { get; internal set; }
        public decimal ChangeAmount { get; internal set; }
    }

    public class PortfolioHistoryPoint
    {
        public DateTime Date { get; set; }
        public decimal Inflow { get; set; }
        public decimal Outflow { get; set; }
    }

    public class PortfolioViewModel
    {
        public PortfolioSummary Summary { get; set; } = new PortfolioSummary();
        public List<PortfolioHistoryPoint> History { get; set; } = new List<PortfolioHistoryPoint>();
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