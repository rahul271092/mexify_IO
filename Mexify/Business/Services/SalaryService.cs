using System;
using System.Collections.Generic;
using Mexify.DataAccess.Repositories;
using Mexify.Models;
using Mexify.Utilities;
using Mexify.Web.Models;

namespace Mexify.Business.Services
{
    public class SalaryService
    {
        private readonly SalaryRepository _repository;

        public SalaryService()
        {
            _repository = new SalaryRepository();
        }

        /// <summary>
        /// Gets the user's current salary details including tier information
        /// </summary>
        public Models.UserSalaryDetails GetUserSalaryDetails(int userId)
        {
            try
            {
                return _repository.GetUserSalaryDetails(userId);
            }
            catch (Exception ex)
            {
                Logger.Error($"Failed to get salary details for user {userId}", ex);
                return new Models.UserSalaryDetails();
            }
        }

        /// <summary>
        /// Gets all investor tiers with the user's current status (qualified, current tier, etc.)
        /// </summary>
        public List<InvestorTier> GetAllTiersWithUserStatus(int userId)
        {
            try
            {
                return _repository.GetAllTiersWithUserStatus(userId);
            }
            catch (Exception ex)
            {
                Logger.Error($"Failed to get tiers with user status for user {userId}", ex);
                return new List<InvestorTier>();
            }
        }

        /// <summary>
        /// Gets all investor tiers (basic info only)
        /// </summary>
        public List<InvestorTier> GetAllTiers()
        {
            try
            {
                return _repository.GetAllTiers();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get all investor tiers", ex);
                return new List<InvestorTier>();
            }
        }


        public Tuple<bool, string, long> Subscribe(int userId, int planId)
        {
            try
            {
                return _repository.Subscribe(userId, planId);
            }
            catch (Exception ex)
            {
                Logger.Error($"Failed to subscribe user {userId} to plan {planId}", ex);
                return new Tuple<bool, string, long>(false, "An error occurred while subscribing. Please try again.", 0);
            }
        }


        //public InvestorTier GetFirstTierRequirements()
        //{
        //    return ExecuteStoredProcedure<InvestorTier>(
        //        "usp_GetFirstTierRequirements",
        //        reader => new InvestorTier
        //        {
        //            TierId = GetSafeInt(reader, "TierId"),
        //            TierCode = GetSafeString(reader, "TierCode") ?? "",
        //            TierName = GetSafeString(reader, "TierName") ?? "",
        //            TierLevel = GetSafeInt(reader, "TierLevel"),
        //            SelfInvestment = GetSafeDecimal(reader, "SelfInvestment"),
        //            StrongLegVolume = GetSafeDecimal(reader, "StrongLegVolume"),
        //            WeakerLegVolume = GetSafeDecimal(reader, "WeakerLegVolume"),
        //            MonthlySalary = GetSafeDecimal(reader, "MonthlySalary"),
        //            Requirements = GetSafeString(reader, "Requirements"),
        //            IsActive = GetSafeBool(reader, "IsActive")
        //        }
        //    ).FirstOrDefault();
        //}


        /// <summary>
        /// Gets the user's progress toward the next tier
        /// </summary>
        public List<TierProgress> GetNextTierProgress(int userId)
        {
            try
            {
                return _repository.GetNextTierProgress(userId);
            }
            catch (Exception ex)
            {
                Logger.Error($"Failed to get tier progress for user {userId}", ex);
                return new List<TierProgress>();
            }
        }

        /// <summary>
        /// Gets the user's salary payment history
        /// </summary>
        public List<SalaryRecord> GetUserSalaryHistory(int userId, int count = 20)
        {
            try
            {
                return _repository.GetUserSalaryHistory(userId, count);
            }
            catch (Exception ex)
            {
                Logger.Error($"Failed to get salary history for user {userId}", ex);
                return new List<SalaryRecord>();
            }
        }

        /// <summary>
        /// Gets aggregated salary statistics for the user
        /// </summary>
        public Models.SalaryStats GetUserSalaryStats(int userId)
        {
            try
            {
                return _repository.GetUserSalaryStats(userId);
            }
            catch (Exception ex)
            {
                Logger.Error($"Failed to get salary stats for user {userId}", ex);
                return new Models.SalaryStats();
            }
        }

        /// <summary>
        /// Gets all active salary plans with user eligibility information
        /// </summary>
        public List<SalaryPlan> GetActivePlans(int? userId = null)
        {
            try
            {
                return _repository.GetActivePlans(userId);
            }
            catch (Exception ex)
            {
                Logger.Error($"Failed to get active salary plans for user {userId}", ex);
                return new List<SalaryPlan>();
            }
        }

        /// <summary>
        /// Subscribes a user to a salary plan
        /// </summary>
        /// <returns>Tuple containing: Success status, Message, Subscription ID</returns>
        //public Tuple<bool, string, long> Subscribe(int userId, int planId)
        //{
        //    try
        //    {
        //        return _repository.Subscribe(userId, planId);
        //    }
        //    catch (Exception ex)
        //    {
        //        Logger.Error($"Failed to subscribe user {userId} to plan {planId}", ex);
        //        return new Tuple<bool, string, long>(false, "An error occurred while subscribing. Please try again.", 0);
        //    }
        //}

        /// <summary>
        /// Checks if a user is qualified for a specific tier
        /// </summary>
        public bool IsUserQualifiedForTier(int userId, int tierId)
        {
            try
            {
                var tiers = _repository.GetAllTiersWithUserStatus(userId);
                var tier = tiers.Find(t => t.TierId == tierId);

                if (tier == null)
                    return false;

                var userDetails = _repository.GetUserSalaryDetails(userId);

                return userDetails.SelfInvestment >= tier.SelfInvestment
                    && userDetails.StrongLegVolume >= tier.StrongLegVolume
                    && userDetails.WeakerLegVolume >= tier.WeakerLegVolume;
            }
            catch (Exception ex)
            {
                Logger.Error($"Failed to check qualification for user {userId} and tier {tierId}", ex);
                return false;
            }
        }

        /// <summary>
        /// Gets the user's current tier information
        /// </summary>
        public InvestorTier GetUserCurrentTier(int userId)
        {
            try
            {
                var details = _repository.GetUserSalaryDetails(userId);

                if (details.CurrentTierId == null || details.CurrentTierId == 0)
                    return null;

                var tiers = _repository.GetAllTiersWithUserStatus(userId);
                return tiers.Find(t => t.TierId == details.CurrentTierId);
            }
            catch (Exception ex)
            {
                Logger.Error($"Failed to get current tier for user {userId}", ex);
                return null;
            }
        }

        /// <summary>
        /// Calculates the estimated time to reach the next tier based on current progress
        /// </summary>
        public string GetEstimatedTimeToNextTier(int userId)
        {
            try
            {
                var progress = _repository.GetNextTierProgress(userId);
                var nextTier = progress.Find(p => p.IsNextTier);

                if (nextTier == null)
                    return "N/A";

                // This is a simplified calculation - you may need to adjust based on your business logic
                var overallProgress = nextTier.OverallProgress;

                if (overallProgress >= 100)
                    return "Ready to upgrade!";

                if (overallProgress == 0)
                    return "No progress yet";

                // Assuming linear progress (you may need to adjust this)
                var remainingProgress = 100 - overallProgress;
                var daysEstimate = (int)(remainingProgress / 5); // Assuming 5% progress per day on average

                if (daysEstimate <= 0)
                    return "Very soon";
                if (daysEstimate == 1)
                    return "1 day";
                if (daysEstimate < 30)
                    return $"{daysEstimate} days";
                if (daysEstimate < 365)
                    return $"{daysEstimate / 30} months";

                return $"{daysEstimate / 365} years";
            }
            catch (Exception ex)
            {
                Logger.Error($"Failed to calculate estimated time for user {userId}", ex);
                return "Unknown";
            }
        }
    }
}