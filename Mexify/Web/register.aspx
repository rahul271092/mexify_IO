<%@ Page Title="Create Account " Language="C#" MasterPageFile="~/Web/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="register.aspx.cs" Inherits="Mexify.Web.register" %>


<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="Create your free MEXIFY account and start earning 2X ROI in 51 days with institutional-grade crypto investments.">
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
        .auth-container { position: relative; z-index: 2; width: 100%; }
        .auth-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-xl);
            padding: 40px;
            max-width: 600px;
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
            margin-bottom: 28px;
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
        .auth-alert i { margin-top: 2px; flex-shrink: 0; }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }
        .form-group-custom { margin-bottom: 18px; }
        .form-group-custom label {
            display: block;
            color: var(--text-white);
            font-size: 0.88rem;
            font-weight: 600;
            margin-bottom: 6px;
        }
        .form-group-custom label .required { color: #ff3b5c; }
        .input-icon-wrap { position: relative; }
        .input-icon-wrap i.input-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            transition: color 0.3s ease;
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
        .input-icon-wrap select option {
            background: var(--bg-secondary);
            color: var(--text-white);
        }
        .input-icon-wrap input:focus, 
        .input-icon-wrap select:focus {
            outline: none;
            border-color: var(--secondary);
            background: rgba(0, 212, 255, 0.03);
            box-shadow: 0 0 0 3px rgba(0, 212, 255, 0.1);
        }
        .input-icon-wrap:focus-within i.input-icon { color: var(--secondary); }
        .password-toggle {
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            background: transparent;
            border: none;
            color: var(--text-muted);
            cursor: pointer;
            padding: 4px;
            z-index: 2;
        }
        .password-toggle:hover { color: var(--secondary); }
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
            margin-top: 8px;
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
        .referral-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 14px;
            background: rgba(0, 255, 178, 0.1);
            border: 1px solid rgba(0, 255, 178, 0.3);
            border-radius: 50px;
            color: var(--accent);
            font-size: 0.85rem;
            font-weight: 600;
            margin-bottom: 20px;
        }
        .referral-badge i { color: var(--gold); }
        .terms-check {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            margin: 20px 0;
            font-size: 0.85rem;
            color: var(--text-gray);
        }
        .terms-check input {
            margin-top: 3px;
            flex-shrink: 0;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--glass-border);
        }
        .terms-check input:checked {
            background-color: var(--secondary);
            border-color: var(--secondary);
        }
        .terms-check label {
            margin: 0;
            cursor: pointer;
        }
        .terms-check a { color: var(--secondary); text-decoration: none; }
        .terms-check a:hover { text-decoration: underline; }
        .btn-register {
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
        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(37, 99, 235, 0.4);
        }
        .btn-register:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }
        .auth-footer {
            text-align: center;
            color: var(--text-gray);
            font-size: 0.9rem;
            margin-top: 20px;
        }
        .auth-footer a { color: var(--secondary); font-weight: 600; text-decoration: none; }
        .auth-footer a:hover { text-decoration: underline; }
        @media (max-width: 576px) {
            .auth-card { padding: 28px 20px; }
            .form-row { grid-template-columns: 1fr; gap: 0; }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <section class="auth-wrapper">
        <div class="container auth-container">
            <div class="auth-card" data-aos="zoom-in">
                
                <div class="auth-logo">MEXIFY</div>
                <p class="auth-subtitle">Create your free account in seconds</p>

                <!-- Referral Badge -->
                <asp:Panel ID="pnlReferral" runat="server" Visible="false">
                    <div class="text-center">
                        <span class="referral-badge">
                            <i class="fas fa-gift"></i>
                            You were invited by <strong><asp:Literal ID="litReferrerName" runat="server"></asp:Literal></strong>
                        </span>
                    </div>
                </asp:Panel>

                <!-- Error Alert -->
                <asp:Panel ID="pnlError" runat="server" Visible="false">
                    <div class="auth-alert error">
                        <i class="fas fa-exclamation-circle"></i>
                        <asp:Literal ID="litError" runat="server"></asp:Literal>
                    </div>
                </asp:Panel>

                <!-- Registration Form -->
                <asp:Panel ID="pnlForm" runat="server" DefaultButton="btnRegister">
                    
                    <div class="form-row">
                        <div class="form-group-custom">
                            <label>First Name <span class="required">*</span></label>
                            <div class="input-icon-wrap">
                                <asp:TextBox ID="txtFirstName" runat="server" placeholder="John"></asp:TextBox>
                                <i class="fas fa-user input-icon"></i>
                            </div>
                        </div>
                        <div class="form-group-custom">
                            <label>Last Name <span class="required">*</span></label>
                            <div class="input-icon-wrap">
                                <asp:TextBox ID="txtLastName" runat="server" placeholder="Doe"></asp:TextBox>
                                <i class="fas fa-user input-icon"></i>
                            </div>
                        </div>
                    </div>

                    <div class="form-group-custom">
                        <label>Email Address <span class="required">*</span></label>
                        <div class="input-icon-wrap">
                            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="you@example.com" autocomplete="email"></asp:TextBox>
                            <i class="fas fa-envelope input-icon"></i>
                        </div>
                    </div>

                    <div class="form-group-custom">
                        <label>Phone Number</label>
                        <div class="input-icon-wrap">
                            <asp:TextBox ID="txtPhone" runat="server" placeholder="+1 234 567 8900"></asp:TextBox>
                            <i class="fas fa-phone input-icon"></i>
                        </div>
                    </div>

                    <div class="form-group-custom">
                        <label>Country <span class="required">*</span></label>
                        <div class="input-icon-wrap">
                            <asp:DropDownList ID="ddlCountry" runat="server">
                                <asp:ListItem Value="" Text="Select your country"></asp:ListItem>
                            </asp:DropDownList>
                            <i class="fas fa-globe input-icon"></i>
                        </div>
                    </div>

                    <div class="form-group-custom">
                        <label>Password <span class="required">*</span></label>
                        <div class="input-icon-wrap">
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" 
                                placeholder="Create a strong password" 
                                autocomplete="new-password"
                                onkeyup="checkPasswordStrength(this.value)"></asp:TextBox>
                            <i class="fas fa-lock input-icon"></i>
                            <button type="button" class="password-toggle" onclick="togglePassword('txtPassword', 'pwdIcon1')" aria-label="Toggle password">
                                <i class="fas fa-eye" id="pwdIcon1"></i>
                            </button>
                        </div>
                        <div class="password-strength">
                            <div class="password-strength-fill" id="strengthFill"></div>
                        </div>
                        <ul class="password-requirements" id="passwordReqs">
                            <li id="reqLength"><i class="far fa-circle"></i> At least 8 characters</li>
                            <li id="reqUpper"><i class="far fa-circle"></i> One uppercase letter</li>
                            <li id="reqNumber"><i class="far fa-circle"></i> One number</li>
                            <li id="reqSpecial"><i class="far fa-circle"></i> One special character</li>
                        </ul>
                    </div>

                    <div class="form-group-custom">
                        <label>Confirm Password <span class="required">*</span></label>
                        <div class="input-icon-wrap">
                            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" 
                                placeholder="Confirm your password" 
                                autocomplete="new-password"></asp:TextBox>
                            <i class="fas fa-lock input-icon"></i>
                            <button type="button" class="password-toggle" onclick="togglePassword('txtConfirmPassword', 'pwdIcon2')" aria-label="Toggle password">
                                <i class="fas fa-eye" id="pwdIcon2"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Hidden field for referral code -->
                    <asp:HiddenField ID="hfReferralCode" runat="server" />

                    <div class="terms-check">
                        <asp:CheckBox ID="chkTerms" runat="server" />
                        <label for="<%= chkTerms.ClientID %>">
                            I agree to MEXIFY's 
                            <a href="<%= ResolveUrl("~/terms.aspx") %>" target="_blank">Terms of Service</a> and 
                            <a href="<%= ResolveUrl("~/privacy.aspx") %>" target="_blank">Privacy Policy</a>
                        </label>
                    </div>

                    <asp:Button ID="btnRegister" runat="server" 
                        Text="Create Account" 
                        CssClass="btn-register" 
                        OnClick="btnRegister_Click" />
                </asp:Panel>

                <div class="auth-footer">
                    Already have an account? 
                    <a href="<%= ResolveUrl("~/Web/login.aspx") %>">Login here</a>
                </div>
            </div>
        </div>
    </section>

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        function togglePassword(inputId, iconId) {
            const input = document.getElementById(inputId);
            const icon = document.getElementById(iconId);
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

        function checkPasswordStrength(password) {
            const fill = document.getElementById('strengthFill');
            const reqLength = document.getElementById('reqLength');
            const reqUpper = document.getElementById('reqUpper');
            const reqNumber = document.getElementById('reqNumber');
            const reqSpecial = document.getElementById('reqSpecial');

            toggleReq(reqLength, password.length >= 8);
            toggleReq(reqUpper, /[A-Z]/.test(password));
            toggleReq(reqNumber, /[0-9]/.test(password));
            toggleReq(reqSpecial, /[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\\/]/.test(password));

            let score = 0;
            if (password.length >= 8) score++;
            if (/[A-Z]/.test(password)) score++;
            if (/[0-9]/.test(password)) score++;
            if (/[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\\/]/.test(password)) score++;

            fill.className = 'password-strength-fill';
            if (password.length === 0) {
                fill.style.width = '0';
            } else if (score <= 1) {
                fill.classList.add('weak');
            } else if (score === 2) {
                fill.classList.add('fair');
            } else if (score === 3) {
                fill.classList.add('good');
            } else {
                fill.classList.add('strong');
            }
        }

        function toggleReq(element, isValid) {
            const icon = element.querySelector('i');
            if (isValid) {
                element.classList.add('valid');
                icon.classList.remove('far', 'fa-circle');
                icon.classList.add('fas', 'fa-check-circle');
            } else {
                element.classList.remove('valid');
                icon.classList.remove('fas', 'fa-check-circle');
                icon.classList.add('far', 'fa-circle');
            }
        }
    </script>
</asp:Content>