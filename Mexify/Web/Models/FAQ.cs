using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class FAQ
    {
        public int FAQId { get; set; }
        public string Question { get; set; }
        public string Answer { get; set; }
        public string Category { get; set; }
        public int SortOrder { get; set; }
        public bool IsActive { get; set; }
    }
}