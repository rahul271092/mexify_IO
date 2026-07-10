using Mexify.DataAccess.Repositories;
using Mexify.Utilities;
using Mexify.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Business.Services
{
    public class RoyaltyService
    {
        private readonly RoyaltyRepository _repository;

        public RoyaltyService()
        {
            _repository = new RoyaltyRepository();
        }

        public List<RoyaltyLicense> GetActiveLicenses()
        {
            try { return _repository.GetActiveLicenses(); }
            catch (Exception ex) { Logger.Error("Failed to load royalty licenses", ex); return new List<RoyaltyLicense>(); }
        }

        public RoyaltyLicense GetLicenseById(int licenseId)
        {
            try { return _repository.GetLicenseById(licenseId); }
            catch (Exception ex) { Logger.Error("Failed to load royalty license", ex); return null; }
        }
    }
}