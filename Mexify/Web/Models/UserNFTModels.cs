using System;
using System.Collections.Generic;

namespace Mexify.Web.Models
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

        public long UserNFTId { get; set; }
        public int UserId { get; set; }
        public string Name { get; set; }
        public string TxHash { get; set; }
        public DateTime MintDate { get; set; }
        public decimal PurchasePrice { get;  set; }
        public DateTime PurchaseDate { get;  set; }
        public string StatusSlug { get; set; }
        public decimal ProfitLoss { get;  set; }
        public decimal ProfitPercent { get;  set; }
        public string RarityClass { get;  set; }
        public decimal? ListPrice { get;  set; }
        public DateTime? ListDate { get; set; }
        public decimal? SalePrice { get;  set; }
        public DateTime? SaleDate { get;  set; }
        public int DaysHeld { get;  set; }
        public string NFTName { get; internal set; }
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

    //public class NFTCollection
    //{
    //    public int CollectionId { get; set; }
    //    public string CollectionName { get; set; }
    //}

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