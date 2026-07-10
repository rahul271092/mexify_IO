using Mexify.DataAccess.Repositories;
using Mexify.Web.Models;
using Mexify.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Mexify.Models;

namespace Mexify.Business.Services
{
    public class InvestmentService
    {
        public InvestmentRepository _repository;

        public InvestmentService()
        {
            _repository = new InvestmentRepository();
        }

        /// <summary>
        /// Creates a new 2X ROI investment with fee distribution
        /// </summary>
        public InvestmentResult CreateInvestment(int userId, int planId, decimal amount)
        {
            var result = new InvestmentResult();
            try
            {
                // Create OUTPUT parameters
                var outputId = new SqlParameter("@InvestmentId", SqlDbType.BigInt)
                {
                    Direction = ParameterDirection.Output
                };

                var outputSuccess = new SqlParameter("@Success", SqlDbType.Bit)
                {
                    Direction = ParameterDirection.Output
                };

                var outputMessage = new SqlParameter("@Message", SqlDbType.NVarChar, 500)
                {
                    Direction = ParameterDirection.Output
                };

                // Execute the stored procedure
                _repository.ExecuteStoredProcedureNonQuery(
                    "usp_CreateInvestment",
                    _repository.CreateParameter("@UserId", userId),
                    _repository.CreateParameter("@PlanId", planId),
                    _repository.CreateParameter("@Amount", amount),
                    _repository.CreateParameter("@ParentInvestmentId", DBNull.Value),
                    _repository.CreateParameter("@ReinvestCount", 0),
                    _repository.CreateParameter("@AutoReinvest", true),
                    outputId,
                    outputSuccess,
                    outputMessage
                );

                // Read OUTPUT parameter values
                result.Success = outputSuccess.Value != DBNull.Value && Convert.ToBoolean(outputSuccess.Value);
                result.ErrorMessage = outputMessage.Value != DBNull.Value ? outputMessage.Value.ToString() : "";
                result.InvestmentId = outputId.Value != DBNull.Value ? Convert.ToInt64(outputId.Value) : 0;

                if (result.Success)
                {
                    Logger.Info("User " + userId + " created investment " + result.InvestmentId + " for " + amount + " PNC");
                }
                else
                {
                    Logger.Info("Investment creation failed for user " + userId + ": " + result.ErrorMessage);
                }
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.ErrorMessage = "An error occurred: " + ex.Message;
                Logger.Error("Create investment failed", ex);
            }
            return result;
        }

        /// <summary>
        /// Gets the 2X ROI plan (only one plan now)
        /// </summary>
        public InvestmentPlan Get2XPlan()
        {
            try
            {
                var plans = _repository.GetActivePlans();
                foreach (var plan in plans)
                {
                    if (plan.PlanName.Contains("2X") || plan.PlanName.Contains("ROI"))
                        return plan;
                }
                return plans.Count > 0 ? plans[0] : null;
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get 2X plan", ex);
                return null;
            }
        }

        /// <summary>
        /// Calculates fee breakdown for display
        /// </summary>
        public FeeBreakdown CalculateFees(decimal amount)
        {
            var plan = Get2XPlan();
            if (plan == null) return new FeeBreakdown();

            decimal depositFee = amount * plan.DepositFeePercent / 100;
            decimal withdrawalFee = amount * plan.WithdrawalFeePercent / 100;
            decimal directReferral = amount * plan.DirectReferralPercent / 100;
            decimal adminFee = amount * plan.AdminFeePercent / 100;
            decimal royaltyFee = amount * plan.RoyaltyPercent / 100;
            decimal totalFees = depositFee;
            decimal investmentPool = amount + depositFee;

            return new FeeBreakdown
            {
                Amount = amount,
                DepositFee = depositFee,
                WithdrawalFee = withdrawalFee,
                DirectReferral = directReferral,
                AdminFee = adminFee,
                RoyaltyFee = royaltyFee,
                InvestmentPool = investmentPool,
                TotalFees = totalFees,
                TotalReturn = amount * 2, // 2X return
                NetProfit = amount, // 100% profit
                DailyROI = investmentPool * plan.DailyROI / 100,
                DurationDays = plan.DurationDays
            };
        }

        /// <summary>
        /// Gets all active investment plans.
        /// </summary>
        public List<InvestmentPlan> GetActivePlans()
        {
            try
            {
                return _repository.GetActivePlans();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load investment plans", ex);
                return new List<InvestmentPlan>();
            }
        }

        /// <summary>
        /// Gets a specific investment plan by ID.
        /// </summary>
        public InvestmentPlan GetPlanById(int planId)
        {
            try
            {
                return _repository.GetPlanById(planId);
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load investment plan " + planId, ex);
                return null;
            }
        }

        /// <summary>
        /// Gets user investment statistics
        /// </summary>
        public InvestmentStats GetUserInvestmentStats(int userId)
        {
            try
            {
                return _repository.GetUserInvestmentStats(userId);
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get investment stats", ex);
                return new InvestmentStats();
            }
        }

        /// <summary>
        /// Gets user's active investments
        /// </summary>
        public List<UserInvestment> GetUserActiveInvestments(int userId)
        {
            try
            {
                return _repository.GetUserActiveInvestments(userId);
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get active investments", ex);
                return new List<UserInvestment>();
            }
        }

        /// <summary>
        /// Gets user's matured investments
        /// </summary>
        public List<UserInvestment> GetUserMaturedInvestments(int userId)
        {
            try
            {
                return _repository.GetUserMaturedInvestments(userId);
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get matured investments", ex);
                return new List<UserInvestment>();
            }
        }

        /// <summary>
        /// Gets all user investments (history)
        /// </summary>
        public List<UserInvestment> GetUserAllInvestments(int userId)
        {
            try
            {
                return _repository.GetUserAllInvestments(userId);
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get all investments", ex);
                return new List<UserInvestment>();
            }
        }
    }

    /// <summary>
    /// Result of investment creation
    /// </summary>
    public class InvestmentResult
    {
        public bool Success { get; set; }
        public string ErrorMessage { get; set; }
        public long InvestmentId { get; set; }
    }

    /// <summary>
    /// Fee breakdown for display
    /// </summary>
    public class FeeBreakdown
    {
        public decimal Amount { get; set; }
        public decimal DepositFee { get; set; }
        public decimal WithdrawalFee { get; set; }
        public decimal DirectReferral { get; set; }
        public decimal AdminFee { get; set; }
        public decimal RoyaltyFee { get; set; }
        public decimal InvestmentPool { get; set; }
        public decimal TotalFees { get; set; }
        public decimal TotalReturn { get; set; }
        public decimal NetProfit { get; set; }
        public decimal DailyROI { get; set; }
        public int DurationDays { get; set; }
    }
}