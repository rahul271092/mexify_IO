using System;
using System.Collections.Generic;

namespace Mexify.Models
{
    public class UserProfile
    {
        public int UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public int? CountryId { get; set; }
        public string CountryName { get; set; }
        public string PhotoUrl { get; set; }
        public string Tier { get; set; }
        public string ReferralCode { get; set; }
        public bool IsEmailVerified { get; set; }
        public bool Is2FAEnabled { get; set; }
        public string KYCStatus { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime? LastLoginDate { get; set; }

        public int? status { get; set; }
    }

    public class UserProfileStats
    {
        public decimal TotalInvested { get; set; }
        public decimal TotalEarned { get; set; }
        public int TeamSize { get; set; }
        public int ActiveInvestments { get; set; }
    }

    public class ProfileUpdateResult
    {
        public bool Success { get; set; }
        public string ErrorMessage { get; set; }
    }

    public class LoginHistoryItem
    {
        public long LoginId { get; set; }
        public string Device { get; set; }
        public string Location { get; set; }
        public string Icon { get; set; }
        public string TimeAgo { get; set; }
        public bool IsCurrent { get; set; }
        public DateTime LoginDate { get; set; }
    }

    public class AccountActivityItem
    {
        public string Title { get; set; }
        public string Icon { get; set; }
        public string IconBg { get; set; }
        public string IconColor { get; set; }
        public string TimeAgo { get; set; }
        public DateTime CreatedDate { get; set; }
    }

    public class CountryInfo
    {
        public int CountryId { get; set; }
        public string CountryName { get; set; }
    }
}