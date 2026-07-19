<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="TrustWalletConnect.aspx.cs" Inherits="Mexify.Web.TrustWalletConnect" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

     <!-- Web3Modal for Trust Wallet Mobile -->
    <script type="module" src="https://cdn.jsdelivr.net/npm/@walletconnect/modal@2.6.2/dist/index.umd.min.js"></script>
    
    <style>
        .trust-page {
            min-height: 80vh;
            padding: 3rem 0;
            background: linear-gradient(135deg, #f0f4f8 0%, #d9e2ec 100%);
        }

        .trust-card {
            background: white;
            border-radius: 24px;
            padding: 2.5rem;
            box-shadow: 0 15px 50px rgba(0,0,0,0.1);
            max-width: 650px;
            margin: 0 auto;
        }

        .trust-header {
            text-align: center;
            margin-bottom: 2.5rem;
        }

        .trust-logo {
            width: 100px;
            height: 100px;
            border-radius: 25px;
            background: #3375BB;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            font-size: 3rem;
            color: white;
            box-shadow: 0 10px 30px rgba(51, 117, 187, 0.3);
        }

        .connection-options {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .connection-option {
            background: #f8f9fa;
            border: 2px solid #e9ecef;
            border-radius: 16px;
            padding: 1.5rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .connection-option:hover {
            border-color: #3375BB;
            background: #f0f7ff;
            transform: translateY(-3px);
        }

        .connection-option.disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .connection-option .icon {
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
            color: #3375BB;
        }

        .connection-option h6 {
            margin-bottom: 0.25rem;
            font-weight: 600;
        }

        .connection-option p {
            font-size: 0.8rem;
            color: #6c757d;
            margin: 0;
        }

        .wallet-status {
            padding: 1.5rem;
            border-radius: 16px;
            margin-bottom: 1.5rem;
            text-align: center;
        }

        .wallet-status.connected {
            background: linear-gradient(135deg, rgba(51, 117, 187, 0.05) 0%, rgba(51, 117, 187, 0.1) 100%);
            border: 2px solid #3375BB;
        }

        .wallet-status.disconnected {
            background: #f8f9fa;
            border: 2px dashed #dee2e6;
        }

        .wallet-address {
            font-family: 'Courier New', monospace;
            font-size: 0.9rem;
            background: #3375BB;
            color: white;
            padding: 0.75rem 1rem;
            border-radius: 10px;
            word-break: break-all;
            margin: 1rem 0;
        }

        .btn-trust {
            background: #3375BB;
            border: none;
            color: white;
            padding: 1rem 2rem;
            border-radius: 30px;
            font-weight: 600;
            font-size: 1.05rem;
            width: 100%;
            transition: all 0.3s ease;
        }

        .btn-trust:hover {
            background: #285e96;
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(51, 117, 187, 0.4);
            color: white;
        }

        .btn-disconnect {
            background: #dc3545;
            color: white;
            border: none;
            padding: 0.8rem 1.5rem;
            border-radius: 25px;
            font-weight: 600;
            width: 100%;
        }

        .balance-card {
            background: linear-gradient(135deg, #3375BB 0%, #285e96 100%);
            color: white;
            border-radius: 16px;
            padding: 1.5rem;
            margin: 1.5rem 0;
            position: relative;
            overflow: hidden;
        }

        .balance-card::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 200px;
            height: 200px;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.2) 0%, transparent 70%);
            border-radius: 50%;
        }

        .balance-label {
            font-size: 0.9rem;
            opacity: 0.8;
            margin-bottom: 0.5rem;
        }

        .balance-amount {
            font-size: 2rem;
            font-weight: 700;
        }

        .network-badge {
            display: inline-block;
            padding: 0.3rem 0.8rem;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 600;
            background: rgba(255, 255, 255, 0.2);
            margin-top: 0.5rem;
        }

        .info-box {
            background: #f0f7ff;
            border-left: 4px solid #3375BB;
            padding: 1rem;
            border-radius: 8px;
            margin-top: 1.5rem;
            font-size: 0.9rem;
        }

        .alert-custom {
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 1rem;
        }

        @media (max-width: 576px) {
            .connection-options {
                grid-template-columns: 1fr;
            }
        }
    </style>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

     <div class="trust-page">
        <div class="container">
            <div class="trust-card">
                <div class="trust-header">
                    <div class="trust-logo">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h2 class="mb-2">Connect Trust Wallet</h2>
                    <p class="text-muted">Link your Trust Wallet to enable secure transactions</p>
                </div>

                <!-- Alert Messages -->
                <asp:Panel ID="pnlAlert" runat="server" Visible="false">
                    <div class="alert-custom" id="alertBox">
                        <asp:Label ID="lblAlertMessage" runat="server" />
                    </div>
                </asp:Panel>

                <!-- Wallet Status -->
                <div id="walletStatus" class="wallet-status disconnected">
                    <div id="disconnectedView">
                        <i class="fas fa-shield-alt fa-3x text-muted mb-3"></i>
                        <h5 class="mb-2">No Trust Wallet Connected</h5>
                        <p class="text-muted small mb-0">Choose a connection method below</p>
                    </div>
                    <div id="connectedView" style="display: none;">
                        <i class="fas fa-check-circle fa-3x mb-3" style="color: #3375BB;"></i>
                        <h5 class="mb-2">Trust Wallet Connected</h5>
                        <div class="wallet-address" id="displayAddress">-</div>
                        <span class="network-badge" id="networkBadge">-</span>
                        <div class="mt-2">
                            <small class="text-muted">Connected via: <strong id="connectionMethod">-</strong></small>
                        </div>
                    </div>
                </div>

                <!-- Connection Options -->
                <div id="connectionOptions">
                    <div class="connection-options">
                        <!-- Trust Wallet Extension -->
                        <div class="connection-option" id="optionExtension" onclick="connectViaExtension()">
                            <div class="icon">
                                <i class="fas fa-puzzle-piece"></i>
                            </div>
                            <h6>Browser Extension</h6>
                            <p>Fast & direct connection</p>
                            <small id="extensionStatus" class="text-success">
                                <i class="fas fa-check-circle"></i> Detected
                            </small>
                        </div>

                        <!-- Trust Wallet Mobile -->
                        <div class="connection-option" id="optionMobile" onclick="connectViaMobile()">
                            <div class="icon">
                                <i class="fas fa-mobile-alt"></i>
                            </div>
                            <h6>Trust Wallet Mobile</h6>
                            <p>Scan QR code</p>
                            <small class="text-muted">
                                <i class="fas fa-qrcode"></i> WalletConnect
                            </small>
                        </div>
                    </div>
                </div>

                <!-- Balance Display -->
                <div class="balance-card" id="balanceCard" style="display: none;">
                    <div class="balance-label">Wallet Balance</div>
                    <div class="balance-amount">
                        <span id="balanceAmount">0.0000</span> 
                        <small id="balanceSymbol">BNB</small>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div id="actionButtons">
                    <button type="button" id="btnDisconnect" class="btn-disconnect mt-2" onclick="disconnectWallet()" style="display: none;">
                        <i class="fas fa-unlink me-2"></i>Disconnect Wallet
                    </button>
                </div>

                <!-- Save Button -->
                <button type="button" id="btnSaveWallet" class="btn-trust mt-3" onclick="saveWalletToAccount()" style="display: none;">
                    <i class="fas fa-save me-2"></i>Save Trust Wallet to My Account
                </button>

                <!-- Info Box -->
                <div class="info-box">
                    <strong><i class="fas fa-info-circle me-2"></i>Don't have Trust Wallet?</strong><br>
                    Download the extension for 
                    <a href="https://chromewebstore.google.com/detail/trust-wallet/egjidjbpglichdcondbcbdnbeeppgdph" target="_blank" style="color: #3375BB;">Chrome</a> or 
                    get the 
                    <a href="https://trustwallet.com/download" target="_blank" style="color: #3375BB;">Mobile App</a> 
                    for iOS/Android.
                </div>

                <!-- Hidden fields for postback -->
                <asp:HiddenField ID="hfWalletAddress" runat="server" />
                <asp:HiddenField ID="hfWalletProvider" runat="server" />
                <asp:HiddenField ID="hfChainId" runat="server" />
                <asp:HiddenField ID="hfConnectionMethod" runat="server" />
                <asp:Button ID="btnSaveToServer" runat="server" Style="display:none;" OnClick="btnSaveToServer_Click" />
            </div>
        </div>
    </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">



    <script type="module">
        const PROJECT_ID = '4d98ec275236ffea1f9d31897b2c391f';
        
        let trustProvider = null;
        let walletConnectModal = null;
        let wcProvider = null;
        let currentAddress = null;
        let connectionMethod = null;

        async function init() {
            detectTrustExtension();
            await initWalletConnect();
            
            <% if (HasExistingWallet) { %>
            showExistingWallet('<%= ExistingWalletAddress %>', '<%= ExistingConnectionMethod %>');
            <% } %>
        }

        function detectTrustExtension() {
            const option = document.getElementById('optionExtension');
            const status = document.getElementById('extensionStatus');
            
            // Trust Wallet injects window.trustwallet, or window.ethereum with isTrust flag
            if (window.trustwallet || (window.ethereum && window.ethereum.isTrust)) {
                trustProvider = window.trustwallet || window.ethereum;
                status.innerHTML = '<i class="fas fa-check-circle"></i> Detected';
                status.className = 'text-success';
                option.classList.remove('disabled');
            } else {
                status.innerHTML = '<i class="fas fa-times-circle"></i> Not installed';
                status.className = 'text-danger';
                option.classList.add('disabled');
            }
        }

        async function initWalletConnect() {
            try {
                const { Web3Modal } = window;
                walletConnectModal = new Web3Modal({
                    projectId: PROJECT_ID,
                    chains: ['eip155:1', 'eip155:56'],
                    features: { analytics: false, email: false, legal: false },
                    themeMode: 'light'
                });
            } catch (error) {
                console.error('WalletConnect init error:', error);
            }
        }

        window.connectViaExtension = async function() {
            if (!trustProvider) {
                showAlert('Trust Wallet extension not detected. Please install it first.', 'warning');
                return;
            }

            try {
                const accounts = await trustProvider.request({ method: 'eth_requestAccounts' });
                if (accounts && accounts.length > 0) {
                    currentAddress = accounts[0];
                    connectionMethod = 'extension';
                    
                    const chainId = await trustProvider.request({ method: 'eth_chainId' });
                    const balance = await trustProvider.request({
                        method: 'eth_getBalance',
                        params: [currentAddress, 'latest']
                    });
                    
                    const balanceEth = parseInt(balance, 16) / 1e18;
                    
                    trustProvider.on('accountsChanged', handleAccountsChanged);
                    trustProvider.on('chainChanged', () => window.location.reload());
                    
                    updateConnectedUI(currentAddress, chainId, balanceEth, 'Browser Extension');
                }
            } catch (error) {
                console.error('Extension connection error:', error);
                showAlert('Failed to connect: ' + (error.message || 'User rejected'), 'danger');
            }
        };

        window.connectViaMobile = async function() {
            try {
                if (!walletConnectModal) await initWalletConnect();
                await walletConnectModal.open();

                walletConnectModal.subscribeEvents(async ({ data }) => {
                    if (data.event === 'MODAL_CONNECTED' || data.event === 'CONNECT_SUCCESS') {
                        await handleWalletConnectConnection();
                    }
                });

                setTimeout(async () => {
                    if (await walletConnectModal.getState().connected) {
                        await handleWalletConnectConnection();
                    }
                }, 1500);
            } catch (error) {
                console.error('Mobile connection error:', error);
                showAlert('Failed to connect mobile wallet.', 'danger');
            }
        };

        async function handleWalletConnectConnection() {
            try {
                wcProvider = await walletConnectModal.getProvider();
                const accounts = await wcProvider.request({ method: 'eth_requestAccounts' });
                
                if (accounts && accounts.length > 0) {
                    currentAddress = accounts[0];
                    connectionMethod = 'mobile';
                    
                    const chainId = await wcProvider.request({ method: 'eth_chainId' });
                    const balance = await wcProvider.request({
                        method: 'eth_getBalance',
                        params: [currentAddress, 'latest']
                    });
                    
                    updateConnectedUI(currentAddress, chainId, parseInt(balance, 16) / 1e18, 'Trust Wallet Mobile');
                }
            } catch (error) {
                console.error('WalletConnect handle error:', error);
                showAlert('Error reading wallet data.', 'danger');
            }
        }

        function handleAccountsChanged(accounts) {
            if (accounts.length === 0) {
                disconnectWallet();
            } else {
                currentAddress = accounts[0];
                document.getElementById('displayAddress').textContent = formatAddress(currentAddress);
                document.getElementById('<%= hfWalletAddress.ClientID %>').value = currentAddress;
            }
        }

        function formatAddress(address) {
            return address.substring(0, 8) + '...' + address.substring(address.length - 6);
        }

        function updateConnectedUI(address, chainId, balance, methodLabel) {
            const networks = {
                '0x1': { name: 'Ethereum', symbol: 'ETH' },
                '0x38': { name: 'BSC', symbol: 'BNB' },
                '0x89': { name: 'Polygon', symbol: 'MATIC' },
                '0x5': { name: 'Goerli', symbol: 'ETH' },
                '0xaa36a7': { name: 'Sepolia', symbol: 'ETH' }
            };
            
            const network = networks[chainId] || { name: 'Unknown', symbol: 'ETH' };
            
            document.getElementById('walletStatus').classList.remove('disconnected');
            document.getElementById('walletStatus').classList.add('connected');
            document.getElementById('disconnectedView').style.display = 'none';
            document.getElementById('connectedView').style.display = 'block';
            document.getElementById('displayAddress').textContent = formatAddress(address);
            document.getElementById('networkBadge').textContent = network.name;
            document.getElementById('connectionMethod').textContent = methodLabel;
            
            document.getElementById('balanceCard').style.display = 'block';
            document.getElementById('balanceAmount').textContent = balance.toFixed(4);
            document.getElementById('balanceSymbol').textContent = network.symbol;
            
            document.getElementById('connectionOptions').style.display = 'none';
            document.getElementById('btnDisconnect').style.display = 'block';
            document.getElementById('btnSaveWallet').style.display = 'block';
            
            document.getElementById('<%= hfWalletAddress.ClientID %>').value = address;
            document.getElementById('<%= hfWalletProvider.ClientID %>').value = 'TrustWallet';
            document.getElementById('<%= hfChainId.ClientID %>').value = chainId;
            document.getElementById('<%= hfConnectionMethod.ClientID %>').value = connectionMethod;
        }

        function showExistingWallet(address, method) {
            document.getElementById('walletStatus').classList.remove('disconnected');
            document.getElementById('walletStatus').classList.add('connected');
            document.getElementById('disconnectedView').style.display = 'none';
            document.getElementById('connectedView').style.display = 'block';
            document.getElementById('displayAddress').textContent = address;
            document.getElementById('connectionMethod').textContent = method || 'Saved Wallet';
            document.getElementById('connectionOptions').style.display = 'none';
            document.getElementById('btnDisconnect').style.display = 'block';
            document.getElementById('btnSaveWallet').style.display = 'none';
        }

        window.disconnectWallet = async function() {
            try {
                if (connectionMethod === 'mobile' && walletConnectModal) {
                    await walletConnectModal.disconnect();
                }
                
                trustProvider = null;
                wcProvider = null;
                currentAddress = null;
                connectionMethod = null;
                
                document.getElementById('walletStatus').classList.remove('connected');
                document.getElementById('walletStatus').classList.add('disconnected');
                document.getElementById('disconnectedView').style.display = 'block';
                document.getElementById('connectedView').style.display = 'none';
                document.getElementById('balanceCard').style.display = 'none';
                document.getElementById('connectionOptions').style.display = 'block';
                document.getElementById('btnDisconnect').style.display = 'none';
                document.getElementById('btnSaveWallet').style.display = 'none';
                
                detectTrustExtension();
                showAlert('Wallet disconnected successfully.', 'success');
            } catch (error) {
                console.error('Disconnect error:', error);
            }
        };

        window.saveWalletToAccount = function() {
            const address = document.getElementById('<%= hfWalletAddress.ClientID %>').value;
            if (!address) {
                showAlert('Please connect your wallet first.', 'warning');
                return;
            }
            document.getElementById('<%= btnSaveToServer.ClientID %>').click();
        };

        function showAlert(message, type) {
            const alertBox = document.getElementById('alertBox');
            const pnlAlert = document.getElementById('<%= pnlAlert.ClientID %>');
            const colors = { success: '#d4edda', danger: '#f8d7da', warning: '#fff3cd', info: '#d1ecf1' };
            
            alertBox.style.background = colors[type] || colors.info;
            alertBox.innerHTML = '<i class="fas fa-info-circle me-2"></i>' + message;
            pnlAlert.style.display = 'block';
            
            setTimeout(() => { pnlAlert.style.display = 'none'; }, 5000);
        }

        document.addEventListener('DOMContentLoaded', init);
    </script>

</asp:Content>
