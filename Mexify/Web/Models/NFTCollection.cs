using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class NFTCollection
    {

        public int CollectionId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string LogoUrl { get; set; }
        public string BannerUrl { get; set; }
        public int CreatorId { get; set; }
        public string CreatorName { get; set; }
        public decimal FloorPrice { get; set; }
        public string FloorPriceFormatted { get; set; }
        public decimal Volume { get; set; }
        public string VolumeFormatted { get; set; }
        public int TotalItems { get; set; }
        public int OwnersCount { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}