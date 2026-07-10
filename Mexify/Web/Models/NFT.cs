using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class NFT
    {
        public long NFTId { get; set; }
        public int CollectionId { get; set; }
        public string CollectionName { get; set; }
        public string TokenId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string ImageUrl { get; set; }
        public string MetadataUrl { get; set; }
        public int OwnerId { get; set; }
        public int CreatorId { get; set; }
        public string CreatorUsername { get; set; }
        public string CreatorPhoto { get; set; }
        public decimal Price { get; set; }
        public int CurrencyId { get; set; }
        public string CurrencyCode { get; set; }
        public bool IsForSale { get; set; }
        public bool IsAuction { get; set; }
        public DateTime? AuctionEndDate { get; set; }
        public string Category { get; set; }
        public int LikesCount { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}