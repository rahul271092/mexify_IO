using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class Connection
    {
        private static string connectionString = ConfigurationManager.ConnectionStrings["MexifyDB"].ConnectionString;
        public static SqlConnection con = null;
        // Returns a new, open SqlConnection
        public static SqlConnection GetConnection()
        {
            var conn = new SqlConnection(connectionString);
            conn.Open();
            return conn;
        }


        public static SqlCommand Sql(string procedureName)
        {
            var conn = GetConnection();
            var cmd = new SqlCommand(procedureName, conn)
            {
                CommandType = CommandType.StoredProcedure,
                CommandTimeout = 300
            };
            return cmd;
        }


        // Executes a raw SQL query and returns a SqlCommand (caller must manage disposal)
        public static SqlCommand SqlQuery(string commandText)
        {
            var conn = GetConnection();
            var cmd = new SqlCommand(commandText, conn)
            {
                CommandType = CommandType.Text,
                CommandTimeout = 300
            };
            return cmd;
        }

        // Executes a stored procedure and returns a SqlCommand (caller must manage disposal)
        public static SqlCommand Procedure(string procedureName)
        {
            var conn = GetConnection();
            var cmd = new SqlCommand(procedureName, conn)
            {
                CommandType = CommandType.StoredProcedure,
                CommandTimeout = 300
            };
            return cmd;
        }

        // Alias for SqlQuery (for backward compatibility)
        public static SqlCommand Query(string commandText)
        {
            return SqlQuery(commandText);
        }

        // Optional: Closes and disposes a command and its connection
        public static void CloseConnection(SqlCommand cmd)
        {
            if (cmd != null)
            {
                if (cmd.Connection != null)
                {
                    cmd.Connection.Close();
                    cmd.Connection.Dispose();
                }
                cmd.Dispose();
            }
        }


        public static void CloseConnection()
        {
            try
            {
                if (con != null)
                {
                    con.Close();
                    con.Dispose();
                }
            }
            catch
            {
                throw;
            }
        }
    }
}