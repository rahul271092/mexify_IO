using System;
using System.Collections.Generic;
using Mexify.DataAccess.Repositories;
using Mexify.Models;
using Mexify.Utilities;

namespace Mexify.Business.Services
{
    public class UserProfileService
    {
        private readonly UserProfileRepository _repository;

        public UserProfileService()
        {
            _repository = new UserProfileRepository();
        }

        public UserProfile GetUserProfile(int userId)
        {
            try { return _repository.GetUserProfile(userId); }
            catch (Exception ex) { Logger.Error("Failed to get user profile", ex); return null; }
        }

        public UserProfileStats GetUserProfileStats(int userId)
        {
            try { return _repository.GetUserProfileStats(userId); }
            catch (Exception ex) { Logger.Error("Failed to get profile stats", ex); return new UserProfileStats(); }
        }

        public ProfileUpdateResult UpdateProfile(int userId, string firstName, string lastName, string phone, int? countryId, string photoUrl)
        {
            try { return _repository.UpdateProfile(userId, firstName, lastName, phone, countryId, photoUrl); }
            catch (Exception ex) { Logger.Error("Profile update failed", ex); return new ProfileUpdateResult { Success = false, ErrorMessage = "Update failed" }; }
        }

        public ProfileUpdateResult ChangePassword(int userId, string currentPassword, string newPassword)
        {
            try
            {
                // Get current password hash
                string currentHash = _repository.GetUserPasswordHash(userId);
                if (string.IsNullOrEmpty(currentHash))
                {
                    return new ProfileUpdateResult { Success = false, ErrorMessage = "User not found." };
                }

                // Verify current password
                if (!PasswordHelper.VerifyPassword(currentPassword, currentHash))
                {
                    return new ProfileUpdateResult { Success = false, ErrorMessage = "Current password is incorrect." };
                }

                // Hash new password
                string newHash = PasswordHelper.HashPassword(newPassword);

                // Update password
                return _repository.ChangePassword(userId, currentHash, newHash);
            }
            catch (Exception ex)
            {
                Logger.Error("Password change failed", ex);
                return new ProfileUpdateResult { Success = false, ErrorMessage = "Password change failed." };
            }
        }

        public List<CountryInfo> GetCountries()
        {
            try { return _repository.GetCountries(); }
            catch (Exception ex) { Logger.Error("Failed to get countries", ex); return new List<CountryInfo>(); }
        }

        public List<LoginHistoryItem> GetLoginHistory(int userId, int count)
        {
            try { return _repository.GetLoginHistory(userId, count); }
            catch (Exception ex) { Logger.Error("Failed to get login history", ex); return new List<LoginHistoryItem>(); }
        }

        public List<AccountActivityItem> GetAccountActivity(int userId, int count)
        {
            try { return _repository.GetAccountActivity(userId, count); }
            catch (Exception ex) { Logger.Error("Failed to get account activity", ex); return new List<AccountActivityItem>(); }
        }
    }
}