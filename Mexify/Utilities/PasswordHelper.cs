using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Web;

namespace Mexify.Utilities
{
    public class PasswordHelper
    {


        private const int SaltSize = 16;       // 128 bits
        private const int HashSize = 32;       // 256 bits
        private const int Iterations = 10000;  // PBKDF2 iterations

        /// <summary>
        /// Hashes a password with a random salt using PBKDF2.
        /// Returns a combined string: "iterations.salt.hash" (all base64)
        /// </summary>
        public static string HashPassword(string password)
        {
            if (string.IsNullOrEmpty(password))
                throw new ArgumentNullException("password");

            byte[] salt;
            using (var rng = new RNGCryptoServiceProvider())
            {
                salt = new byte[SaltSize];
                rng.GetBytes(salt);
            }

            byte[] hash;
            using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, Iterations))
            {
                hash = pbkdf2.GetBytes(HashSize);
            }

            return string.Format("{0}.{1}.{2}",
                Iterations,
                Convert.ToBase64String(salt),
                Convert.ToBase64String(hash));
        }

        /// <summary>
        /// Verifies a password against a stored hash.
        /// </summary>
        public static bool VerifyPassword(string password, string storedHash)
        {
            if (string.IsNullOrEmpty(password) || string.IsNullOrEmpty(storedHash))
                return false;

            try
            {
                string[] parts = storedHash.Split('.');
                if (parts.Length != 3) return false;

                int iterations = int.Parse(parts[0]);
                byte[] salt = Convert.FromBase64String(parts[1]);
                byte[] storedHashBytes = Convert.FromBase64String(parts[2]);

                byte[] computedHash;
                using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, iterations))
                {
                    computedHash = pbkdf2.GetBytes(storedHashBytes.Length);
                }

                // Constant-time comparison to prevent timing attacks
                return ConstantTimeEquals(storedHashBytes, computedHash);
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Generates a cryptographically secure random token.
        /// </summary>
        public static string GenerateToken(int length = 32)
        {
            byte[] tokenBytes = new byte[length];
            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(tokenBytes);
            }
            return Convert.ToBase64String(tokenBytes)
                .Replace("+", "-")
                .Replace("/", "_")
                .Replace("=", "");
        }

        /// <summary>
        /// Generates a random referral code (e.g., "REF-A8F3K2").
        /// </summary>
        public static string GenerateReferralCode()
        {
            const string chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"; // No ambiguous chars
            char[] code = new char[8];
            using (var rng = new RNGCryptoServiceProvider())
            {
                byte[] data = new byte[1];
                for (int i = 0; i < code.Length; i++)
                {
                    rng.GetBytes(data);
                    code[i] = chars[data[0] % chars.Length];
                }
            }
            return "REF-" + new string(code);
        }

        /// <summary>
        /// Constant-time byte array comparison.
        /// </summary>
        private static bool ConstantTimeEquals(byte[] a, byte[] b)
        {
            if (a == null || b == null || a.Length != b.Length)
                return false;

            int result = 0;
            for (int i = 0; i < a.Length; i++)
            {
                result |= a[i] ^ b[i];
            }
            return result == 0;
        }
    }
}