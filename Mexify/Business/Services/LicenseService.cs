using System;
using System.Collections.Generic;
using Mexify.DataAccess.Repositories;
using Mexify.Models;
using Mexify.Utilities;

namespace Mexify.Business.Services
{
    public class LicenseService
    {
        private readonly LicenseRepository _repository;

        public LicenseService()
        {
            _repository = new LicenseRepository();
        }

        public UserLicense GetUserActiveLicense(int userId)
        {
            try { return _repository.GetUserActiveLicense(userId); }
            catch (Exception ex) { Logger.Error("Failed to get user license", ex); return null; }
        }

        public List<LicenseHistoryItem> GetLicenseHistory(int userId)
        {
            try { return _repository.GetLicenseHistory(userId); }
            catch (Exception ex) { Logger.Error("Failed to get license history", ex); return new List<LicenseHistoryItem>(); }
        }

        public LicensePurchaseResult PurchaseLicense(int userId, string licenseType, decimal amount)
        {
            try
            {
                // Determine duration based on tier
                int days = 30; // Default Silver
                if (licenseType == "Gold") days = 90;
                if (licenseType == "Platinum") days = 365;

                DateTime expiry = DateTime.UtcNow.AddDays(days);

                var result = _repository.PurchaseLicense(userId, licenseType, amount, expiry);

                if (result.Success)
                {
                    // TODO: Log transaction in WalletService if not handled in SP
                    Logger.Info($"User {userId} purchased {licenseType} License for {amount} PNC");
                }

                return result;
            }
            catch (Exception ex)
            {
                Logger.Error("License purchase failed", ex);
                return new LicensePurchaseResult { Success = false, ErrorMessage = "Purchase failed." };
            }
        }
    }
}