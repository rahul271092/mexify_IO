using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using Mexify.Utilities;

namespace Mexify.DataAccess
{
    public abstract class BaseRepository
    {
        /// <summary>
        /// Executes a stored procedure that returns data.
        /// </summary>
        public List<T> ExecuteStoredProcedure<T>(string procedureName, Func<SqlDataReader, T> mapper, params SqlParameter[] parameters)
        {
            var results = new List<T>();

            try
            {
                using (var connection = ConnectionManager.GetConnection())
                {
                    using (var command = new SqlCommand(procedureName, connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.CommandTimeout = 30;

                        if (parameters != null && parameters.Length > 0)
                        {
                            command.Parameters.AddRange(parameters);
                        }

                        connection.Open();

                        using (var reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                results.Add(mapper(reader));
                            }
                        }
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

        /// <summary>
        /// Executes a stored procedure that returns a single value.
        /// </summary>
        public T ExecuteStoredProcedureScalar<T>(string procedureName, params SqlParameter[] parameters)
        {
            try
            {
                using (var connection = ConnectionManager.GetConnection())
                {
                    using (var command = new SqlCommand(procedureName, connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.CommandTimeout = 30;

                        if (parameters != null && parameters.Length > 0)
                        {
                            command.Parameters.AddRange(parameters);
                        }

                        connection.Open();
                        var result = command.ExecuteScalar();

                        if (result == null || result == DBNull.Value)
                        {
                            return default(T);
                        }

                        return (T)Convert.ChangeType(result, typeof(T));
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
        }

        /// <summary>
        /// ✅ Executes a stored procedure that modifies data (INSERT, UPDATE, DELETE).
        /// Returns the number of rows affected.
        /// CHANGED: protected → public (needed by services)
        /// </summary>
        public int ExecuteStoredProcedureNonQuery(string procedureName, params SqlParameter[] parameters)
        {
            try
            {
                using (var connection = ConnectionManager.GetConnection())
                {
                    using (var command = new SqlCommand(procedureName, connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.CommandTimeout = 30;

                        if (parameters != null && parameters.Length > 0)
                        {
                            command.Parameters.AddRange(parameters);
                        }

                        connection.Open();
                        return command.ExecuteNonQuery();
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
        }

        /// <summary>
        /// ✅ Executes a stored procedure with output parameters.
        /// CHANGED: protected → public (needed by services)
        /// </summary>
        public void ExecuteStoredProcedureWithOutput(string procedureName, SqlParameter[] outputParameters, params SqlParameter[] inputParameters)
        {
            try
            {
                using (var connection = ConnectionManager.GetConnection())
                {
                    using (var command = new SqlCommand(procedureName, connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.CommandTimeout = 30;

                        // Add input parameters
                        if (inputParameters != null && inputParameters.Length > 0)
                        {
                            command.Parameters.AddRange(inputParameters);
                        }

                        // Add output parameters and set their direction
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

        /// <summary>
        /// Helper to create SqlParameter with value.
        /// </summary>
        public SqlParameter CreateParameter(string name, object value)
        {
            return new SqlParameter(name, value ?? DBNull.Value);
        }

        /// <summary>
        /// ✅ Helper to create output parameter.
        /// CHANGED: protected → public (needed by services)
        /// </summary>
        public SqlParameter CreateOutputParameter(string name, SqlDbType type, int size = 0)
        {
            var param = size > 0
                ? new SqlParameter(name, type, size)
                : new SqlParameter(name, type);

            param.Direction = ParameterDirection.Output;
            return param;
        }

        /// <summary>
        /// ✅ Helper to create input/output parameter.
        /// CHANGED: protected → public (needed by services)
        /// </summary>
        public SqlParameter CreateInputOutputParameter(string name, SqlDbType type, object value, int size = 0)
        {
            var param = size > 0
                ? new SqlParameter(name, type, size)
                : new SqlParameter(name, type);

            param.Value = value ?? DBNull.Value;
            param.Direction = ParameterDirection.InputOutput;
            return param;
        }

        /// <summary>
        /// Safely get string value from SqlDataReader.
        /// </summary>
        public string GetSafeString(SqlDataReader reader, string columnName)
        {
            int ordinal = reader.GetOrdinal(columnName);
            return reader.IsDBNull(ordinal) ? null : reader.GetString(ordinal);
        }

        /// <summary>
        /// Safely get decimal value from SqlDataReader.
        /// </summary>
        public decimal GetSafeDecimal(SqlDataReader reader, string columnName)
        {
            //int ordinal = reader.GetOrdinal(columnName);
            //return reader.IsDBNull(ordinal) ? 0m : reader.GetDecimal(ordinal);



            try
            {
                int ordinal = reader.GetOrdinal(columnName);

                if (reader.IsDBNull(ordinal))
                    return 0m;

                // ✅ FIX: Handle different data types gracefully
                var value = reader.GetValue(ordinal);

                if (value == null || value == DBNull.Value)
                    return 0m;

                // Try direct decimal conversion first
                if (value is decimal)
                    return (decimal)value;

                // Handle numeric types that might come back as INT/BIGINT
                if (value is int)
                    return (int)value;

                if (value is long)
                    return (long)value;

                if (value is short)
                    return (short)value;

                if (value is byte)
                    return (byte)value;

                if (value is double)
                    return (decimal)(double)value;

                if (value is float)
                    return (decimal)(float)value;

                // Last resort: try Convert.ToDecimal
                return Convert.ToDecimal(value);
            }
            catch (Exception ex)
            {
                Logger.Error($"GetSafeDecimal failed for column '{columnName}': {ex.Message}");
                return 0m;
            }
        }

        /// <summary>
        /// Safely get int value from SqlDataReader.
        /// </summary>
        public int GetSafeInt(SqlDataReader reader, string columnName)
        {
            try
            {
                int ordinal = reader.GetOrdinal(columnName);

                if (reader.IsDBNull(ordinal))
                    return 0;

                var value = reader.GetValue(ordinal);

                if (value == null || value == DBNull.Value)
                    return 0;

                return Convert.ToInt32(value);
            }
            catch
            {
                return 0;
            }
        }

        /// <summary>
        /// Safely get long value from SqlDataReader.
        /// </summary>
        public long GetSafeLong(SqlDataReader reader, string columnName)
        {
            try
            {
                int ordinal = reader.GetOrdinal(columnName);

                if (reader.IsDBNull(ordinal))
                    return 0;

                var value = reader.GetValue(ordinal);

                if (value == null || value == DBNull.Value)
                    return 0;

                return Convert.ToInt64(value);
            }
            catch
            {
                return 0;
            }
        }

        /// <summary>
        /// Safely get DateTime value from SqlDataReader.
        /// </summary>
        public DateTime GetSafeDateTime(SqlDataReader reader, string columnName)
        {
            int ordinal = reader.GetOrdinal(columnName);
            return reader.IsDBNull(ordinal) ? DateTime.MinValue : reader.GetDateTime(ordinal);
        }

        /// <summary>
        /// Safely get bool value from SqlDataReader.
        /// </summary>
        public bool GetSafeBool(SqlDataReader reader, string columnName)
        {
            int ordinal = reader.GetOrdinal(columnName);
            return reader.IsDBNull(ordinal) ? false : reader.GetBoolean(ordinal);
        }

        /// <summary>
        /// ✅ Creates a SqlParameter that handles null values automatically.
        /// CHANGED: protected → public (needed by services)
        /// </summary>
        public SqlParameter CreateNullableParameter(string name, string value)
        {
            return new SqlParameter(name,
                string.IsNullOrEmpty(value) ? (object)DBNull.Value : value);
        }

        /// <summary>
        /// ✅ Creates a SqlParameter for nullable value types (int?, decimal?, DateTime?).
        /// CHANGED: protected → public (needed by services)
        /// </summary>
        public SqlParameter CreateNullableParameter<T>(string name, T? value) where T : struct
        {
            return new SqlParameter(name,
                value.HasValue ? (object)value.Value : DBNull.Value);
        }

        /// <summary>
        /// ✅ Creates a SqlParameter for nullable objects.
        /// CHANGED: protected → public (needed by services)
        /// </summary>
        public SqlParameter CreateNullableParameter(string name, object value)
        {
            return new SqlParameter(name, value ?? DBNull.Value);
        }
    }
}