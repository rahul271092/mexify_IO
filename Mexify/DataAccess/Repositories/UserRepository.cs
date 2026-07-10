using Mexify.Utilities;
using Mexify.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using static Mexify.Web.Models.RewardModels;

namespace Mexify.DataAccess.Repositories
{
    public class UserRepository : BaseRepository
    {
        /// <summary>
        /// Gets User ID by Wallet Address
        /// </summary>
        /// 



        public string GetOrCreateNonce(string walletAddress)
        {
            try
            {
                // ✅ Create output parameter
                var outputNonce = new SqlParameter("@Nonce", SqlDbType.NVarChar, 100)
                {
                    Direction = ParameterDirection.Output
                };

                // ✅ Execute stored procedure with output parameter
                ExecuteStoredProcedureNonQuery(
                    "usp_GetOrCreateLoginNonce",
                    CreateParameter("@WalletAddress", walletAddress),
                    outputNonce
                );

                // ✅ Read the output parameter value
                return outputNonce.Value?.ToString() ?? "";
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get/create nonce for wallet: " + walletAddress, ex);
                throw;
            }
        }

        /// <summary>
        /// Validates if a nonce exists, is unused, and not expired
        /// </summary>
        public bool ValidateLoginNonce(string walletAddress, string nonce)
        {
            var result = ExecuteStoredProcedureScalar<int>(
                "usp_ValidateLoginNonce",
                CreateParameter("@WalletAddress", walletAddress),
                CreateParameter("@Nonce", nonce)
            );
            return result > 0;
        }

        /// <summary>
        /// Gets User ID by Wallet Address
        /// </summary>
        public int GetUserIdByWalletAddress(string walletAddress)
        {
            var result = ExecuteStoredProcedureScalar<int>(
                "usp_GetUserIdByWallet",
                CreateParameter("@WalletAddress", walletAddress)
            );
            return result;
        }

        /// <summary>
        /// Marks a nonce as used to prevent replay attacks
        /// </summary>
        public void MarkNonceAsUsed(string nonce)
        {
            ExecuteStoredProcedureNonQuery(
                "usp_MarkNonceAsUsed",
                CreateParameter("@Nonce", nonce)
            );
        }
        

        public string GetLoginNonce(string walletAddress)
        {
            var result = ExecuteStoredProcedureScalar<string>(
                "usp_GetLoginNonce",
                CreateParameter("@WalletAddress", walletAddress)
            );
            return result;
        }

        /// <summary>
        /// Validates if a nonce exists and is not expired
        /// </summary>
        
        /// <summary>
        /// Marks a nonce as used to prevent replay attacks
        /// </summary>
        

        /// <summary>
        /// Records the $15 USDT Concept Entry Fee distribution upon registration
        /// </summary>
        public void RecordRegistrationEntryFee(int userId, int? referrerUserId)
        {
            try
            {
                ExecuteStoredProcedureNonQuery(
                    "usp_RecordRegistrationEntryFee",
                    CreateParameter("@UserId", userId),
                    CreateParameter("@ReferrerUserId", referrerUserId ?? (object)DBNull.Value)
                );
                Logger.Info("Recorded $15 USDT Entry Fee for User ID: " + userId);
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to record registration entry fee for User ID: " + userId, ex);
                // Don't throw exception here so registration doesn't fail if logging fails
            }
        }


        /// </summary>
        public User ValidateLogin(string email, string password)
        {
            var results = ExecuteStoredProcedure<User>(
                "usp_GetUserForLogin",
                reader => MapUser(reader),
                CreateParameter("@Email", email)
            );

            if (results.Count == 0) return null;

            User user = results[0];

            // Verify password
            if (!PasswordHelper.VerifyPassword(password, user.PasswordHash))
                return null;

            return user;
        }



        public bool WalletAddressExists(string walletAddress)
        {
            var result = ExecuteStoredProcedureScalar<int>(
                "usp_CheckWalletExists",
                CreateParameter("@WalletAddress", walletAddress)
            );
            return result > 0;
        }


        public void VerifyMetaMaskLogin(string walletAddress, string signature, string nonce,
    out int userId, out bool success, out string message)
        {
            var outputUserId = new SqlParameter("@UserId", System.Data.SqlDbType.Int)
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
                "usp_VerifyMetaMaskLogin",
                CreateParameter("@WalletAddress", walletAddress),
                CreateParameter("@Signature", signature),
                CreateParameter("@Nonce", nonce),
                outputUserId,
                outputSuccess,
                outputMessage
            );

            userId = outputUserId.Value != DBNull.Value ? Convert.ToInt32(outputUserId.Value) : 0;
            success = outputSuccess.Value != DBNull.Value && Convert.ToBoolean(outputSuccess.Value);
            message = outputMessage.Value != DBNull.Value ? outputMessage.Value.ToString() : "";
        }


        /// <summary>
        /// Gets user by email (without password hash for public use).
        /// </summary>
        public User GetUserByEmail(string email)
        {
            var results = ExecuteStoredProcedure<User>(
                "usp_GetUserByEmail",
                reader => MapUser(reader),
                CreateParameter("@Email", email)
            );
            return results.Count > 0 ? results[0] : null;
        }

        /// <summary>
        /// Gets user by ID.
        /// </summary>
        public User GetUserById(int userId)
        {
            var results = ExecuteStoredProcedure<User>(
                "usp_GetUserById",
                reader => MapUser(reader),
                CreateParameter("@UserId", userId)
            );
            return results.Count > 0 ? results[0] : null;
        }

        /// <summary>
        /// Gets user by referral code.
        /// </summary>
        public User GetUserByReferralCode(string code)
        {
            var results = ExecuteStoredProcedure<User>(
                "usp_GetUserByReferralCode",
                reader => MapUser(reader),
                CreateParameter("@ReferralCode", code)
            );
            return results.Count > 0 ? results[0] : null;
        }

        /// <summary>
        /// Creates a new user account.
        /// Returns the new UserId.
        /// </summary>
        public int CreateUser(User user, int? referrerUserId)
        {
            var outputParam = CreateOutputParameter("@UserId", SqlDbType.Int);

            ExecuteStoredProcedureNonQuery(
                "usp_CreateUser",
                CreateParameter("@FirstName", user.FirstName),
                CreateParameter("@LastName", user.LastName),
                CreateParameter("@Email", user.Email),
                CreateParameter("@PasswordHash", user.PasswordHash),
                CreateParameter("@Phone", (object)user.Phone ?? DBNull.Value),
                CreateParameter("@CountryId", (object)user.CountryId ?? DBNull.Value),
                CreateParameter("@ReferralCode", user.ReferralCode),
                CreateNullableParameter("@ReferrerUserId", referrerUserId ),
                CreateNullableParameter("@VerificationToken", user.VerificationToken),
                outputParam
            );

            return (int)outputParam.Value;
        }

        /// <summary>
        /// Verifies user email with token.
        /// Returns true if successful.
        /// </summary>
        public bool VerifyEmail(string token)
        {
            int affected = ExecuteStoredProcedureNonQuery(
                "usp_VerifyEmail",
                CreateParameter("@Token", token)
            );
            return affected > 0;
        }

        /// <summary>
        /// Creates a password reset token for the given email.
        /// Returns the token, or null if email not found.
        /// </summary>
        public string CreatePasswordResetToken(string email)
        {
            string token = PasswordHelper.GenerateToken(32);
            int affected = ExecuteStoredProcedureNonQuery(
                "usp_CreatePasswordResetToken",
                CreateParameter("@Email", email),
                CreateParameter("@Token", token)
            );
            return affected > 0 ? token : null;
        }

        /// <summary>
        /// Resets password using a valid token.
        /// </summary>
        public bool ResetPassword(string token, string newPasswordHash)
        {
            int affected = ExecuteStoredProcedureNonQuery(
                "usp_ResetPassword",
                CreateParameter("@Token", token),
                CreateParameter("@NewPasswordHash", newPasswordHash)
            );
            return affected > 0;
        }

        /// <summary>
        /// Checks if email exists in the system.
        /// </summary>
        public bool EmailExists(string email)
        {
            int count = ExecuteStoredProcedureScalar<int>(
                "usp_CheckEmailExists",
                CreateParameter("@Email", email)
            );
            return count > 0;
        }

        /// <summary>
        /// Checks if referral code exists and is available.
        /// </summary>
        public bool ReferralCodeExists(string code)
        {
            int count = ExecuteStoredProcedureScalar<int>(
                "usp_CheckReferralCodeExists",
                CreateParameter("@ReferralCode", code)
            );
            return count > 0;
        }


        /// <summary>
        /// Validates if a nonce exists, is unused, and not expired
        /// </summary>
       
        /// <summary>
        /// Gets User ID by Wallet Address
        /// </summary>
      
        /// <summary>
        /// Marks a nonce as used to prevent replay attacks
        /// </summary>
      

        /// <summary>
        /// Logs user activity (login, failed attempts, etc.)
        /// </summary>
        public void LogActivity(int? userId, string action, string details, string ipAddress)
        {
            ExecuteStoredProcedureNonQuery(
                "usp_LogActivity",
                CreateParameter("@UserId", (object)userId ?? DBNull.Value),
                CreateParameter("@Action", action),
                CreateParameter("@Details", details),
                CreateParameter("@IpAddress", ipAddress)
            );
        }


        /// <summary>
        /// Gets an existing unused nonce or creates a new one for MetaMask login
        /// </summary>
        /// <param name="walletAddress">The user's wallet address</param>
        /// <returns>The nonce string</returns>

        /// <summary>
        /// Updates the KYC status for a user
        /// </summary>
        /// <param name="userId">The user ID</param>
        /// <param name="kycStatus">-1=Not Started, 0=Pending, 1=Approved, 2=Rejected</param>
        public void UpdateUserKYCStatus(int userId, int kycStatus)
        {
            ExecuteStoredProcedureNonQuery(
                "usp_UpdateUserKYCStatus",
                CreateParameter("@UserId", userId),
                CreateParameter("@KYCStatus", kycStatus)
            );
        }

        public RewardsHistoryResult GetUserRewardsHistory(int userId, int pageNumber = 1, int pageSize = 50)
        {
            var result = new RewardsHistoryResult
            {
                PageNumber = pageNumber,
                PageSize = pageSize
            };

            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_GetUserRewardsHistory", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@PageNumber", pageNumber);
                    cmd.Parameters.AddWithValue("@PageSize", pageSize);
                    conn.Open();

                    using (var reader = cmd.ExecuteReader())
                    {
                        // Result Set 1: Transactions
                        while (reader.Read())
                        {
                            result.Transactions.Add(new UserRewardHistory
                            {
                                TransactionId = GetSafeLong(reader, "TransactionId"),
                                EarnedDate = GetSafeDateTime(reader, "EarnedDate"),
                                RewardSource = GetSafeString(reader, "RewardSource") ?? "",
                                RewardType = GetSafeString(reader, "RewardType") ?? "",
                                CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "PNC",
                                RewardAmount = GetSafeDecimal(reader, "RewardAmount"),
                                Status = GetSafeString(reader, "Status") ?? "Completed"
                            });
                        }

                        // Result Set 2: Total Count
                        if (reader.NextResult() && reader.Read())
                        {
                            result.TotalRecords = GetSafeInt(reader, "TotalRecords");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get user rewards history", ex);
            }

            return result;
        }

        private User MapUser(SqlDataReader reader)
        {
            return new User
            {
                UserId = GetSafeInt(reader, "UserId"),
                FirstName = GetSafeString(reader, "FirstName") ?? "",
                LastName = GetSafeString(reader, "LastName") ?? "",
                Email = GetSafeString(reader, "Email") ?? "",
                PasswordHash = GetSafeString(reader, "PasswordHash"),
                Phone = GetSafeString(reader, "Phone"),
                CountryId = reader.IsDBNull(reader.GetOrdinal("CountryId"))
                    ? (int?)null
                    : reader.GetInt32(reader.GetOrdinal("CountryId")),
                ReferralCode = GetSafeString(reader, "ReferralCode"),
                PhotoUrl = GetSafeString(reader, "PhotoUrl"),
                Tier = GetSafeString(reader, "Tier") ?? "Standard",
                IsEmailVerified = GetSafeBool(reader, "IsEmailVerified"),
                Status = GetSafeInt(reader, "Status"),
                CreatedDate = GetSafeDateTime(reader, "CreatedDate")
            };
        }
    }
}