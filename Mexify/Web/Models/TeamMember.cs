using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class TeamMember
    {
        public int MemberId { get; set; }
        public string FullName { get; set; }
        public string Designation { get; set; }
        public string Bio { get; set; }
        public string PhotoUrl { get; set; }
        public string LinkedInUrl { get; set; }
        public string TwitterUrl { get; set; }
        public int SortOrder { get; set; }
        public bool IsActive { get; set; }
    }
}