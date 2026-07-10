using System;
using System.Collections.Generic;
using Mexify.DataAccess.Repositories;
using Mexify.Models;
using Mexify.Utilities;

namespace Mexify.Business.Services
{
    public class TransactionService
    {
        private readonly TransactionRepository _repository;

        public TransactionService()
        {
            _repository = new TransactionRepository();
        }

        public TransactionPagedResult GetUserTransactionsPaged(TransactionFilter filter)
        {
            try { return _repository.GetUserTransactionsPaged(filter); }
            catch (Exception ex) { Logger.Error("Failed to get paged transactions", ex); return new TransactionPagedResult(); }
        }

        public TransactionSummary GetUserTransactionSummary(int userId)
        {
            try { return _repository.GetUserTransactionSummary(userId); }
            catch (Exception ex) { Logger.Error("Failed to get transaction summary", ex); return new TransactionSummary(); }
        }

        public List<UserTransaction> GetUserTransactionsByType(int userId, int type, int count)
        {
            try { return _repository.GetUserTransactionsByType(userId, type, count); }
            catch (Exception ex) { Logger.Error("Failed to get transactions by type", ex); return new List<UserTransaction>(); }
        }

        public TransactionStatsByType GetTransactionStatsByType(int userId, int type)
        {
            try { return _repository.GetTransactionStatsByType(userId, type); }
            catch (Exception ex) { Logger.Error("Failed to get transaction stats", ex); return new TransactionStatsByType(); }
        }

        public List<UserTransaction> GetUserEarnings(int userId, int count)
        {
            try { return _repository.GetUserEarnings(userId, count); }
            catch (Exception ex) { Logger.Error("Failed to get earnings", ex); return new List<UserTransaction>(); }
        }

        public EarningsBreakdown GetEarningsBreakdown(int userId)
        {
            try { return _repository.GetEarningsBreakdown(userId); }
            catch (Exception ex) { Logger.Error("Failed to get earnings breakdown", ex); return new EarningsBreakdown(); }
        }

        public List<VolumeHistoryPoint> GetVolumeHistory(int userId, int days)
        {
            try { return _repository.GetVolumeHistory(userId, days); }
            catch (Exception ex) { Logger.Error("Failed to get volume history", ex); return new List<VolumeHistoryPoint>(); }
        }

        public List<TypeDistributionItem> GetTypeDistribution(int userId)
        {
            try { return _repository.GetTypeDistribution(userId); }
            catch (Exception ex) { Logger.Error("Failed to get type distribution", ex); return new List<TypeDistributionItem>(); }
        }
    }
}