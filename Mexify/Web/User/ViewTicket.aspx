<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="ViewTicket.aspx.cs" Inherits="Mexify.Web.User.ViewTicke" %>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3" data-aos="fade-up">
        <div>
            <a href="Support.aspx#tickets" class="text-muted small mb-2 d-inline-block">
                <i class="fas fa-arrow-left me-1"></i> Back to My Tickets
            </a>
            <h2 class="text-white mb-1">
                <code class="text-gold"><asp:Literal ID="litTicketNumber" runat="server" /></code>
            </h2>
            <h4 class="text-white"><asp:Literal ID="litSubject" runat="server" /></h4>
        </div>
        <div class="text-end">
            <span class='badge badge-<asp:Literal ID="litStatusColor" runat="server" /> fs-6'>
                <asp:Literal ID="litStatus" runat="server" />
            </span>
            <div class="text-muted small mt-1">
                <i class='<asp:Literal ID="litCategoryIcon" runat="server" /> me-1'></i>
                <asp:Literal ID="litCategory" runat="server" />
            </div>
        </div>
    </div>

    <!-- Ticket Info -->
    <div class="glass-card p-3 mb-4" data-aos="fade-up">
        <div class="row g-3">
            <div class="col-md-4">
                <small class="text-muted d-block">Priority</small>
                <span class='badge badge-<asp:Literal ID="litPriorityColor" runat="server" />'>
                    <asp:Literal ID="litPriority" runat="server" />
                </span>
            </div>
            <div class="col-md-4">
                <small class="text-muted d-block">Created</small>
                <span class="text-white"><asp:Literal ID="litCreated" runat="server" /></span>
            </div>
            <div class="col-md-4">
                <small class="text-muted d-block">Last Activity</small>
                <span class="text-white"><asp:Literal ID="litLastActivity" runat="server" /></span>
            </div>
        </div>
    </div>

    <!-- Conversation -->
    <div class="glass-card p-4 mb-4" data-aos="fade-up">
        <h5 class="text-white mb-4"><i class="fas fa-comments text-gold me-2"></i>Conversation</h5>
        
        <asp:Repeater ID="rptMessages" runat="server">
            <ItemTemplate>
                <div class='message-bubble <%# Convert.ToBoolean(Eval("IsAdmin")) ? "admin" : "user" %>'>
                    <div class="message-sender">
                        <i class='<%# Eval("SenderIcon") %> me-1'></i><%# Eval("SenderName") %>
                    </div>
                    <div class="message-text"><%# Eval("Message") %></div>
                    <div class="message-time"><%# Eval("TimeAgo") %></div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <!-- Reply Form (only if ticket is open/in-progress) -->
    <asp:Panel ID="pnlReplyForm" runat="server">
        <div class="glass-card p-4" data-aos="fade-up">
            <h5 class="text-white mb-3"><i class="fas fa-reply text-gold me-2"></i>Reply</h5>
            
            <asp:Panel ID="pnlReplyError" runat="server" Visible="false">
                <div class="alert alert-danger mb-3" style="background: rgba(255, 59, 92, 0.1); border: 1px solid rgba(255, 59, 92, 0.3); color: #ff3b5c;">
                    <asp:Literal ID="litReplyError" runat="server" />
                </div>
            </asp:Panel>

            <asp:TextBox ID="txtReply" runat="server" CssClass="form-control bg-dark text-white border-secondary mb-3" 
                TextMode="MultiLine" Rows="4" placeholder="Type your reply here..." />
            
            <div class="d-flex justify-content-end gap-2">
                <a href="Support.aspx#tickets" class="btn btn-outline-glass">Cancel</a>
                <asp:Button ID="btnSendReply" runat="server" Text="Send Reply" CssClass="btn btn-primary-glow" OnClick="btnSendReply_Click" />
            </div>
        </div>
    </asp:Panel>

    <!-- Closed State -->
    <asp:Panel ID="pnlClosed" runat="server" Visible="false">
        <div class="glass-card p-4 text-center">
            <i class="fas fa-lock fa-2x text-muted mb-2"></i>
            <p class="text-muted mb-0">This ticket is closed. If you need further assistance, please create a new ticket.</p>
            <a href="Support.aspx#submit" class="btn btn-primary-glow mt-3">Create New Ticket</a>
        </div>
    </asp:Panel>

</asp:Content>