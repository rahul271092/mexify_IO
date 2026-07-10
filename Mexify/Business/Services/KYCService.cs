using System;
using System.Collections.Generic;
using Mexify.DataAccess.Repositories;
using Mexify.Models;
using Mexify.Utilities;

namespace Mexify.Business.Services
{
    public class KYCService
    {
        private readonly KYCRepository _repo = new KYCRepository();

        public KYCVerification GetUserKYC(int userId)
        {
            try { return _repo.GetUserKYC(userId); }
            catch (Exception ex) { Logger.Error("Failed to get user KYC", ex); return null; }
        }

        public int SubmitKYC(KYCVerification kyc)
        {
            try { return _repo.SubmitKYC(kyc); }
            catch (Exception ex) { Logger.Error("Failed to submit KYC", ex); return -1; }
        }

        public List<KYCVerification> GetPendingKYC()
        {
            try { return _repo.GetPendingKYC(); }
            catch (Exception ex) { Logger.Error("Failed to get pending KYC", ex); return new List<KYCVerification>(); }
        }

        public bool ApproveKYC(long kycId, int reviewedBy)
        {
            try { return _repo.ApproveKYC(kycId, reviewedBy); }
            catch (Exception ex) { Logger.Error("Failed to approve KYC", ex); return false; }
        }

     

        public bool RejectKYC(long kycId, int reviewedBy, string reason)
        {
            try { return _repo.RejectKYC(kycId, reviewedBy, reason); }
            catch (Exception ex) { Logger.Error("Failed to reject KYC", ex); return false; }
        }

        public void LogActivity(int userId, string action, string details, string ipAddress)
        {
            try { _repo.LogActivity(userId, action, details, ipAddress); }
            catch (Exception ex) { Logger.Error("Failed to log KYC activity", ex); }
        }
    }
}