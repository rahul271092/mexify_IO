using System;
using System.Collections.Generic;
using Mexify.DataAccess.Repositories;
using Mexify.Web.Models;
using Mexify.Utilities;
using Mexify.Models;

namespace Mexify.Business.Services
{
    public class SalaryService
    {
        private readonly SalaryRepository _repository;

        public SalaryService()
        {
            _repository = new SalaryRepository();
        }

        public Models.UserSalaryDetails GetUserSalaryDetails(int userId)
        {
            try { return _repository.GetUserSalaryDetails(userId); }
            catch (Exception ex) { Logger.Error("Failed to get salary details", ex); return new Models.UserSalaryDetails(); }
        }

        public List<InvestorTier> GetAllTiersWithUserStatus(int userId)
        {
            try { return _repository.GetAllTiersWithUserStatus(userId); }
            catch (Exception ex) { Logger.Error("Failed to get tiers", ex); return new List<InvestorTier>(); }
        }

        public List<TierProgress> GetNextTierProgress(int userId)
        {
            try { return _repository.GetNextTierProgress(userId); }
            catch (Exception ex) { Logger.Error("Failed to get progress", ex); return new List<TierProgress>(); }
        }

        public List<Models.SalaryPayment> GetUserSalaryHistory(int userId,  int count)
        {
            count = 20;
            try { return _repository.GetUserSalaryHistory(userId); }
            catch (Exception ex) { Logger.Error("Failed to get salary history", ex); return new List<Models.SalaryPayment>(); }
        }

        public Models.SalaryStats GetUserSalaryStats(int userId)
        {
            try { return _repository.GetUserSalaryStats(userId); }
            catch (Exception ex) { Logger.Error("Failed to get salary stats", ex); return new Models.SalaryStats(); }
        }

        public InvestorTier GetFirstTierRequirements()
        {
            try
            {
                var tiers = _repository.GetAllTiers();
                return tiers.Count > 0 ? tiers[0] : null;
            }
            catch { return null; }
        }
    }
}