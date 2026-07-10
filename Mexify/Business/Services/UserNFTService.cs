using System;
using System.Collections.Generic;
using Mexify.DataAccess.Repositories;
using Mexify.Models;
using Mexify.Utilities;
using Mexify.Web.Models;

namespace Mexify.Business.Services
{
    public class UserNFTService
    {
        private readonly UserNFTRepository _repository;

        public UserNFTService()
        {
            _repository = new UserNFTRepository();
        }

        public UserNFTSummary GetUserNFTSummary(int userId)
        {
            try { return _repository.GetUserNFTSummary(userId); }
            catch (Exception ex) { Logger.Error("Failed to get NFT summary", ex); return new UserNFTSummary(); }
        }

        public List<UserNFT> GetUserOwnedNFTs(int userId)
        {
            try { return _repository.GetUserOwnedNFTs(userId); }
            catch (Exception ex) { Logger.Error("Failed to get owned NFTs", ex); return new List<UserNFT>(); }
        }

        public List<UserNFT> GetUserCreatedNFTs(int userId)
        {
            try { return _repository.GetUserCreatedNFTs(userId); }
            catch (Exception ex) { Logger.Error("Failed to get created NFTs", ex); return new List<UserNFT>(); }
        }

        public List<NFTActivity> GetUserNFTActivity(int userId, int count)
        {
            try { return _repository.GetUserNFTActivity(userId, count); }
            catch (Exception ex) { Logger.Error("Failed to get NFT activity", ex); return new List<NFTActivity>(); }
        }

        public List<NFTCollection> GetUserCollections(int userId)
        {
            try { return _repository.GetUserCollections(userId); }
            catch (Exception ex) { Logger.Error("Failed to get collections", ex); return new List<NFTCollection>(); }
        }

        public List<CollectionDistributionItem> GetCollectionDistribution(int userId)
        {
            try { return _repository.GetCollectionDistribution(userId); }
            catch (Exception ex) { Logger.Error("Failed to get distribution", ex); return new List<CollectionDistributionItem>(); }
        }

        public List<NFTValuePoint> GetPortfolioValueHistory(int userId, int days)
        {
            try { return _repository.GetPortfolioValueHistory(userId, days); }
            catch (Exception ex) { Logger.Error("Failed to get value history", ex); return new List<NFTValuePoint>(); }
        }
    }
}