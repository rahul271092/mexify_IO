using Mexify.Web.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Mexify.DataAccess.Repositories
{
    public class NFTRepository : BaseRepository
    {
        public List<NFTCollection> GetTrendingCollections(int count)
        {
            return ExecuteStoredProcedure<NFTCollection>(
                "usp_GetTrendingNFTCollections",
                reader => MapCollection(reader),
                CreateParameter("@Count", count)
            );
        }

        public List<NFT> GetNFTs(string category, string sortBy, string search, int pageNumber, int pageSize)
        {
            return ExecuteStoredProcedure<NFT>(
                "usp_GetNFTs",
                reader => MapNFT(reader),
                CreateParameter("@Category", category),
                CreateParameter("@SortBy", sortBy),
                CreateParameter("@Search", search),
                CreateParameter("@PageNumber", pageNumber),
                CreateParameter("@PageSize", pageSize)
            );
        }

        private NFTCollection MapCollection(SqlDataReader reader)
        {
            decimal floorPrice = GetSafeDecimal(reader, "FloorPrice");
            decimal volume = GetSafeDecimal(reader, "Volume");

            return new NFTCollection
            {
                CollectionId = GetSafeInt(reader, "CollectionId"),
                Name = GetSafeString(reader, "Name"),
                Description = GetSafeString(reader, "Description"),
                LogoUrl = GetSafeString(reader, "LogoUrl"),
                BannerUrl = GetSafeString(reader, "BannerUrl"),
                CreatorId = GetSafeInt(reader, "CreatorId"),
                CreatorName = GetSafeString(reader, "CreatorName"),
                FloorPrice = floorPrice,
                FloorPriceFormatted = FormatCrypto(floorPrice),
                Volume = volume,
                VolumeFormatted = FormatCrypto(volume),
                TotalItems = GetSafeInt(reader, "TotalItems"),
                OwnersCount = GetSafeInt(reader, "OwnersCount"),
                CreatedDate = GetSafeDateTime(reader, "CreatedDate")
            };
        }

        private NFT MapNFT(SqlDataReader reader)
        {
            return new NFT
            {
                NFTId = GetSafeInt(reader, "NFTId"),
                CollectionId = GetSafeInt(reader, "CollectionId"),
                CollectionName = GetSafeString(reader, "CollectionName"),
                TokenId = GetSafeString(reader, "TokenId"),
                Name = GetSafeString(reader, "Name"),
                Description = GetSafeString(reader, "Description"),
                ImageUrl = GetSafeString(reader, "ImageUrl"),
                OwnerId = GetSafeInt(reader, "OwnerId"),
                CreatorId = GetSafeInt(reader, "CreatorId"),
                CreatorUsername = GetSafeString(reader, "CreatorUsername"),
                CreatorPhoto = GetSafeString(reader, "CreatorPhoto"),
                Price = GetSafeDecimal(reader, "Price"),
                CurrencyId = GetSafeInt(reader, "CurrencyId"),
                CurrencyCode = GetSafeString(reader, "CurrencyCode"),
                IsForSale = GetSafeBool(reader, "IsForSale"),
                IsAuction = GetSafeBool(reader, "IsAuction"),
                AuctionEndDate = reader.IsDBNull(reader.GetOrdinal("AuctionEndDate"))
                    ? (DateTime?)null
                    : reader.GetDateTime(reader.GetOrdinal("AuctionEndDate")),
                Category = GetSafeString(reader, "Category") ?? "art",
                LikesCount = GetSafeInt(reader, "LikesCount"),
                CreatedDate = GetSafeDateTime(reader, "CreatedDate")
            };
        }

        private string FormatCrypto(decimal value)
        {
            if (value >= 1000000)
                return (value / 1000000).ToString("0.##") + "M";
            if (value >= 1000)
                return (value / 1000).ToString("0.##") + "K";
            return value.ToString("0.####");
        }

    }
}