<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="forgot-password.aspx.cs" Inherits="Mexify.Web.forgot_password" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="Reset your MEXIFY account password. Enter your email to receive a secure reset link.">
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
            max-width: 500px;
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
            align-items: flex-start;
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
        .auth-alert i {
            margin-top: 2px;
            flex-shrink: 0;
        }
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: var(--text-gray);
            text-decoration: none;
            font-size: 0.9rem;
            margin-bottom: 24px;
            transition: color 0.3s ease;
        }
        .back-link:hover {
            color: var(--secondary);
        }
        .info-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, rgba(0, 212, 255, 0.2), rgba(0, 255, 178, 0.1));
            border-radius: 50%;
            font-size: 2rem;
            color: var(--secondary);
            border: 1px solid rgba(0, 212, 255, 0.3);
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
        .btn-primary-custom {
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
        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(37, 99, 235, 0.4);
        }
        .btn-primary-custom:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
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
        .auth-footer a:hover {
            text-decoration: underline;
        }
        .security-note {
            margin-top: 20px;
            padding: 14px;
            background: rgba(255, 215, 0, 0.05);
            border: 1px solid rgba(255, 215, 0, 0.2);
            border-radius: 10px;
            font-size: 0.8rem;
            color: var(--text-gray);
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }
        .security-note i {
            color: var(--gold);
            margin-top: 2px;
        }
        .success-view {
            text-align: center;
        }
        .success-icon {
            width: 100px;
            height: 100px;
            margin: 0 auto 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, rgba(0, 255, 178, 0.2), rgba(0, 212, 255, 0.1));
            border-radius: 50%;
            font-size: 2.5rem;
            color: var(--accent);
            border: 2px solid rgba(0, 255, 178, 0.3);
            animation: successPulse 2s ease-in-out infinite;
        }
        @keyframes successPulse {
            0%, 100% { box-shadow: 0 0 0 0 rgba(0, 255, 178, 0.4); }
            50% { box-shadow: 0 0 0 15px rgba(0, 255, 178, 0); }
        }
        .success-view h4 {
            color: var(--text-white);
            margin-bottom: 12px;
            font-size: 1.4rem;
        }
        .success-view p {
            color: var(--text-gray);
            margin-bottom: 16px;
            line-height: 1.6;
        }
        .email-highlight {
            color: var(--secondary);
            font-weight: 600;
        }
        .resend-link {
            display: inline-block;
            margin-top: 16px;
            color: var(--secondary);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            background: none;
            border: none;
        }
        .resend-link:hover {
            text-decoration: underline;
        }
        @media (max-width: 576px) {
            .auth-card { padding: 32px 24px; }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <section class="auth-wrapper">
        <div class="container auth-container">
            <div class="auth-card" data-aos="zoom-in">
                
                <a href="<%= ResolveUrl("~/Web/login.aspx") %>" class="back-link">
                    <i class="fas fa-arrow-left"></i> Back to Login
                </a>

                <div class="auth-logo">MEXIFY</div>

                <!-- FORM VIEW -->
                <asp:Panel ID="pnlForm" runat="server">
                    <div class="text-center mb-4">
                        <div class="info-icon">
                            <i class="fas fa-key"></i>
                        </div>
                        <h3 class="text-white mb-2">Forgot Your Password?</h3>
                        <p class="auth-subtitle mb-0">
                            Enter your registered email address and we'll send you a secure link to reset your password.
                        </p>
                    </div>

                    <!-- Error Alert -->
                    <asp:Panel ID="pnlError" runat="server" Visible="false">
                        <div class="auth-alert error">
                            <i class="fas fa-exclamation-circle"></i>
                            <asp:Literal ID="litError" runat="server"></asp:Literal>
                        </div>
                    </asp:Panel>

                    <!-- Email Input -->
                    <div class="form-group-custom">
                        <label for="<%= txtEmail.ClientID %>">Email Address</label>
                        <div class="input-icon-wrap">
                            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" 
                                placeholder="you@example.com" autocomplete="email"></asp:TextBox>
                            <i class="fas fa-envelope"></i>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <asp:Button ID="btnSendReset" runat="server" 
                        Text="Send Reset Link" 
                        CssClass="btn-primary-custom" 
                        OnClick="btnSendReset_Click" />

                    <!-- Security Note -->
                    <div class="security-note">
                        <i class="fas fa-shield-alt"></i>
                        <div>
                            <strong class="text-white">Security Notice:</strong><br>
                            The reset link will expire in 2 hours. If you don't receive an email, check your spam folder or contact support.
                        </div>
                    </div>
                </asp:Panel>

                <!-- SUCCESS VIEW -->
                <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
                    <div class="success-view">
                        <div class="success-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <h4>Check Your Email</h4>
                        <p>
                            If an account exists with 
                            <span class="email-highlight"><asp:Literal ID="litEmailUsed" runat="server"></asp:Literal></span>,
                            we've sent password reset instructions to your inbox.
                        </p>
                        <p class="small text-muted">
                            <i class="fas fa-clock me-1"></i> The link will expire in 2 hours.
                        </p>

                        <div class="security-note" style="text-align: left;">
                            <i class="fas fa-info-circle"></i>
                            <div>
                                <strong class="text-white">Didn't receive the email?</strong><br>
                                Check your spam folder, or click below to resend the reset link.
                            </div>
                        </div>

                        <asp:Button ID="btnResend" runat="server" 
                            Text="Resend Reset Link" 
                            CssClass="resend-link" 
                            OnClick="btnResend_Click" />

                        <div class="auth-footer">
                            Remember your password? 
                            <a href="<%= ResolveUrl("~/Web/login.aspx") %>">Login here</a>
                        </div>
                    </div>
                </asp:Panel>

            </div>
        </div>
    </section>

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        // Auto-focus email input on page load
        document.addEventListener('DOMContentLoaded', function() {
            const emailInput = document.getElementById('<%= txtEmail.ClientID %>');
            if (emailInput) {
                emailInput.focus();
            }
        });
    </script>
</asp:Content>