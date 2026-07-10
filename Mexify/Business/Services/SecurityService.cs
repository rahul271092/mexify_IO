using System;
using System.Collections.Generic;
using Mexify.DataAccess.Repositories;
using Mexify.Models;
using Mexify.Utilities;

namespace Mexify.Business.Services
{
    public class SecurityService
    {
        private readonly SecurityRepository _repository;
        private readonly UserRepository _userRepository;

        public SecurityService()
        {
            _repository = new SecurityRepository();
            _userRepository = new UserRepository();
        }

        public UserSecurityInfo GetUserSecurityInfo(int userId)
        {
            try { return _repository.GetUserSecurityInfo(userId); }
            catch (Exception ex) { Logger.Error("Failed to get security info", ex); return new UserSecurityInfo(); }
        }

        public TwoFASetup Generate2FASecret(int userId)
        {
            try
            {
                string secret = PasswordHelper.GenerateToken(20).Replace("-", "").Replace("_", "").ToUpper().Substring(0, 16);
                return new TwoFASetup
                {
                    SecretKey = secret,
                    QRCodeUrl = ""
                };
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to generate 2FA secret", ex);
                return new TwoFASetup { SecretKey = "", QRCodeUrl = "" };
            }
        }

        public SecurityActionResult Enable2FA(int userId, string code)
        {
            try
            {
                // In production, verify code against the secret
                // For now, accept any 6-digit code
                if (string.IsNullOrEmpty(code) || code.Length != 6)
                {
                    return new SecurityActionResult { Success = false, ErrorMessage = "Invalid code." };
                }

                // TODO: Call stored procedure to enable 2FA
                Logger.Info("User " + userId + " enabled 2FA");
                return new SecurityActionResult { Success = true };
            }
            catch (Exception ex)
            {
                Logger.Error("Enable 2FA failed", ex);
                return new SecurityActionResult { Success = false, ErrorMessage = "Failed to enable 2FA." };
            }
        }

        public SecurityActionResult Disable2FA(int userId)
        {
            try
            {
                Logger.Info("User " + userId + " disabled 2FA");
                return new SecurityActionResult { Success = true };
            }
            catch (Exception ex)
            {
                Logger.Error("Disable 2FA failed", ex);
                return new SecurityActionResult { Success = false, ErrorMessage = "Failed to disable 2FA." };
            }
        }

        public List<string> GenerateBackupCodes(int userId)
        {
            var codes = new List<string>();
            for (int i = 0; i < 10; i++)
            {
                codes.Add(PasswordHelper.GenerateToken(6).Substring(0, 8).ToUpper());
            }
            return codes;
        }

        public SecurityActionResult ChangePassword(int userId, string currentPassword, string newPassword)
        {
            try
            {
                var user = _userRepository.GetUserById(userId);
                if (user == null)
                {
                    return new SecurityActionResult { Success = false, ErrorMessage = "User not found." };
                }

                // Verify current password (would need PasswordHash from DB)
                // For demo, accept any non-empty password
                if (string.IsNullOrEmpty(currentPassword))
                {
                    return new SecurityActionResult { Success = false, ErrorMessage = "Current password is incorrect." };
                }

                Logger.Info("User " + userId + " changed password");
                return new SecurityActionResult { Success = true };
            }
            catch (Exception ex)
            {
                Logger.Error("Password change failed", ex);
                return new SecurityActionResult { Success = false, ErrorMessage = "Failed to change password." };
            }
        }

        public SecurityActionResult UpdateNotificationPreferences(int userId, NotificationPreferences prefs)
        {
            try { return _repository.UpdateNotificationPreferences(userId, prefs); }
            catch (Exception ex) { Logger.Error("Failed to update preferences", ex); return new SecurityActionResult { Success = false, ErrorMessage = ex.Message }; }
        }

        public List<ActiveSession> GetActiveSessions(int userId)
        {
            try { return _repository.GetActiveSessions(userId); }
            catch (Exception ex) { Logger.Error("Failed to get sessions", ex); return new List<ActiveSession>(); }
        }

        public SecurityActionResult LogoutAllSessions(int userId, string currentSessionId)
        {
            try
            {
                Logger.Info("User " + userId + " logged out all sessions");
                return new SecurityActionResult { Success = true };
            }
            catch (Exception ex)
            {
                return new SecurityActionResult { Success = false, ErrorMessage = ex.Message };
            }
        }

        public SecurityActionResult RevokeSession(int userId, long sessionId)
        {
            try { return _repository.RevokeSession(userId, sessionId); }
            catch (Exception ex) { return new SecurityActionResult { Success = false, ErrorMessage = ex.Message }; }
        }

        public List<WhitelistAddress> GetWhitelist(int userId)
        {
            try { return _repository.GetWhitelist(userId); }
            catch (Exception ex) { Logger.Error("Failed to get whitelist", ex); return new List<WhitelistAddress>(); }
        }

        public SecurityActionResult AddToWhitelist(int userId, string label, string address, int currencyId, string twoFACode)
        {
            try { return _repository.AddToWhitelist(userId, label, address, currencyId); }
            catch (Exception ex) { return new SecurityActionResult { Success = false, ErrorMessage = ex.Message }; }
        }

        public SecurityActionResult RemoveFromWhitelist(int userId, long whitelistId)
        {
            try { return _repository.RemoveFromWhitelist(userId, whitelistId); }
            catch (Exception ex) { return new SecurityActionResult { Success = false, ErrorMessage = ex.Message }; }
        }

        public List<SecurityActivity> GetSecurityActivity(int userId, int count)
        {
            try { return _repository.GetSecurityActivity(userId, count); }
            catch (Exception ex) { Logger.Error("Failed to get activity", ex); return new List<SecurityActivity>(); }
        }
    }
}