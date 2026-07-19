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
        public DateTime CreatedDate { get;  set; }
        public string UserName { get;  set; }
        public string UserImage { get;  set; }
        public string Company { get; set; }
        public string UserTitle { get;  set; }


      //  public string Company { get;  set; }
       // public string TimeAgo { get;  set; }
      //  public string StarDisplay { get;  set; }
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