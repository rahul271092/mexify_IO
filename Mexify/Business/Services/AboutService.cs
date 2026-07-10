using Mexify.DataAccess.Repositories;
using Mexify.Utilities;
using Mexify.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Business.Services
{
    public class AboutService
    {

        private readonly AboutRepository _repository;

        public AboutService()
        {
            _repository = new AboutRepository();
        }

        public List<TeamMember> GetActiveTeamMembers()
        {
            try
            {
                return _repository.GetActiveTeamMembers();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load team members", ex);
                return new List<TeamMember>();
            }
        }

        public List<TimelineItem> GetActiveTimeline()
        {
            try
            {
                return _repository.GetActiveTimeline();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load timeline", ex);
                return new List<TimelineItem>();
            }
        }

        public List<Certificate> GetActiveCertificates()
        {
            try
            {
                return _repository.GetActiveCertificates();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load certificates", ex);
                return new List<Certificate>();
            }
        }
    }
}