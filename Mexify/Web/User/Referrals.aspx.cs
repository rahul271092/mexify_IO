using System;
using System.Collections.Generic;
using System.Web.UI;
using Mexify.Business.Services;
using Mexify.Models;
using Mexify.Utilities;
using System.Data.SqlClient;
using Mexify.Web.Models;

namespace Mexify.Web.User
{
    public partial class Referrals : System.Web.UI.Page
    {
        private ReferralService _referralService;
        private int _userId;

        public string ReferralLink { get; private set; } = "";
        public bool IsEligible { get;  set; }
        public string CurrentRankClass { get; set; } = "bronze";
        public string CurrentRankIcon { get;  set; } = "fas fa-medal";
        public decimal RankProgress { get;  set; }

        private string _currentRankName = "Bronze";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.IsAuthenticated || Session["UserId"] == null)
            {
                Response.Redirect(ResolveUrl("~/Web/login.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl)));
                return;
            }

            _userId = Convert.ToInt32(Session["UserId"]);
            _referralService = new ReferralService();

            if (!IsPostBack)
            {
                LoadReferralData();
            }
        }



        public ReferralStats2 GetReferralStats()
        {
            ReferralStats2 rs = new  ReferralStats2();
            try
            {
                string sql = "usp_GetReferralStats";
                using (SqlCommand cmd = Web.Models.Connection.Sql(sql))
                {
                    cmd.Parameters.AddWithValue("@UserId", Int32.Parse(Session["UserId"].ToString()));
                    SqlDataReader sdr = cmd.ExecuteReader();
                    if(sdr.HasRows)
                    {
                        sdr.Read();
                        rs.DirectReferrals = Int32.Parse(sdr["DirectReferrals"].ToString());
                        rs.TotalTeam = Int32.Parse(sdr["TotalTeam"].ToString());
                        rs.TotalCommission = Decimal.Parse(sdr["TotalCommission"].ToString());
                        rs.ThisMonthCommission = Decimal.Parse(sdr["ThisMonthCommission"].ToString());
                        rs.TodayCommission = Decimal.Parse(sdr["TodayCommission"].ToString());

                    }
                }
            }
            catch(Exception ef)
            {
                Logger.Error("Get ReferralStats Error", ef);
            }
            finally
            {
                Web.Models.Connection.CloseConnection();
            }

            return rs;
        }


        //public List<LevelBreakdown> GetLevelBreakdown2()
        //{
        //    List<LevelBreakdown> levelBreakdown = new List<LevelBreakdown>();


        //        string sql = "usp_GetUserLevelBreakdown2";
        //        using (SqlCommand cmd = Web.Models.Connection.Sql(sql))
        //        {
        //            cmd.Parameters.AddWithValue("@UserId", Int32.Parse(Session["UserId"].ToString()));
        //            SqlDataReader sdr = cmd.ExecuteReader();
        //            if (sdr.HasRows)
        //            {
        //                while(sdr.Read())
        //                {
        //                    sdr.Read();
        //                    LevelBreakdown lb = new LevelBreakdown();

        //                       lb.Level = Int32.Parse(sdr["Level"].ToString());
        //                    lb.CommissionPercent = Decimal.Parse(sdr["CommissionPercent"].ToString());
        //                    lb.TeamCount = Int32.Parse(sdr["TeamCount"].ToString());
        //                    lb.Earned = Decimal.Parse(sdr["Earned"].ToString());
        //                    lb.IsEligible = Boolean.Parse(sdr["IsEligible"].ToString());

        //                    levelBreakdown.Add(lb);
        //                }
        //            }
        //            sdr.Close();

        //        }



        //    return levelBreakdown;
        //}



        public List<LevelBreakdown> GetLevelBreakdown2()
        {
            List<LevelBreakdown> levelBreakdown = new List<LevelBreakdown>();

            // ✅ NULL check for Session
            if (Session["UserId"] == null)
                return levelBreakdown;

            int userId;
            if (!Int32.TryParse(Session["UserId"].ToString(), out userId))
                return levelBreakdown;

            try
            {
                string sql = "usp_GetUserLevelBreakdown2";
                using (SqlCommand cmd = Web.Models.Connection.Sql(sql))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    using (SqlDataReader sdr = cmd.ExecuteReader())
                    {
                        // ✅ Sirf ek while loop, double read HATA DIYA
                        while (sdr.Read())
                        {
                            LevelBreakdown lb = new LevelBreakdown();

                            // ✅ Safe parsing with NULL checks
                            lb.Level = GetSafeInt(sdr, "Level");
                            lb.CommissionPercent = GetSafeDecimal(sdr, "CommissionPercent");
                            lb.TeamCount = GetSafeInt(sdr, "TeamCount");
                            lb.Earned = GetSafeDecimal(sdr, "Earned");
                            lb.IsEligible = GetSafeBool(sdr, "IsEligible");

                            levelBreakdown.Add(lb);
                        }
                    } // ✅ sdr automatically close ho jayega
                }
            }
            catch (Exception ex)
            {
                // ✅ Error log karo, crash mat hone do
                System.Diagnostics.Debug.WriteLine("GetLevelBreakdown2 Error: " + ex.Message);
            }

            return levelBreakdown;
        }

        // ==========================================
        // ✅ HELPER METHODS (Add these in same class)
        // ==========================================

        private int GetSafeInt(SqlDataReader reader, string columnName)
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

        private decimal GetSafeDecimal(SqlDataReader reader, string columnName)
        {
            try
            {
                if (reader[columnName] == DBNull.Value || reader[columnName] == null)
                    return 0;

                return Convert.ToDecimal(reader[columnName]);
            }
            catch
            {
                return 0;
            }
        }

        private bool GetSafeBool(SqlDataReader reader, string columnName)
        {
            try
            {
                if (reader[columnName] == DBNull.Value || reader[columnName] == null)
                    return false;

                // ✅ SQL BIT (1/0) aur string ("True"/"False") dono handle karega
                object value = reader[columnName];

                if (value is bool)
                    return (bool)value;
                if (value is int)
                    return (int)value != 0;
                if (value is byte)
                    return (byte)value != 0;

                string strValue = value.ToString().Trim().ToLower();
                return strValue == "true" || strValue == "1" || strValue == "yes";
            }
            catch
            {
                return false;
            }
        }
        private void LoadReferralData()
        {
          
                var master = this.Master as Mexify.Web.MasterPages.UserMaster;
                if (master != null)
                {
                    master.SetPageTitle("Referrals");
                    master.SetBreadcrumb("Referrals");
                }

                // Get referral code


                Web.Models.UserRankInfo rank = new Models.UserRankInfo();

                string referralCode = string.Empty;
                string sql = "select ReferralCode from Users where UserId=@UserId";
                using (SqlCommand cmd = Web.Models.Connection.SqlQuery(sql))
                {
                    cmd.Parameters.AddWithValue("@UserId", Session["UserId"].ToString());
                    SqlDataReader sdr = cmd.ExecuteReader();
                    if(sdr.HasRows && sdr.Read())
                    {
                        referralCode = sdr["ReferralCode"] as string;
                        ReferralLink = "https://mexify.io/Web/MetaMaskLogin.aspx?ref=" + referralCode;

                    }
                sdr.Close();
                }



                //    string refCode = _referralService.GetUserReferralCode(_userId);
                //if (string.IsNullOrEmpty(refCode))
                //{
                //    refCode = _referralService.GenerateReferralCode(_userId);
                //}

                //// Build referral link
                //string baseUrl = Request.Url.GetLeftPart(UriPartial.Authority);
                //ReferralLink = baseUrl + ResolveUrl("~/Web/MetaMaskLogin.aspx?ref=" + refCode);

                // Stats
                var stats = GetReferralStats();



                litDirectReferrals.Text = stats.DirectReferrals.ToString();
                litTotalTeam.Text = stats.TotalTeam.ToString();
                litTotalCommission.Text = stats.TotalCommission.ToString("0.00");
                litMonthCommission.Text = stats.ThisMonthCommission.ToString("0.00");

                // Commissions tab stats
                litLifetimeCommissions.Text = stats.TotalCommission.ToString("0.00");
                litMonthCommissions.Text = stats.ThisMonthCommission.ToString("0.00");
                litTodayCommissions.Text = stats.TodayCommission.ToString("0.00");

                // Eligibility
                IsEligible = stats.DirectReferrals >= 1;

            // Rank
            //Models.UserRank rank = _referralService.GetUserRank(_userId);
            //litRankName.Text = rank.RankName;
            //litRankRequirement.Text = rank.Requirement;
            //CurrentRankClass = rank.RankClass.ToString();
            //CurrentRankIcon = rank.RankIcon;
            //RankProgress = rank.ProgressPercent;
            //litRankProgress.Text = rank.ProgressText;
            //litRankBonus.Text = rank.MonthlyBonus.ToString() + " USDT";
            //_currentRankName = rank.RankName;

            //  15 Levels
            var levels = GetLevelBreakdown2();
            if (levels != null && levels.Count > 0)
            {
                rptLevels.DataSource = levels;
                rptLevels.DataBind();

                // Calculate totals
                decimal totalLevelEarnings = 0;
                int activeLevels = 0;
                foreach (var level in levels)
                {
                    totalLevelEarnings += level.Earned;
                    if (level.TeamCount > 0) activeLevels++;
                }
                litTotalLevelEarnings.Text = totalLevelEarnings.ToString("0.00");
                litActiveLevels.Text = activeLevels.ToString();
            }

            //// Team members
            var team = _referralService.GetUserTeam(_userId, 50);
            if (team != null && team.Count > 0)
            {
                rptTeam.DataSource = team;
                rptTeam.DataBind();
                pnlNoTeam.Visible = false;
            }
            else
            {
                pnlNoTeam.Visible = true;
            }

            //// Recent commissions (overview)
            var recentCommissions = _referralService.GetRecentCommissions(_userId, 5);
            if (recentCommissions != null && recentCommissions.Count > 0)
            {
                rptRecentCommissions.DataSource = recentCommissions;
                rptRecentCommissions.DataBind();
                pnlNoCommissions.Visible = false;
            }
            else
            {
                pnlNoCommissions.Visible = true;
            }

            //// All commissions
            var allCommissions = _referralService.GetRecentCommissions(_userId, 50);
            if (allCommissions != null && allCommissions.Count > 0)
            {
                rptAllCommissions.DataSource = allCommissions;
                rptAllCommissions.DataBind();
                pnlNoAllCommissions.Visible = false;
            }
            else
            {
                pnlNoAllCommissions.Visible = true;
            }

            //// History
            var history = _referralService.GetCommissionHistory(_userId, 100);
            if (history != null && history.Count > 0)
            {
                rptHistory.DataSource = history;
                rptHistory.DataBind();
                pnlNoHistory.Visible = false;
            }
            else
            {
                pnlNoHistory.Visible = true;
            }
        
        }

        public bool IsRankAchieved(string rankName)
        {
            string[] rankOrder = { "Bronze", "Silver", "Gold", "Platinum", "Diamond" };
            int currentIndex = Array.IndexOf(rankOrder, _currentRankName);
            int checkIndex = Array.IndexOf(rankOrder, rankName);
            return checkIndex < currentIndex;
        }

        public bool IsRankCurrent(string rankName)
        {
            return _currentRankName == rankName;
        }

        public string GetCommissionChartData()
        {
            try
            {
                var data = _referralService.GetCommissionHistory(_userId, 30);
                var dailyTotals = new Dictionary<DateTime, decimal>();

                foreach (var item in data)
                {
                    var date = item.CreatedDate.Date;
                    if (!dailyTotals.ContainsKey(date)) dailyTotals[date] = 0;
                    dailyTotals[date] += item.Amount;
                }

                var labels = new List<string>();
                var values = new List<string>();

                for (int i = 29; i >= 0; i--)
                {
                    var date = DateTime.UtcNow.Date.AddDays(-i);
                    labels.Add("\"" + date.ToString("MMM dd") + "\"");
                    values.Add((dailyTotals.ContainsKey(date) ? dailyTotals[date] : 0).ToString("0.00"));
                }

                return "{ labels: [" + string.Join(",", labels) + "], values: [" + string.Join(",", values) + "] }";
            }
            catch { return "{ labels: [], values: [] }"; }
        }

        public string GetLevelChartData()
        {
            try
            {
                var levels = _referralService.GetLevelBreakdown(_userId);
                var labels = new List<string>();
                var values = new List<string>();
                var colors = new List<string>();

                string[] colorPalette = { "#10B981", "#059669", "#047857", "#065F46", "#064E3B", "#FFD700", "#FFA500", "#FF6B6B", "#9C27B0", "#00D4FF", "#2563EB", "#E91E63", "#FF9800", "#795548", "#607D8B" };
                int colorIndex = 0;

                foreach (var level in levels)
                {
                    labels.Add("\"Level " + level.Level + "\"");
                    values.Add(level.Earned.ToString("0.00"));
                    colors.Add("\"" + colorPalette[colorIndex % colorPalette.Length] + "\"");
                    colorIndex++;
                }

                return "{ labels: [" + string.Join(",", labels) + "], values: [" + string.Join(",", values) + "], colors: [" + string.Join(",", colors) + "] }";
            }
            catch { return "{ labels: [], values: [], colors: [] }"; }
        }
    }
}