<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="Mmining.aspx.cs" Inherits="Mexify.Web.User.Mmining" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        .mining-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            flex-wrap: wrap;
            gap: 16px;
        }
        .mining-header h2 { color: var(--text-white); margin: 0; font-size: 1.8rem; }

        .mining-tabs {
            display: flex;
            gap: 4px;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 50px;
            padding: 4px;
            margin-bottom: 28px;
            width: fit-content;
            max-width: 100%;
            overflow-x: auto;
            flex-wrap: wrap;
        }
        .mining-tab {
            padding: 10px 24px;
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
        .mining-tab.active {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: var(--text-white);
            box-shadow: 0 4px 12px rgba(123, 44, 191, 0.3);
        }
        .mining-tab:hover:not(.active) {
            background: rgba(255, 255, 255, 0.05);
            color: var(--text-white);
        }

        /* Mining Stats Hero */
        .mining-hero {
            background: linear-gradient(135deg, rgba(123, 44, 191, 0.25), rgba(255, 215, 0, 0.1));
            border: 1px solid rgba(157, 78, 221, 0.3);
            border-radius: var(--radius-xl);
            padding: 40px;
            position: relative;
            overflow: hidden;
            margin-bottom: 32px;
        }
        .mining-hero::before {
            content: '';
            position: absolute;
            top: -50%; right: -10%;
            width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(157, 78, 221, 0.2) 0%, transparent 70%);
            animation: float 15s ease-in-out infinite;
        }
        @keyframes float {
            0%,100%{transform:translate(0,0) scale(1)}
            50%{transform:translate(20px,-20px) scale(1.1)}
        }

        .hashrate-display {
            display: flex;
            align-items: baseline;
            gap: 8px;
            margin-bottom: 8px;
        }
        .hashrate-value {
            font-size: 3rem;
            font-weight: 800;
            color: var(--text-white);
            font-family: 'Space Grotesk', sans-serif;
        }
        .hashrate-unit {
            font-size: 1.2rem;
            color: var(--accent);
            font-weight: 600;
        }

        .mining-stat-card {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 20px;
            text-align: center;
            transition: all 0.3s ease;
        }
        .mining-stat-card:hover {
            border-color: var(--accent);
            transform: translateY(-3px);
        }
        .mining-stat-label {
            color: var(--text-muted);
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 8px;
        }
        .mining-stat-value {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--text-white);
        }

        /* Mining Rig Card */
        .rig-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 24px;
            margin-bottom: 16px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .rig-card:hover {
            border-color: var(--secondary);
            transform: translateX(4px);
        }
        .rig-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0;
            width: 4px; height: 100%;
            background: linear-gradient(180deg, var(--accent), var(--secondary));
        }
        .rig-card.mining::before {
            background: linear-gradient(180deg, #00FFB2, #00D4FF);
            animation: pulse-bar 2s infinite;
        }
        @keyframes pulse-bar {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
        }
        .rig-card.expired::before {
            background: linear-gradient(180deg, var(--gold), #FFA500);
        }

        .rig-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 16px;
            flex-wrap: wrap;
            gap: 12px;
        }
        .rig-info { display: flex; align-items: center; gap: 14px; }
        .rig-icon {
            width: 52px; height: 52px;
            border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.4rem;
            background: linear-gradient(135deg, rgba(157, 78, 221, 0.2), rgba(0, 212, 255, 0.1));
            color: var(--accent);
            border: 1px solid rgba(157, 78, 221, 0.3);
            flex-shrink: 0;
        }
        .rig-name { color: var(--text-white); font-weight: 600; font-size: 1rem; margin-bottom: 2px; }
        .rig-id { color: var(--text-muted); font-size: 0.8rem; }

        .rig-status {
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
            text-transform: uppercase;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .rig-status.active { background: rgba(0, 255, 178, 0.15); color: var(--accent); }
        .rig-status.active::before {
            content: '';
            width: 6px; height: 6px;
            border-radius: 50%;
            background: var(--accent);
            animation: blink 1.5s infinite;
        }
        @keyframes blink {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.3; }
        }
        .rig-status.expired { background: rgba(255, 215, 0, 0.15); color: var(--gold); }
        .rig-status.stopped { background: rgba(255, 59, 92, 0.15); color: #ff3b5c; }

        .rig-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 12px;
            padding: 16px 0;
            border-top: 1px solid var(--glass-border);
            border-bottom: 1px solid var(--glass-border);
        }
        .rig-stat { text-align: center; }
        .rig-stat .label {
            color: var(--text-muted);
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }
        .rig-stat .value {
            color: var(--text-white);
            font-weight: 600;
            font-size: 0.9rem;
        }
        .rig-stat .value.accent { color: var(--accent); }
        .rig-stat .value.gold { color: var(--gold); }

        .progress-bar-mining {
            height: 6px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50px;
            overflow: hidden;
            margin: 16px 0 8px;
        }
        .progress-fill-mining {
            height: 100%;
            background: linear-gradient(90deg, var(--accent), var(--secondary));
            border-radius: 50px;
            transition: width 1s ease;
            position: relative;
        }
        .progress-fill-mining::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            animation: shimmer 2s infinite;
        }
        @keyframes shimmer {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
        }

        /* Mining Plans */
        .plan-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 28px;
            transition: all 0.3s ease;
            cursor: pointer;
            height: 100%;
            position: relative;
        }
        .plan-card:hover {
            transform: translateY(-5px);
            border-color: var(--secondary);
            box-shadow: 0 15px 40px rgba(157, 78, 221, 0.15);
        }
        .plan-card.featured {
            border-color: var(--gold);
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.05), rgba(123, 44, 191, 0.05));
        }
        .plan-card.featured::before {
            content: 'POPULAR';
            position: absolute;
            top: 16px; right: 16px;
            background: linear-gradient(135deg, var(--gold), #FFA500);
            color: #000;
            font-size: 0.65rem;
            font-weight: 800;
            padding: 3px 10px;
            border-radius: 50px;
            letter-spacing: 1px;
        }
        .plan-hashrate {
            font-size: 2.2rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--accent), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: 12px 0;
            line-height: 1;
        }
        .plan-hashrate small {
            font-size: 0.85rem;
            color: var(--text-gray);
            -webkit-text-fill-color: var(--text-gray);
        }
        .plan-price {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-white);
            margin: 16px 0 8px;
        }
        .plan-price small {
            font-size: 0.8rem;
            color: var(--text-muted);
            font-weight: 400;
        }
        .plan-features {
            list-style: none;
            padding: 0;
            margin: 16px 0;
        }
        .plan-features li {
            color: var(--text-gray);
            font-size: 0.85rem;
            padding: 6px 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .plan-features li i { color: var(--accent); font-size: 0.8rem; }

        /* Charts */
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
        }
        .chart-title {
            color: var(--text-white);
            font-weight: 700;
            font-size: 1.1rem;
            margin: 0;
        }

        /* History Table */
        .history-table {
            width: 100%;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            overflow: hidden;
        }
        .history-table table { width: 100%; color: var(--text-gray); min-width: 700px; }
        .history-table th {
            background: rgba(157, 78, 221, 0.08);
            padding: 14px 16px;
            color: var(--text-white);
            font-weight: 600;
            font-size: 0.85rem;
            text-align: left;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .history-table td {
            padding: 14px 16px;
            border-bottom: 1px solid var(--glass-border);
            font-size: 0.9rem;
        }
        .history-table tr:last-child td { border-bottom: none; }
        .history-table tr:hover { background: rgba(255, 255, 255, 0.02); }

        .status-badge {
            padding: 3px 10px;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        .status-completed { background: rgba(0, 255, 178, 0.15); color: var(--accent); }
        .status-pending { background: rgba(255, 215, 0, 0.15); color: var(--gold); }
        .status-failed { background: rgba(255, 59, 92, 0.15); color: #ff3b5c; }

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

        .tab-content { display: none; width: 100%; }
        .tab-content.active { display: block; }

        @media (max-width: 768px) {
            .hashrate-value { font-size: 2rem; }
            .mining-tabs { width: 100%; }
            .mining-tab { flex: 1; text-align: center; padding: 10px 12px; font-size: 0.8rem; }
            .rig-stats { grid-template-columns: repeat(2, 1fr); }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Header -->
    <div class="mining-header" data-aos="fade-up">
        <div>
            <h2><i class="fas fa-microchip me-2" style="color: var(--accent);"></i>Cloud Mining</h2>
            <p class="text-gray mb-0">Enterprise-grade mining infrastructure with guaranteed returns</p>
        </div>
        <a href="#plans" class="btn btn-primary-glow">
            <i class="fas fa-plus me-2"></i> Buy Mining Contract
        </a>
    </div>

    <!-- Tabs -->
    <div class="mining-tabs" data-aos="fade-up">
        <button type="button" class="mining-tab active" data-tab="overview">
            <i class="fas fa-tachometer-alt me-1"></i> Overview
        </button>
        <button type="button" class="mining-tab" data-tab="myrigs">
            <i class="fas fa-server me-1"></i> My Rigs 
            (<asp:Literal ID="litRigCount" runat="server" Text="0"></asp:Literal>)
        </button>
        <button type="button" class="mining-tab" data-tab="plans">
            <i class="fas fa-store me-1"></i> Mining Plans
        </button>
        <button type="button" class="mining-tab" data-tab="history">
            <i class="fas fa-history me-1"></i> Earnings
        </button>
    </div>

    <!-- =========================================
         OVERVIEW TAB
         ========================================= -->
    <div id="tab-overview" class="tab-content active" data-aos="fade-up">
        
        <!-- Mining Stats Hero -->
        <div class="mining-hero">
            <div class="row align-items-center position-relative" style="z-index: 2;">
                <div class="col-lg-6">
                    <div class="mining-stat-label">Total Hashrate</div>
                    <div class="hashrate-display">
                        <span class="hashrate-value">
                            <asp:Literal ID="litTotalHashrate" runat="server" Text="0.00"></asp:Literal>
                        </span>
                        <span class="hashrate-unit">TH/s</span>
                    </div>
                    <div class="text-gray" style="font-size: 1rem;">
                        ≈ <asp:Literal ID="litDailyEarning" runat="server" Text="0.00"></asp:Literal> 
                        <small>PNC / day</small>
                    </div>
                </div>
                <div class="col-lg-6 mt-4 mt-lg-0">
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="mining-stat-card">
                                <div class="mining-stat-label">Active Rigs</div>
                                <div class="mining-stat-value" style="color: var(--accent);">
                                    <asp:Literal ID="litActiveRigs" runat="server" Text="0"></asp:Literal>
                                </div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="mining-stat-card">
                                <div class="mining-stat-label">Total Earned</div>
                                <div class="mining-stat-value" style="color: var(--gold);">
                                    <asp:Literal ID="litTotalEarned" runat="server" Text="0.00"></asp:Literal>
                                </div>
                                <small class="text-muted">PNC</small>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="mining-stat-card">
                                <div class="mining-stat-label">Today's Earnings</div>
                                <div class="mining-stat-value" style="color: var(--accent);">
                                    <asp:Literal ID="litTodayEarnings" runat="server" Text="0.00"></asp:Literal>
                                </div>
                                <small class="text-muted">PNC</small>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="mining-stat-card">
                                <div class="mining-stat-label">Pending Payout</div>
                                <div class="mining-stat-value" style="color: var(--secondary);">
                                    <asp:Literal ID="litPendingPayout" runat="server" Text="0.00"></asp:Literal>
                                </div>
                                <small class="text-muted">PNC</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts -->
        <div class="row g-4 mb-4">
            <div class="col-lg-8" data-aos="fade-up">
                <div class="chart-card">
                    <div class="chart-header">
                        <h5 class="chart-title">
                            <i class="fas fa-chart-area me-2" style="color: var(--accent);"></i>
                            Mining Performance (Last 30 Days)
                        </h5>
                    </div>
                    <div style="height: 280px;">
                        <canvas id="miningChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-lg-4" data-aos="fade-up" data-aos-delay="100">
                <div class="chart-card h-100">
                    <div class="chart-header">
                        <h5 class="chart-title">
                            <i class="fas fa-chart-pie me-2" style="color: var(--gold);"></i>
                            Rig Distribution
                        </h5>
                    </div>
                    <div style="height: 220px;">
                        <canvas id="rigDistChart"></canvas>
                    </div>
                    <div id="rigDistLegend" class="mt-3"></div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="row g-3">
            <div class="col-md-4" data-aos="fade-up">
                <a href="#plans" class="quick-action">
                    <i class="fas fa-shopping-cart"></i>
                    <span>Buy New Contract</span>
                </a>
            </div>
            <div class="col-md-4" data-aos="fade-up" data-aos-delay="100">
                <a href="#" class="quick-action" onclick="switchTab('myrigs'); return false;">
                    <i class="fas fa-server"></i>
                    <span>View My Rigs</span>
                </a>
            </div>
            <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
                <a href="#" class="quick-action" onclick="switchTab('history'); return false;">
                    <i class="fas fa-coins"></i>
                    <span>Claim Earnings</span>
                </a>
            </div>
        </div>
    </div>

    <!-- =========================================
         MY RIGS TAB
         ========================================= -->
    <div id="tab-myrigs" class="tab-content" data-aos="fade-up">
        
        <asp:Repeater ID="rptRigs" runat="server">
            <ItemTemplate>
                <div class='rig-card <%# GetRigStatusClass(Eval("Status")) %>'>
                    <div class="rig-header">
                        <div class="rig-info">
                            <div class="rig-icon">
                                <i class='<%# GetRigIcon(Eval("PlanName")) %>'></i>
                            </div>
                            <div>
                                <div class="rig-name"><%# Eval("PlanName") %></div>
                                <div class="rig-id">
                                    Rig #<%# Eval("MiningContractId") %> · 
                                    Started <%# Convert.ToDateTime(Eval("StartDate")).ToString("MMM dd, yyyy") %>
                                </div>
                            </div>
                        </div>
                        <span class='rig-status <%# GetRigStatusClass(Eval("Status")) %>'>
                            <%# GetRigStatusName(Eval("Status")) %>
                        </span>
                    </div>

                    <div class="rig-stats">
                        <div class="rig-stat">
                            <div class="label">Hashrate</div>
                            <div class="value accent"><%# string.Format("{0:0.##}", Eval("Hashrate")) %> TH/s</div>
                        </div>
                        <div class="rig-stat">
                            <div class="label">Power</div>
                            <div class="value"><%# Eval("PowerConsumption") %> W</div>
                        </div>
                        <div class="rig-stat">
                            <div class="label">Daily Output</div>
                            <div class="value gold"><%# string.Format("{0:0.####}", Eval("DailyOutput")) %> PNC</div>
                        </div>
                        <div class="rig-stat">
                            <div class="label">Total Earned</div>
                            <div class="value accent"><%# string.Format("{0:0.####}", Eval("TotalEarned")) %> PNC</div>
                        </div>
                        <div class="rig-stat">
                            <div class="label">Progress</div>
                            <div class="value"><%# Eval("ProgressPercent") %>%</div>
                        </div>
                        <div class="rig-stat">
                            <div class="label">Expires</div>
                            <div class="value"><%# Convert.ToDateTime(Eval("EndDate")).ToString("MMM dd, yyyy") %></div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between align-items-center mt-3 flex-wrap gap-2">
                        <div style="flex: 1; min-width: 200px;">
                            <div class="d-flex justify-content-between mb-1">
                                <small class="text-muted">Contract Progress</small>
                                <small class="text-accent"><%# Eval("DaysElapsed") %> / <%# Eval("ContractDays") %> days</small>
                            </div>
                            <div class="progress-bar-mining">
                                <div class="progress-fill-mining" style="width: <%# Eval("ProgressPercent") %>%;"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoRigs" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-server"></i>
                <h4>No Active Mining Rigs</h4>
                <p>Purchase a mining contract to start earning passive income.</p>
                <a href="#plans" class="btn btn-primary-glow" onclick="switchTab('plans'); return false;">
                    <i class="fas fa-shopping-cart me-2"></i> Browse Mining Plans
                </a>
            </div>
        </asp:Panel>
    </div>

    <!-- =========================================
         MINING PLANS TAB
         ========================================= -->
    <div id="tab-plans" class="tab-content" data-aos="fade-up">
        
        <div class="info-card" style="background: rgba(157, 78, 221, 0.05); border: 1px solid rgba(157, 78, 221, 0.2); border-radius: var(--radius-md); padding: 16px; margin-bottom: 24px; display: flex; gap: 12px;">
            <i class="fas fa-info-circle" style="color: var(--secondary); font-size: 1.2rem; margin-top: 2px;"></i>
            <div>
                <div style="color: var(--text-white); font-weight: 600; font-size: 0.9rem; margin-bottom: 4px;">Enterprise-Grade Mining Infrastructure</div>
                <div style="color: var(--text-gray); font-size: 0.85rem;">All mining contracts are backed by real hardware in our Tier-4 data centers. Earnings are distributed daily to your wallet.</div>
            </div>
        </div>

        <div class="row g-4">
            <asp:Repeater ID="rptPlans" runat="server">
                <ItemTemplate>
                    <div class="col-md-6 col-lg-4" data-aos="fade-up">
                        <div class='plan-card <%# Convert.ToBoolean(Eval("IsPopular")) ? "featured" : "" %>'>
                            <h5 class="text-white mb-0"><%# Eval("PlanName") %></h5>
                            <div class="plan-hashrate">
                                <%# string.Format("{0:0.##}", Eval("Hashrate")) %>
                                <small>TH/s</small>
                            </div>
                            <div class="plan-price">
                                $<%# string.Format("{0:0.00}", Eval("Price")) %>
                                <small>/ contract</small>
                            </div>
                            <ul class="plan-features">
                                <li><i class="fas fa-check"></i> Duration: <%# Eval("ContractDays") %> Days</li>
                                <li><i class="fas fa-check"></i> Daily Output: <%# string.Format("{0:0.####}", Eval("DailyOutput")) %> PNC</li>
                                <li><i class="fas fa-check"></i> Power: <%# Eval("PowerConsumption") %> W</li>
                                <li><i class="fas fa-check"></i> Maintenance Fee: Included</li>
                                <li><i class="fas fa-check"></i> 24/7 Monitoring</li>
                            </ul>
                            <a href='<%# ResolveUrl("~/Web/User/BuyMining.aspx?planId=" + Eval("MiningPlanId")) %>' class="btn btn-primary-glow w-100">
                                <i class="fas fa-bolt me-2"></i> Purchase Now
                            </a>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnlNoPlans" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-store"></i>
                <h4>No Plans Available</h4>
                <p>Check back soon for new mining contracts.</p>
            </div>
        </asp:Panel>
    </div>

    <!-- =========================================
         EARNINGS HISTORY TAB
         ========================================= -->
    <div id="tab-history" class="tab-content" data-aos="fade-up">
        
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="mining-stat-card">
                    <div class="mining-stat-label">Lifetime Earnings</div>
                    <div class="mining-stat-value" style="color: var(--accent);">
                        <asp:Literal ID="litLifetimeEarnings" runat="server" Text="0.00"></asp:Literal>
                    </div>
                    <small class="text-muted">PNC</small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="mining-stat-card">
                    <div class="mining-stat-label">This Month</div>
                    <div class="mining-stat-value" style="color: var(--gold);">
                        <asp:Literal ID="litMonthEarnings" runat="server" Text="0.00"></asp:Literal>
                    </div>
                    <small class="text-muted">PNC</small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="mining-stat-card">
                    <div class="mining-stat-label">Total Payouts</div>
                    <div class="mining-stat-value" style="color: var(--secondary);">
                        <asp:Literal ID="litTotalPayouts" runat="server" Text="0"></asp:Literal>
                    </div>
                    <small class="text-muted">Transactions</small>
                </div>
            </div>
        </div>

        <div class="history-table">
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Rig</th>
                            <th>Hashrate</th>
                            <th>Output</th>
                            <th>Status</th>
                            <th>TxHash</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptEarnings" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td class="text-muted"><%# Convert.ToDateTime(Eval("EarnedDate")).ToString("MMM dd, yyyy HH:mm") %></td>
                                    <td class="text-white"><%# Eval("PlanName") %></td>
                                    <td><%# string.Format("{0:0.##}", Eval("Hashrate")) %> TH/s</td>
                                    <td class="text-accent fw-bold">+<%# string.Format("{0:0.####}", Eval("Amount")) %> PNC</td>
                                    <td>
                                        <span class='status-badge <%# GetEarningStatusClass(Eval("Status")) %>'>
                                            <%# Eval("StatusName") %>
                                        </span>
                                    </td>
                                    <td>
                                        <small class="text-secondary" style="font-family: monospace;">
                                            <%# GetTxHashShort(Eval("TxHash")) %>
                                        </small>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>

        <asp:Panel ID="pnlNoEarnings" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-coins"></i>
                <h4>No Earnings Yet</h4>
                <p>Your mining earnings will appear here once your rigs start producing.</p>
            </div>
        </asp:Panel>
    </div>

    <asp:HiddenField ID="hfActiveTab" runat="server" Value="overview" />

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        function switchTab(tabName) {
            document.querySelectorAll('.mining-tab').forEach(t => t.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
            
            var targetTab = document.querySelector('[data-tab="' + tabName + '"]');
            var targetContent = document.getElementById('tab-' + tabName);
            
            if (targetTab) targetTab.classList.add('active');
            if (targetContent) targetContent.classList.add('active');
            
            document.getElementById('<%= hfActiveTab.ClientID %>').value = tabName;
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        document.addEventListener('DOMContentLoaded', function() {
            // Tab switching
            document.querySelectorAll('.mining-tab').forEach(function(tab) {
                tab.addEventListener('click', function(e) {
                    e.preventDefault();
                    switchTab(this.getAttribute('data-tab'));
                });
            });

            // Check URL hash or saved tab
            var hash = window.location.hash.replace('#', '');
            var savedTab = document.getElementById('<%= hfActiveTab.ClientID %>').value;
            if (hash && document.getElementById('tab-' + hash)) {
                switchTab(hash);
            } else if (savedTab && savedTab !== 'overview') {
                switchTab(savedTab);
            }

            // Mining Performance Chart
            try {
                var chartData = <%= GetMiningChartData() %>;
                var ctx = document.getElementById('miningChart');
                if (ctx && chartData.labels && chartData.labels.length > 0 && typeof Chart !== 'undefined') {
                    new Chart(ctx, {
                        type: 'line',
                        data: {
                            labels: chartData.labels,
                            datasets: [{
                                label: 'Daily Earnings (PNC)',
                                data: chartData.values,
                                borderColor: '#C77DFF',
                                backgroundColor: 'rgba(199, 125, 255, 0.1)',
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
                                    backgroundColor: 'rgba(10, 4, 20, 0.95)',
                                    borderColor: '#C77DFF',
                                    borderWidth: 1,
                                    callbacks: {
                                        label: function(ctx) { return ctx.parsed.y.toFixed(4) + ' PNC'; }
                                    }
                                }
                            },
                            scales: {
                                y: {
                                    grid: { color: 'rgba(255,255,255,0.05)' },
                                    ticks: { color: '#6D5A85', callback: function(v) { return v.toFixed(2); } }
                                },
                                x: { grid: { display: false }, ticks: { color: '#6D5A85' } }
                            }
                        }
                    });
                }
            } catch (e) { console.error('Mining chart error:', e); }

            // Rig Distribution Chart
            try {
                var distData = <%= GetRigDistributionData() %>;
                var distCtx = document.getElementById('rigDistChart');
                if (distCtx && distData.labels && distData.labels.length > 0 && typeof Chart !== 'undefined') {
                    new Chart(distCtx, {
                        type: 'doughnut',
                        data: {
                            labels: distData.labels,
                            datasets: [{
                                data: distData.values,
                                backgroundColor: distData.colors,
                                borderColor: 'rgba(10, 4, 20, 0.8)',
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

                    var legendHtml = '';
                    for (var i = 0; i < distData.labels.length; i++) {
                        legendHtml += '<div class="d-flex align-items-center gap-2 mb-1">' +
                            '<span style="width: 10px; height: 10px; border-radius: 50%; background: ' + distData.colors[i] + '; display: inline-block;"></span>' +
                            '<span class="text-gray small flex-grow-1">' + distData.labels[i] + '</span>' +
                            '<span class="text-white small fw-bold">' + distData.values[i].toFixed(2) + ' TH/s</span>' +
                            '</div>';
                    }
                    document.getElementById('rigDistLegend').innerHTML = legendHtml;
                }
            } catch (e) { console.error('Rig distribution error:', e); }
        });
    </script>
</asp:Content>