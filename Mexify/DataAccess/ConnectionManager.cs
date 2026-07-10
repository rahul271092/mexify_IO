using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;


namespace Mexify.DataAccess
{
    public class ConnectionManager
    {

        private static readonly string ConnectionString;

        static ConnectionManager()
        {
            // Load connection string from Web.config
            var connectionStringSettings = ConfigurationManager.ConnectionStrings["MexifyDB"];

            if (connectionStringSettings == null)
            {
                throw new ConfigurationErrorsException(
                    "Connection string 'MexifyDB' not found in Web.config. " +
                    "Please add it to the <connectionStrings> section."
                );
            }

            ConnectionString = connectionStringSettings.ConnectionString;
        }

        /// <summary>
        /// Creates a new SqlConnection instance.
        /// Always use with 'using' statement for proper disposal.
        /// </summary>
        public static SqlConnection GetConnection()
        {
            return new SqlConnection(ConnectionString);
        }

        /// <summary>
        /// Gets the connection string (for advanced scenarios).
        /// </summary>
        public static string GetConnectionString()
        {
            return ConnectionString;
        }

        /// <summary>
        /// Tests the database connection.
        /// Returns true if connection is successful, false otherwise.
        /// </summary>
        public static bool TestConnection()
        {
            try
            {
                using (var connection = GetConnection())
                {
                    connection.Open();
                    return connection.State == System.Data.ConnectionState.Open;
                }
            }
            catch
            {
                return false;
            }
        }
    }
}