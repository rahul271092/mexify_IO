using Mexify.Web.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Mexify.DataAccess.Repositories
{
    public class ICORepository : BaseRepository
    {

        public List<ICOProject> GetAllProjects()
        {
            return ExecuteStoredProcedure<ICOProject>(
                "usp_GetAllICOProjects",
                reader => MapProject(reader)
            );
        }

        /// <summary>
        /// Retrieves the single highest-priority active ICO project for the hero banner.
        /// </summary>
        public ICOProject GetFeaturedProject()
        {
            var results = ExecuteStoredProcedure<ICOProject>(
                "usp_GetFeaturedICOProject",
                reader => MapProject(reader)
            );
            return results.Count > 0 ? results[0] : null;
        }

        /// <summary>
        /// Maps a SqlDataReader row to an ICOProject model.
        /// Handles DBNull, formatting, and calculated fields (Progress, EndDateIso).
        /// </summary>
        private ICOProject MapProject(SqlDataReader reader)
        {
            decimal raised = GetSafeDecimal(reader, "RaisedAmount");
            decimal hardCap = GetSafeDecimal(reader, "HardCap");

            // Calculate funding progress percentage
            decimal progress = hardCap > 0 ? (raised / hardCap) * 100m : 0m;
            if (progress > 100m) progress = 100m;

            DateTime endDate = GetSafeDateTime(reader, "EndDate");
            DateTime startDate = GetSafeDateTime(reader, "StartDate");
            DateTime createdDate = GetSafeDateTime(reader, "CreatedDate");

            return new ICOProject
            {
                ProjectId = GetSafeInt(reader, "ProjectId"),
                ProjectName = GetSafeString(reader, "ProjectName") ?? "Untitled Project",
                Description = GetSafeString(reader, "Description"),
                ShortDescription = GetSafeString(reader, "ShortDescription"),
                LogoUrl = GetSafeString(reader, "LogoUrl"),
                BannerUrl = GetSafeString(reader, "BannerUrl"),
                TokenName = GetSafeString(reader, "TokenName") ?? "Token",
                TokenSymbol = GetSafeString(reader, "TokenSymbol") ?? "TKN",

                TotalSupply = GetSafeDecimal(reader, "TotalSupply"),
                TotalSupplyFormatted = FormatLargeNumber(GetSafeDecimal(reader, "TotalSupply")),

                SoftCap = GetSafeDecimal(reader, "SoftCap"),
                SoftCapFormatted = FormatCurrency(GetSafeDecimal(reader, "SoftCap")),

                HardCap = hardCap,
                HardCapFormatted = FormatCurrency(hardCap),
                TokenPrice = GetSafeDecimal(reader, "TokenPrice"),

                RaisedAmount = raised,
                RaisedFormatted = FormatCurrency(raised),
                ProgressPercent = progress,

                StartDate = startDate != DateTime.MinValue ? startDate : DateTime.UtcNow,
                EndDate = endDate != DateTime.MinValue ? endDate : DateTime.UtcNow.AddMonths(1),
                EndDateIso = endDate != DateTime.MinValue ? endDate.ToString("yyyy-MM-ddTHH:mm:ss.fffZ") : "",

                Status = GetSafeInt(reader, "Status"),
                CreatedDate = createdDate != DateTime.MinValue ? createdDate : DateTime.UtcNow
            };
        }

        /// <summary>
        /// Formats decimal values as compact currency strings (e.g., $12.5M, $3.2K).
        /// </summary>
        private string FormatCurrency(decimal value)
        {
            if (value >= 1000000m) return "$" + (value / 1000000m).ToString("0.##") + "M";
            if (value >= 1000m) return "$" + (value / 1000m).ToString("0.##") + "K";
            return "$" + value.ToString("0.##");
        }

        /// <summary>
        /// Formats large numbers for token supply (e.g., 1.2B, 500M).
        /// </summary>
        private string FormatLargeNumber(decimal value)
        {
            if (value >= 1000000000m) return (value / 1000000000m).ToString("0.##") + "B";
            if (value >= 1000000m) return (value / 1000000m).ToString("0.##") + "M";
            if (value >= 1000m) return (value / 1000m).ToString("0.##") + "K";
            return value.ToString("0");
        }

    }
}