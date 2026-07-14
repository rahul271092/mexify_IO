using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Mexify.Business.Services;
using Mexify.Utilities;
namespace Mexify.Web.User
{
    public partial class Investments : System.Web.UI.Page
    {
        private InvestmentService _service;

        protected void Page_Load(object sender, EventArgs e)
        {
            _service = new InvestmentService();

            if (!IsPostBack)
            {
                CalculateReturns();
            }
        }

        protected void btnCalculate_Click(object sender, EventArgs e)
        {
            CalculateReturns();
            btnInvest.Visible = true;
        }

        private void CalculateReturns()
        {
            try
            {
                decimal amount;
                if (!decimal.TryParse(txtAmount.Text, out amount) || amount <= 0)
                {
                    amount = 100;
                    txtAmount.Text = "100";
                }

                if (amount < 100)
                {
                    pnlError.Visible = true;
                    litError.Text = "Minimum investment is 100 USDT.";
                    return;
                }

                var fees = _service.CalculateFees(amount);

                litTotalReturn.Text = fees.TotalReturn.ToString("0.00") + " USDT";
                litDailyROI.Text = fees.DailyROI.ToString("0.00") + " USDT";
                litProfit.Text = fees.NetProfit.ToString("0.00") + " USDT";
            }
            catch (Exception ex)
            {
                Logger.Error("Calculation failed", ex);
            }
        }

        protected void btnInvest_Click(object sender, EventArgs e)
        {
            // Check authentication
            if (!Request.IsAuthenticated || Session["UserId"] == null)
            {
                Response.Redirect(ResolveUrl("~/Web/MetaMasklogin.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl)));
                return;
            }

            try
            {
                decimal amount;
                if (!decimal.TryParse(txtAmount.Text, out amount) || amount < 100)
                {
                    pnlError.Visible = true;
                    litError.Text = "Please enter a valid amount (minimum 100 USDT).";
                    return;
                }

                int userId = Convert.ToInt32(Session["UserId"]);
                var plan = _service.Get2XPlan();
                if (plan == null)
                {
                    pnlError.Visible = true;
                    litError.Text = "Investment plan not available.";
                    return;
                }

                var result = _service.CreateInvestment(userId, plan.PlanId, amount);

                if (result.Success)
                {
                    pnlSuccess.Visible = true;
                    litSuccess.Text = $"Investment created successfully! Investment ID: {result.InvestmentId}. Your 2X journey begins now.";
                    pnlError.Visible = false;
                    btnInvest.Visible = false;
                }
                else     
                {
                    pnlError.Visible = true;
                    litError.Text = result.ErrorMessage;
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Investment failed", ex);
                pnlError.Visible = true;
                litError.Text = "An error occurred. Please try again.";
            }
        }
    }
}