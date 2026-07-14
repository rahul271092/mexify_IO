using System;
using System.Collections.Generic;

namespace Mexify.Models
{
    public class SupportCategory
    {
        public int CategoryId { get; set; }
        public string CategoryName { get; set; }
        public string CategorySlug { get; set; }
        public string IconClass { get; set; }
        public string Description { get; set; }
    }

    public class SupportTicket
    {
        public long TicketId { get; set; }
        public string TicketNumber { get; set; }
        public string Subject { get; set; }
        public string InitialMessage { get; set; }
        public int Priority { get; set; }
        public string PriorityName { get; set; }
        public string PriorityColor { get; set; }
        public int Status { get; set; }
        public string StatusName { get; set; }
        public string StatusColor { get; set; }
        public string CategoryName { get; set; }
        public string CategoryIcon { get; set; }
        public int MessageCount { get; set; }
        public string LastMessage { get; set; }
        public bool HasNewReply { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime LastActivityDate { get; set; }
        public string TimeAgo { get; set; }

        public string StatusBadgeClass
        {
            get
            {
                if (Status == 0) return "badge-warning";
                if (Status == 1) return "badge-info";
                if (Status == 2) return "badge-success";
                if (Status == 3) return "badge-secondary";
                if (Status == 4) return "badge-danger";
                return "badge-muted";
            }
        }

    }

        public class TicketMessage
    {
        public long MessageId { get; set; }
        public int? UserId { get; set; }
        public bool IsAdmin { get; set; }
        public string Message { get; set; }
        public string AttachmentUrl { get; set; }
        public DateTime CreatedDate { get; set; }
        public string SenderName { get; set; }
        public string SenderIcon { get; set; }
        public string TimeAgo { get; set; }
    }

    public class FAQItem
    {
        public int FAQId { get; set; }
        public int CategoryId { get; set; }
        public string Question { get; set; }
        public string Answer { get; set; }
        public int ViewCount { get; set; }
        public string CategoryName { get; set; }
        public string CategoryIcon { get; set; }
    }

    public class CreateTicketResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public long TicketId { get; set; }
    }

}