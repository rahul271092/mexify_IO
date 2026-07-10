using System;
using System.Collections.Generic;

namespace Mexify.Web.Models
{
    // =========================================
    // NFT COLLECTION
    // =========================================
    public class NFTCollection
    {
        public int CollectionId { get; set; }
        public string CollectionName { get; set; }
        public string Name { get { return CollectionName; } set { CollectionName = value; } } // Alias
        public string Description { get; set; }
        public string CreatorName { get; set; }
        public int CreatorId { get; set; }
        public string ImageUrl { get; set; }
        public string LogoUrl { get; set; }
        public string BannerUrl { get; set; }
        public string Blockchain { get; set; }
        public string ContractAddress { get; set; }
        public decimal MintPrice { get; set; }
        public decimal FloorPrice { get; set; }
        public string FloorPriceFormatted { get; set; }
        public decimal Volume { get; set; }
        public string VolumeFormatted { get; set; }
        public int TotalItems { get; set; }
        public int AvailableItems { get; set; }
        public int MaxItems { get; set; }
        public int HoldersCount { get; set; }
        public int OwnersCount { get { return HoldersCount; } set { HoldersCount = value; } } // Alias
        public bool IsFeatured { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }

        public string DisplayName => $"{CollectionName} ({MintPrice:0.00} PNC)";
    }

    // =========================================
    // NFT
    // =========================================
    //public class NFT
    //{
    //    public int NFTId { get; set; }
    //    public int CollectionId { get; set; }
    //    public string CollectionName { get; set; }
    //    public string TokenId { get; set; }
    //    public string Name { get; set; }
    //    public string Description { get; set; }
    //    public string ImageUrl { get; set; }
    //    public int OwnerId { get; set; }
    //    public int CreatorId { get; set; }
    //    public string CreatorUsername { get; set; }
    //    public string CreatorPhoto { get; set; }
    //    public decimal Price { get; set; }
    //    public int CurrencyId { get; set; }
    //    public string CurrencyCode { get; set; }
    //    public bool IsForSale { get; set; }
    //    public bool IsAuction { get; set; }
    //    public DateTime? AuctionEndDate { get; set; }
    //    public string Category { get; set; }
    //    public int LikesCount { get; set; }
    //    public DateTime CreatedDate { get; set; }
    //}

    // =========================================
    // USER NFT
    // =========================================
  

    // =========================================
    // NFT TRANSACTION
    // =========================================
    public class NFTTransaction
    {
        public long TransactionId { get; set; }
        public int UserId { get; set; }
        public int CollectionId { get; set; }
        public string CollectionName { get; set; }
        public string NFTName { get; set; }
        public long TokenId { get; set; }
        public decimal Price { get; set; }
        public int Status { get; set; }
        public string StatusName { get; set; }
        public string TxHash { get; set; }
        public DateTime MintDate { get; set; }
    }

    // =========================================
    // MINT NFT REQUEST/RESULT
    // =========================================
    public class MintNFTRequest
    {
        public int UserId { get; set; }
        public int CollectionId { get; set; }
        public string NFTName { get; set; }
        public string Description { get; set; }
        public int Quantity { get; set; }
        public string RecipientAddress { get; set; }
    }

    public class MintNFTResult
    {
        public bool Success { get; set; }
        public string ErrorMessage { get; set; }
        public long TokenId { get; set; }
        public string TxHash { get; set; }
    }

    // =========================================
    // NFT STATS
    // =========================================
    public class NFTStats
    {
        public int TotalCollections { get; set; }
        public int TotalMinted { get; set; }
        public int TotalHolders { get; set; }
        public decimal FloorPrice { get; set; }
    }
}