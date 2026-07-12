<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="MetaMaskLogin.aspx.cs" Inherits="Mexify.Web.MetaMaskLogin" %>
<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .login-container {
            min-height: calc(100vh - 76px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }
        .login-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-xl);
            padding: 48px;
            max-width: 480px;
            width: 100%;
            text-align: center;
        }
        .login-logo {
            width: 80px;
            height: 80px;
            margin: 0 auto 24px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            color: var(--text-white);
        }
        .login-title {
            color: var(--text-white);
            font-size: 1.8rem;
            font-weight: 800;
            margin-bottom: 8px;
        }
        .login-subtitle {
            color: var(--text-gray);
            font-size: 0.95rem;
            margin-bottom: 32px;
        }
        .metamask-btn {
            width: 100%;
            padding: 16px 24px;
            background: linear-gradient(135deg, #f6851b, #e2761b);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }
        .metamask-btn:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(246, 133, 27, 0.4);
        }
        .metamask-btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }
        .metamask-btn img {
            width: 28px;
            height: 28px;
        }
        .form-input {
            width: 100%;
            padding: 14px;
            background: rgba(255,255,255,0.05);
            border: 1px solid var(--glass-border);
            border-radius: 10px;
            color: white;
            font-size: 0.95rem;
            margin-bottom: 20px;
            box-sizing: border-box;
            text-align: center;
        }
        .form-input:focus {
            outline: none;
            border-color: var(--accent);
        }
        .form-input::placeholder {
            color: var(--text-muted);
        }
        .referral-label {
            color: var(--text-gray);
            font-size: 0.85rem;
            margin-bottom: 8px;
            text-align: left;
        }
        .alert-box {
            padding: 14px 18px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 0.9rem;
            display: flex;
            align-items: flex-start;
            gap: 10px;
            text-align: left;
        }
        .alert-box.error { background: rgba(255, 59, 92, 0.1); border: 1px solid rgba(255, 59, 92, 0.3); color: #ff3b5c; }
        .alert-box.success { background: rgba(0, 255, 178, 0.1); border: 1px solid rgba(0, 255, 178, 0.3); color: var(--accent); }
        .login-status {
            margin-top: 20px;
            padding: 12px;
            background: rgba(0, 212, 255, 0.05);
            border: 1px solid rgba(0, 212, 255, 0.2);
            border-radius: 10px;
            color: var(--text-gray);
            font-size: 0.85rem;
            display: none;
        }
        .spinner {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255,255,255,0.3);
            border-radius: 50%;
            border-top-color: #fff;
            animation: spin 1s ease-in-out infinite;
        }
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        .divider {
            display: flex;
            align-items: center;
            margin: 24px 0;
            color: var(--text-muted);
            font-size: 0.85rem;
        }
        .divider::before, .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: var(--glass-border);
        }
        .divider span {
            padding: 0 16px;
        }
        .features-list {
            text-align: left;
            margin: 24px 0;
            padding: 0;
            list-style: none;
        }
        .features-list li {
            padding: 8px 0;
            color: var(--text-gray);
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .features-list li i {
            color: var(--accent);
            font-size: 0.9rem;
        }
        .auto-register-note {
            font-size: 0.8rem;
            color: var(--text-muted);
            margin-top: 12px;
        }
        .auto-register-note i {
            color: var(--accent);
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="login-container">
        <div class="login-card" data-aos="fade-up">
            
            <!-- Logo -->
            <div class="login-logo">
                <i class="fas fa-cube"></i>
            </div>

            <h1 class="login-title">Welcome to Mexify</h1>
            <p class="login-subtitle">Connect your wallet to login or create an account</p>

            <!-- Messages -->
            <asp:Panel ID="pnlError" runat="server" Visible="false">
                <div class="alert-box error">
                    <i class="fas fa-exclamation-circle"></i>
                    <asp:Literal ID="litError" runat="server"></asp:Literal>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
                <div class="alert-box success">
                    <i class="fas fa-check-circle"></i>
                    <asp:Literal ID="litSuccess" runat="server"></asp:Literal>
                </div>
            </asp:Panel>

            <!-- Status Message -->
            <div id="loginStatus" class="login-status">
                <i class="fas fa-info-circle me-2"></i>
                <span id="statusText">Initializing...</span>
            </div>

            <!-- ✅ Referral Code Input -->
            <div class="text-start">
                <label class="referral-label">
                    <i class="fas fa-user-plus me-1"></i> Referral Code (Optional)
                </label>
            </div>
            <input type="text" id="txtReferralCode" class="form-input" placeholder="Enter referral code if you have one" />

            <!-- Visible button for user interaction -->
            <button type="button" id="btnConnectMetaMask" class="metamask-btn" onclick="initiateMetaMaskLogin()">
                <img src="Assets/images/metamask1.png" alt="MetaMask" style="width:28px;height:28px;" />
                Login / Register with MetaMask
            </button>

            <p class="auto-register-note">
                <i class="fas fa-magic me-1"></i> New wallet? An account will be created automatically.
            </p>

            <!-- Hidden server button that triggers postback -->
            <asp:Button ID="btnMetaMaskLogin" runat="server" Text="Login" 
                        OnClick="btnMetaMaskLogin_Click" 
                        Style="display: none;" UseSubmitBehavior="false" />

            <div class="divider">
                <span>Secure Web3 Authentication</span>
            </div>

            <!-- Features List -->
            <ul class="features-list">
                <li><i class="fas fa-shield-alt"></i> Secure & Private - No password needed</li>
                <li><i class="fas fa-bolt"></i> Instant Access - Login or Register in seconds</li>
                <li><i class="fas fa-lock"></i> You own your keys - Full control</li>
            </ul>

            <!-- Hidden Fields for Web3 Data -->
            <asp:HiddenField ID="hfWalletAddress" runat="server" />
            <asp:HiddenField ID="hfSignature" runat="server" />
            <asp:HiddenField ID="hfNonce" runat="server" />
            <asp:HiddenField ID="hfReferralCode" runat="server" />

        </div>
    </div>
</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        // Check if MetaMask is installed
        function isMetaMaskInstalled() {
            return typeof window.ethereum !== 'undefined' && window.ethereum.isMetaMask;
        }

        // Show status message
        function showStatus(message, isError = false) {
            const statusDiv = document.getElementById('loginStatus');
            const statusText = document.getElementById('statusText');
            if (!statusDiv || !statusText) return;
            
            statusDiv.style.display = 'block';
            statusText.textContent = message;
            
            if (isError) {
                statusDiv.style.borderColor = 'rgba(255, 59, 92, 0.3)';
                statusDiv.style.background = 'rgba(255, 59, 92, 0.05)';
                statusDiv.style.color = '#ff3b5c';
            } else {
                statusDiv.style.borderColor = 'rgba(0, 212, 255, 0.2)';
                statusDiv.style.background = 'rgba(0, 212, 255, 0.05)';
                statusDiv.style.color = 'var(--text-gray)';
            }
        }

        // Main login/register function
        async function initiateMetaMaskLogin() {
            try {
                if (!isMetaMaskInstalled()) {
                    alert('MetaMask is not installed! Please install it from https://metamask.io');
                    window.open('https://metamask.io/download/', '_blank');
                    return false;
                }

                const visibleBtn = document.getElementById('btnConnectMetaMask');
                visibleBtn.disabled = true;
                visibleBtn.innerHTML = '<span class="spinner"></span> Connecting...';

                showStatus('Connecting to MetaMask...');

                // Step 1: Request account access
                const accounts = await window.ethereum.request({ 
                    method: 'eth_requestAccounts' 
                });

                if (!accounts || accounts.length === 0) {
                    throw new Error('No accounts found. Please unlock MetaMask.');
                }

                const walletAddress = accounts[0];
                showStatus('Connected! Getting nonce from server...');

                // Step 2: Get nonce using POST
                const nonceResponse = await fetch('meta-login.aspx/GetNonce', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ wallet: walletAddress })
                });

                const responseText = await nonceResponse.text();

                if (responseText.trim().startsWith('<!DOCTYPE') || responseText.trim().startsWith('<html')) {
                    throw new Error('API endpoint not found.');
                }

                let nonceData;
                try {
                    const parsed = JSON.parse(responseText);
                    nonceData = parsed.d ? (typeof parsed.d === 'string' ? JSON.parse(parsed.d) : parsed.d) : parsed;
                } catch (e) {
                    throw new Error('Invalid response from server');
                }

                if (!nonceData.success) {
                    throw new Error('Failed to get nonce: ' + (nonceData.message || 'Unknown error'));
                }

                const nonce = nonceData.nonce;
                document.getElementById('<%= hfNonce.ClientID %>').value = nonce;

                showStatus('Please sign the message in MetaMask...');

                // Step 3: Create message to sign
                const message = `Welcome to Mexify!\n\nClick to sign in and accept the Terms of Service.\n\nThis request will not trigger a blockchain transaction or cost any fees.\n\nWallet address:\n${walletAddress}\n\nNonce:\n${nonce}`;

                // Step 4: Request signature
                const signature = await window.ethereum.request({
                    method: 'personal_sign',
                    params: [message, walletAddress]
                });

                showStatus('Signature received! Verifying...');

                // Step 5: Store in hidden fields
                document.getElementById('<%= hfWalletAddress.ClientID %>').value = walletAddress;
                document.getElementById('<%= hfSignature.ClientID %>').value = signature;
                document.getElementById('<%= hfNonce.ClientID %>').value = nonce;
                
                // ✅ Store referral code in hidden field
                const referralCode = document.getElementById('txtReferralCode').value.trim();
                document.getElementById('<%= hfReferralCode.ClientID %>').value = referralCode;

                // Step 6: Click the hidden server button
                visibleBtn.innerHTML = '<span class="spinner"></span> Verifying...';
                document.getElementById('<%= btnMetaMaskLogin.ClientID %>').click();
                
                return false;

            } catch (error) {
                console.error('MetaMask error:', error);
                
                const visibleBtn = document.getElementById('btnConnectMetaMask');
                if (visibleBtn) {
                    visibleBtn.disabled = false;
                    visibleBtn.innerHTML = '<img src="Assets/images/metamask1.png" alt="MetaMask" style="width:28px;height:28px;" /> Login / Register with MetaMask';
                }
                
                if (error.code === 4001) {
                    showStatus('You rejected the signature request. Please try again.', true);
                } else {
                    showStatus('Error: ' + (error.message || 'Unknown error'), true);
                }
                
                return false;
            }
        }

        // Listen for account changes
        if (typeof window.ethereum !== 'undefined') {
            window.ethereum.on('accountsChanged', function (accounts) {
                if (accounts.length === 0) {
                    showStatus('MetaMask disconnected. Please reconnect.', true);
                }
            });
        }

        // Check MetaMask on page load
        document.addEventListener('DOMContentLoaded', function() {
            if (!isMetaMaskInstalled()) {
                showStatus('MetaMask is not installed. Please install it to login.', true);
            } else {
                showStatus('MetaMask detected. Click the button to continue.');
            }
        });
    </script>
</asp:Content>