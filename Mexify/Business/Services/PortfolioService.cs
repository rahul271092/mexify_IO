using System;
using System.Collections.Generic;
using Mexify.DataAccess.Repositories;

using Mexify.Utilities;
using Mexify.Web.Models;

namespace Mexify.Business.Services
{
    public class PortfolioService
    {
        private readonly PortfolioRepository _repository;

        public PortfolioService()
        {
            _repository = new PortfolioRepository();
        }

        public PortfolioSummary GetPortfolioSummary(int userId)
        {
            try { return _repository.GetPortfolioSummary(userId); }
            catch (Exception ex) { Logger.Error("Failed to get portfolio summary", ex); return new PortfolioSummary(); }
        }

        public List<WalletHolding> GetWalletHoldings(int userId)
        {
            try { return _repository.GetWalletHoldings(userId); }
            catch (Exception ex) { Logger.Error("Failed to get wallet holdings", ex); return new List<WalletHolding>(); }
        }

        public List<PortfolioHolding> GetHoldings(int userId)
        {
            try { return _repository.GetHoldings(userId); }
            catch (Exception ex) { Logger.Error("Failed to get holdings", ex); return new List<PortfolioHolding>(); }
        }

        public List<PerformancePoint> GetPerformanceHistory(int userId, int days)
        {
            try { return _repository.GetPerformanceHistory(userId, days); }
            catch (Exception ex) { Logger.Error("Failed to get performance", ex); return new List<PerformancePoint>(); }
        }

        public List<AllocationItem> GetAllocation(int userId)
        {
            try
            {
                var summary = GetPortfolioSummary(userId);
                decimal total = summary.TotalValue > 0 ? summary.TotalValue : 1;

                var holdings = GetHoldings(userId);
                var wallets = GetWalletHoldings(userId);

                decimal roiTotal = 0, stakingTotal = 0, miningTotal = 0;
                decimal nftTotal = 0, icoTotal = 0, royaltyTotal = 0, walletTotal = 0;

                foreach (var h in holdings)
                {
                    switch (h.TypeClass)
                    {
                        case "roi": roiTotal += h.Value; break;
                        case "staking": stakingTotal += h.Value; break;
                        case "mining": miningTotal += h.Value; break;
                        case "nft": nftTotal += h.Value; break;
                        case "ico": icoTotal += h.Value; break;
                        case "royalty": royaltyTotal += h.Value; break;
                        default: roiTotal += h.Value; break;
                    }
                }

                foreach (var w in wallets)
                {
                    walletTotal += w.ValuePNC;
                }

                return new List<AllocationItem>
                {
                    new AllocationItem { Name = "ROI Plans", Value = roiTotal, Percent = Math.Round(roiTotal / total * 100, 1), Color = "#2563EB" },
                    new AllocationItem { Name = "Staking", Value = stakingTotal, Percent = Math.Round(stakingTotal / total * 100, 1), Color = "#00FFB2" },
                    new AllocationItem { Name = "Mining", Value = miningTotal, Percent = Math.Round(miningTotal / total * 100, 1), Color = "#FFD700" },
                    new AllocationItem { Name = "NFTs", Value = nftTotal, Percent = Math.Round(nftTotal / total * 100, 1), Color = "#9C27B0" },
                    new AllocationItem { Name = "ICO", Value = icoTotal, Percent = Math.Round(icoTotal / total * 100, 1), Color = "#ff3b5c" },
                    new AllocationItem { Name = "Wallet", Value = walletTotal, Percent = Math.Round(walletTotal / total * 100, 1), Color = "#00D4FF" }
                };
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get allocation", ex);
                return new List<AllocationItem>();
            }
        }
    }
}