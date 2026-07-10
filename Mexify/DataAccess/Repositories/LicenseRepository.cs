using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Mexify.Models;

namespace Mexify.DataAccess.Repositories
{
    public class LicenseRepository : BaseRepository
    {
        public UserLicense GetUserActiveLicense(int userId)
        {
            var results = ExecuteStoredProcedure<UserLicense>(
                "usp_GetUserActiveLicense",
                reader => new UserLicense
                {
                    LicenseId = GetSafeLong(reader, "LicenseId"),
                    LicenseType = GetSafeString(reader, "LicenseType") ?? "",
                    LicenseName = GetSafeString(reader, "LicenseName") ?? "",
                    IsActive = GetSafeBool(reader, "IsActive"),
                    StartDate = GetSafeDateTime(reader, "StartDate"),
                    ExpiryDate = GetSafeDateTime(reader, "ExpiryDate"),
                    Price = GetSafeDecimal(reader, "Price")
                },
                CreateParameter("@UserId", userId)
            );
            return results.Count > 0 ? results[0] : null;
        }

        public List<LicenseHistoryItem> GetLicenseHistory(int userId)
        {
            return ExecuteStoredProcedure<LicenseHistoryItem>(
                "usp_GetLicenseHistory",
                reader => new LicenseHistoryItem
                {
                    HistoryId = GetSafeLong(reader, "HistoryId"),
                    LicenseType = GetSafeString(reader, "LicenseType") ?? "",
                    LicenseName = GetSafeString(reader, "LicenseName") ?? "",
                    Amount = GetSafeDecimal(reader, "Amount"),
                    PurchaseDate = GetSafeDateTime(reader, "PurchaseDate"),
                    ExpiryDate = GetSafeDateTime(reader, "ExpiryDate"),
                    IsActive = GetSafeBool(reader, "IsActive")
                },
                CreateParameter("@UserId", userId)
            );
        }

        public LicensePurchaseResult PurchaseLicense(int userId, string licenseType, decimal amount, DateTime expiryDate)
        {
            var result = new LicensePurchaseResult();
            try
            {
                var outputId = new SqlParameter("@LicenseId", System.Data.SqlDbType.BigInt)
                {
                    Direction = System.Data.ParameterDirection.Output
                };
                var outputSuccess = new SqlParameter("@Success", System.Data.SqlDbType.Bit)
                {
                    Direction = System.Data.ParameterDirection.Output
                };
                var outputMessage = new SqlParameter("@Message", System.Data.SqlDbType.NVarChar, 500)
                {
                    Direction = System.Data.ParameterDirection.Output
                };

                ExecuteStoredProcedureNonQuery(
                    "usp_PurchaseLicense",
                    CreateParameter("@UserId", userId),
                    CreateParameter("@LicenseType", licenseType),
                    CreateParameter("@Amount", amount),
                    CreateParameter("@ExpiryDate", expiryDate),
                    outputId,
                    outputSuccess,
                    outputMessage
                );

                result.Success = outputSuccess.Value != DBNull.Value && Convert.ToBoolean(outputSuccess.Value);
                result.ErrorMessage = outputMessage.Value != DBNull.Value ? outputMessage.Value.ToString() : "";
                result.NewLicenseId = outputId.Value != DBNull.Value ? Convert.ToInt64(outputId.Value) : 0;
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.ErrorMessage = "Database error: " + ex.Message;
            }
            return result;
        }
    }
}