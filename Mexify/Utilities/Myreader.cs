using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Mexify.Utilities
{
    public static class Myreader
    {

        /// Safely reads an integer. Returns 0 if null, DBNull, or invalid.
        /// </summary>
        public static int GetSafeInt(SqlDataReader reader, string columnName)
        {
            try
            {
                if (reader[columnName] == DBNull.Value || reader[columnName] == null)
                    return 0;

                return Convert.ToInt32(reader[columnName]);
            }
            catch
            {
                return 0;
            }
        }

        /// <summary>
        /// Safely reads a long (BIGINT). Returns 0 if null, DBNull, or invalid.
        /// </summary>
        public static long GetSafeLong(SqlDataReader reader, string columnName)
        {
            try
            {
                if (reader[columnName] == DBNull.Value || reader[columnName] == null)
                    return 0;

                return Convert.ToInt64(reader[columnName]);
            }
            catch
            {
                return 0;
            }
        }

        /// <summary>
        /// Safely reads a decimal. Returns 0m if null, DBNull, or invalid.
        /// </summary>
        public static decimal GetSafeDecimal(SqlDataReader reader, string columnName)
        {
            try
            {
                if (reader[columnName] == DBNull.Value || reader[columnName] == null)
                    return 0m;

                return Convert.ToDecimal(reader[columnName]);
            }
            catch
            {
                return 0m;
            }
        }

        /// <summary>
        /// Safely reads a boolean. Handles SQL BIT (1/0), bool, and string ("true"/"false").
        /// Returns false if null, DBNull, or invalid.
        /// </summary>
        public static bool GetSafeBool(SqlDataReader reader, string columnName)
        {
            try
            {
                if (reader[columnName] == DBNull.Value || reader[columnName] == null)
                    return false;

                object value = reader[columnName];

                if (value is bool)
                    return (bool)value;
                if (value is int)
                    return (int)value != 0;
                if (value is byte) // SQL Server BIT sometimes reads as byte
                    return (byte)value != 0;

                string strValue = value.ToString().Trim().ToLower();
                return strValue == "true" || strValue == "1" || strValue == "yes";
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Safely reads a string. Returns empty string "" if null, DBNull, or invalid.
        /// </summary>
        public static string GetSafeString(SqlDataReader reader, string columnName)
        {
            try
            {
                if (reader[columnName] == DBNull.Value || reader[columnName] == null)
                    return string.Empty;

                return reader[columnName].ToString().Trim();
            }
            catch
            {
                return string.Empty;
            }
        }

        /// <summary>
        /// Safely reads a DateTime. Returns DateTime.MinValue if null, DBNull, or invalid.
        /// </summary>
        public static DateTime GetSafeDateTime(SqlDataReader reader, string columnName)
        {
            try
            {
                if (reader[columnName] == DBNull.Value || reader[columnName] == null)
                    return DateTime.MinValue;

                return Convert.ToDateTime(reader[columnName]);
            }
            catch
            {
                return DateTime.MinValue;
            }
        }

        /// <summary>
        /// Safely reads a nullable DateTime. Returns null if null, DBNull, or invalid.
        /// </summary>
        public static DateTime? GetSafeNullableDateTime(SqlDataReader reader, string columnName)
        {
            try
            {
                if (reader[columnName] == DBNull.Value || reader[columnName] == null)
                    return null;

                return Convert.ToDateTime(reader[columnName]);
            }
            catch
            {
                return null;
            }
        }


    }
}