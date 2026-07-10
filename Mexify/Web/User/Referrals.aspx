<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="Referrals.aspx.cs" Inherits="Mexify.Web.User.Referrals" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .ref-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            flex-wrap: wrap;
            gap: 16px;
        }
        .ref-header h2 { color: var(--text-white); margin: 0; font-size: 1.8rem; }

        .ref-tabs {
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
        .ref-tab {
            padding: 10px 20px;
            border-radius: 50px;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-gray);
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            background: transparent;
        }
        .ref-tab.active {
            background: linear-gradient(135deg, #10B981, #059669);
            color: #fff;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
        }
        .ref-tab:hover:not(.active) {
            background: rgba(255, 255, 255, 0.05);
            color: var(--text-white);
        }

        .ref-hero {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.15), rgba(5, 150, 105, 0.1));
            border: 1px solid rgba(16, 185, 129, 0.3);
            border-radius: var(--radius-xl);
            padding: 40px;
            position: relative;
            overflow: hidden;
            margin-bottom: 32px;
        }
        .ref-hero::before {
            content: '';
            position: absolute;
            top: -50%; right: -10%;
            width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(16, 185, 129, 0.15) 0%, transparent 70%);
            animation: float 15s ease-in-out infinite;
        }
        @keyframes float {
            0%,100%{transform:translate(0,0) scale(1)}
            50%{transform:translate(20px,-20px) scale(1.1)}
        }

        .ref-link-box {
            background: rgba(0, 0, 0, 0.3);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-md);
            padding: 16px;
            display: flex;
            align-items: center;
            gap: 12px;
            margin-top: 20px;
            flex-wrap: wrap;
        }
        .ref-link-input {
            flex: 1;
            min-width: 200px;
            background: transparent;
            border: none;
            color: #10B981;
            font-family: 'Courier New', monospace;
            font-size: 0.95rem;
            padding: 8px 0;
            outline: none;
        }
        .ref-link-input::selection { background: #10B981; color: #000; }
        .copy-btn {
            padding: 10px 20px;
            background: linear-gradient(135deg, #10B981, #059669);
            border: none;
            border-radius: 50px;
            color: #fff;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .copy-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(16, 185, 129, 0.4);
        }
        .share-buttons {
            display: flex;
            gap: 10px;
            margin-top: 16px;
            flex-wrap: wrap;
        }
        .share-btn {
            width: 42px; height: 42px;
            display: flex; align-items: center; justify-content: center;
            border-radius: 50%;
            color: #fff;
            text-decoration: none;
            transition: all 0.3s ease;
            border: 1px solid var(--glass-border);
        }
        .share-btn:hover { transform: translateY(-3px); }
        .share-btn.whatsapp { background: #25D366; border-color: #25D366; }
        .share-btn.telegram { background: #0088cc; border-color: #0088cc; }
        .share-btn.twitter { background: #1DA1F2; border-color: #1DA1F2; }
        .share-btn.facebook { background: #4267B2; border-color: #4267B2; }
        .share-btn.copy { background: var(--glass-bg); color: var(--text-gray); }

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
        }
        .stat-card:hover {
            transform: translateY(-3px);
            border-color: #10B981;
        }
        .stat-card .value {
            font-size: 1.8rem;
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

        .rank-card {
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.1), rgba(255, 165, 0, 0.05));
            border: 1px solid rgba(255, 215, 0, 0.3);
            border-radius: var(--radius-lg);
            padding: 28px;
            position: relative;
            overflow: hidden;
        }
        .rank-badge {
            width: 80px; height: 80px;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 2rem;
            margin-bottom: 16px;
        }
        .rank-badge.bronze { background: linear-gradient(135deg, #CD7F32, #8B4513); color: #fff; }
        .rank-badge.silver { background: linear-gradient(135deg, #C0C0C0, #808080); color: #fff; }
        .rank-badge.gold { background: linear-gradient(135deg, #FFD700, #FFA500); color: #000; }
        .rank-badge.platinum { background: linear-gradient(135deg, #E5E4E2, #A8A9AD); color: #000; }
        .rank-badge.diamond { background: linear-gradient(135deg, #B9F2FF, #40E0D0); color: #000; }
        .rank-progress-bar {
            height: 8px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50px;
            overflow: hidden;
            margin: 16px 0 8px;
        }
        .rank-progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #FFD700, #FFA500);
            border-radius: 50px;
            transition: width 1s ease;
        }
        .rank-levels {
            display: flex;
            justify-content: space-between;
            margin-top: 16px;
            font-size: 0.7rem;
        }
        .rank-level {
            text-align: center;
            color: var(--text-muted);
        }
        .rank-level.current { color: var(--gold); font-weight: 700; }
        .rank-level.achieved { color: var(--accent); }

        .level-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap: 12px;
        }
        .level-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-md);
            padding: 16px;
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .level-card:hover {
            transform: translateY(-3px);
            border-color: #10B981;
        }
        .level-card.eligible {
            border-color: rgba(16, 185, 129, 0.4);
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.08), transparent);
        }
        .level-card.locked {
            opacity: 0.5;
        }
        .level-number {
            display: inline-block;
            padding: 4px 12px;
            background: rgba(16, 185, 129, 0.15);
            color: #10B981;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 700;
            margin-bottom: 8px;
        }
        .level-percent {
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--text-white);
            margin: 8px 0;
        }
        .level-stats {
            display: flex;
            justify-content: space-around;
            margin-top: 12px;
            padding-top: 12px;
            border-top: 1px solid var(--glass-border);
        }
        .level-stat {
            text-align: center;
        }
        .level-stat small {
            display: block;
            font-size: 0.65rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .level-stat .value {
            font-size: 0.95rem;
            font-weight: 700;
            color: var(--text-white);
        }
        .level-stat .value.accent { color: #10B981; }
        .level-lock {
            position: absolute;
            top: 8px;
            right: 8px;
            color: var(--text-muted);
            font-size: 0.9rem;
        }

        .team-member-item {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 14px 16px;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-md);
            margin-bottom: 10px;
            transition: all 0.3s ease;
        }
        .team-member-item:hover {
            border-color: #10B981;
            transform: translateX(4px);
        }
        .team-avatar {
            width: 44px; height: 44px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #10B981;
            flex-shrink: 0;
        }
        .team-info { flex: 1; min-width: 0; }
        .team-name { color: var(--text-white); font-weight: 600; font-size: 0.95rem; }
        .team-meta { color: var(--text-muted); font-size: 0.75rem; }
        .team-stats {
            display: flex;
            gap: 16px;
            align-items: center;
        }
        .team-stat { text-align: right; }
        .team-stat small {
            display: block;
            color: var(--text-muted);
            font-size: 0.65rem;
            text-transform: uppercase;
        }
        .team-stat .value {
            color: var(--text-white);
            font-weight: 700;
            font-size: 0.9rem;
        }
        .team-stat .value.accent { color: #10B981; }

        .commission-item {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 14px 0;
            border-bottom: 1px solid var(--glass-border);
        }
        .commission-item:last-child { border-bottom: none; }
        .commission-icon {
            width: 42px; height: 42px;
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            background: rgba(16, 185, 129, 0.15);
            color: #10B981;
            flex-shrink: 0;
            font-size: 1rem;
        }
        .commission-info { flex: 1; min-width: 0; }
        .commission-title { color: var(--text-white); font-weight: 600; font-size: 0.9rem; margin-bottom: 2px; }
        .commission-date { color: var(--text-muted); font-size: 0.75rem; }
        .commission-amount {
            color: #10B981;
            font-weight: 700;
            font-size: 1rem;
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
            flex-wrap: wrap;
            gap: 12px;
        }
        .chart-title {
            color: var(--text-white);
            font-weight: 700;
            font-size: 1.1rem;
            margin: 0;
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
            background: rgba(16, 185, 129, 0.08);
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
        .status-pending { background: rgba(255, 215, 0, 0.15); color: var(--gold); }
        .status-inactive { background: rgba(107, 117, 141, 0.15); color: var(--text-muted); }

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
        .alert-box.info { background: rgba(16, 185, 129, 0.1); border: 1px solid rgba(16, 185, 129, 0.3); color: #10B981; }
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

        .filter-bar {
            display: flex;
            gap: 12px;
            margin-bottom: 20px;
            flex-wrap: wrap;
            align-items: center;
        }
        .filter-bar select {
            padding: 8px 14px;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 8px;
            color: var(--text-white);
            font-size: 0.85rem;
        }
        .filter-bar select option { background: var(--bg-secondary); }

        .eligibility-banner {
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.1), rgba(255, 165, 0, 0.05));
            border: 1px solid rgba(255, 215, 0, 0.3);
            border-radius: var(--radius-lg);
            padding: 20px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .eligibility-banner.active {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(5, 150, 105, 0.05));
            border-color: rgba(16, 185, 129, 0.3);
        }
        .eligibility-icon {
            width: 50px; height: 50px;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.3rem;
            flex-shrink: 0;
        }
        .eligibility-banner .eligibility-icon {
            background: rgba(255, 215, 0, 0.2);
            color: var(--gold);
        }
        .eligibility-banner.active .eligibility-icon {
            background: rgba(16, 185, 129, 0.2);
            color: #10B981;
        }

        @media (max-width: 768px) {
            .summary-value { font-size: 1.8rem; }
            .level-grid { grid-template-columns: repeat(2, 1fr); }
            .team-stats { flex-direction: column; gap: 4px; }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Header -->
    <div class="ref-header" data-aos="fade-up">
        <div>
            <h2>Referrals & Networking Income</h2>
            <p class="text-gray mb-0">Earn from 15 levels of your network</p>
        </div>
    </div>

    <!-- Tabs -->
    <div class="ref-tabs" data-aos="fade-up">
        <button class="ref-tab active" data-tab="overview">
            <i class="fas fa-chart-pie me-1"></i> Overview
        </button>
        <button class="ref-tab" data-tab="team">
            <i class="fas fa-users me-1"></i> My Team
        </button>
        <button class="ref-tab" data-tab="levels">
            <i class="fas fa-layer-group me-1"></i> 15 Levels
        </button>
        <button class="ref-tab" data-tab="commissions">
            <i class="fas fa-coins me-1"></i> Commissions
        </button>
        <button class="ref-tab" data-tab="history">
            <i class="fas fa-history me-1"></i> History
        </button>
    </div>

    <!-- OVERVIEW TAB -->
    <div id="tab-overview" class="tab-content" data-aos="fade-up">
        
        <!-- Referral Link Hero -->
        <div class="ref-hero">
            <div class="row align-items-center position-relative" style="z-index: 2;">
                <div class="col-lg-8">
                    <small class="text-secondary">
                        <i class="fas fa-share-alt me-1"></i> Your Unique Referral Link
                    </small>
                    <h3 class="text-white mb-2">Invite Friends & Earn Passive Income</h3>
                    <p class="text-gray mb-0">Share your link and earn commissions from 15 levels of your network.</p>
                    
                    <div class="ref-link-box">
                        <i class="fas fa-link" style="color: #10B981;"></i>
                        <input type="text" class="ref-link-input" id="referralLink" 
                               value='<%= ReferralLink %>' readonly>
                        <button type="button" class="copy-btn" onclick="copyReferralLink()">
                            <i class="fas fa-copy"></i> Copy
                        </button>
                    </div>

                    <div class="share-buttons">
                        <a href="#" class="share-btn whatsapp" onclick="shareWhatsApp()" title="Share on WhatsApp"><i class="fab fa-whatsapp"></i></a>
                        <a href="#" class="share-btn telegram" onclick="shareTelegram()" title="Share on Telegram"><i class="fab fa-telegram"></i></a>
                        <a href="#" class="share-btn twitter" onclick="shareTwitter()" title="Share on Twitter"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="share-btn facebook" onclick="shareFacebook()" title="Share on Facebook"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="share-btn copy" onclick="copyReferralLink()" title="Copy Link"><i class="fas fa-copy"></i></a>
                    </div>
                </div>
                <div class="col-lg-4 text-center mt-4 mt-lg-0">
                    <div style="background: #fff; padding: 12px; border-radius: 12px; display: inline-block;">
                        <img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=<%= Server.UrlEncode(ReferralLink) %>" 
                             alt="QR Code" width="150" height="150">
                    </div>
                    <small class="text-muted d-block mt-2">Scan to register</small>
                </div>
            </div>
        </div>

        <!-- Eligibility Banner -->
        <asp:Panel ID="pnlEligibility" runat="server">
            <div class='eligibility-banner <%# IsEligible ? "active" : "" %>'>
                <div class="eligibility-icon">
                    <i class='<%# IsEligible ? "fas fa-check-circle" : "fas fa-exclamation-triangle" %>'></i>
                </div>
                <div>
                    <h5 class="text-white mb-1">
                        <%# IsEligible ? "✓ Eligible for 15-Level Income" : "⚠ Not Eligible Yet" %>
                    </h5>
                    <p class="text-gray mb-0">
                        <%# IsEligible ? "You have at least 1 direct referral. All 15 levels are active!" : "You need at least 1 direct referral to activate the 15-level income program." %>
                    </p>
                </div>
            </div>
        </asp:Panel>

        <!-- Stats Cards -->
        <div class="row g-4 mb-4">
            <div class="col-md-6 col-lg-3" data-aos="fade-up">
                <div class="stat-card">
                    <div class="value" style="color: #10B981;">
                        <asp:Literal ID="litDirectReferrals" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="label">Direct Referrals</div>
                </div>
            </div>
            <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="100">
                <div class="stat-card">
                    <div class="value">
                        <asp:Literal ID="litTotalTeam" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="label">Total Team Size</div>
                </div>
            </div>
            <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="200">
                <div class="stat-card">
                    <div class="value" style="color: var(--gold);">
                        <asp:Literal ID="litTotalCommission" runat="server" Text="0.00"></asp:Literal>
                    </div>
                    <div class="label">Total Commission (PNC)</div>
                </div>
            </div>
            <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="300">
                <div class="stat-card">
                    <div class="value" style="color: var(--secondary);">
                        <asp:Literal ID="litMonthCommission" runat="server" Text="0.00"></asp:Literal>
                    </div>
                    <div class="label">This Month (PNC)</div>
                </div>
            </div>
        </div>

        <!-- Charts Row -->
        <div class="row g-4 mb-4">
            <div class="col-lg-8" data-aos="fade-up">
                <div class="chart-card">
                    <div class="chart-header">
                        <h5 class="chart-title">Commission Earnings Over Time</h5>
                    </div>
                    <div style="height: 280px;">
                        <canvas id="commissionChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-lg-4" data-aos="fade-up" data-aos-delay="100">
                <div class="chart-card h-100">
                    <div class="chart-header">
                        <h5 class="chart-title">Earnings by Level</h5>
                    </div>
                    <div style="height: 220px;">
                        <canvas id="levelChart"></canvas>
                    </div>
                    <div id="levelLegend" class="mt-3"></div>
                </div>
            </div>
        </div>

        <!-- Rank Card -->
        <div class="row g-4">
            <div class="col-lg-6" data-aos="fade-up">
                <div class="rank-card h-100">
                    <div class="rank-badge <%# CurrentRankClass %>">
                        <i class='<%# CurrentRankIcon %>'></i>
                    </div>
                    <h4 class="text-white mb-1"><asp:Literal ID="litRankName" runat="server" Text="Bronze"></asp:Literal> Rank</h4>
                    <p class="text-gray small mb-3"><asp:Literal ID="litRankRequirement" runat="server"></asp:Literal></p>
                    
                    <div class="rank-progress-bar">
                        <div class="rank-progress-fill" style="width: <%# RankProgress %>%;"></div>
                    </div>
                    <small class="text-muted"><asp:Literal ID="litRankProgress" runat="server"></asp:Literal></small>

                    <div class="rank-levels">
                        <div class='rank-level <%# IsRankAchieved("Bronze") ? "achieved" : (IsRankCurrent("Bronze") ? "current" : "") %>'>
                            <i class="fas fa-medal"></i><br>Bronze
                        </div>
                        <div class='rank-level <%# IsRankAchieved("Silver") ? "achieved" : (IsRankCurrent("Silver") ? "current" : "") %>'>
                            <i class="fas fa-medal"></i><br>Silver
                        </div>
                        <div class='rank-level <%# IsRankAchieved("Gold") ? "achieved" : (IsRankCurrent("Gold") ? "current" : "") %>'>
                            <i class="fas fa-medal"></i><br>Gold
                        </div>
                        <div class='rank-level <%# IsRankAchieved("Platinum") ? "achieved" : (IsRankCurrent("Platinum") ? "current" : "") %>'>
                            <i class="fas fa-medal"></i><br>Platinum
                        </div>
                        <div class='rank-level <%# IsRankAchieved("Diamond") ? "achieved" : (IsRankCurrent("Diamond") ? "current" : "") %>'>
                            <i class="fas fa-gem"></i><br>Diamond
                        </div>
                    </div>

                    <div class="mt-4 pt-3" style="border-top: 1px solid var(--glass-border);">
                        <h6 class="text-white mb-2">Rank Benefits</h6>
                        <ul class="list-unstyled text-gray small mb-0">
                            <li><i class="fas fa-check text-accent me-2"></i> Base commission: 15 levels</li>
                            <li><i class="fas fa-check text-accent me-2"></i> Monthly bonus: <asp:Literal ID="litRankBonus" runat="server" Text="500 PNC"></asp:Literal></li>
                            <li><i class="fas fa-check text-accent me-2"></i> Priority support</li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Recent Commissions -->
            <div class="col-lg-6" data-aos="fade-up" data-aos-delay="100">
                <div class="chart-card h-100">
                    <div class="chart-header">
                        <h5 class="chart-title">
                            <i class="fas fa-gift" style="color: #10B981;"></i>
                            Recent Commissions
                        </h5>
                        <button class="ref-tab" onclick="document.querySelector('[data-tab=commissions]').click()">View All</button>
                    </div>
                    <asp:Repeater ID="rptRecentCommissions" runat="server">
                        <ItemTemplate>
                            <div class="commission-item">
                                <div class="commission-icon">
                                    <i class="fas fa-hand-holding-usd"></i>
                                </div>
                                <div class="commission-info">
                                    <div class="commission-title">
                                        Level <%# Eval("Level") %> Commission
                                        <small class="text-muted">from <%# Eval("ReferralName") %></small>
                                    </div>
                                    <div class="commission-date">
                                        <%# Convert.ToDateTime(Eval("CreatedDate")).ToString("MMM dd, yyyy 'at' hh:mm tt") %>
                                    </div>
                                </div>
                                <div class="commission-amount">
                                    +<%# string.Format("{0:0.00}", Eval("Amount")) %> PNC
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlNoCommissions" runat="server" Visible="false">
                        <div class="empty-state">
                            <i class="fas fa-coins"></i>
                            <h4>No Commissions Yet</h4>
                            <p>Share your referral link to start earning!</p>
                        </div>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </div>

    <!-- TEAM TAB -->
    <div id="tab-team" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <div class="filter-bar">
            <select id="filterLevel" onchange="filterTeam()">
                <option value="all">All Levels</option>
                <option value="1">Level 1 (Direct)</option>
                <option value="2">Level 2</option>
                <option value="3">Level 3</option>
                <option value="4">Level 4</option>
                <option value="5">Level 5</option>
            </select>
            <select id="filterStatus" onchange="filterTeam()">
                <option value="all">All Status</option>
                <option value="active">Active</option>
                <option value="inactive">Inactive</option>
            </select>
        </div>

        <asp:Repeater ID="rptTeam" runat="server">
            <ItemTemplate>
                <div class="team-member-item" 
                     data-level='<%# Eval("Level") %>' 
                     data-status='<%# Convert.ToBoolean(Eval("IsActive")) ? "active" : "inactive" %>'>
                    <img src='<%# Eval("PhotoUrl") %>' 
                         alt='<%# Eval("Name") %>' 
                         class="team-avatar"
                         onerror="this.src='https://ui-avatars.com/api/?name=<%# Eval("Name") %>&background=10B981&color=fff'">
                    <div class="team-info">
                        <div class="team-name"><%# Eval("Name") %></div>
                        <div class="team-meta">
                            Level <%# Eval("Level") %> · 
                            Joined <%# Convert.ToDateTime(Eval("JoinDate")).ToString("MMM dd, yyyy") %>
                        </div>
                    </div>
                    <div class="team-stats">
                        <div class="team-stat">
                            <small>Invested</small>
                            <div class="value"><%# string.Format("{0:0.00}", Eval("InvestedAmount")) %> PNC</div>
                        </div>
                        <div class="team-stat">
                            <small>Your Earnings</small>
                            <div class="value accent">+<%# string.Format("{0:0.00}", Eval("YourEarnings")) %> PNC</div>
                        </div>
                        <div class="team-stat">
                            <small>Status</small>
                            <span class='status-badge <%# Convert.ToBoolean(Eval("IsActive")) ? "status-active" : "status-inactive" %>'>
                                <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %>
                            </span>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoTeam" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-users"></i>
                <h4>No Team Members Yet</h4>
                <p>Share your referral link to start building your team.</p>
                <button type="button" class="btn btn-primary-glow" onclick="copyReferralLink()">
                    <i class="fas fa-copy me-2"></i> Copy Referral Link
                </button>
            </div>
        </asp:Panel>
    </div>

    <!-- LEVELS TAB -->
    <div id="tab-levels" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <div class="alert-box info">
            <i class="fas fa-info-circle"></i>
            <div>
                <strong class="text-white">15-Level Income Program</strong><br>
                Earn commissions from 15 levels of your network. Total distribution: <strong>100%</strong> of daily rewards. 
                <strong>Requirement:</strong> At least 1 direct referral.
            </div>
        </div>

        <div class="level-grid">
            <asp:Repeater ID="rptLevels" runat="server">
                <ItemTemplate>
                    <div class='level-card <%# Convert.ToBoolean(Eval("IsEligible")) ? "eligible" : "locked" %>'>
                        <div class="level-number">Level <%# Eval("Level") %></div>
                        <div class="level-percent">
                            <%# string.Format("{0:0.##}", Eval("CommissionPercent")) %>%
                        </div>
                        <div class="level-stats">
                            <div class="level-stat">
                                <small>Team</small>
                                <div class="value"><%# Eval("TeamCount") %></div>
                            </div>
                            <div class="level-stat">
                                <small>Earned</small>
                                <div class="value accent"><%# string.Format("{0:0.00}", Eval("EarnedAmount")) %></div>
                            </div>
                        </div>
                        <%# !Convert.ToBoolean(Eval("IsEligible")) ? "<div class='level-lock'><i class='fas fa-lock'></i></div>" : "" %>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- Level Summary -->
        <div class="row g-4 mt-4">
            <div class="col-md-4">
                <div class="stat-card" style="padding: 24px;">
                    <div class="summary-label">Total Commission Rate</div>
                    <div class="summary-value" style="color: #10B981;">100%</div>
                    <small class="text-muted">Across 15 levels</small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card" style="padding: 24px;">
                    <div class="summary-label">Total Level Earnings</div>
                    <div class="summary-value" style="color: var(--gold);">
                        <asp:Literal ID="litTotalLevelEarnings" runat="server" Text="0.00"></asp:Literal>
                    </div>
                    <small class="text-muted">PNC lifetime</small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card" style="padding: 24px;">
                    <div class="summary-label">Active Levels</div>
                    <div class="summary-value" style="color: var(--secondary);">
                        <asp:Literal ID="litActiveLevels" runat="server" Text="0"></asp:Literal>/15
                    </div>
                    <small class="text-muted">Levels earning</small>
                </div>
            </div>
        </div>
    </div>

    <!-- COMMISSIONS TAB -->
    <div id="tab-commissions" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="stat-card" style="padding: 24px;">
                    <div class="summary-label">Total Lifetime Commissions</div>
                    <div class="summary-value" style="color: #10B981;">
                        <asp:Literal ID="litLifetimeCommissions" runat="server" Text="0.00"></asp:Literal>
                    </div>
                    <small class="text-muted">PNC</small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card" style="padding: 24px;">
                    <div class="summary-label">This Month</div>
                    <div class="summary-value" style="color: var(--gold);">
                        <asp:Literal ID="litMonthCommissions" runat="server" Text="0.00"></asp:Literal>
                    </div>
                    <small class="text-muted">PNC</small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card" style="padding: 24px;">
                    <div class="summary-label">Today</div>
                    <div class="summary-value" style="color: var(--secondary);">
                        <asp:Literal ID="litTodayCommissions" runat="server" Text="0.00"></asp:Literal>
                    </div>
                    <small class="text-muted">PNC</small>
                </div>
            </div>
        </div>

        <div class="chart-card">
            <div class="chart-header">
                <h5 class="chart-title">
                    <i class="fas fa-coins" style="color: #10B981;"></i>
                    All Commissions
                </h5>
            </div>
            <asp:Repeater ID="rptAllCommissions" runat="server">
                <ItemTemplate>
                    <div class="commission-item">
                        <div class="commission-icon">
                            <i class="fas fa-hand-holding-usd"></i>
                        </div>
                        <div class="commission-info">
                            <div class="commission-title">
                                Level <%# Eval("Level") %> Commission
                                <small class="text-muted">from <%# Eval("ReferralName") %></small>
                            </div>
                            <div class="commission-date">
                                <%# Convert.ToDateTime(Eval("CreatedDate")).ToString("MMM dd, yyyy 'at' hh:mm tt") %>
                            </div>
                        </div>
                        <div class="commission-amount">
                            +<%# string.Format("{0:0.00}", Eval("Amount")) %> PNC
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoAllCommissions" runat="server" Visible="false">
                <div class="empty-state">
                    <i class="fas fa-coins"></i>
                    <h4>No Commissions Yet</h4>
                    <p>Your commission history will appear here once your team starts earning.</p>
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
                            <th>Level</th>
                            <th>Referral</th>
                            <th>Amount</th>
                            <th>Source</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptHistory" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td class="text-muted"><%# Convert.ToDateTime(Eval("CreatedDate")).ToString("MMM dd, yyyy HH:mm") %></td>
                                    <td><span class="level-number" style="padding: 2px 8px; font-size: 0.7rem;">L<%# Eval("Level") %></span></td>
                                    <td class="text-white"><%# Eval("ReferralName") %></td>
                                    <td class="text-accent">+<%# string.Format("{0:0.00}", Eval("Amount")) %> PNC</td>
                                    <td class="text-muted"><%# Eval("SourceType") %></td>
                                    <td>
                                        <span class='status-badge status-active'>
                                            Completed
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
                <h4>No Commission History</h4>
                <p>Your commission history will appear here.</p>
            </div>
        </asp:Panel>
    </div>

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Tab switching
            var tabs = document.querySelectorAll('.ref-tab');
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

            // Commission Chart
            var commData = <%= GetCommissionChartData() %>;
            var commCtx = document.getElementById('commissionChart');
            if (commCtx && commData.labels.length > 0) {
                new Chart(commCtx, {
                    type: 'line',
                    data: {
                        labels: commData.labels,
                        datasets: [{
                            label: 'Commissions (PNC)',
                            data: commData.values,
                            borderColor: '#10B981',
                            backgroundColor: 'rgba(16, 185, 129, 0.1)',
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
                                borderColor: '#10B981',
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

            // Level Distribution Chart
            var levelData = <%= GetLevelChartData() %>;
            var levelCtx = document.getElementById('levelChart');
            if (levelCtx && levelData.labels.length > 0) {
                new Chart(levelCtx, {
                    type: 'doughnut',
                    data: {
                        labels: levelData.labels,
                        datasets: [{
                            data: levelData.values,
                            backgroundColor: levelData.colors,
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
                for (var i = 0; i < levelData.labels.length; i++) {
                    legendHtml += '<div class="d-flex align-items-center gap-2 mb-1">' +
                        '<span style="width: 10px; height: 10px; border-radius: 50%; background: ' + levelData.colors[i] + '; display: inline-block;"></span>' +
                        '<span class="text-gray small flex-grow-1">' + levelData.labels[i] + '</span>' +
                        '<span class="text-white small fw-bold">' + levelData.values[i].toFixed(2) + ' PNC</span>' +
                        '</div>';
                }
                document.getElementById('levelLegend').innerHTML = legendHtml;
            }
        });

        // Copy referral link
        function copyReferralLink() {
            var input = document.getElementById('referralLink');
            input.select();
            input.setSelectionRange(0, 99999);
            navigator.clipboard.writeText(input.value).then(function() {
                var btn = event.target.closest('.copy-btn');
                var originalHTML = btn.innerHTML;
                btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                setTimeout(function() { btn.innerHTML = originalHTML; }, 2000);
            });
        }

        // Social sharing
        function shareWhatsApp() {
            var link = document.getElementById('referralLink').value;
            var text = 'Join MEXIFY and start earning with the 2X ROI Plan! Use my referral link: ' + link;
            window.open('https://wa.me/?text=' + encodeURIComponent(text), '_blank');
        }

        function shareTelegram() {
            var link = document.getElementById('referralLink').value;
            var text = 'Join MEXIFY and start earning with the 2X ROI Plan!';
            window.open('https://t.me/share/url?url=' + encodeURIComponent(link) + '&text=' + encodeURIComponent(text), '_blank');
        }

        function shareTwitter() {
            var link = document.getElementById('referralLink').value;
            var text = 'Join MEXIFY and start earning with the 2X ROI Plan! #MEXIFY #Crypto #PassiveIncome';
            window.open('https://twitter.com/intent/tweet?text=' + encodeURIComponent(text) + '&url=' + encodeURIComponent(link), '_blank');
        }

        function shareFacebook() {
            var link = document.getElementById('referralLink').value;
            window.open('https://www.facebook.com/sharer/sharer.php?u=' + encodeURIComponent(link), '_blank');
        }

        // Filter team
        function filterTeam() {
            var level = document.getElementById('filterLevel').value;
            var status = document.getElementById('filterStatus').value;

            var items = document.querySelectorAll('.team-member-item');
            items.forEach(function(item) {
                var matchLevel = level === 'all' || item.dataset.level === level;
                var matchStatus = status === 'all' || item.dataset.status === status;
                item.style.display = (matchLevel && matchStatus) ? '' : 'none';
            });
        }
    </script>
</asp:Content>