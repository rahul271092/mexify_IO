using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Mexify.Models;
using Mexify.Utilities;
using Mexify.Web.Models;

namespace Mexify.DataAccess.Repositories
{
    public class NFTRepository : BaseRepository
    {
        // =========================================
        // GET ACTIVE COLLECTIONS
        // =========================================
        public List<NFTCollection> GetActiveCollections()
        {
            try
            {
                return ExecuteStoredProcedure<NFTCollection>(
                    "usp_GetActiveCollections",
                    reader => new NFTCollection
                    {
                        CollectionId = GetSafeInt(reader, "CollectionId"),
                        CollectionName = GetSafeString(reader, "CollectionName") ?? "",
                        Description = GetSafeString(reader, "Description"),
                        CreatorName = GetSafeString(reader, "CreatorName") ?? "MEXIFY",
                        ImageUrl = GetSafeString(reader, "ImageUrl"),
                //        LogoUrl = GetSafeString(reader, "ImageUrl"),
                 //       BannerUrl = GetSafeString(reader, "BannerUrl"),
                        Blockchain = GetSafeString(reader, "Blockchain") ?? "BSC",
                      //  ContractAddress = GetSafeString(reader, "ContractAddress"),
                        MintPrice = GetSafeDecimal(reader, "MintPrice"),
                      //  FloorPrice = GetSafeDecimal(reader, "MintPrice"),
                      //  FloorPriceFormatted = GetSafeDecimal(reader, "MintPrice").ToString("0.00") + " PNC",
                    //    Volume = 0,
                        TotalItems = GetSafeInt(reader, "TotalItems"),
                        AvailableItems = GetSafeInt(reader, "AvailableItems"),
                        HoldersCount = GetSafeInt(reader, "HoldersCount"),
                        IsFeatured = GetSafeBool(reader, "IsFeatured"),
                        IsActive = GetSafeBool(reader, "IsActive"),
                        CreatedDate = GetSafeDateTime(reader, "CreatedDate")
                    }
                );
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get active collections", ex);
                return new List<NFTCollection>();
            }
        }

        // =========================================
        // GET COLLECTION BY ID
        // =========================================
        public NFTCollection GetCollectionById(int collectionId)
        {
            try
            {
                var results = ExecuteStoredProcedure<NFTCollection>(
                    "usp_GetCollectionById",
                    reader => new NFTCollection
                    {
                        CollectionId = GetSafeInt(reader, "CollectionId"),
                        CollectionName = GetSafeString(reader, "CollectionName") ?? "",
                        Description = GetSafeString(reader, "Description"),
                        CreatorName = GetSafeString(reader, "CreatorName") ?? "MEXIFY",
                        ImageUrl = GetSafeString(reader, "ImageUrl"),
                        Blockchain = GetSafeString(reader, "Blockchain") ?? "BSC",
                        MintPrice = GetSafeDecimal(reader, "MintPrice"),
                        TotalItems = GetSafeInt(reader, "TotalItems"),
                        AvailableItems = GetSafeInt(reader, "AvailableItems"),
                        HoldersCount = GetSafeInt(reader, "HoldersCount"),
                        IsFeatured = GetSafeBool(reader, "IsFeatured")
                    },
                    CreateParameter("@CollectionId", collectionId)
                );
                return results.Count > 0 ? results[0] : null;
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get collection by ID", ex);
                return null;
            }
        }

        // =========================================
        // GET USER NFTs
        // =========================================
        public List<UserNFT> GetUserNFTs(int userId)
        {
            try
            {
                return ExecuteStoredProcedure<UserNFT>(
                    "[usp_GetUserNFTs]",
                    reader => new UserNFT
                    {
                        UserNFTId = GetSafeLong(reader, "UserNFTId"),
                        UserId = GetSafeInt(reader, "UserId"),
                        CollectionId = GetSafeInt(reader, "CollectionId"),
                        CollectionName = GetSafeString(reader, "CollectionName") ?? "",
                        NFTName = GetSafeString(reader, "Name") ?? "",
                        Description = GetSafeString(reader, "Description") ?? " NFT Description",
                        ImageUrl = GetSafeString(reader, "ImageUrl"),
                        TokenId = GetSafeString(reader, "TokenId"),
                        TxHash = GetSafeString(reader, "TxHash"),
                        MintDate = GetSafeDateTime(reader, "MintDate")
                    },
                    CreateParameter("@UserId", userId)
                );
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get user NFTs", ex);
                return new List<UserNFT>();
            }
        }

        // =========================================
        // GET MINT HISTORY
        // =========================================
        public List<NFTTransaction> GetMintHistory(int userId, int count)
        {
            try
            {
                return ExecuteStoredProcedure<NFTTransaction>(
                    "[usp_GetNFTMintHistory]",
                    reader => new NFTTransaction
                    {
                        TransactionId = GetSafeLong(reader, "TransactionId"),
                        UserId = GetSafeInt(reader, "UserId"),
                        CollectionId = GetSafeInt(reader, "CollectionId"),
                        CollectionName = GetSafeString(reader, "CollectionName") ?? "",
                        NFTName = GetSafeString(reader, "Name") ?? "",
                        TokenId = GetSafeLong(reader, "TokenId"),
                        Price = GetSafeDecimal(reader, "Price"),
                        Status = GetSafeInt(reader, "Status"),
                        StatusName = GetSafeString(reader, "StatusName") ?? "Pending",
                        TxHash = GetSafeString(reader, "TxHash"),
                        MintDate = GetSafeDateTime(reader, "MintDate")
                    },
                    CreateParameter("@UserId", userId),
                    CreateParameter("@Count", count)
                );
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get mint history", ex);
                return new List<NFTTransaction>();
            }
        }

        // =========================================
        // MINT NFT
        // =========================================
        public MintNFTResult MintNFT(MintNFTRequest request)
        {
            var result = new MintNFTResult();
            try
            {
                var outputSuccess = new SqlParameter("@Success", SqlDbType.Bit) { Direction = ParameterDirection.Output };
                var outputMessage = new SqlParameter("@Message", SqlDbType.NVarChar, 500) { Direction = ParameterDirection.Output };
                var outputTokenId = new SqlParameter("@TokenId", SqlDbType.BigInt) { Direction = ParameterDirection.Output };
                var outputTxHash = new SqlParameter("@TxHash", SqlDbType.NVarChar, 255) { Direction = ParameterDirection.Output };

                ExecuteStoredProcedureNonQuery(
                    "usp_MintNFT",
                    CreateParameter("@UserId", request.UserId),
                    CreateParameter("@CollectionId", request.CollectionId),
                    CreateParameter("@NFTName", request.NFTName),
                    CreateParameter("@Description", (object)request.Description ?? DBNull.Value),
                    CreateParameter("@Quantity", request.Quantity),
                    CreateParameter("@RecipientAddress", (object)request.RecipientAddress ?? DBNull.Value),
                    outputSuccess, outputMessage, outputTokenId, outputTxHash
                );

                result.Success = outputSuccess.Value != DBNull.Value && Convert.ToBoolean(outputSuccess.Value);
                result.ErrorMessage = outputMessage.Value != DBNull.Value ? outputMessage.Value.ToString() : "";
                result.TokenId = outputTokenId.Value != DBNull.Value ? Convert.ToInt64(outputTokenId.Value) : 0;
                result.TxHash = outputTxHash.Value != DBNull.Value ? outputTxHash.Value.ToString() : "";
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.ErrorMessage = "System error: " + ex.Message;
                Logger.Error("Failed to mint NFT", ex);
            }
            return result;
        }

        // =========================================
        // GET TRENDING COLLECTIONS
        // =========================================
        public List<NFTCollection> GetTrendingCollections(int count)
        {
            try
            {
                return ExecuteStoredProcedure<NFTCollection>(
                    "usp_GetTrendingNFTCollections",
                    reader => new NFTCollection
                    {
                        CollectionId = GetSafeInt(reader, "CollectionId"),
                        CollectionName = GetSafeString(reader, "Name") ?? GetSafeString(reader, "CollectionName") ?? "",
                        Description = GetSafeString(reader, "Description"),
                        CreatorName = GetSafeString(reader, "CreatorName") ?? "MEXIFY",
                        ImageUrl = GetSafeString(reader, "LogoUrl") ?? GetSafeString(reader, "ImageUrl"),
                        MintPrice = GetSafeDecimal(reader, "FloorPrice"),
                        TotalItems = GetSafeInt(reader, "TotalItems"),
                        HoldersCount = GetSafeInt(reader, "OwnersCount"),
                        CreatedDate = GetSafeDateTime(reader, "CreatedDate")
                    },
                    CreateParameter("@Count", count)
                );
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get trending collections", ex);
                return new List<NFTCollection>();
            }
        }

        // =========================================
        // GET NFTs
        // =========================================
        public List<NFT> GetNFTs(int _userId,string category, string sortBy, string search, int pageNumber, int pageSize)
        {
            try
            {
                return ExecuteStoredProcedure<NFT>(
                    "[usp_GetNFTs]",
                    reader => new NFT
                    {
                        NFTId = GetSafeInt(reader, "NFTId"),
                        CollectionId = GetSafeInt(reader, "CollectionId"),
                        CollectionName = GetSafeString(reader, "CollectionName") ?? "",
                        TokenId = GetSafeString(reader, "TokenId") ?? "",
                        Name = GetSafeString(reader, "Name") ?? "",
                        Description = GetSafeString(reader, "Description"),
                        ImageUrl = GetSafeString(reader, "ImageUrl"),
                        OwnerId = GetSafeInt(reader, "OwnerId"),
                        CreatorId = GetSafeInt(reader, "CreatorId"),
                        CreatorUsername = GetSafeString(reader, "CreatorUsername"),
                        Price = GetSafeDecimal(reader, "Price"),
                        CurrencyCode = GetSafeString(reader, "CurrencyCode") ?? "PNC",
                        IsForSale = GetSafeBool(reader, "IsForSale"),
                        Category = GetSafeString(reader, "Category") ?? "art",
                        LikesCount = GetSafeInt(reader, "LikesCount"),
                        CreatedDate = GetSafeDateTime(reader, "CreatedDate")
                    },
                    CreateParameter("@Category", (object)category ?? DBNull.Value),
                    CreateParameter("@SortBy", (object)sortBy ?? "newest"),
                    CreateParameter("@Search", (object)search ?? DBNull.Value),
                    CreateParameter("@PageNumber", pageNumber),
                    CreateParameter("@PageSize", pageSize),
                    CreateParameter("@UserId", _userId)
                );
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get NFTs", ex);
                return new List<NFT>();
            }
        }
    }
}