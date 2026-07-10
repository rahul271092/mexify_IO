<%@ Page Title="My Wallet" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="Wallet.aspx.cs" Inherits="Mexify.Web.User.Wallet" %>


<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
  <style>
        /* =========================================
           GLOBAL LAYOUT FIXES
           ========================================= */
        .tab-content {
            width: 100% !important;
            max-width: 100% !important;
            box-sizing: border-box;
        }

        /* =========================================
           HEADER & TABS
           ========================================= */
        .wallet-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            flex-wrap: wrap;
            gap: 16px;
            width: 100%;
        }
        .wallet-header h2 {
            color: var(--text-white);
            margin: 0;
            font-size: 1.8rem;
        }

        .wallet-tabs {
            display: flex;
            gap: 4px;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 50px;
            padding: 4px;
            margin-bottom: 28px;
            width: fit-content;
            max-width: 100%;
            flex-wrap: wrap;
        }
        .wallet-tab {
            padding: 10px 24px;
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
        .wallet-tab.active {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: var(--text-white);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }
        .wallet-tab:hover:not(.active) {
            background: rgba(255, 255, 255, 0.05);
            color: var(--text-white);
        }

        /* =========================================
           BALANCE CARD
           ========================================= */
        .balance-card {
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.25), rgba(0, 255, 178, 0.15));
            border: 1px solid rgba(0, 212, 255, 0.3);
            border-radius: var(--radius-xl);
            padding: 40px;
            position: relative;
            overflow: hidden;
            margin-bottom: 32px;
            width: 100%;
            box-sizing: border-box;
        }
        .balance-card::before {
            content: '';
            position: absolute;
            top: -50%; right: -10%;
            width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(0, 212, 255, 0.2) 0%, transparent 70%);
            animation: float 15s ease-in-out infinite;
        }
        @keyframes float {
            0%,100%{transform:translate(0,0) scale(1)}
            50%{transform:translate(20px,-20px) scale(1.1)}
        }
        .balance-label {
            color: var(--text-gray);
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            margin-bottom: 8px;
        }
        .balance-amount {
            font-size: 3rem;
            font-weight: 800;
            color: var(--text-white);
            font-family: 'Space Grotesk', sans-serif;
            margin-bottom: 4px;
            line-height: 1.2;
        }
        .balance-usd {
            color: var(--text-gray);
            font-size: 1.1rem;
        }
        .balance-actions {
            display: flex;
            gap: 12px;
            margin-top: 24px;
            flex-wrap: wrap;
        }

        /* =========================================
           WALLET CARDS
           ========================================= */
        .wallet-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 24px;
            transition: all 0.3s ease;
            cursor: pointer;
            text-decoration: none;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 100%;
            width: 100%;
            box-sizing: border-box;
        }
        .wallet-card:hover {
            transform: translateY(-5px);
            border-color: var(--secondary);
            box-shadow: 0 15px 40px rgba(0, 212, 255, 0.15);
        }
        .wallet-card-header {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 20px;
        }
        .wallet-card-icon {
            width: 52px; height: 52px;
            border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.4rem;
            flex-shrink: 0;
        }
        .wallet-card-icon.pnc { background: linear-gradient(135deg, rgba(255, 215, 0, 0.2), rgba(255, 165, 0, 0.1)); color: var(--gold); border: 1px solid rgba(255, 215, 0, 0.3); }
        .wallet-card-icon.btc { background: linear-gradient(135deg, rgba(247, 147, 26, 0.2), rgba(247, 147, 26, 0.05)); color: #F7931A; border: 1px solid rgba(247, 147, 26, 0.3); }
        .wallet-card-icon.eth { background: linear-gradient(135deg, rgba(98, 126, 234, 0.2), rgba(98, 126, 234, 0.05)); color: #627EEA; border: 1px solid rgba(98, 126, 234, 0.3); }
        .wallet-card-icon.usdt { background: linear-gradient(135deg, rgba(38, 161, 123, 0.2), rgba(38, 161, 123, 0.05)); color: #26A17B; border: 1px solid rgba(38, 161, 123, 0.3); }
        .wallet-card-name {
            color: var(--text-white);
            font-weight: 600;
            font-size: 1rem;
            margin: 0;
            word-break: break-word;
        }
        .wallet-card-code {
            color: var(--text-muted);
            font-size: 0.8rem;
        }
        .wallet-card-balance {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-white);
            margin-bottom: 4px;
            word-break: break-word;
        }
        .wallet-card-locked {
            font-size: 0.8rem;
            color: var(--text-muted);
            margin-bottom: 12px;
        }
        .wallet-card-locked i { color: var(--gold); margin-right: 4px; }
        
        .wallet-card-actions {
            display: flex;
            gap: 8px;
            margin-top: 16px;
            width: 100%;
        }
        .wallet-card-btn {
            flex: 1;
            height: 38px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            font-size: 0.8rem;
            font-weight: 600;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 1px solid var(--glass-border);
            background: transparent;
            color: var(--text-gray);
            text-decoration: none;
            box-sizing: border-box;
            white-space: nowrap;
        }
        .wallet-card-btn:hover {
            background: rgba(0, 212, 255, 0.1);
            color: var(--secondary);
            border-color: var(--secondary);
        }
        .wallet-card-btn.primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: var(--text-white);
            border: none;
        }

        /* =========================================
           DEPOSIT & WITHDRAW SECTIONS
           ========================================= */
        .deposit-section, .withdraw-section {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 32px;
            width: 100%;
            box-sizing: border-box;
        }
        .deposit-address-box {
            background: rgba(0, 0, 0, 0.3);
            border: 1px dashed var(--glass-border);
            border-radius: var(--radius-md);
            padding: 20px;
            text-align: center;
            margin: 20px 0;
            width: 100%;
            box-sizing: border-box;
        }
        .deposit-address {
            font-family: 'Courier New', monospace;
            color: var(--secondary);
            font-size: 0.95rem;
            word-break: break-all;
            margin: 12px 0;
            padding: 12px;
            background: rgba(0, 212, 255, 0.05);
            border-radius: 8px;
            border: 1px solid rgba(0, 212, 255, 0.2);
        }
        .qr-code {
            background: #fff;
            padding: 16px;
            border-radius: 12px;
            display: inline-block;
            margin: 16px 0;
        }
        .copy-btn {
            padding: 10px 20px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            border-radius: 50px;
            color: var(--text-white);
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .copy-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.4);
        }

        /* =========================================
           FORM ELEMENTS
           ========================================= */
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
            box-sizing: border-box;
        }
        .input-icon-wrap select option { background: var(--bg-secondary); color: var(--text-white); }
        .input-icon-wrap input:focus,
        .input-icon-wrap select:focus {
            outline: none;
            border-color: var(--secondary);
            background: rgba(0, 212, 255, 0.03);
            box-shadow: 0 0 0 3px rgba(0, 212, 255, 0.1);
        }
        .input-icon-wrap:focus-within i.input-icon { color: var(--secondary); }

        /* =========================================
           ALERT BOXES
           ========================================= */
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

        /* =========================================
           HISTORY TABLE
           ========================================= */
        .history-table {
            width: 100%;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-sizing: border-box;
        }
        .table-responsive {
            width: 100%;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }
        .history-table table { 
            width: 100%; 
            color: var(--text-gray);
            min-width: 700px;
            border-collapse: collapse;
        }
        .history-table th {
            background: rgba(37, 99, 235, 0.08);
            padding: 14px 16px;
            color: var(--text-white);
            font-weight: 600;
            font-size: 0.85rem;
            text-align: left;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            white-space: nowrap;
        }
        .history-table td {
            padding: 14px 16px;
            border-bottom: 1px solid var(--glass-border);
            font-size: 0.9rem;
            word-break: break-word;
        }
        .history-table tr:last-child td { border-bottom: none; }
        .history-table tr:hover { background: rgba(255, 255, 255, 0.02); }

        /* =========================================
           STATUS BADGES
           ========================================= */
        .status-badge {
            padding: 3px 10px;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
            text-transform: uppercase;
            display: inline-block;
            white-space: nowrap;
        }
        .status-completed { background: rgba(0, 255, 178, 0.15); color: var(--accent); }
        .status-pending { background: rgba(255, 215, 0, 0.15); color: var(--gold); }
        .status-failed { background: rgba(255, 59, 92, 0.15); color: #ff3b5c; }

        .amount-positive { color: var(--accent); font-weight: 600; }
        .amount-negative { color: #ff3b5c; font-weight: 600; }

        /* =========================================
           EMPTY STATES
           ========================================= */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: var(--glass-bg);
            border: 1px dashed var(--glass-border);
            border-radius: var(--radius-lg);
            width: 100%;
            box-sizing: border-box;
        }
        .empty-state i {
            font-size: 4rem;
            color: var(--text-muted);
            margin-bottom: 20px;
            opacity: 0.5;
        }
        .empty-state h4 { color: var(--text-white); margin-bottom: 8px; }
        .empty-state p { color: var(--text-gray); margin-bottom: 24px; }

        /* =========================================
           FILTER BAR
           ========================================= */
        .filter-bar {
            display: flex;
            gap: 12px;
            margin-bottom: 20px;
            flex-wrap: wrap;
            align-items: center;
            width: 100%;
        }
        .filter-bar select {
            padding: 8px 14px;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 8px;
            color: var(--text-white);
            font-size: 0.85rem;
            min-width: 120px;
        }
        .filter-bar select option { background: var(--bg-secondary); }

        /* =========================================
           RESPONSIVE DESIGN
           ========================================= */
        @media (max-width: 992px) {
            .balance-card {
                padding: 30px 20px;
            }
            .balance-amount {
                font-size: 2.5rem;
            }
        }

        @media (max-width: 768px) {
            .wallet-header {
                flex-direction: column;
                align-items: flex-start;
            }
            .wallet-tabs {
                width: 100%;
                overflow-x: auto;
                flex-wrap: nowrap;
            }
            .wallet-tab {
                flex: 0 0 auto;
                padding: 10px 16px;
                font-size: 0.8rem;
            }
            .balance-card {
                padding: 24px 16px;
            }
            .balance-amount {
                font-size: 2rem;
            }
            .deposit-section, .withdraw-section {
                padding: 20px 16px;
            }
            .filter-bar select {
                min-width: 100px;
                font-size: 0.8rem;
            }
            .history-table table {
                min-width: 600px;
            }
            .wallet-card-actions {
                flex-direction: column;
            }
            .wallet-card-btn {
                width: 100%;
            }
        }

        @media (max-width: 576px) {
            .wallet-header h2 {
                font-size: 1.5rem;
            }
            .balance-amount {
                font-size: 1.8rem;
            }
            .wallet-card {
                padding: 20px 16px;
            }
            .wallet-card-balance {
                font-size: 1.3rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Header -->
    <div class="wallet-header" data-aos="fade-up">
        <div>
            <h2>My Wallet</h2>
            <p class="text-gray mb-0">Manage your crypto assets securely</p>
        </div>
        <a href="<%= ResolveUrl("~/Web/User/Wallet.aspx?action=deposit") %>" class="btn btn-primary-glow">
            <i class="fas fa-plus me-2"></i> Deposit Funds
        </a>
    </div>

    <!-- Tabs -->
    <div class="wallet-tabs" data-aos="fade-up">
        <button type="button" class="wallet-tab active" data-tab="overview">
            <i class="fas fa-wallet me-1"></i> Overview
        </button>
        <button type="button" class="wallet-tab" data-tab="deposit">
            <i class="fas fa-arrow-down me-1"></i> Deposit
        </button>
        <button type="button" class="wallet-tab" data-tab="web3">
            <i class="fas fa-arrow-down me-1"></i> Web3 Deposit
        </button>


        <button type="button" class="wallet-tab" data-tab="withdraw">
            <i class="fas fa-arrow-up me-1"></i> Withdraw
        </button>
        <button type="button" class="wallet-tab" data-tab="history">
            <i class="fas fa-history me-1"></i> History
        </button>
    </div>

    <!-- OVERVIEW TAB -->
    <div id="tab-overview" class="tab-content" data-aos="fade-up">
        
        <!-- Total Balance Card -->
        <div class="balance-card">
            <div class="row align-items-center position-relative" style="z-index: 2;">
                <div class="col-lg-8 mb-3 mb-lg-0">
                    <div class="balance-label">Total Portfolio Value</div>
                    <div class="balance-amount">
                        <asp:Literal ID="litTotalBalance" runat="server" Text="0.00"></asp:Literal>
                        <small style="font-size: 1.2rem; color: var(--text-gray);"> PNC</small>
                    </div>
                    <div class="balance-usd">
                        ≈ $<asp:Literal ID="litTotalUSD" runat="server" Text="0.00"></asp:Literal> USD
                    </div>
                </div>
                <div class="col-lg-4 text-lg-end">
                    <div class="balance-actions">
                        <a href="<%= ResolveUrl("~/Web/User/Wallet.aspx?action=deposit") %>" class="btn btn-primary-glow">
                            <i class="fas fa-arrow-down me-2"></i> Deposit
                        </a>
                        <a href="<%= ResolveUrl("~/Web/User/Wallet.aspx?action=withdraw") %>" class="btn btn-outline-glass">
                            <i class="fas fa-arrow-up me-2"></i> Withdraw
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Wallet Cards -->
        <h4 class="text-white mb-3" data-aos="fade-up">Your Wallets</h4>
        <div class="row g-4">
            <asp:Repeater ID="rptWallets" runat="server">
                <ItemTemplate>
                    <div class="col-md-6 col-lg-3" data-aos="fade-up">
                        <div class="wallet-card">
                            <div class="wallet-card-header">
                                <div class='wallet-card-icon <%# Eval("CurrencyCode").ToString().ToLower() %>'>
                                    <i class='<%# GetCurrencyIcon(Eval("CurrencyCode")) %>'></i>
                                </div>
                                <div>
                                    <h5 class="wallet-card-name"><%# Eval("CurrencyName") %></h5>
                                    <small class="wallet-card-code"><%# Eval("CurrencyCode") %></small>
                                </div>
                            </div>
                            <div class="wallet-card-balance">
                                <%# string.Format("{0:0.########}", Eval("Balance")) %>
                            </div>
                            <asp:Panel runat="server" Visible='<%# Convert.ToDecimal(Eval("LockedBalance")) > 0 %>'>
                                <div class="wallet-card-locked">
                                    <i class="fas fa-lock"></i>
                                    Locked: <%# string.Format("{0:0.########}", Eval("LockedBalance")) %>
                                </div>
                            </asp:Panel>
                            <div class="wallet-card-actions">
                                <a href='<%# ResolveUrl("~/Web/User/Wallet.aspx?action=deposit&currency=" + Eval("CurrencyCode")) %>' class="wallet-card-btn primary">
                                    Deposit
                                </a>
                                <a href='<%# ResolveUrl("~/Web/User/Wallet.aspx?action=withdraw&currency=" + Eval("CurrencyCode")) %>' class="wallet-card-btn">
                                    Withdraw
                                </a>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnlNoWallets" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-wallet"></i>
                <h4>No Wallets Yet</h4>
                <p>Your wallets will appear here once you make your first deposit.</p>
            </div>
        </asp:Panel>
    </div>








    <!-- DEPOSIT TAB -->
    <div id="tab-deposit" class="tab-content" style="display: none;" data-aos="fade-up">
        <div class="deposit-section">
            <h4 class="text-white mb-3">
                <i class="fas fa-arrow-down text-accent me-2"></i>
                Deposit Funds
            </h4>
            <p class="text-gray mb-4">Send crypto to your unique deposit address below.</p>

            <asp:Panel ID="pnlDepositSuccess" runat="server" Visible="false">
                <div class="alert-box success">
                    <i class="fas fa-check-circle"></i>
                    <asp:Literal ID="litDepositSuccess" runat="server"></asp:Literal>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlDepositError" runat="server" Visible="false">
                <div class="alert-box error">
                    <i class="fas fa-exclamation-circle"></i>
                    <asp:Literal ID="litDepositError" runat="server"></asp:Literal>
                </div>
            </asp:Panel>

            <div class="form-group-custom">
                <label>Select Currency <span class="required">*</span></label>
                <div class="input-icon-wrap">
                    <asp:DropDownList ID="ddlDepositCurrency" runat="server" OnSelectedIndexChanged="ddlDepositCurrency_SelectedIndexChanged" AutoPostBack="true">
                    </asp:DropDownList>
                    <i class="fas fa-coins input-icon"></i>
                </div>
            </div>

            <div class="deposit-address-box">
                <h5 class="text-white mb-2">Your Deposit Address</h5>
                <small class="text-muted">Send only <strong class="text-secondary"><asp:Literal ID="litDepositCurrencyName" runat="server"></asp:Literal></strong> to this address</small>
                
                <div class="qr-code">
                    <img id="depositQR" src="" alt="QR Code" width="180" height="180" 
                         onerror="this.src='https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=Loading...'">
                </div>

                <div class="deposit-address" id="depositAddress">
                    <asp:Literal ID="litDepositAddress" runat="server" Text="Loading deposit address..."></asp:Literal>
                </div>

                <button type="button" class="copy-btn" onclick="copyDepositAddress()">
                    <i class="fas fa-copy"></i> Copy Address
                </button>
            </div>

            <div class="alert-box warning">
                <i class="fas fa-exclamation-triangle"></i>
                <div>
                    <strong class="text-white">Important:</strong>
                    <ul class="mb-0 mt-1" style="padding-left: 18px;">
                        <li>Send only <strong class="text-secondary"><asp:Literal ID="litDepositCurrencyName2" runat="server"></asp:Literal></strong> to this address</li>
                        <li>Minimum deposit: <strong class="text-white"><asp:Literal ID="litMinDeposit" runat="server"></asp:Literal></strong></li>
                        <li>Deposits require <strong class="text-white">3 network confirmations</strong></li>
                        <li>Your address will not change on future deposits</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>





    <!-- Web3 Deposit Section -->
<div class="web3-deposit-section" style="margin-top: 32px;">
    <h4 class="text-white mb-3">
        <i class="fab fa-ethereum text-accent me-2"></i>
        Web3 Deposit (MetaMask)
    </h4>
    <p class="text-gray mb-4">Deposit directly from your Web3 wallet (MetaMask, WalletConnect, etc.)</p>

    <!-- Connect Wallet Button -->
    <div id="web3ConnectSection" class="mb-4">
        <button type="button" id="btnConnectWallet" class="btn btn-primary-glow w-100" onclick="connectWeb3Wallet()">
            <i class="fas fa-wallet me-2"></i> Connect MetaMask Wallet
        </button>
    </div>

    <!-- Connected Wallet Info -->
    <div id="web3ConnectedSection" style="display: none;" class="mb-4">
        <div class="alert-box success">
            <i class="fas fa-check-circle"></i>
            <div>
                <strong class="text-white">Wallet Connected!</strong><br>
                <small class="text-muted">Address: <span id="connectedWalletAddress" class="text-accent"></span></small>
            </div>
        </div>
    </div>

    <!-- Web3 Deposit Form -->
    <div id="web3DepositForm" style="display: none;">
        <div class="form-group-custom">
            <label>Select Network <span class="required">*</span></label>
            <div class="input-icon-wrap">
                <select id="ddlWeb3Network" onchange="updateWeb3DepositAddress()">
                    <option value="ethereum">Ethereum (ERC20)</option>
                    <option value="bsc">BNB Smart Chain (BEP20)</option>
                    <option value="polygon">Polygon (MATIC)</option>
                </select>
                <i class="fas fa-network-wired input-icon"></i>
            </div>
        </div>

        <div class="form-group-custom">
            <label>Select Token <span class="required">*</span></label>
            <div class="input-icon-wrap">
                <select id="ddlWeb3Token" onchange="updateWeb3DepositAddress()">
                    <option value="ETH">ETH (Ethereum)</option>
                    <option value="USDT">USDT (Tether)</option>
                    <option value="USDC">USDC (USD Coin)</option>
                    <option value="BNB">BNB (Binance Coin)</option>
                    <option value="PNC">PNC (Pinnacle Coin)</option>
                </select>
                <i class="fas fa-coins input-icon"></i>
            </div>
        </div>

        <div class="form-group-custom">
            <label>Your Balance</label>
            <div style="padding: 12px 16px; background: rgba(0, 255, 178, 0.05); border: 1px solid rgba(0, 255, 178, 0.2); border-radius: 10px; color: var(--accent); font-weight: 700;">
                <span id="web3TokenBalance">0.00</span>
                <small class="text-muted" style="font-weight: 400;"> <span id="web3TokenSymbol">ETH</span></small>
            </div>
        </div>

        <div class="form-group-custom">
            <label>Deposit Address</label>
            <div class="deposit-address-box">
                <div class="deposit-address" id="web3DepositAddress">
                    Loading deposit address...
                </div>
                <button type="button" class="copy-btn" onclick="copyWeb3DepositAddress()">
                    <i class="fas fa-copy"></i> Copy Address
                </button>
            </div>
        </div>

        <div class="form-group-custom">
            <label>Amount to Deposit <span class="required">*</span></label>
            <div class="input-icon-wrap">
                <input type="number" id="txtWeb3Amount" placeholder="0.00" step="0.00000001" min="0">
                <i class="fas fa-coins input-icon"></i>
            </div>
            <div class="d-flex gap-2 mt-2">
                <button type="button" class="wallet-card-btn" onclick="setWeb3Amount(25)">25%</button>
                <button type="button" class="wallet-card-btn" onclick="setWeb3Amount(50)">50%</button>
                <button type="button" class="wallet-card-btn" onclick="setWeb3Amount(75)">75%</button>
                <button type="button" class="wallet-card-btn" onclick="setWeb3Amount(100)">Max</button>
            </div>
        </div>

        <div class="alert-box warning">
            <i class="fas fa-exclamation-triangle"></i>
            <div>
                <strong class="text-white">Important:</strong>
                <ul class="mb-0 mt-1" style="padding-left: 18px;">
                    <li>Send only <strong class="text-accent"><span id="web3TokenName">ETH</span></strong> to this address</li>
                    <li>Minimum deposit: <strong class="text-white"><span id="web3MinDeposit">0.01</span></strong></li>
                    <li>Requires <strong class="text-white">12-30 confirmations</strong> depending on network</li>
                    <li>Gas fees will be deducted from your wallet</li>
                </ul>
            </div>
        </div>

        <button type="button" id="btnWeb3Deposit" class="btn btn-primary-glow w-100" onclick="executeWeb3Deposit()">
            <i class="fas fa-paper-plane me-2"></i> Deposit via MetaMask
        </button>
    </div>

    <!-- Transaction Status -->
    <div id="web3TransactionStatus" style="display: none;" class="mt-4">
        <div class="chart-card">
            <h5 class="chart-title mb-3">
                <i class="fas fa-clock text-accent me-2"></i>
                Transaction Status
            </h5>
            <div id="transactionStatusContent"></div>
        </div>
    </div>
</div>

    <!-- WITHDRAW TAB -->
    <div id="tab-withdraw" class="tab-content" style="display: none;" data-aos="fade-up">
        <div class="withdraw-section">
            <h4 class="text-white mb-3">
                <i class="fas fa-arrow-up text-secondary me-2"></i>
                Withdraw Funds
            </h4>
            <p class="text-gray mb-4">Transfer crypto to your external wallet.</p>

            <asp:Panel ID="pnlWithdrawSuccess" runat="server" Visible="false">
                <div class="alert-box success">
                    <i class="fas fa-check-circle"></i>
                    <asp:Literal ID="litWithdrawSuccess" runat="server"></asp:Literal>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlWithdrawError" runat="server" Visible="false">
                <div class="alert-box error">
                    <i class="fas fa-exclamation-circle"></i>
                    <asp:Literal ID="litWithdrawError" runat="server"></asp:Literal>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlWithdrawForm" runat="server">
                <div class="form-group-custom">
                    <label>Currency <span class="required">*</span></label>
                    <div class="input-icon-wrap">
                        <asp:DropDownList ID="ddlWithdrawCurrency" runat="server" OnSelectedIndexChanged="ddlWithdrawCurrency_SelectedIndexChanged" AutoPostBack="true">
                        </asp:DropDownList>
                        <i class="fas fa-coins input-icon"></i>
                    </div>
                </div>

                <div class="form-group-custom">
                    <label>Available Balance</label>
                    <div style="padding: 12px 16px; background: rgba(0, 255, 178, 0.05); border: 1px solid rgba(0, 255, 178, 0.2); border-radius: 10px; color: var(--accent); font-weight: 700;">
                        <asp:Literal ID="litAvailableBalance" runat="server" Text="0.00"></asp:Literal>
                        <small class="text-muted" style="font-weight: 400;"> <asp:Literal ID="litWithdrawCurrencyCode" runat="server"></asp:Literal></small>
                    </div>
                </div>

                <div class="form-group-custom">
                    <label>Destination Address <span class="required">*</span></label>
                    <div class="input-icon-wrap">
                        <asp:TextBox ID="txtWithdrawAddress" runat="server" placeholder="Enter wallet address"></asp:TextBox>
                        <i class="fas fa-wallet input-icon"></i>
                    </div>
                </div>

                <div class="form-group-custom">
                    <label>Amount <span class="required">*</span></label>
                    <div class="input-icon-wrap">
                        <asp:TextBox ID="txtWithdrawAmount" runat="server" TextMode="Number" placeholder="0.00" step="0.00000001" oninput="calculateReceive()"></asp:TextBox>
                        <i class="fas fa-coins input-icon"></i>
                    </div>
                    <div class="d-flex gap-2 mt-2">
                        <button type="button" class="wallet-card-btn" onclick="setWithdrawPercent(25)">25%</button>
                        <button type="button" class="wallet-card-btn" onclick="setWithdrawPercent(50)">50%</button>
                        <button type="button" class="wallet-card-btn" onclick="setWithdrawPercent(75)">75%</button>
                        <button type="button" class="wallet-card-btn" onclick="setWithdrawPercent(100)">Max</button>
                    </div>
                </div>

                <div class="form-group-custom">
                    <label>Network Fee</label>
                    <div style="padding: 12px 16px; background: rgba(255, 215, 0, 0.05); border: 1px solid rgba(255, 215, 0, 0.2); border-radius: 10px; color: var(--gold); font-weight: 600;">
                        <asp:Literal ID="litNetworkFee" runat="server" Text="0.00"></asp:Literal>
                        <small class="text-muted" style="font-weight: 400;"> <asp:Literal ID="litFeeCurrency" runat="server"></asp:Literal></small>
                    </div>
                </div>

                <div class="form-group-custom">
                    <label>You'll Receive</label>
                    <div style="padding: 12px 16px; background: rgba(0, 255, 178, 0.1); border: 1px solid rgba(0, 255, 178, 0.3); border-radius: 10px; color: var(--accent); font-weight: 700; font-size: 1.1rem;">
                        <asp:Literal ID="litYouReceive" runat="server" Text="0.00"></asp:Literal>
                        <small class="text-muted" style="font-weight: 400;"> <asp:Literal ID="litReceiveCurrency" runat="server"></asp:Literal></small>
                    </div>
                </div>

                <div class="form-group-custom">
                    <label>2FA Code <span class="required">*</span></label>
                    <div class="input-icon-wrap">
                        <asp:TextBox ID="txt2FACode" runat="server" placeholder="Enter 6-digit code" MaxLength="6"></asp:TextBox>
                        <i class="fas fa-shield-alt input-icon"></i>
                    </div>
                    <small class="text-muted">Enter the code from your authenticator app</small>
                </div>

                <asp:Button ID="btnWithdraw" runat="server" Text="Confirm Withdrawal" CssClass="btn btn-primary-glow w-100" OnClick="btnWithdraw_Click" />
            </asp:Panel>
        </div>
    </div>

    <!-- HISTORY TAB -->
    <div id="tab-history" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <!-- Filter Bar -->
        <div class="filter-bar">
            <select id="filterType" onchange="filterTransactions()">
                <option value="all">All Types</option>
                <option value="deposit">Deposits</option>
                <option value="withdraw">Withdrawals</option>
                <option value="transfer">Transfers</option>
            </select>
            <select id="filterStatus" onchange="filterTransactions()">
                <option value="all">All Status</option>
                <option value="completed">Completed</option>
                <option value="pending">Pending</option>
                <option value="failed">Failed</option>
            </select>
            <select id="filterCurrency" onchange="filterTransactions()">
                <option value="all">All Currencies</option>
                <asp:Repeater ID="rptFilterCurrencies" runat="server">
                    <ItemTemplate>
                        <option value='<%# Eval("CurrencyCode") %>'><%# Eval("CurrencyCode") %></option>
                    </ItemTemplate>
                </asp:Repeater>
            </select>
        </div>

        <!-- Transaction Table -->
        <div class="history-table">
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Type</th>
                            <th>Currency</th>
                            <th>Amount</th>
                            <th>Fee</th>
                            <th>Status</th>
                            <th>TXID</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptTransactions" runat="server">
                            <ItemTemplate>
                                <tr data-type='<%# Eval("TypeSlug") %>' data-status='<%# Eval("StatusSlug") %>' data-currency='<%# Eval("CurrencyCode") %>'>
                                    <td class="text-muted"><%# Convert.ToDateTime(Eval("CreatedDate")).ToString("MMM dd, yyyy HH:mm") %></td>
                                    <td>
                                        <i class='<%# GetTransactionTypeIcon(Eval("TransactionType")) %>' style="margin-right: 6px;"></i>
                                        <%# Eval("TypeName") %>
                                    </td>
                                    <td class="text-white"><%# Eval("CurrencyCode") %></td>
                                    <td class='<%# Convert.ToDecimal(Eval("Amount")) >= 0 ? "amount-positive" : "amount-negative" %>'>
                                        <%# (Convert.ToDecimal(Eval("Amount")) >= 0 ? "+" : "") + string.Format("{0:0.########}", Eval("Amount")) %>
                                    </td>
                                    <td class="text-muted"><%# string.Format("{0:0.########}", Eval("Fee")) %></td>
                                    <td>
                                        <span class='status-badge <%# GetStatusClass(Eval("Status")) %>'>
                                            <%# Eval("StatusName") %>
                                        </span>
                                    </td>
                                    <td>
                                        <asp:Panel runat="server" Visible='<%# !string.IsNullOrEmpty(Eval("TxHash").ToString()) %>'>
                                            <small class="text-secondary" style="font-family: monospace;">
                                                <%# Eval("TxHash").ToString().Length > 10 ? Eval("TxHash").ToString().Substring(0, 10) + "..." : Eval("TxHash") %>
                                            </small>
                                        </asp:Panel>
                                        <asp:Panel runat="server" Visible='<%# string.IsNullOrEmpty(Eval("TxHash").ToString()) %>'>
                                            <small class="text-muted">—</small>
                                        </asp:Panel>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>

        <asp:Panel ID="pnlNoTransactions" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-exchange-alt"></i>
                <h4>No Transactions Yet</h4>
                <p>Your transaction history will appear here once you make deposits or withdrawals.</p>
                <a href="<%= ResolveUrl("~/Web/User/Wallet.aspx?action=deposit") %>" class="btn btn-primary-glow">
                    <i class="fas fa-arrow-down me-2"></i> Make Your First Deposit
                </a>
            </div>
        </asp:Panel>
    </div>

    <!-- Hidden field to persist active tab -->
    <asp:HiddenField ID="hfActiveTab" runat="server" Value="overview" />
</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        // Single initialization - no duplicates
        (function() {
            'use strict';
            
            // Wait for DOM to be ready
            function initWalletTabs() {
                var tabs = document.querySelectorAll('.wallet-tab');
                var contents = document.querySelectorAll('.tab-content');
                var activeTabInput = document.getElementById('<%= hfActiveTab.ClientID %>');
                
                if (!tabs.length || !contents.length) {
                    // Retry if elements not found yet
                    setTimeout(initWalletTabs, 100);
                    return;
                }

                // Tab switching function
                function switchTab(tabName) {
                    // Remove active from all tabs
                    tabs.forEach(function(t) { 
                        t.classList.remove('active'); 
                    });
                    
                    // Hide all content
                    contents.forEach(function(c) { 
                        c.style.display = 'none'; 
                    });
                    
                    // Activate clicked tab
                    var targetTab = document.querySelector('[data-tab="' + tabName + '"]');
                    var targetContent = document.getElementById('tab-' + tabName);
                    
                    if (targetTab) {
                        targetTab.classList.add('active');
                    }
                    if (targetContent) {
                        targetContent.style.display = 'block';
                    }
                    
                    // Save to hidden field
                    if (activeTabInput) {
                        activeTabInput.value = tabName;
                    }
                }

                // Attach click handlers
                tabs.forEach(function(tab) {
                    tab.addEventListener('click', function(e) {
                        e.preventDefault();
                        var tabName = this.getAttribute('data-tab');
                        switchTab(tabName);
                    });
                });

                // Determine which tab to show
                var tabToShow = 'overview';
                
                // Priority 1: URL parameter
                var urlParams = new URLSearchParams(window.location.search);
                var action = urlParams.get('action');
                if (action === 'deposit' || action === 'withdraw') {
                    tabToShow = action;
                }
                // Priority 2: Saved tab from hidden field
                else if (activeTabInput && activeTabInput.value) {
                    tabToShow = activeTabInput.value;
                }

                // Initialize with correct tab
                switchTab(tabToShow);

                console.log('Wallet tabs initialized. Active tab:', tabToShow);
            }

            // Initialize when DOM is ready
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', initWalletTabs);
            } else {
                initWalletTabs();
            }
        })();

        // Copy deposit address
        function copyDepositAddress() {
            var address = document.getElementById('depositAddress').innerText.trim();
            if (!address || address === 'Loading deposit address...') {
                alert('Please select a currency first');
                return;
            }
            
            if (navigator.clipboard && navigator.clipboard.writeText) {
                navigator.clipboard.writeText(address).then(function() {
                    showCopySuccess();
                }).catch(function() {
                    fallbackCopy(address);
                });
            } else {
                fallbackCopy(address);
            }
        }

        function fallbackCopy(text) {
            var textArea = document.createElement('textarea');
            textArea.value = text;
            textArea.style.position = 'fixed';
            textArea.style.left = '-9999px';
            document.body.appendChild(textArea);
            textArea.select();
            try {
                document.execCommand('copy');
                showCopySuccess();
            } catch (err) {
                alert('Failed to copy address');
            }
            document.body.removeChild(textArea);
        }

        function showCopySuccess() {
            var btn = event.target.closest('.copy-btn');
            if (btn) {
                var originalHTML = btn.innerHTML;
                btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                btn.style.background = 'linear-gradient(135deg, #00FFB2, #00D4FF)';
                setTimeout(function() { 
                    btn.innerHTML = originalHTML;
                    btn.style.background = '';
                }, 2000);
            }
        }

        // Set withdraw percentage
        function setWithdrawPercent(percent) {
            var balance = parseFloat('<%= AvailableBalance %>') || 0;
            var amount = (balance * percent / 100).toFixed(8);
            var amountInput = document.getElementById('<%= txtWithdrawAmount.ClientID %>');
            if (amountInput) {
                amountInput.value = amount;
                calculateReceive();
            }
        }

        // Calculate receive amount
        function calculateReceive() {
            var amountInput = document.getElementById('<%= txtWithdrawAmount.ClientID %>');
            var amount = amountInput ? parseFloat(amountInput.value) || 0 : 0;
            var fee = parseFloat('<%= NetworkFee %>') || 0;
            var receive = Math.max(0, amount - fee);
            var receiveElement = document.getElementById('<%= litYouReceive.ClientID %>');
            if (receiveElement) {
                receiveElement.innerText = receive.toFixed(8);
            }
        }

        // Filter transactions
        function filterTransactions() {
            var type = document.getElementById('filterType').value;
            var status = document.getElementById('filterStatus').value;
            var currency = document.getElementById('filterCurrency').value;

            var rows = document.querySelectorAll('.history-table tbody tr');
            rows.forEach(function(row) {
                var matchType = type === 'all' || row.dataset.type === type;
                var matchStatus = status === 'all' || row.dataset.status === status;
                var matchCurrency = currency === 'all' || row.dataset.currency === currency;
                row.style.display = (matchType && matchStatus && matchCurrency) ? '' : 'none';
            });
        }
    </script>
</asp:Content>