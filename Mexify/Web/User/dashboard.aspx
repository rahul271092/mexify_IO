<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="dashboard.aspx.cs" Inherits="Mexify.Web.User.Dashboard" %>
<%@ Register Src="~/Web/User/Controls/EntryFeeModal.ascx" TagPrefix="uc1" TagName="EntryFeeModal" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* 1. The Main Wrapper - Forces side-by-side layout */
        .dashboard-layout {
            display: flex !important;
            flex-direction: row;
            min-height: 100vh;
            background-color: var(--bg-primary, #07111F);
            position: relative;
            overflow: hidden;
        }

        /* 2. The Sidebar - Fixed width, doesn't shrink */
        .dashboard-sidebar {
            width: 280px;
            flex-shrink: 0;
            height: 100vh;
            position: sticky;
            top: 0;
            z-index: 100;
            overflow-y: auto;
            background: linear-gradient(180deg, var(--bg-secondary, #0B132B) 0%, var(--bg-tertiary, #07111F) 100%);
            border-right: 1px solid var(--glass-border, rgba(255,255,255,0.08));
            box-shadow: 4px 0 24px rgba(0, 0, 0, 0.2);
        }

        /* 3. The Main Content Area - Fills remaining space */
        .dashboard-main {
            flex: 1;
            min-width: 0;
            display: flex;
            flex-direction: column;
            height: 100vh;
            overflow-y: auto;
            position: relative;
        }

        /* 4. Mobile Responsive */
        @media (max-width: 991.98px) {
            .dashboard-layout { display: block; overflow: auto; }
            .dashboard-sidebar {
                width: 280px; height: 100vh; position: fixed; left: 0; top: 0;
                transform: translateX(-100%); transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1); z-index: 1000;
            }
            .dashboard-sidebar.active { transform: translateX(0); }
            .dashboard-main { width: 100%; height: auto; margin-left: 0; }
        }

        .welcome-banner {
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.2), rgba(0, 255, 178, 0.1));
            border: 1px solid rgba(0, 212, 255, 0.3);
            border-radius: 16px;
            padding: 32px;
            position: relative;
            overflow: hidden;
            margin-bottom: 32px;
        }
        .welcome-banner::before {
            content: ''; position: absolute; top: -50%; right: -10%;
            width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(0, 212, 255, 0.15) 0%, transparent 70%);
        }
        .welcome-banner h2 { color: var(--text-white, #fff); font-size: 1.8rem; margin-bottom: 8px; }
        .welcome-banner p { color: var(--text-gray, #A0AABF); margin-bottom: 0; }
        .daily-roi-banner {
            display: inline-flex; align-items: center; gap: 8px; padding: 8px 16px;
            background: rgba(0, 255, 178, 0.1); border: 1px solid rgba(0, 255, 178, 0.3);
            border-radius: 50px; color: var(--accent, #00FFB2); font-weight: 600; font-size: 0.9rem; margin-top: 16px;
        }

        .quick-action {
            background: var(--glass-bg, rgba(255,255,255,0.03));
            border: 1px solid var(--glass-border, rgba(255,255,255,0.08));
            border-radius: 12px; padding: 20px; text-align: center;
            transition: all 0.3s ease; cursor: pointer; text-decoration: none; display: block;
        }
        .quick-action:hover { transform: translateY(-5px); border-color: var(--secondary, #00D4FF); background: rgba(0, 212, 255, 0.05); }
        .quick-action i { font-size: 1.8rem; margin-bottom: 10px; background: linear-gradient(135deg, var(--secondary), var(--accent)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .quick-action span { display: block; color: var(--text-white); font-weight: 600; font-size: 0.9rem; }

        .wallet-widget {
            background: var(--glass-bg); backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border); border-radius: 12px;
            padding: 16px; display: flex; align-items: center; gap: 14px;
            transition: all 0.3s ease; text-decoration: none;
        }
        .wallet-widget:hover { border-color: var(--secondary); transform: translateX(5px); }
        .wallet-icon { width: 46px; height: 46px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.3rem; flex-shrink: 0; }
        .wallet-icon.pnc { background: rgba(255, 215, 0, 0.15); color: #FFD700; border: 1px solid rgba(255, 215, 0, 0.3); }
        .wallet-icon.usdt { background: rgba(38, 161, 123, 0.15); color: #26A17B; border: 1px solid rgba(38, 161, 123, 0.3); }
        .wallet-info { flex: 1; min-width: 0; }
        .wallet-name { color: var(--text-white); font-weight: 600; font-size: 0.9rem; margin-bottom: 2px; }
        .wallet-balance { color: var(--text-gray); font-size: 0.8rem; }
        .wallet-value { text-align: right; }
        .wallet-value-amount { color: var(--text-white); font-weight: 700; font-size: 1rem; }

        .investment-item {
            background: var(--glass-bg); border: 1px solid var(--glass-border);
            border-radius: 12px; padding: 16px; margin-bottom: 12px; transition: all 0.3s ease;
        }
        .investment-item:hover { border-color: var(--secondary); }
        .investment-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; flex-wrap: wrap; gap: 8px; }
        .investment-title { color: var(--text-white); font-weight: 600; font-size: 0.95rem; }
        .investment-status { padding: 3px 10px; border-radius: 50px; font-size: 0.7rem; font-weight: 600; text-transform: uppercase; }
        .status-active { background: rgba(0, 255, 178, 0.15); color: var(--accent); }
        .status-matured { background: rgba(0, 212, 255, 0.15); color: var(--secondary); }
        .status-pending { background: rgba(255, 215, 0, 0.15); color: var(--gold); }
        .progress-info { display: flex; justify-content: space-between; font-size: 0.8rem; margin-bottom: 6px; }
        .progress-info .label { color: var(--text-muted, #6B758D); }
        .progress-info .value { color: var(--text-white); font-weight: 600; }
        .progress-bar-custom { height: 6px; background: rgba(255, 255, 255, 0.05); border-radius: 50px; overflow: hidden; }
        .progress-fill { height: 100%; background: linear-gradient(90deg, var(--primary, #2563EB), var(--accent, #00FFB2)); border-radius: 50px; transition: width 1s ease; }

        .transaction-item { display: flex; align-items: center; gap: 12px; padding: 12px 0; border-bottom: 1px solid var(--glass-border); }
        .transaction-item:last-child { border-bottom: none; }
        .transaction-icon { width: 38px; height: 38px; border-radius: 10px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
        .transaction-icon.deposit { background: rgba(0, 255, 178, 0.15); color: var(--accent); }
        .transaction-icon.withdraw { background: rgba(255, 59, 92, 0.15); color: #ff3b5c; }
        .transaction-icon.roi { background: rgba(0, 212, 255, 0.15); color: var(--secondary); }
        .transaction-icon.invest { background: rgba(255, 215, 0, 0.15); color: var(--gold); }
        .transaction-info { flex: 1; min-width: 0; }
        .transaction-title { color: var(--text-white); font-weight: 600; font-size: 0.85rem; margin-bottom: 2px; }
        .transaction-date { color: var(--text-muted); font-size: 0.7rem; }
        .transaction-amount { text-align: right; font-weight: 700; font-size: 0.9rem; }
        .transaction-amount.positive { color: var(--accent); }
        .transaction-amount.negative { color: #ff3b5c; }

        .empty-state { text-align: center; padding: 40px 20px; color: var(--text-muted); }
        .empty-state i { font-size: 3rem; margin-bottom: 16px; opacity: 0.5; }

        @media (max-width: 768px) {
            .welcome-banner { padding: 24px; }
            .welcome-banner h2 { font-size: 1.4rem; }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Entry Fee Modal -->
    <asp:Panel ID="pnlEntryFeeModal" runat="server" Visible="false">
        <uc1:EntryFeeModal ID="EntryFeeModal1" runat="server" />
    </asp:Panel>

    <!-- Welcome Banner -->
    <div class="welcome-banner" data-aos="fade-up">
        <div class="row align-items-center position-relative" style="z-index: 2;">
            <div class="col-lg-8">
                <small class="text-secondary"><i class="far fa-calendar me-1"></i><asp:Literal ID="litDate" runat="server"></asp:Literal></small>
                <h2>Welcome back, <asp:Literal ID="litWelcomeName" runat="server"></asp:Literal> 👋</h2>
                <p>Here's what's happening with your portfolio today.</p>
                <div class="daily-roi-banner">
                    <i class="fas fa-bolt"></i> Today's ROI: <strong><asp:Literal ID="litTodayROI" runat="server" Text="0.00 USDT"></asp:Literal></strong>
                </div>
            </div>
            <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
                <a href="<%= ResolveUrl("~/Web/User/Wallet.aspx?action=deposit") %>" class="btn btn-primary-glow">
                    <i class="fas fa-plus me-2"></i> Deposit Funds
                </a>
            </div>
        </div>
    </div>

    <!-- SUMMARY STAT CARDS -->
    <div class="row g-4 mb-4">
        <div class="col-lg-3 col-md-6" data-aos="fade-up">
            <div class="stat-card gold">
                <div class="stat-icon"><i class="fas fa-wallet"></i></div>
                <div class="stat-label">Net Worth</div>
                <div class="stat-value text-gradient-gold"><asp:Literal ID="litNetWorth" runat="server" Text="0.00" /></div>
                <small class="text-muted">Total USDT Value</small>
            </div>
        </div>
        <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="100">
            <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-coins"></i></div>
                <div class="stat-label">Wallet Balance</div>
                <div class="stat-value"><asp:Literal ID="litWalletBalance" runat="server" Text="0.00" /></div>
                <small class="text-muted">Available Funds</small>
            </div>
        </div>
        <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="200">
            <div class="stat-card green">
                <div class="stat-icon"><i class="fas fa-chart-line"></i></div>
                <div class="stat-label">Total Invested</div>
                <div class="stat-value"><asp:Literal ID="litTotalInvested" runat="server" Text="0.00" /></div>
                <small class="text-muted">Active Plans</small>
            </div>
        </div>
        <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="300">
            <div class="stat-card purple">
                <div class="stat-icon"><i class="fas fa-gift"></i></div>
                <div class="stat-label">Total Earnings</div>
                <div class="stat-value"><asp:Literal ID="litTotalEarnings" runat="server" Text="0.00" /></div>
                <small class="text-muted">Lifetime ROI</small>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="row g-3 mb-4">
        <div class="col-6 col-md-3" data-aos="fade-up">
            <a href="<%= ResolveUrl("~/Web/User/Wallet.aspx?action=deposit") %>" class="quick-action">
                <i class="fas fa-arrow-down"></i><span>Deposit</span>
            </a>
        </div>
        <div class="col-6 col-md-3" data-aos="fade-up" data-aos-delay="100">
            <a href="<%= ResolveUrl("~/Web/User/Wallet.aspx?action=withdraw") %>" class="quick-action">
                <i class="fas fa-arrow-up"></i><span>Withdraw</span>
            </a>
        </div>
        <div class="col-6 col-md-3" data-aos="fade-up" data-aos-delay="200">
            <a href="<%= ResolveUrl("~/Web/User/Investments.aspx") %>" class="quick-action">
                <i class="fas fa-chart-line"></i><span>Invest</span>
            </a>
        </div>
        <div class="col-6 col-md-3" data-aos="fade-up" data-aos-delay="300">
            <a href="<%= ResolveUrl("~/Web/User/Referrals.aspx") %>" class="quick-action">
                <i class="fas fa-users"></i><span>Refer & Earn</span>
            </a>
        </div>
    </div>

    <!-- Main Grid -->
    <div class="row g-4">

        <!-- Portfolio Chart -->
        <div class="col-lg-8" data-aos="fade-up">
            <div class="chart-card">
                <div class="chart-header">
                    <h5 class="chart-title"><i class="fas fa-chart-area text-gold me-2"></i> Portfolio Flow</h5>
                    <div class="d-flex gap-3 align-items-center">
                        <div class="d-flex align-items-center gap-2">
                            <span style="width: 12px; height: 12px; background: #FFD700; border-radius: 50%; display: inline-block;"></span>
                            <small class="text-muted">Inflow</small>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <span style="width: 12px; height: 12px; background: #FF3B5C; border-radius: 50%; display: inline-block;"></span>
                            <small class="text-muted">Outflow</small>
                        </div>
                    </div>
                </div>
                <div style="height: 320px; position: relative;">
                    <!-- ✅ FIX: Only ONE canvas with this ID -->
                    <canvas id="portfolioChart"></canvas>
                </div>
            </div>
        </div>

        <!-- Wallets -->
        <div class="col-lg-4" data-aos="fade-up" data-aos-delay="100">
            <div class="chart-card h-100">
                <div class="chart-header">
                    <h5 class="chart-title">My Wallets</h5>
                    <a href="<%= ResolveUrl("~/Web/User/Wallet.aspx") %>" class="text-secondary small">View All</a>
                </div>
                <div class="d-flex flex-column gap-3">
                    <asp:Repeater ID="rptWallets" runat="server">
                        <ItemTemplate>
                            <a href="<%= ResolveUrl("~/Web/User/Wallet.aspx") %>" class="wallet-widget">
                                <div class='wallet-icon <%# GetCurrencyIconClass(Eval("CurrencyCode")) %>'>
                                    <i class='<%# GetCurrencyIcon(Eval("CurrencyCode")) %>'></i>
                                </div>
                                <div class="wallet-info">
                                    <div class="wallet-name"><%# Eval("CurrencyName") %></div>
                                    <div class="wallet-balance"><%# string.Format("{0:0.########}", Eval("Balance")) %> <%# Eval("CurrencyCode") %></div>
                                </div>
                                <div class="wallet-value">
                                    <div class="wallet-value-amount"><%# string.Format("{0:0.00}", Eval("ValuePNC")) %></div>
                                    <div class="wallet-value-change">USDT</div>
                                </div>
                            </a>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlNoWallets" runat="server" Visible="false">
                        <div class="empty-state"><i class="fas fa-wallet"></i><p>No wallets yet</p></div>
                    </asp:Panel>
                </div>
            </div>
        </div>

        <!-- Active Investments -->
        <div class="col-lg-8" data-aos="fade-up">
            <div class="chart-card">
                <div class="chart-header">
                    <h5 class="chart-title">Active Investments</h5>
                    <a href="<%= ResolveUrl("~/Web/User/Investments.aspx") %>" class="text-secondary small">View All</a>
                </div>
                <asp:Repeater ID="rptInvestments" runat="server">
                    <ItemTemplate>
                        <div class="investment-item">
                            <div class="investment-header">
                                <div>
                                    <div class="investment-title"><%# Eval("PlanName") %></div>
                                    <small class="text-muted">Invested: <%# string.Format("{0:0.00}", Eval("PrincipalAmount")) %> USDT</small>
                                </div>
                                <span class='investment-status <%# GetInvestmentStatusClass(Eval("Status")) %>'><%# GetInvestmentStatusLabel(Eval("Status")) %></span>
                            </div>
                            <div class="progress-info">
                                <span class="label">Day <%# Eval("CurrentDay") %> of <%# Eval("TotalDays") %></span>
                                <span class="value"><%# Eval("ProgressPercent") %>%</span>
                            </div>
                            <div class="progress-bar-custom">
                                <!-- ✅ FIX: Corrected inline style syntax -->
                                <div class="progress-fill" style='width: <%# Eval("ProgressPercent") %>%;'></div>
                            </div>
                            <div class="d-flex justify-content-between mt-2">
                                <small class="text-muted">Earned: <strong class="text-accent"><%# string.Format("{0:0.00}", Eval("TotalEarned")) %> USDT</strong></small>
                                <small class="text-muted">Daily: <strong class="text-white"><%# string.Format("{0:0.00}", Eval("DailyROI")) %> USDT</strong></small>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Panel ID="pnlNoInvestments" runat="server" Visible="false">
                    <div class="empty-state">
                        <i class="fas fa-chart-line"></i><p>No active investments yet.</p>
                        <a href="<%= ResolveUrl("~/Web/User/Investments.aspx") %>" class="btn btn-primary-glow">Start Investing</a>
                    </div>
                </asp:Panel>
            </div>
        </div>

        <!-- Recent Transactions -->
        <div class="col-lg-4" data-aos="fade-up" data-aos-delay="100">
            <div class="chart-card h-100">
                <div class="chart-header">
                    <h5 class="chart-title">Recent Transactions</h5>
                    <a href="<%= ResolveUrl("~/Web/User/Transactions.aspx") %>" class="text-secondary small">View All</a>
                </div>
                <asp:Repeater ID="rptTransactions" runat="server">
                    <ItemTemplate>
                        <div class="transaction-item">
                            <div class='transaction-icon <%# GetTransactionIconClass(Eval("TransactionType")) %>'>
                                <i class='<%# GetTransactionIcon(Eval("TransactionType")) %>'></i>
                            </div>
                            <div class="transaction-info">
                                <div class="transaction-title"><%# Eval("TypeName") %></div>
                                <div class="transaction-date"><%# Eval("CreatedDate") %></div>
                            </div>
                            <div class='transaction-amount <%# Convert.ToDecimal(Eval("Amount")) >= 0 ? "positive" : "negative" %>'>
                                <%# (Convert.ToDecimal(Eval("Amount")) >= 0 ? "+" : "") + string.Format(" {0:0.00} {1}", Eval("Amount"), Eval("CurrencyCode")) %>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Panel ID="pnlNoTransactions" runat="server" Visible="false">
                    <div class="empty-state"><i class="fas fa-exchange-alt"></i><p>No transactions yet</p></div>
                </asp:Panel>
            </div>
        </div>

        <!-- Earnings Breakdown Chart -->
        <div class="col-lg-6" data-aos="fade-up">
            <div class="chart-card">
                <div class="chart-header"><h5 class="chart-title">Earnings Breakdown</h5></div>
                <div style="height: 280px;"><canvas id="earningsChart"></canvas></div>
            </div>
        </div>

        <!-- Referral Stats -->
        <div class="col-lg-6" data-aos="fade-up" data-aos-delay="100">
            <div class="chart-card h-100">
                <div class="chart-header">
                    <h5 class="chart-title">Referral Program</h5>
                    <a href="<%= ResolveUrl("~/Web/User/Referrals.aspx") %>" class="text-secondary small">Details</a>
                </div>
                <div class="row g-3">
                    <div class="col-6">
                        <div class="stat-card" style="padding: 16px;">
                            <div class="stat-label">Direct Referrals</div>
                            <div class="stat-value" style="font-size: 1.5rem;"><asp:Literal ID="litDirectReferrals" runat="server" Text="0"></asp:Literal></div>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="stat-card green" style="padding: 16px;">
                            <div class="stat-label">Total Team</div>
                            <div class="stat-value" style="font-size: 1.5rem;"><asp:Literal ID="litTotalTeam" runat="server" Text="0"></asp:Literal></div>
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="stat-card gold" style="padding: 16px;">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="stat-label">Total Commission Earned</div>
                                    <div class="stat-value" style="font-size: 1.5rem;">
                                        <asp:Literal ID="litTotalCommission" runat="server" Text="0.00"></asp:Literal>
                                        <small style="font-size: 0.8rem; color: var(--text-gray);"> USDT</small>
                                    </div>
                                </div>
                                <i class="fas fa-coins fa-3x" style="color: var(--gold); opacity: 0.3;"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-12">
                        <a href="<%= ResolveUrl("~/Web/User/Referrals.aspx") %>" class="btn btn-outline-glass w-100">
                            <i class="fas fa-share-alt me-2"></i> Share Your Referral Link
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ✅ FIX: Hidden Fields with correct plural names matching C# -->
    <asp:HiddenField ID="hidChartLabels" runat="server" />
    <asp:HiddenField ID="hidChartInflows" runat="server" />
    <asp:HiddenField ID="hidChartOutflows" runat="server" />

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <!-- ✅ FIX 1: Chart.js MUST load BEFORE any script that uses it -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
    <script src="https://cdn.ethers.io/lib/ethers-5.7.umd.min.js"></script>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // ✅ FIX 2: Safely parse data using C# helper methods to prevent null/undefined JS errors
            const labels = <%= GetChartLabels() %>;
            const inflowData = <%= GetChartInflows() %>;
            const outflowData = <%= GetChartOutflows() %>;
            const earningsData = [<%= GetEarningsBreakdown() %>];

            // --- Portfolio Flow Chart ---
            const portfolioCtx = document.getElementById('portfolioChart');
            if (portfolioCtx && labels.length > 0) {
                const ctx = portfolioCtx.getContext('2d');

                const goldGradient = ctx.createLinearGradient(0, 0, 0, 320);
                goldGradient.addColorStop(0, 'rgba(255, 215, 0, 0.4)');
                goldGradient.addColorStop(1, 'rgba(255, 215, 0, 0.0)');

                const redGradient = ctx.createLinearGradient(0, 0, 0, 320);
                redGradient.addColorStop(0, 'rgba(255, 59, 92, 0.3)');
                redGradient.addColorStop(1, 'rgba(255, 59, 92, 0.0)');

                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: labels,
                        datasets: [
                            {
                                label: 'Inflow',
                                data: inflowData,
                                borderColor: '#FFD700',
                                backgroundColor: goldGradient,
                                borderWidth: 3,
                                fill: true,
                                tension: 0.4,
                                pointRadius: 0,
                                pointHoverRadius: 6
                            },
                            {
                                label: 'Outflow',
                                data: outflowData,
                                borderColor: '#FF3B5C',
                                backgroundColor: redGradient,
                                borderWidth: 2,
                                fill: true,
                                tension: 0.4,
                                pointRadius: 0,
                                pointHoverRadius: 6,
                                borderDash: [5, 5]
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        interaction: { mode: 'index', intersect: false },
                        plugins: {
                            legend: { display: false },
                            tooltip: {
                                backgroundColor: 'rgba(10, 10, 15, 0.95)',
                                titleColor: '#FFD700',
                                bodyColor: '#fff',
                                borderColor: 'rgba(255, 215, 0, 0.3)',
                                borderWidth: 1,
                                padding: 12,
                                callbacks: {
                                    label: function(context) {
                                        return context.dataset.label + ': ' + context.parsed.y.toLocaleString() + ' USDT';
                                    }
                                }
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                grid: { color: 'rgba(255, 255, 255, 0.05)', drawBorder: false },
                                ticks: {
                                    color: '#8B7355',
                                    font: { size: 11 },
                                    callback: function(value) {
                                        if (value >= 1000000) return (value / 1000000).toFixed(1) + 'M';
                                        if (value >= 1000) return (value / 1000).toFixed(0) + 'K';
                                        return value;
                                    }
                                }
                            },
                            x: {
                                grid: { display: false },
                                ticks: { color: '#8B7355', font: { size: 11 }, maxRotation: 0, autoSkip: true, maxTicksLimit: 10 }
                            }
                        }
                    }
                });
            }

            // --- Earnings Doughnut Chart ---
            const earningsCtx = document.getElementById('earningsChart');
            if (earningsCtx) {
                new Chart(earningsCtx, {
                    type: 'doughnut',
                    data: {
                        labels: ['ROI Plans', 'Staking', 'Mining', 'Referrals', 'Royalties'],
                        datasets: [{
                            data: earningsData,
                            backgroundColor: ['#2563EB', '#00D4FF', '#00FFB2', '#FFD700', '#9C27B0'],
                            borderColor: 'rgba(7, 17, 31, 0.8)',
                            borderWidth: 3
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        cutout: '65%',
                        plugins: {
                            legend: {
                                position: 'bottom',
                                labels: { color: '#A0AABF', padding: 15, font: { size: 12 }, usePointStyle: true, pointStyle: 'circle' }
                            },
                            tooltip: {
                                backgroundColor: 'rgba(11, 19, 43, 0.95)',
                                borderColor: '#00D4FF',
                                borderWidth: 1,
                                padding: 12,
                                callbacks: {
                                    label: function(ctx) { return ctx.label + ': ' + ctx.parsed.toLocaleString() + ' USDT'; }
                                }
                            }
                        }
                    }
                });
            }
        });
    </script>
</asp:Content>