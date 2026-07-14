<%@ Page Title="Portfolio" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="Portfolio.aspx.cs" Inherits="Mexify.Web.User.Portfolio" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .portfolio-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            flex-wrap: wrap;
            gap: 16px;
        }
        .portfolio-header h2 { color: var(--text-white); margin: 0; font-size: 1.8rem; }

        .portfolio-summary {
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.25), rgba(0, 255, 178, 0.15));
            border: 1px solid rgba(0, 212, 255, 0.3);
            border-radius: var(--radius-xl);
            padding: 40px;
            position: relative;
            overflow: hidden;
            margin-bottom: 32px;
        }
        .portfolio-summary::before {
            content: '';
            position: absolute;
            top: -50%; right: -10%;
            width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(0, 212, 255, 0.2) 0%, transparent 70%);
            animation: float 15s ease-in-out infinite;
        }
        @keyframes float {
            0%,100%{transform:translate(0,0) scale(1)}
            50%{transform:translate(20px,-20px) scale(1.1)}
        }
        .portfolio-value-label {
            color: var(--text-gray);
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            margin-bottom: 8px;
        }
        .portfolio-value {
            font-size: 3rem;
            font-weight: 800;
            color: var(--text-white);
            font-family: 'Space Grotesk', sans-serif;
            margin-bottom: 4px;
        }
        .portfolio-value small {
            font-size: 1.2rem;
            color: var(--text-gray);
        }
        .portfolio-change {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.9rem;
            margin-top: 8px;
        }
        .portfolio-change.up { background: rgba(0, 255, 178, 0.1); color: var(--accent); }
        .portfolio-change.down { background: rgba(255, 59, 92, 0.1); color: #ff3b5c; }

        .metric-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 24px;
            text-align: center;
            transition: all 0.3s ease;
            height: 100%;
        }
        .metric-card:hover {
            transform: translateY(-3px);
            border-color: var(--secondary);
        }
        .metric-value {
            font-size: 1.6rem;
            font-weight: 800;
            color: var(--text-white);
            font-family: 'Space Grotesk', sans-serif;
            margin-bottom: 4px;
        }
        .metric-label {
            font-size: 0.8rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .holding-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 24px;
            margin-bottom: 16px;
            transition: all 0.3s ease;
        }
        .holding-card:hover {
            border-color: var(--secondary);
            transform: translateX(4px);
        }
        .holding-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
            flex-wrap: wrap;
            gap: 12px;
        }
        .holding-info {
            display: flex;
            align-items: center;
            gap: 14px;
        }
        .holding-icon {
            width: 48px; height: 48px;
            border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.3rem;
            flex-shrink: 0;
        }
        .holding-icon.roi { background: linear-gradient(135deg, rgba(37, 99, 235, 0.2), rgba(0, 212, 255, 0.1)); color: var(--secondary); }
        .holding-icon.staking { background: linear-gradient(135deg, rgba(0, 255, 178, 0.2), rgba(0, 212, 255, 0.1)); color: var(--accent); }
        .holding-icon.mining { background: linear-gradient(135deg, rgba(255, 215, 0, 0.2), rgba(255, 165, 0, 0.1)); color: var(--gold); }
        .holding-icon.nft { background: linear-gradient(135deg, rgba(156, 39, 176, 0.2), rgba(233, 30, 99, 0.1)); color: #9C27B0; }
        .holding-icon.ico { background: linear-gradient(135deg, rgba(255, 107, 107, 0.2), rgba(255, 59, 92, 0.1)); color: #ff6b6b; }
        .holding-icon.royalty { background: linear-gradient(135deg, rgba(0, 212, 255, 0.2), rgba(37, 99, 235, 0.1)); color: #00D4FF; }
        .holding-icon.wallet { background: linear-gradient(135deg, rgba(255, 215, 0, 0.2), rgba(255, 165, 0, 0.1)); color: var(--gold); }
        .holding-name { color: var(--text-white); font-weight: 600; font-size: 1rem; }
        .holding-type { color: var(--text-muted); font-size: 0.8rem; }
        .holding-value { text-align: right; }
        .holding-amount { color: var(--text-white); font-weight: 700; font-size: 1.2rem; }
        .holding-change { font-size: 0.8rem; font-weight: 600; }
        .holding-change.up { color: var(--accent); }
        .holding-change.down { color: #ff3b5c; }

        .holding-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 12px;
            padding-top: 16px;
            border-top: 1px solid var(--glass-border);
        }
        .holding-detail {
            text-align: center;
        }
        .holding-detail .label {
            color: var(--text-muted);
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }
        .holding-detail .value {
            color: var(--text-white);
            font-weight: 600;
            font-size: 0.9rem;
        }

        .progress-bar-holding {
            height: 4px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50px;
            overflow: hidden;
            margin-top: 12px;
        }
        .progress-fill-holding {
            height: 100%;
            border-radius: 50px;
            transition: width 1s ease;
        }
        .progress-fill-holding.roi { background: linear-gradient(90deg, var(--primary), var(--secondary)); }
        .progress-fill-holding.staking { background: linear-gradient(90deg, var(--accent), #00D4FF); }
        .progress-fill-holding.mining { background: linear-gradient(90deg, var(--gold), #FFA500); }
        .progress-fill-holding.nft { background: linear-gradient(90deg, #9C27B0, #E91E63); }
        .progress-fill-holding.ico { background: linear-gradient(90deg, #ff6b6b, #ff3b5c); }

        .chart-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 24px;
        }
        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 12px;
        }
        .chart-title {
            color: var(--text-white);
            font-weight: 700;
            font-size: 1.1rem;
            margin: 0;
        }
        .chart-tabs {
            display: flex;
            gap: 4px;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 50px;
            padding: 4px;
        }
        .chart-tab {
            padding: 6px 14px;
            border-radius: 50px;
            font-size: 0.75rem;
            color: var(--text-gray);
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            background: transparent;
            font-weight: 600;
        }
        .chart-tab.active {
            background: var(--primary);
            color: var(--text-white);
        }
        .chart-tab:hover:not(.active) {
            background: rgba(255, 255, 255, 0.05);
            color: var(--text-white);
        }

        .allocation-legend {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            margin-top: 20px;
        }
        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.85rem;
            color: var(--text-gray);
        }
        .legend-dot {
            width: 10px; height: 10px;
            border-radius: 50%;
            flex-shrink: 0;
        }
        .legend-value {
            margin-left: auto;
            font-weight: 600;
            color: var(--text-white);
        }

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
            .portfolio-value { font-size: 2rem; }
            .holding-details { grid-template-columns: repeat(2, 1fr); }
            .allocation-legend { grid-template-columns: 1fr; }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Header -->
    <div class="portfolio-header" data-aos="fade-up">
        <div>
            <h2>Portfolio</h2>
            <p class="text-gray mb-0">Track your investments and asset allocation</p>
        </div>
        <div class="d-flex gap-2">
            <a href="<%= ResolveUrl("~/Web/User/Wallet.aspx") %>" class="btn btn-outline-glass">
                <i class="fas fa-wallet me-2"></i> Wallet
            </a>
            <a href="<%= ResolveUrl("~/Web/User/Investments.aspx") %>" class="btn btn-primary-glow">
                <i class="fas fa-plus me-2"></i> New Investment
            </a>
        </div>
    </div>

    <!-- Portfolio Summary -->
    <div class="portfolio-summary" data-aos="fade-up">
        <div class="row align-items-center position-relative" style="z-index: 2;">
            <div class="col-lg-6">
                <div class="portfolio-value-label">Total Portfolio Value</div>
                <div class="portfolio-value">
                    <asp:Literal ID="litTotalValue" runat="server" Text="0.00"></asp:Literal>
                    <small> USDT</small>
                </div>
                <div style="color: var(--text-gray); font-size: 1.1rem;">
                     $<asp:Literal ID="litTotalUSD" runat="server" Text="0.00"></asp:Literal> USD
                </div>
                <asp:Panel ID="pnlChange" runat="server">
                    <span class='portfolio-change <%# IsPositiveChange ? "up" : "down" %>'>
                        <i class='fas fa-arrow-<%# IsPositiveChange ? "up" : "down" %>'></i>
                        <asp:Literal ID="litChangePercent" runat="server" Text="0.00"></asp:Literal>%
                        (<asp:Literal ID="litChangeAmount" runat="server" Text="0.00"></asp:Literal> USDT)
                    </span>
                </asp:Panel>
            </div>
            <div class="col-lg-6 mt-3 mt-lg-0">
                <div class="row g-3">
                    <div class="col-6">
                        <div class="metric-card">
                            <div class="metric-value" style="color: var(--accent);">
                                <asp:Literal ID="litTotalEarnings" runat="server" Text="0.00"></asp:Literal>
                            </div>
                            <div class="metric-label">Total Earnings</div>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="metric-card">
                            <div class="metric-value">
                                <asp:Literal ID="litActiveCount" runat="server" Text="0"></asp:Literal>
                            </div>
                            <div class="metric-label">Active Investments</div>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="metric-card">
                            <div class="metric-value" style="color: var(--gold);">
                                <asp:Literal ID="litDailyIncome" runat="server" Text="0.00"></asp:Literal>
                            </div>
                            <div class="metric-label">Daily Income</div>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="metric-card">
                            <div class="metric-value" style="color: var(--secondary);">
                                <asp:Literal ID="litROI" runat="server" Text="0.00"></asp:Literal>%
                            </div>
                            <div class="metric-label">Overall ROI</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Charts Row -->
    <div class="row g-4 mb-4">
        <!-- Portfolio Performance -->
        <div class="col-lg-8" data-aos="fade-up">
            <div class="chart-card">
                <div class="chart-header">
                    <h5 class="chart-title">Portfolio Performance</h5>
                    <div class="chart-tabs">
                        <button class="chart-tab active">7D</button>
                        <button class="chart-tab">30D</button>
                        <button class="chart-tab">90D</button>
                        <button class="chart-tab">1Y</button>
                    </div>
                </div>
                <div style="height: 300px;">
                    <canvas id="performanceChart"></canvas>
                </div>
            </div>
        </div>

        <!-- Asset Allocation -->
        <div class="col-lg-4" data-aos="fade-up" data-aos-delay="100">
            <div class="chart-card h-100">
                <div class="chart-header">
                    <h5 class="chart-title">Asset Allocation</h5>
                </div>
                <div style="height: 220px;">
                    <canvas id="allocationChart"></canvas>
                </div>
                <div class="allocation-legend">
                    <asp:Repeater ID="rptAllocationLegend" runat="server">
                        <ItemTemplate>
                            <div class="legend-item">
                                <span class="legend-dot" style='background: <%# Eval("Color") %>;' ></span>
                                <span><%# Eval("Name") %></span>
                                <span class="legend-value"><%# Eval("Percent") %>%</span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
    </div>

    <!-- Holdings Section -->
    <h4 class="text-white mb-3" data-aos="fade-up">
        <i class="fas fa-layer-group text-secondary me-2"></i>
        Your Holdings
    </h4>

    <!-- Wallet Holdings -->
    <asp:Panel ID="pnlWalletHoldings" runat="server">
        <asp:Repeater ID="rptWalletHoldings" runat="server">
            <ItemTemplate>
                <div class="holding-card" data-aos="fade-up">
                    <div class="holding-header">
                        <div class="holding-info">
                            <div class="holding-icon wallet">
                                <i class='<%# GetCurrencyIcon(Eval("CurrencyCode")) %>'></i>
                            </div>
                            <div>
                                <div class="holding-name"><%# Eval("CurrencyName") %></div>
                                <div class="holding-type">Wallet Balance</div>
                            </div>
                        </div>
                        <div class="holding-value">
                            <div class="holding-amount">
                                <%# string.Format("{0:0.########}", Eval("Balance")) %> <%# Eval("CurrencyCode") %>
                            </div>
                            <div class="holding-change up">
                                ≈ <%# string.Format("{0:0.00}", Eval("ValuePNC")) %> USDT
                            </div>
                        </div>
                    </div>
                    <div class="holding-details">
                        <div class="holding-detail">
                            <div class="label">Available</div>
                            <div class="value"><%# string.Format("{0:0.########}", Eval("AvailableBalance")) %></div>
                        </div>
                        <div class="holding-detail">
                            <div class="label">Locked</div>
                            <div class="value"><%# string.Format("{0:0.########}", Eval("LockedBalance")) %></div>
                        </div>
                        <div class="holding-detail">
                            <div class="label">Allocation</div>
                            <div class="value"><%# Eval("AllocationPercent") %>%</div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </asp:Panel>

    <!-- Investment Holdings -->
    <asp:Repeater ID="rptHoldings" runat="server">
        <ItemTemplate>
            <div class="holding-card" data-aos="fade-up">
                <div class="holding-header">
                    <div class="holding-info">
                        <div class='holding-icon <%# Eval("TypeClass") %>'>
                            <i class='<%# Eval("Icon") %>'></i>
                        </div>
                        <div>
                            <div class="holding-name"><%# Eval("Name") %></div>
                            <div class="holding-type"><%# Eval("TypeName") %></div>
                        </div>
                    </div>
                    <div class="holding-value">
                        <div class="holding-amount">
                            <%# string.Format("{0:0.00}", Eval("Value")) %> USDT
                        </div>
                        <div class='holding-change <%# Convert.ToDecimal(Eval("ChangePercent")) >= 0 ? "up" : "down" %>'>
                            <i class='fas fa-arrow-<%# Convert.ToDecimal(Eval("ChangePercent")) >= 0 ? "up" : "down" %>'></i>
                            <%# Math.Abs(Convert.ToDecimal(Eval("ChangePercent"))).ToString("0.00") %>%
                        </div>
                    </div>
                </div>

                <div class="holding-details">
                    <div class="holding-detail">
                        <div class="label">Invested</div>
                        <div class="value"><%# string.Format("{0:0.00}", Eval("Invested")) %> USDT</div>
                    </div>
                    <div class="holding-detail">
                        <div class="label">Earned</div>
                        <div class="value" style="color: var(--accent);"><%# string.Format("{0:0.00}", Eval("Earned")) %> PNC</div>
                    </div>
                    <div class="holding-detail">
                        <div class="label">Daily Income</div>
                        <div class="value"><%# string.Format("{0:0.00}", Eval("DailyIncome")) %> USDT</div>
                    </div>
                    <div class="holding-detail">
                        <div class="label">Status</div>
                        <div class="value"><%# Eval("Status") %></div>
                    </div>
                </div>

                <asp:Panel runat="server" Visible='<%# Convert.ToInt32(Eval("Progress")) > 0 && Convert.ToInt32(Eval("Progress")) <= 100 %>'>
                    <div class="progress-bar-holding">
                        <div class='progress-fill-holding <%# Eval("TypeClass") %>' style="width: <%# Eval("Progress") %>%;"></div>
                    </div>
                    <div class="d-flex justify-content-between mt-1">
                        <small class="text-muted">Day <%# Eval("CurrentDay") %> / <%# Eval("TotalDays") %></small>
                        <small class="text-muted"><%# Eval("Progress") %>% Complete</small>
                    </div>
                </asp:Panel>
            </div>
        </ItemTemplate>
    </asp:Repeater>

    <!-- Empty State -->
    <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
        <div class="empty-state" data-aos="fade-up">
            <i class="fas fa-chart-pie"></i>
            <h4>No Holdings Yet</h4>
            <p>Start building your portfolio by making your first investment.</p>
            <div class="d-flex gap-3 justify-content-center flex-wrap">
                <a href="<%= ResolveUrl("~/roi.aspx") %>" class="btn btn-primary-glow">
                    <i class="fas fa-chart-line me-2"></i> 2X ROI Plans
                </a>
                <a href="<%= ResolveUrl("~/staking.aspx") %>" class="btn btn-outline-glass">
                    <i class="fas fa-coins me-2"></i> Staking
                </a>
                <a href="<%= ResolveUrl("~/mining.aspx") %>" class="btn btn-outline-glass">
                    <i class="fas fa-server me-2"></i> Mining
                </a>
            </div>
        </div>
    </asp:Panel>

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Portfolio Performance Chart
            var perfData = <%= GetPerformanceChartData() %>;
            var perfCtx = document.getElementById('performanceChart');
            if (perfCtx) {
                new Chart(perfCtx, {
                    type: 'line',
                    data: {
                        labels: perfData.labels,
                        datasets: [{
                            label: 'Portfolio Value (PNC)',
                            data: perfData.values,
                            borderColor: '#00FFB2',
                            backgroundColor: 'rgba(0, 255, 178, 0.1)',
                            fill: true,
                            tension: 0.4,
                            pointRadius: 0,
                            pointHoverRadius: 6,
                            borderWidth: 2
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { display: false },
                            tooltip: {
                                backgroundColor: 'rgba(11, 19, 43, 0.95)',
                                borderColor: '#00D4FF',
                                borderWidth: 1,
                                callbacks: {
                                    label: function(ctx) { return ctx.parsed.y.toLocaleString() + ' USDT'; }
                                }
                            }
                        },
                        scales: {
                            y: {
                                grid: { color: 'rgba(255,255,255,0.05)' },
                                ticks: { color: '#6B758D', callback: function(v) { return v.toLocaleString(); } }
                            },
                            x: { grid: { display: false }, ticks: { color: '#6B758D' } }
                        }
                    }
                });
            }

            // Allocation Doughnut Chart
            var allocData = <%= GetAllocationChartData() %>;
            var allocCtx = document.getElementById('allocationChart');
            if (allocCtx) {
                new Chart(allocCtx, {
                    type: 'doughnut',
                    data: {
                        labels: allocData.labels,
                        datasets: [{
                            data: allocData.values,
                            backgroundColor: allocData.colors,
                            borderColor: 'rgba(7, 17, 31, 0.8)',
                            borderWidth: 3
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        cutout: '70%',
                        plugins: { legend: { display: false } }
                    }
                });
            }

            // Tab switching
            document.querySelectorAll('.chart-tab').forEach(function(tab) {
                tab.addEventListener('click', function() {
                    document.querySelectorAll('.chart-tab').forEach(function(t) { t.classList.remove('active'); });
                    tab.classList.add('active');
                });
            });
        });
    </script>
</asp:Content>