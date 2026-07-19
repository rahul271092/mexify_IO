<%@ Page Title="My Staking" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="Staking.aspx.cs" Inherits="Mexify.Web.User.Staking" %>


<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Chart.js Library -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    
    <style>

        .user-main{
            width:85vw;
        }

        /* =========================================
           GLOBAL LAYOUT FIXES
           ========================================= */
        .tab-content {
            width: 100% !important;
            max-width: 100% !important;
            box-sizing: border-box;
        }

        /* =========================================
           HEADER & TABS
           ========================================= */
        .staking-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            flex-wrap: wrap;
            gap: 16px;
            width: 100%;
        }
        .staking-header h2 { 
            color: var(--text-white); 
            margin: 0; 
            font-size: 1.8rem; 
        }

        .staking-tabs {
            display: flex;
            gap: 4px;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 50px;
            padding: 4px;
            margin-bottom: 28px;
            width: fit-content;
            max-width: 100%;
            flex-wrap: wrap;
        }
        .staking-tab {
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
        .staking-tab.active {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: var(--text-white);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }
        .staking-tab:hover:not(.active) {
            background: rgba(255, 255, 255, 0.05);
            color: var(--text-white);
        }

        /* =========================================
           SUMMARY CARD
           ========================================= */
        .staking-summary {
            background: linear-gradient(135deg, rgba(0, 255, 178, 0.15), rgba(0, 212, 255, 0.1));
            border: 1px solid rgba(0, 255, 178, 0.3);
            border-radius: var(--radius-xl);
            padding: 40px;
            position: relative;
            overflow: hidden;
            margin-bottom: 32px;
            width: 100%;
            box-sizing: border-box;
        }
        .staking-summary::before {
            content: '';
            position: absolute;
            top: -50%; right: -10%;
            width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(0, 255, 178, 0.15) 0%, transparent 70%);
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
            line-height: 1.2;
        }
        .summary-value small { 
            font-size: 1.2rem; 
            color: var(--text-gray); 
            font-weight: 500;
        }

        /* =========================================
           STAKE CARDS
           ========================================= */
        .stake-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 24px;
            margin-bottom: 16px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            width: 100%;
            box-sizing: border-box;
        }
        .stake-card:hover {
            border-color: var(--secondary);
            transform: translateX(4px);
        }
        .stake-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0;
            width: 4px; height: 100%;
            background: linear-gradient(180deg, var(--accent), var(--secondary));
        }
        .stake-card.matured::before {
            background: linear-gradient(180deg, var(--gold), #FFA500);
        }

        .stake-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 16px;
            flex-wrap: wrap;
            gap: 12px;
        }
        .stake-info { 
            display: flex; 
            align-items: center; 
            gap: 14px; 
            flex: 1;
            min-width: 0;
        }
        .stake-icon {
            width: 52px; height: 52px;
            border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.4rem;
            background: linear-gradient(135deg, rgba(0, 255, 178, 0.2), rgba(0, 212, 255, 0.1));
            color: var(--accent);
            border: 1px solid rgba(0, 255, 178, 0.3);
            flex-shrink: 0;
        }
        .stake-name { 
            color: var(--text-white); 
            font-weight: 600; 
            font-size: 1rem; 
            margin-bottom: 2px;
            word-break: break-word;
        }
        .stake-currency { 
            color: var(--text-muted); 
            font-size: 0.8rem; 
        }
        .stake-amount { 
            text-align: right; 
            flex-shrink: 0;
        }
        .stake-amount-value { 
            color: var(--text-white); 
            font-weight: 700; 
            font-size: 1.3rem;
            word-break: break-word;
        }
        .stake-apy { 
            color: var(--accent); 
            font-size: 0.85rem; 
            font-weight: 600; 
        }

        .stake-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 12px;
            padding: 16px 0;
            border-top: 1px solid var(--glass-border);
            border-bottom: 1px solid var(--glass-border);
        }
        .stake-detail { 
            text-align: center; 
            min-width: 0;
        }
        .stake-detail .label {
            color: var(--text-muted);
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }
        .stake-detail .value {
            color: var(--text-white);
            font-weight: 600;
            font-size: 0.9rem;
            word-break: break-word;
        }
        .stake-detail .value.accent { color: var(--accent); }
        .stake-detail .value.gold { color: var(--gold); }

        /* =========================================
           PROGRESS BARS
           ========================================= */
        .progress-bar-stake {
            height: 6px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50px;
            overflow: hidden;
            margin: 16px 0 8px;
            width: 100%;
        }
        .progress-fill-stake {
            height: 100%;
            background: linear-gradient(90deg, var(--accent), var(--secondary));
            border-radius: 50px;
            transition: width 1s ease;
            position: relative;
        }
        .progress-fill-stake::after {
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

        /* =========================================
           COUNTDOWN TIMER
           ========================================= */
        .countdown-timer {
            display: inline-flex;
            gap: 8px;
            padding: 8px 14px;
            background: rgba(0, 212, 255, 0.08);
            border: 1px solid rgba(0, 212, 255, 0.2);
            border-radius: var(--radius-sm);
            flex-wrap: wrap;
            justify-content: center;
        }
        .countdown-unit { 
            text-align: center; 
            min-width: 40px; 
        }
        .countdown-unit .value {
            display: block;
            color: var(--secondary);
            font-size: 1.1rem;
            font-weight: 800;
        }
        .countdown-unit .label {
            font-size: 0.65rem;
            color: var(--text-muted);
            text-transform: uppercase;
        }

        /* =========================================
           STAKE ACTIONS
           ========================================= */
        .stake-actions {
            display: flex;
            gap: 8px;
            margin-top: 16px;
            flex-wrap: wrap;
            align-items: center;
        }
        .stake-btn {
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
        .stake-btn:hover {
            background: rgba(0, 212, 255, 0.1);
            color: var(--secondary);
            border-color: var(--secondary);
        }
        .stake-btn.primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: var(--text-white);
            border-color: transparent;
        }
        .stake-btn.primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.4);
        }
        .stake-btn.gold {
            background: linear-gradient(135deg, var(--gold), #FFA500);
            color: #000;
            border-color: transparent;
        }

        /* =========================================
           STATUS BADGES
           ========================================= */
        .status-badge {
            padding: 3px 10px;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
            text-transform: uppercase;
            display: inline-block;
            white-space: nowrap;
        }
        .status-active { background: rgba(0, 255, 178, 0.15); color: var(--accent); }
        .status-matured { background: rgba(255, 215, 0, 0.15); color: var(--gold); }
        .status-pending { background: rgba(0, 212, 255, 0.15); color: var(--secondary); }
        .status-locked { background: rgba(255, 59, 92, 0.15); color: #ff3b5c; }

        /* =========================================
           POOL CARDS
           ========================================= */
        .pool-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 24px;
            transition: all 0.3s ease;
            cursor: pointer;
            height: 100%;
            width: 100%;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
        }
        .pool-card:hover {
            transform: translateY(-5px);
            border-color: var(--secondary);
            box-shadow: 0 15px 40px rgba(0, 212, 255, 0.15);
        }
        .pool-card.featured {
            border-color: var(--gold);
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.05), rgba(37, 99, 235, 0.05));
        }
        .pool-card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 16px;
            gap: 12px;
        }
        .pool-card-title {
            color: var(--text-white);
            font-size: 1.1rem;
            font-weight: 700;
            margin: 0 0 4px 0;
            word-break: break-word;
        }
        .pool-card-subtitle {
            color: var(--text-muted);
            font-size: 0.8rem;
        }
        .pool-apy {
            font-size: 2.5rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--accent), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: 12px 0;
            line-height: 1;
        }
        .pool-apy small {
            font-size: 0.9rem;
            color: var(--text-gray);
            -webkit-text-fill-color: var(--text-gray);
        }
        .pool-limits {
            display: flex;
            justify-content: space-between;
            color: var(--text-muted);
            font-size: 0.85rem;
            margin: 12px 0 20px;
            gap: 8px;
            flex-wrap: wrap;
        }
        .pool-card .btn-primary-glow {
            margin-top: auto;
        }

        /* =========================================
           CHART CARDS
           ========================================= */
        .chart-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 24px;
            width: 100%;
            box-sizing: border-box;
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
        .chart-container {
            position: relative;
            width: 100%;
            min-height: 250px;
        }

        /* =========================================
           TABLES
           ========================================= */
        .history-table,
        .tier-table {
            width: 100%;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-sizing: border-box;
        }
        .table-responsive {
            width: 100%;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }
        .history-table table,
        .tier-table table { 
            width: 100%; 
            color: var(--text-gray);
            min-width: 700px;
            border-collapse: collapse;
        }
        .history-table th,
        .tier-table th {
            background: rgba(0, 255, 178, 0.08);
            padding: 14px 16px;
            color: var(--text-white);
            font-weight: 600;
            font-size: 0.85rem;
            text-align: left;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            white-space: nowrap;
        }
        .tier-table th {
            background: rgba(139, 92, 246, 0.1);
        }
        .history-table td,
        .tier-table td {
            padding: 14px 16px;
            border-bottom: 1px solid var(--glass-border);
            font-size: 0.9rem;
            word-break: break-word;
        }
        .history-table tr:last-child td,
        .tier-table tr:last-child td { 
            border-bottom: none; 
        }
        .history-table tr:hover,
        .tier-table tr:hover { 
            background: rgba(255, 255, 255, 0.02); 
        }
        .tier-table tr.current-tier {
            background: rgba(139, 92, 246, 0.08);
            border-left: 4px solid #8B5CF6;
        }

        /* =========================================
           REWARD ITEMS
           ========================================= */
        .reward-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 0;
            border-bottom: 1px solid var(--glass-border);
            flex-wrap: wrap;
        }
        .reward-item:last-child { border-bottom: none; }
        .reward-icon {
            width: 38px; height: 38px;
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            background: rgba(0, 255, 178, 0.15);
            color: var(--accent);
            flex-shrink: 0;
        }
        .reward-info { 
            flex: 1; 
            min-width: 150px; 
        }
        .reward-title { 
            color: var(--text-white); 
            font-weight: 600; 
            font-size: 0.85rem; 
            margin-bottom: 2px;
            word-break: break-word;
        }
        .reward-date { 
            color: var(--text-muted); 
            font-size: 0.7rem; 
        }
        .reward-amount { 
            color: var(--accent); 
            font-weight: 700; 
            font-size: 0.9rem;
            white-space: nowrap;
        }

        /* =========================================
           COMMISSION ITEMS
           ========================================= */
        .commission-item {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 14px;
            background: rgba(255,255,255,0.02);
            border-radius: 10px;
            margin-bottom: 10px;
            flex-wrap: wrap;
        }
        .commission-icon {
            width: 44px; 
            height: 44px;
            border-radius: 10px;
            background: rgba(139, 92, 246, 0.15);
            color: #8B5CF6;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            flex-shrink: 0;
        }
        .commission-info {
            flex: 1;
            min-width: 150px;
        }
        .commission-amount {
            color: var(--accent);
            font-weight: 700;
            font-size: 1.1rem;
            white-space: nowrap;
        }

        /* =========================================
           STAT CARDS
           ========================================= */
        .stat-card {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            text-align: center;
            transition: all 0.3s ease;
            padding: 24px;
            width: 100%;
            box-sizing: border-box;
        }
        .stat-card:hover {
            border-color: var(--accent);
            transform: translateY(-3px);
        }

        /* =========================================
           TIER BADGES
           ========================================= */
        .tier-badge {
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 700;
            display: inline-block;
            white-space: nowrap;
        }

        /* =========================================
           EMPTY STATES
           ========================================= */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: var(--glass-bg);
            border: 1px dashed var(--glass-border);
            border-radius: var(--radius-lg);
            width: 100%;
            box-sizing: border-box;
        }
        .empty-state i { 
            font-size: 4rem; 
            color: var(--text-muted); 
            margin-bottom: 20px; 
            opacity: 0.5; 
        }
        .empty-state h4 { 
            color: var(--text-white); 
            margin-bottom: 8px; 
        }
        .empty-state p { 
            color: var(--text-gray); 
            margin-bottom: 24px; 
        }

        /* =========================================
           RESPONSIVE DESIGN
           ========================================= */
        @media (max-width: 992px) {
            .staking-summary {
                padding: 30px 20px;
            }
            .summary-value {
                font-size: 2.5rem;
            }
            .pool-apy {
                font-size: 2rem;
            }
        }

        @media (max-width: 768px) {
            .staking-header {
                flex-direction: column;
                align-items: flex-start;
            }
            .staking-tabs {
                width: 100%;
                overflow-x: auto;
                flex-wrap: nowrap;
            }
            .staking-tab {
                flex: 0 0 auto;
                padding: 10px 16px;
                font-size: 0.8rem;
            }
            .staking-summary {
                padding: 24px 16px;
            }
            .summary-value {
                font-size: 2rem;
            }
            .stake-header {
                flex-direction: column;
                align-items: flex-start;
            }
            .stake-amount {
                text-align: left;
                width: 100%;
            }
            .stake-details {
                grid-template-columns: repeat(2, 1fr);
            }
            .countdown-timer {
                width: 100%;
                justify-content: center;
            }
            .pool-card {
                padding: 20px;
            }
            .pool-apy {
                font-size: 1.8rem;
            }
            .chart-card {
                padding: 16px;
            }
            .history-table table,
            .tier-table table {
                min-width: 600px;
            }
            .reward-item {
                flex-direction: column;
                align-items: flex-start;
            }
            .commission-item {
                flex-direction: column;
                align-items: flex-start;
            }
        }

        @media (max-width: 576px) {
            .staking-header h2 {
                font-size: 1.5rem;
            }
            .summary-value {
                font-size: 1.8rem;
            }
            .stake-details {
                grid-template-columns: 1fr;
            }
            .pool-apy {
                font-size: 1.5rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Header -->
    <div class="staking-header" data-aos="fade-up">
        <div>
            <h2>My Staking</h2>
            <p class="text-gray mb-0">Manage your staked assets and rewards</p>
        </div>
        <a href="<%= ResolveUrl("~/Web/User/StakeNow.aspx") %>" class="btn btn-primary-glow">
            <i class="fas fa-plus me-2"></i> New Stake
        </a>
    </div>

    <!-- Tabs -->
    <div class="staking-tabs" data-aos="fade-up">
        <button type="button" class="staking-tab active" data-tab="overview">
            <i class="fas fa-chart-pie me-1"></i> Overview
        </button>
        <button type="button" class="staking-tab" data-tab="active">
            <i class="fas fa-circle me-1" style="font-size: 0.5rem; color: var(--accent);"></i>
            Active (<asp:Literal ID="litActiveCount" runat="server" Text="0"></asp:Literal>)
        </button>
        <button type="button" class="staking-tab" data-tab="history">
            <i class="fas fa-history me-1"></i> History
        </button>
        <button type="button" class="staking-tab" data-tab="rewards">
            <i class="fas fa-gift me-1"></i> Rewards
        </button>
        <button type="button" class="staking-tab" data-tab="commissions">
            <i class="fas fa-layer-group me-1"></i> 15-Level Commissions
        </button>
    </div>

    <!-- =========================================
         OVERVIEW TAB
         ========================================= -->
    <div id="tab-overview" class="tab-content" data-aos="fade-up">
        
        <!-- Summary Card -->
        <div class="staking-summary">
            <div class="row align-items-center position-relative" style="z-index: 2;">
                <div class="col-lg-6 mb-4 mb-lg-0">
                    <div class="summary-label">Total Staked Value</div>
                    <div class="summary-value">
                        <asp:Literal ID="litTotalStaked" runat="server" Text="0.00"></asp:Literal>
                        <small> USDT</small>
                    </div>
                    <div style="color: var(--text-gray); font-size: 1.1rem;">
                        ≈ $<asp:Literal ID="litTotalUSD" runat="server" Text="0.00"></asp:Literal> USD
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="stake-card" style="padding: 16px; margin-bottom: 0;">
                                <div class="summary-label">Active Stakes</div>
                                <div style="font-size: 1.5rem; font-weight: 800; color: var(--text-white);">
                                    <asp:Literal ID="litActiveStakes" runat="server" Text="0"></asp:Literal>
                                </div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stake-card" style="padding: 16px; margin-bottom: 0;">
                                <div class="summary-label">Total Rewards</div>
                                <div style="font-size: 1.5rem; font-weight: 800; color: var(--accent);">
                                    <asp:Literal ID="litTotalRewards" runat="server" Text="0.00"></asp:Literal>
                                </div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stake-card" style="padding: 16px; margin-bottom: 0;">
                                <div class="summary-label">Daily Rewards</div>
                                <div style="font-size: 1.5rem; font-weight: 800; color: var(--gold);">
                                    <asp:Literal ID="litDailyRewards" runat="server" Text="0.00"></asp:Literal>
                                </div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stake-card" style="padding: 16px; margin-bottom: 0;">
                                <div class="summary-label">Avg APY</div>
                                <div style="font-size: 1.5rem; font-weight: 800; color: var(--secondary);">
                                    <asp:Literal ID="litAvgAPY" runat="server" Text="0.00"></asp:Literal>%
                                </div>
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
                        <h5 class="chart-title">Staking Rewards Over Time</h5>
                    </div>
                    <div class="chart-container">
                        <canvas id="rewardsChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-lg-4" data-aos="fade-up" data-aos-delay="100">
                <div class="chart-card h-100">
                    <div class="chart-header">
                        <h5 class="chart-title">Stake Distribution</h5>
                    </div>
                    <div class="chart-container" style="min-height: 220px;">
                        <canvas id="distributionChart"></canvas>
                    </div>
                    <div id="distributionLegend" class="mt-3"></div>
                </div>
            </div>
        </div>

        <!-- Available Pools -->
        <h4 class="text-white mb-3" data-aos="fade-up">
            <i class="fas fa-layer-group text-secondary me-2"></i>
            Available Staking Pools
        </h4>
        <div class="row g-4">

                 <%--  <asp:Repeater ID="rptPools" runat="server">
                <ItemTemplate>
                    <div class="col-md-6 col-lg-4" data-aos="fade-up">
                        <div class='pool-card <%# Convert.ToBoolean(Eval("IsHot")) ? "hot" : (Convert.ToBoolean(Eval("IsNew")) ? "new" : "") %>'>
                            <div class="pool-header">
                                <div class='pool-icon <%# Eval("CurrencyCode").ToString().ToLower() %>'>
                                    <i class='<%# GetCurrencyIcon(Eval("CurrencyCode")) %>'></i>
                                </div>
                                <div>
                                    <div class="pool-name"><%# Eval("PoolName") %></div>
                                    <div class="pool-symbol"><%# Eval("CurrencyCode") %> Staking</div>
                                </div>
                            </div>

                            <div class="pool-apy">
                                <div class="apy-label">Annual Percentage Yield</div>
                                <div class="apy-value">
                                    <%# string.Format("{0:0.##}", Eval("APY")) %><small>% APY</small>
                                </div>
                            </div>

                            <div class="pool-stats">
                                <div class="pool-stat">
                                    <div class="pool-stat-label">Min Stake</div>
                                    <div class="pool-stat-value"><%# string.Format("{0:0.##}", Eval("MinStake")) %></div>
                                </div>
                                <div class="pool-stat">
                                    <div class="pool-stat-label">Max Stake</div>
                                    <div class="pool-stat-value"><%# string.Format("{0:0}", Eval("MaxStake")) %></div>
                                </div>
                                <div class="pool-stat">
                                    <div class="pool-stat-label">Total Staked</div>
                                    <div class="pool-stat-value"><%# Eval("TotalStakedFormatted") %></div>
                                </div>
                                <div class="pool-stat">
                                    <div class="pool-stat-label">Stakers</div>
                                    <div class="pool-stat-value"><%# Eval("StakersCount") %></div>
                                </div>
                            </div>

                            <div class="pool-lock-period">
                                <i class="fas fa-lock"></i>
                                <span>Lock Period:</span>
                                <strong><%# Eval("LockPeriodDays") %> Days</strong>
                            </div>

                            <button type="button" class="btn-stake" onclick='openStakeModal(<%# Eval("PoolId") %>, "<%# Eval("PoolName") %>", "<%# Eval("CurrencyCode") %>", <%# Eval("APY") %>, <%# Eval("MinStake") %>, <%# Eval("LockPeriodDays") %>)'>
                                <i class="fas fa-coins"></i> Stake Now
                            </button>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>--%>
     


            <asp:Repeater ID="rptPools" runat="server">
                <ItemTemplate>
                    <div class="col-md-6 col-lg-4" data-aos="fade-up">
                        <div class='pool-card <%# (Eval("IsHot") != null && Convert.ToBoolean(Eval("IsHot"))) ? "featured" : "" %>'>
                            <div class="pool-card-header">
                                <div>
                                    <h5 class="pool-card-title">
                                        <%# Eval("PoolName") != null ? Eval("PoolName").ToString() : (Eval("PoolName") != null ? Eval("PoolName").ToString() : "Staking Pool") %>
                                    </h5>
                                    <small class="pool-card-subtitle">
                                        <%# Eval("LockPeriodDays") ?? "30" %> days lock
                                    </small>
                                </div>
                                <%# (Eval("IsHot") != null && Convert.ToBoolean(Eval("IsHot"))) ? "<span class='status-badge' style='background: rgba(255, 215, 0, 0.15); color: var(--gold);'>HOT</span>" : "" %>
                            </div>
                            <div class="pool-apy">
                                <%# string.Format("{0:0.##}", Eval("APY") ?? 0) %>%
                                <small>APY</small>
                            </div>
                            <div class="pool-limits">
                                <span>Min: <%# string.Format("{0:0.##}", Eval("MinStake") ?? 0) %> USDT</span>
                                <span>Max: <%# string.Format("{0:0.##}", Eval("MaxStake") ?? 0) %> USDT</span>
                            </div>
                            <a href='<%# ResolveUrl("~/Web/User/StakeNow.aspx?poolId=" + Eval("PoolId")) %>' class="btn btn-primary-glow w-100">
                                <i class="fas fa-bolt me-2"></i> Stake Now
                            </a>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnlNoPools" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-layer-group"></i>
                <h4>No Pools Available</h4>
                <p>Check back soon for new staking opportunities.</p>
            </div>
        </asp:Panel>
    </div>

    <!-- =========================================
         ACTIVE STAKES TAB
         ========================================= -->
    <div id="tab-active" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <asp:Repeater ID="rptActiveStakes" runat="server">
            <ItemTemplate>
                <div class="stake-card">
                    <div class="stake-header">
                        <div class="stake-info">
                            <div class="stake-icon">
                                <i class='<%# GetCurrencyIcon(Eval("CurrencyCode")) %>'></i>
                            </div>
                            <div>
                                <div class="stake-name"><%# Eval("PoolName") %></div>
                                <div class="stake-currency">
                                    Stake #<%# Eval("StakeId") %> · 
                                    Started <%# Convert.ToDateTime(Eval("StakeDate")).ToString("MMM dd, yyyy") %>
                                </div>
                            </div>
                        </div>
                        <div class="stake-amount">
                            <div class="stake-amount-value">
                                <%# string.Format("{0:0.########}", Eval("Amount")) %> <%# Eval("CurrencyCode") %>
                            </div>
                            <div class="stake-apy"><%# string.Format("{0:0.##}", Eval("APY")) %>% APY</div>
                        </div>
                    </div>

                    <div class="stake-details">
                        <div class="stake-detail">
                            <div class="label">Lock Period</div>
                            <div class="value"><%# Eval("LockPeriodDays") %> Days</div>
                        </div>
                        <div class="stake-detail">
                            <div class="label">Progress</div>
                            <div class="value accent"><%# Eval("ProgressPercent") %>%</div>
                        </div>
                        <div class="stake-detail">
                            <div class="label">Rewards Earned</div>
                            <div class="value accent"><%# string.Format("{0:0.########}", Eval("TotalRewards")) %> USDT</div>
                        </div>
                        <div class="stake-detail">
                            <div class="label">Daily Reward</div>
                            <div class="value gold"><%# string.Format("{0:0.########}", Eval("DailyReward")) %> USDT</div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mt-3">
                        <div>
                            <small class="text-muted">Matures on</small>
                            <div class="text-white fw-bold"><%# Convert.ToDateTime(Eval("EndDate")).ToString("MMMM dd, yyyy") %></div>
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
                    </div>

                    <div class="progress-bar-stake">
                        <div class="progress-fill-stake" style="width: <%# Eval("ProgressPercent") %>%;"></div>
                    </div>

                    <div class="stake-actions">
                        <span class='status-badge <%# GetStatusClass(Eval("Status")) %>'>
                            <%# GetStatusName(Eval("Status")) %>
                        </span>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoActive" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-coins"></i>
                <h4>No Active Stakes</h4>
                <p>Start earning passive rewards by staking your USDT.</p>
                <a href="<%= ResolveUrl("~/Web/User/StakeNow.aspx") %>" class="btn btn-primary-glow">
                    <i class="fas fa-bolt me-2"></i> Start Staking
                </a>
            </div>
        </asp:Panel>
    </div>

    <!-- =========================================
         HISTORY TAB
         ========================================= -->
    <div id="tab-history" class="tab-content" style="display: none;" data-aos="fade-up">
        <div class="history-table">
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Pool</th>
                            <th>Amount</th>
                            <th>APY</th>
                            <th>Rewards</th>
                            <th>Status</th>
                            <th>Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptHistory" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td>#<%# Eval("StakeId") %></td>
                                    <td class="text-white"><%# Eval("PoolName") %></td>
                                    <td><%# string.Format("{0:0.########}", Eval("StakedAmount")) %> <%# Eval("CurrencyCode") %></td>
                                    <td class="text-accent"><%# string.Format("{0:0.##}", Eval("APY")) %>%</td>
                                    <td class="text-accent"><%# string.Format("{0:0.########}", Eval("TotalRewards")) %> USDT</td>
                                    <td>
                                        <span class='status-badge <%# GetStatusClass(Eval("Status")) %>'>
                                            <%# GetStatusName(Eval("Status")) %>
                                        </span>
                                    </td>
                                    <td class="text-muted"><%# Eval("StakedDate") %></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>

        <asp:Panel ID="pnlNoHistory" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-history"></i>
                <h4>No Staking History</h4>
                <p>Your completed and matured stakes will appear here.</p>
            </div>
        </asp:Panel>
    </div>

    <!-- =========================================
         REWARDS TAB
         ========================================= -->
    <div id="tab-rewards" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="summary-label">Total Lifetime Rewards</div>
                    <div style="font-size: 2rem; font-weight: 800; color: var(--accent);">
                        <asp:Literal ID="litLifetimeRewards" runat="server" Text="0.00"></asp:Literal>
                        <small style="font-size: 0.9rem; color: var(--text-gray);"> USDT</small>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="summary-label">This Month</div>
                    <div style="font-size: 2rem; font-weight: 800; color: var(--gold);">
                        <asp:Literal ID="litMonthRewards" runat="server" Text="0.00"></asp:Literal>
                        <small style="font-size: 0.9rem; color: var(--text-gray);"> USDT</small>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="summary-label">Pending Claim</div>
                    <div style="font-size: 2rem; font-weight: 800; color: var(--secondary);">
                        <asp:Literal ID="litPendingRewards" runat="server" Text="0.00"></asp:Literal>
                        <small style="font-size: 0.9rem; color: var(--text-gray);"> USDT</small>
                    </div>
                </div>
            </div>
        </div>

        <div class="chart-card">
            <div class="chart-header">
                <h5 class="chart-title">
                    <i class="fas fa-gift text-accent me-2"></i>
                    Recent Reward Distributions
                </h5>
            </div>
            <asp:Repeater ID="rptRewards" runat="server">
                <ItemTemplate>
                    <div class="reward-item">
                        <div class="reward-icon">
                            <i class="fas fa-coins"></i>
                        </div>
                        <div class="reward-info">
                            <div class="reward-title">
                                <%# Eval("PoolName") %> - Daily Reward
                            </div>
                            <div class="reward-date">
                                <%# Convert.ToDateTime(Eval("DistributedDate")).ToString("MMM dd, yyyy 'at' hh:mm tt") %>
                            </div>
                        </div>
                        <div class="reward-amount">
                            +<%# string.Format("{0:0.########}", Eval("Amount")) %> USDT
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoRewards" runat="server" Visible="false">
                <div class="empty-state">
                    <i class="fas fa-gift"></i>
                    <h4>No Rewards Yet</h4>
                    <p>Your reward distributions will appear here once you start staking.</p>
                </div>
            </asp:Panel>
        </div>
    </div>

    <!-- =========================================
         15-LEVEL COMMISSIONS TAB
         ========================================= -->
    <div id="tab-commissions" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <!-- Commission Stats Overview -->
        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="summary-label">Total Commission Earned</div>
                    <div class="summary-value" style="color: var(--accent); font-size: 2rem;">
                        $<asp:Literal ID="litCommissionTotal" runat="server" Text="0.00"></asp:Literal>
                    </div>
                    <small class="text-muted">USDT</small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="summary-label">Total Commissions</div>
                    <div class="summary-value" style="color: #8B5CF6; font-size: 2rem;">
                        <asp:Literal ID="litCommissionCount" runat="server" Text="0"></asp:Literal>
                    </div>
                    <small class="text-muted">Transactions</small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="summary-label">Unique Downlines Staking</div>
                    <div class="summary-value" style="color: var(--gold); font-size: 2rem;">
                        <asp:Literal ID="litUniqueDownlines" runat="server" Text="0"></asp:Literal>
                    </div>
                    <small class="text-muted">Active stakers in your team</small>
                </div>
            </div>
        </div>

        <!-- 15 Level Breakdown -->
        <div class="chart-card mb-4">
            <div class="chart-header">
                <h5 class="chart-title">
                    <i class="fas fa-layer-group" style="color: #8B5CF6;"></i>
                    15-Level Commission Structure
                </h5>
                <div class="text-muted small">
                    <i class="fas fa-info-circle"></i> Level N requires N direct referrals
                </div>
            </div>
            
            <div class="table-responsive">
                <table class="tier-table">
                    <thead>
                        <tr>
                            <th>Level</th>
                            <th>Commission %</th>
                            <th>Directs Required</th>
                            <th>Your Directs</th>
                            <th>Status</th>
                            <th>Times Earned</th>
                            <th>Total Earned</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptCommissionLevels" runat="server">
                            <ItemTemplate>
                                <tr class='<%# Convert.ToBoolean(Eval("IsQualified")) ? "current-tier" : "" %>'>
                                    <td>
                                        <span class="tier-badge" style="background: rgba(139, 92, 246, 0.2); color: #8B5CF6;">
                                            Level <%# Eval("Level") %>
                                        </span>
                                    </td>
                                    <td class="text-white fw-bold"><%# string.Format("{0:0.##}", Eval("CommissionPercent")) %>%</td>
                                    <td><%# Eval("RequiredDirects") %> Directs</td>
                                    <td class="text-accent"><%# Eval("CurrentDirects") %></td>
                                    <td>
                                        <%# Convert.ToBoolean(Eval("IsQualified")) 
                                            ? "<span class='status-badge status-active'><i class='fas fa-check'></i> Qualified</span>" 
                                            : "<span class='status-badge status-locked'><i class='fas fa-lock'></i> Locked</span>" %>
                                    </td>
                                    <td><%# Eval("TimesEarned") %></td>
                                    <td class="text-gold fw-bold">$<%# string.Format("{0:0.00}", Eval("LevelTotal")) %></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Recent Commission History -->
        <div class="chart-card">
            <div class="chart-header">
                <h5 class="chart-title">
                    <i class="fas fa-history" style="color: var(--accent);"></i>
                    Recent Commission Earnings
                </h5>
            </div>
            
            <asp:Repeater ID="rptCommissionHistory" runat="server">
                <ItemTemplate>
                    <div class="commission-item">
                        <div class="commission-icon">
                            L<%# Eval("Level") %>
                        </div>
                        <div class="commission-info">
                            <div class="text-white fw-bold">
                                <%# Eval("FromUserName") %> 
                                <small class="text-muted">staked $<%# string.Format("{0:0.00}", Eval("StakedAmount")) %> USDT</small>
                            </div>
                            <div class="text-muted small">
                                <%# Convert.ToDateTime(Eval("CreatedDate")).ToString("MMM dd, yyyy hh:mm tt") %> · 
                                <%# string.Format("{0:0.##}", Eval("CommissionPercent")) %>% commission
                            </div>
                        </div>
                        <div class="commission-amount">
                            +$<%# string.Format("{0:0.00}", Eval("CommissionAmount")) %>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoCommissions" runat="server" Visible="false">
                <div class="empty-state">
                    <i class="fas fa-coins"></i>
                    <h4>No Commissions Yet</h4>
                    <p>When your referrals stake, you'll earn commissions across 15 levels.</p>
                </div>
            </asp:Panel>
        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Tab switching
            var tabs = document.querySelectorAll('.staking-tab');
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
                var endDateStr = el.dataset.end;
                if (!endDateStr) return;
                var endDate = new Date(endDateStr).getTime();
                if (isNaN(endDate)) return;
                
                function update() {
                    var now = new Date().getTime();
                    var distance = endDate - now;
                    if (distance < 0) {
                        el.querySelector('.cd-days').textContent = '00';
                        el.querySelector('.cd-hours').textContent = '00';
                        el.querySelector('.cd-mins').textContent = '00';
                        el.querySelector('.cd-secs').textContent = '00';
                        return;
                    }
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

            // Rewards Chart
            try {
                var rewardsData = <%= GetRewardsChartData() %>;
                var rewardsCtx = document.getElementById('rewardsChart');
                if (rewardsCtx && rewardsData.labels && rewardsData.labels.length > 0 && typeof Chart !== 'undefined') {
                    new Chart(rewardsCtx, {
                        type: 'line',
                        data: {
                            labels: rewardsData.labels,
                            datasets: [{
                                label: 'Rewards (USDT)',
                                data: rewardsData.values,
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
            } catch (e) { console.error('Rewards chart error:', e); }

            // Distribution Chart
            try {
                var distData = <%= GetDistributionData() %>;
                var distCtx = document.getElementById('distributionChart');
                if (distCtx && distData.labels && distData.labels.length > 0 && typeof Chart !== 'undefined') {
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
                            '<span class="text-white small fw-bold">' + distData.values[i].toFixed(2) + ' USDT</span>' +
                            '</div>';
                    }
                    document.getElementById('distributionLegend').innerHTML = legendHtml;
                }
            } catch (e) { console.error('Distribution chart error:', e); }
        });
    </script>
</asp:Content>