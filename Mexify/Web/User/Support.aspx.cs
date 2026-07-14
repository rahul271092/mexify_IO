using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Mexify.DataAccess.Repositories;
using Mexify.Models;
using Mexify.Utilities;

namespace Mexify.Web.User
{
    public partial class Support : System.Web.UI.Page
    {
        private int _userId;
        private SupportRepository _repo;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Web/login.aspx", false);
                return;
            }

            _userId = Convert.ToInt32(Session["UserId"]);
            _repo = new SupportRepository();

            if (!IsPostBack)
            {
                LoadData();
            }
        }

        private void LoadData()
        {
            try
            {
                // Categories
                var categories = _repo.GetActiveCategories();
                rptCategories.DataSource = categories;
                rptCategories.DataBind();

                // Category dropdown
                ddlCategory.DataSource = categories;
                ddlCategory.DataValueField = "CategoryId";
                ddlCategory.DataTextField = "CategoryName";
                ddlCategory.DataBind();
                ddlCategory.Items.Insert(0, new ListItem("-- Select Category --", "0"));

                // FAQ
                var faqs = _repo.GetFAQ();
                rptFAQ.DataSource = faqs;
                rptFAQ.DataBind();
                pnlNoFAQ.Visible = faqs.Count == 0;

                // Tickets
                var tickets = _repo.GetUserTickets(_userId);
                rptTickets.DataSource = tickets;
                rptTickets.DataBind();
                pnlNoTickets.Visible = tickets.Count == 0;

                // Ticket count badge
                int openCount = tickets.Count(t => t.Status == 0 || t.Status == 1);
                litTicketCount.Text = openCount > 0 ? $"<span class='badge badge-accent ms-1'>{openCount}</span>" : "";
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load support data", ex);
            }
        }

        protected void btnSubmitTicket_Click(object sender, EventArgs e)
        {
            pnlFormError.Visible = false;
            pnlTicketSuccess.Visible = false;

            if (!Page.IsValid) return;

            int categoryId;
            if (!int.TryParse(ddlCategory.SelectedValue, out categoryId) || categoryId == 0)
            {
                ShowFormError("Please select a category.");
                return;
            }

            string subject = txtSubject.Text?.Trim();
            string message = txtTicketMessage.Text?.Trim();
            int priority = int.Parse(ddlPriority.SelectedValue);

            if (string.IsNullOrWhiteSpace(subject))
            {
                ShowFormError("Subject is required.");
                return;
            }

            if (string.IsNullOrWhiteSpace(message))
            {
                ShowFormError("Message is required.");
                return;
            }

            try
            {
                var result = _repo.CreateTicket(_userId, categoryId, subject, message, priority);

                if (result.Success)
                {
                    Logger.Info($"User {_userId} created support ticket #{result.TicketId}");
                    pnlTicketForm.Visible = false;
                    pnlTicketSuccess.Visible = true;
                    litSuccessMsg.Text = result.Message + " Our support team will review and respond shortly.";
                }
                else
                {
                    ShowFormError(result.Message);
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to submit ticket", ex);
                ShowFormError("An error occurred. Please try again.");
            }
        }

        private void ShowFormError(string message)
        {
            litFormError.Text = message;
            pnlFormError.Visible = true;
        }
    }
}