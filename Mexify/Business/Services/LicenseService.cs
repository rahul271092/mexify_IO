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

        public List<LicensePackage> GetActivePackages()
        {
            try { return _repository.GetActivePackages(); }
            catch (Exception ex) { Logger.Error("Failed to get license packages", ex); return new List<LicensePackage>(); }
        }

        public List<LicenseCommissionTier> GetCommissionTiers()
        {
            try { return _repository.GetCommissionTiers(); }
            catch (Exception ex) { Logger.Error("Failed to get commission tiers", ex); return new List<LicenseCommissionTier>(); }
        }

        public LicenseStats GetUserLicenseStats(int userId)
        {
            try { return _repository.GetUserLicenseStats(userId); }
            catch (Exception ex) { Logger.Error("Failed to get user license stats", ex); return new LicenseStats(); }
        }

        public LicensePurchaseResult PurchaseLicense(int userId, int packageId)
        {
            try { return _repository.PurchaseLicense(userId, packageId); }
            catch (Exception ex)
            {
                Logger.Error("Purchase license failed", ex);
                return new LicensePurchaseResult { Success = false, ErrorMessage = ex.Message };
            }
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