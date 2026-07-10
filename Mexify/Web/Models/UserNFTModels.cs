using System;
using System.Collections.Generic;

namespace Mexify.Models
{
    public class UserNFTSummary
    {
        public decimal TotalValue { get; set; }
        public int TotalOwned { get; set; }
        public int TotalCreated { get; set; }
        public decimal TotalSales { get; set; }
        public decimal RoyaltiesEarned { get; set; }
        public decimal TotalPurchases { get; set; }
        public decimal MintingFees { get; set; }
    }

    public class UserNFT
    {
        public long NFTId { get; set; }
        public string TokenId { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string ImageUrl { get; set; }
        public string CollectionName { get; set; }
        public int CollectionId { get; set; }
        public string CreatorName { get; set; }
        public int CreatorId { get; set; }
        public string Rarity { get; set; }
        public decimal CurrentValue { get; set; }
        public decimal LastSalePrice { get; set; }
        public int Status { get; set; }
        public string StatusName { get; set; }
        public DateTime CreatedDate { get; set; }
    }

    public class NFTActivity
    {
        public long ActivityId { get; set; }
        public string TypeClass { get; set; }
        public string Icon { get; set; }
        public string Title { get; set; }
        public string NFTTitle { get; set; }
        public decimal Amount { get; set; }
        public string TimeAgo { get; set; }
        public DateTime CreatedDate { get; set; }
    }

    public class NFTCollection
    {
        public int CollectionId { get; set; }
        public string CollectionName { get; set; }
    }

    public class CollectionDistributionItem
    {
        public string Name { get; set; }
        public int Value { get; set; }
    }

    public class NFTValuePoint
    {
        public DateTime Date { get; set; }
        public decimal Value { get; set; }
    }
}