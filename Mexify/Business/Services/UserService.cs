using Mexify.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using static Mexify.Web.Models.RewardModels;

namespace Mexify.Business.Services
{
    public class UserService
    {

        UserService _userRepo;


        public UserService()
        {
            _userRepo = new UserService();
        }

        public RewardsHistoryResult GetUserRewardsHistory(int userId, int pageNumber = 1, int pageSize = 50)
        {
            try
            {
                return _userRepo.GetUserRewardsHistory(userId, pageNumber, pageSize);
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get rewards history", ex);
                return new RewardsHistoryResult();
            }
        }
    }
}