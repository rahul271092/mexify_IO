using System;

namespace Mexify.Models
{
    public class UserLicense
    {
        public long LicenseId { get; set; }
        public string LicenseType { get; set; } // Silver, Gold, Platinum
        public string LicenseName { get; set; }
        public bool IsActive { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime ExpiryDate { get; set; }
        public decimal Price { get; set; }
    }

    public class LicensePurchaseResult
    {
        public bool Success { get; set; }
        public string ErrorMessage { get; set; }
        public long NewLicenseId { get; set; }
    }

    public class LicenseHistoryItem
    {
        public long HistoryId { get; set; }
        public string LicenseType { get; set; }
        public string LicenseName { get; set; }
        public decimal Amount { get; set; }
        public DateTime PurchaseDate { get; set; }
        public DateTime ExpiryDate { get; set; }
        public bool IsActive { get; set; }
    }
}