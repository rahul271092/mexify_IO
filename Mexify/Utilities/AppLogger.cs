using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Web;

namespace Mexify.Utilities
{
    public class AppLogger
    {
        public static void Error<T>(
        T context,
        Exception exception,
        string customMessage = null,
        [CallerMemberName] string memberName = "",
        [CallerFilePath] string filePath = "",
        [CallerLineNumber] int lineNumber = 0)
        {
            // 1. Get Class Name
            string className = context?.GetType().Name ?? "UnknownClass";

            // 2. Get File Name (strips long paths for cleaner logs)
            string fileName = Path.GetFileName(filePath);

            // 3. Safely extract UserId from Session (fallback to "Anonymous" or "System")
            string userId = "System/Anonymous";
            try
            {
                if (HttpContext.Current?.Session?["UserId"] != null)
                {
                    userId = $"UserId:{HttpContext.Current.Session["UserId"]}";
                }
                else if (HttpContext.Current?.User?.Identity?.IsAuthenticated == true)
                {
                    userId = $"User:{HttpContext.Current.User.Identity.Name}";
                }
            }
            catch { /* Ignore session access errors during logging */ }

            // 4. Build the rich, standardized log message
            string baseMessage = $"[{className}.{memberName}] (File: {fileName}, Line: {lineNumber}) | {userId}";

            if (!string.IsNullOrEmpty(customMessage))
            {
                baseMessage += $" | Context: {customMessage}";
            }

            // 5. Pass to your underlying logging framework
            // (Replace 'Mexify.Utilities.Logger.Error' with your actual logger call, e.g., NLog, Serilog, log4net)
            Mexify.Utilities.Logger.Error(baseMessage, exception);
        }

        /// <summary>
        /// Generic Info Logger for consistency.
        /// </summary>
        public static void Info<T>(
            T context,
            string message,
            [CallerMemberName] string memberName = "",
            [CallerFilePath] string filePath = "")
        {
            string className = context?.GetType().Name ?? "UnknownClass";
            string fileName = Path.GetFileName(filePath);

            string userId = "System/Anonymous";
            try
            {
                if (HttpContext.Current?.Session?["UserId"] != null)
                    userId = $"UserId:{HttpContext.Current.Session["UserId"]}";
            }
            catch { }

            string logMessage = $"[{className}.{memberName}] (File: {fileName}) | {userId} | {message}";
            Mexify.Utilities.Logger.Info(logMessage);
        }

    }
}