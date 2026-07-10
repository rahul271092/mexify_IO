<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="Mexify.Web.User.Profile" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .profile-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            flex-wrap: wrap;
            gap: 16px;
        }
        .profile-header h2 { color: var(--text-white); margin: 0; font-size: 1.8rem; }

        .profile-tabs {
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
        .profile-tab {
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
        .profile-tab.active {
            background: linear-gradient(135deg, #14B8A6, #0D9488);
            color: #fff;
            box-shadow: 0 4px 12px rgba(20, 184, 166, 0.3);
        }
        .profile-tab:hover:not(.active) {
            background: rgba(255, 255, 255, 0.05);
            color: var(--text-white);
        }

        .profile-hero {
            background: linear-gradient(135deg, rgba(20, 184, 166, 0.15), rgba(13, 148, 136, 0.1));
            border: 1px solid rgba(20, 184, 166, 0.3);
            border-radius: var(--radius-xl);
            padding: 40px;
            position: relative;
            overflow: hidden;
            margin-bottom: 32px;
        }
        .profile-hero::before {
            content: '';
            position: absolute;
            top: -50%; right: -10%;
            width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(20, 184, 166, 0.15) 0%, transparent 70%);
            animation: float 15s ease-in-out infinite;
        }
        @keyframes float {
            0%,100%{transform:translate(0,0) scale(1)}
            50%{transform:translate(20px,-20px) scale(1.1)}
        }

        .profile-avatar-wrap {
            position: relative;
            display: inline-block;
        }
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 4px solid rgba(20, 184, 166, 0.5);
            object-fit: cover;
            background: var(--glass-bg);
        }
        .avatar-upload-btn {
            position: absolute;
            bottom: 0;
            right: 0;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: linear-gradient(135deg, #14B8A6, #0D9488);
            color: #fff;
            border: 3px solid var(--bg-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .avatar-upload-btn:hover {
            transform: scale(1.1);
            box-shadow: 0 4px 12px rgba(20, 184, 166, 0.4);
        }

        .profile-name {
            color: var(--text-white);
            font-size: 1.8rem;
            font-weight: 800;
            margin: 16px 0 4px;
        }
        .profile-email {
            color: var(--text-gray);
            font-size: 0.95rem;
            margin-bottom: 12px;
        }
        .profile-tier-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: 50px;
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .tier-standard { background: rgba(107, 117, 141, 0.2); color: var(--text-gray); border: 1px solid rgba(107, 117, 141, 0.3); }
        .tier-silver { background: rgba(192, 192, 192, 0.2); color: #C0C0C0; border: 1px solid rgba(192, 192, 192, 0.3); }
        .tier-gold { background: rgba(255, 215, 0, 0.2); color: var(--gold); border: 1px solid rgba(255, 215, 0, 0.3); }
        .tier-platinum { background: rgba(229, 228, 226, 0.2); color: #E5E4E2; border: 1px solid rgba(229, 228, 226, 0.3); }

        .kyc-banner {
            padding: 16px 20px;
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            gap: 14px;
            margin-top: 20px;
        }
        .kyc-banner.verified {
            background: rgba(0, 255, 178, 0.1);
            border: 1px solid rgba(0, 255, 178, 0.3);
        }
        .kyc-banner.pending {
            background: rgba(255, 215, 0, 0.1);
            border: 1px solid rgba(255, 215, 0, 0.3);
        }
        .kyc-banner.unverified {
            background: rgba(255, 59, 92, 0.1);
            border: 1px solid rgba(255, 59, 92, 0.3);
        }
        .kyc-icon {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            flex-shrink: 0;
        }
        .kyc-banner.verified .kyc-icon { background: rgba(0, 255, 178, 0.2); color: var(--accent); }
        .kyc-banner.pending .kyc-icon { background: rgba(255, 215, 0, 0.2); color: var(--gold); }
        .kyc-banner.unverified .kyc-icon { background: rgba(255, 59, 92, 0.2); color: #ff3b5c; }
        .kyc-title { color: var(--text-white); font-weight: 600; margin-bottom: 2px; }
        .kyc-desc { color: var(--text-gray); font-size: 0.85rem; margin: 0; }

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
        .info-card-title i { color: #14B8A6; }

        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 14px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.03);
            flex-wrap: wrap;
            gap: 8px;
        }
        .info-row:last-child { border-bottom: none; }
        .info-label {
            color: var(--text-muted);
            font-size: 0.85rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .info-label i { color: #14B8A6; font-size: 0.9rem; }
        .info-value {
            color: var(--text-white);
            font-weight: 600;
            font-size: 0.95rem;
            text-align: right;
        }

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
            border-color: #14B8A6;
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
        .stat-card .icon.teal { background: rgba(20, 184, 166, 0.15); color: #14B8A6; }
        .stat-card .icon.gold { background: rgba(255, 215, 0, 0.15); color: var(--gold); }
        .stat-card .icon.accent { background: rgba(0, 255, 178, 0.15); color: var(--accent); }
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
            border-color: #14B8A6;
            background: rgba(20, 184, 166, 0.03);
            box-shadow: 0 0 0 3px rgba(20, 184, 166, 0.1);
        }
        .input-icon-wrap input:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }
        .input-icon-wrap:focus-within i.input-icon { color: #14B8A6; }

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

        .security-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px;
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-md);
            margin-bottom: 12px;
            transition: all 0.3s ease;
        }
        .security-item:hover {
            border-color: #14B8A6;
            background: rgba(20, 184, 166, 0.03);
        }
        .security-info {
            display: flex;
            align-items: center;
            gap: 14px;
            flex: 1;
        }
        .security-icon {
            width: 42px;
            height: 42px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1rem;
            flex-shrink: 0;
        }
        .security-icon.enabled { background: rgba(0, 255, 178, 0.15); color: var(--accent); }
        .security-icon.disabled { background: rgba(255, 59, 92, 0.15); color: #ff3b5c; }
        .security-icon.neutral { background: rgba(0, 212, 255, 0.15); color: var(--secondary); }
        .security-title { color: var(--text-white); font-weight: 600; font-size: 0.95rem; margin-bottom: 2px; }
        .security-desc { color: var(--text-muted); font-size: 0.8rem; }
        .security-status {
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        .status-enabled { background: rgba(0, 255, 178, 0.15); color: var(--accent); }
        .status-disabled { background: rgba(255, 59, 92, 0.15); color: #ff3b5c; }

        .btn-primary-teal {
            padding: 12px 24px;
            background: linear-gradient(135deg, #14B8A6, #0D9488);
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
        .btn-primary-teal:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(20, 184, 166, 0.4);
        }
        .btn-outline-teal {
            padding: 12px 24px;
            background: transparent;
            border: 1px solid rgba(20, 184, 166, 0.4);
            border-radius: 10px;
            color: #14B8A6;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-outline-teal:hover {
            background: rgba(20, 184, 166, 0.1);
            border-color: #14B8A6;
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

        .login-history-item {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 14px 0;
            border-bottom: 1px solid var(--glass-border);
        }
        .login-history-item:last-child { border-bottom: none; }
        .login-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(20, 184, 166, 0.15);
            color: #14B8A6;
            flex-shrink: 0;
        }
        .login-info { flex: 1; min-width: 0; }
        .login-title { color: var(--text-white); font-weight: 600; font-size: 0.9rem; margin-bottom: 2px; }
        .login-meta { color: var(--text-muted); font-size: 0.75rem; }

        @media (max-width: 768px) {
            .profile-avatar { width: 100px; height: 100px; }
            .profile-name { font-size: 1.4rem; }
            .info-row { flex-direction: column; align-items: flex-start; gap: 4px; }
            .info-value { text-align: left; }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Header -->
    <div class="profile-header" data-aos="fade-up">
        <div>
            <h2>My Profile</h2>
            <p class="text-gray mb-0">Manage your account information and security</p>
        </div>
    </div>

    <!-- Tabs -->
    <div class="profile-tabs" data-aos="fade-up">
        <button class="profile-tab active" data-tab="overview">
            <i class="fas fa-user me-1"></i> Overview
        </button>
        <button class="profile-tab" data-tab="edit">
            <i class="fas fa-edit me-1"></i> Edit Profile
        </button>
        <button class="profile-tab" data-tab="security">
            <i class="fas fa-shield-alt me-1"></i> Security
        </button>
        <button class="profile-tab" data-tab="activity">
            <i class="fas fa-history me-1"></i> Activity
        </button>
    </div>

    <!-- OVERVIEW TAB -->
    <div id="tab-overview" class="tab-content" data-aos="fade-up">
        
        <!-- Profile Hero -->
        <div class="profile-hero">
            <div class="row align-items-center position-relative" style="z-index: 2;">
                <div class="col-lg-8">
                    <div class="d-flex align-items-center gap-4 flex-wrap">
                        <div class="profile-avatar-wrap">
                            <img src='<%= ProfilePhotoUrl %>' 
                                 alt="Profile" 
                                 class="profile-avatar"
                                 id="profileAvatar"
                                 onerror="this.src='https://ui-avatars.com/api/?name=<%= Server.UrlEncode(UserFullName) %>&background=14B8A6&color=fff&size=200'">
                        </div>
                        <div>
                            <div class="profile-name"><asp:Literal ID="litFullName" runat="server" Text="User"></asp:Literal></div>
                            <div class="profile-email">
                                <i class="fas fa-envelope me-1"></i>
                                <asp:Literal ID="litEmail" runat="server" Text=""></asp:Literal>
                            </div>
                            <span class='profile-tier-badge <%# TierClass %>'>
                                <i class='<%# TierIcon %>'></i>
                                <asp:Literal ID="litTierName" runat="server" Text="Standard"></asp:Literal> Member
                            </span>
                        </div>
                    </div>

                    <!-- KYC Banner -->
                    <div class='kyc-banner <%# KYCStatusClass %>'>
                        <div class="kyc-icon">
                            <i class='<%# KYCStatusIcon %>'></i>
                        </div>
                        <div style="flex: 1;">
                            <div class="kyc-title"><asp:Literal ID="litKYCTitle" runat="server" Text="KYC Not Verified"></asp:Literal></div>
                            <p class="kyc-desc"><asp:Literal ID="litKYCDesc" runat="server" Text=""></asp:Literal></p>
                        </div>
                        <asp:Panel ID="pnlKYCButton" runat="server">
                            <a href="<%= ResolveUrl("~/Web/User/KYC.aspx") %>" class="btn btn-outline-teal">
                                <i class="fas fa-id-card me-1"></i> Verify Now
                            </a>
                        </asp:Panel>
                    </div>
                </div>
                <div class="col-lg-4 mt-4 mt-lg-0">
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="stat-card">
                                <div class="icon teal"><i class="fas fa-calendar-alt"></i></div>
                                <div class="value" style="font-size: 1.2rem;">
                                    <asp:Literal ID="litMemberDays" runat="server" Text="0"></asp:Literal>
                                </div>
                                <div class="label">Days Member</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stat-card">
                                <div class="icon gold"><i class="fas fa-coins"></i></div>
                                <div class="value" style="font-size: 1.2rem;">
                                    <asp:Literal ID="litTotalInvested" runat="server" Text="0"></asp:Literal>
                                </div>
                                <div class="label">Total Invested</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stat-card">
                                <div class="icon accent"><i class="fas fa-chart-line"></i></div>
                                <div class="value" style="font-size: 1.2rem;">
                                    <asp:Literal ID="litTotalEarned" runat="server" Text="0"></asp:Literal>
                                </div>
                                <div class="label">Total Earned</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stat-card">
                                <div class="icon secondary"><i class="fas fa-users"></i></div>
                                <div class="value" style="font-size: 1.2rem;">
                                    <asp:Literal ID="litTeamSize" runat="server" Text="0"></asp:Literal>
                                </div>
                                <div class="label">Team Size</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Info Cards -->
        <div class="row g-4">
            <div class="col-lg-6">
                <div class="info-card">
                    <div class="info-card-header">
                        <h5 class="info-card-title">
                            <i class="fas fa-id-card"></i>
                            Personal Information
                        </h5>
                        <button class="profile-tab" onclick="document.querySelector('[data-tab=edit]').click()">
                            <i class="fas fa-edit"></i> Edit
                        </button>
                    </div>
                    <div class="info-row">
                        <div class="info-label"><i class="fas fa-user"></i> Full Name</div>
                        <div class="info-value"><asp:Literal ID="litInfoName" runat="server"></asp:Literal></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label"><i class="fas fa-envelope"></i> Email</div>
                        <div class="info-value"><asp:Literal ID="litInfoEmail" runat="server"></asp:Literal></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label"><i class="fas fa-phone"></i> Phone</div>
                        <div class="info-value"><asp:Literal ID="litInfoPhone" runat="server" Text="Not provided"></asp:Literal></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label"><i class="fas fa-globe"></i> Country</div>
                        <div class="info-value"><asp:Literal ID="litInfoCountry" runat="server" Text="Not provided"></asp:Literal></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label"><i class="fas fa-link"></i> Referral Code</div>
                        <div class="info-value" style="color: #14B8A6; font-family: 'Courier New', monospace;">
                            <asp:Literal ID="litReferralCode" runat="server" Text="—"></asp:Literal>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-6">
                <div class="info-card">
                    <div class="info-card-header">
                        <h5 class="info-card-title">
                            <i class="fas fa-info-circle"></i>
                            Account Information
                        </h5>
                    </div>
                    <div class="info-row">
                        <div class="info-label"><i class="fas fa-user-tag"></i> User ID</div>
                        <div class="info-value">#<asp:Literal ID="litUserId" runat="server"></asp:Literal></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label"><i class="fas fa-crown"></i> Membership Tier</div>
                        <div class="info-value"><asp:Literal ID="litInfoTier" runat="server" Text="Standard"></asp:Literal></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label"><i class="fas fa-calendar-plus"></i> Member Since</div>
                        <div class="info-value"><asp:Literal ID="litJoinDate" runat="server"></asp:Literal></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label"><i class="fas fa-clock"></i> Last Login</div>
                        <div class="info-value"><asp:Literal ID="litLastLogin" runat="server" Text="—"></asp:Literal></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label"><i class="fas fa-check-circle"></i> Email Verified</div>
                        <div class="info-value">
                            <asp:Panel ID="pnlEmailVerified" runat="server">
                                <span style="color: var(--accent);"><i class="fas fa-check-circle me-1"></i> Verified</span>
                            </asp:Panel>
                            <asp:Panel ID="pnlEmailNotVerified" runat="server" Visible="false">
                                <span style="color: #ff3b5c;"><i class="fas fa-times-circle me-1"></i> Not Verified</span>
                            </asp:Panel>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- EDIT PROFILE TAB -->
    <div id="tab-edit" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <asp:Panel ID="pnlEditError" runat="server" Visible="false">
            <div class="alert-box error">
                <i class="fas fa-exclamation-circle"></i>
                <asp:Literal ID="litEditError" runat="server"></asp:Literal>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlEditSuccess" runat="server" Visible="false">
            <div class="alert-box success">
                <i class="fas fa-check-circle"></i>
                <asp:Literal ID="litEditSuccess" runat="server"></asp:Literal>
            </div>
        </asp:Panel>

        <div class="row g-4">
            <div class="col-lg-8">
                <div class="info-card">
                    <div class="info-card-header">
                        <h5 class="info-card-title">
                            <i class="fas fa-edit"></i>
                            Edit Profile Information
                        </h5>
                    </div>

                    <asp:Panel ID="pnlEditForm" runat="server" DefaultButton="btnSaveProfile">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="form-group-custom">
                                    <label>First Name <span class="required">*</span></label>
                                    <div class="input-icon-wrap">
                                        <asp:TextBox ID="txtFirstName" runat="server" placeholder="John"></asp:TextBox>
                                        <i class="fas fa-user input-icon"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group-custom">
                                    <label>Last Name <span class="required">*</span></label>
                                    <div class="input-icon-wrap">
                                        <asp:TextBox ID="txtLastName" runat="server" placeholder="Doe"></asp:TextBox>
                                        <i class="fas fa-user input-icon"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group-custom">
                                    <label>Email Address</label>
                                    <div class="input-icon-wrap">
                                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" Enabled="false"></asp:TextBox>
                                        <i class="fas fa-envelope input-icon"></i>
                                    </div>
                                    <small class="text-muted">Email cannot be changed for security reasons</small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group-custom">
                                    <label>Phone Number</label>
                                    <div class="input-icon-wrap">
                                        <asp:TextBox ID="txtPhone" runat="server" placeholder="+1 234 567 8900"></asp:TextBox>
                                        <i class="fas fa-phone input-icon"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group-custom">
                                    <label>Country</label>
                                    <div class="input-icon-wrap">
                                        <asp:DropDownList ID="ddlCountry" runat="server">
                                            <asp:ListItem Value="" Text="Select country"></asp:ListItem>
                                        </asp:DropDownList>
                                        <i class="fas fa-globe input-icon"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group-custom">
                                    <label>Timezone</label>
                                    <div class="input-icon-wrap">
                                        <asp:DropDownList ID="ddlTimezone" runat="server">
                                            <asp:ListItem Value="UTC" Text="UTC (Coordinated Universal Time)"></asp:ListItem>
                                            <asp:ListItem Value="EST" Text="EST (Eastern Standard Time)"></asp:ListItem>
                                            <asp:ListItem Value="PST" Text="PST (Pacific Standard Time)"></asp:ListItem>
                                            <asp:ListItem Value="CST" Text="CST (Central Standard Time)"></asp:ListItem>
                                            <asp:ListItem Value="GMT" Text="GMT (Greenwich Mean Time)"></asp:ListItem>
                                            <asp:ListItem Value="CET" Text="CET (Central European Time)"></asp:ListItem>
                                            <asp:ListItem Value="IST" Text="IST (India Standard Time)"></asp:ListItem>
                                            <asp:ListItem Value="JST" Text="JST (Japan Standard Time)"></asp:ListItem>
                                        </asp:DropDownList>
                                        <i class="fas fa-clock input-icon"></i>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex gap-3 mt-4 flex-wrap">
                            <asp:Button ID="btnSaveProfile" runat="server" Text="Save Changes" CssClass="btn-primary-teal" OnClick="btnSaveProfile_Click" />
                            <asp:Button ID="btnCancelEdit" runat="server" Text="Cancel" CssClass="btn-outline-teal" OnClick="btnCancelEdit_Click" CausesValidation="false" />
                        </div>
                    </asp:Panel>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="info-card">
                    <div class="info-card-header">
                        <h5 class="info-card-title">
                            <i class="fas fa-camera"></i>
                            Profile Photo
                        </h5>
                    </div>
                    <div class="text-center">
                        <div class="profile-avatar-wrap" style="display: inline-block;">
                            <img src='<%= ProfilePhotoUrl %>' 
                                 alt="Profile" 
                                 class="profile-avatar"
                                 id="editAvatar"
                                 onerror="this.src='https://ui-avatars.com/api/?name=<%= Server.UrlEncode(UserFullName) %>&background=14B8A6&color=fff&size=200'">
                        </div>
                        <div class="mt-3">
                            <asp:FileUpload ID="fuPhoto" runat="server" CssClass="form-control" style="display: none;" accept="image/*" />
                            <button type="button" class="btn-outline-teal" onclick="document.getElementById('<%= fuPhoto.ClientID %>').click()">
                                <i class="fas fa-upload me-2"></i> Upload Photo
                            </button>
                            <small class="text-muted d-block mt-2">JPG, PNG or GIF. Max 2MB.</small>
                        </div>
                    </div>
                </div>

                <div class="info-card">
                    <div class="info-card-header">
                        <h5 class="info-card-title">
                            <i class="fas fa-link"></i>
                            Your Referral Link
                        </h5>
                    </div>
                    <div style="background: rgba(0, 0, 0, 0.3); padding: 12px; border-radius: 8px; word-break: break-all; font-family: 'Courier New', monospace; color: #14B8A6; font-size: 0.85rem;">
                        <asp:Literal ID="litReferralLink" runat="server"></asp:Literal>
                    </div>
                    <button type="button" class="btn-outline-teal w-100 mt-3" onclick="copyReferralLink()">
                        <i class="fas fa-copy me-2"></i> Copy Link
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- SECURITY TAB -->
    <div id="tab-security" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <asp:Panel ID="pnlSecurityError" runat="server" Visible="false">
            <div class="alert-box error">
                <i class="fas fa-exclamation-circle"></i>
                <asp:Literal ID="litSecurityError" runat="server"></asp:Literal>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlSecuritySuccess" runat="server" Visible="false">
            <div class="alert-box success">
                <i class="fas fa-check-circle"></i>
                <asp:Literal ID="litSecuritySuccess" runat="server"></asp:Literal>
            </div>
        </asp:Panel>

        <div class="row g-4">
            <div class="col-lg-6">
                <!-- Change Password -->
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
                                <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" placeholder="Enter new password"></asp:TextBox>
                                <i class="fas fa-lock input-icon"></i>
                            </div>
                            <small class="text-muted">Minimum 8 characters with uppercase, number, and special character</small>
                        </div>
                        <div class="form-group-custom">
                            <label>Confirm New Password <span class="required">*</span></label>
                            <div class="input-icon-wrap">
                                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" placeholder="Confirm new password"></asp:TextBox>
                                <i class="fas fa-lock input-icon"></i>
                            </div>
                        </div>

                        <asp:Button ID="btnChangePassword" runat="server" Text="Update Password" CssClass="btn-primary-teal" OnClick="btnChangePassword_Click" />
                    </asp:Panel>
                </div>
            </div>

            <div class="col-lg-6">
                <!-- Security Settings -->
                <div class="info-card">
                    <div class="info-card-header">
                        <h5 class="info-card-title">
                            <i class="fas fa-shield-alt"></i>
                            Security Settings
                        </h5>
                    </div>

                    <div class="security-item">
                        <div class="security-info">
                            <div class="security-icon enabled">
                                <i class="fas fa-mobile-alt"></i>
                            </div>
                            <div>
                                <div class="security-title">Two-Factor Authentication</div>
                                <div class="security-desc">Add an extra layer of security</div>
                            </div>
                        </div>
                        <span class='security-status <%# Is2FAEnabled ? "status-enabled" : "status-disabled" %>'>
                            <%# Is2FAEnabled ? "Enabled" : "Disabled" %>
                        </span>
                    </div>

                    <div class="security-item">
                        <div class="security-info">
                            <div class="security-icon enabled">
                                <i class="fas fa-envelope"></i>
                            </div>
                            <div>
                                <div class="security-title">Email Verification</div>
                                <div class="security-desc">Verify your email address</div>
                            </div>
                        </div>
                        <span class='security-status <%# IsEmailVerified ? "status-enabled" : "status-disabled" %>'>
                            <%# IsEmailVerified ? "Verified" : "Unverified" %>
                        </span>
                    </div>

                    <div class="security-item">
                        <div class="security-info">
                            <div class="security-icon neutral">
                                <i class="fas fa-bell"></i>
                            </div>
                            <div>
                                <div class="security-title">Login Notifications</div>
                                <div class="security-desc">Get notified of new logins</div>
                            </div>
                        </div>
                        <a href="<%= ResolveUrl("~/User/Settings.aspx") %>" class="btn-outline-teal" style="padding: 6px 14px; font-size: 0.8rem;">
                            Configure
                        </a>
                    </div>

                    <div class="security-item">
                        <div class="security-info">
                            <div class="security-icon neutral">
                                <i class="fas fa-history"></i>
                            </div>
                            <div>
                                <div class="security-title">Active Sessions</div>
                                <div class="security-desc">Manage logged-in devices</div>
                            </div>
                        </div>
                        <a href="<%= ResolveUrl("~/User/Settings.aspx") %>" class="btn-outline-teal" style="padding: 6px 14px; font-size: 0.8rem;">
                            View
                        </a>
                    </div>
                </div>

                <!-- Danger Zone -->
                <div class="info-card" style="border-color: rgba(255, 59, 92, 0.3);">
                    <div class="info-card-header">
                        <h5 class="info-card-title" style="color: #ff3b5c;">
                            <i class="fas fa-exclamation-triangle"></i>
                            Danger Zone
                        </h5>
                    </div>
                    <p class="text-gray mb-3">Once you delete your account, there is no going back. Please be certain.</p>
                    <button type="button" class="btn-outline-teal" style="border-color: rgba(255, 59, 92, 0.4); color: #ff3b5c;" onclick="confirmDeleteAccount()">
                        <i class="fas fa-trash me-2"></i> Delete Account
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- ACTIVITY TAB -->
    <div id="tab-activity" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <div class="row g-4">
            <div class="col-lg-6">
                <div class="info-card">
                    <div class="info-card-header">
                        <h5 class="info-card-title">
                            <i class="fas fa-sign-in-alt"></i>
                            Recent Login Activity
                        </h5>
                    </div>
                    <asp:Repeater ID="rptLoginHistory" runat="server">
                        <ItemTemplate>
                            <div class="login-history-item">
                                <div class="login-icon">
                                    <i class='<%# Eval("Icon") %>'></i>
                                </div>
                                <div class="login-info">
                                    <div class="login-title"><%# Eval("Device") %></div>
                                    <div class="login-meta">
                                        <i class="fas fa-map-marker-alt me-1"></i> <%# Eval("Location") %> · 
                                        <i class="fas fa-clock me-1"></i> <%# Eval("TimeAgo") %>
                                    </div>
                                </div>
                                <span class='security-status <%# Convert.ToBoolean(Eval("IsCurrent")) ? "status-enabled" : "status-disabled" %>'>
                                    <%# Convert.ToBoolean(Eval("IsCurrent")) ? "Current" : "Previous" %>
                                </span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlNoLogins" runat="server" Visible="false">
                        <div class="empty-state">
                            <i class="fas fa-sign-in-alt"></i>
                            <h4>No Login History</h4>
                            <p>Your login activity will appear here.</p>
                        </div>
                    </asp:Panel>
                </div>
            </div>

            <div class="col-lg-6">
                <div class="info-card">
                    <div class="info-card-header">
                        <h5 class="info-card-title">
                            <i class="fas fa-tasks"></i>
                            Recent Account Activity
                        </h5>
                    </div>
                    <asp:Repeater ID="rptAccountActivity" runat="server">
                        <ItemTemplate>
                            <div class="login-history-item">
                                <div class='login-icon' style='background: <%# Eval("IconBg") %>; color: <%# Eval("IconColor") %>'>
                                    <i class='<%# Eval("Icon") %>'></i>
                                </div>
                                <div class="login-info">
                                    <div class="login-title"><%# Eval("Title") %></div>
                                    <div class="login-meta">
                                        <%# Eval("TimeAgo") %>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlNoActivity" runat="server" Visible="false">
                        <div class="empty-state">
                            <i class="fas fa-tasks"></i>
                            <h4>No Activity Yet</h4>
                            <p>Your account activity will appear here.</p>
                        </div>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Tab switching
            var tabs = document.querySelectorAll('.profile-tab');
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

            // Check for tab in URL
            var urlParams = new URLSearchParams(window.location.search);
            var tabParam = urlParams.get('tab');
            if (tabParam && document.querySelector('[data-tab="' + tabParam + '"]')) {
                document.querySelector('[data-tab="' + tabParam + '"]').click();
            }

            // File upload preview
            var fileInput = document.getElementById('<%= fuPhoto.ClientID %>');
            if (fileInput) {
                fileInput.addEventListener('change', function(e) {
                    var file = e.target.files[0];
                    if (file) {
                        if (file.size > 2 * 1024 * 1024) {
                            alert('File size must be less than 2MB');
                            e.target.value = '';
                            return;
                        }
                        var reader = new FileReader();
                        reader.onload = function(e) {
                            document.getElementById('editAvatar').src = e.target.result;
                            document.getElementById('profileAvatar').src = e.target.result;
                        };
                        reader.readAsDataURL(file);
                    }
                });
            }
        });

        // Copy referral link
        function copyReferralLink() {
            var link = document.querySelector('#tab-edit .info-card div[style*="Courier"]').innerText.trim();
            navigator.clipboard.writeText(link).then(function() {
                var btn = event.target.closest('button');
                var originalHTML = btn.innerHTML;
                btn.innerHTML = '<i class="fas fa-check me-2"></i> Copied!';
                setTimeout(function() { btn.innerHTML = originalHTML; }, 2000);
            });
        }

        // Confirm delete account
        function confirmDeleteAccount() {
            if (confirm('Are you sure you want to delete your account? This action cannot be undone.')) {
                if (confirm('This will permanently delete all your data. Type DELETE to confirm.')) {
                    alert('Please contact support to delete your account.');
                }
            }
        }
    </script>
</asp:Content>