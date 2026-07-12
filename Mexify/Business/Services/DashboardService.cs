using System;
using System.Collections.Generic;
using Mexify.DataAccess.Repositories;

using Mexify.Utilities;
using Mexify.Web.Models;

namespace Mexify.Business.Services
{
    public class DashboardService
    {
        private readonly DashboardRepository _repository;

        public DashboardService()
        {
            _repository = new DashboardRepository();
        }

        public PortfolioStats GetPortfolioStats(int userId)
        {
            try { return _repository.GetPortfolioStats(userId); }
            catch (Exception ex) { Logger.Error("Failed to get portfolio stats", ex);
                Logger.Info("Exception:" + ex.ToString());

                return new PortfolioStats(); }
        }

        public List<WalletSummary> GetUserWallets(int userId)
        {
            try { return _repository.GetUserWallets(userId); }
            catch (Exception ex) { Logger.Error("Failed to get user wallets", ex);
                Logger.Info("Exception:" + ex.ToString());
                return new List<WalletSummary>(); }
        }

        public List<ActiveInvestment> GetActiveInvestments(int userId)
        {
            try { return _repository.GetActiveInvestments(userId); }
            catch (Exception ex) { Logger.Error("Failed to get active investments", ex);
                Logger.Info("Exception:" + ex.ToString());
                return new List<ActiveInvestment>(); }
        }

        public List<RecentTransaction> GetRecentTransactions(int userId, int count)
        {
            try { return _repository.GetRecentTransactions(userId, count); }
            catch (Exception ex) { Logger.Error("Failed to get recent transactions", ex);
                Logger.Info("Exception:" + ex.ToString());
                return new List<RecentTransaction>(); }
        }

        public ReferralStats GetReferralStats(int userId)
        {
            try { return _repository.GetReferralStats(userId); }
            catch (Exception ex) { Logger.Error("Failed to get referral stats", ex);
                Logger.Info("Exception:" + ex.ToString());
                return new ReferralStats(); }
        }

        public List<PortfolioPoint> GetPortfolioHistory(int userId, int days)
        {
            try { return _repository.GetPortfolioHistory(userId, days); }
            catch (Exception ex) { Logger.Error("Failed to get portfolio history", ex);
                Logger.Info("Exception:" + ex.ToString());
                return new List<PortfolioPoint>(); }
        }

        public EarningsBreakdown GetEarningsBreakdown(int userId)
        {
            try { return _repository.GetEarningsBreakdown(userId); }
            catch (Exception ex) { Logger.Error("Failed to get earnings breakdown", ex);
                Logger.Info("Exception:" + ex.ToString());

                return new EarningsBreakdown(); }
        }
    }
}