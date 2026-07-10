<%@ Page Title="" Async="true" Language="C#" MasterPageFile="~/Web/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="meta-login.aspx.cs" Inherits="Mexify.Web.meta_login" %>
<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/web3@latest/dist/web3.min.js"></script>
    <style>
        .login-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
            background: var(--bg-primary);
            position: relative;
            overflow: hidden;
        }
        .login-container::before {
            content: '';
            position: absolute;
            top: -50%; right: -20%;
            width: 800px; height: 800px;
            background: radial-gradient(circle, rgba(247, 147, 26, 0.15) 0%, transparent 70%);
            animation: float 15s ease-in-out infinite;
        }
        @keyframes float {
            0%,100%{transform:translate(0,0) scale(1)}
            50%{transform:translate(30px,-30px) scale(1.1)}
        }
        .login-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-xl);
            padding: 48px;
            max-width: 480px;
            width: 100%;
            position: relative;
            z-index: 2;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }
        .login-logo {
            text-align: center;
            margin-bottom: 32px;
        }
        .login-logo h1 {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-size: 2rem;
            font-weight: 800;
            margin: 0;
        }
        .login-logo p {
            color: var(--text-gray);
            margin: 8px 0 0;
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
        .btn-metamask {
            width: 100%;
            padding: 14px 24px;
            background: linear-gradient(135deg, #F7931A, #FFA500);
            border: none;
            border-radius: 10px;
            color: #fff;
            font-weight: 700;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }
        .btn-metamask:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(247, 147, 26, 0.4);
        }
        .btn-metamask:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }
        .wallet-connected {
            background: rgba(0, 255, 178, 0.1);
            border: 1px solid rgba(0, 255, 178, 0.3);
            border-radius: 10px;
            padding: 16px;
            margin: 16px 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .wallet-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #F7931A, #FFA500);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            color: #fff;
        }
        .wallet-address {
            font-family: 'Courier New', monospace;
            color: var(--text-white);
            font-weight: 600;
        }
        .wallet-status {
            font-size: 0.8rem;
            color: var(--accent);
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
        .alert-box.error { background: rgba(255, 59, 92, 0.1); border: 1px solid rgba(255, 59, 92, 0.3); color: #ff3b5c; }
        .alert-box.success { background: rgba(0, 255, 178, 0.1); border: 1px solid rgba(0, 255, 178, 0.3); color: var(--accent); }
        .alert-box.info { background: rgba(0, 212, 255, 0.1); border: 1px solid rgba(0, 212, 255, 0.3); color: var(--secondary); }
        .alert-box i { margin-top: 2px; flex-shrink: 0; }
        .form-group-custom { margin-bottom: 20px; }
        .form-group-custom label {
            display: block;
            color: var(--text-white);
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 8px;
        }
        .input-icon-wrap { position: relative; }
        .input-icon-wrap i.input-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
        }
        .input-icon-wrap input {
            width: 100%;
            padding: 12px 14px 12px 42px;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--glass-border);
            border-radius: 10px;
            color: var(--text-white);
        }
        .btn-primary-glow {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            border-radius: 10px;
            color: #fff;
            font-weight: 700;
            cursor: pointer;
        }
        .login-footer {
            text-align: center;
            margin-top: 24px;
            color: var(--text-gray);
            font-size: 0.9rem;
        }
        .login-footer a {
            color: var(--secondary);
            text-decoration: none;
        }
        .loading-spinner {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 50%;
            border-top-color: #fff;
            animation: spin 0.8s linear infinite;
        }
        @keyframes spin { to { transform: rotate(360deg); } }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="login-container">
        <div class="login-card" data-aos="zoom-in">
            
            <div class="login-logo">
                <h1>MEXIFY</h1>
                <p>Decentralized Crypto Asset Management</p>
            </div>

            <!-- MetaMask Login Section -->
            <div id="metamaskSection">
                <button type="button" class="btn-metamask" id="btnConnectMetaMask" onclick="connectMetaMask()">
                    <i class="fab fa-ethereum" style="font-size: 1.5rem;"></i>
                    <span id="btnMetaMaskText">Connect with MetaMask</span>
                </button>

                <!-- Wallet Connected Display -->
                <div id="walletConnected" class="wallet-connected" style="display: none;">
                    <div class="wallet-icon">
                        <i class="fas fa-wallet"></i>
                    </div>
                    <div style="flex: 1;">
                        <div class="wallet-address" id="walletAddressDisplay">0x...</div>
                        <div class="wallet-status">
                            <i class="fas fa-check-circle"></i> Wallet Connected
                        </div>
                    </div>
                </div>

                <!-- Signature Status -->
                <div id="signatureStatus" style="display: none; margin-top: 16px;">
                    <div class="alert-box info">
                        <i class="fas fa-info-circle"></i>
                        <div id="signatureMessage">Please sign the message in MetaMask...</div>
                    </div>
                </div>
            </div>

            <!-- Divider -->
            <div class="divider">
                <span>OR</span>
            </div>

            <!-- Traditional Login (Optional - keep for fallback) -->
            <asp:Panel ID="pnlTraditionalLogin" runat="server">
                <asp:Panel ID="pnlError" runat="server" Visible="false">
                    <div class="alert-box error">
                        <i class="fas fa-exclamation-circle"></i>
                        <asp:Literal ID="litError" runat="server"></asp:Literal>
                    </div>
                </asp:Panel>

                <div class="form-group-custom">
                    <label>Email Address</label>
                    <div class="input-icon-wrap">
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="your@email.com"></asp:TextBox>
                        <i class="fas fa-envelope input-icon"></i>
                    </div>
                </div>

                <div class="form-group-custom">
                    <label>Password</label>
                    <div class="input-icon-wrap">
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Enter password"></asp:TextBox>
                        <i class="fas fa-lock input-icon"></i>
                    </div>
                </div>

                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                    <label style="display: flex; align-items: center; gap: 8px; color: var(--text-gray); font-size: 0.85rem; cursor: pointer;">
                        <asp:CheckBox ID="chkRemember" runat="server" />
                        Remember me
                    </label>
                    <a href="<%= ResolveUrl("~/forgot-password.aspx") %>" style="color: var(--secondary); font-size: 0.85rem; text-decoration: none;">
                        Forgot password?
                    </a>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn-primary-glow" OnClick="btnLogin_Click" />
            </asp:Panel>

            <div class="login-footer">
                Don't have an account? <a href="<%= ResolveUrl("~/register.aspx") %>">Register</a>
            </div>

            <!-- Hidden fields for MetaMask data -->
            <asp:HiddenField ID="hfWalletAddress" runat="server" />
            <asp:HiddenField ID="hfSignature" runat="server" />
            <asp:HiddenField ID="hfNonce" runat="server" />

        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        let web3;
        let userAccount;
        let currentNonce;

        // Initialize Web3
        async function initWeb3() {
            if (typeof window.ethereum !== 'undefined') {
                web3 = new Web3(window.ethereum);
                return true;
            } else {
                alert('Please install MetaMask to use this feature!');
                return false;
            }
        }

        // Connect MetaMask
        async function connectMetaMask() {
            const btn = document.getElementById('btnConnectMetaMask');
            const btnText = document.getElementById('btnMetaMaskText');
            
            btn.disabled = true;
            btnText.innerHTML = '<span class="loading-spinner"></span> Connecting...';

            try {
                if (!await initWeb3()) {
                    btn.disabled = false;
                    btnText.textContent = 'Connect with MetaMask';
                    return;
                }

                // Request account access
                const accounts = await window.ethereum.request({ 
                    method: 'eth_requestAccounts' 
                });
                
                userAccount = accounts[0];
                
                // Display connected wallet
                document.getElementById('walletAddressDisplay').textContent = 
                    userAccount.substring(0, 6) + '...' + userAccount.substring(38);
                document.getElementById('walletConnected').style.display = 'flex';
                
                // Get nonce from server
                await getNonce(userAccount);
                
                btnText.textContent = 'Wallet Connected';
                
            } catch (error) {
                console.error('MetaMask connection error:', error);
                alert('Failed to connect MetaMask: ' + error.message);
                btn.disabled = false;
                btnText.textContent = 'Connect with MetaMask';
            }
        }

        // Get nonce from server
        async function getNonce(walletAddress) {
            try {
                const response = await fetch('<%= ResolveUrl("~/api/getnonce.aspx") %>?wallet=' + walletAddress);
                const data = await response.json();
                
                if (data.success) {
                    currentNonce = data.nonce;
                    document.getElementById('hfNonce').value = currentNonce;
                    
                    // Request signature
                    await requestSignature(walletAddress, currentNonce);
                } else {
                    alert('Failed to get nonce: ' + data.message);
                }
            } catch (error) {
                console.error('Get nonce error:', error);
                alert('Failed to get nonce from server');
            }
        }

        // Request signature from MetaMask
        async function requestSignature(walletAddress, nonce) {
            const signatureStatus = document.getElementById('signatureStatus');
            const signatureMessage = document.getElementById('signatureMessage');
            
            signatureStatus.style.display = 'block';
            signatureMessage.textContent = 'Please sign the authentication message in MetaMask...';

            try {
                const message = `MEXIFY Authentication\n\nNonce: ${nonce}\n\nPlease sign this message to verify your wallet ownership.`;
                
                const signature = await web3.eth.personal.sign(message, walletAddress);
                
                document.getElementById('hfWalletAddress').value = walletAddress;
                document.getElementById('hfSignature').value = signature;
                
                signatureMessage.innerHTML = '<i class="fas fa-check-circle"></i> Signature verified! Logging in...';
                
                // Submit login form
                setTimeout(() => {
                    document.getElementById('<%= btnMetaMaskLogin.ClientID %>').click();
                }, 1000);
                
            } catch (error) {
                console.error('Signature error:', error);
                signatureMessage.textContent = 'Signature cancelled or failed. Please try again.';
                signatureStatus.querySelector('.alert-box').className = 'alert-box error';
            }
        }

        // Listen for account changes
        if (window.ethereum) {
            window.ethereum.on('accountsChanged', (accounts) => {
                if (accounts.length === 0) {
                    // User disconnected
                    document.getElementById('walletConnected').style.display = 'none';
                    document.getElementById('signatureStatus').style.display = 'none';
                } else {
                    // Account changed
                    userAccount = accounts[0];
                    connectMetaMask();
                }
            });
        }
    </script>

    <!-- Hidden button for MetaMask login postback -->
    <asp:Button ID="btnMetaMaskLogin" runat="server" Style="display: none;" OnClick="btnMetaMaskLogin_Click" />
</asp:Content>