using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class Testimonial
    {
        internal string Name;

        public int TestimonialId { get; set; }
        public string UserName { get; set; }
        public string UserTitle { get; set; }
        public string UserImage { get; set; }
        public string Company { get; set; }
        public int Rating { get; set; }
        public string Message { get; set; }
        public bool IsActive { get; set; }

        // ✅ Ensure this property exists
        public DateTime CreatedDate { get; set; }

        // Computed fields from SQL
        public string TimeAgo { get; set; }
        public string StarDisplay { get; set; }
        public int SortOrder { get; set; }
        public string Designation { get; internal set; }
        public string PhotoUrl { get; internal set; }
    }
}