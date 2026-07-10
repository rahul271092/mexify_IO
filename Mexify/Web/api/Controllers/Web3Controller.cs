using System;
using System.Web.Http;
using Mexify.Business.Services;
using Mexify.Models;

namespace Mexify.Web.Controllers
{
    [RoutePrefix("api/Web3")]
    public class Web3Controller : ApiController
    {
        private readonly Web3Service _web3Service;

        public Web3Controller()
        {
            _web3Service = new Web3Service();
        }

        [HttpGet]
        [Route("GetDepositAddress")]
        public IHttpActionResult GetDepositAddress(string currency, string network)
        {
            try
            {
                var address = _web3Service.GetDepositAddress(currency, network);

                if (address == null)
                {
                    return Ok(new { success = false, message = "Deposit address not found" });
                }

                return Ok(new
                {
                    success = true,
                    depositAddress = address.DepositAddress,
                    minDeposit = address.MinDeposit,
                    currency = address.CurrencyCode,
                    network = address.Network
                });
            }
            catch (Exception ex)
            {
                return Ok(new { success = false, message = ex.Message });
            }
        }

        [HttpPost]
        [Route("RecordDeposit")]
        public IHttpActionResult RecordDeposit([FromBody] Web3DepositRequest request)
        {
            try
            {
                int userId = Convert.ToInt32(System.Web.HttpContext.Current.Session["UserId"]);
                request.UserId = userId;

                var depositId = _web3Service.RecordDeposit(request);

                if (depositId > 0)
                {
                    return Ok(new { success = true, depositId = depositId });
                }
                else if (depositId == -1)
                {
                    return Ok(new { success = false, message = "Transaction already recorded" });
                }
                else
                {
                    return Ok(new { success = false, message = "Invalid currency" });
                }
            }
            catch (Exception ex)
            {
                return Ok(new { success = false, message = ex.Message });
            }
        }

        [HttpPost]
        [Route("ConfirmDeposit")]
        public IHttpActionResult ConfirmDeposit([FromBody] dynamic data)
        {
            try
            {
                string txHash = data.txHash;
                long blockNumber = (long)data.blockNumber;
                decimal gasUsed = Convert.ToDecimal(data.gasUsed);
                decimal gasPrice = Convert.ToDecimal(data.gasPrice);
                int confirmations = (int)data.confirmations;

                string message;
                bool success = _web3Service.ConfirmDeposit(txHash, blockNumber, gasUsed, gasPrice, confirmations, out message);

                return Ok(new { success = success, message = message });
            }
            catch (Exception ex)
            {
                return Ok(new { success = false, message = ex.Message });
            }
        }
    }
}