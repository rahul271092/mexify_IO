using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Mexify.Models;
using Mexify.Utilities;

namespace Mexify.DataAccess.Repositories
{
    public class UserProfileRepository : BaseRepository
    {
        public UserProfile GetUserProfile(int userId)
        {
            var results = ExecuteStoredProcedure<UserProfile>(
                "usp_GetUserProfile",
                reader => new UserProfile
                {
                    UserId = GetSafeInt(reader, "UserId"),
                    FirstName = GetSafeString(reader, "FirstName") ?? "",
                    LastName = GetSafeString(reader, "LastName") ?? "",
                    Email = GetSafeString(reader, "Email") ?? "",
                    Phone = GetSafeString(reader, "Phone"),
                    CountryId = reader.IsDBNull(reader.GetOrdinal("CountryId")) ? (int?)null : GetSafeInt(reader, "CountryId"),
                    CountryName = GetSafeString(reader, "CountryName"),
                    PhotoUrl = GetSafeString(reader, "PhotoUrl"),
                    Tier = GetSafeString(reader, "Tier") ?? "Standard",
                    ReferralCode = GetSafeString(reader, "ReferralCode"),
                    IsEmailVerified = GetSafeBool(reader, "IsEmailVerified"),
                    Is2FAEnabled = GetSafeBool(reader, "Is2FAEnabled"),
                    KYCStatus = GetSafeString(reader, "KYCStatus") ?? "Unverified",
                    CreatedDate = GetSafeDateTime(reader, "CreatedDate"),
                    LastLoginDate = reader.IsDBNull(reader.GetOrdinal("LastLoginDate")) ? (DateTime?)null : GetSafeDateTime(reader, "LastLoginDate")
                },
                CreateParameter("@UserId", userId)
            );
            return results.Count > 0 ? results[0] : null;
        }

        public UserProfileStats GetUserProfileStats(int userId)
        {
            var results = ExecuteStoredProcedure<UserProfileStats>(
                "usp_GetUserProfileStats",
                reader => new UserProfileStats
                {
                    TotalInvested = GetSafeDecimal(reader, "TotalInvested"),
                    TotalEarned = GetSafeDecimal(reader, "TotalEarned"),
                    TeamSize = GetSafeInt(reader, "TeamSize"),
                    ActiveInvestments = GetSafeInt(reader, "ActiveInvestments")
                },
                CreateParameter("@UserId", userId)
            );
            return results.Count > 0 ? results[0] : new UserProfileStats();
        }

        public ProfileUpdateResult UpdateProfile(int userId, string firstName, string lastName, string phone, int? countryId, string photoUrl)
        {
            var result = new ProfileUpdateResult();
            try
            {
                var outputSuccess = new SqlParameter("@Success", System.Data.SqlDbType.Bit) { Direction = System.Data.ParameterDirection.Output };
                var outputMessage = new SqlParameter("@Message", System.Data.SqlDbType.NVarChar, 500) { Direction = System.Data.ParameterDirection.Output };

                ExecuteStoredProcedureNonQuery(
                    "usp_UpdateUserProfile",
                    CreateParameter("@UserId", userId),
                    CreateParameter("@FirstName", firstName),
                    CreateParameter("@LastName", lastName),
                    CreateParameter("@Phone", phone ?? (object)DBNull.Value),
                    CreateParameter("@CountryId", countryId ?? (object)DBNull.Value),
                    CreateParameter("@PhotoUrl", photoUrl ?? (object)DBNull.Value),
                    outputSuccess,
                    outputMessage
                );

                result.Success = outputSuccess.Value != DBNull.Value && Convert.ToBoolean(outputSuccess.Value);
                result.ErrorMessage = outputMessage.Value != DBNull.Value ? outputMessage.Value.ToString() : "";
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.ErrorMessage = "Database error: " + ex.Message;
                Logger.Error("Profile update failed", ex);
            }
            return result;
        }

        public ProfileUpdateResult ChangePassword(int userId, string currentPasswordHash, string newPasswordHash)
        {
            var result = new ProfileUpdateResult();
            try
            {
                var outputSuccess = new SqlParameter("@Success", System.Data.SqlDbType.Bit) { Direction = System.Data.ParameterDirection.Output };
                var outputMessage = new SqlParameter("@Message", System.Data.SqlDbType.NVarChar, 500) { Direction = System.Data.ParameterDirection.Output };

                ExecuteStoredProcedureNonQuery(
                    "usp_ChangeUserPassword",
                    CreateParameter("@UserId", userId),
                    CreateParameter("@CurrentPasswordHash", currentPasswordHash),
                    CreateParameter("@NewPasswordHash", newPasswordHash),
                    outputSuccess,
                    outputMessage
                );

                result.Success = outputSuccess.Value != DBNull.Value && Convert.ToBoolean(outputSuccess.Value);
                result.ErrorMessage = outputMessage.Value != DBNull.Value ? outputMessage.Value.ToString() : "";
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.ErrorMessage = "Database error: " + ex.Message;
                Logger.Error("Password change failed", ex);
            }
            return result;
        }

        public List<CountryInfo> GetCountries()
        {
            return ExecuteStoredProcedure<CountryInfo>(
                "usp_GetActiveCountries",
                reader => new CountryInfo
                {
                    CountryId = GetSafeInt(reader, "CountryId"),
                    CountryName = GetSafeString(reader, "CountryName") ?? ""
                }
            );
        }

        public List<LoginHistoryItem> GetLoginHistory(int userId, int count)
        {
            return ExecuteStoredProcedure<LoginHistoryItem>(
                "usp_GetUserLoginHistory",
                reader => new LoginHistoryItem
                {
                    LoginId = GetSafeLong(reader, "LoginId"),
                    Device = GetSafeString(reader, "Device") ?? "Unknown Device",
                    Location = GetSafeString(reader, "Location") ?? "Unknown",
                    Icon = GetSafeString(reader, "Icon") ?? "fas fa-desktop",
                    TimeAgo = GetSafeString(reader, "TimeAgo") ?? "Just now",
                    IsCurrent = GetSafeBool(reader, "IsCurrent"),
                    LoginDate = GetSafeDateTime(reader, "LoginDate")
                },
                CreateParameter("@UserId", userId),
                CreateParameter("@Count", count)
            );
        }

        public List<AccountActivityItem> GetAccountActivity(int userId, int count)
        {
            return ExecuteStoredProcedure<AccountActivityItem>(
                "usp_GetUserAccountActivity",
                reader => new AccountActivityItem
                {
                    Title = GetSafeString(reader, "Title") ?? "Activity",
                    Icon = GetSafeString(reader, "Icon") ?? "fas fa-circle",
                    IconBg = GetSafeString(reader, "IconBg") ?? "rgba(20, 184, 166, 0.15)",
                    IconColor = GetSafeString(reader, "IconColor") ?? "#14B8A6",
                    TimeAgo = GetSafeString(reader, "TimeAgo") ?? "Just now",
                    CreatedDate = GetSafeDateTime(reader, "CreatedDate")
                },
                CreateParameter("@UserId", userId),
                CreateParameter("@Count", count)
            );
        }

        public string GetUserPasswordHash(int userId)
        {
            var result = ExecuteStoredProcedureScalar<string>(
                "usp_GetUserPasswordHash",
                CreateParameter("@UserId", userId)
            );
            return result;
        }
    }
}