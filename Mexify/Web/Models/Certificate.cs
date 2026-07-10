using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class Certificate
    {
        public int CertificateId { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string IconClass { get; set; }
        public int SortOrder { get; set; }
        public bool IsActive { get; set; }

    }
}