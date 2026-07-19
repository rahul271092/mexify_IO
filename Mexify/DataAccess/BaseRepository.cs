using Mexify.DataAccess;
using Mexify.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace Mexify.DataAccess
{
    public  abstract class BaseRepository
    {



        // =====================================================================
        // STORED PROCEDURE EXECUTION METHODS
        // =====================================================================

        public List<T> ExecuteStoredProcedure<T>(string procedureName, Func<SqlDataReader, T> mapper, params SqlParameter[] parameters)
        {
            var results = new List<T>();
            try
            {
                using (var connection = ConnectionManager.GetConnection())
                using (var command = new SqlCommand(procedureName, connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandTimeout = 30;

                    if (parameters != null && parameters.Length > 0)
                        command.Parameters.AddRange(parameters);

                    connection.Open();
                    using (var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                            results.Add(mapper(reader));
                    }
                }
            }
            catch (SqlException sqlEx)
            {
                Logger.Error("SQL Error in " + procedureName + ": " + sqlEx.Message, sqlEx);
                throw;
            }
            catch (Exception ex)
            {
                Logger.Error("Error executing stored procedure: " + procedureName, ex);
                throw;
            }
            return results;
        }

        public T ExecuteStoredProcedureScalar<T>(string procedureName, params SqlParameter[] parameters)
        {
            try
            {
                using (var connection = ConnectionManager.GetConnection())
                using (var command = new SqlCommand(procedureName, connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandTimeout = 30;

                    if (parameters != null && parameters.Length > 0)
                        command.Parameters.AddRange(parameters);

                    connection.Open();
                    var result = command.ExecuteScalar();

                    return result == null || result == DBNull.Value ? default(T) : (T)Convert.ChangeType(result, typeof(T));
                }
            }
            catch (SqlException sqlEx)
            {
                Logger.Error("SQL Error in " + procedureName + ": " + sqlEx.Message, sqlEx);
                throw;
            }
            catch (Exception ex)
            {
                Logger.Error("Error executing stored procedure: " + procedureName, ex);
                throw;
            }
        }

        public int ExecuteStoredProcedureNonQuery(string procedureName, params SqlParameter[] parameters)
        {
            try
            {
                using (var connection = ConnectionManager.GetConnection())
                using (var command = new SqlCommand(procedureName, connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandTimeout = 30;

                    if (parameters != null && parameters.Length > 0)
                        command.Parameters.AddRange(parameters);

                    connection.Open();
                    return command.ExecuteNonQuery();
                }
            }
            catch (SqlException sqlEx)
            {
                Logger.Error("SQL Error in " + procedureName + ": " + sqlEx.Message, sqlEx);
                throw;
            }
            catch (Exception ex)
            {
                Logger.Error("Error executing stored procedure: " + procedureName, ex);
                throw;
            }
        }

        public void ExecuteStoredProcedureWithOutput(string procedureName, SqlParameter[] outputParameters, params SqlParameter[] inputParameters)
        {
            try
            {
                using (var connection = ConnectionManager.GetConnection())
                using (var command = new SqlCommand(procedureName, connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandTimeout = 30;

                    if (inputParameters != null && inputParameters.Length > 0)
                        command.Parameters.AddRange(inputParameters);

                    if (outputParameters != null && outputParameters.Length > 0)
                    {
                        foreach (var param in outputParameters)
                        {
                            param.Direction = ParameterDirection.Output;
                            command.Parameters.Add(param);
                        }
                    }

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
            catch (SqlException sqlEx)
            {
                Logger.Error("SQL Error in " + procedureName + ": " + sqlEx.Message, sqlEx);
                throw;
            }
            catch (Exception ex)
            {
                Logger.Error("Error executing stored procedure: " + procedureName, ex);
                throw;
            }
        }


        // ✅ NEW: 2-argument overload that auto-detects SqlDbType from the value
        public SqlParameter CreateNullableParameter(string name, object value)
        {
            SqlDbType dbType = InferSqlDbType(value);
            return new SqlParameter(name, dbType)
            {
                Value = value ?? (object)DBNull.Value,
                IsNullable = true
            };
        }

        // Helper: maps CLR types to SqlDbType
        private SqlDbType InferSqlDbType(object value)
        {
            if (value == null || value == DBNull.Value)
                return SqlDbType.NVarChar;

            Type t = value.GetType();

            // Handle Nullable<T>
            if (t.IsGenericType && t.GetGenericTypeDefinition() == typeof(Nullable<>))
                t = Nullable.GetUnderlyingType(t);

            if (t == typeof(int)) return SqlDbType.Int;
            if (t == typeof(long)) return SqlDbType.BigInt;
            if (t == typeof(short)) return SqlDbType.SmallInt;
            if (t == typeof(byte)) return SqlDbType.TinyInt;
            if (t == typeof(decimal)) return SqlDbType.Decimal;
            if (t == typeof(double)) return SqlDbType.Float;
            if (t == typeof(float)) return SqlDbType.Real;
            if (t == typeof(bool)) return SqlDbType.Bit;
            if (t == typeof(DateTime)) return SqlDbType.DateTime;
            if (t == typeof(Guid)) return SqlDbType.UniqueIdentifier;
            if (t == typeof(byte[])) return SqlDbType.VarBinary;
            if (t == typeof(string)) return SqlDbType.NVarChar;

            return SqlDbType.NVarChar; // fallback
        }

        // =====================================================================
        // PARAMETER HELPER METHODS
        // =====================================================================

        public SqlParameter CreateParameter(string name, object value)
        {
            return new SqlParameter(name, value ?? (object)DBNull.Value);
        }

        // ✅ FIX for CS7036: Added 2-argument overload
        public SqlParameter CreateNullableParameter(string name, SqlDbType type)
        {
            return new SqlParameter(name, type) { Value = DBNull.Value, IsNullable = true };
        }

        public SqlParameter CreateNullableParameter(string name, SqlDbType type, object value)
        {
            return new SqlParameter(name, type) { Value = value ?? (object)DBNull.Value, IsNullable = true };
        }

        public SqlParameter CreateOutputParameter(string name, SqlDbType type, int size = 0)
        {
            var param = size > 0 ? new SqlParameter(name, type, size) : new SqlParameter(name, type);
            param.Direction = ParameterDirection.Output;
            return param;
        }

        public SqlParameter CreateInputOutputParameter(string name, SqlDbType type, object value, int size = 0)
        {
            var param = size > 0 ? new SqlParameter(name, type, size) : new SqlParameter(name, type);
            param.Value = value ?? (object)DBNull.Value;
            param.Direction = ParameterDirection.InputOutput;
            return param;
        }

        // =====================================================================
        // ✅ FIX for CS0122: Changed from 'protected' to 'public static'
        // Now callable from CMSService, UserRepository, and any other class
        // =====================================================================

        public static decimal GetSafeDecimal(SqlDataReader reader, string columnName)
        {
            for (int i = 0; i < reader.FieldCount; i++)
            {
                if (reader.GetName(i).Equals(columnName, StringComparison.OrdinalIgnoreCase))
                {
                    return reader.IsDBNull(i) ? 0m : Convert.ToDecimal(reader.GetValue(i));
                }
            }
            return 0m;
        }

        public static int GetSafeInt(SqlDataReader reader, string columnName)
        {
            for (int i = 0; i < reader.FieldCount; i++)
            {
                if (reader.GetName(i).Equals(columnName, StringComparison.OrdinalIgnoreCase))
                {
                    return reader.IsDBNull(i) ? 0 : Convert.ToInt32(reader.GetValue(i));
                }
            }
            return 0;
        }

        public static long GetSafeLong(SqlDataReader reader, string columnName)
        {
            for (int i = 0; i < reader.FieldCount; i++)
            {
                if (reader.GetName(i).Equals(columnName, StringComparison.OrdinalIgnoreCase))
                {
                    return reader.IsDBNull(i) ? 0L : Convert.ToInt64(reader.GetValue(i));
                }
            }
            return 0L;
        }

        public static double GetSafeDouble(SqlDataReader reader, string columnName)
        {
            for (int i = 0; i < reader.FieldCount; i++)
            {
                if (reader.GetName(i).Equals(columnName, StringComparison.OrdinalIgnoreCase))
                {
                    return reader.IsDBNull(i) ? 0.0 : Convert.ToDouble(reader.GetValue(i));
                }
            }
            return 0.0;
        }

        public static string GetSafeString(SqlDataReader reader, string columnName)
        {
            for (int i = 0; i < reader.FieldCount; i++)
            {
                if (reader.GetName(i).Equals(columnName, StringComparison.OrdinalIgnoreCase))
                {
                    return reader.IsDBNull(i) ? "" : reader.GetValue(i).ToString();
                }
            }
            return "";
        }

        public static bool GetSafeBool(SqlDataReader reader, string columnName)
        {
            for (int i = 0; i < reader.FieldCount; i++)
            {
                if (reader.GetName(i).Equals(columnName, StringComparison.OrdinalIgnoreCase))
                {
                    return reader.IsDBNull(i) ? false : Convert.ToBoolean(reader.GetValue(i));
                }
            }
            return false;
        }

        public static DateTime GetSafeDateTime(SqlDataReader reader, string columnName)
        {
            for (int i = 0; i < reader.FieldCount; i++)
            {
                if (reader.GetName(i).Equals(columnName, StringComparison.OrdinalIgnoreCase))
                {
                    return reader.IsDBNull(i) ? DateTime.MinValue : Convert.ToDateTime(reader.GetValue(i));
                }
            }
            return DateTime.MinValue;
        }

        public static DateTime? GetSafeNullableDateTime(SqlDataReader reader, string columnName)
        {
            for (int i = 0; i < reader.FieldCount; i++)
            {
                if (reader.GetName(i).Equals(columnName, StringComparison.OrdinalIgnoreCase))
                {
                    return reader.IsDBNull(i) ? (DateTime?)null : Convert.ToDateTime(reader.GetValue(i));
                }
            }
            return null;
        }

        public static Guid GetSafeGuid(SqlDataReader reader, string columnName)
        {
            for (int i = 0; i < reader.FieldCount; i++)
            {
                if (reader.GetName(i).Equals(columnName, StringComparison.OrdinalIgnoreCase))
                {
                    return reader.IsDBNull(i) ? Guid.Empty : (Guid)reader.GetValue(i);
                }
            }
            return Guid.Empty;
        }





        //    /// <summary>
        //    /// Executes a stored procedure that returns data.
        //    /// </summary>
        //    public List<T> ExecuteStoredProcedure<T>(string procedureName, Func<SqlDataReader, T> mapper, params SqlParameter[] parameters)
        //    {
        //        var results = new List<T>();

        //        try
        //        {
        //            using (var connection = ConnectionManager.GetConnection())
        //            {
        //                using (var command = new SqlCommand(procedureName, connection))
        //                {
        //                    command.CommandType = CommandType.StoredProcedure;
        //                    command.CommandTimeout = 30;

        //                    if (parameters != null && parameters.Length > 0)
        //                    {
        //                        command.Parameters.AddRange(parameters);
        //                    }

        //                    connection.Open();

        //                    using (var reader = command.ExecuteReader())
        //                    {
        //                        while (reader.Read())
        //                        {
        //                            results.Add(mapper(reader));
        //                        }
        //                    }
        //                }
        //            }
        //        }
        //        catch (SqlException sqlEx)
        //        {
        //            Logger.Error("SQL Error in " + procedureName + ": " + sqlEx.Message, sqlEx);
        //            throw;
        //        }
        //        catch (Exception ex)
        //        {
        //            Logger.Error("Error executing stored procedure: " + procedureName, ex);
        //            throw;
        //        }

        //        return results;
        //    }

        //    /// <summary>
        //    /// Executes a stored procedure that returns a single value.
        //    /// </summary>
        //    public T ExecuteStoredProcedureScalar<T>(string procedureName, params SqlParameter[] parameters)
        //    {
        //        try
        //        {
        //            using (var connection = ConnectionManager.GetConnection())
        //            {
        //                using (var command = new SqlCommand(procedureName, connection))
        //                {
        //                    command.CommandType = CommandType.StoredProcedure;
        //                    command.CommandTimeout = 30;

        //                    if (parameters != null && parameters.Length > 0)
        //                    {
        //                        command.Parameters.AddRange(parameters);
        //                    }

        //                    connection.Open();
        //                    var result = command.ExecuteScalar();

        //                    if (result == null || result == DBNull.Value)
        //                    {
        //                        return default(T);
        //                    }

        //                    return (T)Convert.ChangeType(result, typeof(T));
        //                }
        //            }
        //        }
        //        catch (SqlException sqlEx)
        //        {
        //            Logger.Error("SQL Error in " + procedureName + ": " + sqlEx.Message, sqlEx);
        //            throw;
        //        }
        //        catch (Exception ex)
        //        {
        //            Logger.Error("Error executing stored procedure: " + procedureName, ex);
        //            throw;
        //        }
        //    }

        //    /// <summary>
        //    /// Executes a stored procedure that modifies data (INSERT, UPDATE, DELETE).
        //    /// Returns the number of rows affected.
        //    /// </summary>
        //    public int ExecuteStoredProcedureNonQuery(string procedureName, params SqlParameter[] parameters)
        //    {
        //        try
        //        {
        //            using (var connection = ConnectionManager.GetConnection())
        //            {
        //                using (var command = new SqlCommand(procedureName, connection))
        //                {
        //                    command.CommandType = CommandType.StoredProcedure;
        //                    command.CommandTimeout = 30;

        //                    if (parameters != null && parameters.Length > 0)
        //                    {
        //                        command.Parameters.AddRange(parameters);
        //                    }

        //                    connection.Open();
        //                    return command.ExecuteNonQuery();
        //                }
        //            }
        //        }
        //        catch (SqlException sqlEx)
        //        {
        //            Logger.Error("SQL Error in " + procedureName + ": " + sqlEx.Message, sqlEx);
        //            throw;
        //        }
        //        catch (Exception ex)
        //        {
        //            Logger.Error("Error executing stored procedure: " + procedureName, ex);
        //            throw;
        //        }
        //    }

        //    /// <summary>
        //    /// Executes a stored procedure with output parameters.
        //    /// </summary>
        //    public void ExecuteStoredProcedureWithOutput(string procedureName, SqlParameter[] outputParameters, params SqlParameter[] inputParameters)
        //    {
        //        try
        //        {
        //            using (var connection = ConnectionManager.GetConnection())
        //            {
        //                using (var command = new SqlCommand(procedureName, connection))
        //                {
        //                    command.CommandType = CommandType.StoredProcedure;
        //                    command.CommandTimeout = 30;

        //                    if (inputParameters != null && inputParameters.Length > 0)
        //                    {
        //                        command.Parameters.AddRange(inputParameters);
        //                    }

        //                    if (outputParameters != null && outputParameters.Length > 0)
        //                    {
        //                        foreach (var param in outputParameters)
        //                        {
        //                            param.Direction = ParameterDirection.Output;
        //                            command.Parameters.Add(param);
        //                        }
        //                    }

        //                    connection.Open();
        //                    command.ExecuteNonQuery();
        //                }
        //            }
        //        }
        //        catch (SqlException sqlEx)
        //        {
        //            Logger.Error("SQL Error in " + procedureName + ": " + sqlEx.Message, sqlEx);
        //            throw;
        //        }
        //        catch (Exception ex)
        //        {
        //            Logger.Error("Error executing stored procedure: " + procedureName, ex);
        //            throw;
        //        }
        //    }

        //    /// <summary>
        //    /// Helper to create SqlParameter with value.
        //    /// </summary>
        //    public SqlParameter CreateParameter(string name, object value)
        //    {
        //        return new SqlParameter(name, value ?? DBNull.Value);
        //    }

        //    /// <summary>
        //    /// Helper to create output parameter.
        //    /// </summary>
        //    public SqlParameter CreateOutputParameter(string name, SqlDbType type, int size = 0)
        //    {
        //        var param = size > 0
        //            ? new SqlParameter(name, type, size)
        //            : new SqlParameter(name, type);

        //        param.Direction = ParameterDirection.Output;
        //        return param;
        //    }

        //    /// <summary>
        //    /// Helper to create input/output parameter.
        //    /// </summary>
        //    public SqlParameter CreateInputOutputParameter(string name, SqlDbType type, object value, int size = 0)
        //    {
        //        var param = size > 0
        //            ? new SqlParameter(name, type, size)
        //            : new SqlParameter(name, type);

        //        param.Value = value ?? DBNull.Value;
        //        param.Direction = ParameterDirection.InputOutput;
        //        return param;
        //    }

        //    // =====================================================================
        //    // SAFE DATA READER EXTENSION METHODS
        //    // =====================================================================

        //    public static bool HasColumn(this IDataReader reader, string columnName)
        //    {
        //        if (string.IsNullOrWhiteSpace(columnName))
        //            return false;

        //        try
        //        {
        //            for (int i = 0; i < reader.FieldCount; i++)
        //            {
        //                if (reader.GetName(i).Equals(columnName, StringComparison.OrdinalIgnoreCase))
        //                    return true;
        //            }
        //        }
        //        catch
        //        {
        //            // Reader might be closed or in an invalid state; fail gracefully
        //            return false;
        //        }

        //        return false;
        //    }

        //    public static T GetSafe<T>(this IDataReader reader, string columnName, T defaultValue = default(T))
        //    {
        //        try
        //        {
        //            if (string.IsNullOrWhiteSpace(columnName))
        //                return defaultValue;

        //            if (!reader.HasColumn(columnName))
        //                return defaultValue;

        //            int ordinal = reader.GetOrdinal(columnName);

        //            if (reader.IsDBNull(ordinal))
        //                return defaultValue;

        //            object value = reader.GetValue(ordinal);

        //            // Double-check for nulls just in case of quirky IDataReader implementations
        //            if (value == null || value == DBNull.Value)
        //                return defaultValue;

        //            if (value is T typedValue)
        //                return typedValue;

        //            // Handle enum conversions safely (Convert.ChangeType fails on enums)
        //            if (typeof(T).IsEnum)
        //            {
        //                return (T)Enum.ToObject(typeof(T), Convert.ToInt32(value));
        //            }

        //            return (T)Convert.ChangeType(value, typeof(T));
        //        }
        //        catch
        //        {
        //            // Catch-all ensures NO crashes; returns the safe default
        //            return defaultValue;
        //        }
        //    }

        //    public static T? GetSafeNullable<T>(this IDataReader reader, string columnName) where T : struct
        //    {
        //        try
        //        {
        //            if (string.IsNullOrWhiteSpace(columnName))
        //                return null;

        //            if (!reader.HasColumn(columnName))
        //                return null;

        //            int ordinal = reader.GetOrdinal(columnName);

        //            if (reader.IsDBNull(ordinal))
        //                return null;

        //            object value = reader.GetValue(ordinal);

        //            if (value == null || value == DBNull.Value)
        //                return null;

        //            if (value is T typedValue)
        //                return typedValue;

        //            if (typeof(T).IsEnum)
        //            {
        //                return (T)Enum.ToObject(typeof(T), Convert.ToInt32(value));
        //            }

        //            return (T)Convert.ChangeType(value, typeof(T));
        //        }
        //        catch
        //        {
        //            return null;
        //        }
        //    }

        //    // ──────────────────────────────────────────────
        //    // CONVENIENCE METHODS
        //    // ──────────────────────────────────────────────

        //    public static decimal GetSafeDecimal(this IDataReader reader, string columnName, decimal defaultValue = 0m)
        //        => reader.GetName(columnName, defaultValue);

        //    public static int GetSafeInt(this IDataReader reader, string columnName, int defaultValue = 0)
        //        => reader.GetSafe(columnName, defaultValue);

        //    public static long GetSafeLong(this IDataReader reader, string columnName, long defaultValue = 0L)
        //        => reader.GetSafe(columnName, defaultValue);

        //    public static double GetSafeDouble(this IDataReader reader, string columnName, double defaultValue = 0.0)
        //        => reader.GetName(columnName, defaultValue);

        //    public static string GetSafeString(this IDataReader reader, string columnName, string defaultValue = "")
        //        => reader.GetName(columnName, defaultValue);

        //    public static bool GetSafeBool(this IDataReader reader, string columnName, bool defaultValue = false)
        //        => reader.GetName(columnName, defaultValue);

        //    public static DateTime GetSafeDateTime(this IDataReader reader, string columnName, DateTime? defaultValue = null)
        //        => reader.GetSafe(columnName, defaultValue ?? DateTime.MinValue);

        //    public static DateTime? GetSafeNullableDateTime(this IDataReader reader, string columnName)
        //        => reader.GetSafeNullable<DateTime>(columnName);

        //    public static Guid GetSafeGuid(this IDataReader reader, string columnName, Guid defaultValue = default(Guid))
        //        => reader.GetName(columnName, defaultValue);
    }
}