using Mexify.DataAccess.Repositories;
using Mexify.Utilities;
using Mexify.Utilities;
using Mexify.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Business.Services
{
    public class NFTService
    {

        private readonly NFTRepository _repository;

        public NFTService()
        {
            _repository = new NFTRepository();
        }

        public List<NFTCollection> GetTrendingCollections(int count)
        {
            try
            {
                return _repository.GetTrendingCollections(count);
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load trending collections", ex);
                return new List<NFTCollection>();
            }
        }

        public List<NFT> GetNFTs(string category, string sortBy, string search, int pageNumber, int pageSize)
        {
            try
            {
                if (string.IsNullOrEmpty(category)) category = "art";
                if (string.IsNullOrEmpty(sortBy)) sortBy = "recent";
                if (string.IsNullOrEmpty(search)) search = "";

                return _repository.GetNFTs(category, sortBy, search, pageNumber, pageSize);
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load NFTs", ex);
                return new List<NFT>();
            }
        }
    }
}