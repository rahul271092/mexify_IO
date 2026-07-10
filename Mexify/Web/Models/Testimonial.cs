using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class Testimonial
    {
        public int TestimonialId { get; set; }
        public string Name { get; set; }
        public string Designation { get; set; }
        public string Company { get; set; }
        public string Message { get; set; }
        public string PhotoUrl { get; set; }
        public int Rating { get; set; }
        public bool IsActive { get; set; }
    }
}