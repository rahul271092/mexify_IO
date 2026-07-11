using Mexify.DataAccess.Repositories;
using Mexify.Utilities;
using Mexify.Web.Models;
using Nethereum.Signer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Mexify.Business.Services;

namespace Mexify.Business.Services
{
    public class AuthService
    {
        private readonly UserRepository _repository;

        public AuthService()
        {
            _repository = new UserRepository();
        }

        /// <summary>
        /// Registers a new user via MetaMask signature
        /// </summary>
        public MetaMaskLoginResult RegisterWithWallet(string walletAddress, string signature, string nonce, string referralCode)
        {
            var result = new MetaMaskLoginResult();

            try
            {
                // 1. Validate Nonce
                if (!_repository.ValidateLoginNonce(walletAddress, nonce))
                {
                    result.Success = false;
                    result.ErrorMessage = "Invalid or expired nonce. Please refresh and try again.";
                    return result;
                }

                // 2. Verify Signature
                string message = $"Welcome to Mexify!\n\nClick to sign in and accept the Terms of Service.\n\nThis request will not trigger a blockchain transaction or cost any fees.\n\nWallet address:\n{walletAddress}\n\nNonce:\n{nonce}";

                var signer = new Nethereum.Signer.EthereumMessageSigner();
                string recoveredAddress = signer.EncodeUTF8AndEcRecover(message, signature);

                string normalizedRecovered = recoveredAddress.Replace("0x", "").ToLowerInvariant();
                string normalizedProvided = walletAddress.Replace("0x", "").ToLowerInvariant();

                if (normalizedRecovered != normalizedProvided)
                {
                    result.Success = false;
                    result.ErrorMessage = "Signature verification failed.";
                    return result;
                }

                // 3. Check if user already exists
                int existingUserId = _repository.GetUserIdByWalletAddress(walletAddress);
                if (existingUserId > 0)
                {
                    result.Success = false;
                    result.ErrorMessage = "This wallet is already registered. Please login instead.";
                    return result;
                }

                // ✅ 4. Create the User (Using OUT parameters)
                int newUserId;
                string regMessage;

                bool regSuccess = _repository.RegisterUserWithWallet(
                    walletAddress, null, null, null, referralCode, out newUserId, out regMessage);

                if (!regSuccess)
                {
                    result.Success = false;
                    result.ErrorMessage = regMessage;
                    return result;
                }

                // 5. Mark Nonce as Used
                _repository.MarkNonceAsUsed(nonce);

                // 6. Success!
                result.Success = true;
                result.UserId = newUserId;
                Logger.Info($"New Web3 User Registered: {newUserId} (Wallet: {walletAddress})");
            }
            catch (Exception ex)
            {
                Logger.Error("Web3 Registration failed", ex);
                result.Success = false;
                result.ErrorMessage = "Registration failed: " + ex.Message;
            }

            return result;
        }

        public void UpdateUserKYCStatus(int userId, int kycStatus)
        {
            try
            {
                _repository.UpdateUserKYCStatus(userId, kycStatus);
                Logger.Info("Updated KYC status for user " + userId + " to " + kycStatus);
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to update KYC status for user " + userId, ex);
                throw;
            }
        }


        public string GetOrCreateNonce(string walletAddress)
        {
            return _repository.GetOrCreateNonce(walletAddress);
        }


        /// <summary>
        /// Registers a new user via MetaMask signature
        /// </summary>
   

        public MetaMaskLoginResult VerifyMetaMaskLogin(string walletAddress, string signature, string nonce)
        {
            var result = new MetaMaskLoginResult();
            try
            {
                // ✅ DEBUG: Log what the server actually received
                Logger.Info($"MetaMask Login Attempt - Wallet: '{walletAddress}', Nonce: '{nonce}'");

                // 1. Verify nonce is valid and unused
                bool isValidNonce = _repository.ValidateLoginNonce(walletAddress, nonce);
                if (!isValidNonce)
                {
                    Logger.Error($"MetaMask Nonce Validation FAILED for wallet: {walletAddress}");
                    result.Success = false;
                    result.ErrorMessage = "Invalid or expired nonce. Please refresh the page and try again.";
                    return result;
                }

                // 2. Cryptographically verify signature (using Nethereum)
                // ⚠️ CRITICAL FIX: This message MUST exactly match the message signed in your JavaScript!
                string message = $"Welcome to Mexify!\n\nClick to sign in and accept the Terms of Service.\n\nThis request will not trigger a blockchain transaction or cost any fees.\n\nWallet address:\n{walletAddress}\n\nNonce:\n{nonce}";

                var signer = new Nethereum.Signer.EthereumMessageSigner();
                string recoveredAddress = signer.EncodeUTF8AndEcRecover(message, signature);

                // ✅ FIX: Normalize addresses to prevent "0x" prefix or casing mismatches
                string normalizedRecovered = recoveredAddress.Replace("0x", "").ToLowerInvariant();
                string normalizedProvided = walletAddress.Replace("0x", "").ToLowerInvariant();

                // ✅ DEBUG: Log the comparison
                Logger.Info($"Signature Verification - Recovered: '{normalizedRecovered}', Provided: '{normalizedProvided}'");

                if (normalizedRecovered != normalizedProvided)
                {
                    Logger.Error($"Signature mismatch! Recovered: {normalizedRecovered}, Expected: {normalizedProvided}");
                    result.Success = false;
                    result.ErrorMessage = "Signature verification failed. The signature does not match the wallet address.";
                    return result;
                }

                // 3. Find user by wallet address
                int userId = _repository.GetUserIdByWalletAddress(walletAddress);
                if (userId == 0)
                {
                    result.Success = false;
                    result.ErrorMessage = "No account linked to this wallet. Please register first.";
                    return result;
                }

                // 4. Mark nonce as used to prevent replay attacks
                _repository.MarkNonceAsUsed(nonce);

                result.Success = true;
                result.UserId = userId;
            }
            catch (Exception ex)
            {
                Logger.Error("MetaMask verification failed", ex);
                result.Success = false;
                // ✅ FIX: Include the actual exception message for easier debugging
                result.ErrorMessage = "Authentication failed: " + ex.Message;
            }
            return result;
        }

        //public MetaMaskLoginResult VerifyMetaMaskLogin(string walletAddress, string signature, string nonce)
        //{
        //    var result = new MetaMaskLoginResult();
        //    try
        //    {
        //        // ✅ DEBUG: Log what the server actually received
        //        Logger.Info($"MetaMask Login Attempt - Wallet: '{walletAddress}', Nonce: '{nonce}'");
        //        // 1. Verify nonce is valid and unused
        //        bool isValidNonce = _repository.ValidateLoginNonce(walletAddress, nonce);
        //        if (!isValidNonce)
        //        {
        //            // ✅ DEBUG: Log why it failed
        //            Logger.Error($"MetaMask Nonce Validation FAILED for wallet: {walletAddress}");
        //            result.Success = false;
        //            result.ErrorMessage = "Invalid or expired nonce.";
        //            return result;
        //        }

        //        // 2. Cryptographically verify signature (using Nethereum)
        //        string message = $"MEXIFY Authentication\n\nNonce: {nonce}\n\nPlease sign this message to verify your wallet ownership.";
        //        var signer = new Nethereum.Signer.EthereumMessageSigner();
        //        string recoveredAddress = signer.EncodeUTF8AndEcRecover(message, signature);

        //        if (!string.Equals(recoveredAddress, walletAddress, StringComparison.OrdinalIgnoreCase))
        //        {
        //            result.Success = false;
        //            result.ErrorMessage = "Signature verification failed.";
        //            return result;
        //        }

        //        // 3. Find user by wallet address
        //        int userId = _repository.GetUserIdByWalletAddress(walletAddress);
        //        if (userId == 0)
        //        {
        //            result.Success = false;
        //            result.ErrorMessage = "No account linked to this wallet. Please register first.";
        //            return result;
        //        }

        //        // 4. Mark nonce as used
        //        _repository.MarkNonceAsUsed(nonce);

        //        result.Success = true;
        //        result.UserId = userId;
        //    }
        //    catch (Exception ex)
        //    {
        //        Logger.Error("MetaMask verification failed", ex);
        //        result.Success = false;
        //        result.ErrorMessage = "Authentication failed.";
        //    }
        //    return result;
        //}






        public void LogUserActivity(int userId, string action, string details, string ipAddress)
        {
            try
            {
                var repo = new Mexify.DataAccess.Repositories.UserRepository();
                repo.LogActivity(userId, action, details, ipAddress);
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to log user activity", ex);
            }
        }




       
        /// <summary>
        /// Validates login credentials and returns user if successful.
        /// </summary>
        public User ValidateLogin(string email, string password, string ipAddress)
        {
            if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
                return null;

            try
            {
                var user = _repository.ValidateLogin(email.Trim(), password);

                if (user == null)
                {
                    _repository.LogActivity(null, "LOGIN_FAILED",
                        "Failed login attempt for: " + email, ipAddress);
                    return null;
                }

                if (user.Status != 1)
                {
                    _repository.LogActivity(user.UserId, "LOGIN_BLOCKED",
                        "Login blocked - account status: " + user.Status, ipAddress);
                    return null;
                }

                _repository.LogActivity(user.UserId, "LOGIN_SUCCESS",
                    "Successful login", ipAddress);

                return user;
            }
            catch (Exception ex)
            {
                Logger.Error("Login validation failed", ex);
                return null;
            }
        }

        /// <summary>
        /// Registers a new user account.
        /// Returns the new UserId, or -1 on failure.
        /// </summary>
        public int RegisterUser(User user, string refCode, string ipAddress)
        {
            try
            {


             //   var result = new RegistrationResult();
                // Check if email already exists
                if (_repository.EmailExists(user.Email))
                {
                    return -2; // Email exists
                }

                // Hash password
                user.PasswordHash = PasswordHelper.HashPassword(user.PasswordHash); // PasswordHash field holds plain temporarily

                // Generate unique referral code
                string refCodeNew;
                do
                {
                    refCodeNew = PasswordHelper.GenerateReferralCode();
                } while (_repository.ReferralCodeExists(refCodeNew));
                user.ReferralCode = refCodeNew;

                // Generate email verification token
                user.VerificationToken = PasswordHelper.GenerateToken(32);

                // Find referrer
                int? referrerUserId = null;
                if (!string.IsNullOrEmpty(refCode))
                {
                    var referrer = _repository.GetUserByReferralCode(refCode);
                    if (referrer != null)
                    {
                        referrerUserId = referrer.UserId;
                    }
                }
                // Create user
                int userId = _repository.CreateUser(user, referrerUserId);

                _repository.RecordRegistrationEntryFee(userId, referrerUserId);


                _repository.LogActivity(userId, "REGISTER_SUCCESS",
                    "New user registered. Referrer: " + (refCode ?? "none"), ipAddress);

                return userId;
            }
            catch (Exception ex)
            {
                Logger.Error("User registration failed", ex);
                return -1;
            }
        }

        /// <summary>
        /// Verifies user email with token.
        /// </summary>
        public bool VerifyEmail(string token)
        {
            try
            {
                return _repository.VerifyEmail(token);
            }
            catch (Exception ex)
            {
                Logger.Error("Email verification failed", ex);
                return false;
            }
        }

        /// <summary>
        /// Initiates password reset by creating a token.
        /// </summary>
        public string InitiatePasswordReset(string email, string ipAddress)
        {
            try
            {
                string token = _repository.CreatePasswordResetToken(email);
                if (token != null)
                {
                    _repository.LogActivity(null, "PASSWORD_RESET_REQUESTED",
                        "Password reset requested for: " + email, ipAddress);
                }
                return token;
            }
            catch (Exception ex)
            {
                Logger.Error("Password reset initiation failed", ex);
                return null;
            }
        }

        /// <summary>
        /// Completes password reset with token and new password.
        /// </summary>
        public bool CompletePasswordReset(string token, string newPassword, string ipAddress)
        {
            try
            {
                string hash = PasswordHelper.HashPassword(newPassword);
                bool success = _repository.ResetPassword(token, hash);

                if (success)
                {
                    _repository.LogActivity(null, "PASSWORD_RESET_COMPLETE",
                        "Password reset completed", ipAddress);
                }
                return success;
            }
            catch (Exception ex)
            {
                Logger.Error("Password reset completion failed", ex);
                return false;
            }
        }

        /// <summary>
        /// Gets user by ID (for profile display).
        /// </summary>
        public User GetUserById(int userId)
        {
            try { return _repository.GetUserById(userId); }
            catch (Exception ex) { Logger.Error("Failed to get user", ex); return null; }
        }

        /// <summary>
        /// Checks if email exists.
        /// </summary>
        public bool EmailExists(string email)
        {
            try { return _repository.EmailExists(email); }
            catch { return false; }
        }
    }

public class MetaMaskLoginResult
{
    public bool Success { get; set; }
    public string ErrorMessage { get; set; }
    public int UserId { get; set; }
}

}