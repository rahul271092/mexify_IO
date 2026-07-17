using System;
using System.Collections.Generic;
using Mexify.DataAccess.Repositories;
using Mexify.Models;
using Mexify.Utilities;
using Mexify.Web.Models;

namespace Mexify.Business.Services
{
    public class NFTService
    {
        private readonly NFTRepository _repo;

        public NFTService()
        {
            _repo = new NFTRepository();
        }

        public List<NFTCollection> GetActiveCollections()
        {
            try { return _repo.GetActiveCollections(); }
            catch (Exception ex) { Logger.Error("Failed to get collections", ex); return new List<NFTCollection>(); }
        }

        public NFTCollection GetCollectionById(int collectionId)
        {
            try { return _repo.GetCollectionById(collectionId); }
            catch (Exception ex) { Logger.Error("Failed to get collection", ex); return null; }
        }

        public List<UserNFT> GetUserNFTs(int userId)
        {
            try { return _repo.GetUserNFTs(userId); }
            catch (Exception ex) { Logger.Error("Failed to get user NFTs", ex); return new List<UserNFT>(); }
        }

        public List<NFTTransaction> GetMintHistory(int userId, int count)
        {
            try { return _repo.GetMintHistory(userId, count); }
            catch (Exception ex) { Logger.Error("Failed to get mint history", ex); return new List<NFTTransaction>(); }
        }

        public MintNFTResult MintNFT(MintNFTRequest request)
        {
            try
            {
                if (request.Quantity < 1 || request.Quantity > 10)
                    return new MintNFTResult { Success = false, ErrorMessage = "Invalid quantity" };

                if (string.IsNullOrWhiteSpace(request.NFTName))
                    return new MintNFTResult { Success = false, ErrorMessage = "NFT name is required" };

                return _repo.MintNFT(request);
            }
            catch (Exception ex)
            {
                Logger.Error("Mint NFT failed", ex);
                return new MintNFTResult { Success = false, ErrorMessage = ex.Message };
            }
        }

        public List<NFTCollection> GetTrendingCollections(int count = 10)
        {
            try { return _repo.GetTrendingCollections(count); }
            catch (Exception ex) { Logger.Error("Failed to get trending collections", ex); return new List<NFTCollection>(); }
        }

        public List<NFT> GetNFTs(int _userId,string category, string sortBy, string search, int pageNumber, int pageSize)
        {
            try { return _repo.GetNFTs( _userId,category, sortBy, search, pageNumber, pageSize); }
            catch (Exception ex) { Logger.Error("Failed to get NFTs", ex); return new List<NFT>(); }
        }
    }
}