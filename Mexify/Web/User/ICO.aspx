<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="ICO.aspx.cs" Inherits="Mexify.Web.User.ICO" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .ico-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            flex-wrap: wrap;
            gap: 16px;
        }
        .ico-header h2 { color: var(--text-white); margin: 0; font-size: 1.8rem; }

        .ico-tabs {
            display: flex;
            gap: 4px;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 50px;
            padding: 4px;
            margin-bottom: 28px;
            width: fit-content;
        }
        .ico-tab {
            padding: 10px 24px;
            border-radius: 50px;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-gray);
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            background: transparent;
        }
        .ico-tab.active {
            background: linear-gradient(135deg, #ff6b6b, #ff3b5c);
            color: var(--text-white);
            box-shadow: 0 4px 12px rgba(255, 59, 92, 0.3);
        }
        .ico-tab:hover:not(.active) {
            background: rgba(255, 255, 255, 0.05);
            color: var(--text-white);
        }

        .ico-summary {
            background: linear-gradient(135deg, rgba(255, 59, 92, 0.15), rgba(255, 107, 107, 0.1));
            border: 1px solid rgba(255, 59, 92, 0.3);
            border-radius: var(--radius-xl);
            padding: 40px;
            position: relative;
            overflow: hidden;
            margin-bottom: 32px;
        }
        .ico-summary::before {
            content: '';
            position: absolute;
            top: -50%; right: -10%;
            width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(255, 59, 92, 0.15) 0%, transparent 70%);
            animation: float 15s ease-in-out infinite;
        }
        @keyframes float {
            0%,100%{transform:translate(0,0) scale(1)}
            50%{transform:translate(20px,-20px) scale(1.1)}
        }

        .summary-label {
            color: var(--text-gray);
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            margin-bottom: 8px;
        }
        .summary-value {
            font-size: 3rem;
            font-weight: 800;
            color: var(--text-white);
            font-family: 'Space Grotesk', sans-serif;
            margin-bottom: 4px;
        }
        .summary-value small { font-size: 1.2rem; color: var(--text-gray); }

        .project-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            overflow: hidden;
            transition: all 0.3s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        .project-card:hover {
            transform: translateY(-5px);
            border-color: #ff3b5c;
            box-shadow: 0 15px 40px rgba(255, 59, 92, 0.2);
        }
        .project-card.featured {
            border-color: var(--gold);
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.05), rgba(255, 59, 92, 0.05));
        }
        .project-image-wrap {
            position: relative;
            width: 100%;
            padding-top: 56.25%;
            overflow: hidden;
            background: linear-gradient(135deg, rgba(255, 59, 92, 0.1), rgba(255, 107, 107, 0.05));
        }
        .project-image {
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        .project-card:hover .project-image {
            transform: scale(1.05);
        }
        .project-status-badge {
            position: absolute;
            top: 12px; left: 12px;
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            backdrop-filter: blur(10px);
        }
        .status-live { background: rgba(0, 255, 178, 0.9); color: #000; }
        .status-upcoming { background: rgba(0, 212, 255, 0.9); color: #000; }
        .status-ended { background: rgba(107, 117, 141, 0.9); color: #fff; }
        .status-hot {
            position: absolute;
            top: 12px; right: 12px;
            padding: 4px 10px;
            background: rgba(255, 59, 92, 0.9);
            color: #fff;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 700;
            backdrop-filter: blur(10px);
        }
        .project-body {
            padding: 20px;
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        .project-title {
            color: var(--text-white);
            font-weight: 700;
            font-size: 1.1rem;
            margin-bottom: 4px;
        }
        .project-category {
            color: var(--text-muted);
            font-size: 0.8rem;
            margin-bottom: 16px;
        }
        .project-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-bottom: 16px;
        }
        .project-stat {
            text-align: center;
            padding: 10px;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 8px;
        }
        .project-stat .label {
            font-size: 0.65rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }
        .project-stat .value {
            font-size: 0.95rem;
            font-weight: 700;
            color: var(--text-white);
        }
        .project-stat .value.accent { color: var(--accent); }
        .project-stat .value.gold { color: var(--gold); }

        .funding-progress {
            margin-bottom: 16px;
        }
        .funding-progress-header {
            display: flex;
            justify-content: space-between;
            font-size: 0.8rem;
            margin-bottom: 6px;
        }
        .funding-progress-header .label { color: var(--text-muted); }
        .funding-progress-header .value { color: var(--text-white); font-weight: 600; }
        .progress-bar-funding {
            height: 8px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50px;
            overflow: hidden;
        }
        .progress-fill-funding {
            height: 100%;
            background: linear-gradient(90deg, #ff6b6b, #ff3b5c);
            border-radius: 50px;
            transition: width 1s ease;
            position: relative;
        }
        .progress-fill-funding::after {
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

        .countdown-timer {
            display: inline-flex;
            gap: 8px;
            padding: 8px 14px;
            background: rgba(255, 59, 92, 0.08);
            border: 1px solid rgba(255, 59, 92, 0.2);
            border-radius: var(--radius-sm);
            margin-bottom: 16px;
        }
        .countdown-unit { text-align: center; min-width: 40px; }
        .countdown-unit .value {
            display: block;
            color: #ff3b5c;
            font-size: 1.1rem;
            font-weight: 800;
        }
        .countdown-unit .label {
            font-size: 0.65rem;
            color: var(--text-muted);
            text-transform: uppercase;
        }

        .participation-card {
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
        .participation-card:hover {
            border-color: #ff3b5c;
            transform: translateX(4px);
        }
        .participation-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0;
            width: 4px; height: 100%;
            background: linear-gradient(180deg, #ff6b6b, #ff3b5c);
        }
        .participation-card.vested::before {
            background: linear-gradient(180deg, var(--gold), #FFA500);
        }

        .participation-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 16px;
            flex-wrap: wrap;
            gap: 12px;
        }
        .participation-info { display: flex; align-items: center; gap: 14px; }
        .participation-icon {
            width: 52px; height: 52px;
            border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.4rem;
            background: linear-gradient(135deg, rgba(255, 59, 92, 0.2), rgba(255, 107, 107, 0.1));
            color: #ff3b5c;
            border: 1px solid rgba(255, 59, 92, 0.3);
            flex-shrink: 0;
        }
        .participation-name { color: var(--text-white); font-weight: 600; font-size: 1rem; margin-bottom: 2px; }
        .participation-meta { color: var(--text-muted); font-size: 0.8rem; }
        .participation-amount { text-align: right; }
        .participation-amount-value { color: var(--text-white); font-weight: 700; font-size: 1.3rem; }
        .participation-tokens { color: #ff3b5c; font-size: 0.85rem; font-weight: 600; }

        .participation-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 12px;
            padding: 16px 0;
            border-top: 1px solid var(--glass-border);
            border-bottom: 1px solid var(--glass-border);
        }
        .participation-detail { text-align: center; }
        .participation-detail .label {
            color: var(--text-muted);
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }
        .participation-detail .value {
            color: var(--text-white);
            font-weight: 600;
            font-size: 0.9rem;
        }
        .participation-detail .value.accent { color: var(--accent); }
        .participation-detail .value.gold { color: var(--gold); }

        .vesting-schedule {
            margin-top: 16px;
        }
        .vesting-title {
            color: var(--text-white);
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 12px;
        }
        .vesting-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 12px;
            background: rgba(255, 255, 255, 0.02);
            border-radius: 8px;
            margin-bottom: 8px;
            border-left: 3px solid var(--glass-border);
        }
        .vesting-item.released { border-left-color: var(--accent); }
        .vesting-item.pending { border-left-color: var(--gold); }
        .vesting-item-info { flex: 1; }
        .vesting-item-date { color: var(--text-white); font-weight: 600; font-size: 0.85rem; }
        .vesting-item-percent { color: var(--text-muted); font-size: 0.75rem; }
        .vesting-item-amount {
            color: var(--text-white);
            font-weight: 700;
            font-size: 0.9rem;
        }
        .vesting-item-status {
            padding: 2px 8px;
            border-radius: 50px;
            font-size: 0.65rem;
            font-weight: 600;
            text-transform: uppercase;
            margin-left: 8px;
        }
        .vesting-status-released { background: rgba(0, 255, 178, 0.15); color: var(--accent); }
        .vesting-status-pending { background: rgba(255, 215, 0, 0.15); color: var(--gold); }

        .participation-actions {
            display: flex;
            gap: 8px;
            margin-top: 16px;
            flex-wrap: wrap;
        }
        .participation-btn {
            padding: 8px 16px;
            border-radius: 50px;
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 1px solid var(--glass-border);
            background: transparent;
            color: var(--text-gray);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .participation-btn:hover {
            background: rgba(255, 59, 92, 0.1);
            color: #ff3b5c;
            border-color: #ff3b5c;
        }
        .participation-btn.primary {
            background: linear-gradient(135deg, #ff6b6b, #ff3b5c);
            color: var(--text-white);
            border-color: transparent;
        }
        .participation-btn.gold {
            background: linear-gradient(135deg, var(--gold), #FFA500);
            color: #000;
            border-color: transparent;
        }

        .stat-card-mini {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-md);
            padding: 16px;
            text-align: center;
        }
        .stat-card-mini .value {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--text-white);
            font-family: 'Space Grotesk', sans-serif;
        }
        .stat-card-mini .label {
            font-size: 0.7rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

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

        .token-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 0;
            border-bottom: 1px solid var(--glass-border);
        }
        .token-item:last-child { border-bottom: none; }
        .token-icon {
            width: 38px; height: 38px;
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            background: rgba(255, 59, 92, 0.15);
            color: #ff3b5c;
            flex-shrink: 0;
        }
        .token-info { flex: 1; min-width: 0; }
        .token-title { color: var(--text-white); font-weight: 600; font-size: 0.85rem; margin-bottom: 2px; }
        .token-date { color: var(--text-muted); font-size: 0.7rem; }
        .token-amount { color: #ff3b5c; font-weight: 700; font-size: 0.9rem; }

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

        .history-table {
            width: 100%;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            overflow: hidden;
        }
        .history-table table { width: 100%; color: var(--text-gray); }
        .history-table th {
            background: rgba(255, 59, 92, 0.08);
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
        .status-active { background: rgba(0, 255, 178, 0.15); color: var(--accent); }
        .status-completed { background: rgba(0, 212, 255, 0.15); color: var(--secondary); }
        .status-refunded { background: rgba(255, 59, 92, 0.15); color: #ff3b5c; }
        .status-vesting { background: rgba(255, 215, 0, 0.15); color: var(--gold); }

        @media (max-width: 768px) {
            .summary-value { font-size: 2rem; }
            .participation-details { grid-template-columns: repeat(2, 1fr); }
            .countdown-timer { width: 100%; justify-content: center; }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Header -->
    <div class="ico-header" data-aos="fade-up">
        <div>
            <h2>ICO Launchpad</h2>
            <p class="text-gray mb-0">Participate in early-stage token sales</p>
        </div>
        <a href="<%= ResolveUrl("~/ico.aspx") %>" class="btn btn-primary-glow">
            <i class="fas fa-compass me-2"></i> Browse Projects
        </a>
    </div>

    <!-- Tabs -->
    <div class="ico-tabs" data-aos="fade-up">
        <button class="ico-tab active" data-tab="overview">
            <i class="fas fa-chart-pie me-1"></i> Overview
        </button>
        <button class="ico-tab" data-tab="active">
            <i class="fas fa-rocket me-1"></i>
            Active (<asp:Literal ID="litActiveCount" runat="server" Text="0"></asp:Literal>)
        </button>
        <button class="ico-tab" data-tab="participations">
            <i class="fas fa-hand-holding-usd me-1"></i>
            My Participations (<asp:Literal ID="litParticipationCount" runat="server" Text="0"></asp:Literal>)
        </button>
        <button class="ico-tab" data-tab="history">
            <i class="fas fa-history me-1"></i> Token History
        </button>
    </div>

    <!-- OVERVIEW TAB -->
    <div id="tab-overview" class="tab-content" data-aos="fade-up">
        
        <!-- Summary Card -->
        <div class="ico-summary">
            <div class="row align-items-center position-relative" style="z-index: 2;">
                <div class="col-lg-6">
                    <div class="summary-label">Total ICO Investment</div>
                    <div class="summary-value">
                        <asp:Literal ID="litTotalInvested" runat="server" Text="0.00"></asp:Literal>
                        <small> PNC</small>
                    </div>
                    <div style="color: var(--text-gray); font-size: 1.1rem;">
                        ≈ $<asp:Literal ID="litTotalUSD" runat="server" Text="0.00"></asp:Literal> USD
                    </div>
                </div>
                <div class="col-lg-6 mt-3 mt-lg-0">
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="stat-card-mini">
                                <div class="value" style="color: #ff3b5c;">
                                    <asp:Literal ID="litTotalParticipations" runat="server" Text="0"></asp:Literal>
                                </div>
                                <div class="label">Participations</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stat-card-mini">
                                <div class="value" style="color: var(--accent);">
                                    <asp:Literal ID="litTokensReceived" runat="server" Text="0"></asp:Literal>
                                </div>
                                <div class="label">Tokens Received</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stat-card-mini">
                                <div class="value" style="color: var(--gold);">
                                    <asp:Literal ID="litTokensVesting" runat="server" Text="0"></asp:Literal>
                                </div>
                                <div class="label">Tokens Vesting</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stat-card-mini">
                                <div class="value" style="color: var(--secondary);">
                                    <asp:Literal ID="litCurrentROI" runat="server" Text="0.00"></asp:Literal>%
                                </div>
                                <div class="label">Current ROI</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts Row -->
        <div class="row g-4 mb-4">
            <div class="col-lg-8" data-aos="fade-up">
                <div class="chart-card">
                    <div class="chart-header">
                        <h5 class="chart-title">ICO Investment Performance</h5>
                    </div>
                    <div style="height: 280px;">
                        <canvas id="performanceChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-lg-4" data-aos="fade-up" data-aos-delay="100">
                <div class="chart-card h-100">
                    <div class="chart-header">
                        <h5 class="chart-title">Portfolio Distribution</h5>
                    </div>
                    <div style="height: 220px;">
                        <canvas id="distributionChart"></canvas>
                    </div>
                    <div id="distributionLegend" class="mt-3"></div>
                </div>
            </div>
        </div>

        <!-- Active Projects Preview -->
        <h4 class="text-white mb-3" data-aos="fade-up">
            <i class="fas fa-rocket" style="color: #ff3b5c;"></i>
            Live ICO Projects
        </h4>
        <div class="row g-4">
            <asp:Repeater ID="rptLiveProjects" runat="server">
                <ItemTemplate>
                    <div class="col-md-6 col-lg-4" data-aos="fade-up">
                        <div class='project-card <%# Convert.ToBoolean(Eval("IsHot")) ? "featured" : "" %>'>
                            <div class="project-image-wrap">
                                <img src='<%# Eval("ImageUrl") %>' 
                                     alt='<%# Eval("ProjectName") %>' 
                                     class="project-image"
                                     onerror="this.src='https://via.placeholder.com/400x225/ff3b5c/FFFFFF?text=ICO'">
                                <span class='project-status-badge status-live'>● LIVE</span>
                                <%# Convert.ToBoolean(Eval("IsHot")) ? "<span class='status-hot'>🔥 HOT</span>" : "" %>
                            </div>
                            <div class="project-body">
                                <div class="project-title"><%# Eval("ProjectName") %></div>
                                <div class="project-category"><%# Eval("Category") %></div>
                                
                                <div class="funding-progress">
                                    <div class="funding-progress-header">
                                        <span class="label">Raised</span>
                                        <span class="value"><%# Eval("FundingPercent") %>%</span>
                                    </div>
                                    <div class="progress-bar-funding">
                                        <div class="progress-fill-funding" style="width: <%# Eval("FundingPercent") %>%;"></div>
                                    </div>
                                    <div class="d-flex justify-content-between mt-1">
                                        <small class="text-muted"><%# string.Format("{0:0.##}", Eval("RaisedAmount")) %> PNC</small>
                                        <small class="text-muted">Goal: <%# string.Format("{0:0.##}", Eval("HardCap")) %> PNC</small>
                                    </div>
                                </div>

                                <div class="countdown-timer" data-end='<%# Eval("EndDateIso") %>'>
                                    <div class="countdown-unit">
                                        <span class="value cd-days">00</span>
                                        <span class="label">Days</span>
                                    </div>
                                    <div class="countdown-unit">
                                        <span class="value cd-hours">00</span>
                                        <span class="label">Hours</span>
                                    </div>
                                    <div class="countdown-unit">
                                        <span class="value cd-mins">00</span>
                                        <span class="label">Mins</span>
                                    </div>
                                    <div class="countdown-unit">
                                        <span class="value cd-secs">00</span>
                                        <span class="label">Secs</span>
                                    </div>
                                </div>

                                <a href='<%# ResolveUrl("~/User/ParticipateICO.aspx?id=" + Eval("ICOProjectId")) %>' class="btn btn-primary-glow w-100">
                                    <i class="fas fa-bolt me-2"></i> Participate Now
                                </a>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>

    <!-- ACTIVE PROJECTS TAB -->
    <div id="tab-active" class="tab-content" style="display: none;" data-aos="fade-up">
        <div class="row g-4">
            <asp:Repeater ID="rptActiveProjects" runat="server">
                <ItemTemplate>
                    <div class="col-md-6 col-lg-4" data-aos="fade-up">
                        <div class='project-card <%# Convert.ToBoolean(Eval("IsHot")) ? "featured" : "" %>'>
                            <div class="project-image-wrap">
                                <img src='<%# Eval("ImageUrl") %>' 
                                     alt='<%# Eval("ProjectName") %>' 
                                     class="project-image"
                                     onerror="this.src='https://via.placeholder.com/400x225/ff3b5c/FFFFFF?text=ICO'">
                                <span class='project-status-badge <%# Eval("StatusClass") %>'>
                                    <%# Eval("StatusName") %>
                                </span>
                                <%# Convert.ToBoolean(Eval("IsHot")) ? "<span class='status-hot'>🔥 HOT</span>" : "" %>
                            </div>
                            <div class="project-body">
                                <div class="project-title"><%# Eval("ProjectName") %></div>
                                <div class="project-category"><%# Eval("Category") %></div>
                                
                                <div class="project-stats">
                                    <div class="project-stat">
                                        <div class="label">Token Price</div>
                                        <div class="value accent"><%# string.Format("{0:0.####}", Eval("TokenPrice")) %> PNC</div>
                                    </div>
                                    <div class="project-stat">
                                        <div class="label">Total Supply</div>
                                        <div class="value"><%# Eval("TotalSupplyFormatted") %></div>
                                    </div>
                                    <div class="project-stat">
                                        <div class="label">Min Investment</div>
                                        <div class="value gold"><%# string.Format("{0:0}", Eval("MinInvestment")) %> PNC</div>
                                    </div>
                                    <div class="project-stat">
                                        <div class="label">Vesting</div>
                                        <div class="value"><%# Eval("VestingPeriod") %></div>
                                    </div>
                                </div>

                                <div class="funding-progress">
                                    <div class="funding-progress-header">
                                        <span class="label">Funding Progress</span>
                                        <span class="value"><%# Eval("FundingPercent") %>%</span>
                                    </div>
                                    <div class="progress-bar-funding">
                                        <div class="progress-fill-funding" style="width: <%# Eval("FundingPercent") %>%;"></div>
                                    </div>
                                    <div class="d-flex justify-content-between mt-1">
                                        <small class="text-muted"><%# string.Format("{0:0.##}", Eval("RaisedAmount")) %> PNC</small>
                                        <small class="text-muted">Goal: <%# string.Format("{0:0.##}", Eval("HardCap")) %> PNC</small>
                                    </div>
                                </div>

                                <div class="countdown-timer" data-end='<%# Eval("EndDateIso") %>'>
                                    <div class="countdown-unit">
                                        <span class="value cd-days">00</span>
                                        <span class="label">Days</span>
                                    </div>
                                    <div class="countdown-unit">
                                        <span class="value cd-hours">00</span>
                                        <span class="label">Hours</span>
                                    </div>
                                    <div class="countdown-unit">
                                        <span class="value cd-mins">00</span>
                                        <span class="label">Mins</span>
                                    </div>
                                    <div class="countdown-unit">
                                        <span class="value cd-secs">00</span>
                                        <span class="label">Secs</span>
                                    </div>
                                </div>

                                <a href='<%# ResolveUrl("~/User/ParticipateICO.aspx?id=" + Eval("ICOProjectId")) %>' class="btn btn-primary-glow w-100">
                                    <i class="fas fa-bolt me-2"></i> Participate Now
                                </a>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnlNoActive" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-rocket"></i>
                <h4>No Active ICO Projects</h4>
                <p>Check back soon for new token sale opportunities.</p>
            </div>
        </asp:Panel>
    </div>

    <!-- PARTICIPATIONS TAB -->
    <div id="tab-participations" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <asp:Repeater ID="rptParticipations" runat="server">
            <ItemTemplate>
                <div class="participation-card">
                    <div class="participation-header">
                        <div class="participation-info">
                            <div class="participation-icon">
                                <i class="fas fa-rocket"></i>
                            </div>
                            <div>
                                <div class="participation-name"><%# Eval("ProjectName") %></div>
                                <div class="participation-meta">
                                    Participation #<%# Eval("ParticipationId") %> · 
                                    Joined <%# Convert.ToDateTime(Eval("ParticipatedDate")).ToString("MMM dd, yyyy") %>
                                </div>
                            </div>
                        </div>
                        <div class="participation-amount">
                            <div class="participation-amount-value">
                                <%# string.Format("{0:0.##}", Eval("InvestedAmount")) %> PNC
                            </div>
                            <div class="participation-tokens">
                                <%# string.Format("{0:0.##}", Eval("TokensAllocated")) %> <%# Eval("TokenSymbol") %>
                            </div>
                        </div>
                    </div>

                    <div class="participation-details">
                        <div class="participation-detail">
                            <div class="label">Token Price</div>
                            <div class="value accent"><%# string.Format("{0:0.####}", Eval("TokenPrice")) %> PNC</div>
                        </div>
                        <div class="participation-detail">
                            <div class="label">Tokens Released</div>
                            <div class="value accent"><%# string.Format("{0:0.##}", Eval("TokensReleased")) %></div>
                        </div>
                        <div class="participation-detail">
                            <div class="label">Tokens Vesting</div>
                            <div class="value gold"><%# string.Format("{0:0.##}", Eval("TokensVesting")) %></div>
                        </div>
                        <div class="participation-detail">
                            <div class="label">Current Value</div>
                            <div class="value"><%# string.Format("{0:0.##}", Eval("CurrentValue")) %> PNC</div>
                        </div>
                    </div>

                    <!-- Vesting Schedule -->
                    <div class="vesting-schedule">
                        <div class="vesting-title">
                            <i class="fas fa-clock text-gold me-2"></i>
                            Vesting Schedule
                        </div>
                        <asp:Repeater ID="rptVesting" runat="server" DataSource='<%# Eval("VestingSchedule") %>'>
                            <ItemTemplate>
                                <div class='vesting-item <%# Convert.ToBoolean(Eval("IsReleased")) ? "released" : "pending" %>'>
                                    <div class="vesting-item-info">
                                        <div class="vesting-item-date">
                                            <%# Convert.ToDateTime(Eval("ReleaseDate")).ToString("MMM dd, yyyy") %>
                                        </div>
                                        <div class="vesting-item-percent"><%# Eval("ReleasePercent") %>% of allocation</div>
                                    </div>
                                    <div class="vesting-item-amount">
                                        <%# string.Format("{0:0.##}", Eval("ReleaseAmount")) %>
                                    </div>
                                    <span class='vesting-item-status <%# Convert.ToBoolean(Eval("IsReleased")) ? "vesting-status-released" : "vesting-status-pending" %>'>
                                        <%# Convert.ToBoolean(Eval("IsReleased")) ? "Released" : "Pending" %>
                                    </span>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                    <div class="participation-actions">
                        <a href='<%# ResolveUrl("~/User/ICODetails.aspx?id=" + Eval("ParticipationId")) %>' class="participation-btn">
                            <i class="fas fa-eye"></i> View Details
                        </a>
                        <asp:Panel runat="server" Visible='<%# HasClaimableTokens(Eval("TokensVesting")) %>'>
                            <a href='<%# ResolveUrl("~/User/ClaimICOTokens.aspx?id=" + Eval("ParticipationId")) %>' class="participation-btn gold">
                                <i class="fas fa-gift"></i> Claim Tokens
                            </a>
                        </asp:Panel>
                        <span class='status-badge <%# GetStatusClass(Eval("Status")) %>'>
                            <%# Eval("StatusName") %>
                        </span>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoParticipations" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-hand-holding-usd"></i>
                <h4>No Participations Yet</h4>
                <p>Join an active ICO to get early access to promising blockchain projects.</p>
                <a href="<%= ResolveUrl("~/ico.aspx") %>" class="btn btn-primary-glow">
                    <i class="fas fa-rocket me-2"></i> Browse ICO Projects
                </a>
            </div>
        </asp:Panel>
    </div>

    <!-- HISTORY TAB -->
    <div id="tab-history" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="stat-card-mini" style="padding: 24px;">
                    <div class="summary-label">Total Tokens Received</div>
                    <div style="font-size: 2rem; font-weight: 800; color: var(--accent);">
                        <asp:Literal ID="litTotalTokensReceived" runat="server" Text="0"></asp:Literal>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card-mini" style="padding: 24px;">
                    <div class="summary-label">Total Tokens Claimed</div>
                    <div style="font-size: 2rem; font-weight: 800; color: var(--gold);">
                        <asp:Literal ID="litTotalTokensClaimed" runat="server" Text="0"></asp:Literal>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card-mini" style="padding: 24px;">
                    <div class="summary-label">Total Refunded</div>
                    <div style="font-size: 2rem; font-weight: 800; color: #ff3b5c;">
                        <asp:Literal ID="litTotalRefunded" runat="server" Text="0.00"></asp:Literal> PNC
                    </div>
                </div>
            </div>
        </div>

        <div class="chart-card">
            <div class="chart-header">
                <h5 class="chart-title">
                    <i class="fas fa-coins" style="color: #ff3b5c;"></i>
                    Token Distribution History
                </h5>
            </div>
            <asp:Repeater ID="rptTokenHistory" runat="server">
                <ItemTemplate>
                    <div class="token-item">
                        <div class="token-icon">
                            <i class="fas fa-coins"></i>
                        </div>
                        <div class="token-info">
                            <div class="token-title">
                                <%# Eval("ProjectName") %> - <%# Eval("TokenType") %>
                            </div>
                            <div class="token-date">
                                <%# Convert.ToDateTime(Eval("DistributedDate")).ToString("MMM dd, yyyy 'at' hh:mm tt") %>
                            </div>
                        </div>
                        <div class="token-amount">
                            +<%# string.Format("{0:0.##}", Eval("Amount")) %> <%# Eval("TokenSymbol") %>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoHistory" runat="server" Visible="false">
                <div class="empty-state">
                    <i class="fas fa-history"></i>
                    <h4>No Token History</h4>
                    <p>Your token distributions will appear here once ICO projects complete.</p>
                </div>
            </asp:Panel>
        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Tab switching
            var tabs = document.querySelectorAll('.ico-tab');
            var contents = document.querySelectorAll('.tab-content');

            tabs.forEach(function(tab) {
                tab.addEventListener('click', function() {
                    tabs.forEach(function(t) { t.classList.remove('active'); });
                    tab.classList.add('active');
                    var target = tab.dataset.tab;
                    contents.forEach(function(c) { c.style.display = 'none'; });
                    document.getElementById('tab-' + target).style.display = 'block';
                });
            });

            // Countdown timers
            document.querySelectorAll('.countdown-timer').forEach(function(el) {
                var endDate = new Date(el.dataset.end).getTime();
                function update() {
                    var now = new Date().getTime();
                    var distance = endDate - now;
                    if (distance < 0) return;
                    var d = Math.floor(distance / (1000 * 60 * 60 * 24));
                    var h = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                    var m = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                    var s = Math.floor((distance % (1000 * 60)) / 1000);
                    el.querySelector('.cd-days').textContent = String(d).padStart(2, '0');
                    el.querySelector('.cd-hours').textContent = String(h).padStart(2, '0');
                    el.querySelector('.cd-mins').textContent = String(m).padStart(2, '0');
                    el.querySelector('.cd-secs').textContent = String(s).padStart(2, '0');
                }
                update();
                setInterval(update, 1000);
            });

            // Performance Chart
            var perfData = <%= GetPerformanceChartData() %>;
            var perfCtx = document.getElementById('performanceChart');
            if (perfCtx && perfData.labels.length > 0) {
                new Chart(perfCtx, {
                    type: 'line',
                    data: {
                        labels: perfData.labels,
                        datasets: [{
                            label: 'Portfolio Value (PNC)',
                            data: perfData.values,
                            borderColor: '#ff3b5c',
                            backgroundColor: 'rgba(255, 59, 92, 0.1)',
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
                                borderColor: '#ff3b5c',
                                borderWidth: 1,
                                callbacks: {
                                    label: function(ctx) { return ctx.parsed.y.toLocaleString() + ' PNC'; }
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

            // Distribution Chart
            var distData = <%= GetDistributionData() %>;
            var distCtx = document.getElementById('distributionChart');
            if (distCtx && distData.labels.length > 0) {
                new Chart(distCtx, {
                    type: 'doughnut',
                    data: {
                        labels: distData.labels,
                        datasets: [{
                            data: distData.values,
                            backgroundColor: distData.colors,
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

                // Build legend
                var legendHtml = '';
                for (var i = 0; i < distData.labels.length; i++) {
                    legendHtml += '<div class="d-flex align-items-center gap-2 mb-1">' +
                        '<span style="width: 10px; height: 10px; border-radius: 50%; background: ' + distData.colors[i] + '; display: inline-block;"></span>' +
                        '<span class="text-gray small flex-grow-1">' + distData.labels[i] + '</span>' +
                        '<span class="text-white small fw-bold">' + distData.values[i].toFixed(2) + ' PNC</span>' +
                        '</div>';
                }
                document.getElementById('distributionLegend').innerHTML = legendHtml;
            }
        });
    </script>
</asp:Content>