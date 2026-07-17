<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="Salary2.aspx.cs" Inherits="Mexify.Web.User.Salary2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .tier-card { transition: all 0.3s ease; border-left: 4px solid; }
        .tier-card:hover { transform: translateY(-3px); box-shadow: 0 8px 20px rgba(0,0,0,0.1); }
        .progress-ring { width: 80px; height: 80px; }
        .requirement-card { border-top: 4px solid; transition: all 0.3s ease; }
        .requirement-card:hover { transform: translateY(-2px); }
        .stat-card { border-radius: 12px; overflow: hidden; }
        .stat-card .stat-icon { font-size: 2.5rem; opacity: 0.3; }
        .qualified-badge { animation: pulse 2s infinite; }
        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(40, 167, 69, 0.7); }
            70% { box-shadow: 0 0 0 15px rgba(40, 167, 69, 0); }
            100% { box-shadow: 0 0 0 0 rgba(40, 167, 69, 0); }
        }
        .missing-amount { color: #dc3545; font-weight: 600; }
        .tier-qualified { border-left-color: #28a745 !important; background: linear-gradient(90deg, rgba(40,167,69,0.05), transparent); }
        .tier-current { border-left-color: #0d6efd !important; background: linear-gradient(90deg, rgba(13,110,253,0.08), transparent); }
        .tier-next { border-left-color: #ffc107 !important; background: linear-gradient(90deg, rgba(255,193,7,0.05), transparent); }
        .tier-locked { border-left-color: #6c757d !important; opacity: 0.7; }
    </style>

    <div class="container-fluid py-4">
        
        <!-- ============================================ -->
        <!-- HEADER SECTION                                -->
        <!-- ============================================ -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="mb-1">
                            <i class="fas fa-money-bill-wave text-success"></i> 
                            Fixed Salary Plan
                        </h2>
                        <p class="text-muted mb-0">Earn monthly passive income through your MLM network</p>
                    </div>
                    <div>
                        <asp:Label ID="lblQualifiedBadge" runat="server" CssClass="badge fs-6 px-3 py-2" />
                    </div>
                </div>
            </div>
        </div>

        <!-- ============================================ -->
        <!-- STATS CARDS ROW                               -->
        <!-- ============================================ -->
        <div class="row mb-4">
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="card stat-card bg-primary text-white h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <small class="text-uppercase opacity-75">Total Earned</small>
                                <h3 class="mb-0 mt-2"><asp:Literal ID="litTotalEarned" runat="server" /></h3>
                            </div>
                            <i class="fas fa-coins stat-icon"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="card stat-card bg-success text-white h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <small class="text-uppercase opacity-75">Payments Received</small>
                                <h3 class="mb-0 mt-2"><asp:Literal ID="litPaymentsReceived" runat="server" /></h3>
                            </div>
                            <i class="fas fa-hand-holding-usd stat-icon"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="card stat-card bg-warning text-white h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <small class="text-uppercase opacity-75">Next Payment</small>
                                <h5 class="mb-0 mt-2"><asp:Literal ID="litNextPayment" runat="server" /></h5>
                            </div>
                            <i class="fas fa-calendar-check stat-icon"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="card stat-card bg-info text-white h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <small class="text-uppercase opacity-75">Qualified Since</small>
                                <h5 class="mb-0 mt-2"><asp:Literal ID="litQualifiedDate" runat="server" /></h5>
                            </div>
                            <i class="fas fa-award stat-icon"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ============================================ -->
        <!-- QUALIFIED PANEL (User meets requirements)     -->
        <!-- ============================================ -->
        <asp:Panel ID="pnlQualified" runat="server" Visible="false">
            <div class="alert alert-success border-0 shadow-sm mb-4">
                <div class="d-flex align-items-center">
                    <div class="me-3">
                        <i class="fas fa-check-circle fa-3x text-success qualified-badge"></i>
                    </div>
                    <div class="flex-grow-1">
                        <h4 class="mb-1">Congratulations! You're Qualified</h4>
                        <p class="mb-0">
                            Current Tier: <strong><asp:Literal ID="litCurrentTier" runat="server" /></strong>
                            &nbsp;•&nbsp; Monthly Salary: 
                            <strong class="text-success fs-5">$<asp:Literal ID="litMonthlySalary" runat="server" /></strong>
                        </p>
                    </div>
                </div>
            </div>
        </asp:Panel>

        <!-- ============================================ -->
        <!-- NOT QUALIFIED PANEL (User needs to qualify)   -->
        <!-- ============================================ -->
        <asp:Panel ID="pnlNotQualified" runat="server" Visible="false">
            <div class="alert alert-warning border-0 shadow-sm mb-4">
                <div class="d-flex align-items-center">
                    <div class="me-3">
                        <i class="fas fa-exclamation-triangle fa-3x text-warning"></i>
                    </div>
                    <div class="flex-grow-1">
                        <h4 class="mb-1">Not Yet Qualified</h4>
                        <p class="mb-0">Complete the requirements below to start earning your monthly salary.</p>
                    </div>
                </div>
            </div>

            <!-- Requirements Cards -->
            <div class="row mb-4">
                <!-- Self Investment -->
                <div class="col-md-4 mb-3">
                    <div class="card requirement-card h-100 border-primary shadow-sm">
                        <div class="card-body text-center">
                            <i class="fas fa-user-investor fa-3x text-primary mb-3"></i>
                            <h5 class="card-title">Self Investment</h5>
                            <p class="text-muted small">Your personal investment in plans</p>
                            <div class="my-3">
                                <span class="display-6 fw-bold text-primary">
                                    <asp:Literal ID="litSelfInvestment" runat="server" />
                                </span>
                                <span class="text-muted">/ <asp:Literal ID="litRequiredSelf" runat="server" /></span>
                            </div>
                            <asp:Panel ID="pnlSelfMissing" runat="server">
                                <small class="missing-amount">
                                    <i class="fas fa-arrow-down"></i> 
                                    Need <asp:Literal ID="litSelfMissing" runat="server" /> more
                                </small>
                            </asp:Panel>
                        </div>
                    </div>
                </div>

                <!-- Strong Leg -->
                <div class="col-md-4 mb-3">
                    <div class="card requirement-card h-100 border-success shadow-sm">
                        <div class="card-body text-center">
                            <i class="fas fa-arrow-up fa-3x text-success mb-3"></i>
                            <h5 class="card-title">Strong Leg Volume</h5>
                            <p class="text-muted small">Volume on your stronger side</p>
                            <div class="my-3">
                                <span class="display-6 fw-bold text-success">
                                    <asp:Literal ID="litStrongLeg" runat="server" />
                                </span>
                                <span class="text-muted">/ <asp:Literal ID="litRequiredStrong" runat="server" /></span>
                            </div>
                            <asp:Panel ID="pnlStrongMissing" runat="server">
                                <small class="missing-amount">
                                    <i class="fas fa-arrow-down"></i> 
                                    Need <asp:Literal ID="litStrongMissing" runat="server" /> more
                                </small>
                            </asp:Panel>
                        </div>
                    </div>
                </div>

                <!-- Weaker Leg -->
                <div class="col-md-4 mb-3">
                    <div class="card requirement-card h-100 border-warning shadow-sm">
                        <div class="card-body text-center">
                            <i class="fas fa-balance-scale fa-3x text-warning mb-3"></i>
                            <h5 class="card-title">Weaker Leg Volume</h5>
                            <p class="text-muted small">Volume on your weaker side</p>
                            <div class="my-3">
                                <span class="display-6 fw-bold text-warning">
                                    <asp:Literal ID="litWeakerLeg" runat="server" />
                                </span>
                                <span class="text-muted">/ <asp:Literal ID="litRequiredWeaker" runat="server" /></span>
                            </div>
                            <asp:Panel ID="pnlWeakerMissing" runat="server">
                                <small class="missing-amount">
                                    <i class="fas fa-arrow-down"></i> 
                                    Need <asp:Literal ID="litWeakerMissing" runat="server" /> more
                                </small>
                            </asp:Panel>
                        </div>
                    </div>
                </div>
            </div>

            <!-- How to Qualify Help Box -->
            <div class="card bg-light border-0 shadow-sm mb-4">
                <div class="card-body">
                    <h5><i class="fas fa-lightbulb text-warning"></i> How to Qualify</h5>
                    <div class="row mt-3">
                        <div class="col-md-4">
                            <div class="d-flex">
                                <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-2" style="width:30px;height:30px;flex-shrink:0;">1</div>
                                <div>
                                    <strong>Self Investment</strong>
                                    <p class="small text-muted mb-0">Invest in 2x51 ROI plans yourself to build your personal volume.</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="d-flex">
                                <div class="bg-success text-white rounded-circle d-flex align-items-center justify-content-center me-2" style="width:30px;height:30px;flex-shrink:0;">2</div>
                                <div>
                                    <strong>Strong Leg</strong>
                                    <p class="small text-muted mb-0">Your stronger MLM side needs more team volume through active members.</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="d-flex">
                                <div class="bg-warning text-white rounded-circle d-flex align-items-center justify-content-center me-2" style="width:30px;height:30px;flex-shrink:0;">3</div>
                                <div>
                                    <strong>Weaker Leg</strong>
                                    <p class="small text-muted mb-0">Build up your weaker side by enrolling new members and balancing your tree.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </asp:Panel>

        <!-- ============================================ -->
        <!-- NEXT TIER PROGRESS SECTION                    -->
        <!-- ============================================ -->
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white">
                <h5 class="mb-0"><i class="fas fa-chart-line text-primary"></i> Tier Progress</h5>
            </div>
            <div class="card-body">
                <asp:Repeater ID="rptNextTiers" runat="server">
                    <HeaderTemplate>
                        <div class="row">
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="col-md-6 mb-3">
                            <div class="card tier-card h-100 
                                <%# Convert.ToBoolean(Eval("IsCurrentTier")) ? "tier-current" : "" %>
                                <%# Convert.ToBoolean(Eval("IsNextTier")) ? "tier-next" : "" %>
                                <%# Convert.ToBoolean(Eval("IsQualified")) && !Convert.ToBoolean(Eval("IsCurrentTier")) ? "tier-qualified" : "" %>
                                <%# !Convert.ToBoolean(Eval("IsQualified")) && !Convert.ToBoolean(Eval("IsNextTier")) ? "tier-locked" : "" %>">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <div>
                                            <h5 class="mb-0">
                                                <i class='<%# Eval("IconClass") %>'></i>
                                                <%# Eval("TierName") %>
                                            </h5>
                                            <small class="text-muted">Level <%# Eval("TierLevel") %></small>
                                        </div>
                                        <div>
                                            <%# Convert.ToBoolean(Eval("IsCurrentTier")) ? "<span class='badge bg-primary'>Current</span>" : "" %>
                                            <%# Convert.ToBoolean(Eval("IsNextTier")) ? "<span class='badge bg-warning text-dark'>Next</span>" : "" %>
                                            <%# Convert.ToBoolean(Eval("IsQualified")) && !Convert.ToBoolean(Eval("IsCurrentTier")) ? "<span class='badge bg-success'>Qualified</span>" : "" %>
                                            <%# !Convert.ToBoolean(Eval("IsQualified")) && !Convert.ToBoolean(Eval("IsNextTier")) ? "<span class='badge bg-secondary'>Locked</span>" : "" %>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-2">
                                        <small class="text-muted">Monthly Salary:</small>
                                        <strong class="text-success">$<%# string.Format("{0:N0}", Eval("NextSalary")) %></strong>
                                    </div>

                                    <!-- Progress bars -->
                                    <div class="mb-2">
                                        <div class="d-flex justify-content-between small">
                                            <span>Self Investment</span>
                                            <span><%# string.Format("{0:N0}", Eval("CurrentSelf")) %> / <%# string.Format("{0:N0}", Eval("RequiredSelf")) %></span>
                                        </div>
                                        <div class="progress" style="height: 6px;">
                                            <div class="progress-bar bg-primary" style="width: <%# Eval("SelfProgress") %>%"></div>
                                        </div>
                                    </div>
                                    <div class="mb-2">
                                        <div class="d-flex justify-content-between small">
                                            <span>Strong Leg</span>
                                            <span><%# string.Format("{0:N0}", Eval("CurrentStrong")) %> / <%# string.Format("{0:N0}", Eval("RequiredStrong")) %></span>
                                        </div>
                                        <div class="progress" style="height: 6px;">
                                            <div class="progress-bar bg-success" style="width: <%# Eval("StrongProgress") %>%"></div>
                                        </div>
                                    </div>
                                    <div class="mb-2">
                                        <div class="d-flex justify-content-between small">
                                            <span>Weaker Leg</span>
                                            <span><%# string.Format("{0:N0}", Eval("CurrentWeaker")) %> / <%# string.Format("{0:N0}", Eval("RequiredWeaker")) %></span>
                                        </div>
                                        <div class="progress" style="height: 6px;">
                                            <div class="progress-bar bg-warning" style="width: <%# Eval("WeakerProgress") %>%"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>

                <asp:Panel ID="pnlNoProgress" runat="server" Visible="false">
                    <div class="text-center py-4 text-muted">
                        <i class="fas fa-info-circle fa-2x mb-2"></i>
                        <p>No tier progress data available.</p>
                    </div>
                </asp:Panel>
            </div>
        </div>

        <!-- ============================================ -->
        <!-- RECENT SALARIES SECTION                       -->
        <!-- ============================================ -->
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="fas fa-history text-info"></i> Recent Salary Payments</h5>
                <a href="#fullHistory" class="btn btn-sm btn-outline-primary">View All</a>
            </div>
            <div class="card-body p-0">
                <asp:Repeater ID="rptRecentSalaries" runat="server">
                    <HeaderTemplate>
                        <div class="table-responsive">
                            <table class="table table-hover mb-0 align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>Date</th>
                                        <th>Amount</th>
                                        <th>Tier</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td>
                                <strong><%# Eval("PaymentDate", "{0:MMM dd, yyyy}") %></strong>
                                <br><small class="text-muted"><%# Eval("TimeAgo") %></small>
                            </td>
                            <td class="text-success fw-bold">+<%# string.Format("{0:N2}", Eval("Amount")) %> USDT</td>
                            <td><span class="badge bg-light text-dark"><%# Eval("TierName") %></span></td>
                            <td><span class='badge bg-<%# Eval("StatusColor") %>'><%# Eval("StatusName") %></span></td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                                </tbody>
                            </table>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>

                <asp:Panel ID="pnlNoRecentSalaries" runat="server" Visible="false">
                    <div class="text-center py-5 text-muted">
                        <i class="fas fa-inbox fa-3x mb-3"></i>
                        <p class="mb-0">No recent salary payments yet.</p>
                    </div>
                </asp:Panel>
            </div>
        </div>

        <!-- ============================================ -->
        <!-- ALL TIERS SECTION                             -->
        <!-- ============================================ -->
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white">
                <h5 class="mb-0"><i class="fas fa-layer-group text-warning"></i> All Salary Tiers</h5>
            </div>
            <div class="card-body">
                <asp:Repeater ID="rptAllTiers" runat="server">
                    <HeaderTemplate>
                        <div class="row">
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="col-md-4 mb-3">
                            <div class="card h-100 border-0 shadow-sm">
                                <div class="card-body text-center">
                                    <i class='<%# Eval("IconClass") %> fa-3x text-<%# Eval("ColorClass") %> mb-3'></i>
                                    <h5><%# Eval("TierName") %></h5>
                                    <p class="text-muted small"><%# Eval("Description") %></p>
                                    <hr>
                                    <div class="mb-2">
                                        <small class="text-muted">Monthly Salary</small>
                                        <h3 class="text-success mb-0">$<%# string.Format("{0:N0}", Eval("MonthlySalary")) %></h3>
                                    </div>
                                    <div class="small text-start">
                                        <div class="mb-1"><i class="fas fa-check text-success"></i> Self: $<%# string.Format("{0:N0}", Eval("MinSelfBusiness")) %></div>
                                        <div class="mb-1"><i class="fas fa-check text-success"></i> Team: $<%# string.Format("{0:N0}", Eval("MinTeamBusiness")) %></div>
                                    </div>
                                    <%# Convert.ToBoolean(Eval("HasQualified")) ? "<span class='badge bg-success mt-2'><i class=\"fas fa-check\"></i> Qualified</span>" : "<span class='badge bg-secondary mt-2'><i class=\"fas fa-lock\"></i> Locked</span>" %>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
        </div>

        <!-- ============================================ -->
        <!-- FULL SALARY HISTORY SECTION                   -->
        <!-- ============================================ -->
        <div class="card shadow-sm mb-4" id="fullHistory">
            <div class="card-header bg-white">
                <h5 class="mb-0"><i class="fas fa-list text-secondary"></i> Full Salary History</h5>
            </div>
            <div class="card-body p-0">
                <asp:Repeater ID="rptSalaryHistory" runat="server">
                    <HeaderTemplate>
                        <div class="table-responsive">
                            <table class="table table-hover mb-0 align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Date</th>
                                        <th>Amount</th>
                                        <th>Tier</th>
                                        <th>Status</th>
                                        <th>Notes</th>
                                    </tr>
                                </thead>
                                <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td><%# Container.ItemIndex + 1 %></td>
                            <td>
                                <strong><%# Eval("PaymentDate", "{0:MMM dd, yyyy}") %></strong>
                                <br><small class="text-muted"><%# Eval("TimeAgo") %></small>
                            </td>
                            <td class="text-success fw-bold">+<%# string.Format("{0:N2}", Eval("Amount")) %> USDT</td>
                            <td><span class="badge bg-light text-dark"><%# Eval("TierName") %></span></td>
                            <td><span class='badge bg-<%# Eval("StatusColor") %>'><%# Eval("StatusName") %></span></td>
                            <td><small class="text-muted"><%# Eval("Notes") %></small></td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                                </tbody>
                            </table>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>

                <asp:Panel ID="pnlNoHistory" runat="server" Visible="false">
                    <div class="text-center py-5 text-muted">
                        <i class="fas fa-inbox fa-3x mb-3"></i>
                        <p class="mb-0">No salary history available.</p>
                    </div>
                </asp:Panel>
            </div>
        </div>

    </div>

</asp:Content>