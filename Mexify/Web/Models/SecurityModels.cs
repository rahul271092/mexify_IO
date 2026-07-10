using System;
using System.Collections.Generic;

namespace Mexify.Models
{
    public class UserSecurityInfo
    {
        public string Email { get; set; }
        public bool Is2FAEnabled { get; set; }
        public bool IsEmailVerified { get; set; }
        public string AntiPhishingCode { get; set; }
        public int PasswordAgeDays { get; set; }
        public DateTime? LastPasswordChange { get; set; }
        public string PasswordStrength { get; set; }
        public bool HasWhitelist { get; set; }
        public DateTime? TwoFAEnabledDate { get; set; }
        public int TwoFADaysActive { get; set; }
        public bool LoginAlerts { get; set; }
        public bool WithdrawAlerts { get; set; }
        public bool FailedLoginAlerts { get; set; }
        public bool SettingsAlerts { get; set; }
    }

    public class TwoFASetup
    {
        public string SecretKey { get; set; }
        public string QRCodeUrl { get; set; }
    }

    public class SecurityActionResult
    {
        public bool Success { get; set; }
        public string ErrorMessage { get; set; }
    }

    public class ActiveSession
    {
        public long SessionId { get; set; }
        public string DeviceName { get; set; }
        public string DeviceIcon { get; set; }
        public string Location { get; set; }
        public string Browser { get; set; }
        public string LastActive { get; set; }
        public bool IsCurrent { get; set; }
        public DateTime LoginDate { get; set; }
    }

    public class WhitelistAddress
    {
        public long WhitelistId { get; set; }
        public string Label { get; set; }
        public string Address { get; set; }
        public string CurrencyCode { get; set; }
        public DateTime AddedDate { get; set; }
    }

    public class SecurityActivity
    {
        public long ActivityId { get; set; }
        public string TypeClass { get; set; }
        public string Icon { get; set; }
        public string Title { get; set; }
        public string Location { get; set; }
        public string Device { get; set; }
        public DateTime CreatedDate { get; set; }
    }

    public class NotificationPreferences
    {
        public bool LoginAlerts { get; set; }
        public bool WithdrawAlerts { get; set; }
        public bool FailedLoginAlerts { get; set; }
        public bool SettingsAlerts { get; set; }
    }
}