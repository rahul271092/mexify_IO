using System;
using System.Collections.Generic;
using System.Linq;
using Mexify.DataAccess.Repositories;
using Mexify.Models;
using Mexify.Utilities;
using Mexify.Web.Models;

namespace Mexify.Business.Services
{
    /// <summary>
    /// Business logic layer for all mining-related operations.
    /// Acts as a bridge between the UI (Mining.aspx.cs) and the data layer (MiningRepository).
    /// </summary>
    public class MiningService
    {
        private readonly MiningRepository _repo;

        public MiningService()
        {
            _repo = new MiningRepository();
        }

        public List<MiningPlanViewModel> GetActiveContracts()
        {
            return GetActiveMiningPlans();
        }

        // ✅ PASTE THE NEW METHODS HERE
        public List<MiningPlanViewModel> GetActivePlans()
        {
            return GetActiveMiningPlans();
        }

        public MiningPlanViewModel GetPlanById(int planId)
        {
            return GetMiningPlanById(planId);
        }

        // =========================================
        // 1. MINING PLANS (UI-Facing)
        // =========================================

        /// <summary>
        /// Gets all active mining plans available for purchase (returns ViewModel for UI).
        /// </summary>
        public List<MiningPlanViewModel> GetActiveMiningPlans()
        {
            try
            {
                return _repo.GetActiveMiningPlans();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get active mining plans", ex);
                return new List<MiningPlanViewModel>();
            }
        }

        /// <summary>
        /// Alias for GetActiveMiningPlans - used by Mining.aspx.cs
        /// </summary>
        //public List<MiningPlanViewModel> GetActiveContracts()
        //{
        //    return GetActiveMiningPlans();
        //}

        /// <summary>
        /// Gets a specific mining plan by its ID.
        /// </summary>
        public MiningPlanViewModel GetMiningPlanById(int planId)
        {
            try
            {
                var plans = GetActiveMiningPlans();
                return plans.FirstOrDefault(p => p.MiningPlanId == planId);
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get mining plan by ID: " + planId, ex);
                return null;
            }
        }

        // =========================================
        // 2. USER MINING CONTRACTS
        // =========================================

        /// <summary>
        /// Gets ALL mining contracts for a user (active, expired, stopped).
        /// </summary>
        public List<MiningContract> GetUserMiningContracts(int userId)
        {
            try
            {
                return _repo.GetUserMiningContracts(userId) ?? new List<MiningContract>();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get user mining contracts for user " + userId, ex);
                return new List<MiningContract>();
            }
        }

        /// <summary>
        /// Gets only ACTIVE mining contracts for a user.
        /// </summary>
        public List<MiningContract> GetUserActiveContracts(int userId)
        {
            try
            {
                var all = GetUserMiningContracts(userId);
                return all.Where(c => c.Status == 1).ToList();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get user active contracts for user " + userId, ex);
                return new List<MiningContract>();
            }
        }

        // =========================================
        // 3. MINING STATS & SUMMARY
        // =========================================

        /// <summary>
        /// Gets detailed mining statistics for a user (used by Mmining.aspx.cs).
        /// </summary>
        public MiningStats GetUserMiningStats(int userId)
        {
            try
            {
                var result = _repo.GetUserMiningStats(userId);
                return result ?? new MiningStats();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get mining stats for user " + userId, ex);
                return new MiningStats();
            }
        }

        /// <summary>
        /// Gets a simplified mining summary for the dashboard (used by Mining.aspx.cs).
        /// Maps MiningStats to MiningSummary for the UI.
        /// </summary>
        public MiningSummary GetUserMiningSummary(int userId)
        {
            try
            {
                var stats = GetUserMiningStats(userId);
                
                // Calculate total invested from active contracts
                var activeContracts = GetUserActiveContracts(userId);
                decimal totalInvested = 0;
                foreach (var contract in activeContracts)
                {
                    // Estimate invested amount from plan price (stored in contract or calculated)
                    totalInvested += contract.TotalEarned > 0 
                        ? contract.TotalEarned * 2 
                        : 0;
                }

                return new MiningSummary
                {
                    TotalHashrate = stats.TotalHashrate,
                    ActiveContracts = stats.ActiveRigs,
                    DailyRewards = stats.DailyEarning,
                    TotalEarned = stats.TotalEarned,
                    TotalInvested = totalInvested,
                    MonthRewards = stats.ThisMonthEarnings,
                    TodayRewards = stats.TodayEarnings
                };
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get mining summary for user " + userId, ex);
                return new MiningSummary();
            }
        }

        // =========================================
        // 4. EARNINGS & REWARDS
        // =========================================

        /// <summary>
        /// Gets mining earnings history for a user (used by Mmining.aspx.cs).
        /// </summary>
        public List<MiningEarning> GetUserMiningEarnings(int userId, int count)
        {
            try
            {
                return _repo.GetUserMiningEarnings(userId, count) ?? new List<MiningEarning>();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get mining earnings for user " + userId, ex);
                return new List<MiningEarning>();
            }
        }

        /// <summary>
        /// Gets full mining history (alias for GetUserMiningEarnings).
        /// Used by Mining.aspx.cs
        /// </summary>
        public List<MiningEarning> GetUserMiningHistory(int userId)
        {
            return GetUserMiningEarnings(userId, 50);
        }

        /// <summary>
        /// Gets recent reward claims for a user.
        /// Used by Mining.aspx.cs
        /// </summary>
        public List<MiningEarning> GetUserRewards(int userId, int count)
        {
            return GetUserMiningEarnings(userId, count);
        }

        // =========================================
        // 5. CHART DATA
        // =========================================

        /// <summary>
        /// Gets mining performance history for charts (used by Mmining.aspx.cs).
        /// </summary>
        public List<ChartDataPoint> GetMiningPerformanceHistory(int userId, int days)
        {
            try
            {
                return _repo.GetMiningPerformanceHistory(userId, days) ?? new List<ChartDataPoint>();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get mining performance history for user " + userId, ex);
                return new List<ChartDataPoint>();
            }
        }

        /// <summary>
        /// Gets rewards history for charts (alias for GetMiningPerformanceHistory).
        /// Used by Mining.aspx.cs
        /// </summary>
        public List<ChartDataPoint> GetRewardsHistory(int userId, int days)
        {
            return GetMiningPerformanceHistory(userId, days);
        }

        /// <summary>
        /// Gets hashrate distribution grouped by plan name for pie/doughnut chart.
        /// Returns List<DistributionItem> with Name and Value properties.
        /// </summary>
        public List<DistributionItem> GetHashrateDistribution(int userId)
        {
            try
            {
                var contracts = GetUserActiveContracts(userId);
                var grouped = new Dictionary<string, decimal>();

                foreach (var contract in contracts)
                {
                    string name = string.IsNullOrEmpty(contract.PlanName) ? "Other" : contract.PlanName;
                    if (!grouped.ContainsKey(name))
                        grouped[name] = 0;
                    grouped[name] += contract.Hashrate;
                }

                var result = new List<DistributionItem>();
                foreach (var kvp in grouped)
                {
                    result.Add(new DistributionItem
                    {
                        Name = kvp.Key,
                        Value = kvp.Value
                    });
                }

                return result;
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get hashrate distribution for user " + userId, ex);
                return new List<DistributionItem>();
            }
        }

        // =========================================
        // 6. PURCHASE CONTRACT
        // =========================================

        /// <summary>
        /// Purchases a new mining contract for a user.
        /// Deducts payment from USDT wallet and creates contract record.
        /// </summary>
        public PurchaseResult PurchaseMiningContract(int userId, int planId)
        {
            try
            {
                // Validate plan exists
                var plan = GetMiningPlanById(planId);
                if (plan == null)
                {
                    return new PurchaseResult
                    {
                        Success = false,
                        ErrorMessage = "Invalid or inactive mining plan."
                    };
                }

                return _repo.PurchaseMiningContract(userId, planId);
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to purchase mining contract for user " + userId, ex);
                return new PurchaseResult
                {
                    Success = false,
                    ErrorMessage = "System error: " + ex.Message
                };
            }
        }

        // =========================================
        // 7. CONTRACT MANAGEMENT
        // =========================================

        /// <summary>
        /// Claims pending rewards from an active mining contract.
        /// </summary>
        public ClaimResult ClaimMiningRewards(int userId, long contractId)
        {
            try
            {
                return _repo.ClaimMiningRewards(userId, contractId);
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to claim mining rewards", ex);
                return new ClaimResult
                {
                    Success = false,
                    ErrorMessage = "System error: " + ex.Message
                };
            }
        }

        /// <summary>
        /// Unstakes from an expired mining contract and returns principal.
        /// </summary>
        public ClaimResult UnstakeMiningContract(int userId, long contractId)
        {
            try
            {
                return _repo.UnstakeMiningContract(userId, contractId);
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to unstake mining contract", ex);
                return new ClaimResult
                {
                    Success = false,
                    ErrorMessage = "System error: " + ex.Message
                };
            }
        }
    }

    // =========================================
    // SUPPORTING MODELS
    // =========================================

    /// <summary>
    /// Simplified mining summary for dashboard display.
    /// </summary>
    public class MiningSummary
    {
        public decimal TotalHashrate { get; set; }
        public int ActiveContracts { get; set; }
        public decimal DailyRewards { get; set; }
        public decimal TotalEarned { get; set; }
        public decimal TotalInvested { get; set; }
        public decimal MonthRewards { get; set; }
        public decimal TodayRewards { get; set; }
    }

    /// <summary>
    /// Distribution item for chart data (Name + Value).
    /// </summary>
    public class DistributionItem
    {
        public string Name { get; set; }
        public decimal Value { get; set; }
    }

    /// <summary>
    /// Result of purchasing a mining contract.
    /// </summary>
   
    /// <summary>
    /// Result of claiming rewards or unstaking.
    /// </summary>
    public class ClaimResult
    {
        public bool Success { get; set; }
        public string ErrorMessage { get; set; }
        public decimal Amount { get; set; }
    }
}