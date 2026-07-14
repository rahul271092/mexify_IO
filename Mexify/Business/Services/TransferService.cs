using System;
using System.Collections.Generic;
using Mexify.DataAccess.Repositories;
using Mexify.Models;
using Mexify.Utilities;

namespace Mexify.Business.Services
{
    public class TransferService
    {
        private readonly TransferRepository _repo;

        public TransferService()
        {
            _repo = new TransferRepository();
        }

        public List<UserWalletAddress> GetUserWalletAddresses(int userId)
            => _repo.GetUserWalletAddresses(userId);

        public string GetOrCreateWalletAddress(int userId, string currencyCode)
            => _repo.GetOrCreateWalletAddress(userId, currencyCode);

        public TransferResult SendTransfer(int fromUserId, string toAddress, string currencyCode, decimal amount, string memo = null)
        {
            // Validation
            if (string.IsNullOrWhiteSpace(toAddress))
                return new TransferResult { Success = false, Message = "Recipient address is required." };

            if (amount <= 0)
                return new TransferResult { Success = false, Message = "Amount must be greater than zero." };

            return _repo.ExecuteTransfer(fromUserId, toAddress, currencyCode, amount, memo);
        }

        public List<InternalTransfer> GetTransferHistory(int userId, int count = 20)
            => _repo.GetTransferHistory(userId, count);
    }
}