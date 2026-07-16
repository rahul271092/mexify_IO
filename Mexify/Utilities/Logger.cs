using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Hosting;

namespace Mexify.Utilities
{
    public class Logger
    {
        private static readonly object LockObj = new object();

        public static void Error(string message, Exception ex = null)
        {
            try
            {
                string logFolder = HostingEnvironment.MapPath("~/App_Data/logs/");
                if (!Directory.Exists(logFolder))
                {
                    Directory.CreateDirectory(logFolder);
                }

                string logFile = Path.Combine(logFolder, $"error_{DateTime.Now:yyyyMMdd}.log");
                string logEntry = $"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] ERROR: {message}";

                if (ex != null)
                {
                    logEntry += Environment.NewLine +
                                $"Exception: {ex.Message}" + Environment.NewLine +
                                $"Stack Trace: {ex.StackTrace}" + Environment.NewLine;
                    if (ex.InnerException != null)
                    {
                        logEntry += $"Inner Exception: {ex.InnerException.Message}" + Environment.NewLine;
                    }
                }

                logEntry += new string('-', 80) + Environment.NewLine;

                lock (LockObj)
                {
                    File.AppendAllText(logFile, logEntry);
                }
            }
            catch
            {
                // Swallow logging errors to prevent cascading failures
            }
        }

        public static void Info(string message)
        {
            try
            {
                string logFolder = HostingEnvironment.MapPath("~/App_Data/logs/");
                if (!Directory.Exists(logFolder)) Directory.CreateDirectory(logFolder);

                string logFile = Path.Combine(logFolder, $"info_{DateTime.Now:yyyyMMdd}.log");
                string logEntry = $"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] INFO: {message}{Environment.NewLine}";

                lock (LockObj)
                {
                    File.AppendAllText(logFile, logEntry);
                }
            }
            catch { }
        }

        internal static void Warn(string v)
        {
            throw new NotImplementedException();
        }
    }
}