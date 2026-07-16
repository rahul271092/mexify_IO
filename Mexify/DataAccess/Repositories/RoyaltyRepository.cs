using Mexify.Web.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Mexify.DataAccess.Repositories
{
    public class RoyaltyRepository : BaseRepository
    {

        //public List<RoyaltyLicense> GetActiveLicenses()
        //{
        //    return ExecuteStoredProcedure<RoyaltyLicense>(
        //        "usp_GetActiveRoyaltyLicenses",
        //        reader => new RoyaltyLicense
        //        {
        //            LicenseId = GetSafeInt(reader, "LicenseId"),
        //            LicenseName = GetSafeString(reader, "LicenseName") ?? "",
        //            Description = GetSafeString(reader, "Description") ?? "",
        //            Price = GetSafeDecimal(reader, "Price"),
        //            DurationDays = GetSafeInt(reader, "DurationDays"),
        //            CommissionPercent = GetSafeDecimal(reader, "CommissionPercent"),
        //            MinInvestment = GetSafeDecimal(reader, "MinInvestment"),
        //            MaxInvestment = reader.IsDBNull(reader.GetOrdinal("MaxInvestment"))
        //                ? (decimal?)null : GetSafeDecimal(reader, "MaxInvestment"),
        //            IsActive = GetSafeBool(reader, "IsActive")
        //        }
        //    );
        //}

        public List<RoyaltyLicense> GetActiveLicenses()
        {
            return ExecuteStoredProcedure<RoyaltyLicense>(
                "usp_GetActiveRoyaltyLicenses",
                reader => MapLicense(reader)
            );
        }

        public RoyaltyLicense GetLicenseById(int licenseId)
        {
            var results = ExecuteStoredProcedure<RoyaltyLicense>(
                "usp_GetRoyaltyLicenseById",
                reader => MapLicense(reader),
                CreateParameter("@LicenseId", licenseId)
            );
            return results.Count > 0 ? results[0] : null;
        }

        private RoyaltyLicense MapLicense(SqlDataReader reader)
        {
            return new RoyaltyLicense
            {
                LicenseId = GetSafeInt(reader, "LicenseId"),
                Title = GetSafeString(reader, "Title") ?? "Untitled License",
                AssetType = GetSafeString(reader, "AssetType") ?? "General",
                Description = GetSafeString(reader, "Description"),
                SharePrice = GetSafeDecimal(reader, "Price"),
                TotalShares = GetSafeInt(reader, "TotalShares"),
                SharesAvailable = GetSafeInt(reader, "SharesAvailable"),
                RoyaltyRate = GetSafeDecimal(reader, "RoyaltyRate"),
                CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "PNC",
                IsPremium = GetSafeBool(reader, "IsPremium"),
                IsActive = GetSafeBool(reader, "IsActive"),
                CreatedDate = GetSafeDateTime(reader, "CreatedDate")
            };
        }
    }
}