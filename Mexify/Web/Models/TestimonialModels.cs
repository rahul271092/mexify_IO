using System;

namespace Mexify.Models
{
    public class Testimonial
    {
        public int TestimonialId { get; set; }
        public string Name { get; set; }
        public string Designation { get; set; }
        public string PhotoUrl { get; set; }
        public string Message { get; set; }
        public int Rating { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; internal set; }
        public string UserName { get; internal set; }
        public string UserImage { get; internal set; }
        public string UserTitle { get; internal set; }
        public string Company { get; internal set; }
        public string TimeAgo { get; internal set; }
        public string StarDisplay { get; internal set; }
        public int SortOrder { get; internal set; }
    }

    public class FAQ
    {
        public int FAQId { get; set; }
        public string Question { get; set; }
        public string Answer { get; set; }
        public bool IsActive { get; set; }
    }
}