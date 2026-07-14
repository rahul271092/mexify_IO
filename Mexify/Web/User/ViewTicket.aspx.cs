using System;
using System.Collections.Generic;
using System.Web.UI;
using Mexify.DataAccess.Repositories;
using Mexify.Models;
using Mexify.Utilities;

namespace Mexify.Web.User
{
    public partial class ViewTicket : System.Web.UI.Page
    {
        private int _userId;
        private long _ticketId;
        private SupportRepository _repo;
        private readonly object messages;

        public object ticket { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Web/login.aspx", false);
                return;
            }

            _userId = Convert.ToInt32(Session["UserId"]);
            _repo = new SupportRepository();

            if (!long.TryParse(Request.QueryString["id"], out _ticketId))
            {
                Response.Redirect("Support.aspx#tickets", false);
                return;
            }

            if (!IsPostBack)
            {
      //          LoadTicket();
            }
        }

        //public string Priority
        //{
        //    get
        //    {
        //        if (0 == 0) return "badge-warning";
        //        if (1 == 1) return "badge-info";
        //        if (2 == 2) return "badge-success";
        //        if (3 == 3) return "badge-secondary";
        //        if (4 == 4) return "badge-danger";
        //        return "badge-muted";
        //    }
        //}

 //       private void LoadTicket()
 //       {
 //           try
 //           {
 //               var(Tuple<SupportTicket>, List<TicketMessage>)  = _repo.GetTicketDetails(_ticketId, _userId);

 //               if (ticket == null)
 //               {
 //                   Response.Redirect("Support.aspx#tickets", false);
 //                   return;
 //               }

 //               litTicketNumber.Text = ticket.TicketNumber;
 //               litSubject.Text = ticket.Subject;
 //               litStatus.Text = ticket.StatusName;
 //               litStatusColor.Text = ticket.StatusBadgeClass.Replace("badge-", "");
 //               litCategory.Text = ticket.CategoryName;
 //               litCategoryIcon.Text = ticket.CategoryIcon;
 //               litPriority.Text = ticket.PriorityName;
 //               //litPriorityColor.Text = ticket.Priority switch
 //               //{
 //               //    1 => "muted", 2 => "info", 3 => "warning", 4 => "danger", _ => "muted"
 //               //};

                

 //               litCreated.Text = ticket.CreatedDate.ToString("MMM dd, yyyy HH:mm");
 //               litLastActivity.Text = ticket.LastActivityDate.ToString("MMM dd, yyyy HH:mm");

 //               rptMessages.DataSource = messages;
 //               rptMessages.DataBind();



          


 //           // Show reply form only if ticket is open/in-progress
 //           if (ticket.Status == 0 || ticket.Status == 1)
 //           {
 //               pnlReplyForm.Visible = true;
 //               pnlClosed.Visible = false;
 //           }
 //           else
 //           {
 //               pnlReplyForm.Visible = false;
 //               pnlClosed.Visible = true;
 //           }

 //}
 //           catch (Exception ex)
 //           {
 //               Logger.Error("Failed to load ticket", ex);
 //               Response.Redirect("Support.aspx#tickets", false);
 //           }
 //       }

        private Tuple<SupportTicket, List<TicketMessage>> var()
        {
            throw new NotImplementedException();
        }

    //    protected void btnSendReply_Click(object sender, EventArgs e)
    // {
    //   pnlReplyError.Visible = false;
    //string reply = txtReply.Text?.Trim();

    //if (string.IsNullOrWhiteSpace(reply))
    //{
    //    litReplyError.Text = "Reply cannot be empty.";
    //    pnlReplyError.Visible = true;
    //    return;
    //}

  


    }
}