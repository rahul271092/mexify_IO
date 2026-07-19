<%@ Page Title="Salary Dashboard" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="Salary.aspx.cs" Inherits="Mexify.Web.User.Salary" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --success-gradient: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            --warning-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            --info-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }

        .page-header {
            background: var(--primary-gradient);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            border-radius: 0 0 20px 20px;
        }

        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: transform 0.3s ease;
            border: none;
            height: 100%;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            color: white;
            margin-bottom: 1rem;
        }

        .stat-icon.gradient-1 { background: var(--primary-gradient); }
        .stat-icon.gradient-2 { background: var(--success-gradient); }
        .stat-icon.gradient-3 { background: var(--warning-gradient); }
        .stat-icon.gradient-4 { background: var(--info-gradient); }

        .tier-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            border: 2px solid transparent;
            position: relative;
            overflow: hidden;
            height: 100%;
        }

        .tier-card.current {
            border-color: #667eea;
            background: linear-gradient(135deg, rgba(102,126,234,0.05) 0%, rgba(118,75,162,0.05) 100%);
        }

        .tier-card.qualified {
            border-color: #38ef7d;
        }

        .tier-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .progress-section {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            margin-bottom: 2rem;
        }

        .progress-item {
            margin-bottom: 1.5rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid #e9ecef;
        }

        .progress-item:last-child {
            margin-bottom: 0;
            padding-bottom: 0;
            border-bottom: none;
        }

        .progress-label {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
            font-weight: 600;
        }

        .progress-bar-custom {
            height: 12px;
            border-radius: 10px;
            background: #e9ecef;
            overflow: hidden;
        }

        .progress-bar-fill {
            height: 100%;
            border-radius: 10px;
            transition: width 0.6s ease;
        }

        .history-table {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
        }

        .history-table thead {
            background: var(--primary-gradient);
            color: white;
        }

        .status-badge {
            padding: 0.4rem 0.8rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
        }

        .status-pending { background: #fff3cd; color: #856404; }
        .status-paid { background: #d4edda; color: #155724; }
        .status-failed { background: #f8d7da; color: #721c24; }

        .plan-card {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: transform 0.3s ease;
            position: relative;
            overflow: hidden;
            height: 100%;
        }

        .plan-card:hover {
            transform: translateY(-5px);
        }

        .plan-card.popular {
            border: 2px solid #667eea;
        }

        .popular-badge {
            position: absolute;
            top: 0;
            right: 0;
            background: var(--primary-gradient);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 0 15px 0 15px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .btn-subscribe {
            background: var(--primary-gradient);
            border: none;
            color: white;
            padding: 0.8rem 2rem;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-subscribe:hover {
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(102,126,234,0.4);
            color: white;
        }

        .btn-subscribe:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        .section-title {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            color: #2d3748;
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #a0aec0;
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="mb-2">
                        <i class="fas fa-money-bill-wave me-2"></i>Salary Dashboard
                    </h1>
                    <p class="mb-0 opacity-75">
                        Track your earnings, tier progress, and manage your salary plans
                    </p>
                </div>
                <div class="col-md-4 text-md-end mt-3 mt-md-0">
                    <div class="d-inline-block text-start">
                        <small class="opacity-75">Current Monthly Salary</small>
                        <h2 class="mb-0 fw-bold">
                            <asp:Label ID="lblCurrentSalary" runat="server" Text="$0.00" />
                        </h2>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container pb-5">
        <!-- Alert Messages -->
        <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-dismissible fade show" role="alert">
            <asp:Label ID="lblAlertMessage" runat="server" />
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </asp:Panel>

        <!-- Stats Cards -->
        <div class="row g-4 mb-4">
            <div class="col-md-3 col-sm-6">
                <div class="stat-card">
                    <div class="stat-icon gradient-1">
                        <i class="fas fa-dollar-sign"></i>
                    </div>
                    <h6 class="text-muted mb-1">Total Earned</h6>
                    <h3 class="mb-0 fw-bold">
                        <asp:Label ID="lblTotalEarned" runat="server" Text="$0.00" />
                    </h3>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="stat-card">
                    <div class="stat-icon gradient-2">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <h6 class="text-muted mb-1">Payments Count</h6>
                    <h3 class="mb-0 fw-bold">
                        <asp:Label ID="lblPaymentsCount" runat="server" Text="0" />
                    </h3>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="stat-card">
                    <div class="stat-icon gradient-3">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <h6 class="text-muted mb-1">Average Payment</h6>
                    <h3 class="mb-0 fw-bold">
                        <asp:Label ID="lblAveragePayment" runat="server" Text="$0.00" />
                    </h3>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="stat-card">
                    <div class="stat-icon gradient-4">
                        <i class="fas fa-trophy"></i>
                    </div>
                    <h6 class="text-muted mb-1">Current Tier</h6>
                    <h3 class="mb-0 fw-bold">
                        <asp:Label ID="lblCurrentTier" runat="server" Text="None" />
                    </h3>
                </div>
            </div>
        </div>

        <!-- Progress Section -->
        <div class="progress-section">
            <h3 class="section-title">
                <i class="fas fa-tasks me-2 text-primary"></i>Tier Progress
            </h3>
            <asp:Repeater ID="rptProgress" runat="server">
                <ItemTemplate>
                    <div class="progress-item">
                        <div class="progress-label">
                            <span>
                                <i class='<%# GetIconClass(Eval("TierCode")) %>'></i>
                                <%# Eval("TierName") %>
                                <asp:Label runat="server" CssClass="badge bg-primary ms-2" 
                                           Visible='<%# Eval("IsCurrentTier") %>'>Current</asp:Label>
                                <asp:Label runat="server" CssClass="badge bg-success ms-2" 
                                           Visible='<%# Eval("IsNextTier") %>'>Next</asp:Label>
                            </span>
                            <span>
                                <%# Eval("OverallProgress", "{0:F1}") %>%
                            </span>
                        </div>
                        <div class="progress-bar-custom">
                            <div class="progress-bar-fill" 
                                 style='width: <%# Eval("OverallProgress") %>%; background: var(--primary-gradient);'>
                            </div>
                        </div>
                        <div class="row mt-2 small text-muted">
                            <div class="col-md-4">
                                Self: <%# Eval("CurrentSelf", "{0:N2}") %> / <%# Eval("RequiredSelf", "{0:N2}") %>
                                <span class="text-danger">(<%# Eval("SelfRemaining", "{0:N2}") %> left)</span>
                            </div>
                            <div class="col-md-4">
                                Strong: <%# Eval("CurrentStrong", "{0:N2}") %> / <%# Eval("RequiredStrong", "{0:N2}") %>
                                <span class="text-danger">(<%# Eval("StrongRemaining", "{0:N2}") %> left)</span>
                            </div>
                            <div class="col-md-4">
                                Weaker: <%# Eval("CurrentWeaker", "{0:N2}") %> / <%# Eval("RequiredWeaker", "{0:N2}") %>
                                <span class="text-danger">(<%# Eval("WeakerRemaining", "{0:N2}") %> left)</span>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:Panel ID="pnlNoProgress" runat="server" Visible="false" CssClass="empty-state">
                <i class="fas fa-chart-bar"></i>
                <p>No progress data available</p>
            </asp:Panel>
        </div>

        <!-- All Tiers -->
        <h3 class="section-title">
            <i class="fas fa-layer-group me-2 text-primary"></i>All Investor Tiers
        </h3>
        <div class="row g-4 mb-4">
            <asp:Repeater ID="rptTiers" runat="server">
                <ItemTemplate>
                    <div class="col-md-4">
                        <div class='tier-card <%# GetTierCardClass(Container.DataItem) %>'>
                            <asp:Label runat="server" CssClass="tier-badge bg-primary text-white" 
                                       Visible='<%# Eval("IsCurrentTier") %>'>Current Tier</asp:Label>
                            <asp:Label runat="server" CssClass="tier-badge bg-success text-white" 
                                       Visible='<%# Eval("IsQualified") %>'>Qualified</asp:Label>
                            
                            <div class="text-center mb-3">
                                <i class='<%# Eval("IconClass", "fas {0}") %> fa-3x text-primary mb-2'></i>
                                <h4 class="mb-1"><%# Eval("TierName") %></h4>
                                <p class="text-muted small mb-0"><%# Eval("TierCode") %></p>
                            </div>

                            <div class="mb-3">
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Monthly Salary:</span>
                                    <strong class="text-success">$<%# Eval("MonthlySalary", "{0:N2}") %></strong>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Self Investment:</span>
                                    <strong>$<%# Eval("SelfInvestment", "{0:N2}") %></strong>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Strong Leg:</span>
                                    <strong>$<%# Eval("StrongLegVolume", "{0:N2}") %></strong>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <span class="text-muted">Weaker Leg:</span>
                                    <strong>$<%# Eval("WeakerLegVolume", "{0:N2}") %></strong>
                                </div>
                            </div>

                            <div class="small text-muted">
                                <%# Eval("Requirements") %>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- Active Plans -->
        <h3 class="section-title">
            <i class="fas fa-rocket me-2 text-primary"></i>Available Salary Plans
        </h3>
        <div class="row g-4 mb-4">
            <asp:Repeater ID="rptPlans" runat="server" OnItemCommand="rptPlans_ItemCommand">
                <ItemTemplate>
                    <div class="col-md-4">
                        <div class='plan-card <%# Eval("IsPopular").ToString() == "True" ? "popular" : "" %>'>
                            <asp:Label runat="server" CssClass="popular-badge" 
                                       Visible='<%# Eval("IsPopular") %>'>
                                <i class="fas fa-star me-1"></i>Popular
                            </asp:Label>

                            <div class="text-center mb-3">
                                <i class='<%# Eval("IconClass", "fas {0}") %> fa-3x mb-2' 
                                   style='color: <%# Eval("ColorClass", "#667eea") %>'></i>
                                <h4 class="mb-1"><%# Eval("PlanName") %></h4>
                                <p class="text-muted small mb-0"><%# Eval("ShortDescription") %></p>
                            </div>

                            <div class="text-center mb-3">
                                <h2 class="fw-bold text-primary mb-1">
                                    $<%# Eval("InvestmentAmount", "{0:N2}") %>
                                </h2>
                                <small class="text-muted">Investment Required</small>
                            </div>

                            <div class="mb-3">
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Daily Salary:</span>
                                    <strong class="text-success">$<%# Eval("DailySalary", "{0:N2}") %></strong>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Duration:</span>
                                    <strong><%# Eval("DurationDays") %> days</strong>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Total Earning:</span>
                                    <strong class="text-success">$<%# Eval("TotalEarning", "{0:N2}") %></strong>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <span class="text-muted">Available Slots:</span>
                                    <strong><%# Eval("AvailableSlots") %></strong>
                                </div>
                            </div>

                            <asp:Panel runat="server" Visible='<%# Eval("IsEligible") %>'>
                                <asp:Button ID="btnSubscribe" runat="server" 
                                            CommandName="Subscribe" 
                                            CommandArgument='<%# Eval("PlanId") %>'
                                            CssClass="btn btn-subscribe w-100" 
                                            Text="Subscribe Now" />
                            </asp:Panel>
                            <asp:Panel runat="server" Visible='<%# !Convert.ToBoolean(Eval("IsEligible")) %>'>
                                <button class="btn btn-secondary w-100" disabled>
                                    <i class="fas fa-lock me-2"></i>Not Eligible
                                </button>
                                <small class="text-muted d-block text-center mt-2">
                                    <%# Eval("RequirementText") %>
                                </small>
                            </asp:Panel>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- Salary History -->
        <h3 class="section-title">
            <i class="fas fa-history me-2 text-primary"></i>Salary History
        </h3>
        <div class="history-table">
            <table class="table table-hover mb-0">
                <thead>
                    <tr>
                        <th>Month</th>
                        <th>Tier</th>
                        <th>Amount</th>
                        <th>Payment Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptHistory" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <strong><%# Eval("MonthName") %> <%# Eval("SalaryYear") %></strong>
                                </td>
                                <td><%# Eval("TierName") %></td>
                                <td class="fw-bold text-success">$<%# Eval("SalaryAmount", "{0:N2}") %></td>
                                <td><%# Eval("PaymentDate", "{0:MMM dd, yyyy}") %></td>
                                <td>
                                    <span class='status-badge status-<%# GetStatusClass(Eval("PaymentStatus").ToString()) %>'>
                                        <%# GetStatusName(Eval("PaymentStatus").ToString()) %>
                                    </span>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
            <asp:Panel ID="pnlNoHistory" runat="server" Visible="false" CssClass="empty-state">
                <i class="fas fa-inbox"></i>
                <p>No salary history available</p>
            </asp:Panel>
        </div>
    </div>
</asp:Content>