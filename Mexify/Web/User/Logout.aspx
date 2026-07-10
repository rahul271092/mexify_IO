<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="Logout.aspx.cs" Inherits="Mexify.Web.User.Logout" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="robots" content="noindex, nofollow">
    <style>
        .logout-wrapper {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--bg-primary);
            position: relative;
            overflow: hidden;
            padding: 20px;
        }
        .logout-wrapper::before {
            content: '';
            position: absolute;
            top: -50%; right: -20%;
            width: 800px; height: 800px;
            background: radial-gradient(circle, rgba(37, 99, 235, 0.15) 0%, transparent 70%);
            animation: float 15s ease-in-out infinite;
        }
        .logout-wrapper::after {
            content: '';
            position: absolute;
            bottom: -30%; left: -20%;
            width: 600px; height: 600px;
            background: radial-gradient(circle, rgba(0, 255, 178, 0.1) 0%, transparent 70%);
            animation: float 12s ease-in-out infinite reverse;
        }
        @keyframes float {
            0%,100%{transform:translate(0,0) scale(1)}
            50%{transform:translate(30px,-30px) scale(1.1)}
        }

        .logout-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-xl);
            padding: 48px;
            max-width: 500px;
            width: 100%;
            text-align: center;
            position: relative;
            z-index: 2;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            animation: slideUp 0.6s ease-out;
        }
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .logout-icon-wrap {
            width: 100px;
            height: 100px;
            margin: 0 auto 24px;
            border-radius: 50%;
            background: linear-gradient(135deg, rgba(0, 255, 178, 0.15), rgba(0, 212, 255, 0.1));
            border: 2px solid rgba(0, 255, 178, 0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            animation: pulse 2s ease-in-out infinite;
        }
        @keyframes pulse {
            0%, 100% { box-shadow: 0 0 0 0 rgba(0, 255, 178, 0.4); }
            50% { box-shadow: 0 0 0 20px rgba(0, 255, 178, 0); }
        }
        .logout-icon-wrap i {
            font-size: 2.5rem;
            background: linear-gradient(135deg, var(--accent), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .logout-title {
            color: var(--text-white);
            font-size: 1.8rem;
            font-weight: 800;
            margin-bottom: 12px;
            font-family: 'Space Grotesk', sans-serif;
        }
        .logout-message {
            color: var(--text-gray);
            font-size: 1rem;
            margin-bottom: 32px;
            line-height: 1.6;
        }

        .logout-details {
            background: rgba(0, 0, 0, 0.2);
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 28px;
            text-align: left;
        }
        .logout-detail-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 8px 0;
            color: var(--text-gray);
            font-size: 0.9rem;
        }
        .logout-detail-item:not(:last-child) {
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }
        .logout-detail-item i {
            color: var(--accent);
            width: 20px;
            text-align: center;
        }

        .redirect-info {
            color: var(--text-muted);
            font-size: 0.85rem;
            margin-bottom: 20px;
        }
        .redirect-info strong {
            color: var(--secondary);
        }

        .logout-actions {
            display: flex;
            gap: 12px;
            justify-content: center;
            flex-wrap: wrap;
        }
        .btn-login-redirect {
            padding: 12px 28px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            border-radius: 50px;
            color: var(--text-white);
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-login-redirect:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(37, 99, 235, 0.4);
        }
        .btn-home-redirect {
            padding: 12px 28px;
            background: transparent;
            border: 1px solid var(--glass-border);
            border-radius: 50px;
            color: var(--text-gray);
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-home-redirect:hover {
            background: rgba(255, 255, 255, 0.05);
            color: var(--text-white);
            border-color: var(--secondary);
        }

        .countdown-bar {
            height: 3px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50px;
            overflow: hidden;
            margin-top: 24px;
        }
        .countdown-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--accent), var(--secondary));
            border-radius: 50px;
            width: 100%;
            animation: countdown 5s linear forwards;
        }
        @keyframes countdown {
            from { width: 100%; }
            to { width: 0%; }
        }

        .security-note {
            margin-top: 24px;
            padding: 12px 16px;
            background: rgba(0, 212, 255, 0.05);
            border: 1px solid rgba(0, 212, 255, 0.2);
            border-radius: 10px;
            font-size: 0.8rem;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .security-note i {
            color: var(--secondary);
            font-size: 1rem;
        }

        @media (max-width: 576px) {
            .logout-card { padding: 32px 24px; }
            .logout-title { font-size: 1.4rem; }
            .logout-icon-wrap { width: 80px; height: 80px; }
            .logout-icon-wrap i { font-size: 2rem; }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <section class="logout-wrapper">
        <div class="logout-card" data-aos="zoom-in">
            
            <div class="logout-icon-wrap">
                <i class="fas fa-sign-out-alt"></i>
            </div>

            <h1 class="logout-title">You've Been Logged Out</h1>
            <p class="logout-message">
                <asp:Literal ID="litMessage" runat="server" Text="Your session has been securely ended. All authentication tokens have been cleared."></asp:Literal>
            </p>

            <!-- Cleanup Details -->
            <div class="logout-details">
                <div class="logout-detail-item">
                    <i class="fas fa-check-circle"></i>
                    <span>Session data cleared</span>
                </div>
                <div class="logout-detail-item">
                    <i class="fas fa-check-circle"></i>
                    <span>Authentication cookie removed</span>
                </div>
                <div class="logout-detail-item">
                    <i class="fas fa-check-circle"></i>
                    <span>Login activity recorded</span>
                </div>
                <div class="logout-detail-item">
                    <i class="fas fa-check-circle"></i>
                    <span>Temporary files cleaned</span>
                </div>
            </div>

            <!-- Redirect Info -->
            <div class="redirect-info">
                Redirecting to login page in <strong id="countdown">5</strong> seconds...
            </div>

            <!-- Action Buttons -->
            <div class="logout-actions">
                <a href="<%= ResolveUrl("~/Web/login.aspx") %>" class="btn-login-redirect">
                    <i class="fas fa-sign-in-alt"></i> Login Again
                </a>
                <a href="<%= ResolveUrl("~/") %>" class="btn-home-redirect">
                    <i class="fas fa-home"></i> Go Home
                </a>
            </div>

            <!-- Progress Bar -->
            <div class="countdown-bar">
                <div class="countdown-fill"></div>
            </div>

            <!-- Security Note -->
            <div class="security-note">
                <i class="fas fa-shield-alt"></i>
                <span>For security, always log out when using a shared or public device.</span>
            </div>

        </div>
    </section>

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        // Countdown timer
        (function() {
            var seconds = 5;
            var countdownEl = document.getElementById('countdown');
            var loginUrl = '<%= ResolveUrl("~/Web/login.aspx?logout=1") %>';

            var timer = setInterval(function() {
                seconds--;
                if (countdownEl) {
                    countdownEl.textContent = seconds;
                }
                if (seconds <= 0) {
                    clearInterval(timer);
                    window.location.href = loginUrl;
                }
            }, 1000);
        })();
    </script>
</asp:Content>