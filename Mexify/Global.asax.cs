using Mexify.App_Start;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Threading;
using System.Timers;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

namespace Mexify
{
    public class Global : System.Web.HttpApplication
    {


        private System.Timers.Timer _cronTimer;

        protected void Application_Start(object sender, EventArgs e)
        {
            System.Web.Http.GlobalConfiguration.Configure(WebApiConfig.Register);


            _cronTimer = new System.Timers.Timer(60000);
            _cronTimer.Elapsed += OnCronTimerElapsed;
            _cronTimer.AutoReset = true;
            _cronTimer.Enabled = true;
        }

        private void OnCronTimerElapsed(object source, ElapsedEventArgs e)
        {
            // Prevent multiple instances from running at the exact same second
            if (e.SignalTime.Second == 0)
            {
                RunDailyJobs(e.SignalTime);
            }
            if (e.SignalTime.Minute % 5 == 0 && e.SignalTime.Second == 0)
            {
                RunWeb3Jobs();
            }
            if (e.SignalTime.Minute == 0 && e.SignalTime.Second == 0)
            {
                RunHourlyJobs();
            }
        }

        private void RunDailyJobs(DateTime now)
        {
            // Run at 00:05 AM
            if (now.Hour == 0 && now.Minute == 5)
            {
                ExecuteStoredProcedure("usp_ProcessDailyMiningPayouts");
                ExecuteStoredProcedure("usp_CalculateDailyStakingRewards");
                ExecuteStoredProcedure("usp_CalculateNFTInterest");
                ExecuteStoredProcedure("usp_CalculateLicenseDailyROI");

                // Expire contracts
                ExecuteNonQuery("UPDATE MiningContracts SET Status = 2 WHERE Status = 1 AND EndDate <= GETDATE();");
                ExecuteNonQuery("UPDATE UserStakes SET Status = 2 WHERE Status = 1 AND MaturityDate <= GETDATE();");
                ExecuteNonQuery("UPDATE UserLicenses SET Status = 2 WHERE Status = 1 AND EndDate <= GETDATE();");
            }
        }

        private void RunWeb3Jobs()
        {
            // Run every 5 minutes
            ExecuteStoredProcedure("usp_ConfirmPendingWeb3Deposits");
        }

        private void RunHourlyJobs()
        {
            // Run every hour
            ExecuteStoredProcedure("usp_CleanupExpiredNonces");
        }

        private void ExecuteStoredProcedure(string procName)
        {
            try
            {
                using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString))
                using (var cmd = new SqlCommand(procName, conn))
                {
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                // Log error to file
                System.IO.File.AppendAllText(System.Web.Hosting.HostingEnvironment.MapPath("~/App_Data/cron_errors.log"),
                    $"{DateTime.Now}: Error in {procName} - {ex.Message}\n");
            }
        }

        private void ExecuteNonQuery(string sql)
        {
            try
            {
                using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString))
                using (var cmd = new SqlCommand(sql, conn))
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                System.IO.File.AppendAllText(System.Web.Hosting.HostingEnvironment.MapPath("~/App_Data/cron_errors.log"),
                    $"{DateTime.Now}: Error in SQL Update - {ex.Message}\n");
            }
        }

        protected void Application_End(object sender, EventArgs e)
        {
            if (_cronTimer != null) _cronTimer.Dispose();
        }


        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

       
    }
}