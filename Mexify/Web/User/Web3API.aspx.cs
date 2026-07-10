using Mexify.Business.Services;
using Mexify.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Mexify.Web.User
{
    public partial class Web3API : System.Web.UI.Page
    {
             protected void Page_Load(object sender, EventArgs e) { }

            [WebMethod(EnableSession = true)]
            public static string GetDepositAddress(string currency, string network)
            {
                try
                {
                    var service = new Web3Service();
                    var address = service.GetDepositAddress(currency, network);

                    if (address == null)
                    {
                        return JsonConvert.SerializeObject(new { success = false, message = "Not found" });
                    }

                    return JsonConvert.SerializeObject(new
                    {
                        success = true,
                        depositAddress = address.DepositAddress,
                        minDeposit = address.MinDeposit
                    });
                }
                catch (Exception ex)
                {
                    return JsonConvert.SerializeObject(new { success = false, message = ex.Message });
                }
            }

            [WebMethod(EnableSession = true)]
            public static string RecordDeposit(string walletAddress, string currencyCode, decimal amount, string network, string txHash, string fromAddress, string toAddress)
            {
                try
                {
                    int userId = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
                    var service = new Web3Service();

                    var request = new Web3DepositRequest
                    {
                        UserId = userId,
                        WalletAddress = walletAddress,
                        CurrencyCode = currencyCode,
                        Amount = amount,
                        Network = network,
                        TxHash = txHash,
                        FromAddress = fromAddress,
                        ToAddress = toAddress
                    };

                    var depositId = service.RecordDeposit(request);

                    return JsonConvert.SerializeObject(new { success = depositId > 0, depositId = depositId });
                }
                catch (Exception ex)
                {
                    return JsonConvert.SerializeObject(new { success = false, message = ex.Message });
                }
            }

            [WebMethod(EnableSession = true)]
            public static string ConfirmDeposit(string txHash, long blockNumber, decimal gasUsed, decimal gasPrice, int confirmations)
            {
                try
                {
                    var service = new Web3Service();
                    string message;
                    bool success = service.ConfirmDeposit(txHash, blockNumber, gasUsed, gasPrice, confirmations, out message);

                    return JsonConvert.SerializeObject(new { success = success, message = message });
                }
                catch (Exception ex)
                {
                    return JsonConvert.SerializeObject(new { success = false, message = ex.Message });
                }
            }
        }
    
}
