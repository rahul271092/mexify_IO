using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class User
    {
        public int UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string PasswordHash { get; set; }
        public string Phone { get; set; }
        public int? CountryId { get; set; }
        public string ReferralCode { get; set; }
        public string PhotoUrl { get; set; }
        public string Tier { get; set; }
        public bool IsEmailVerified { get; set; }
        public int Status { get; set; }  // 0=Pending, 1=Active, 2=Suspended, 3=Banned
        public string VerificationToken { get; set; }
        public DateTime CreatedDate { get; set; }

        public int EntryFee { get; set; }//0=pending , 1=completed

        public bool IsAdmin {
            get;
            set;
        }

        public string FullName
        {
            get { return (FirstName ?? "") + " " + (LastName ?? ""); }
        }

        public object PlainPassword { get; internal set; }
        public string ProfilePhoto { get; internal set; }
    }
}