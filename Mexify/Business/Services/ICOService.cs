using System;
using System.Collections.Generic;
using Mexify.DataAccess.Repositories;
using Mexify.Models;
using Mexify.Utilities;

namespace Mexify.Business.Services
{
    public class ICOService
    {
        private readonly ICORepository _repo;

        public ICOService()
        {
            _repo = new ICORepository();
        }

        // =========================================
        // ✅ FIXED: Return type is List<ICOProject>
        // =========================================
        public List<ICOProject> GetActiveICOs()
        {
            try { return _repo.GetActiveICOs(); }
            catch (Exception ex) { Logger.Error("Failed to get active ICOs", ex); return new List<ICOProject>(); }
        }

        public List<ICOProject> GetAllProjects()
        {
            try { return _repo.GetAllProjects(); }
            catch (Exception ex) { Logger.Error("Failed to get all ICO projects", ex); return new List<ICOProject>(); }
        }

        public List<ICOProject> GetFeaturedProjects()
        {
            try { return _repo.GetFeaturedProjects(); }
            catch (Exception ex) { Logger.Error("Failed to get featured ICO projects", ex); return new List<ICOProject>(); }
        }

        public List<ICOCommissionTier> GetCommissionTiers()
        {
            try { return _repo.GetCommissionTiers(); }
            catch (Exception ex) { Logger.Error("Failed to get commission tiers", ex); return new List<ICOCommissionTier>(); }
        }

        public ICOStats GetUserICOStats(int userId)
        {
            try { return _repo.GetUserICOStats(userId); }
            catch (Exception ex) { Logger.Error("Failed to get user ICO stats", ex); return new ICOStats(); }
        }

        public ICOPurchaseResult PurchaseTokens(ICOPurchaseRequest request)
        {
            try
            {
                if (request.Amount <= 0)
                    return new ICOPurchaseResult { Success = false, ErrorMessage = "Invalid amount" };

                return _repo.PurchaseTokens(request);
            }
            catch (Exception ex)
            {
                Logger.Error("Purchase tokens failed", ex);
                return new ICOPurchaseResult { Success = false, ErrorMessage = ex.Message };
            }
        }

        // ✅ Helper method to get a single project by ID
        public ICOProject GetProjectById(int projectId)
        {
            try
            {
                var projects = _repo.GetActiveICOs();
                foreach (var project in projects)
                {
                    if (project.ICOId == projectId)
                        return project;
                }
                return null;
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get project by ID", ex);
                return null;
            }
        }
    }
}