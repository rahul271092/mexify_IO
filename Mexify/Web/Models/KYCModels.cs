using System;

namespace Mexify.Models
{
    public class KYCVerification
    {
        public long KYCId { get; set; }
        public int UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public string Nationality { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string PostalCode { get; set; }
        public string Phone { get; set; }
        public string Occupation { get; set; }
        public string DocumentType { get; set; }
        public string IdFrontPath { get; set; }
        public string IdBackPath { get; set; }
        public string SelfiePath { get; set; }
        public string ProofOfAddressPath { get; set; }
        public int Status { get; set; } // -1=Not Started, 0=Pending, 1=Approved, 2=Rejected
        public string RejectionReason { get; set; }
        public DateTime SubmittedDate { get; set; }
        public DateTime? ReviewedDate { get; set; }
    }
}