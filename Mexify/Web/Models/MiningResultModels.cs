using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Mexify.Models;

namespace Mexify.Web.Models
{
    public class MiningResultModels
    {
        public class PurchaseResult
        {
            public bool Success { get; set; }
            public string ErrorMessage { get; set; }
            public long ContractId { get; set; }
        }

        /// <summary>
        /// Result of claiming rewards or unstaking.
        /// </summary>
        public class ClaimResult
        {
            public bool Success { get; set; }
            public string ErrorMessage { get; set; }
            public decimal Amount { get; set; }
        }
    }
}