using System;
using System.Linq;
using System.Web.UI;
using Mexify.Business.Services;
using Mexify.Models;
using Mexify.Utilities;
using Mexify.Web.Models;

namespace Mexify.Web.User
{
    public partial class NewMiningContract : System.Web.UI.Page
    {
        private MiningService _miningService;
        private WalletService _walletService;
        private int _userId;
        private int _planId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Web/meta-login.aspx");
                return;
            }

            _userId = Convert.ToInt32(Session["UserId"]);
            _miningService = new MiningService();
            _walletService = new WalletService();


            _planId = Int32.Parse(Request.QueryString["planId"]);

            //if (!int.TryParse(Request.QueryString["planId"], out _planId) || _planId <= 0)
            //{
            //    Response.Redirect("~/Web/User/Mining.aspx");
            //    return;
            //}

            if (!IsPostBack)
            {
                LoadPlanDetails();
                LoadUserBalance();
            }
        }

        private void LoadPlanDetails()
        {
            try
            {
                MiningService _miningService;
                _miningService = new MiningService();
                Logger.Info("Load Plan Details function call");
                var plan = _miningService.GetPlanById(_planId);
                if (plan == null || !plan.IsActive)
                {
                    ShowError("This mining plan is no longer available.");
                    btnPurchase.Enabled = false;
                    return;
                }

                litPlanName.Text = plan.PlanName;
                litAlgorithm.Text = plan.Algorithm ?? "SHA-256";
                litHashrate.Text = plan.Hashrate;
                litDuration.Text = plan.ContractDays.ToString();
                litDailyOutput.Text = plan.DailyOutput.ToString("0.0000");
                litPower.Text = plan.PowerConsumption;
                litMaintenance.Text = plan.MaintenanceFeeFormatted ?? "Included";

                litPrice.Text = plan.Price.ToString("0.00");
                litTotal.Text = plan.Price.ToString("0.00");
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load plan details", ex);
                ShowError("Failed to load plan details. Please try again.");
            }
        }

        private void LoadUserBalance()
        {
            try
            {
                decimal usdtBalance = 0;
                var wallets = _walletService.GetUserWallets(_userId);

                if (wallets != null)
                {
                    var usdtWallet = wallets.FirstOrDefault(w => w.CurrencyCode == "PNC");
                    if (usdtWallet != null)
                    {
                        usdtBalance = usdtWallet.Balance;
                    }
                }

                litUserBalance.Text = usdtBalance.ToString("0.00");

                // Check if user has enough balance
                var plan = _miningService.GetPlanById(_planId);
                if (plan != null && usdtBalance < plan.Price)
                {
                    btnPurchase.Enabled = false;
                    btnPurchase.Text = "Insufficient USDT Balance";
                    btnPurchase.CssClass = "btn-purchase";
                    btnPurchase.Style.Add("background", "rgba(255, 59, 92, 0.2)");
                    btnPurchase.Style.Add("color", "#ff3b5c");
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load user balance", ex);
            }
        }

        protected void btnPurchase_Click(object sender, EventArgs e)
        {
            HideMessages();

            try
            {
                var result = _miningService.PurchaseMiningContract(_userId, _planId);

                if (result.Success)
                {
                    // Log activity
                    Logger.Info($"User {_userId} purchased mining contract #{result.ContractId} for plan {_planId}");

                    ShowSuccess($"Success! Your mining contract has been activated. Contract ID: #{result.ContractId}");
                    btnPurchase.Enabled = false;
                    btnPurchase.Text = "Purchase Successful";

                    // Redirect after 3 seconds
                    ClientScript.RegisterStartupScript(this.GetType(), "redirect",
                        "setTimeout(function(){ window.location.href = '" + ResolveUrl("~/Web/User/Mining.aspx") + "'; }, 3000);", true);
                }
                else
                {
                    ShowError(result.ErrorMessage ?? "Failed to purchase contract. Please try again.");
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Purchase failed", ex);
                ShowError("An unexpected error occurred: " + ex.Message);
            }
        }

        private void ShowError(string message)
        {
            pnlError.Visible = true;
            litError.Text = message;
        }

        private void ShowSuccess(string message)
        {
            pnlSuccess.Visible = true;
            litSuccess.Text = message;
        }

        private void HideMessages()
        {
            pnlError.Visible = false;
            pnlSuccess.Visible = false;
        }
    }
}