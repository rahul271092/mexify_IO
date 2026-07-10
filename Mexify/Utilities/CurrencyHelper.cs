using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Utilities
{
    public class CurrencyHelper
    {
        public const string BaseCurrencyCode = "USDT";
        public const string BaseCurrencyName = "Tether";
        public const string BaseCurrencySymbol = "USDT";

        /// <summary>
        /// Formats a decimal value as PNC currency (e.g., "1,234.56 PNC")
        /// </summary>
        public static string FormatPNC(decimal amount, int decimals = 2)
        {
            return amount.ToString($"N{decimals}") + " PNC";
        }

        /// <summary>
        /// Formats a decimal value as PNC with compact notation (e.g., "1.2K PNC", "3.5M PNC")
        /// </summary>
        public static string FormatPNCCompact(decimal amount)
        {
            if (amount >= 1000000m)
                return (amount / 1000000m).ToString("0.##") + "M PNC";
            if (amount >= 1000m)
                return (amount / 1000m).ToString("0.##") + "K PNC";
            return amount.ToString("0.##") + " PNC";
        }

        /// <summary>
        /// Formats a decimal value as PNC with full precision (for crypto displays)
        /// </summary>
        public static string FormatPNCCrypto(decimal amount)
        {
            return amount.ToString("0.########") + " USDT";
        }

        /// <summary>
        /// Gets the HTML icon for PNC currency
        /// </summary>
        public static string GetPNCCurrencyIcon()
        {
            return "<i class='fas fa-coins' style='color: #FFD700;'></i>";
        }
    }
}