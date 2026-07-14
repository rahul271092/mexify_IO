<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="Support.aspx.cs" Inherits="Mexify.Web.User.Support" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .support-tabs { display: flex; gap: 8px; margin-bottom: 24px; flex-wrap: wrap; }
        .support-tab { padding: 10px 20px; background: var(--glass-bg); border: 1px solid var(--glass-border); border-radius: 50px; color: var(--text-muted); cursor: pointer; transition: all 0.2s; text-decoration: none; }
        .support-tab:hover { color: var(--text-white); border-color: var(--secondary); }
        .support-tab.active { background: linear-gradient(135deg, rgba(255, 215, 0, 0.15), rgba(255, 165, 0, 0.05)); border-color: var(--gold); color: var(--gold); }

        .category-card { background: var(--glass-bg); border: 1px solid var(--glass-border); border-radius: 12px; padding: 20px; cursor: pointer; transition: all 0.3s; text-decoration: none; display: block; height: 100%; }
        .category-card:hover { border-color: var(--gold); transform: translateY(-3px); box-shadow: 0 10px 30px rgba(255, 215, 0, 0.1); }
        .category-card i { font-size: 1.8rem; color: var(--gold); margin-bottom: 12px; }
        .category-card h6 { color: var(--text-white); margin-bottom: 6px; }
        .category-card p { color: var(--text-muted); font-size: 0.85rem; margin: 0; }

        .ticket-item { background: var(--glass-bg); border: 1px solid var(--glass-border); border-radius: 12px; padding: 16px; margin-bottom: 12px; transition: all 0.2s; cursor: pointer; text-decoration: none; display: block; }
        .ticket-item:hover { border-color: var(--secondary); transform: translateX(3px); }
        .ticket-item.has-reply { border-left: 3px solid var(--accent); }

        .faq-item { background: var(--glass-bg); border: 1px solid var(--glass-border); border-radius: 10px; margin-bottom: 10px; overflow: hidden; }
        .faq-question { padding: 16px 20px; cursor: pointer; display: flex; justify-content: space-between; align-items: center; color: var(--text-white); font-weight: 600; transition: background 0.2s; }
        .faq-question:hover { background: rgba(255, 215, 0, 0.03); }
        .faq-question i { color: var(--gold); transition: transform 0.3s; }
        .faq-item.open .faq-question i { transform: rotate(180deg); }
        .faq-answer { padding: 0 20px; max-height: 0; overflow: hidden; color: var(--text-gray); transition: all 0.3s ease; }
        .faq-item.open .faq-answer { padding: 0 20px 16px; max-height: 500px; }

        .message-bubble { padding: 14px 18px; border-radius: 14px; margin-bottom: 12px; max-width: 85%; }
        .message-bubble.user { background: rgba(0, 212, 255, 0.08); border: 1px solid rgba(0, 212, 255, 0.2); margin-left: auto; border-bottom-right-radius: 4px; }
        .message-bubble.admin { background: rgba(255, 215, 0, 0.08); border: 1px solid rgba(255, 215, 0, 0.2); border-bottom-left-radius: 4px; }
        .message-sender { font-size: 0.8rem; font-weight: 600; margin-bottom: 4px; }
        .message-bubble.user .message-sender { color: var(--secondary); }
        .message-bubble.admin .message-sender { color: var(--gold); }
        .message-text { color: var(--text-white); line-height: 1.5; word-wrap: break-word; }
        .message-time { font-size: 0.7rem; color: var(--text-muted); margin-top: 6px; }

        .contact-card { background: linear-gradient(135deg, rgba(255, 215, 0, 0.05), rgba(0, 212, 255, 0.03)); border: 1px solid var(--glass-border); border-radius: 12px; padding: 20px; text-align: center; }
        .contact-card i { font-size: 2rem; color: var(--gold); margin-bottom: 10px; }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3" data-aos="fade-up">
        <div>
            <h2 class="text-white mb-1"><i class="fas fa-life-ring text-gold me-2"></i>Support Center</h2>
            <p class="text-muted mb-0">We're here to help. Browse FAQs or submit a ticket.</p>
        </div>
        <a href="#submit" class="btn btn-primary-glow" onclick="showTab('submit'); return false;">
            <i class="fas fa-plus me-2"></i> New Ticket
        </a>
    </div>

    <!-- Tabs -->
    <div class="support-tabs" data-aos="fade-up">
        <a href="#" class="support-tab active" data-tab="home" onclick="showTab('home'); return false;">
            <i class="fas fa-home me-1"></i> Home
        </a>
        <a href="#" class="support-tab" data-tab="faq" onclick="showTab('faq'); return false;">
            <i class="fas fa-question-circle me-1"></i> FAQ
        </a>
        <a href="#" class="support-tab" data-tab="submit" onclick="showTab('submit'); return false;">
            <i class="fas fa-paper-plane me-1"></i> Submit Ticket
        </a>
        <a href="#" class="support-tab" data-tab="tickets" onclick="showTab('tickets'); return false;">
            <i class="fas fa-list me-1"></i> My Tickets
            <asp:Literal ID="litTicketCount" runat="server" />
        </a>
    </div>

    <!-- ==================== HOME TAB ==================== -->
    <asp:Panel ID="pnlHome" runat="server">
        <!-- Quick Stats -->
        <div class="row g-3 mb-4">
            <div class="col-md-4" data-aos="fade-up">
                <div class="contact-card">
                    <i class="fas fa-clock"></i>
                    <h6 class="text-white">Response Time</h6>
                    <div class="text-gold fs-4 fw-bold">~2 hrs</div>
                    <small class="text-muted">Average response</small>
                </div>
            </div>
            <div class="col-md-4" data-aos="fade-up" data-aos-delay="100">
                <div class="contact-card">
                    <i class="fas fa-headset"></i>
                    <h6 class="text-white">Live Support</h6>
                    <div class="text-accent fs-4 fw-bold">24/7</div>
                    <small class="text-muted">Always available</small>
                </div>
            </div>
            <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
                <div class="contact-card">
                    <i class="fas fa-shield-alt"></i>
                    <h6 class="text-white">Satisfaction</h6>
                    <div class="text-gold fs-4 fw-bold">98%</div>
                    <small class="text-muted">Customer rating</small>
                </div>
            </div>
        </div>

        <!-- Categories -->
        <h4 class="text-white mb-3" data-aos="fade-up"><i class="fas fa-th-large text-gold me-2"></i>How can we help you?</h4>
        <div class="row g-3 mb-4">
            <asp:Repeater ID="rptCategories" runat="server">
                <ItemTemplate>
                    <div class="col-md-4 col-sm-6" data-aos="fade-up">
                        <a href="#" class="category-card" onclick="selectCategoryAndSubmit(<%# Eval("CategoryId") %>); return false;">
                            <i class='<%# Eval("IconClass") %>'></i>
                            <h6><%# Eval("CategoryName") %></h6>
                            <p><%# Eval("Description") %></p>
                        </a>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- Contact Info -->
        <div class="row g-3">
            <div class="col-md-6" data-aos="fade-up">
                <div class="glass-card p-4 h-100">
                    <h5 class="text-white mb-3"><i class="fas fa-envelope text-gold me-2"></i>Email Support</h5>
                    <p class="text-muted mb-3">For non-urgent inquiries, email us anytime.</p>
                    <a href="mailto:support@mexify.com" class="text-gold fw-600">
                        <i class="fas fa-paper-plane me-2"></i>support@mexify.com
                    </a>
                </div>
            </div>
            <div class="col-md-6" data-aos="fade-up" data-aos-delay="100">
                <div class="glass-card p-4 h-100">
                    <h5 class="text-white mb-3"><i class="fab fa-telegram text-gold me-2"></i>Telegram</h5>
                    <p class="text-muted mb-3">Join our community for quick help.</p>
                    <a href="https://t.me/mexify" target="_blank" class="text-gold fw-600">
                        <i class="fab fa-telegram me-2"></i>@mexify
                    </a>
                </div>
            </div>
        </div>
    </asp:Panel>

    <!-- ==================== FAQ TAB ==================== -->
    <asp:Panel ID="pnlFAQ" runat="server" Visible="false">
        <!-- Search -->
        <div class="glass-card p-3 mb-4" data-aos="fade-up">
            <div class="input-group">
                <span class="input-group-text bg-dark border-secondary"><i class="fas fa-search text-muted"></i></span>
                <asp:TextBox ID="txtFAQSearch" runat="server" CssClass="form-control bg-dark text-white border-secondary" placeholder="Search FAQs..." onkeyup="filterFAQ(this.value)" />
            </div>
        </div>

        <asp:Repeater ID="rptFAQ" runat="server">
            <ItemTemplate>
                <div class="faq-item" data-aos="fade-up">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        <div>
                            <small class="text-gold"><i class='<%# Eval("CategoryIcon") %> me-1'></i><%# Eval("CategoryName") %></small>
                            <div class="mt-1"><%# Eval("Question") %></div>
                        </div>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p><%# Eval("Answer") %></p>
                        <small class="text-muted"><i class="fas fa-eye me-1"></i><%# Eval("ViewCount") %> views</small>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoFAQ" runat="server" Visible="false">
            <div class="glass-card text-center p-5">
                <i class="fas fa-search fa-3x text-muted mb-3"></i>
                <h5 class="text-white">No FAQs Found</h5>
                <p class="text-muted">Try a different search or submit a ticket.</p>
            </div>
        </asp:Panel>
    </asp:Panel>

    <!-- ==================== SUBMIT TICKET TAB ==================== -->
    <asp:Panel ID="pnlSubmit" runat="server" Visible="false">
        <asp:Panel ID="pnlTicketSuccess" runat="server" Visible="false">
            <div class="glass-card p-5 text-center" style="border-color: rgba(0, 255, 178, 0.3);">
                <i class="fas fa-check-circle fa-4x text-accent mb-3"></i>
                <h3 class="text-white">Ticket Created!</h3>
                <p class="text-muted"><asp:Literal ID="litSuccessMsg" runat="server" /></p>
                <div class="d-flex justify-content-center gap-3 mt-3">
                    <a href="#" class="btn btn-primary-glow" onclick="showTab('tickets'); return false;">View My Tickets</a>
                    <a href="#" class="btn btn-outline-glass" onclick="showTab('submit'); resetForm(); return false;">Create Another</a>
                </div>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlTicketForm" runat="server">
            <div class="glass-card p-4" data-aos="fade-up">
                <h4 class="text-white mb-4"><i class="fas fa-paper-plane text-gold me-2"></i>Submit a Ticket</h4>

                <asp:Panel ID="pnlFormError" runat="server" Visible="false">
                    <div class="alert alert-danger" style="background: rgba(255, 59, 92, 0.1); border: 1px solid rgba(255, 59, 92, 0.3); color: #ff3b5c;">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        <asp:Literal ID="litFormError" runat="server" />
                    </div>
                </asp:Panel>

                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label text-muted small">Category *</label>
                        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select bg-dark text-white border-secondary">
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-muted small">Priority</label>
                        <asp:DropDownList ID="ddlPriority" runat="server" CssClass="form-select bg-dark text-white border-secondary">
                            <asp:ListItem Value="1" Text="Low - General inquiry"></asp:ListItem>
                            <asp:ListItem Value="2" Text="Normal - Standard issue" Selected="True"></asp:ListItem>
                            <asp:ListItem Value="3" Text="High - Urgent matter"></asp:ListItem>
                            <asp:ListItem Value="4" Text="Urgent - Account blocked/funds at risk"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-12">
                        <label class="form-label text-muted small">Subject *</label>
                        <asp:TextBox ID="txtSubject" runat="server" CssClass="form-control bg-dark text-white border-secondary" MaxLength="200" placeholder="Brief description of your issue" />
                        <asp:RequiredFieldValidator ID="rfvSubject" runat="server" ControlToValidate="txtSubject" ErrorMessage="Subject is required" ForeColor="#ff3b5c" Display="Dynamic" />
                    </div>
                    <div class="col-12">
                        <label class="form-label text-muted small">Message *</label>
                        <asp:TextBox ID="txtTicketMessage" runat="server" CssClass="form-control bg-dark text-white border-secondary" TextMode="MultiLine" Rows="6" MaxLength="4000" placeholder="Please describe your issue in detail. Include any relevant account information, transaction IDs, or error messages." />
                        <asp:RequiredFieldValidator ID="rfvMessage" runat="server" ControlToValidate="txtTicketMessage" ErrorMessage="Message is required" ForeColor="#ff3b5c" Display="Dynamic" />
                        <small class="text-muted mt-1 d-block">Be as specific as possible to help us resolve your issue faster.</small>
                    </div>
                    <div class="col-12">
                        <div class="p-3" style="background: rgba(0, 212, 255, 0.05); border: 1px solid rgba(0, 212, 255, 0.2); border-radius: 10px;">
                            <small class="text-muted">
                                <i class="fas fa-info-circle text-secondary me-1"></i>
                                <strong>Response Time:</strong> We typically respond within 2 hours during business hours. Urgent tickets are prioritized.
                            </small>
                        </div>
                    </div>
                    <div class="col-12">
                        <asp:Button ID="btnSubmitTicket" runat="server" Text="🚀 Submit Ticket" CssClass="btn btn-primary-glow w-100 py-3" OnClick="btnSubmitTicket_Click" />
                    </div>
                </div>
            </div>
        </asp:Panel>
    </asp:Panel>

    <!-- ==================== MY TICKETS TAB ==================== -->
    <asp:Panel ID="pnlTickets" runat="server" Visible="false">
        <!-- Filters -->
        <div class="glass-card p-3 mb-4" data-aos="fade-up">
            <div class="d-flex flex-wrap gap-2">
                <a href="#" class="btn btn-sm btn-primary" onclick="filterTickets(-1); return false;">All</a>
                <a href="#" class="btn btn-sm btn-outline" onclick="filterTickets(0); return false;">Open</a>
                <a href="#" class="btn btn-sm btn-outline" onclick="filterTickets(1); return false;">In Progress</a>
                <a href="#" class="btn btn-sm btn-outline" onclick="filterTickets(2); return false;">Resolved</a>
                <a href="#" class="btn btn-sm btn-outline" onclick="filterTickets(3); return false;">Closed</a>
            </div>
        </div>

        <asp:Repeater ID="rptTickets" runat="server">
            <ItemTemplate>
                <a href='ViewTicket.aspx?id=<%# Eval("TicketId") %>' class='ticket-item <%# Convert.ToBoolean(Eval("HasNewReply")) ? "has-reply" : "" %>' data-status='<%# Eval("Status") %>'>
                    <div class="d-flex justify-content-between align-items-start flex-wrap gap-2">
                        <div class="flex-grow-1">
                            <div class="d-flex align-items-center gap-2 mb-2">
                                <code class="text-gold small"><%# Eval("TicketNumber") %></code>
                                <span class='badge badge-<%# Eval("StatusColor") %>'><%# Eval("StatusName") %></span>
                                <span class='badge badge-<%# Eval("PriorityColor") %> small'><%# Eval("PriorityName") %></span>
                                <%# Convert.ToBoolean(Eval("HasNewReply")) ? "<span class='badge badge-accent'><i class='fas fa-bell me-1'></i>New Reply</span>" : "" %>
                            </div>
                            <h6 class="text-white mb-1"><%# Eval("Subject") %></h6>
                            <small class="text-muted">
                                <i class='<%# Eval("CategoryIcon") %> me-1'></i><%# Eval("CategoryName") %>
                                <span class="mx-2">•</span>
                                <i class="fas fa-comments me-1"></i><%# Eval("MessageCount") %> messages
                            </small>
                        </div>
                        <div class="text-end">
                            <small class="text-muted"><%# Eval("TimeAgo") %></small>
                        </div>
                    </div>
                </a>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoTickets" runat="server" Visible="false">
            <div class="glass-card text-center p-5">
                <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                <h5 class="text-white">No Tickets Found</h5>
                <p class="text-muted">You haven't submitted any tickets yet.</p>
                <a href="#" class="btn btn-primary-glow" onclick="showTab('submit'); return false;">Submit Your First Ticket</a>
            </div>
        </asp:Panel>
    </asp:Panel>

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        function showTab(tabName) {
            // Hide all panels
            document.querySelectorAll('[id^="MainContent1_pnl"]').forEach(p => {
                if (p.id.includes('pnlHome') || p.id.includes('pnlFAQ') || p.id.includes('pnlSubmit') || p.id.includes('pnlTickets')) {
                    p.style.display = 'none';
                }
            });

            // Show selected
            const target = document.getElementById('MainContent1_pnl' + tabName.charAt(0).toUpperCase() + tabName.slice(1));
            if (target) target.style.display = 'block';

            // Update tabs
            document.querySelectorAll('.support-tab').forEach(t => t.classList.remove('active'));
            document.querySelector(`.support-tab[data-tab="${tabName}"]`)?.classList.add('active');

            // Update URL hash
            history.replaceState(null, '', '#' + tabName);
        }

        function toggleFAQ(el) {
            el.parentElement.classList.toggle('open');
        }

        function filterFAQ(query) {
            const items = document.querySelectorAll('.faq-item');
            let visible = 0;
            items.forEach(item => {
                const text = item.textContent.toLowerCase();
                if (text.includes(query.toLowerCase())) {
                    item.style.display = 'block';
                    visible++;
                } else {
                    item.style.display = 'none';
                }
            });
        }

        function filterTickets(status) {
            const items = document.querySelectorAll('.ticket-item');
            items.forEach(item => {
                if (status === -1 || parseInt(item.dataset.status) === status) {
                    item.style.display = 'block';
                } else {
                    item.style.display = 'none';
                }
            });
        }

        function selectCategoryAndSubmit(categoryId) {
            showTab('submit');
            setTimeout(() => {
                const ddl = document.getElementById('MainContent1_ddlCategory');
                if (ddl) ddl.value = categoryId;
            }, 100);
        }

        function resetForm() {
            const form = document.getElementById('MainContent1_pnlTicketForm');
            if (form) {
                form.querySelectorAll('input[type="text"], textarea').forEach(el => el.value = '');
            }
        }

        // Load tab from URL hash on page load
        document.addEventListener('DOMContentLoaded', function() {
            const hash = window.location.hash.replace('#', '');
            if (['home', 'faq', 'submit', 'tickets'].includes(hash)) {
                showTab(hash);
            }
        });
    </script>
</asp:Content>