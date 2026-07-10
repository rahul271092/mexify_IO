using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Mexify.DataAccess.Repositories;
using Mexify.Models;
using Mexify.Utilities;

namespace Mexify.Business.Services
{
    public class Web3Service
    {
        private readonly Web3Repository _repo;

        public Web3Service()
        {
            _repo = new Web3Repository();
        }

        public long RecordDeposit(Web3DepositRequest request)
        {
            try
            {
                return _repo.RecordWeb3Deposit(request);
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to record Web3 deposit", ex);
                return -1;
            }
        }

        public bool ConfirmDeposit(string txHash, long blockNumber, decimal gasUsed, decimal gasPrice, int confirmations, out string message)
        {
            try
            {
                return _repo.ConfirmWeb3Deposit(txHash, blockNumber, gasUsed, gasPrice, confirmations, out message);
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to confirm Web3 deposit", ex);
                message = ex.Message;
                return false;
            }
        }

        public List<Web3Deposit> GetUserDeposits(int userId, int count = 50)
        {
            try
            {
                return _repo.GetUserWeb3Deposits(userId, count);
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get user Web3 deposits", ex);
                return new List<Web3Deposit>();
            }
        }

        public PlatformDepositAddress GetDepositAddress(string currencyCode, string network)
        {
            try
            {
                return _repo.GetPlatformDepositAddress(currencyCode, network);
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get platform deposit address", ex);
                return null;
            }
        }

        // Get network chain ID for MetaMask
        public int GetNetworkChainId(string network)
        {
            switch (network.ToLower())
            {
                case "ethereum":
                case "eth":
                    return 1;
                case "bsc":
                case "binance":
                    return 56;
                case "polygon":
                case "matic":
                    return 137;
                case "arbitrum":
                    return 42161;
                default:
                    return 1;
            }
        }

        // Get network RPC URL
        public string GetNetworkRpcUrl(string network)
        {
            switch (network.ToLower())
            {
                case "ethereum":
                case "eth":
                    return "https://mainnet.infura.io/v3/YOUR_INFURA_KEY";
                case "bsc":
                case "binance":
                    return "https://bsc-dataseed.binance.org/";
                case "polygon":
                case "matic":
                    return "https://polygon-rpc.com/";
                default:
                    return "https://mainnet.infura.io/v3/YOUR_INFURA_KEY";
            }
        }
    }
}