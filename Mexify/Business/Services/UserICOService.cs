using System;
using System.Collections.Generic;
using Mexify.DataAccess.Repositories;
using Mexify.Models;
using Mexify.Utilities;

namespace Mexify.Business.Services
{
    public class UserICOService
    {
        private readonly UserICORepository _repository;

        public UserICOService()
        {
            _repository = new UserICORepository();
        }

        public UserICOSummary GetUserICOSummary(int userId)
        {
            try { return _repository.GetUserICOSummary(userId); }
            catch (Exception ex) { Logger.Error("Failed to get ICO summary", ex); return new UserICOSummary(); }
        }

        public List<ICOProject> GetLiveProjects(int count)
        {
            try { return _repository.GetLiveProjects(count); }
            catch (Exception ex) { Logger.Error("Failed to get live projects", ex); return new List<ICOProject>(); }
        }

        public List<ICOProject> GetActiveProjects()
        {
            try { return _repository.GetActiveProjects(); }
            catch (Exception ex) { Logger.Error("Failed to get active projects", ex); return new List<ICOProject>(); }
        }

        public List<ICOParticipation> GetUserParticipations(int userId)
        {
            try { return _repository.GetUserParticipations(userId); }
            catch (Exception ex) { Logger.Error("Failed to get participations", ex); return new List<ICOParticipation>(); }
        }

        public List<ICOTokenHistory> GetUserTokenHistory(int userId, int count)
        {
            try { return _repository.GetUserTokenHistory(userId, count); }
            catch (Exception ex) { Logger.Error("Failed to get token history", ex); return new List<ICOTokenHistory>(); }
        }

        public List<ICOPerformancePoint> GetPerformanceHistory(int userId, int days)
        {
            try { return _repository.GetPerformanceHistory(userId, days); }
            catch (Exception ex) { Logger.Error("Failed to get performance history", ex); return new List<ICOPerformancePoint>(); }
        }

        public List<ICODistributionItem> GetPortfolioDistribution(int userId)
        {
            try { return _repository.GetPortfolioDistribution(userId); }
            catch (Exception ex) { Logger.Error("Failed to get distribution", ex); return new List<ICODistributionItem>(); }
        }
    }
}