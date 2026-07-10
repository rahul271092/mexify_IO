using Mexify.DataAccess.Repositories;
using Mexify.Utilities;
using Mexify.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Business.Services
{
    public class ICOService
    {

        private readonly ICORepository _repository;

        public ICOService()
        {
            _repository = new ICORepository();
        }

        public List<ICOProject> GetAllProjects()
        {
            try { return _repository.GetAllProjects(); }
            catch (Exception ex) { Logger.Error("Failed to load ICO projects", ex); return new List<ICOProject>(); }
        }

        public ICOProject GetFeaturedProject()
        {
            try { return _repository.GetFeaturedProject(); }
            catch (Exception ex) { Logger.Error("Failed to load featured ICO", ex); return null; }
        }
    }
}