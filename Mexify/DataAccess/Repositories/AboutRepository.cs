using Mexify.Web.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Mexify.DataAccess.Repositories
{
    public class AboutRepository : BaseRepository
    {

        public List<TeamMember> GetActiveTeamMembers()
        {
           // return ExecuteStoredProcedure("usp_GetActiveTeamMembers", MapTeamMember);


            return ExecuteStoredProcedure<TeamMember>(
               "usp_GetActiveTeamMembers",
               reader => MapTeamMember(reader)
           );
        }

        public List<TimelineItem> GetActiveTimeline()
        {
            return ExecuteStoredProcedure<TimelineItem>(
                "usp_GetActiveTimeline",
                reader => MapTimeline(reader)
            );
        }

        private List<TimelineItem> ExecuteStoredProcedure(string v, Func<SqlDataReader, TimelineItem> mapTimeline)
        {
            throw new NotImplementedException();
        }

        public List<Certificate> GetActiveCertificates()
        {
            return ExecuteStoredProcedure<Certificate>(
                "usp_GetActiveCertificates",
                reader => MapCertificate(reader)
            );
        }



        private TeamMember MapTeamMember(SqlDataReader reader)
        {
            return new TeamMember
            {
                MemberId = reader.GetInt32(reader.GetOrdinal("MemberId")),
                FullName = reader.GetString(reader.GetOrdinal("FullName")),
                Designation = reader.GetString(reader.GetOrdinal("Designation")),
                Bio = reader.IsDBNull(reader.GetOrdinal("Bio")) ? null : reader.GetString(reader.GetOrdinal("Bio")),
                PhotoUrl = reader.IsDBNull(reader.GetOrdinal("PhotoUrl")) ? null : reader.GetString(reader.GetOrdinal("PhotoUrl")),
                LinkedInUrl = reader.IsDBNull(reader.GetOrdinal("LinkedInUrl")) ? "#" : reader.GetString(reader.GetOrdinal("LinkedInUrl")),
                TwitterUrl = reader.IsDBNull(reader.GetOrdinal("TwitterUrl")) ? "#" : reader.GetString(reader.GetOrdinal("TwitterUrl")),
                SortOrder = reader.GetInt32(reader.GetOrdinal("SortOrder")),
                IsActive = reader.GetBoolean(reader.GetOrdinal("IsActive"))
            };
        }

        private TimelineItem MapTimeline(SqlDataReader reader)
        {
            return new TimelineItem
            {
                TimelineId = reader.GetInt32(reader.GetOrdinal("TimelineId")),
                Year = reader.GetString(reader.GetOrdinal("Year")),
                Title = reader.GetString(reader.GetOrdinal("Title")),
                Description = reader.IsDBNull(reader.GetOrdinal("Description")) ? null : reader.GetString(reader.GetOrdinal("Description")),
                SortOrder = reader.GetInt32(reader.GetOrdinal("SortOrder")),
                IsActive = reader.GetBoolean(reader.GetOrdinal("IsActive"))
            };
        }

        private Certificate MapCertificate(SqlDataReader reader)
        {
            return new Certificate
            {
                CertificateId = reader.GetInt32(reader.GetOrdinal("CertificateId")),
                Title = reader.GetString(reader.GetOrdinal("Title")),
                Description = reader.IsDBNull(reader.GetOrdinal("Description")) ? null : reader.GetString(reader.GetOrdinal("Description")),
                IconClass = reader.IsDBNull(reader.GetOrdinal("IconClass")) ? "fas fa-certificate" : reader.GetString(reader.GetOrdinal("IconClass")),
                SortOrder = reader.GetInt32(reader.GetOrdinal("SortOrder")),
                IsActive = reader.GetBoolean(reader.GetOrdinal("IsActive"))
            };
        }

     
    }
}