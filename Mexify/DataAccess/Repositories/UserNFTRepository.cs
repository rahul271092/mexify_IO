using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Mexify.Web.Models;
using Mexify.Models;

namespace Mexify.DataAccess.Repositories
{
    public class UserNFTRepository : BaseRepository
    {
        public UserNFTSummary GetUserNFTSummary(int userId)
        {
            var results = ExecuteStoredProcedure<UserNFTSummary>(
                "usp_GetUserNFTSummary",
                reader => new UserNFTSummary
                {
                    TotalValue = GetSafeDecimal(reader, "TotalValue"),
                    TotalOwned = GetSafeInt(reader, "TotalOwned"),
                    TotalCreated = GetSafeInt(reader, "TotalCreated"),
                    TotalSales = GetSafeDecimal(reader, "TotalSales"),
                    RoyaltiesEarned = GetSafeDecimal(reader, "RoyaltiesEarned"),
                    TotalPurchases = GetSafeDecimal(reader, "TotalPurchases"),
                    MintingFees = GetSafeDecimal(reader, "MintingFees")
                },
                CreateParameter("@UserId", userId)
            );
            return results.Count > 0 ? results[0] : new UserNFTSummary();
        }

        public List<UserNFT> GetUserOwnedNFTs(int userId)
        {
            return ExecuteStoredProcedure<UserNFT>(
                "usp_GetUserOwnedNFTs",
                reader => new UserNFT
                {
                    NFTId = GetSafeLong(reader, "NFTId"),
                    TokenId = GetSafeString(reader, "TokenId") ?? "0",
                    Title = GetSafeString(reader, "Title") ?? "Untitled",
                    ImageUrl = GetSafeString(reader, "ImageUrl") ?? "",
                    CollectionName = GetSafeString(reader, "CollectionName") ?? "Unknown",
                    CollectionId = GetSafeInt(reader, "CollectionId"),
                    CreatorName = GetSafeString(reader, "CreatorName") ?? "Unknown",
                    Rarity = GetSafeString(reader, "Rarity") ?? "Common",
                    CurrentValue = GetSafeDecimal(reader, "CurrentValue")
                },
                CreateParameter("@UserId", userId)
            );
        }

        public List<UserNFT> GetUserCreatedNFTs(int userId)
        {
            return ExecuteStoredProcedure<UserNFT>(
                "usp_GetUserCreatedNFTs",
                reader => new UserNFT
                {
                    NFTId = GetSafeLong(reader, "NFTId"),
                    TokenId = GetSafeString(reader, "TokenId") ?? "0",
                    Title = GetSafeString(reader, "Title") ?? "Untitled",
                    ImageUrl = GetSafeString(reader, "ImageUrl") ?? "",
                    CollectionName = GetSafeString(reader, "CollectionName") ?? "Unknown",
                    Rarity = GetSafeString(reader, "Rarity") ?? "Common",
                    LastSalePrice = GetSafeDecimal(reader, "LastSalePrice"),
                    Status = GetSafeInt(reader, "Status"),
                    StatusName = GetSafeString(reader, "StatusName") ?? "Owned"
                },
                CreateParameter("@UserId", userId)
            );
        }

        public List<NFTActivity> GetUserNFTActivity(int userId, int count)
        {
            return ExecuteStoredProcedure<NFTActivity>(
                "usp_GetUserNFTActivity",
                reader => new NFTActivity
                {
                    ActivityId = GetSafeLong(reader, "ActivityId"),
                    TypeClass = GetSafeString(reader, "TypeClass") ?? "buy",
                    Icon = GetSafeString(reader, "Icon") ?? "fas fa-shopping-cart",
                    Title = GetSafeString(reader, "Title") ?? "Activity",
                    NFTTitle = GetSafeString(reader, "NFTTitle") ?? "NFT",
                    Amount = GetSafeDecimal(reader, "Amount"),
                    TimeAgo = GetSafeString(reader, "TimeAgo") ?? "Just now",
                    CreatedDate = GetSafeDateTime(reader, "CreatedDate")
                },
                CreateParameter("@UserId", userId),
                CreateParameter("@Count", count)
            );
        }

        public List<NFTCollection> GetUserCollections(int userId)
        {
            return ExecuteStoredProcedure<NFTCollection>(
                "usp_GetUserNFTCollections",
                reader => new NFTCollection
                {
                    CollectionId = GetSafeInt(reader, "CollectionId"),
                    CollectionName = GetSafeString(reader, "CollectionName") ?? "Unknown"
                },
                CreateParameter("@UserId", userId)
            );
        }

        public List<CollectionDistributionItem> GetCollectionDistribution(int userId)
        {
            return ExecuteStoredProcedure<CollectionDistributionItem>(
                "usp_GetUserNFTCollectionDistribution",
                reader => new CollectionDistributionItem
                {
                    Name = GetSafeString(reader, "Name") ?? "Unknown",
                    Value = GetSafeInt(reader, "Value")
                },
                CreateParameter("@UserId", userId)
            );
        }

        public List<NFTValuePoint> GetPortfolioValueHistory(int userId, int days)
        {
            return ExecuteStoredProcedure<NFTValuePoint>(
                "usp_GetUserNFTValueHistory",
                reader => new NFTValuePoint
                {
                    Date = GetSafeDateTime(reader, "Date"),
                    Value = GetSafeDecimal(reader, "Value")
                },
                CreateParameter("@UserId", userId),
                CreateParameter("@Days", days)
            );
        }
    }
}