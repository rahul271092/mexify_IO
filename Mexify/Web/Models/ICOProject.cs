using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class ICOProject
    {
        public int ProjectId { get; set; }
        public string ProjectName { get; set; }
        public string Description { get; set; }
        public string ShortDescription { get; set; }
        public string LogoUrl { get; set; }
        public string BannerUrl { get; set; }
        public string TokenName { get; set; }
        public string TokenSymbol { get; set; }
        public decimal TotalSupply { get; set; }
        public string TotalSupplyFormatted { get; set; }
        public decimal SoftCap { get; set; }
        public string SoftCapFormatted { get; set; }
        public decimal HardCap { get; set; }
        public string HardCapFormatted { get; set; }
        public decimal TokenPrice { get; set; }
        public decimal RaisedAmount { get; set; }
        public string RaisedFormatted { get; set; }
        public decimal ProgressPercent { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string EndDateIso { get; set; }
        public int Status { get; set; } // 0:Upcoming, 1:Live, 2:Completed
        public DateTime CreatedDate { get; set; }
    }
}