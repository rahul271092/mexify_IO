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
    }

    public class FAQ
    {
        public int FAQId { get; set; }
        public string Question { get; set; }
        public string Answer { get; set; }
        public bool IsActive { get; set; }
    }
}