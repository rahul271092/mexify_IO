using System;
using System.Collections.Generic;
using Mexify.DataAccess.Repositories;
using Mexify.Models;
using Mexify.Utilities;
using Mexify.Web.Models;

namespace Mexify.Business.Services
{
    public class UserStakingService
    {
        private readonly UserStakingRepository _repository;

        public UserStakingService()
        {
            _repository = new UserStakingRepository();
        }

        public UserStakingSummary GetUserStakingSummary(int userId)
        {
            try { return _repository.GetUserStakingSummary(userId); }
            catch (Exception ex) { Logger.Error("Failed to get staking summary", ex); return new UserStakingSummary(); }
        }

        public List<StakingPlan> GetActivePools()
        {
            try { return _repository.GetActivePools(); }
            catch (Exception ex) { Logger.Error("Failed to get staking pools", ex); return new List<StakingPlan>(); }
        }

        public List<UserStake> GetUserActiveStakes(int userId)
        {
            try { return _repository.GetUserActiveStakes(userId); }
            catch (Exception ex) { Logger.Error("Failed to get active stakes", ex); return new List<UserStake>(); }
        }

        public List<UserStake> GetUserStakingHistory(int userId)
        {
            try { return _repository.GetUserStakingHistory(userId); }
            catch (Exception ex) { Logger.Error("Failed to get staking history", ex); return new List<UserStake>(); }
        }

        public List<StakeReward> GetUserRewards(int userId, int count)
        {
            try { return _repository.GetUserRewards(userId, count); }
            catch (Exception ex) { Logger.Error("Failed to get rewards", ex); return new List<StakeReward>(); }
        }

        public List<RewardsHistoryPoint> GetRewardsHistory(int userId, int days)
        {
            try { return _repository.GetRewardsHistory(userId, days); }
            catch (Exception ex) { Logger.Error("Failed to get rewards history", ex); return new List<RewardsHistoryPoint>(); }
        }

        public List<StakeDistributionItem> GetStakeDistribution(int userId)
        {
            try { return _repository.GetStakeDistribution(userId); }
            catch (Exception ex) { Logger.Error("Failed to get distribution", ex); return new List<StakeDistributionItem>(); }
        }

        internal object GetUserStakingCommissionStats(int _userId)
        {
            throw new NotImplementedException();
        }
    }
}