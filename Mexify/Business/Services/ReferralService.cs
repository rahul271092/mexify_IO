using System;
using System.Collections.Generic;
using Mexify.DataAccess.Repositories;
using Mexify.Models;
using Mexify.Utilities;

namespace Mexify.Business.Services
{
    public class ReferralService
    {
        private readonly ReferralRepository _repository;

        public ReferralService()
        {
            _repository = new ReferralRepository();
        }

        public string GetUserReferralCode(int userId)
        {
            try { return _repository.GetUserReferralCode(userId); }
            catch (Exception ex) { Logger.Error("Failed to get referral code", ex); return ""; }
        }

        public string GenerateReferralCode(int userId)
        {
            try { return _repository.GenerateReferralCode(userId); }
            catch (Exception ex) { Logger.Error("Failed to generate referral code", ex); return "REF" + userId; }
        }

        public ReferralStats GetUserReferralStats(int userId)
        {
            try { return _repository.GetUserReferralStats(userId); }
            catch (Exception ex) { Logger.Error("Failed to get referral stats", ex); return new ReferralStats(); }
        }

        public UserRank GetUserRank(int userId)
        {
            try { return _repository.GetUserRank(userId); }
            catch (Exception ex) { Logger.Error("Failed to get user rank", ex); return new UserRank(); }
        }

        public List<LevelBreakdown> GetLevelBreakdown(int userId)
        {
            try { return _repository.GetLevelBreakdown(userId); }
            catch (Exception ex) { Logger.Error("Failed to get level breakdown", ex); return new List<LevelBreakdown>(); }
        }

        public List<TeamMember> GetUserTeam(int userId, int count)
        {
            try { return _repository.GetUserTeam(userId, count); }
            catch (Exception ex) { Logger.Error("Failed to get team", ex); return new List<TeamMember>(); }
        }

        public List<CommissionHistory> GetRecentCommissions(int userId, int count)
        {
            try { return _repository.GetRecentCommissions(userId, count); }
            catch (Exception ex) { Logger.Error("Failed to get commissions", ex); return new List<CommissionHistory>(); }
        }

        public List<CommissionHistory> GetCommissionHistory(int userId, int count)
        {
            try { return _repository.GetCommissionHistory(userId, count); }
            catch (Exception ex) { Logger.Error("Failed to get commission history", ex); return new List<CommissionHistory>(); }
        }
    }
}