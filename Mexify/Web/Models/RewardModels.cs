using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class RewardModels
    {
        public class UserRewardHistory
        {
            public long TransactionId { get; set; }
            public DateTime EarnedDate { get; set; }
            public string RewardSource { get; set; }
            public string RewardType { get; set; }
            public string CurrencyCode { get; set; }
            public decimal RewardAmount { get; set; }
            public string Status { get; set; }
        }

        public class RewardsHistoryResult
        {
            public List<UserRewardHistory> Transactions { get; set; }
            public int TotalRecords { get; set; }
            public int PageNumber { get; set; }
            public int PageSize { get; set; }
            public int TotalPages => (int)Math.Ceiling((double)TotalRecords / PageSize);

            public RewardsHistoryResult()
            {
                Transactions = new List<UserRewardHistory>();
            }
        }
    }


}