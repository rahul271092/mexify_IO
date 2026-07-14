using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Mexify.Web.Models;
using Mexify.Models;
using Mexify.Utilities;
using System.Data;

namespace Mexify.DataAccess.Repositories
{
    public class UserNFTRepository : BaseRepository
    {

        public List<UserNFT> GetUserOwnedNFTs(int userId)
        {
            var nfts = new List<UserNFT>();

            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_GetUserOwnedNFTs", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    conn.Open();

                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            nfts.Add(new UserNFT
                            {
                                UserNFTId = GetSafeLong(reader, "UserNFTId"),
                                UserId = GetSafeInt(reader, "UserId"),
                                NFTId = GetSafeLong(reader, "NFTId"),
                                CollectionId = Convert.ToInt32(reader["CollectionId"]),

                            //    CollectionId = reader["CollectionId"] == DBNull.Value ? (int?)null : Convert.ToInt32(reader["CollectionId"]),

                                PurchasePrice = GetSafeDecimal(reader, "PurchasePrice"),
                                // ✅ Use PurchaseDate (matches the table)
                                PurchaseDate = GetSafeDateTime(reader, "PurchaseDate"),

                                CurrentValue = GetSafeDecimal(reader, "CurrentValue"),
                                Status = GetSafeInt(reader, "Status"),
                                StatusName = GetSafeString(reader, "StatusName") ?? "",
                                StatusSlug = GetSafeString(reader, "StatusSlug") ?? "",

                                ProfitLoss = GetSafeDecimal(reader, "ProfitLoss"),
                                ProfitPercent = GetSafeDecimal(reader, "ProfitPercent"),

                                Title = GetSafeString(reader, "Title") ?? "Untitled",
                                ImageUrl = GetSafeString(reader, "ImageUrl") ?? "/Images/nft-placeholder.png",
                                TokenId = GetSafeString(reader, "TokenId") ?? "",
                                Rarity = GetSafeString(reader, "Rarity") ?? "Common",
                                RarityClass = GetSafeString(reader, "RarityClass") ?? "common",

                                ListPrice = reader["ListPrice"] == DBNull.Value ? (decimal?)null : Convert.ToDecimal(reader["ListPrice"]),
                                ListDate = reader["ListDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["ListDate"]),

                                SalePrice = reader["SalePrice"] == DBNull.Value ? (decimal?)null : Convert.ToDecimal(reader["SalePrice"]),
                                SaleDate = reader["SaleDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["SaleDate"]),

                                CollectionName = GetSafeString(reader, "CollectionName") ?? "",
                                DaysHeld = GetSafeInt(reader, "DaysHeld"),
                                CreatedDate = GetSafeDateTime(reader, "CreatedDate")
                            });
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Error($"Failed to get owned NFTs for User {userId}", ex);
            }

            return nfts;
        }


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

        //public List<UserNFT> GetUserOwnedNFTs(int userId)
        //{
        //    return ExecuteStoredProcedure<UserNFT>(
        //        "usp_GetUserOwnedNFTs",
        //        reader => new UserNFT
        //        {
        //            NFTId = GetSafeLong(reader, "NFTId"),
        //            TokenId = GetSafeString(reader, "TokenId") ?? "0",
        //            Title = GetSafeString(reader, "Title") ?? "Untitled",
        //            ImageUrl = GetSafeString(reader, "ImageUrl") ?? "",
        //            CollectionName = GetSafeString(reader, "CollectionName") ?? "Unknown",
        //            CollectionId = GetSafeInt(reader, "CollectionId"),
        //            CreatorName = GetSafeString(reader, "CreatorName") ?? "Unknown",
        //            Rarity = GetSafeString(reader, "Rarity") ?? "Common",
        //            CurrentValue = GetSafeDecimal(reader, "CurrentValue")
        //        },
        //        CreateParameter("@UserId", userId)
        //    );
        //}

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