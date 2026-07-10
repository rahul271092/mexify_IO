<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="Salary.aspx.cs" Inherits="Mexify.Web.User.Salary" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .salary-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            flex-wrap: wrap;
            gap: 16px;
        }
        .salary-header h2 { color: var(--text-white); margin: 0; font-size: 1.8rem; }

        .salary-tabs {
            display: flex;
            gap: 4px;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 50px;
            padding: 4px;
            margin-bottom: 28px;
            width: fit-content;
            flex-wrap: wrap;
        }
        .salary-tab {
            padding: 10px 20px;
            border-radius: 50px;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-gray);
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            background: transparent;
            white-space: nowrap;
        }
        .salary-tab.active {
            background: linear-gradient(135deg, #FFD700, #FFA500);
            color: #000;
            box-shadow: 0 4px 12px rgba(255, 215, 0, 0.3);
        }
        .salary-tab:hover:not(.active) {
            background: rgba(255, 255, 255, 0.05);
            color: var(--text-white);
        }

        .salary-hero {
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.15), rgba(255, 165, 0, 0.1));
            border: 1px solid rgba(255, 215, 0, 0.3);
            border-radius: var(--radius-xl);
            padding: 40px;
            position: relative;
            overflow: hidden;
            margin-bottom: 32px;
        }
        .salary-hero::before {
            content: '';
            position: absolute;
            top: -50%; right: -10%;
            width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(255, 215, 0, 0.15) 0%, transparent 70%);
            animation: float 15s ease-in-out infinite;
        }
        @keyframes float {
            0%,100%{transform:translate(0,0) scale(1)}
            50%{transform:translate(20px,-20px) scale(1.1)}
        }

        .tier-badge-large {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 10px 20px;
            background: linear-gradient(135deg, #FFD700, #FFA500);
            border-radius: 50px;
            color: #000;
            font-weight: 800;
            font-size: 1.1rem;
            margin-bottom: 16px;
        }

        .salary-amount-large {
            font-size: 3.5rem;
            font-weight: 800;
            color: var(--text-white);
            font-family: 'Space Grotesk', sans-serif;
            margin-bottom: 8px;
        }
        .salary-amount-large small {
            font-size: 1.2rem;
            color: var(--text-gray);
            font-weight: 500;
        }

        .stat-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 20px;
            text-align: center;
            transition: all 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-3px);
            border-color: #FFD700;
        }
        .stat-card .value {
            font-size: 1.6rem;
            font-weight: 800;
            color: var(--text-white);
            font-family: 'Space Grotesk', sans-serif;
        }
        .stat-card .label {
            font-size: 0.75rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-top: 4px;
        }

        .progress-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 24px;
            margin-bottom: 16px;
        }
        .progress-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }
        .progress-title {
            color: var(--text-white);
            font-weight: 700;
            font-size: 1.1rem;
        }
        .progress-subtitle {
            color: var(--text-muted);
            font-size: 0.85rem;
        }
        .progress-bar-custom {
            height: 10px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50px;
            overflow: hidden;
            margin-bottom: 8px;
        }
        .progress-fill-custom {
            height: 100%;
            background: linear-gradient(90deg, #FFD700, #FFA500);
            border-radius: 50px;
            transition: width 1s ease;
        }
        .progress-stats {
            display: flex;
            justify-content: space-between;
            font-size: 0.8rem;
            color: var(--text-muted);
        }

        .tier-table {
            width: 100%;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            overflow: hidden;
        }
        .tier-table table { width: 100%; color: var(--text-gray); border-collapse: collapse; }
        .tier-table th {
            background: rgba(255, 215, 0, 0.08);
            padding: 14px 16px;
            color: var(--text-white);
            font-weight: 600;
            font-size: 0.8rem;
            text-align: left;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .tier-table td {
            padding: 14px 16px;
            border-bottom: 1px solid var(--glass-border);
            font-size: 0.9rem;
        }
        .tier-table tr:last-child td { border-bottom: none; }
        .tier-table tr:hover { background: rgba(255, 215, 0, 0.03); }
        .tier-table tr.current-tier {
            background: rgba(255, 215, 0, 0.08);
            border-left: 3px solid #FFD700;
        }

        .tier-badge {
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 700;
            display: inline-block;
        }
        .tier-a1 { background: rgba(192, 192, 192, 0.2); color: #C0C0C0; }
        .tier-a2 { background: rgba(205, 127, 50, 0.2); color: #CD7F32; }
        .tier-b1 { background: rgba(0, 212, 255, 0.2); color: #00D4FF; }
        .tier-b2 { background: rgba(0, 255, 178, 0.2); color: #00FFB2; }
        .tier-c1 { background: rgba(255, 215, 0, 0.2); color: #FFD700; }
        .tier-c2 { background: linear-gradient(135deg, rgba(255, 215, 0, 0.3), rgba(255, 165, 0, 0.3)); color: #FFD700; }

        .salary-history-item {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 14px 16px;
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-md);
            margin-bottom: 10px;
        }
        .salary-icon {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255, 215, 0, 0.15);
            color: #FFD700;
            flex-shrink: 0;
        }
        .salary-info { flex: 1; }
        .salary-title { color: var(--text-white); font-weight: 600; font-size: 0.95rem; margin-bottom: 2px; }
        .salary-meta { color: var(--text-muted); font-size: 0.75rem; }
        .salary-amount {
            color: #FFD700;
            font-weight: 700;
            font-size: 1.1rem;
        }

        .info-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 28px;
            margin-bottom: 20px;
        }
        .info-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 16px;
            border-bottom: 1px solid var(--glass-border);
        }
        .info-card-title {
            color: var(--text-white);
            font-weight: 700;
            font-size: 1.1rem;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .info-card-title i { color: #FFD700; }

        .alert-box {
            padding: 14px 18px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 0.9rem;
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }
        .alert-box.info { background: rgba(0, 212, 255, 0.1); border: 1px solid rgba(0, 212, 255, 0.3); color: var(--secondary); }
        .alert-box i { margin-top: 2px; flex-shrink: 0; }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: var(--glass-bg);
            border: 1px dashed var(--glass-border);
            border-radius: var(--radius-lg);
        }
        .empty-state i { font-size: 4rem; color: var(--text-muted); margin-bottom: 20px; opacity: 0.5; }
        .empty-state h4 { color: var(--text-white); margin-bottom: 8px; }
        .empty-state p { color: var(--text-gray); margin-bottom: 24px; }

        @media (max-width: 768px) {
            .salary-amount-large { font-size: 2.5rem; }
            .tier-table { overflow-x: auto; }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Header -->
    <div class="salary-header" data-aos="fade-up">
        <div>
            <h2>Investor Salary Plan</h2>
            <p class="text-gray mb-0">Track your tier qualifications and monthly earnings</p>
        </div>
    </div>

    <!-- Tabs -->
    <div class="salary-tabs" data-aos="fade-up">
        <button type="button" class="salary-tab active" data-tab="overview">
            <i class="fas fa-chart-pie me-1"></i> Overview
        </button>
        <button type="button" class="salary-tab" data-tab="tiers">
            <i class="fas fa-layer-group me-1"></i> All Tiers
        </button>
        <button type="button" class="salary-tab" data-tab="progress">
            <i class="fas fa-tasks me-1"></i> My Progress
        </button>
        <button type="button" class="salary-tab" data-tab="history">
            <i class="fas fa-history me-1"></i> Salary History
        </button>
    </div>

    <!-- OVERVIEW TAB -->
    <div id="tab-overview" class="tab-content" data-aos="fade-up">
        
        <!-- Salary Hero -->
        <div class="salary-hero">
            <div class="row align-items-center position-relative" style="z-index: 2;">
                <div class="col-lg-8">
                    <asp:Panel ID="pnlQualified" runat="server">
                        <div class="tier-badge-large">
                            <i class="fas fa-crown"></i>
                            <asp:Literal ID="litCurrentTier" runat="server" Text="Not Qualified"></asp:Literal>
                        </div>
                        <div class="salary-amount-large">
                            $<asp:Literal ID="litMonthlySalary" runat="server" Text="0"></asp:Literal>
                            <small>/month</small>
                        </div>
                        <p class="text-gray" style="font-size: 1.1rem;">
                            Your monthly investor salary based on current tier qualifications
                        </p>
                        <div class="alert-box info" style="margin-top: 20px;">
                            <i class="fas fa-info-circle"></i>
                            <div>
                                <strong class="text-white">Salary Payment Schedule:</strong><br>
                                Salary is credited on the <strong>15th</strong> and <strong>end date</strong> of each month.
                            </div>
                        </div>
                    </asp:Panel>

                    <asp:Panel ID="pnlNotQualified" runat="server" Visible="false">
                        <div class="tier-badge-large" style="background: linear-gradient(135deg, #6B758D, #4B5563);">
                            <i class="fas fa-lock"></i>
                            Not Yet Qualified
                        </div>
                        <div class="salary-amount-large">
                            $0<small>/month</small>
                        </div>
                        <p class="text-gray" style="font-size: 1.1rem;">
                            Complete the requirements to start earning monthly salary
                        </p>
                    </asp:Panel>
                </div>
                <div class="col-lg-4 mt-4 mt-lg-0">
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="stat-card">
                                <div class="value" style="color: #FFD700;">
                                    <asp:Literal ID="litTotalEarned" runat="server" Text="$0"></asp:Literal>
                                </div>
                                <div class="label">Total Earned</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stat-card">
                                <div class="value" style="color: var(--accent);">
                                    <asp:Literal ID="litPaymentsReceived" runat="server" Text="0"></asp:Literal>
                                </div>
                                <div class="label">Payments</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stat-card">
                                <div class="value" style="color: var(--secondary);">
                                    <asp:Literal ID="litNextPayment" runat="server" Text="--"></asp:Literal>
                                </div>
                                <div class="label">Next Payment</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stat-card">
                                <div class="value" style="color: var(--gold);">
                                    <asp:Literal ID="litQualifiedDate" runat="server" Text="--"></asp:Literal>
                                </div>
                                <div class="label">Qualified Since</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Volume Stats -->
        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="stat-card" style="padding: 24px;">
                    <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px;">Self Investment</div>
                    <div style="font-size: 2rem; font-weight: 800; color: var(--text-white);">
                        $<asp:Literal ID="litSelfInvestment" runat="server" Text="0"></asp:Literal>
                    </div>
                    <small class="text-muted">Required: $<asp:Literal ID="litRequiredSelf" runat="server" Text="0"></asp:Literal></small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card" style="padding: 24px;">
                    <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px;">Strong Leg Volume</div>
                    <div style="font-size: 2rem; font-weight: 800; color: var(--accent);">
                        $<asp:Literal ID="litStrongLeg" runat="server" Text="0"></asp:Literal>
                    </div>
                    <small class="text-muted">Required: $<asp:Literal ID="litRequiredStrong" runat="server" Text="0"></asp:Literal></small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card" style="padding: 24px;">
                    <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px;">Weaker Leg Volume</div>
                    <div style="font-size: 2rem; font-weight: 800; color: var(--secondary);">
                        $<asp:Literal ID="litWeakerLeg" runat="server" Text="0"></asp:Literal>
                    </div>
                    <small class="text-muted">Required: $<asp:Literal ID="litRequiredWeaker" runat="server" Text="0"></asp:Literal></small>
                </div>
            </div>
        </div>

        <!-- Recent Salary Payments -->
        <div class="info-card">
            <div class="info-card-header">
                <h5 class="info-card-title">
                    <i class="fas fa-money-bill-wave"></i>
                    Recent Salary Payments
                </h5>
                <button class="salary-tab" onclick="document.querySelector('[data-tab=history]').click()">View All</button>
            </div>
            <asp:Repeater ID="rptRecentSalaries" runat="server">
                <ItemTemplate>
                    <div class="salary-history-item">
                        <div class="salary-icon">
                            <i class="fas fa-coins"></i>
                        </div>
                        <div class="salary-info">
                            <div class="salary-title"><%# Eval("MonthName") %> Salary</div>
                            <div class="salary-meta">
                                <%# Eval("TierName") %> Tier · Paid on <%# Convert.ToDateTime(Eval("PaymentDate")).ToString("MMM dd, yyyy") %>
                            </div>
                        </div>
                        <div class="salary-amount">
                            +$<%# string.Format("{0:0.00}", Eval("SalaryAmount")) %>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:Panel ID="pnlNoRecentSalaries" runat="server" Visible="false">
                <div class="empty-state">
                    <i class="fas fa-money-bill-wave"></i>
                    <h4>No Salary Payments Yet</h4>
                    <p>Qualify for a tier to start receiving monthly salary.</p>
                </div>
            </asp:Panel>
        </div>
    </div>

    <!-- ALL TIERS TAB -->
    <div id="tab-tiers" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <div class="info-card">
            <div class="info-card-header">
                <h5 class="info-card-title">
                    <i class="fas fa-layer-group"></i>
                    Investor Tier Programs
                </h5>
            </div>

            <div class="alert-box info">
                <i class="fas fa-info-circle"></i>
                <div>
                    <strong class="text-white">Tailored Returns for Every Investor:</strong> Mexify's tiered investor programs are designed to reward commitment and network growth, offering progressively higher monthly returns and benefits as your participation and referral volume increase.
                </div>
            </div>

            <div class="tier-table">
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Tier</th>
                                <th>Self-Investment</th>
                                <th>Strong Leg Volume</th>
                                <th>Weaker Leg Volume</th>
                                <th>Monthly Return</th>
                                <th>Requirements</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptAllTiers" runat="server">
                                <ItemTemplate>
                                    <tr class='<%# Convert.ToBoolean(Eval("IsCurrentTier")) ? "current-tier" : "" %>'>
                                        <td>
                                            <span class='tier-badge tier-<%# Eval("TierCode").ToString().ToLower() %>'>
                                                <%# Eval("TierCode") %>
                                            </span>
                                            <div style="font-size: 0.75rem; color: var(--text-muted); margin-top: 4px;">
                                                <%# Eval("TierName") %>
                                            </div>
                                        </td>
                                        <td class="text-white fw-bold">$<%# string.Format("{0:0}", Eval("SelfInvestment")) %></td>
                                        <td>$<%# string.Format("{0:0}", Eval("StrongLegVolume")) %></td>
                                        <td>$<%# string.Format("{0:0}", Eval("WeakerLegVolume")) %></td>
                                        <td style="color: #FFD700; font-weight: 700;">$<%# string.Format("{0:0}", Eval("MonthlySalary")) %></td>
                                        <td class="text-muted" style="font-size: 0.8rem;"><%# Eval("Requirements") ?? "—" %></td>
                                        <td>
                                            <%# Convert.ToBoolean(Eval("IsQualified")) ? "<span class='tier-badge' style='background: rgba(0, 255, 178, 0.2); color: var(--accent);'>✓ Qualified</span>" : "<span class='tier-badge' style='background: rgba(107, 117, 141, 0.2); color: var(--text-muted);'>Not Yet</span>" %>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="alert-box info" style="margin-top: 24px;">
                <i class="fas fa-calendar-alt"></i>
                <div>
                    <strong class="text-white">Payment Schedule:</strong> Salary will be added on <strong>15th</strong> and <strong>end date</strong> of the month. Further tiers and specific monthly return amounts are available upon request for qualified investors.
                </div>
            </div>
        </div>
    </div>

    <!-- PROGRESS TAB -->
    <div id="tab-progress" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <asp:Repeater ID="rptNextTiers" runat="server">
            <ItemTemplate>
                <div class="progress-card">
                    <div class="progress-header">
                        <div>
                            <div class="progress-title">
                                <span class='tier-badge tier-<%# Eval("TierCode").ToString().ToLower() %>'>
                                    <%# Eval("TierCode") %>
                                </span>
                                <%# Eval("TierName") %>
                            </div>
                            <div class="progress-subtitle">
                                Monthly Salary: <strong style="color: #FFD700;">$<%# string.Format("{0:0}", Eval("NextSalary")) %></strong>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <div class="d-flex justify-content-between mb-1">
                            <small class="text-muted">Self Investment</small>
                            <small class="text-white">$<%# string.Format("{0:0}", Eval("CurrentSelf")) %> / $<%# string.Format("{0:0}", Eval("RequiredSelf")) %></small>
                        </div>
                        <div class="progress-bar-custom">
                            <div class="progress-fill-custom" style="width: <%# Eval("SelfProgress") %>%;"></div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <div class="d-flex justify-content-between mb-1">
                            <small class="text-muted">Strong Leg Volume</small>
                            <small class="text-white">$<%# string.Format("{0:0}", Eval("CurrentStrong")) %> / $<%# string.Format("{0:0}", Eval("RequiredStrong")) %></small>
                        </div>
                        <div class="progress-bar-custom">
                            <div class="progress-fill-custom" style="width: <%# Eval("StrongProgress") %>%;"></div>
                        </div>
                    </div>

                    <div>
                        <div class="d-flex justify-content-between mb-1">
                            <small class="text-muted">Weaker Leg Volume</small>
                            <small class="text-white">$<%# string.Format("{0:0}", Eval("CurrentWeaker")) %> / $<%# string.Format("{0:0}", Eval("RequiredWeaker")) %></small>
                        </div>
                        <div class="progress-bar-custom">
                            <div class="progress-fill-custom" style="width: <%# Eval("WeakerProgress") %>%;"></div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoProgress" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-tasks"></i>
                <h4>No Progress Data</h4>
                <p>Start investing to see your tier progression.</p>
            </div>
        </asp:Panel>
    </div>

    <!-- HISTORY TAB -->
    <div id="tab-history" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <div class="info-card">
            <div class="info-card-header">
                <h5 class="info-card-title">
                    <i class="fas fa-history"></i>
                    Complete Salary History
                </h5>
            </div>

            <asp:Repeater ID="rptSalaryHistory" runat="server">
                <ItemTemplate>
                    <div class="salary-history-item">
                        <div class="salary-icon">
                            <i class="fas fa-coins"></i>
                        </div>
                        <div class="salary-info">
                            <div class="salary-title"><%# Eval("MonthName") %> Salary</div>
                            <div class="salary-meta">
                                <%# Eval("TierName") %> Tier · Paid on <%# Convert.ToDateTime(Eval("PaymentDate")).ToString("MMM dd, yyyy 'at' hh:mm tt") %>
                            </div>
                        </div>
                        <div class="salary-amount">
                            +$<%# string.Format("{0:0.00}", Eval("SalaryAmount")) %>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoHistory" runat="server" Visible="false">
                <div class="empty-state">
                    <i class="fas fa-history"></i>
                    <h4>No Salary History</h4>
                    <p>Your salary payment history will appear here.</p>
                </div>
            </asp:Panel>
        </div>
    </div>

    <asp:HiddenField ID="hfActiveTab" runat="server" Value="overview" />
</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        (function() {
            'use strict';
            
            function initSalaryTabs() {
                var tabs = document.querySelectorAll('.salary-tab');
                var contents = document.querySelectorAll('.tab-content');
                var activeTabInput = document.getElementById('<%= hfActiveTab.ClientID %>');
                
                if (!tabs.length || !contents.length) {
                    setTimeout(initSalaryTabs, 100);
                    return;
                }

                function switchTab(tabName) {
                    tabs.forEach(function(t) { t.classList.remove('active'); });
                    contents.forEach(function(c) { c.style.display = 'none'; });
                    
                    var targetTab = document.querySelector('[data-tab="' + tabName + '"]');
                    var targetContent = document.getElementById('tab-' + tabName);
                    
                    if (targetTab) targetTab.classList.add('active');
                    if (targetContent) targetContent.style.display = 'block';
                    if (activeTabInput) activeTabInput.value = tabName;
                }

                tabs.forEach(function(tab) {
                    tab.addEventListener('click', function(e) {
                        e.preventDefault();
                        switchTab(this.getAttribute('data-tab'));
                    });
                });

                var tabToShow = 'overview';
                var urlParams = new URLSearchParams(window.location.search);
                var tabParam = urlParams.get('tab');
                
                if (tabParam && document.querySelector('[data-tab="' + tabParam + '"]')) {
                    tabToShow = tabParam;
                } else if (activeTabInput && activeTabInput.value) {
                    tabToShow = activeTabInput.value;
                }

                switchTab(tabToShow);
            }

            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', initSalaryTabs);
            } else {
                initSalaryTabs();
            }
        })();
    </script>
</asp:Content>