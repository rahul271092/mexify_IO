using System;
using System.Collections.Generic;
using Mexify.DataAccess.Repositories;
using Mexify.Models;
using Mexify.Utilities;

namespace Mexify.Business.Services
{
    public class StakingService
    {
        private readonly StakingRepository _repository;

        public StakingService()
        {
            _repository = new StakingRepository();
        }

        public List<StakingPool> GetAvailablePools()
        {
            try { return _repository.GetAvailablePools(); }
            catch (Exception ex) { Logger.Error("Failed to get staking pools", ex); return new List<StakingPool>(); }
        }

        public StakingPool GetPoolById(int poolId)
        {
            try
            {
                return _repository.GetPoolById(poolId);
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get staking pool by ID: " + poolId, ex);
                return null;
            }
        }



        public StakingCommissionStats GetUserStakingCommissionStats(int userId)
        {
            try
            {
                return _repository.GetUserStakingCommissionStats(userId);
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get staking commission stats", ex);
                return new StakingCommissionStats();
            }
        }

        public List<StakingPool> GetActivePools()
        {
            try
            {
                return _repository.GetActivePools();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get active staking pools", ex);
                return new List<StakingPool>();
            }
        }



      


        public List<ActiveStake> GetActiveStakes(int userId)
        {
            try { return _repository.GetActiveStakes(userId); }
            catch (Exception ex) { Logger.Error("Failed to get active stakes", ex); return new List<ActiveStake>(); }
        }

        public List<StakingHistory> GetStakingHistory(int userId, int count)
        {
            try { return _repository.GetStakingHistory(userId, count); }
            catch (Exception ex) { Logger.Error("Failed to get staking history", ex); return new List<StakingHistory>(); }
        }

        public List<RewardClaim> GetRewardClaims(int userId, int count)
        {
            try { return _repository.GetRewardClaims(userId, count); }
            catch (Exception ex) { Logger.Error("Failed to get reward claims", ex); return new List<RewardClaim>(); }
        }

        public StakingStats GetUserStakingStats(int userId)
        {
            try { return _repository.GetUserStakingStats(userId); }
            catch (Exception ex) { Logger.Error("Failed to get staking stats", ex); return new StakingStats(); }
        }

        public StakingActionResult StakeTokens(int userId, int poolId, decimal amount)
        {
            try { return _repository.StakeTokens(userId, poolId, amount); }
            catch (Exception ex) { Logger.Error("Stake failed", ex); return new StakingActionResult { Success = false, ErrorMessage = "Staking failed." }; }
        }

        public StakingActionResult ClaimRewards(int userId, long stakeId)
        {
            try { return _repository.ClaimRewards(userId, stakeId); }
            catch (Exception ex) { Logger.Error("Claim failed", ex); return new StakingActionResult { Success = false, ErrorMessage = "Claim failed." }; }
        }

        public StakingActionResult UnstakeTokens(int userId, long stakeId)
        {
            try { return _repository.UnstakeTokens(userId, stakeId); }
            catch (Exception ex) { Logger.Error("Unstake failed", ex); return new StakingActionResult { Success = false, ErrorMessage = "Unstaking failed." }; }
        }

        public List<RewardsHistoryPoint> GetRewardsHistory(int userId, int days)
        {
            try { return _repository.GetRewardsHistory(userId, days); }
            catch (Exception ex) { Logger.Error("Failed to get rewards history", ex); return new List<RewardsHistoryPoint>(); }
        }
    }
}