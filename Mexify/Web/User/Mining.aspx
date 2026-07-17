<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="Mining.aspx.cs" Inherits="Mexify.Web.User.Mining" %>

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
        .mining-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            flex-wrap: wrap;
            gap: 16px;
            width: 100%;
        }
        .mining-header h2 { 
            color: var(--text-white); 
            margin: 0; 
            font-size: 1.8rem; 
        }

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
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }
        .mining-tab:hover:not(.active) {
            background: rgba(255, 255, 255, 0.05);
            color: var(--text-white);
        }

        /* =========================================
           SUMMARY CARD
           ========================================= */
        .mining-summary {
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.15), rgba(255, 165, 0, 0.1));
            border: 1px solid rgba(255, 215, 0, 0.3);
            border-radius: var(--radius-xl);
            padding: 40px;
            position: relative;
            overflow: hidden;
            margin-bottom: 32px;
            width: 100%;
            box-sizing: border-box;
        }
        .mining-summary::before {
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
           CONTRACT CARDS
           ========================================= */
        .contract-card {
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
        .contract-card:hover {
            border-color: var(--gold);
            transform: translateX(4px);
        }
        .contract-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0;
            width: 4px; height: 100%;
            background: linear-gradient(180deg, var(--gold), #FFA500);
        }
        .contract-card.expired::before {
            background: linear-gradient(180deg, var(--text-muted), #6B758D);
        }

        .contract-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 16px;
            flex-wrap: wrap;
            gap: 12px;
        }
        .contract-info { 
            display: flex; 
            align-items: center; 
            gap: 14px; 
            flex: 1;
            min-width: 0;
        }
        .contract-icon {
            width: 52px; height: 52px;
            border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.4rem;
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.2), rgba(255, 165, 0, 0.1));
            color: var(--gold);
            border: 1px solid rgba(255, 215, 0, 0.3);
            flex-shrink: 0;
        }
        .contract-name { 
            color: var(--text-white); 
            font-weight: 600; 
            font-size: 1rem; 
            margin-bottom: 2px;
            word-break: break-word;
        }
        .contract-algo { 
            color: var(--text-muted); 
            font-size: 0.8rem;
            word-break: break-word;
        }
        .contract-hashrate { 
            text-align: right; 
            flex-shrink: 0;
        }
        .contract-hashrate-value { 
            color: var(--gold); 
            font-weight: 700; 
            font-size: 1.3rem;
            word-break: break-word;
        }
        .contract-status { 
            font-size: 0.85rem; 
            font-weight: 600; 
        }

        .contract-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 12px;
            padding: 16px 0;
            border-top: 1px solid var(--glass-border);
            border-bottom: 1px solid var(--glass-border);
        }
        .contract-detail { 
            text-align: center;
            min-width: 0;
        }
        .contract-detail .label {
            color: var(--text-muted);
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }
        .contract-detail .value {
            color: var(--text-white);
            font-weight: 600;
            font-size: 0.9rem;
            word-break: break-word;
        }
        .contract-detail .value.gold { color: var(--gold); }
        .contract-detail .value.accent { color: var(--accent); }

        /* =========================================
           PROGRESS BARS
           ========================================= */
        .progress-bar-contract {
            height: 6px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50px;
            overflow: hidden;
            margin: 16px 0 8px;
            width: 100%;
        }
        .progress-fill-contract {
            height: 100%;
            background: linear-gradient(90deg, var(--gold), #FFA500);
            border-radius: 50px;
            transition: width 1s ease;
            position: relative;
        }
        .progress-fill-contract::after {
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
            background: rgba(255, 215, 0, 0.08);
            border: 1px solid rgba(255, 215, 0, 0.2);
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
            color: var(--gold);
            font-size: 1.1rem;
            font-weight: 800;
        }
        .countdown-unit .label {
            font-size: 0.65rem;
            color: var(--text-muted);
            text-transform: uppercase;
        }

        /* =========================================
           CONTRACT ACTIONS
           ========================================= */
        .contract-actions {
            display: flex;
            gap: 8px;
            margin-top: 16px;
            flex-wrap: wrap;
            align-items: center;
        }
        .contract-btn {
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
        .contract-btn:hover {
            background: rgba(255, 215, 0, 0.1);
            color: var(--gold);
            border-color: var(--gold);
        }
        .contract-btn.primary {
            background: linear-gradient(135deg, var(--gold), #FFA500);
            color: #000;
            border-color: transparent;
        }
        .contract-btn.primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 215, 0, 0.4);
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
        .status-expired { background: rgba(255, 59, 92, 0.15); color: #ff3b5c; }
        .status-pending { background: rgba(255, 215, 0, 0.15); color: var(--gold); }

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
            border-color: var(--gold);
            box-shadow: 0 15px 40px rgba(255, 215, 0, 0.15);
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
        .pool-hashrate {
            font-size: 2.5rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--gold), #FFA500);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: 12px 0;
            line-height: 1;
        }
        .pool-hashrate small {
            font-size: 0.9rem;
            color: var(--text-gray);
            -webkit-text-fill-color: var(--text-gray);
        }
        .pool-details {
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin: 12px 0 20px;
            flex: 1;
        }
        .pool-detail-row {
            display: flex;
            justify-content: space-between;
            color: var(--text-muted);
            font-size: 0.85rem;
            gap: 8px;
            flex-wrap: wrap;
        }
        .pool-price {
            text-align: center;
            margin: 16px 0;
            padding: 12px;
            background: rgba(255, 215, 0, 0.08);
            border: 1px solid rgba(255, 215, 0, 0.2);
            border-radius: 10px;
        }
        .pool-price-value {
            color: var(--gold);
            font-weight: 700;
            font-size: 1.3rem;
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
        .history-table {
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
        .history-table table { 
            width: 100%; 
            color: var(--text-gray);
            min-width: 700px;
            border-collapse: collapse;
        }
        .history-table th {
            background: rgba(255, 215, 0, 0.08);
            padding: 14px 16px;
            color: var(--text-white);
            font-weight: 600;
            font-size: 0.85rem;
            text-align: left;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            white-space: nowrap;
        }
        .history-table td {
            padding: 14px 16px;
            border-bottom: 1px solid var(--glass-border);
            font-size: 0.9rem;
            word-break: break-word;
        }
        .history-table tr:last-child td { border-bottom: none; }
        .history-table tr:hover { background: rgba(255, 255, 255, 0.02); }

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
            background: rgba(255, 215, 0, 0.15);
            color: var(--gold);
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
            color: var(--gold); 
            font-weight: 700; 
            font-size: 0.9rem;
            white-space: nowrap;
        }

        /* =========================================
           ALERT BOXES
           ========================================= */
        .alert-box {
            padding: 14px 18px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 0.9rem;
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }
        .alert-box.error { background: rgba(255, 59, 92, 0.1); border: 1px solid rgba(255, 59, 92, 0.3); color: #ff3b5c; }
        .alert-box.success { background: rgba(0, 255, 178, 0.1); border: 1px solid rgba(0, 255, 178, 0.3); color: var(--accent); }
        .alert-box.warning { background: rgba(255, 215, 0, 0.1); border: 1px solid rgba(255, 215, 0, 0.3); color: var(--gold); }
        .alert-box i { margin-top: 2px; flex-shrink: 0; }

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
           HASHRATE DISPLAY
           ========================================= */
        .hashrate-display {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 12px 16px;
            background: rgba(255, 215, 0, 0.08);
            border: 1px solid rgba(255, 215, 0, 0.2);
            border-radius: var(--radius-md);
            margin-bottom: 16px;
        }
        .hashrate-icon {
            font-size: 1.5rem;
            color: var(--gold);
        }
        .hashrate-info { flex: 1; }
        .hashrate-label { 
            font-size: 0.75rem; 
            color: var(--text-muted); 
            text-transform: uppercase; 
        }
        .hashrate-value { 
            font-size: 1.3rem; 
            font-weight: 800; 
            color: var(--text-white); 
        }

        /* =========================================
           RESPONSIVE DESIGN
           ========================================= */
        @media (max-width: 992px) {
            .mining-summary {
                padding: 30px 20px;
            }
            .summary-value {
                font-size: 2.5rem;
            }
            .pool-hashrate {
                font-size: 2rem;
            }
        }

        @media (max-width: 768px) {
            .mining-header {
                flex-direction: column;
                align-items: flex-start;
            }
            .mining-tabs {
                width: 100%;
                overflow-x: auto;
                flex-wrap: nowrap;
            }
            .mining-tab {
                flex: 0 0 auto;
                padding: 10px 16px;
                font-size: 0.8rem;
            }
            .mining-summary {
                padding: 24px 16px;
            }
            .summary-value {
                font-size: 2rem;
            }
            .contract-header {
                flex-direction: column;
                align-items: flex-start;
            }
            .contract-hashrate {
                text-align: left;
                width: 100%;
            }
            .contract-details {
                grid-template-columns: repeat(2, 1fr);
            }
            .countdown-timer {
                width: 100%;
                justify-content: center;
            }
            .pool-card {
                padding: 20px;
            }
            .pool-hashrate {
                font-size: 1.8rem;
            }
            .chart-card {
                padding: 16px;
            }
            .history-table table {
                min-width: 600px;
            }
            .reward-item {
                flex-direction: column;
                align-items: flex-start;
            }
        }

        @media (max-width: 576px) {
            .mining-header h2 {
                font-size: 1.5rem;
            }
            .summary-value {
                font-size: 1.8rem;
            }
            .contract-details {
                grid-template-columns: 1fr;
            }
            .pool-hashrate {
                font-size: 1.5rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Header -->
    <div class="mining-header" data-aos="fade-up">
        <div>
            <h2>My Mining</h2>
            <p class="text-gray mb-0">Manage your mining contracts and rewards</p>
        </div>
        <a href="<%= ResolveUrl("~/Web/User/NewMiningContract.aspx") %>" class="btn btn-primary-glow">
            <i class="fas fa-plus me-2"></i> New Contract
        </a>
    </div>

    <!-- Tabs -->
    <div class="mining-tabs" data-aos="fade-up">
        <button type="button" class="mining-tab active" data-tab="overview">
            <i class="fas fa-chart-pie me-1"></i> Overview
        </button>
        <button type="button" class="mining-tab" data-tab="active">
            <i class="fas fa-circle me-1" style="font-size: 0.5rem; color: var(--accent);"></i>
            Active (<asp:Literal ID="litActiveCount" runat="server" Text="0"></asp:Literal>)
        </button>
        <button type="button" class="mining-tab" data-tab="history">
            <i class="fas fa-history me-1"></i> History
        </button>
        <button type="button" class="mining-tab" data-tab="rewards">
            <i class="fas fa-gift me-1"></i> Rewards
        </button>
    </div>

    <!-- =========================================
         OVERVIEW TAB
         ========================================= -->
    <div id="tab-overview" class="tab-content" data-aos="fade-up">
        
        <!-- Summary Card -->
        <div class="mining-summary">
            <div class="row align-items-center position-relative" style="z-index: 2;">
                <div class="col-lg-6 mb-4 mb-lg-0">
                    <div class="summary-label">Total Hashrate</div>
                    <div class="summary-value">
                        <asp:Literal ID="litTotalHashrate" runat="server" Text="0"></asp:Literal>
                        <small> TH/s</small>
                    </div>
                    <div style="color: var(--text-gray); font-size: 1.1rem;">
                        Across <asp:Literal ID="litContractCount" runat="server" Text="0"></asp:Literal> active contracts
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="contract-card" style="padding: 16px; margin-bottom: 0;">
                                <div class="summary-label">Daily Rewards</div>
                                <div style="font-size: 1.5rem; font-weight: 800; color: var(--gold);">
                                    <asp:Literal ID="litDailyRewards" runat="server" Text="0.00"></asp:Literal>
                                </div>
                                <small class="text-muted">USDT per day</small>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="contract-card" style="padding: 16px; margin-bottom: 0;">
                                <div class="summary-label">Total Earned</div>
                                <div style="font-size: 1.5rem; font-weight: 800; color: var(--accent);">
                                    <asp:Literal ID="litTotalEarned" runat="server" Text="0.00"></asp:Literal>
                                </div>
                                <small class="text-muted">USDT lifetime</small>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="contract-card" style="padding: 16px; margin-bottom: 0;">
                                <div class="summary-label">Active Contracts</div>
                                <div style="font-size: 1.5rem; font-weight: 800; color: var(--text-white);">
                                    <asp:Literal ID="litActiveContracts" runat="server" Text="0"></asp:Literal>
                                </div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="contract-card" style="padding: 16px; margin-bottom: 0;">
                                <div class="summary-label">Total Invested</div>
                                <div style="font-size: 1.5rem; font-weight: 800; color: var(--secondary);">
                                    <asp:Literal ID="litTotalInvested" runat="server" Text="0.00"></asp:Literal>
                                </div>
                                <small class="text-muted">USDT</small>
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
                        <h5 class="chart-title">Mining Rewards Over Time</h5>
                    </div>
                    <div class="chart-container">
                        <canvas id="rewardsChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-lg-4" data-aos="fade-up" data-aos-delay="100">
                <div class="chart-card h-100">
                    <div class="chart-header">
                        <h5 class="chart-title">Hashrate Distribution</h5>
                    </div>
                    <div class="chart-container" style="min-height: 220px;">
                        <canvas id="distributionChart"></canvas>
                    </div>
                    <div id="distributionLegend" class="mt-3"></div>
                </div>
            </div>
        </div>

        <!-- Available Contracts -->
        <h4 class="text-white mb-3" data-aos="fade-up">
            <i class="fas fa-server text-gold me-2"></i>
            Available Mining Contracts
        </h4>
        <div class="row g-4">
            <asp:Repeater ID="rptContracts" runat="server">
                <ItemTemplate>
                    <div class="col-md-6 col-lg-4" data-aos="fade-up">
                        <div class='pool-card <%# (Eval("IsFeatured") != null && Convert.ToBoolean(Eval("IsFeatured"))) ? "featured" : "" %>'>
                            <div class="pool-card-header">
                                <div>
                                    <h5 class="pool-card-title">
                                        <%# Eval("PlanName") != null ? Eval("PlanName").ToString() : "Mining Plan" %>
                                    </h5>
                                    <small class="pool-card-subtitle">
                                        <%# Eval("Algorithm") != null ? Eval("Algorithm").ToString() : "SHA-256" %>
                                    </small>
                                </div>
                                <%# (Eval("IsFeatured") != null && Convert.ToBoolean(Eval("IsFeatured"))) ? "<span class='status-badge' style='background: rgba(255, 215, 0, 0.15); color: var(--gold);'>🔥 POPULAR</span>" : "" %>
                            </div>
                            <div class="pool-hashrate">
                                <%# Eval("HashrateFormatted") != null ? Eval("HashrateFormatted").ToString() : "0 TH/s" %>
                            </div>
                            <div class="pool-details">
                                <div class="pool-detail-row">
                                    <span>Duration:</span>
                                    <span class="text-white"><%# Eval("DurationDays") ?? "30" %> days</span>
                                </div>
                                <div class="pool-detail-row">
                                    <span>ROI:</span>
                                    <span class="text-white"><%# Eval("RoiDays") ?? "0" %> days</span>
                                </div>
                                <div class="pool-detail-row">
                                    <span>Daily:</span>
                                    <span class="text-gold"><%# string.Format("{0:0.########}", Eval("ExpectedDailyReward") ?? 0) %> <%# Eval("RewardCurrency") ?? "USDT" %></span>
                                </div>
                            </div>
                            <div class="pool-price">
                                <span class="pool-price-value">
                                    <%# string.Format("{0:0.##}", Eval("Price") ?? 0) %> USDT
                                </span>
                            </div>
                            <a href='<%# ResolveUrl("~/Web/User/NewMiningContract.aspx?planId=" + Eval("MiningPlanId")) %>' class="btn btn-primary-glow w-100">
                                <i class="fas fa-hammer me-2"></i> Purchase Contract
                            </a>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnlNoContracts" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-server"></i>
                <h4>No Contracts Available</h4>
                <p>Check back soon for new mining opportunities.</p>
            </div>
        </asp:Panel>
    </div>

    <!-- =========================================
         ACTIVE CONTRACTS TAB
         ========================================= -->
    <div id="tab-active" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <asp:Repeater ID="rptActiveContracts" runat="server">
            <ItemTemplate>
                <div class="contract-card">
                    <div class="contract-header">
                        <div class="contract-info">
                            <div class="contract-icon">
                                <i class="fas fa-server"></i>
                            </div>
                            <div>
                                <div class="contract-name"><%# Eval("PlanName") %></div>
                                <div class="contract-algo">
                                    Contract #<%# Eval("MiningPlanId") %> 
                              <%--      <%# Eval("Algorithm") %> · --%>
                                    Started <%# Convert.ToDateTime(Eval("StartDate")).ToString("MMM dd, yyyy") %>
                                </div>
                            </div>
                        </div>
                        <div class="contract-hashrate">
                            <div class="contract-hashrate-value"><%# Eval("Hashrate") %></div>
                            <div class="contract-status text-accent">● Active</div>
                        </div>
                    </div>

                    <div class="contract-details">
                        <div class="contract-detail">
                            <div class="label">Duration</div>
                            <div class="value"><%# Eval("ContractDays") %> Days</div>
                        </div>
                        <div class="contract-detail">
                            <div class="label">Progress</div>
                            <div class="value gold"><%# Eval("ProgressPercent") %>%</div>
                        </div>
                        <div class="contract-detail">
                            <div class="label">Total Earned</div>
                            <div class="value accent"><%# string.Format("{0:0.########}", Eval("TotalEarned")) %> USDT</div>
                        </div>
                        <div class="contract-detail">
                            <div class="label">Daily Reward</div>
                            <div class="value gold"><%# string.Format("{0:0.########}", Eval("DailyOutput")) %> USDT</div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mt-3">
                        <div>
                            <small class="text-muted">Expires on</small>
                            <div class="text-white fw-bold"><%# Convert.ToDateTime(Eval("EndDate")).ToString("MMMM dd, yyyy") %></div>
                        </div>
                        <div class="countdown-timer" data-end='<%# Eval("DaysRemaining") %>'>
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

                    <div class="progress-bar-contract">
                        <div class="progress-fill-contract" style="width: <%# Eval("ProgressPercent") %>%;"></div>
                    </div>

                    <div class="contract-actions">
                        <a href='<%# ResolveUrl("~/Web/User/ContractDetails.aspx?id=" + Eval("MiningPlanId")) %>' class="contract-btn">
                            <i class="fas fa-eye"></i> View Details
                        </a>
                        <span class='status-badge status-active'>
                            ● Mining Active
                        </span>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoActive" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-server"></i>
                <h4>No Active Contracts</h4>
                <p>Purchase a mining contract to start earning rewards.</p>
                <a href="<%= ResolveUrl("~/Web/User/NewMiningContract.aspx") %>" class="btn btn-primary-glow">
                    <i class="fas fa-hammer me-2"></i> Browse Contracts
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
                            <th>Contract</th>
                            <th>Hashrate</th>
                            <th>Invested</th>
                            <th>Earned</th>
                            <th>Status</th>
                            <th>Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptHistory" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td>#<%# Eval("MiningInvestmentId") %></td>
                                    <td class="text-white"><%# Eval("PlanName") %></td>
                                    <td><%# Eval("HashrateFormatted") %></td>
                                    <td><%# string.Format("{0:0.##}", Eval("Price")) %> USDT</td>
                                    <td class="text-accent"><%# string.Format("{0:0.########}", Eval("TotalRewards")) %> USDT</td>
                                    <td>
                                        <span class='status-badge <%# GetStatusClass(Eval("Status")) %>'>
                                            <%# GetStatusName(Eval("Status")) %>
                                        </span>
                                    </td>
                                    <td class="text-muted"><%# Convert.ToDateTime(Eval("StartDate")).ToString("MMM dd, yyyy") %></td>
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
                <h4>No Mining History</h4>
                <p>Your completed and expired contracts will appear here.</p>
            </div>
        </asp:Panel>
    </div>

    <!-- =========================================
         REWARDS TAB
         ========================================= -->
    <div id="tab-rewards" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="contract-card" style="padding: 24px;">
                    <div class="summary-label">Total Lifetime Rewards</div>
                    <div style="font-size: 2rem; font-weight: 800; color: var(--gold);">
                        <asp:Literal ID="litLifetimeRewards" runat="server" Text="0.00"></asp:Literal>
                        <small style="font-size: 0.9rem; color: var(--text-gray);"> USDT</small>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="contract-card" style="padding: 24px;">
                    <div class="summary-label">This Month</div>
                    <div style="font-size: 2rem; font-weight: 800; color: var(--accent);">
                        <asp:Literal ID="litMonthRewards" runat="server" Text="0.00"></asp:Literal>
                        <small style="font-size: 0.9rem; color: var(--text-gray);"> USDT</small>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="contract-card" style="padding: 24px;">
                    <div class="summary-label">Today's Rewards</div>
                    <div style="font-size: 2rem; font-weight: 800; color: var(--secondary);">
                        <asp:Literal ID="litTodayRewards" runat="server" Text="0.00"></asp:Literal>
                        <small style="font-size: 0.9rem; color: var(--text-gray);"> USDT</small>
                    </div>
                </div>
            </div>
        </div>

        <div class="chart-card">
            <div class="chart-header">
                <h5 class="chart-title">
                    <i class="fas fa-coins text-gold me-2"></i>
                    Recent Mining Rewards
                </h5>
            </div>
            <asp:Repeater ID="rptRewards" runat="server">
                <ItemTemplate>
                    <div class="reward-item">
                        <div class="reward-icon">
                            <i class="fas fa-hammer"></i>
                        </div>
                        <div class="reward-info">
                            <div class="reward-title">
                                <%# Eval("PlanName") %> - Daily Mining Reward
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
                    <p>Your mining rewards will appear here once your contracts start producing.</p>
                </div>
            </asp:Panel>
        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Tab switching
            var tabs = document.querySelectorAll('.mining-tab');
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
                                label: 'Mining Rewards (USDT)',
                                data: rewardsData.values,
                                borderColor: '#FFD700',
                                backgroundColor: 'rgba(255, 215, 0, 0.1)',
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
                                    borderColor: '#FFD700',
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
                            '<span class="text-white small fw-bold">' + distData.values[i].toFixed(2) + ' TH/s</span>' +
                            '</div>';
                    }
                    document.getElementById('distributionLegend').innerHTML = legendHtml;
                }
            } catch (e) { console.error('Distribution chart error:', e); }
        });
    </script>
</asp:Content>