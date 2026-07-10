using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Mexify.Models;

namespace Mexify.DataAccess.Repositories
{
    public class SecurityRepository : BaseRepository
    {
        public UserSecurityInfo GetUserSecurityInfo(int userId)
        {
            var results = ExecuteStoredProcedure<UserSecurityInfo>(
                "usp_GetUserSecurityInfo",
                reader => new UserSecurityInfo
                {
                    Email = GetSafeString(reader, "Email") ?? "",
                    Is2FAEnabled = GetSafeBool(reader, "Is2FAEnabled"),
                    IsEmailVerified = GetSafeBool(reader, "IsEmailVerified"),
                    AntiPhishingCode = GetSafeString(reader, "AntiPhishingCode"),
                    PasswordAgeDays = GetSafeInt(reader, "PasswordAgeDays"),
                    LastPasswordChange = reader.IsDBNull(reader.GetOrdinal("LastPasswordChange"))
                        ? (DateTime?)null : GetSafeDateTime(reader, "LastPasswordChange"),
                    PasswordStrength = GetSafeString(reader, "PasswordStrength") ?? "Unknown",
                    HasWhitelist = GetSafeBool(reader, "HasWhitelist"),
                    TwoFAEnabledDate = reader.IsDBNull(reader.GetOrdinal("TwoFAEnabledDate"))
                        ? (DateTime?)null : GetSafeDateTime(reader, "TwoFAEnabledDate"),
                    TwoFADaysActive = GetSafeInt(reader, "TwoFADaysActive"),
                    LoginAlerts = GetSafeBool(reader, "LoginAlerts"),
                    WithdrawAlerts = GetSafeBool(reader, "WithdrawAlerts"),
                    FailedLoginAlerts = GetSafeBool(reader, "FailedLoginAlerts"),
                    SettingsAlerts = GetSafeBool(reader, "SettingsAlerts")
                },
                CreateParameter("@UserId", userId)
            );
            return results.Count > 0 ? results[0] : new UserSecurityInfo();
        }

        public List<ActiveSession> GetActiveSessions(int userId)
        {
            return ExecuteStoredProcedure<ActiveSession>(
                "usp_GetUserActiveSessions",
                reader => new ActiveSession
                {
                    SessionId = GetSafeLong(reader, "SessionId"),
                    DeviceName = GetSafeString(reader, "DeviceName") ?? "Unknown Device",
                    DeviceIcon = GetSafeString(reader, "DeviceIcon") ?? "fas fa-desktop",
                    Location = GetSafeString(reader, "Location") ?? "Unknown",
                    Browser = GetSafeString(reader, "Browser") ?? "Unknown",
                    LastActive = GetSafeString(reader, "LastActive") ?? "Just now",
                    IsCurrent = GetSafeBool(reader, "IsCurrent"),
                    LoginDate = GetSafeDateTime(reader, "LoginDate")
                },
                CreateParameter("@UserId", userId)
            );
        }

        public List<WhitelistAddress> GetWhitelist(int userId)
        {
            return ExecuteStoredProcedure<WhitelistAddress>(
                "usp_GetUserWhitelist",
                reader => new WhitelistAddress
                {
                    WhitelistId = GetSafeLong(reader, "WhitelistId"),
                    Label = GetSafeString(reader, "Label") ?? "",
                    Address = GetSafeString(reader, "Address") ?? "",
                    CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "",
                    AddedDate = GetSafeDateTime(reader, "AddedDate")
                },
                CreateParameter("@UserId", userId)
            );
        }

        public List<SecurityActivity> GetSecurityActivity(int userId, int count)
        {
            return ExecuteStoredProcedure<SecurityActivity>(
                "usp_GetUserSecurityActivity",
                reader => new SecurityActivity
                {
                    ActivityId = GetSafeLong(reader, "ActivityId"),
                    TypeClass = GetSafeString(reader, "TypeClass") ?? "login",
                    Icon = GetSafeString(reader, "Icon") ?? "fas fa-circle",
                    Title = GetSafeString(reader, "Title") ?? "Activity",
                    Location = GetSafeString(reader, "Location") ?? "",
                    Device = GetSafeString(reader, "Device") ?? "",
                    CreatedDate = GetSafeDateTime(reader, "CreatedDate")
                },
                CreateParameter("@UserId", userId),
                CreateParameter("@Count", count)
            );
        }

        public SecurityActionResult UpdateNotificationPreferences(int userId, NotificationPreferences prefs)
        {
            var result = new SecurityActionResult();
            try
            {
                var outputSuccess = new SqlParameter("@Success", System.Data.SqlDbType.Bit) { Direction = System.Data.ParameterDirection.Output };
                var outputMessage = new SqlParameter("@Message", System.Data.SqlDbType.NVarChar, 500) { Direction = System.Data.ParameterDirection.Output };

                ExecuteStoredProcedureNonQuery(
                    "usp_UpdateNotificationPreferences",
                    CreateParameter("@UserId", userId),
                    CreateParameter("@LoginAlerts", prefs.LoginAlerts),
                    CreateParameter("@WithdrawAlerts", prefs.WithdrawAlerts),
                    CreateParameter("@FailedLoginAlerts", prefs.FailedLoginAlerts),
                    CreateParameter("@SettingsAlerts", prefs.SettingsAlerts),
                    outputSuccess,
                    outputMessage
                );

                result.Success = outputSuccess.Value != DBNull.Value && Convert.ToBoolean(outputSuccess.Value);
                result.ErrorMessage = outputMessage.Value != DBNull.Value ? outputMessage.Value.ToString() : "";
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.ErrorMessage = ex.Message;
            }
            return result;
        }

        public SecurityActionResult RevokeSession(int userId, long sessionId)
        {
            var result = new SecurityActionResult();
            try
            {
                var outputSuccess = new SqlParameter("@Success", System.Data.SqlDbType.Bit) { Direction = System.Data.ParameterDirection.Output };
                var outputMessage = new SqlParameter("@Message", System.Data.SqlDbType.NVarChar, 500) { Direction = System.Data.ParameterDirection.Output };

                ExecuteStoredProcedureNonQuery(
                    "usp_RevokeSession",
                    CreateParameter("@UserId", userId),
                    CreateParameter("@SessionId", sessionId),
                    outputSuccess,
                    outputMessage
                );

                result.Success = outputSuccess.Value != DBNull.Value && Convert.ToBoolean(outputSuccess.Value);
                result.ErrorMessage = outputMessage.Value != DBNull.Value ? outputMessage.Value.ToString() : "";
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.ErrorMessage = ex.Message;
            }
            return result;
        }

        public SecurityActionResult AddToWhitelist(int userId, string label, string address, int currencyId)
        {
            var result = new SecurityActionResult();
            try
            {
                var outputSuccess = new SqlParameter("@Success", System.Data.SqlDbType.Bit) { Direction = System.Data.ParameterDirection.Output };
                var outputMessage = new SqlParameter("@Message", System.Data.SqlDbType.NVarChar, 500) { Direction = System.Data.ParameterDirection.Output };

                ExecuteStoredProcedureNonQuery(
                    "usp_AddToWhitelist",
                    CreateParameter("@UserId", userId),
                    CreateParameter("@Label", label),
                    CreateParameter("@Address", address),
                    CreateParameter("@CurrencyId", currencyId),
                    outputSuccess,
                    outputMessage
                );

                result.Success = outputSuccess.Value != DBNull.Value && Convert.ToBoolean(outputSuccess.Value);
                result.ErrorMessage = outputMessage.Value != DBNull.Value ? outputMessage.Value.ToString() : "";
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.ErrorMessage = ex.Message;
            }
            return result;
        }

        public SecurityActionResult RemoveFromWhitelist(int userId, long whitelistId)
        {
            var result = new SecurityActionResult();
            try
            {
                ExecuteStoredProcedureNonQuery(
                    "usp_RemoveFromWhitelist",
                    CreateParameter("@UserId", userId),
                    CreateParameter("@WhitelistId", whitelistId)
                );
                result.Success = true;
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.ErrorMessage = ex.Message;
            }
            return result;
        }
    }
}