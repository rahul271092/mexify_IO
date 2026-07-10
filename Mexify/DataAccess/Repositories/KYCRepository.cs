using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Mexify.Models;
using Mexify.Utilities;

namespace Mexify.DataAccess.Repositories
{
    public class KYCRepository : BaseRepository
    {
        public KYCVerification GetUserKYC(int userId)
        {
            var results = ExecuteStoredProcedure<KYCVerification>(
                "usp_GetUserKYC",
                reader => new KYCVerification
                {
                    KYCId = GetSafeLong(reader, "KYCId"),
                    UserId = GetSafeInt(reader, "UserId"),
                    FirstName = GetSafeString(reader, "FirstName") ?? "",
                    LastName = GetSafeString(reader, "LastName") ?? "",
                    DateOfBirth = reader["DateOfBirth"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["DateOfBirth"]),
                    Nationality = GetSafeString(reader, "Nationality"),
                    Address = GetSafeString(reader, "Address"),
                    City = GetSafeString(reader, "City"),
                    State = GetSafeString(reader, "State"),
                    PostalCode = GetSafeString(reader, "PostalCode"),
                    Phone = GetSafeString(reader, "Phone"),
                    Occupation = GetSafeString(reader, "Occupation"),
                    DocumentType = GetSafeString(reader, "DocumentType"),
                    IdFrontPath = GetSafeString(reader, "IdFrontPath"),
                    IdBackPath = GetSafeString(reader, "IdBackPath"),
                    SelfiePath = GetSafeString(reader, "SelfiePath"),
                    ProofOfAddressPath = GetSafeString(reader, "ProofOfAddressPath"),
                    Status = GetSafeInt(reader, "Status"),
                    RejectionReason = GetSafeString(reader, "RejectionReason"),
                    SubmittedDate = GetSafeDateTime(reader, "SubmittedDate"),
                    ReviewedDate = reader["ReviewedDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["ReviewedDate"])
                },
                CreateParameter("@UserId", userId)
            );
            return results.Count > 0 ? results[0] : null;
        }

        public int SubmitKYC(KYCVerification kyc)
        {
            var outputParam = CreateOutputParameter("@KYCId", SqlDbType.BigInt);

            ExecuteStoredProcedureNonQuery(
                "usp_SubmitKYC",
                CreateParameter("@UserId", kyc.UserId),
                CreateParameter("@FirstName", kyc.FirstName),
                CreateParameter("@LastName", kyc.LastName),
                CreateParameter("@DateOfBirth", (object)kyc.DateOfBirth ?? DBNull.Value),
                CreateParameter("@Nationality", (object)kyc.Nationality ?? DBNull.Value),
                CreateParameter("@Address", (object)kyc.Address ?? DBNull.Value),
                CreateParameter("@City", (object)kyc.City ?? DBNull.Value),
                CreateParameter("@State", (object)kyc.State ?? DBNull.Value),
                CreateParameter("@PostalCode", (object)kyc.PostalCode ?? DBNull.Value),
                CreateParameter("@Phone", (object)kyc.Phone ?? DBNull.Value),
                CreateParameter("@Occupation", (object)kyc.Occupation ?? DBNull.Value),
                CreateParameter("@DocumentType", (object)kyc.DocumentType ?? DBNull.Value),
                CreateParameter("@IdFrontPath", (object)kyc.IdFrontPath ?? DBNull.Value),
                CreateParameter("@IdBackPath", (object)kyc.IdBackPath ?? DBNull.Value),
                CreateParameter("@SelfiePath", (object)kyc.SelfiePath ?? DBNull.Value),
                CreateParameter("@ProofOfAddressPath", (object)kyc.ProofOfAddressPath ?? DBNull.Value),
                outputParam
            );

            return outputParam.Value != DBNull.Value ? Convert.ToInt32(outputParam.Value) : -1;
        }

        public List<KYCVerification> GetPendingKYC()
        {
            return ExecuteStoredProcedure<KYCVerification>(
                "usp_GetPendingKYC",
                reader => new KYCVerification
                {
                    KYCId = GetSafeLong(reader, "KYCId"),
                    UserId = GetSafeInt(reader, "UserId"),
                    FirstName = GetSafeString(reader, "FullName") ?? "",
                    Nationality = GetSafeString(reader, "Nationality"),
                    DocumentType = GetSafeString(reader, "DocumentType"),
                    Status = GetSafeInt(reader, "Status"),
                    SubmittedDate = GetSafeDateTime(reader, "SubmittedDate"),
                    IdFrontPath = GetSafeString(reader, "IdFrontPath"),
                    IdBackPath = GetSafeString(reader, "IdBackPath"),
                    SelfiePath = GetSafeString(reader, "SelfiePath"),
                    ProofOfAddressPath = GetSafeString(reader, "ProofOfAddressPath")
                }
            );
        }

        public bool ApproveKYC(long kycId, int reviewedBy)
        {
            int affected = ExecuteStoredProcedureNonQuery(
                "usp_ApproveKYC",
                CreateParameter("@KYCId", kycId),
                CreateParameter("@ReviewedBy", reviewedBy)
            );
            return affected > 0;
        }

        public bool RejectKYC(long kycId, int reviewedBy, string reason)
        {
            int affected = ExecuteStoredProcedureNonQuery(
                "usp_RejectKYC",
                CreateParameter("@KYCId", kycId),
                CreateParameter("@ReviewedBy", reviewedBy),
                CreateParameter("@Reason", reason)
            );
            return affected > 0;
        }


     

        public void LogActivity(int userId, string action, string details, string ipAddress)
        {
            ExecuteStoredProcedureNonQuery(
                "usp_LogActivity",
                CreateParameter("@UserId", userId),
                CreateParameter("@Action", action),
                CreateParameter("@Details", details),
                CreateParameter("@IpAddress", ipAddress)
            );
        }
    }
}