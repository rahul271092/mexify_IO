using Mexify.DataAccess.Repositories;
using Mexify.Utilities;
using Mexify.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Business.Services
{
    public class WalletService
    {
        private readonly WalletRepository _repository;

        public WalletService()
        {
            _repository = new WalletRepository();
        }

        /// <summary>
        /// Gets all wallets for a user
        /// </summary>
        public List<WalletInfo> GetUserWallets(int userId)
        {
            try { return _repository.GetUserWallets(userId); }
            catch (Exception ex) { Logger.Error("Failed to get user wallets", ex); return new List<WalletInfo>(); }
        }

        /// <summary>
        /// Gets a specific wallet by currency
        /// </summary>
        public WalletInfo GetUserWallet(int userId, int currencyId)
        {
            try { return _repository.GetUserWallet(userId, currencyId); }
            catch (Exception ex) { Logger.Error("Failed to get user wallet", ex); return null; }
        }

        /// <summary>
        /// Gets all supported currencies
        /// </summary>
        public List<CurrencyInfo> GetSupportedCurrencies()
        {
            try { return _repository.GetSupportedCurrencies(); }
            catch (Exception ex) { Logger.Error("Failed to get currencies", ex); return new List<CurrencyInfo>(); }
        }

        /// <summary>
        /// ✅ Gets currency details by ID (THIS METHOD WAS MISSING)
        /// </summary>
        public CurrencyInfo GetCurrencyById(int currencyId)
        {
            try { return _repository.GetCurrencyById(currencyId); }
            catch (Exception ex) { Logger.Error("Failed to get currency by ID: " + currencyId, ex); return null; }
        }

        /// <summary>
        /// Gets or generates deposit address
        /// </summary>
        public string GetDepositAddress(int userId, int currencyId)
        {
            try
            {
                string address = _repository.GetDepositAddress(userId, currencyId);
                if (string.IsNullOrEmpty(address))
                {
                    address = GeneratePlaceholderAddress(currencyId);
                }
                return address;
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get deposit address", ex);
                return "Error generating address";
            }
        }

        /// <summary>
        /// Gets user transaction history
        /// </summary>
        public List<WalletTransaction> GetUserTransactions(int userId, int count)
        {
            try { return _repository.GetUserTransactions(userId, count); }
            catch (Exception ex) { Logger.Error("Failed to get transactions", ex); return new List<WalletTransaction>(); }
        }

        /// <summary>
        /// Processes a withdrawal request
        /// </summary>
        public WithdrawalResult ProcessWithdrawal(int userId, int currencyId, string address, decimal amount, string twoFACode)
        {
            try
            {
                // Validate wallet exists and has sufficient balance
                var wallet = _repository.GetUserWallet(userId, currencyId);
                if (wallet == null)
                {
                    return new WithdrawalResult { Success = false, ErrorMessage = "Wallet not found." };
                }

                var currency = _repository.GetCurrencyById(currencyId);
                if (currency == null)
                {
                    return new WithdrawalResult { Success = false, ErrorMessage = "Currency not supported." };
                }

                // Validate amount
                if (amount < currency.MinWithdrawal)
                {
                    return new WithdrawalResult
                    {
                        Success = false,
                        ErrorMessage = string.Format("Minimum withdrawal is {0:0.########} {1}.", currency.MinWithdrawal, currency.CurrencyCode)
                    };
                }

                decimal totalRequired = amount + currency.WithdrawalFee;
                if (wallet.Balance < totalRequired)
                {
                    return new WithdrawalResult
                    {
                        Success = false,
                        ErrorMessage = string.Format("Insufficient balance. You need {0:0.########} {1} (including fee).", totalRequired, currency.CurrencyCode)
                    };
                }

                // TODO: Verify 2FA code against user's 2FA secret
                // For now, accept any 6-digit code

                // Process the withdrawal
                return _repository.ProcessWithdrawal(userId, currencyId, address, amount, twoFACode);
            }
            catch (Exception ex)
            {
                Logger.Error("Withdrawal failed", ex);
                return new WithdrawalResult { Success = false, ErrorMessage = "An error occurred. Please try again." };
            }
        }

        /// <summary>
        /// Generates a placeholder address (in production, call blockchain API)
        /// </summary>
        private string GeneratePlaceholderAddress(int currencyId)
        {
            var currency = _repository.GetCurrencyById(currencyId);
            string code = currency?.CurrencyCode ?? "USDT";
            return code.ToUpper() + "0x" + Guid.NewGuid().ToString("N").Substring(0, 32).ToUpper();
        }

    }
}