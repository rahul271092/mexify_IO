<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="StakeNow.aspx.cs" Inherits="Mexify.Web.User.StakeNow" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .staking-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            flex-wrap: wrap;
            gap: 16px;
        }
        .staking-header h2 { color: var(--text-white); margin: 0; font-size: 1.8rem; }

        .staking-tabs {
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
        .staking-tab {
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
        .staking-tab.active {
            background: linear-gradient(135deg, #8B5CF6, #7C3AED);
            color: #fff;
            box-shadow: 0 4px 12px rgba(139, 92, 246, 0.3);
        }
        .staking-tab:hover:not(.active) {
            background: rgba(255, 255, 255, 0.05);
            color: var(--text-white);
        }

        .staking-hero {
            background: linear-gradient(135deg, rgba(139, 92, 246, 0.15), rgba(124, 58, 237, 0.1));
            border: 1px solid rgba(139, 92, 246, 0.3);
            border-radius: var(--radius-xl);
            padding: 40px;
            position: relative;
            overflow: hidden;
            margin-bottom: 32px;
        }
        .staking-hero::before {
            content: '';
            position: absolute;
            top: -50%; right: -10%;
            width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(139, 92, 246, 0.15) 0%, transparent 70%);
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
            font-size: 2.5rem;
            font-weight: 800;
            color: var(--text-white);
            font-family: 'Space Grotesk', sans-serif;
            margin-bottom: 4px;
        }
        .summary-value small { font-size: 1rem; color: var(--text-gray); }

        .stat-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 20px;
            text-align: center;
            transition: all 0.3s ease;
            height: 100%;
        }
        .stat-card:hover {
            transform: translateY(-3px);
            border-color: #8B5CF6;
        }
        .stat-card .icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            margin: 0 auto 12px;
        }
        .stat-card .icon.purple { background: rgba(139, 92, 246, 0.15); color: #8B5CF6; }
        .stat-card .icon.accent { background: rgba(0, 255, 178, 0.15); color: var(--accent); }
        .stat-card .icon.gold { background: rgba(255, 215, 0, 0.15); color: var(--gold); }
        .stat-card .icon.secondary { background: rgba(0, 212, 255, 0.15); color: var(--secondary); }
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

        .pool-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 24px;
            transition: all 0.3s ease;
            height: 100%;
            position: relative;
            overflow: hidden;
        }
        .pool-card:hover {
            transform: translateY(-5px);
            border-color: #8B5CF6;
            box-shadow: 0 15px 40px rgba(139, 92, 246, 0.15);
        }
        .pool-card.hot::before {
            content: '🔥 HOT';
            position: absolute;
            top: 12px;
            right: 12px;
            padding: 4px 10px;
            background: rgba(255, 59, 92, 0.9);
            color: #fff;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 700;
        }
        .pool-card.new::before {
            content: '✨ NEW';
            position: absolute;
            top: 12px;
            right: 12px;
            padding: 4px 10px;
            background: rgba(0, 255, 178, 0.9);
            color: #000;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 700;
        }
        .pool-header {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 20px;
        }
        .pool-icon {
            width: 56px;
            height: 56px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            flex-shrink: 0;
        }
        .pool-icon.pnc { background: linear-gradient(135deg, rgba(255, 215, 0, 0.2), rgba(255, 165, 0, 0.1)); color: var(--gold); border: 1px solid rgba(255, 215, 0, 0.3); }
        .pool-icon.btc { background: linear-gradient(135deg, rgba(247, 147, 26, 0.2), rgba(247, 147, 26, 0.05)); color: #F7931A; border: 1px solid rgba(247, 147, 26, 0.3); }
        .pool-icon.eth { background: linear-gradient(135deg, rgba(98, 126, 234, 0.2), rgba(98, 126, 234, 0.05)); color: #627EEA; border: 1px solid rgba(98, 126, 234, 0.3); }
        .pool-icon.usdt { background: linear-gradient(135deg, rgba(38, 161, 123, 0.2), rgba(38, 161, 123, 0.05)); color: #26A17B; border: 1px solid rgba(38, 161, 123, 0.3); }
        .pool-name {
            color: var(--text-white);
            font-weight: 700;
            font-size: 1.1rem;
            margin-bottom: 2px;
        }
        .pool-symbol {
            color: var(--text-muted);
            font-size: 0.85rem;
        }

        .pool-apy {
            text-align: center;
            padding: 16px;
            background: rgba(139, 92, 246, 0.08);
            border-radius: 12px;
            margin-bottom: 16px;
        }
        .apy-label {
            font-size: 0.75rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 4px;
        }
        .apy-value {
            font-size: 2rem;
            font-weight: 800;
            color: #8B5CF6;
            font-family: 'Space Grotesk', sans-serif;
        }
        .apy-value small {
            font-size: 0.9rem;
            color: var(--text-gray);
        }

        .pool-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-bottom: 16px;
        }
        .pool-stat {
            padding: 10px;
            background: rgba(255, 255, 255, 0.02);
            border-radius: 8px;
            text-align: center;
        }
        .pool-stat-label {
            font-size: 0.65rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }
        .pool-stat-value {
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-white);
        }

        .pool-lock-period {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 10px 14px;
            background: rgba(255, 215, 0, 0.05);
            border: 1px solid rgba(255, 215, 0, 0.2);
            border-radius: 8px;
            margin-bottom: 16px;
            font-size: 0.85rem;
        }
        .pool-lock-period i { color: var(--gold); }
        .pool-lock-period span { color: var(--text-gray); }
        .pool-lock-period strong { color: var(--text-white); }

        .btn-stake {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #8B5CF6, #7C3AED);
            border: none;
            border-radius: 10px;
            color: #fff;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            text-decoration: none;
        }
        .btn-stake:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(139, 92, 246, 0.4);
        }
        .btn-stake:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none;
        }

        .active-stake-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 20px;
            margin-bottom: 16px;
            transition: all 0.3s ease;
        }
        .active-stake-card:hover {
            border-color: #8B5CF6;
            transform: translateX(4px);
        }
        .active-stake-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
            flex-wrap: wrap;
            gap: 12px;
        }
        .active-stake-info {
            display: flex;
            align-items: center;
            gap: 14px;
        }
        .active-stake-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
            flex-shrink: 0;
        }
        .active-stake-title {
            color: var(--text-white);
            font-weight: 600;
            font-size: 1rem;
            margin-bottom: 2px;
        }
        .active-stake-meta {
            color: var(--text-muted);
            font-size: 0.8rem;
        }
        .active-stake-apy {
            text-align: right;
        }
        .active-stake-apy-value {
            color: #8B5CF6;
            font-weight: 800;
            font-size: 1.3rem;
        }
        .active-stake-apy-label {
            color: var(--text-muted);
            font-size: 0.7rem;
            text-transform: uppercase;
        }

        .stake-progress {
            margin-bottom: 16px;
        }
        .stake-progress-header {
            display: flex;
            justify-content: space-between;
            font-size: 0.8rem;
            margin-bottom: 6px;
        }
        .stake-progress-header .label { color: var(--text-muted); }
        .stake-progress-header .value { color: var(--text-white); font-weight: 600; }
        .stake-progress-bar {
            height: 8px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50px;
            overflow: hidden;
        }
        .stake-progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #8B5CF6, #7C3AED);
            border-radius: 50px;
            transition: width 1s ease;
            position: relative;
        }
        .stake-progress-fill::after {
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

        .stake-rewards {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
            padding: 16px 0;
            border-top: 1px solid var(--glass-border);
            border-bottom: 1px solid var(--glass-border);
            margin-bottom: 16px;
        }
        .stake-reward {
            text-align: center;
        }
        .stake-reward .label {
            font-size: 0.7rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }
        .stake-reward .value {
            font-size: 1rem;
            font-weight: 700;
            color: var(--text-white);
        }
        .stake-reward .value.accent { color: var(--accent); }
        .stake-reward .value.purple { color: #8B5CF6; }
        .stake-reward .value.gold { color: var(--gold); }

        .stake-actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        .btn-unstake {
            padding: 8px 16px;
            background: transparent;
            border: 1px solid rgba(255, 59, 92, 0.4);
            border-radius: 50px;
            color: #ff3b5c;
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .btn-unstake:hover {
            background: rgba(255, 59, 92, 0.1);
            border-color: #ff3b5c;
        }
        .btn-claim {
            padding: 8px 16px;
            background: linear-gradient(135deg, var(--accent), #00D4FF);
            border: none;
            border-radius: 50px;
            color: #000;
            font-size: 0.8rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .btn-claim:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 255, 178, 0.3);
        }

        .history-table {
            width: 100%;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            overflow: hidden;
        }
        .history-table table { width: 100%; color: var(--text-gray); }
        .history-table th {
            background: rgba(139, 92, 246, 0.08);
            padding: 14px 16px;
            color: var(--text-white);
            font-weight: 600;
            font-size: 0.8rem;
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
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        .status-active { background: rgba(0, 255, 178, 0.15); color: var(--accent); }
        .status-matured { background: rgba(139, 92, 246, 0.15); color: #8B5CF6; }
        .status-unstaked { background: rgba(107, 117, 141, 0.15); color: var(--text-muted); }
        .status-pending { background: rgba(255, 215, 0, 0.15); color: var(--gold); }

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

        .alert-box {
            padding: 14px 18px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 0.9rem;
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }
        .alert-box.info { background: rgba(139, 92, 246, 0.1); border: 1px solid rgba(139, 92, 246, 0.3); color: #8B5CF6; }
        .alert-box.warning { background: rgba(255, 215, 0, 0.1); border: 1px solid rgba(255, 215, 0, 0.3); color: var(--gold); }
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

        /* Modal Styles */
        .stake-modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.7);
            backdrop-filter: blur(5px);
            z-index: 9999;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .stake-modal-overlay.active { display: flex; }
        .stake-modal {
            background: var(--bg-secondary);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            max-width: 500px;
            width: 100%;
            max-height: 90vh;
            overflow-y: auto;
            animation: modalSlideUp 0.3s ease-out;
        }
        @keyframes modalSlideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .stake-modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 24px;
            border-bottom: 1px solid var(--glass-border);
        }
        .stake-modal-title {
            color: var(--text-white);
            font-weight: 700;
            font-size: 1.2rem;
            margin: 0;
        }
        .stake-modal-close {
            background: transparent;
            border: none;
            color: var(--text-muted);
            font-size: 1.5rem;
            cursor: pointer;
            padding: 0;
            line-height: 1;
        }
        .stake-modal-close:hover { color: var(--text-white); }
        .stake-modal-body { padding: 24px; }
        .stake-modal-footer {
            padding: 16px 24px;
            border-top: 1px solid var(--glass-border);
            display: flex;
            gap: 12px;
            justify-content: flex-end;
        }

        .form-group-custom { margin-bottom: 20px; }
        .form-group-custom label {
            display: block;
            color: var(--text-white);
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 8px;
        }
        .form-group-custom label .required { color: #ff3b5c; }
        .input-icon-wrap { position: relative; }
        .input-icon-wrap i.input-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            z-index: 2;
        }
        .input-icon-wrap input,
        .input-icon-wrap select {
            width: 100%;
            padding: 12px 14px 12px 42px;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--glass-border);
            border-radius: 10px;
            color: var(--text-white);
            font-size: 0.92rem;
            transition: all 0.3s ease;
        }
        .input-icon-wrap select option { background: var(--bg-secondary); color: var(--text-white); }
        .input-icon-wrap input:focus,
        .input-icon-wrap select:focus {
            outline: none;
            border-color: #8B5CF6;
            background: rgba(139, 92, 246, 0.03);
            box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.1);
        }
        .input-icon-wrap:focus-within i.input-icon { color: #8B5CF6; }

        .available-balance {
            padding: 12px 16px;
            background: rgba(0, 255, 178, 0.05);
            border: 1px solid rgba(0, 255, 178, 0.2);
            border-radius: 10px;
            color: var(--accent);
            font-weight: 700;
            margin-bottom: 16px;
        }

        .stake-summary {
            background: rgba(139, 92, 246, 0.05);
            border: 1px solid rgba(139, 92, 246, 0.2);
            border-radius: 10px;
            padding: 16px;
            margin-top: 16px;
        }
        .stake-summary-row {
            display: flex;
            justify-content: space-between;
            padding: 6px 0;
            font-size: 0.9rem;
        }
        .stake-summary-row .label { color: var(--text-muted); }
        .stake-summary-row .value { color: var(--text-white); font-weight: 600; }
        .stake-summary-row.total {
            border-top: 1px solid var(--glass-border);
            margin-top: 8px;
            padding-top: 12px;
            font-size: 1rem;
        }
        .stake-summary-row.total .value { color: #8B5CF6; font-weight: 800; }

        @media (max-width: 768px) {
            .summary-value { font-size: 1.8rem; }
            .stake-rewards { grid-template-columns: 1fr; }
            .staking-tabs { width: 100%; overflow-x: auto; }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Header -->
    <div class="staking-header" data-aos="fade-up">
        <div>
            <h2>Stake & Earn</h2>
            <p class="text-gray mb-0">Stake your crypto and earn passive rewards</p>
        </div>
    </div>

    <!-- Tabs -->
    <div class="staking-tabs" data-aos="fade-up">
        <button type="button" class="staking-tab active" data-tab="pools">
            <i class="fas fa-layer-group me-1"></i> Staking Pools
        </button>
        <button type="button" class="staking-tab" data-tab="active">
            <i class="fas fa-coins me-1"></i> My Stakes (<asp:Literal ID="litActiveCount" runat="server" Text="0"></asp:Literal>)
        </button>
        <button type="button" class="staking-tab" data-tab="rewards">
            <i class="fas fa-gift me-1"></i> Rewards
        </button>
        <button type="button" class="staking-tab" data-tab="history">
            <i class="fas fa-history me-1"></i> History
        </button>
    </div>

    <!-- POOLS TAB -->
    <div id="tab-pools" class="tab-content" data-aos="fade-up">
        
        <!-- Stats Overview -->
        <div class="staking-hero">
            <div class="row align-items-center position-relative" style="z-index: 2;">
                <div class="col-lg-6">
                    <div class="summary-label">Total Value Staked</div>
                    <div class="summary-value">
                        <asp:Literal ID="litTotalStaked" runat="server" Text="0.00"></asp:Literal>
                        <small> PNC</small>
                    </div>
                    <div style="color: var(--text-gray); font-size: 1.1rem;">
                        ≈ $<asp:Literal ID="litTotalStakedUSD" runat="server" Text="0.00"></asp:Literal> USD
                    </div>
                </div>
                <div class="col-lg-6 mt-3 mt-lg-0">
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="stat-card">
                                <div class="icon purple"><i class="fas fa-coins"></i></div>
                                <div class="value" style="color: #8B5CF6;">
                                    <asp:Literal ID="litActiveStakes" runat="server" Text="0"></asp:Literal>
                                </div>
                                <div class="label">Active Stakes</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stat-card">
                                <div class="icon accent"><i class="fas fa-chart-line"></i></div>
                                <div class="value" style="color: var(--accent);">
                                    <asp:Literal ID="litTotalEarned" runat="server" Text="0.00"></asp:Literal>
                                </div>
                                <div class="label">Total Earned</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Available Pools -->
        <h4 class="text-white mb-3" data-aos="fade-up">
            <i class="fas fa-fire" style="color: #8B5CF6;"></i>
            Available Staking Pools
        </h4>
        <div class="row g-4">
            <asp:Repeater ID="rptPools" runat="server">
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
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnlNoPools" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-layer-group"></i>
                <h4>No Staking Pools Available</h4>
                <p>New staking pools will be added soon.</p>
            </div>
        </asp:Panel>
    </div>

    <!-- ACTIVE STAKES TAB -->
    <div id="tab-active" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <asp:Repeater ID="rptActiveStakes" runat="server">
            <ItemTemplate>
                <div class="active-stake-card">
                    <div class="active-stake-header">
                        <div class="active-stake-info">
                            <div class='active-stake-icon pool-icon <%# Eval("CurrencyCode").ToString().ToLower() %>'>
                                <i class='<%# GetCurrencyIcon(Eval("CurrencyCode")) %>'></i>
                            </div>
                            <div>
                                <div class="active-stake-title"><%# Eval("PoolName") %></div>
                                <div class="active-stake-meta">
                                    Staked: <%# Convert.ToDateTime(Eval("StakedDate")).ToString("MMM dd, yyyy") %> · 
                                    <%# Eval("CurrencyCode") %>
                                </div>
                            </div>
                        </div>
                        <div class="active-stake-apy">
                            <div class="active-stake-apy-value"><%# string.Format("{0:0.##}", Eval("APY")) %>%</div>
                            <div class="active-stake-apy-label">APY</div>
                        </div>
                    </div>

                    <div class="stake-progress">
                        <div class="stake-progress-header">
                            <span class="label">Day <%# Eval("DaysStaked") %> of <%# Eval("LockPeriodDays") %></span>
                            <span class="value"><%# Eval("ProgressPercent") %>%</span>
                        </div>
                        <div class="stake-progress-bar">
                            <div class="stake-progress-fill" style="width: <%# Eval("ProgressPercent") %>%;"></div>
                        </div>
                    </div>

                    <div class="stake-rewards">
                        <div class="stake-reward">
                            <div class="label">Staked Amount</div>
                            <div class="value"><%# string.Format("{0:0.########}", Eval("StakedAmount")) %> <%# Eval("CurrencyCode") %></div>
                        </div>
                        <div class="stake-reward">
                            <div class="label">Earned Rewards</div>
                            <div class="value accent">+<%# string.Format("{0:0.########}", Eval("EarnedRewards")) %> <%# Eval("CurrencyCode") %></div>
                        </div>
                        <div class="stake-reward">
                            <div class="label">Pending Rewards</div>
                            <div class="value purple">+<%# string.Format("{0:0.########}", Eval("PendingRewards")) %> <%# Eval("CurrencyCode") %></div>
                        </div>
                    </div>

                    <div class="stake-actions">
                        <asp:Panel runat="server" Visible='<%# Convert.ToDecimal(Eval("PendingRewards")) > 0 %>'>
                            <button type="button" class="btn-claim" onclick='claimRewards(<%# Eval("StakeId") %>)'>
                                <i class="fas fa-gift me-1"></i> Claim Rewards
                            </button>
                        </asp:Panel>
                        <asp:Panel runat="server" Visible='<%# Convert.ToInt32(Eval("ProgressPercent")) >= 100 %>'>
                            <button type="button" class="btn-unstake" onclick='unstake(<%# Eval("StakeId") %>)'>
                                <i class="fas fa-unlock me-1"></i> Unstake
                            </button>
                        </asp:Panel>
                        <asp:Panel runat="server" Visible='<%# Convert.ToInt32(Eval("ProgressPercent")) < 100 %>'>
                            <small class="text-muted">
                                <i class="fas fa-clock me-1"></i>
                                Unlocks in <%# Eval("DaysRemaining") %> days
                            </small>
                        </asp:Panel>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoActiveStakes" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-coins"></i>
                <h4>No Active Stakes</h4>
                <p>Start staking to earn passive rewards.</p>
                <button type="button" class="btn-stake" style="max-width: 200px;" onclick="document.querySelector('[data-tab=pools]').click()">
                    <i class="fas fa-layer-group me-2"></i> View Pools
                </button>
            </div>
        </asp:Panel>
    </div>

    <!-- REWARDS TAB -->
    <div id="tab-rewards" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="stat-card" style="padding: 24px;">
                    <div class="summary-label">Total Rewards Earned</div>
                    <div class="summary-value" style="color: var(--accent);">
                        <asp:Literal ID="litTotalRewards" runat="server" Text="0.00"></asp:Literal>
                    </div>
                    <small class="text-muted">PNC</small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card" style="padding: 24px;">
                    <div class="summary-label">This Month</div>
                    <div class="summary-value" style="color: #8B5CF6;">
                        <asp:Literal ID="litMonthRewards" runat="server" Text="0.00"></asp:Literal>
                    </div>
                    <small class="text-muted">PNC</small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card" style="padding: 24px;">
                    <div class="summary-label">Pending Claims</div>
                    <div class="summary-value" style="color: var(--gold);">
                        <asp:Literal ID="litPendingRewards" runat="server" Text="0.00"></asp:Literal>
                    </div>
                    <small class="text-muted">PNC</small>
                </div>
            </div>
        </div>

        <!-- Rewards Chart -->
        <div class="chart-card mb-4">
            <div class="chart-header">
                <h5 class="chart-title">Rewards Over Time (Last 30 Days)</h5>
            </div>
            <div style="height: 280px;">
                <canvas id="rewardsChart"></canvas>
            </div>
        </div>

        <!-- Recent Claims -->
        <div class="chart-card">
            <div class="chart-header">
                <h5 class="chart-title">
                    <i class="fas fa-gift" style="color: var(--accent);"></i>
                    Recent Reward Claims
                </h5>
            </div>
            <asp:Repeater ID="rptRewardClaims" runat="server">
                <ItemTemplate>
                    <div class="commission-item">
                        <div class="commission-icon" style="background: rgba(139, 92, 246, 0.15); color: #8B5CF6;">
                            <i class="fas fa-gift"></i>
                        </div>
                        <div class="commission-info">
                            <div class="commission-title"><%# Eval("PoolName") %> Reward</div>
                            <div class="commission-date">
                                <%# Convert.ToDateTime(Eval("ClaimDate")).ToString("MMM dd, yyyy 'at' hh:mm tt") %>
                            </div>
                        </div>
                        <div class="commission-amount" style="color: var(--accent);">
                            +<%# string.Format("{0:0.########}", Eval("Amount")) %> <%# Eval("CurrencyCode") %>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:Panel ID="pnlNoClaims" runat="server" Visible="false">
                <div class="empty-state">
                    <i class="fas fa-gift"></i>
                    <h4>No Rewards Claimed Yet</h4>
                    <p>Claim your staking rewards to see them here.</p>
                </div>
            </asp:Panel>
        </div>
    </div>

    <!-- HISTORY TAB -->
    <div id="tab-history" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <div class="history-table">
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Pool</th>
                            <th>Amount</th>
                            <th>APY</th>
                            <th>Duration</th>
                            <th>Rewards</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptHistory" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td class="text-muted"><%# Convert.ToDateTime(Eval("StakedDate")).ToString("MMM dd, yyyy") %></td>
                                    <td class="text-white"><%# Eval("PoolName") %></td>
                                    <td><%# string.Format("{0:0.########}", Eval("StakedAmount")) %> <%# Eval("CurrencyCode") %></td>
                                    <td><%# string.Format("{0:0.##}", Eval("APY")) %>%</td>
                                    <td class="text-muted"><%# Eval("LockPeriodDays") %> Days</td>
                                    <td class="text-accent">+<%# string.Format("{0:0.########}", Eval("TotalRewards")) %></td>
                                    <td>
                                        <span class='status-badge <%# GetStatusClass(Eval("Status")) %>'>
                                            <%# Eval("StatusName") %>
                                        </span>
                                    </td>
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
                <p>Your staking history will appear here.</p>
            </div>
        </asp:Panel>
    </div>

    <!-- Stake Modal -->
    <div class="stake-modal-overlay" id="stakeModal">
        <div class="stake-modal">
            <div class="stake-modal-header">
                <h5 class="stake-modal-title" id="modalPoolName">Stake PNC</h5>
                <button type="button" class="stake-modal-close" onclick="closeStakeModal()">&times;</button>
            </div>
            <div class="stake-modal-body">
                <input type="hidden" id="modalPoolId" />
                <input type="hidden" id="modalAPY" />
                <input type="hidden" id="modalMinStake" />
                <input type="hidden" id="modalLockDays" />

                <div class="available-balance">
                    Available Balance: <span id="modalAvailableBalance">0.00</span> PNC
                </div>

                <div class="form-group-custom">
                    <label>Stake Amount <span class="required">*</span></label>
                    <div class="input-icon-wrap">
                        <input type="number" id="modalStakeAmount" placeholder="0.00" step="0.00000001" oninput="updateStakeSummary()" />
                        <i class="fas fa-coins input-icon"></i>
                    </div>
                    <div class="d-flex gap-2 mt-2">
                        <button type="button" class="wallet-card-btn" onclick="setStakePercent(25)" style="flex:1; padding: 6px; font-size: 0.75rem;">25%</button>
                        <button type="button" class="wallet-card-btn" onclick="setStakePercent(50)" style="flex:1; padding: 6px; font-size: 0.75rem;">50%</button>
                        <button type="button" class="wallet-card-btn" onclick="setStakePercent(75)" style="flex:1; padding: 6px; font-size: 0.75rem;">75%</button>
                        <button type="button" class="wallet-card-btn" onclick="setStakePercent(100)" style="flex:1; padding: 6px; font-size: 0.75rem;">Max</button>
                    </div>
                </div>

                <div class="stake-summary">
                    <div class="stake-summary-row">
                        <span class="label">APY</span>
                        <span class="value" id="modalAPYDisplay">0%</span>
                    </div>
                    <div class="stake-summary-row">
                        <span class="label">Lock Period</span>
                        <span class="value" id="modalLockDisplay">0 Days</span>
                    </div>
                    <div class="stake-summary-row">
                        <span class="label">Daily Rewards</span>
                        <span class="value" id="modalDailyRewards">0.00</span>
                    </div>
                    <div class="stake-summary-row">
                        <span class="label">Total Rewards</span>
                        <span class="value" id="modalTotalRewards">0.00</span>
                    </div>
                    <div class="stake-summary-row total">
                        <span class="label">You'll Receive</span>
                        <span class="value" id="modalTotalReceive">0.00</span>
                    </div>
                </div>

                <div class="alert-box warning mt-3">
                    <i class="fas fa-exclamation-triangle"></i>
                    <div>
                        <strong class="text-white">Important:</strong> Staked tokens are locked for the specified period. Early unstaking may incur penalties.
                    </div>
                </div>
            </div>
            <div class="stake-modal-footer">
                <button type="button" class="btn-outline-glass" onclick="closeStakeModal()">Cancel</button>
                <button type="button" class="btn-stake" onclick="confirmStake()" style="width: auto; padding: 10px 24px;">
                    <i class="fas fa-coins me-1"></i> Confirm Stake
                </button>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="hfActiveTab" runat="server" Value="pools" />
    <asp:HiddenField ID="hfUserBalance" runat="server" Value="0" />
</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        // Tab switching
        (function() {
            'use strict';
            
            function initStakingTabs() {
                var tabs = document.querySelectorAll('.staking-tab');
                var contents = document.querySelectorAll('.tab-content');
                var activeTabInput = document.getElementById('<%= hfActiveTab.ClientID %>');
                
                if (!tabs.length || !contents.length) {
                    setTimeout(initStakingTabs, 100);
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

                var tabToShow = 'pools';
                if (activeTabInput && activeTabInput.value) {
                    tabToShow = activeTabInput.value;
                }
                switchTab(tabToShow);
            }

            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', initStakingTabs);
            } else {
                initStakingTabs();
            }
        })();

        // Stake Modal Functions
        function openStakeModal(poolId, poolName, currency, apy, minStake, lockDays) {
            document.getElementById('modalPoolId').value = poolId;
            document.getElementById('modalPoolName').textContent = 'Stake ' + poolName;
            document.getElementById('modalAPY').value = apy;
            document.getElementById('modalMinStake').value = minStake;
            document.getElementById('modalLockDays').value = lockDays;
            document.getElementById('modalAPYDisplay').textContent = apy + '% APY';
            document.getElementById('modalLockDisplay').textContent = lockDays + ' Days';
            
            var balance = parseFloat(document.getElementById('<%= hfUserBalance.ClientID %>').value) || 0;
            document.getElementById('modalAvailableBalance').textContent = balance.toFixed(8);
            
            document.getElementById('modalStakeAmount').value = '';
            updateStakeSummary();
            
            document.getElementById('stakeModal').classList.add('active');
        }

        function closeStakeModal() {
            document.getElementById('stakeModal').classList.remove('active');
        }

        function setStakePercent(percent) {
            var balance = parseFloat(document.getElementById('<%= hfUserBalance.ClientID %>').value) || 0;
            var amount = (balance * percent / 100);
            var minStake = parseFloat(document.getElementById('modalMinStake').value) || 0;
            if (amount < minStake && percent === 100) amount = balance;
            document.getElementById('modalStakeAmount').value = amount.toFixed(8);
            updateStakeSummary();
        }

        function updateStakeSummary() {
            var amount = parseFloat(document.getElementById('modalStakeAmount').value) || 0;
            var apy = parseFloat(document.getElementById('modalAPY').value) || 0;
            var lockDays = parseInt(document.getElementById('modalLockDays').value) || 0;
            
            var dailyRate = apy / 365 / 100;
            var dailyRewards = amount * dailyRate;
            var totalRewards = dailyRewards * lockDays;
            var totalReceive = amount + totalRewards;
            
            document.getElementById('modalDailyRewards').textContent = dailyRewards.toFixed(8);
            document.getElementById('modalTotalRewards').textContent = totalRewards.toFixed(8);
            document.getElementById('modalTotalReceive').textContent = totalReceive.toFixed(8);
        }

        function confirmStake() {
            var poolId = document.getElementById('modalPoolId').value;
            var amount = parseFloat(document.getElementById('modalStakeAmount').value) || 0;
            var minStake = parseFloat(document.getElementById('modalMinStake').value) || 0;
            var balance = parseFloat(document.getElementById('<%= hfUserBalance.ClientID %>').value) || 0;
            
            if (amount <= 0) {
                alert('Please enter a valid amount.');
                return;
            }
            if (amount < minStake) {
                alert('Minimum stake amount is ' + minStake);
                return;
            }
            if (amount > balance) {
                alert('Insufficient balance.');
                return;
            }
            
            // Submit via AJAX or form post
            window.location.href = '<%= ResolveUrl("~/User/StakeNow.aspx") %>?action=stake&pool=' + poolId + '&amount=' + amount;
        }

        function claimRewards(stakeId) {
            if (confirm('Claim rewards for this stake?')) {
                window.location.href = '<%= ResolveUrl("~/User/StakeNow.aspx") %>?action=claim&stake=' + stakeId;
            }
        }

        function unstake(stakeId) {
            if (confirm('Are you sure you want to unstake? This will return your staked amount plus earned rewards.')) {
                window.location.href = '<%= ResolveUrl("~/User/StakeNow.aspx") %>?action=unstake&stake=' + stakeId;
            }
        }

        // Close modal on overlay click
        document.getElementById('stakeModal').addEventListener('click', function(e) {
            if (e.target === this) closeStakeModal();
        });

        // Rewards Chart
        var rewardsData = <%= GetRewardsChartData() %>;
        document.addEventListener('DOMContentLoaded', function() {
            var ctx = document.getElementById('rewardsChart');
            if (ctx && rewardsData.labels && rewardsData.labels.length > 0) {
                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: rewardsData.labels,
                        datasets: [{
                            label: 'Rewards (PNC)',
                            data: rewardsData.values,
                            borderColor: '#8B5CF6',
                            backgroundColor: 'rgba(139, 92, 246, 0.1)',
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
                                borderColor: '#8B5CF6',
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
        });
    </script>
</asp:Content>
