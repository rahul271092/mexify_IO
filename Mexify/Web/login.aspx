<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="Mexify.Web.login" %>


<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="Login to your MEXIFY account to manage your crypto investments, wallet, and portfolio.">
    <style>
        .auth-wrapper {
            min-height: 100vh;
            display: flex;
            align-items: center;
            padding: 100px 0 60px;
            background: var(--bg-primary);
            position: relative;
            overflow: hidden;
        }
        .auth-wrapper::before {
            content: '';
            position: absolute;
            top: -50%; right: -20%;
            width: 800px; height: 800px;
            background: radial-gradient(circle, rgba(37, 99, 235, 0.15) 0%, transparent 70%);
            animation: float 15s ease-in-out infinite;
        }
        .auth-wrapper::after {
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
        .auth-container {
            position: relative;
            z-index: 2;
            width: 100%;
        }
        .auth-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-xl);
            padding: 48px;
            max-width: 480px;
            margin: 0 auto;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }
        .auth-logo {
            font-family: 'Space Grotesk', sans-serif;
            font-size: 2.2rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--secondary), var(--accent));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-align: center;
            margin-bottom: 8px;
        }
        .auth-subtitle {
            text-align: center;
            color: var(--text-gray);
            margin-bottom: 32px;
            font-size: 0.95rem;
        }
        .auth-alert {
            padding: 12px 16px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .auth-alert.error {
            background: rgba(255, 59, 92, 0.1);
            border: 1px solid rgba(255, 59, 92, 0.3);
            color: #ff3b5c;
        }
        .auth-alert.success {
            background: rgba(0, 255, 178, 0.1);
            border: 1px solid rgba(0, 255, 178, 0.3);
            color: var(--accent);
        }
        .auth-alert.warning {
            background: rgba(255, 215, 0, 0.1);
            border: 1px solid rgba(255, 215, 0, 0.3);
            color: var(--gold);
        }
        .form-group-custom {
            margin-bottom: 20px;
        }
        .form-group-custom label {
            display: block;
            color: var(--text-white);
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 8px;
        }
        .input-icon-wrap {
            position: relative;
        }
        .input-icon-wrap i {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            transition: color 0.3s ease;
        }
        .input-icon-wrap input {
            width: 100%;
            padding: 14px 16px 14px 46px;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            color: var(--text-white);
            font-size: 0.95rem;
            transition: all 0.3s ease;
        }
        .input-icon-wrap input:focus {
            outline: none;
            border-color: var(--secondary);
            background: rgba(0, 212, 255, 0.03);
            box-shadow: 0 0 0 3px rgba(0, 212, 255, 0.1);
        }
        .input-icon-wrap input:focus + i,
        .input-icon-wrap:focus-within i {
            color: var(--secondary);
        }
        .password-toggle {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            background: transparent;
            border: none;
            color: var(--text-muted);
            cursor: pointer;
            padding: 4px;
        }
        .password-toggle:hover { color: var(--secondary); }
        .auth-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            font-size: 0.9rem;
        }
        .auth-options .form-check {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .auth-options .form-check-input {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--glass-border);
        }
        .auth-options .form-check-input:checked {
            background-color: var(--secondary);
            border-color: var(--secondary);
        }
        .auth-options .form-check-label {
            color: var(--text-gray);
            margin: 0;
            cursor: pointer;
        }
        .auth-options a {
            color: var(--secondary);
            text-decoration: none;
            font-weight: 500;
        }
        .auth-options a:hover { text-decoration: underline; }
        .btn-login {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            border-radius: 12px;
            color: var(--text-white);
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            letter-spacing: 0.5px;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(37, 99, 235, 0.4);
        }
        .btn-login:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }
        .auth-divider {
            display: flex;
            align-items: center;
            margin: 24px 0;
            color: var(--text-muted);
            font-size: 0.8rem;
        }
        .auth-divider::before, .auth-divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: var(--glass-border);
        }
        .auth-divider span { padding: 0 16px; }
        .social-login {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-bottom: 24px;
        }
        .social-btn {
            padding: 12px;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            color: var(--text-white);
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 0.9rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        .social-btn:hover {
            background: rgba(255, 255, 255, 0.08);
            border-color: var(--secondary);
            transform: translateY(-2px);
        }
        .auth-footer {
            text-align: center;
            color: var(--text-gray);
            font-size: 0.9rem;
            margin-top: 24px;
        }
        .auth-footer a {
            color: var(--secondary);
            font-weight: 600;
            text-decoration: none;
        }
        .auth-footer a:hover { text-decoration: underline; }
        @media (max-width: 576px) {
            .auth-card { padding: 32px 24px; }
            .social-login { grid-template-columns: 1fr; }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <section class="auth-wrapper">
        <div class="container auth-container">
            <div class="auth-card" data-aos="zoom-in">
                
                <div class="auth-logo">MEXIFY</div>
                <p class="auth-subtitle">Welcome back! Login to your account</p>

                <!-- Alerts -->
                <asp:Panel ID="pnlError" runat="server" Visible="false">
                    <div class="auth-alert error">
                        <i class="fas fa-exclamation-circle"></i>
                        <asp:Literal ID="litError" runat="server"></asp:Literal>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
                    <div class="auth-alert success">
                        <i class="fas fa-check-circle"></i>
                        <asp:Literal ID="litSuccess" runat="server"></asp:Literal>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlWarning" runat="server" Visible="false">
                    <div class="auth-alert warning">
                        <i class="fas fa-exclamation-triangle"></i>
                        <asp:Literal ID="litWarning" runat="server"></asp:Literal>
                    </div>
                </asp:Panel>

                <!-- Login Form - NO VALIDATION -->
                <asp:Panel ID="pnlForm" runat="server" DefaultButton="btnLogin">
                    <div class="form-group-custom">
                        <label for="<%= txtEmail.ClientID %>">Email Address</label>
                        <div class="input-icon-wrap">
                            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="you@example.com" autocomplete="email"></asp:TextBox>
                            <i class="fas fa-envelope"></i>
                        </div>
                    </div>

                    <div class="form-group-custom">
                        <label for="<%= txtPassword.ClientID %>">Password</label>
                        <div class="input-icon-wrap">
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="••••••••" autocomplete="current-password"></asp:TextBox>
                            <i class="fas fa-lock"></i>
                            <button type="button" class="password-toggle" onclick="togglePassword()" aria-label="Toggle password visibility">
                                <i class="fas fa-eye" id="passwordToggleIcon"></i>
                            </button>
                        </div>
                    </div>

                    <div class="auth-options">
                        <div class="form-check">
                            <asp:CheckBox ID="chkRemember" runat="server" CssClass="form-check-input" />
                            <label class="form-check-label" for="<%= chkRemember.ClientID %>">Remember me</label>
                        </div>
                        <a href="<%= ResolveUrl("~/Web/forgot-password.aspx") %>">Forgot password?</a>
                    </div>

                    <asp:Button ID="btnLogin" runat="server" Text="Login to Account" CssClass="btn-login" OnClick="btnLogin_Click" />
                </asp:Panel>

                <div class="auth-divider"><span>OR CONTINUE WITH</span></div>

                <div class="social-login">
                    <button type="button" class="social-btn">
                        <i class="fab fa-google"></i> Google
                    </button>
                    <button type="button" class="social-btn">
                        <i class="fab fa-apple"></i> Apple
                    </button>
                </div>

                <div class="auth-footer">
                    Don't have an account? 
                    <a href="<%= ResolveUrl("~/Web/register.aspx") %>">Create one now</a>
                </div>
            </div>
        </div>
    </section>

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        function togglePassword() {
            const input = document.getElementById('<%= txtPassword.ClientID %>');
            const icon = document.getElementById('passwordToggleIcon');
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }
    </script>
</asp:Content>