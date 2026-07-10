<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="Security.aspx.cs" Inherits="Mexify.Web.User.Security" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .security-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            flex-wrap: wrap;
            gap: 16px;
        }
        .security-header h2 { color: var(--text-white); margin: 0; font-size: 1.8rem; }

        .security-tabs {
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
        .security-tab {
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
        .security-tab.active {
            background: linear-gradient(135deg, #DC2626, #B91C1C);
            color: #fff;
            box-shadow: 0 4px 12px rgba(220, 38, 38, 0.3);
        }
        .security-tab:hover:not(.active) {
            background: rgba(255, 255, 255, 0.05);
            color: var(--text-white);
        }

        .security-hero {
            background: linear-gradient(135deg, rgba(220, 38, 38, 0.15), rgba(185, 28, 28, 0.1));
            border: 1px solid rgba(220, 38, 38, 0.3);
            border-radius: var(--radius-xl);
            padding: 32px;
            position: relative;
            overflow: hidden;
            margin-bottom: 32px;
        }
        .security-hero::before {
            content: '';
            position: absolute;
            top: -50%; right: -10%;
            width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(220, 38, 38, 0.15) 0%, transparent 70%);
            animation: float 15s ease-in-out infinite;
        }
        @keyframes float {
            0%,100%{transform:translate(0,0) scale(1)}
            50%{transform:translate(20px,-20px) scale(1.1)}
        }

        .security-score {
            display: flex;
            align-items: center;
            gap: 24px;
            flex-wrap: wrap;
        }
        .score-circle {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            position: relative;
            flex-shrink: 0;
        }
        .score-circle::before {
            content: '';
            position: absolute;
            inset: 0;
            border-radius: 50%;
            padding: 4px;
            background: conic-gradient(from 0deg, #DC2626 var(--score-percent), rgba(255,255,255,0.1) 0);
            -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
            -webkit-mask-composite: xor;
            mask-composite: exclude;
        }
        .score-value {
            font-size: 2rem;
            font-weight: 800;
            color: var(--text-white);
            font-family: 'Space Grotesk', sans-serif;
        }
        .score-label {
            font-size: 0.7rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .score-info { flex: 1; min-width: 200px; }
        .score-title {
            color: var(--text-white);
            font-size: 1.4rem;
            font-weight: 700;
            margin-bottom: 8px;
        }
        .score-desc { color: var(--text-gray); font-size: 0.9rem; margin-bottom: 16px; }
        .score-checklist {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }
        .check-item {
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            background: rgba(0, 0, 0, 0.2);
            border-radius: 50px;
            font-size: 0.8rem;
        }
        .check-item.done { color: var(--accent); }
        .check-item.pending { color: var(--gold); }
        .check-item.failed { color: #ff3b5c; }

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
            flex-wrap: wrap;
            gap: 12px;
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
        .info-card-title i { color: #DC2626; }

        .security-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 18px;
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-md);
            margin-bottom: 12px;
            transition: all 0.3s ease;
            flex-wrap: wrap;
            gap: 12px;
        }
        .security-item:hover {
            border-color: #DC2626;
            background: rgba(220, 38, 38, 0.03);
        }
        .security-item-info {
            display: flex;
            align-items: center;
            gap: 14px;
            flex: 1;
            min-width: 200px;
        }
        .security-item-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            flex-shrink: 0;
        }
        .security-item-icon.enabled { background: rgba(0, 255, 178, 0.15); color: var(--accent); }
        .security-item-icon.disabled { background: rgba(255, 59, 92, 0.15); color: #ff3b5c; }
        .security-item-icon.warning { background: rgba(255, 215, 0, 0.15); color: var(--gold); }
        .security-item-icon.info { background: rgba(0, 212, 255, 0.15); color: var(--secondary); }
        .security-item-title { color: var(--text-white); font-weight: 600; font-size: 0.95rem; margin-bottom: 2px; }
        .security-item-desc { color: var(--text-muted); font-size: 0.8rem; }
        .security-item-status {
            padding: 6px 14px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .status-enabled { background: rgba(0, 255, 178, 0.15); color: var(--accent); }
        .status-disabled { background: rgba(255, 59, 92, 0.15); color: #ff3b5c; }
        .status-pending { background: rgba(255, 215, 0, 0.15); color: var(--gold); }

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
        .input-icon-wrap select,
        .input-icon-wrap textarea {
            width: 100%;
            padding: 12px 14px 12px 42px;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--glass-border);
            border-radius: 10px;
            color: var(--text-white);
            font-size: 0.92rem;
            transition: all 0.3s ease;
        }
        .input-icon-wrap textarea { min-height: 100px; resize: vertical; padding-top: 14px; }
        .input-icon-wrap select option { background: var(--bg-secondary); color: var(--text-white); }
        .input-icon-wrap input:focus,
        .input-icon-wrap select:focus,
        .input-icon-wrap textarea:focus {
            outline: none;
            border-color: #DC2626;
            background: rgba(220, 38, 38, 0.03);
            box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.1);
        }
        .input-icon-wrap:focus-within i.input-icon { color: #DC2626; }

        .password-strength {
            margin-top: 8px;
            height: 4px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50px;
            overflow: hidden;
        }
        .password-strength-fill {
            height: 100%;
            width: 0;
            border-radius: 50px;
            transition: all 0.3s ease;
        }
        .password-strength-fill.weak { width: 25%; background: #ff3b5c; }
        .password-strength-fill.fair { width: 50%; background: #FFA500; }
        .password-strength-fill.good { width: 75%; background: var(--gold); }
        .password-strength-fill.strong { width: 100%; background: var(--accent); }

        .password-requirements {
            margin-top: 10px;
            padding: 0;
            list-style: none;
            font-size: 0.75rem;
            color: var(--text-muted);
        }
        .password-requirements li {
            margin-bottom: 3px;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: color 0.3s ease;
        }
        .password-requirements li.valid { color: var(--accent); }

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
        .alert-box.info { background: rgba(0, 212, 255, 0.1); border: 1px solid rgba(0, 212, 255, 0.3); color: var(--secondary); }
        .alert-box i { margin-top: 2px; flex-shrink: 0; }

        .btn-primary-red {
            padding: 12px 24px;
            background: linear-gradient(135deg, #DC2626, #B91C1C);
            border: none;
            border-radius: 10px;
            color: #fff;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-primary-red:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(220, 38, 38, 0.4);
        }
        .btn-outline-red {
            padding: 12px 24px;
            background: transparent;
            border: 1px solid rgba(220, 38, 38, 0.4);
            border-radius: 10px;
            color: #DC2626;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-outline-red:hover {
            background: rgba(220, 38, 38, 0.1);
            border-color: #DC2626;
        }
        .btn-outline-glass {
            padding: 10px 20px;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 10px;
            color: var(--text-gray);
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }
        .btn-outline-glass:hover {
            background: rgba(255, 255, 255, 0.05);
            color: var(--text-white);
        }

        .session-item {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 16px;
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-md);
            margin-bottom: 12px;
            flex-wrap: wrap;
            transition: all 0.3s ease;
        }
        .session-item:hover {
            border-color: #DC2626;
        }
        .session-item.current {
            border-color: rgba(0, 255, 178, 0.3);
            background: rgba(0, 255, 178, 0.03);
        }
        .session-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            background: rgba(220, 38, 38, 0.15);
            color: #DC2626;
            flex-shrink: 0;
        }
        .session-item.current .session-icon {
            background: rgba(0, 255, 178, 0.15);
            color: var(--accent);
        }
        .session-info { flex: 1; min-width: 200px; }
        .session-device { color: var(--text-white); font-weight: 600; font-size: 0.95rem; margin-bottom: 4px; }
        .session-meta {
            color: var(--text-muted);
            font-size: 0.75rem;
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }
        .session-meta span {
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        .session-actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .whitelist-item {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 14px 16px;
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-md);
            margin-bottom: 10px;
            flex-wrap: wrap;
        }
        .whitelist-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(0, 255, 178, 0.15);
            color: var(--accent);
            flex-shrink: 0;
        }
        .whitelist-info { flex: 1; min-width: 200px; }
        .whitelist-label { color: var(--text-white); font-weight: 600; font-size: 0.9rem; margin-bottom: 2px; }
        .whitelist-address {
            color: var(--text-muted);
            font-size: 0.75rem;
            font-family: 'Courier New', monospace;
            word-break: break-all;
        }
        .whitelist-currency {
            padding: 3px 10px;
            background: rgba(0, 212, 255, 0.15);
            color: var(--secondary);
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
        }

        .activity-item {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 14px 0;
            border-bottom: 1px solid var(--glass-border);
        }
        .activity-item:last-child { border-bottom: none; }
        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            font-size: 1rem;
        }
        .activity-icon.login { background: rgba(0, 255, 178, 0.15); color: var(--accent); }
        .activity-icon.password { background: rgba(255, 215, 0, 0.15); color: var(--gold); }
        .activity-icon.failed { background: rgba(255, 59, 92, 0.15); color: #ff3b5c; }
        .activity-icon.withdraw { background: rgba(0, 212, 255, 0.15); color: var(--secondary); }
        .activity-icon.settings { background: rgba(156, 39, 176, 0.15); color: #9C27B0; }
        .activity-info { flex: 1; min-width: 0; }
        .activity-title { color: var(--text-white); font-weight: 600; font-size: 0.9rem; margin-bottom: 2px; }
        .activity-meta { color: var(--text-muted); font-size: 0.75rem; }
        .activity-time {
            color: var(--text-muted);
            font-size: 0.75rem;
            white-space: nowrap;
        }

        .qr-setup {
            background: #fff;
            padding: 20px;
            border-radius: 12px;
            display: inline-block;
            margin: 16px 0;
        }
        .secret-key {
            background: rgba(0, 0, 0, 0.3);
            padding: 12px 16px;
            border-radius: 8px;
            font-family: 'Courier New', monospace;
            color: var(--secondary);
            font-size: 0.9rem;
            word-break: break-all;
            margin: 12px 0;
            border: 1px dashed var(--glass-border);
            text-align: center;
        }

        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 50px;
            height: 26px;
        }
        .toggle-switch input { opacity: 0; width: 0; height: 0; }
        .toggle-slider {
            position: absolute;
            cursor: pointer;
            inset: 0;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50px;
            transition: 0.3s;
        }
        .toggle-slider::before {
            content: '';
            position: absolute;
            height: 20px;
            width: 20px;
            left: 3px;
            bottom: 3px;
            background: #fff;
            border-radius: 50%;
            transition: 0.3s;
        }
        .toggle-switch input:checked + .toggle-slider {
            background: linear-gradient(135deg, var(--accent), #00D4FF);
        }
        .toggle-switch input:checked + .toggle-slider::before {
            transform: translateX(24px);
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
            .security-score { flex-direction: column; text-align: center; }
            .score-checklist { justify-content: center; }
            .session-meta { flex-direction: column; gap: 4px; }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Header -->
    <div class="security-header" data-aos="fade-up">
        <div>
            <h2>Security Center</h2>
            <p class="text-gray mb-0">Protect your account with advanced security features</p>
        </div>
    </div>

    <!-- Tabs -->
    <div class="security-tabs" data-aos="fade-up">
        <button type="button" class="security-tab active" data-tab="overview">
            <i class="fas fa-shield-alt me-1"></i> Overview
        </button>
        <button type="button" class="security-tab" data-tab="twofa">
            <i class="fas fa-mobile-alt me-1"></i> 2FA
        </button>
        <button type="button" class="security-tab" data-tab="password">
            <i class="fas fa-key me-1"></i> Password
        </button>
        <button type="button" class="security-tab" data-tab="sessions">
            <i class="fas fa-laptop me-1"></i> Sessions
        </button>
        <button type="button" class="security-tab" data-tab="whitelist">
            <i class="fas fa-check-circle me-1"></i> Whitelist
        </button>
        <button type="button" class="security-tab" data-tab="activity">
            <i class="fas fa-history me-1"></i> Activity
        </button>
    </div>

    <!-- OVERVIEW TAB -->
    <div id="tab-overview" class="tab-content" data-aos="fade-up">
        
        <!-- Security Score Hero -->
        <div class="security-hero">
            <div class="security-score position-relative" style="z-index: 2;">
                <div class="score-circle" style="--score-percent: <%= SecurityScorePercent %>%;">
                    <div class="score-value"><asp:Literal ID="litSecurityScore" runat="server" Text="0"></asp:Literal></div>
                    <div class="score-label">Score</div>
                </div>
                <div class="score-info">
                    <div class="score-title">
                        <asp:Literal ID="litSecurityLevel" runat="server" Text="Good"></asp:Literal> Security Level
                    </div>
                    <div class="score-desc">
                        <asp:Literal ID="litSecurityDesc" runat="server" Text=""></asp:Literal>
                    </div>
                    <div class="score-checklist">
                        <asp:Literal ID="litChecklist" runat="server"></asp:Literal>
                    </div>
                </div>
            </div>
        </div>

        <!-- Security Features Grid -->
        <div class="row g-4">
            <div class="col-lg-6">
                <div class="info-card h-100">
                    <div class="info-card-header">
                        <h5 class="info-card-title">
                            <i class="fas fa-shield-alt"></i>
                            Security Features
                        </h5>
                    </div>

                    <div class="security-item">
                        <div class="security-item-info">
                            <div class='security-item-icon <%# Is2FAEnabled ? "enabled" : "disabled" %>'>
                                <i class="fas fa-mobile-alt"></i>
                            </div>
                            <div>
                                <div class="security-item-title">Two-Factor Authentication</div>
                                <div class="security-item-desc">Extra layer of login protection</div>
                            </div>
                        </div>
                        <span class='security-item-status <%# Is2FAEnabled ? "status-enabled" : "status-disabled" %>'>
                            <%# Is2FAEnabled ? "Enabled" : "Disabled" %>
                        </span>
                    </div>

                    <div class="security-item">
                        <div class="security-item-info">
                            <div class='security-item-icon <%# IsEmailVerified ? "enabled" : "warning" %>'>
                                <i class="fas fa-envelope"></i>
                            </div>
                            <div>
                                <div class="security-item-title">Email Verification</div>
                                <div class="security-item-desc">Verified email for account recovery</div>
                            </div>
                        </div>
                        <span class='security-item-status <%# IsEmailVerified ? "status-enabled" : "status-pending" %>'>
                            <%# IsEmailVerified ? "Verified" : "Pending" %>
                        </span>
                    </div>

                    <div class="security-item">
                        <div class="security-item-info">
                            <div class='security-item-icon <%# HasAntiPhishing ? "enabled" : "disabled" %>'>
                                <i class="fas fa-fish"></i>
                            </div>
                            <div>
                                <div class="security-item-title">Anti-Phishing Code</div>
                                <div class="security-item-desc">Custom code in all emails</div>
                            </div>
                        </div>
                        <span class='security-item-status <%# HasAntiPhishing ? "status-enabled" : "status-disabled" %>'>
                            <%# HasAntiPhishing ? "Active" : "Inactive" %>
                        </span>
                    </div>

                    <div class="security-item">
                        <div class="security-item-info">
                            <div class='security-item-icon <%# HasPasswordRecentlyChanged ? "enabled" : "warning" %>'>
                                <i class="fas fa-key"></i>
                            </div>
                            <div>
                                <div class="security-item-title">Password Age</div>
                                <div class="security-item-desc">Last changed: <asp:Literal ID="litPasswordAge" runat="server" Text="Unknown"></asp:Literal></div>
                            </div>
                        </div>
                        <span class='security-item-status <%# HasPasswordRecentlyChanged ? "status-enabled" : "status-pending" %>'>
                            <%# HasPasswordRecentlyChanged ? "Recent" : "Old" %>
                        </span>
                    </div>
                </div>
            </div>

            <div class="col-lg-6">
                <div class="info-card h-100">
                    <div class="info-card-header">
                        <h5 class="info-card-title">
                            <i class="fas fa-bell"></i>
                            Notification Settings
                        </h5>
                    </div>

                    <div class="security-item">
                        <div class="security-item-info">
                            <div class="security-item-icon info">
                                <i class="fas fa-sign-in-alt"></i>
                            </div>
                            <div>
                                <div class="security-item-title">Login Alerts</div>
                                <div class="security-item-desc">Notify on new device login</div>
                            </div>
                        </div>
                        <label class="toggle-switch">
                            <asp:CheckBox ID="chkLoginAlerts" runat="server" />
                            <span class="toggle-slider"></span>
                        </label>
                    </div>

                    <div class="security-item">
                        <div class="security-item-info">
                            <div class="security-item-icon info">
                                <i class="fas fa-money-bill-wave"></i>
                            </div>
                            <div>
                                <div class="security-item-title">Withdrawal Alerts</div>
                                <div class="security-item-desc">Notify on withdrawal requests</div>
                            </div>
                        </div>
                        <label class="toggle-switch">
                            <asp:CheckBox ID="chkWithdrawAlerts" runat="server" />
                            <span class="toggle-slider"></span>
                        </label>
                    </div>

                    <div class="security-item">
                        <div class="security-item-info">
                            <div class="security-item-icon info">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                            <div>
                                <div class="security-item-title">Failed Login Alerts</div>
                                <div class="security-item-desc">Notify on failed attempts</div>
                            </div>
                        </div>
                        <label class="toggle-switch">
                            <asp:CheckBox ID="chkFailedLoginAlerts" runat="server" />
                            <span class="toggle-slider"></span>
                        </label>
                    </div>

                    <div class="security-item">
                        <div class="security-item-info">
                            <div class="security-item-icon info">
                                <i class="fas fa-cog"></i>
                            </div>
                            <div>
                                <div class="security-item-title">Settings Change Alerts</div>
                                <div class="security-item-desc">Notify on security changes</div>
                            </div>
                        </div>
                        <label class="toggle-switch">
                            <asp:CheckBox ID="chkSettingsAlerts" runat="server" />
                            <span class="toggle-slider"></span>
                        </label>
                    </div>

                    <div class="mt-3">
                        <asp:Button ID="btnSaveNotifications" runat="server" Text="Save Preferences" CssClass="btn-primary-red" OnClick="btnSaveNotifications_Click" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="row g-4 mt-2">
            <div class="col-md-4">
                <a href="#" onclick="document.querySelector('[data-tab=twofa]').click(); return false;" class="info-card" style="text-decoration: none; display: block;">
                    <div class="text-center">
                        <div class="security-item-icon enabled" style="margin: 0 auto 12px; width: 56px; height: 56px; font-size: 1.3rem;">
                            <i class="fas fa-mobile-alt"></i>
                        </div>
                        <h5 class="text-white mb-1">Setup 2FA</h5>
                        <small class="text-gray">Enable authenticator app</small>
                    </div>
                </a>
            </div>
            <div class="col-md-4">
                <a href="#" onclick="document.querySelector('[data-tab=password]').click(); return false;" class="info-card" style="text-decoration: none; display: block;">
                    <div class="text-center">
                        <div class="security-item-icon warning" style="margin: 0 auto 12px; width: 56px; height: 56px; font-size: 1.3rem;">
                            <i class="fas fa-key"></i>
                        </div>
                        <h5 class="text-white mb-1">Change Password</h5>
                        <small class="text-gray">Update your password</small>
                    </div>
                </a>
            </div>
            <div class="col-md-4">
                <a href="#" onclick="document.querySelector('[data-tab=sessions]').click(); return false;" class="info-card" style="text-decoration: none; display: block;">
                    <div class="text-center">
                        <div class="security-item-icon info" style="margin: 0 auto 12px; width: 56px; height: 56px; font-size: 1.3rem;">
                            <i class="fas fa-laptop"></i>
                        </div>
                        <h5 class="text-white mb-1">Manage Sessions</h5>
                        <small class="text-gray">View active devices</small>
                    </div>
                </a>
            </div>
        </div>
    </div>

    <!-- 2FA TAB -->
    <div id="tab-twofa" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <asp:Panel ID="pnl2FAError" runat="server" Visible="false">
            <div class="alert-box error">
                <i class="fas fa-exclamation-circle"></i>
                <asp:Literal ID="lit2FAError" runat="server"></asp:Literal>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnl2FASuccess" runat="server" Visible="false">
            <div class="alert-box success">
                <i class="fas fa-check-circle"></i>
                <asp:Literal ID="lit2FASuccess" runat="server"></asp:Literal>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnl2FANotEnabled" runat="server">
            <div class="info-card">
                <div class="info-card-header">
                    <h5 class="info-card-title">
                        <i class="fas fa-mobile-alt"></i>
                        Enable Two-Factor Authentication
                    </h5>
                </div>

                <div class="alert-box info">
                    <i class="fas fa-info-circle"></i>
                    <div>
                        <strong class="text-white">Recommended:</strong> 2FA adds an extra layer of security to your account. 
                        You'll need an authenticator app like Google Authenticator or Authy.
                    </div>
                </div>

                <div class="text-center">
                    <h5 class="text-white mb-3">Step 1: Scan QR Code</h5>
                    <p class="text-gray">Open your authenticator app and scan this QR code:</p>
                    <div class="qr-setup">
                        <img id="qrCode2FA" src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=Loading..." 
                             alt="2FA QR Code" width="200" height="200">
                    </div>
                    
                    <p class="text-gray small mt-3">Or enter this secret key manually:</p>
                    <div class="secret-key">
                        <asp:Literal ID="lit2FASecret" runat="server" Text="Loading..."></asp:Literal>
                    </div>
                    <button type="button" class="btn-outline-glass" onclick="copySecretKey()">
                        <i class="fas fa-copy me-1"></i> Copy Key
                    </button>
                </div>

                <hr style="border-color: var(--glass-border); margin: 30px 0;">

                <h5 class="text-white mb-3">Step 2: Verify Code</h5>
                <p class="text-gray">Enter the 6-digit code from your authenticator app to confirm:</p>

                <asp:Panel ID="pnlVerify2FA" runat="server" DefaultButton="btnEnable2FA">
                    <div class="form-group-custom">
                        <label>Authenticator Code <span class="required">*</span></label>
                        <div class="input-icon-wrap">
                            <asp:TextBox ID="txt2FACode" runat="server" placeholder="Enter 6-digit code" MaxLength="6"></asp:TextBox>
                            <i class="fas fa-shield-alt input-icon"></i>
                        </div>
                    </div>

                    <asp:Button ID="btnEnable2FA" runat="server" Text="Enable 2FA" CssClass="btn-primary-red" OnClick="btnEnable2FA_Click" />
                </asp:Panel>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnl2FAEnabled" runat="server" Visible="false">
            <div class="info-card">
                <div class="info-card-header">
                    <h5 class="info-card-title">
                        <i class="fas fa-check-circle" style="color: var(--accent);"></i>
                        2FA is Enabled
                    </h5>
                    <span class="security-item-status status-enabled">Active</span>
                </div>

                <div class="alert-box success">
                    <i class="fas fa-shield-alt"></i>
                    <div>
                        <strong class="text-white">Your account is protected!</strong><br>
                        Two-factor authentication is active. You'll need your authenticator app code for:
                        <ul class="mb-0 mt-2" style="padding-left: 18px;">
                            <li>Logging in from new devices</li>
                            <li>Making withdrawals</li>
                            <li>Changing security settings</li>
                        </ul>
                    </div>
                </div>

                <div class="row g-3 mt-3">
                    <div class="col-md-6">
                        <div class="security-item">
                            <div class="security-item-info">
                                <div class="security-item-icon enabled">
                                    <i class="fas fa-calendar-alt"></i>
                                </div>
                                <div>
                                    <div class="security-item-title">Enabled On</div>
                                    <div class="security-item-desc"><asp:Literal ID="lit2FAEnabledDate" runat="server"></asp:Literal></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="security-item">
                            <div class="security-item-info">
                                <div class="security-item-icon info">
                                    <i class="fas fa-clock"></i>
                                </div>
                                <div>
                                    <div class="security-item-title">Days Active</div>
                                    <div class="security-item-desc"><asp:Literal ID="lit2FADaysActive" runat="server" Text="0"></asp:Literal> days</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mt-4 pt-3" style="border-top: 1px solid var(--glass-border);">
                    <h6 class="text-white mb-3">Recovery Options</h6>
                    <div class="alert-box warning">
                        <i class="fas fa-exclamation-triangle"></i>
                        <div>
                            <strong class="text-white">Save your backup codes!</strong><br>
                            If you lose access to your authenticator app, you'll need these codes to recover your account.
                        </div>
                    </div>
                    <asp:Button ID="btnGenerateBackupCodes" runat="server" Text="Generate Backup Codes" CssClass="btn-outline-red" OnClick="btnGenerateBackupCodes_Click" />
                </div>

                <div class="mt-4 pt-3" style="border-top: 1px solid var(--glass-border);">
                    <asp:Button ID="btnDisable2FA" runat="server" Text="Disable 2FA" CssClass="btn-outline-red" OnClick="btnDisable2FA_Click" style="border-color: rgba(255, 59, 92, 0.4); color: #ff3b5c;" />
                </div>
            </div>
        </asp:Panel>
    </div>

    <!-- PASSWORD TAB -->
    <div id="tab-password" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <asp:Panel ID="pnlPasswordError" runat="server" Visible="false">
            <div class="alert-box error">
                <i class="fas fa-exclamation-circle"></i>
                <asp:Literal ID="litPasswordError" runat="server"></asp:Literal>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlPasswordSuccess" runat="server" Visible="false">
            <div class="alert-box success">
                <i class="fas fa-check-circle"></i>
                <asp:Literal ID="litPasswordSuccess" runat="server"></asp:Literal>
            </div>
        </asp:Panel>

        <div class="row g-4">
            <div class="col-lg-8">
                <div class="info-card">
                    <div class="info-card-header">
                        <h5 class="info-card-title">
                            <i class="fas fa-key"></i>
                            Change Password
                        </h5>
                    </div>

                    <asp:Panel ID="pnlPasswordForm" runat="server" DefaultButton="btnChangePassword">
                        <div class="form-group-custom">
                            <label>Current Password <span class="required">*</span></label>
                            <div class="input-icon-wrap">
                                <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password" placeholder="Enter current password"></asp:TextBox>
                                <i class="fas fa-lock input-icon"></i>
                            </div>
                        </div>

                        <div class="form-group-custom">
                            <label>New Password <span class="required">*</span></label>
                            <div class="input-icon-wrap">
                                <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" placeholder="Enter new password" onkeyup="checkPasswordStrength(this.value)"></asp:TextBox>
                                <i class="fas fa-lock input-icon"></i>
                            </div>
                            <div class="password-strength">
                                <div class="password-strength-fill" id="strengthFill"></div>
                            </div>
                            <ul class="password-requirements" id="passwordReqs">
                                <li id="reqLength"><i class="far fa-circle"></i> At least 8 characters</li>
                                <li id="reqUpper"><i class="far fa-circle"></i> One uppercase letter</li>
                                <li id="reqLower"><i class="far fa-circle"></i> One lowercase letter</li>
                                <li id="reqNumber"><i class="far fa-circle"></i> One number</li>
                                <li id="reqSpecial"><i class="far fa-circle"></i> One special character (!@#$%^&*)</li>
                            </ul>
                        </div>

                        <div class="form-group-custom">
                            <label>Confirm New Password <span class="required">*</span></label>
                            <div class="input-icon-wrap">
                                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" placeholder="Confirm new password"></asp:TextBox>
                                <i class="fas fa-lock input-icon"></i>
                            </div>
                        </div>

                        <div class="alert-box warning">
                            <i class="fas fa-info-circle"></i>
                            <div>
                                <strong class="text-white">Important:</strong> After changing your password, you'll be logged out of all other devices for security.
                            </div>
                        </div>

                        <asp:Button ID="btnChangePassword" runat="server" Text="Update Password" CssClass="btn-primary-red" OnClick="btnChangePassword_Click" />
                    </asp:Panel>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="info-card">
                    <div class="info-card-header">
                        <h5 class="info-card-title">
                            <i class="fas fa-info-circle"></i>
                            Password Tips
                        </h5>
                    </div>
                    <ul style="padding-left: 18px; color: var(--text-gray); font-size: 0.85rem; line-height: 1.8;">
                        <li>Use at least 12 characters</li>
                        <li>Mix uppercase and lowercase</li>
                        <li>Include numbers and symbols</li>
                        <li>Don't reuse old passwords</li>
                        <li>Don't use personal info</li>
                        <li>Consider using a password manager</li>
                    </ul>
                </div>

                <div class="info-card">
                    <div class="info-card-header">
                        <h5 class="info-card-title">
                            <i class="fas fa-history"></i>
                            Password History
                        </h5>
                    </div>
                    <div class="info-row" style="display: flex; justify-content: space-between; padding: 10px 0;">
                        <span class="text-gray">Last Changed</span>
                        <span class="text-white"><asp:Literal ID="litLastPasswordChange" runat="server" Text="Never"></asp:Literal></span>
                    </div>
                    <div class="info-row" style="display: flex; justify-content: space-between; padding: 10px 0;">
                        <span class="text-gray">Password Age</span>
                        <span class="text-white"><asp:Literal ID="litPasswordAgeDetail" runat="server" Text="—"></asp:Literal></span>
                    </div>
                    <div class="info-row" style="display: flex; justify-content: space-between; padding: 10px 0;">
                        <span class="text-gray">Strength</span>
                        <span class="text-white"><asp:Literal ID="litPasswordStrength" runat="server" Text="—"></asp:Literal></span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- SESSIONS TAB -->
    <div id="tab-sessions" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <asp:Panel ID="pnlSessionSuccess" runat="server" Visible="false">
            <div class="alert-box success">
                <i class="fas fa-check-circle"></i>
                <asp:Literal ID="litSessionSuccess" runat="server"></asp:Literal>
            </div>
        </asp:Panel>

        <div class="info-card">
            <div class="info-card-header">
                <h5 class="info-card-title">
                    <i class="fas fa-laptop"></i>
                    Active Sessions
                    <span class="security-item-status status-pending ms-2"><asp:Literal ID="litSessionCount" runat="server" Text="0"></asp:Literal></span>
                </h5>
                <asp:Button ID="btnLogoutAll" runat="server" Text="Logout All Devices" CssClass="btn-outline-red" OnClick="btnLogoutAll_Click" style="padding: 8px 16px; font-size: 0.85rem;" />
            </div>

            <asp:Repeater ID="rptSessions" runat="server">
                <ItemTemplate>
                    <div class='session-item <%# Convert.ToBoolean(Eval("IsCurrent")) ? "current" : "" %>'>
                        <div class="session-icon">
                            <i class='<%# Eval("DeviceIcon") %>'></i>
                        </div>
                        <div class="session-info">
                            <div class="session-device">
                                <%# Eval("DeviceName") %>
                                <%# Convert.ToBoolean(Eval("IsCurrent")) ? "<span class='security-item-status status-enabled ms-2' style='padding: 2px 8px; font-size: 0.65rem;'>Current</span>" : "" %>
                            </div>
                            <div class="session-meta">
                                <span><i class="fas fa-map-marker-alt"></i> <%# Eval("Location") %></span>
                                <span><i class="fas fa-clock"></i> <%# Eval("LastActive") %></span>
                                <span><i class="fas fa-globe"></i> <%# Eval("Browser") %></span>
                            </div>
                        </div>
                        <div class="session-actions">
                            <asp:Panel runat="server" Visible='<%# !Convert.ToBoolean(Eval("IsCurrent")) %>'>
                                <asp:LinkButton ID="lnkRevokeSession" runat="server" CssClass="btn-outline-red" 
                                    style="padding: 6px 14px; font-size: 0.8rem;" 
                                    CommandArgument='<%# Eval("SessionId") %>' 
                                    OnCommand="lnkRevokeSession_Command">
                                    <i class="fas fa-times me-1"></i> Revoke
                                </asp:LinkButton>
                            </asp:Panel>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoSessions" runat="server" Visible="false">
                <div class="empty-state">
                    <i class="fas fa-laptop"></i>
                    <h4>No Active Sessions</h4>
                    <p>Your active sessions will appear here.</p>
                </div>
            </asp:Panel>
        </div>
    </div>

    <!-- WHITELIST TAB -->
    <div id="tab-whitelist" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <asp:Panel ID="pnlWhitelistError" runat="server" Visible="false">
            <div class="alert-box error">
                <i class="fas fa-exclamation-circle"></i>
                <asp:Literal ID="litWhitelistError" runat="server"></asp:Literal>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlWhitelistSuccess" runat="server" Visible="false">
            <div class="alert-box success">
                <i class="fas fa-check-circle"></i>
                <asp:Literal ID="litWhitelistSuccess" runat="server"></asp:Literal>
            </div>
        </asp:Panel>

        <div class="row g-4">
            <div class="col-lg-7">
                <div class="info-card">
                    <div class="info-card-header">
                        <h5 class="info-card-title">
                            <i class="fas fa-check-circle"></i>
                            Withdrawal Whitelist
                        </h5>
                    </div>

                    <div class="alert-box info">
                        <i class="fas fa-info-circle"></i>
                        <div>
                            <strong class="text-white">Whitelist Protection:</strong> Only send withdrawals to addresses on your whitelist. 
                            New addresses require 24-hour confirmation period.
                        </div>
                    </div>

                    <asp:Repeater ID="rptWhitelist" runat="server">
                        <ItemTemplate>
                            <div class="whitelist-item">
                                <div class="whitelist-icon">
                                    <i class='<%# GetCurrencyIcon(Eval("CurrencyCode")) %>'></i>
                                </div>
                                <div class="whitelist-info">
                                    <div class="whitelist-label"><%# Eval("Label") %></div>
                                    <div class="whitelist-address"><%# Eval("Address") %></div>
                                    <small class="text-muted">Added: <%# Convert.ToDateTime(Eval("AddedDate")).ToString("MMM dd, yyyy") %></small>
                                </div>
                                <span class="whitelist-currency"><%# Eval("CurrencyCode") %></span>
                                <asp:LinkButton ID="lnkRemoveWhitelist" runat="server" CssClass="btn-outline-red" 
                                    style="padding: 6px 12px; font-size: 0.75rem;" 
                                    CommandArgument='<%# Eval("WhitelistId") %>' 
                                    OnCommand="lnkRemoveWhitelist_Command">
                                    <i class="fas fa-trash"></i>
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <asp:Panel ID="pnlNoWhitelist" runat="server" Visible="false">
                        <div class="empty-state">
                            <i class="fas fa-check-circle"></i>
                            <h4>No Whitelisted Addresses</h4>
                            <p>Add addresses to your whitelist for faster withdrawals.</p>
                        </div>
                    </asp:Panel>
                </div>
            </div>

            <div class="col-lg-5">
                <div class="info-card">
                    <div class="info-card-header">
                        <h5 class="info-card-title">
                            <i class="fas fa-plus-circle"></i>
                            Add New Address
                        </h5>
                    </div>

                    <asp:Panel ID="pnlAddWhitelist" runat="server" DefaultButton="btnAddWhitelist">
                        <div class="form-group-custom">
                            <label>Label <span class="required">*</span></label>
                            <div class="input-icon-wrap">
                                <asp:TextBox ID="txtWhitelistLabel" runat="server" placeholder="e.g., My Binance Wallet"></asp:TextBox>
                                <i class="fas fa-tag input-icon"></i>
                            </div>
                        </div>

                        <div class="form-group-custom">
                            <label>Currency <span class="required">*</span></label>
                            <div class="input-icon-wrap">
                                <asp:DropDownList ID="ddlWhitelistCurrency" runat="server">
                                </asp:DropDownList>
                                <i class="fas fa-coins input-icon"></i>
                            </div>
                        </div>

                        <div class="form-group-custom">
                            <label>Wallet Address <span class="required">*</span></label>
                            <div class="input-icon-wrap">
                                <asp:TextBox ID="txtWhitelistAddress" runat="server" placeholder="Enter wallet address"></asp:TextBox>
                                <i class="fas fa-wallet input-icon"></i>
                            </div>
                        </div>

                        <div class="form-group-custom">
                            <label>2FA Code <span class="required">*</span></label>
                            <div class="input-icon-wrap">
                                <asp:TextBox ID="txtWhitelist2FA" runat="server" placeholder="Enter 2FA code" MaxLength="6"></asp:TextBox>
                                <i class="fas fa-shield-alt input-icon"></i>
                            </div>
                        </div>

                        <asp:Button ID="btnAddWhitelist" runat="server" Text="Add to Whitelist" CssClass="btn-primary-red w-100" OnClick="btnAddWhitelist_Click" />
                    </asp:Panel>
                </div>
            </div>
        </div>
    </div>

    <!-- ACTIVITY TAB -->
    <div id="tab-activity" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <div class="info-card">
            <div class="info-card-header">
                <h5 class="info-card-title">
                    <i class="fas fa-history"></i>
                    Security Activity Log
                </h5>
                <asp:Button ID="btnExportActivity" runat="server" Text="Export Log" CssClass="btn-outline-red" 
                    style="padding: 8px 16px; font-size: 0.85rem;" OnClick="btnExportActivity_Click" />
            </div>

            <asp:Repeater ID="rptActivity" runat="server">
                <ItemTemplate>
                    <div class="activity-item">
                        <div class='activity-icon <%# Eval("TypeClass") %>'>
                            <i class='<%# Eval("Icon") %>'></i>
                        </div>
                        <div class="activity-info">
                            <div class="activity-title"><%# Eval("Title") %></div>
                            <div class="activity-meta">
                                <i class="fas fa-map-marker-alt me-1"></i> <%# Eval("Location") %> · 
                                <i class="fas fa-laptop me-1"></i> <%# Eval("Device") %>
                            </div>
                        </div>
                        <div class="activity-time">
                            <%# Convert.ToDateTime(Eval("CreatedDate")).ToString("MMM dd, yyyy HH:mm") %>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoActivity" runat="server" Visible="false">
                <div class="empty-state">
                    <i class="fas fa-history"></i>
                    <h4>No Activity Yet</h4>
                    <p>Your security activity will appear here.</p>
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
            
            function initSecurityTabs() {
                var tabs = document.querySelectorAll('.security-tab');
                var contents = document.querySelectorAll('.tab-content');
                var activeTabInput = document.getElementById('<%= hfActiveTab.ClientID %>');
                
                if (!tabs.length || !contents.length) {
                    setTimeout(initSecurityTabs, 100);
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
                document.addEventListener('DOMContentLoaded', initSecurityTabs);
            } else {
                initSecurityTabs();
            }
        })();

        function checkPasswordStrength(password) {
            var fill = document.getElementById('strengthFill');
            if (!fill) return;

            var reqLength = document.getElementById('reqLength');
            var reqUpper = document.getElementById('reqUpper');
            var reqLower = document.getElementById('reqLower');
            var reqNumber = document.getElementById('reqNumber');
            var reqSpecial = document.getElementById('reqSpecial');

            toggleReq(reqLength, password.length >= 8);
            toggleReq(reqUpper, /[A-Z]/.test(password));
            toggleReq(reqLower, /[a-z]/.test(password));
            toggleReq(reqNumber, /[0-9]/.test(password));
            toggleReq(reqSpecial, /[!@#$%^&*(),.?":{}|<>]/.test(password));

            var score = 0;
            if (password.length >= 8) score++;
            if (/[A-Z]/.test(password)) score++;
            if (/[a-z]/.test(password)) score++;
            if (/[0-9]/.test(password)) score++;
            if (/[!@#$%^&*(),.?":{}|<>]/.test(password)) score++;

            fill.className = 'password-strength-fill';
            if (password.length === 0) {
                fill.style.width = '0';
            } else if (score <= 2) {
                fill.classList.add('weak');
            } else if (score === 3) {
                fill.classList.add('fair');
            } else if (score === 4) {
                fill.classList.add('good');
            } else {
                fill.classList.add('strong');
            }
        }

        function toggleReq(element, isValid) {
            if (!element) return;
            var icon = element.querySelector('i');
            if (isValid) {
                element.classList.add('valid');
                if (icon) {
                    icon.classList.remove('far', 'fa-circle');
                    icon.classList.add('fas', 'fa-check-circle');
                }
            } else {
                element.classList.remove('valid');
                if (icon) {
                    icon.classList.remove('fas', 'fa-check-circle');
                    icon.classList.add('far', 'fa-circle');
                }
            }
        }

        function copySecretKey() {
            var secretEl = document.querySelector('.secret-key');
            if (secretEl) {
                var text = secretEl.innerText.trim();
                navigator.clipboard.writeText(text).then(function() {
                    alert('Secret key copied to clipboard!');
                });
            }
        }
    </script>
</asp:Content>