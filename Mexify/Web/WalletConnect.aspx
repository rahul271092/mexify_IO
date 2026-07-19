<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="WalletConnect.aspx.cs" Inherits="Mexify.Web.WalletConnect" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Web3Modal v5 ESM CDN -->
    <script type="module">
        import { createWeb3Modal, defaultConfig } from 'https://esm.sh/@web3modal/ethers@5.0.0';
    </script>
    
    <style>
        .wallet-page { min-height: 80vh; padding: 3rem 0; }
        .wallet-card {
            background: white; border-radius: 20px; padding: 2.5rem;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08); max-width: 600px; margin: 0 auto;
        }
        .wallet-header { text-align: center; margin-bottom: 2rem; }
        .wallet-icon {
            width: 80px; height: 80px; border-radius: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 1.5rem; font-size: 2.5rem; color: white;
        }
        .wallet-status { padding: 1.5rem; border-radius: 15px; margin-bottom: 1.5rem; text-align: center; }
        .wallet-status.connected { background: rgba(17,153,142,0.1); border: 2px solid #38ef7d; }
        .wallet-status.disconnected { background: #f8f9fa; border: 2px dashed #dee2e6; }
        .wallet-address {
            font-family: 'Courier New', monospace; font-size: 0.9rem;
            background: #f1f3f5; padding: 0.5rem 1rem; border-radius: 8px;
            word-break: break-all; margin: 1rem 0;
        }
        .btn-connect {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none; color: white; padding: 1rem 2rem; border-radius: 30px;
            font-weight: 600; font-size: 1.1rem; width: 100%; transition: all 0.3s ease;
        }
        .btn-connect:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(102,126,234,0.4); color: white; }
        .btn-disconnect { background: #dc3545; border: none; color: white; padding: 0.8rem 1.5rem; border-radius: 25px; font-weight: 600; width: 100%; }
        .balance-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; border-radius: 15px; padding: 1.5rem; margin: 1.5rem 0;
        }
        .supported-wallets { display: flex; justify-content: center; gap: 1rem; margin-top: 1.5rem; flex-wrap: wrap; }
        .wallet-logo {
            width: 50px; height: 50px; border-radius: 12px; background: #f1f3f5;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.5rem; transition: transform 0.2s;
        }
        .wallet-logo:hover { transform: scale(1.1); }
        .alert-custom { border-radius: 12px; padding: 1rem; margin-bottom: 1rem; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="wallet-page">
        <div class="container">
            <div class="wallet-card">
                <div class="wallet-header">
                    <div class="wallet-icon"><i class="fas fa-wallet"></i></div>
                    <h2 class="mb-2">Connect Your Wallet</h2>
                    <p class="text-muted">Link your crypto wallet to enable deposits and withdrawals</p>
                </div>

                <!-- Alert Messages -->
                <asp:Panel ID="pnlAlert" runat="server" Visible="false">
                    <div class="alert-custom" id="alertBox">
                        <asp:Label ID="lblAlertMessage" runat="server" />
                    </div>
                </asp:Panel>

          
                <div id="walletStatus" class="wallet-status disconnected">
                    <div id="disconnectedView">
                        <i class="fas fa-plug fa-2x text-muted mb-3"></i>
                        <h5 class="mb-2">No Wallet Connected</h5>
                        <p class="text-muted small mb-0">Connect your wallet to get started</p>
                    </div>
                    <div id="connectedView" style="display: none;">
                        <i class="fas fa-check-circle fa-2x text-success mb-3"></i>
                        <h5 class="mb-2">Wallet Connected</h5>
                        <div class="wallet-address" id="displayAddress">-</div>
                        <span class="badge bg-primary" id="networkBadge">-</span>
                    </div>
                </div>

                <!-- Balance Display -->
                <div class="balance-card" id="balanceCard" style="display: none;">
                    <div style="font-size: 0.9rem; opacity: 0.8; margin-bottom: 0.5rem;">Wallet Balance</div>
                    <div style="font-size: 2rem; font-weight: 700;">
                        <span id="balanceAmount">0.0000</span> 
                        <small id="balanceSymbol">ETH</small>
                    </div>
                </div>

                <!-- Action Buttons (✅ REMOVED inline onclick) -->
                <div id="actionButtons">
                    <button type="button" id="btnConnectWallet" class="btn-connect">
                        <i class="fas fa-link me-2"></i>Connect Wallet
                    </button>
                    <button type="button" id="btnDisconnect" class="btn-disconnect mt-2" style="display: none;">
                        <i class="fas fa-unlink me-2"></i>Disconnect Wallet
                    </button>
                </div>

                <!-- Save Button (✅ REMOVED inline onclick) -->
                <button type="button" id="btnSaveWallet" class="btn btn-success w-100 mt-3" style="display: none;">
                    <i class="fas fa-save me-2"></i>Save Wallet to My Account
                </button>

                <!-- Supported 4 Wallets Visuals -->
                <div class="supported-wallets">
                    <div class="wallet-logo" title="MetaMask" style="color: #f6851b;"><i class="fab fa-ethereum"></i></div>
                    <div class="wallet-logo" title="WalletConnect" style="color: #3b99fc;"><i class="fas fa-qrcode"></i></div>
                    <div class="wallet-logo" title="Trust Wallet" style="color: #3375bb;"><i class="fas fa-shield-alt"></i></div>
                    <div class="wallet-logo" title="Coinbase Wallet" style="color: #0052ff;"><i class="fas fa-circle"></i></div>
                </div>

                <!-- Hidden fields for server postback -->
                <asp:HiddenField ID="hfWalletAddress" runat="server" />
                <asp:HiddenField ID="hfWalletProvider" runat="server" />
                <asp:HiddenField ID="hfChainId" runat="server" />
                <asp:Button ID="btnSaveToServer" runat="server" Style="display:none;" OnClick="btnSaveToServer_Click" />
            </div>
        </div>
    </div>

    <!-- WalletConnect Logic -->
    <script type="module">
        import { createWeb3Modal, defaultConfig } from 'https://esm.sh/@web3modal/ethers@5.0.0';

        const PROJECT_ID = 'YOUR_WALLETCONNECT_PROJECT_ID_HERE';
        let web3Modal = null;
        let currentAddress = null;

        // 1. Define functions in module scope (no 'window.' needed)
        async function connectWallet() {
            try {
                if (!web3Modal) await initWalletConnect();
                await web3Modal.open();
                
                setTimeout(async () => {
                    if (web3Modal && web3Modal.getIsConnected()) {
                        await handleConnected();
                    }
                }, 1500);
            } catch (error) {
                console.error('Connection error:', error);
                showAlert('Failed to connect wallet.', 'danger');
            }
        }

        async function disconnectWallet() {
            if (web3Modal) web3Modal.disconnect();
            currentAddress = null;
            
            const status = document.getElementById('walletStatus');
            if(status) status.classList.replace('connected', 'disconnected');
            
            const discView = document.getElementById('disconnectedView');
            const connView = document.getElementById('connectedView');
            if(discView) discView.style.display = 'block';
            if(connView) connView.style.display = 'none';
            
            const balCard = document.getElementById('balanceCard');
            if(balCard) balCard.style.display = 'none';
            
            const btnConn = document.getElementById('btnConnectWallet');
            const btnDisc = document.getElementById('btnDisconnect');
            const btnSave = document.getElementById('btnSaveWallet');
            if(btnConn) btnConn.style.display = 'block';
            if(btnDisc) btnDisc.style.display = 'none';
            if(btnSave) btnSave.style.display = 'none';
            
            showAlert('Wallet disconnected.', 'success');
        }

        function saveWalletToAccount() {
            const address = document.getElementById('<%= hfWalletAddress.ClientID %>').value;
            if (!address) { 
                showAlert('Please connect your wallet first.', 'warning'); 
                return; 
            }
            // Trigger the hidden ASP.NET server button
            document.getElementById('<%= btnSaveToServer.ClientID %>').click();
        }

        function showAlert(message, type) {
            const pnl = document.getElementById('<%= pnlAlert.ClientID %>');
            const box = document.getElementById('alertBox');
            
            if (box) {
                box.className = 'alert-custom alert alert-' + type;
                box.innerHTML = '<i class="fas fa-info-circle me-2"></i>' + message;
            }
            if (pnl) {
                pnl.style.display = 'block';
                setTimeout(() => { pnl.style.display = 'none'; }, 5000);
            }
        }

        async function initWalletConnect() {
            try {
                const metadata = {
                    name: 'Mexify Platform',
                    description: 'Connect your wallet to Mexify',
                    url: window.location.origin,
                    icons: ['https://avatars.githubusercontent.com/u/37784886']
                };

                const ethersConfig = defaultConfig({ metadata });

                web3Modal = createWeb3Modal({
                    ethersConfig,
                    projectId: PROJECT_ID,
                    chains: [
                        { chainId: 1, name: 'Ethereum', currency: 'ETH', explorerUrl: 'https://etherscan.io', rpcUrl: 'https://cloudflare-eth.com' },
                        { chainId: 56, name: 'BSC', currency: 'BNB', explorerUrl: 'https://bscscan.com', rpcUrl: 'https://bsc-dataseed.binance.org' },
                        { chainId: 137, name: 'Polygon', currency: 'MATIC', explorerUrl: 'https://polygonscan.com', rpcUrl: 'https://polygon-rpc.com' }
                    ],
                    defaultChain: { chainId: 1, name: 'Ethereum' },
                    enableAnalytics: false
                });

                if (web3Modal.getIsConnected()) {
                    await handleConnected();
                }
            } catch (error) {
                console.error('Web3Modal init error:', error);
                showAlert('Failed to initialize wallet. Please refresh.', 'danger');
            }
        }

        async function handleConnected() {
            try {
                if (!web3Modal || !web3Modal.getIsConnected()) return;
                
                const provider = web3Modal.getWalletProvider();
                if (!provider) throw new Error("Provider not found");

                const accounts = await provider.request({ method: 'eth_requestAccounts' });
                currentAddress = accounts[0];
                
                const chainId = await provider.request({ method: 'eth_chainId' });
                const balanceHex = await provider.request({ method: 'eth_getBalance', params: [currentAddress, 'latest'] });
                const balanceEth = parseInt(balanceHex, 16) / 1e18;
                
                updateConnectedUI(currentAddress, chainId, balanceEth);
            } catch (error) {
                console.error('Handle connected error:', error);
                showAlert('Error reading wallet data.', 'danger');
            }
        }

        function updateConnectedUI(address, chainId, balance) {
            const shortAddress = address.substring(0, 6) + '...' + address.substring(address.length - 4);
            const networks = { '0x1': 'Ethereum', '0x38': 'BSC', '0x89': 'Polygon', '0x5': 'Goerli', '0xaa36a7': 'Sepolia' };
            const symbols = { '0x1': 'ETH', '0x38': 'BNB', '0x89': 'MATIC', '0x5': 'ETH', '0xaa36a7': 'ETH' };
            
            const networkName = networks[chainId] || 'Unknown';
            const symbol = symbols[chainId] || 'ETH';

            const status = document.getElementById('walletStatus');
            if(status) { status.classList.remove('disconnected'); status.classList.add('connected'); }
            
            const discView = document.getElementById('disconnectedView');
            const connView = document.getElementById('connectedView');
            if(discView) discView.style.display = 'none';
            if(connView) connView.style.display = 'block';
            
            const dispAddr = document.getElementById('displayAddress');
            if(dispAddr) dispAddr.textContent = shortAddress;
            
            const netBadge = document.getElementById('networkBadge');
            if(netBadge) netBadge.textContent = networkName;
            
            const balCard = document.getElementById('balanceCard');
            if(balCard) balCard.style.display = 'block';
            
            const balAmt = document.getElementById('balanceAmount');
            if(balAmt) balAmt.textContent = Number(balance).toFixed(4);
            
            const balSym = document.getElementById('balanceSymbol');
            if(balSym) balSym.textContent = symbol;
            
            const btnConn = document.getElementById('btnConnectWallet');
            const btnDisc = document.getElementById('btnDisconnect');
            const btnSave = document.getElementById('btnSaveWallet');
            if(btnConn) btnConn.style.display = 'none';
            if(btnDisc) btnDisc.style.display = 'block';
            if(btnSave) btnSave.style.display = 'block';
            
            document.getElementById('<%= hfWalletAddress.ClientID %>').value = address;
            document.getElementById('<%= hfWalletProvider.ClientID %>').value = 'Web3Modal';
            document.getElementById('<%= hfChainId.ClientID %>').value = chainId;
        }

        // 2. Attach Event Listeners Safely on DOM Ready
        document.addEventListener('DOMContentLoaded', function() {
            // ✅ Attach clicks directly to elements (No inline onclick needed)
            const btnConnect = document.getElementById('btnConnectWallet');
            if (btnConnect) btnConnect.addEventListener('click', connectWallet);

            const btnDisconnect = document.getElementById('btnDisconnect');
            if (btnDisconnect) btnDisconnect.addEventListener('click', disconnectWallet);

            const btnSave = document.getElementById('btnSaveWallet');
            if (btnSave) btnSave.addEventListener('click', saveWalletToAccount);

            // Initialize Web3Modal
            initWalletConnect();
            
            // Check for existing wallet from server
            const hasExisting = '<%= HasExistingWallet %>' === 'True';
            const shortAddr = '<%= ShortWalletAddress %>';
            
            if (hasExisting && shortAddr && shortAddr !== '') {
                const status = document.getElementById('walletStatus');
                if(status) { status.classList.remove('disconnected'); status.classList.add('connected'); }
                
                const discView = document.getElementById('disconnectedView');
                const connView = document.getElementById('connectedView');
                if(discView) discView.style.display = 'none';
                if(connView) connView.style.display = 'block';
                
                const dispAddr = document.getElementById('displayAddress');
                if(dispAddr) dispAddr.textContent = shortAddr;
                
                const btnConn = document.getElementById('btnConnectWallet');
                const btnDisc = document.getElementById('btnDisconnect');
                if(btnConn) btnConn.style.display = 'none';
                if(btnDisc) btnDisc.style.display = 'block';
            }
        });
    </script>
</asp:Content>

