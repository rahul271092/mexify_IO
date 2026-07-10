<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="NFTs.aspx.cs" Inherits="Mexify.Web.User.NFTs" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .nft-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            flex-wrap: wrap;
            gap: 16px;
        }
        .nft-header h2 { color: var(--text-white); margin: 0; font-size: 1.8rem; }

        .nft-tabs {
            display: flex;
            gap: 4px;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 50px;
            padding: 4px;
            margin-bottom: 28px;
            width: fit-content;
        }
        .nft-tab {
            padding: 10px 24px;
            border-radius: 50px;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-gray);
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            background: transparent;
        }
        .nft-tab.active {
            background: linear-gradient(135deg, #9C27B0, #E91E63);
            color: var(--text-white);
            box-shadow: 0 4px 12px rgba(156, 39, 176, 0.3);
        }
        .nft-tab:hover:not(.active) {
            background: rgba(255, 255, 255, 0.05);
            color: var(--text-white);
        }

        .nft-summary {
            background: linear-gradient(135deg, rgba(156, 39, 176, 0.15), rgba(233, 30, 99, 0.1));
            border: 1px solid rgba(156, 39, 176, 0.3);
            border-radius: var(--radius-xl);
            padding: 40px;
            position: relative;
            overflow: hidden;
            margin-bottom: 32px;
        }
        .nft-summary::before {
            content: '';
            position: absolute;
            top: -50%; right: -10%;
            width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(156, 39, 176, 0.15) 0%, transparent 70%);
            animation: float 15s ease-in-out infinite;
        }
        @keyframes float {
            0%,100%{transform:translate(0,0) scale(1)}
            50%{transform:translate(20px,-20px) scale(1.1)}
        }

        .summary-label {
            color: var(--text-gray);
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            margin-bottom: 8px;
        }
        .summary-value {
            font-size: 3rem;
            font-weight: 800;
            color: var(--text-white);
            font-family: 'Space Grotesk', sans-serif;
            margin-bottom: 4px;
        }
        .summary-value small { font-size: 1.2rem; color: var(--text-gray); }

        .nft-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            overflow: hidden;
            transition: all 0.3s ease;
            cursor: pointer;
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        .nft-card:hover {
            transform: translateY(-5px);
            border-color: #9C27B0;
            box-shadow: 0 15px 40px rgba(156, 39, 176, 0.2);
        }
        .nft-image-wrap {
            position: relative;
            width: 100%;
            padding-top: 100%;
            overflow: hidden;
            background: linear-gradient(135deg, rgba(156, 39, 176, 0.1), rgba(233, 30, 99, 0.05));
        }
        .nft-image {
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        .nft-card:hover .nft-image {
            transform: scale(1.05);
        }
        .nft-rarity {
            position: absolute;
            top: 12px; left: 12px;
            padding: 4px 10px;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            backdrop-filter: blur(10px);
        }
        .nft-rarity.legendary { background: rgba(255, 215, 0, 0.9); color: #000; }
        .nft-rarity.epic { background: rgba(156, 39, 176, 0.9); color: #fff; }
        .nft-rarity.rare { background: rgba(0, 212, 255, 0.9); color: #000; }
        .nft-rarity.common { background: rgba(107, 117, 141, 0.9); color: #fff; }
        .nft-collection-badge {
            position: absolute;
            top: 12px; right: 12px;
            padding: 4px 10px;
            background: rgba(0, 0, 0, 0.7);
            color: #fff;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
            backdrop-filter: blur(10px);
        }
        .nft-body {
            padding: 16px;
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        .nft-title {
            color: var(--text-white);
            font-weight: 700;
            font-size: 1rem;
            margin-bottom: 4px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .nft-creator {
            color: var(--text-muted);
            font-size: 0.8rem;
            margin-bottom: 12px;
        }
        .nft-creator i { color: #9C27B0; margin-right: 4px; }
        .nft-price-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 12px;
            border-top: 1px solid var(--glass-border);
            margin-top: auto;
        }
        .nft-price-label {
            font-size: 0.7rem;
            color: var(--text-muted);
            text-transform: uppercase;
        }
        .nft-price-value {
            font-size: 1.1rem;
            font-weight: 800;
            color: var(--accent);
        }
        .nft-price-value small {
            font-size: 0.75rem;
            color: var(--text-gray);
            font-weight: 500;
        }

        .stat-card-mini {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-md);
            padding: 16px;
            text-align: center;
        }
        .stat-card-mini .value {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--text-white);
            font-family: 'Space Grotesk', sans-serif;
        }
        .stat-card-mini .label {
            font-size: 0.7rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .chart-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 24px;
        }
        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .chart-title {
            color: var(--text-white);
            font-weight: 700;
            font-size: 1.1rem;
            margin: 0;
        }

        .activity-item {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 14px 0;
            border-bottom: 1px solid var(--glass-border);
        }
        .activity-item:last-child { border-bottom: none; }
        .activity-icon {
            width: 42px; height: 42px;
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0;
            font-size: 1rem;
        }
        .activity-icon.buy { background: rgba(0, 255, 178, 0.15); color: var(--accent); }
        .activity-icon.sell { background: rgba(255, 59, 92, 0.15); color: #ff3b5c; }
        .activity-icon.mint { background: rgba(156, 39, 176, 0.15); color: #9C27B0; }
        .activity-icon.transfer { background: rgba(0, 212, 255, 0.15); color: var(--secondary); }
        .activity-info { flex: 1; min-width: 0; }
        .activity-title { color: var(--text-white); font-weight: 600; font-size: 0.9rem; margin-bottom: 2px; }
        .activity-meta { color: var(--text-muted); font-size: 0.75rem; }
        .activity-amount { text-align: right; font-weight: 700; font-size: 0.9rem; }
        .activity-amount.positive { color: var(--accent); }
        .activity-amount.negative { color: #ff3b5c; }

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

        .filter-bar {
            display: flex;
            gap: 12px;
            margin-bottom: 20px;
            flex-wrap: wrap;
            align-items: center;
        }
        .filter-bar select,
        .filter-bar input {
            padding: 8px 14px;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 8px;
            color: var(--text-white);
            font-size: 0.85rem;
        }
        .filter-bar select option { background: var(--bg-secondary); }
        .filter-bar input::placeholder { color: var(--text-muted); }

        .history-table {
            width: 100%;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            overflow: hidden;
        }
        .history-table table { width: 100%; color: var(--text-gray); }
        .history-table th {
            background: rgba(156, 39, 176, 0.08);
            padding: 14px 16px;
            color: var(--text-white);
            font-weight: 600;
            font-size: 0.85rem;
            text-align: left;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .history-table td {
            padding: 14px 16px;
            border-bottom: 1px solid var(--glass-border);
            font-size: 0.9rem;
        }
        .history-table tr:last-child td { border-bottom: none; }
        .history-table tr:hover { background: rgba(255, 255, 255, 0.02); }

        .status-badge {
            padding: 3px 10px;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        .status-listed { background: rgba(0, 255, 178, 0.15); color: var(--accent); }
        .status-owned { background: rgba(0, 212, 255, 0.15); color: var(--secondary); }
        .status-sold { background: rgba(255, 59, 92, 0.15); color: #ff3b5c; }

        @media (max-width: 768px) {
            .summary-value { font-size: 2rem; }
            .nft-tabs { width: 100%; overflow-x: auto; }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Header -->
    <div class="nft-header" data-aos="fade-up">
        <div>
            <h2>My NFTs</h2>
            <p class="text-gray mb-0">Manage your digital collectibles and creations</p>
        </div>
        <div class="d-flex gap-2">
            <a href="<%= ResolveUrl("~/Web/User/nft.aspx") %>" class="btn btn-outline-glass">
                <i class="fas fa-compass me-2"></i> Marketplace
            </a>
            <a href="<%= ResolveUrl("~/Web/User/MintNFT.aspx") %>" class="btn btn-primary-glow">
                <i class="fas fa-plus me-2"></i> Mint NFT
            </a>
        </div>
    </div>

    <!-- Tabs -->
    <div class="nft-tabs" data-aos="fade-up">
        <button class="nft-tab active" data-tab="overview">
            <i class="fas fa-chart-pie me-1"></i> Overview
        </button>
        <button class="nft-tab" data-tab="owned">
            <i class="fas fa-images me-1"></i>
            Owned (<asp:Literal ID="litOwnedCount" runat="server" Text="0"></asp:Literal>)
        </button>
        <button class="nft-tab" data-tab="created">
            <i class="fas fa-paint-brush me-1"></i>
            Created (<asp:Literal ID="litCreatedCount" runat="server" Text="0"></asp:Literal>)
        </button>
        <button class="nft-tab" data-tab="activity">
            <i class="fas fa-history me-1"></i> Activity
        </button>
    </div>

    <!-- OVERVIEW TAB -->
    <div id="tab-overview" class="tab-content" data-aos="fade-up">
        
        <!-- Summary Card -->
        <div class="nft-summary">
            <div class="row align-items-center position-relative" style="z-index: 2;">
                <div class="col-lg-6">
                    <div class="summary-label">Total NFT Portfolio Value</div>
                    <div class="summary-value">
                        <asp:Literal ID="litTotalValue" runat="server" Text="0.00"></asp:Literal>
                        <small> PNC</small>
                    </div>
                    <div style="color: var(--text-gray); font-size: 1.1rem;">
                        ≈ $<asp:Literal ID="litTotalUSD" runat="server" Text="0.00"></asp:Literal> USD
                    </div>
                </div>
                <div class="col-lg-6 mt-3 mt-lg-0">
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="stat-card-mini">
                                <div class="value" style="color: #9C27B0;">
                                    <asp:Literal ID="litTotalOwned" runat="server" Text="0"></asp:Literal>
                                </div>
                                <div class="label">NFTs Owned</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stat-card-mini">
                                <div class="value" style="color: var(--accent);">
                                    <asp:Literal ID="litTotalCreated" runat="server" Text="0"></asp:Literal>
                                </div>
                                <div class="label">NFTs Created</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stat-card-mini">
                                <div class="value" style="color: var(--gold);">
                                    <asp:Literal ID="litTotalSales" runat="server" Text="0.00"></asp:Literal>
                                </div>
                                <div class="label">Total Sales</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stat-card-mini">
                                <div class="value" style="color: var(--secondary);">
                                    <asp:Literal ID="litRoyalties" runat="server" Text="0.00"></asp:Literal>
                                </div>
                                <div class="label">Royalties Earned</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts Row -->
        <div class="row g-4 mb-4">
            <div class="col-lg-8" data-aos="fade-up">
                <div class="chart-card">
                    <div class="chart-header">
                        <h5 class="chart-title">NFT Portfolio Value</h5>
                    </div>
                    <div style="height: 280px;">
                        <canvas id="valueChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-lg-4" data-aos="fade-up" data-aos-delay="100">
                <div class="chart-card h-100">
                    <div class="chart-header">
                        <h5 class="chart-title">Collection Distribution</h5>
                    </div>
                    <div style="height: 220px;">
                        <canvas id="collectionChart"></canvas>
                    </div>
                    <div id="collectionLegend" class="mt-3"></div>
                </div>
            </div>
        </div>

        <!-- Recent Activity -->
        <div class="chart-card" data-aos="fade-up">
            <div class="chart-header">
                <h5 class="chart-title">
                    <i class="fas fa-bolt" style="color: #9C27B0;"></i>
                    Recent Activity
                </h5>
                <button class="nft-tab" data-tab="activity" onclick="document.querySelector('[data-tab=activity]').click()">View All</button>
            </div>
            <asp:Repeater ID="rptRecentActivity" runat="server">
                <ItemTemplate>
                    <div class="activity-item">
                        <div class='activity-icon <%# Eval("TypeClass") %>'>
                            <i class='<%# Eval("Icon") %>'></i>
                        </div>
                        <div class="activity-info">
                            <div class="activity-title"><%# Eval("Title") %></div>
                            <div class="activity-meta">
                                <%# Eval("NFTTitle") %> · <%# Eval("TimeAgo") %>
                            </div>
                        </div>
                        <div class='activity-amount <%# Convert.ToDecimal(Eval("Amount")) >= 0 ? "positive" : "negative" %>'>
                            <%# (Convert.ToDecimal(Eval("Amount")) >= 0 ? "+" : "") + string.Format("{0:0.00}", Eval("Amount")) %> PNC
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>

    <!-- OWNED TAB -->
    <div id="tab-owned" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <!-- Filter Bar -->
        <div class="filter-bar">
            <select id="filterCollection" onchange="filterNFTs()">
                <option value="all">All Collections</option>
                <asp:Repeater ID="rptFilterCollections" runat="server">
                    <ItemTemplate>
                        <option value='<%# Eval("CollectionId") %>'><%# Eval("CollectionName") %></option>
                    </ItemTemplate>
                </asp:Repeater>
            </select>
            <select id="filterRarity" onchange="filterNFTs()">
                <option value="all">All Rarities</option>
                <option value="legendary">Legendary</option>
                <option value="epic">Epic</option>
                <option value="rare">Rare</option>
                <option value="common">Common</option>
            </select>
            <input type="text" id="searchNFT" placeholder="Search NFTs..." onkeyup="filterNFTs()">
        </div>

        <!-- NFT Grid -->
        <div class="row g-4">
            <asp:Repeater ID="rptOwnedNFTs" runat="server">
                <ItemTemplate>
                    <div class="col-6 col-md-4 col-lg-3" data-aos="fade-up"
                         data-collection='<%# Eval("CollectionId") %>'
                         data-rarity='<%# Eval("Rarity").ToString().ToLower() %>'
                         data-title='<%# Eval("Title").ToString().ToLower() %>'>
                        <a href='<%# ResolveUrl("~/User/NFTDetails.aspx?id=" + Eval("NFTId")) %>' class="nft-card">
                            <div class="nft-image-wrap">
                                <img src='<%# Eval("ImageUrl") %>' 
                                     alt='<%# Eval("Title") %>' 
                                     class="nft-image"
                                     onerror="this.src='https://via.placeholder.com/400x400/9C27B0/FFFFFF?text=NFT'">
                                <span class='nft-rarity <%# Eval("Rarity").ToString().ToLower() %>'>
                                    <%# Eval("Rarity") %>
                                </span>
                                <span class="nft-collection-badge">
                                    <%# Eval("CollectionName") %>
                                </span>
                            </div>
                            <div class="nft-body">
                                <div class="nft-title"><%# Eval("Title") %></div>
                                <div class="nft-creator">
                                    <i class="fas fa-user-circle"></i>
                                    by <%# Eval("CreatorName") %>
                                </div>
                                <div class="nft-price-row">
                                    <div>
                                        <div class="nft-price-label">Current Value</div>
                                        <div class="nft-price-value">
                                            <%# string.Format("{0:0.00}", Eval("CurrentValue")) %>
                                            <small>PNC</small>
                                        </div>
                                    </div>
                                    <div class="text-end">
                                        <div class="nft-price-label">Token ID</div>
                                        <div style="color: var(--text-gray); font-size: 0.8rem;">
                                            #<%# Eval("TokenId") %>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnlNoOwned" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-images"></i>
                <h4>No NFTs Owned Yet</h4>
                <p>Start collecting digital art and unique assets from the marketplace.</p>
                <a href="<%= ResolveUrl("~/nft.aspx") %>" class="btn btn-primary-glow">
                    <i class="fas fa-compass me-2"></i> Explore Marketplace
                </a>
            </div>
        </asp:Panel>
    </div>

    <!-- CREATED TAB -->
    <div id="tab-created" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <div class="row g-4">
            <asp:Repeater ID="rptCreatedNFTs" runat="server">
                <ItemTemplate>
                    <div class="col-6 col-md-4 col-lg-3" data-aos="fade-up">
                        <div class="nft-card">
                            <div class="nft-image-wrap">
                                <img src='<%# Eval("ImageUrl") %>' 
                                     alt='<%# Eval("Title") %>' 
                                     class="nft-image"
                                     onerror="this.src='https://via.placeholder.com/400x400/E91E63/FFFFFF?text=Created'">
                                <span class='nft-rarity <%# Eval("Rarity").ToString().ToLower() %>'>
                                    <%# Eval("Rarity") %>
                                </span>
                                <span class="nft-collection-badge">
                                    <%# Eval("CollectionName") %>
                                </span>
                            </div>
                            <div class="nft-body">
                                <div class="nft-title"><%# Eval("Title") %></div>
                                <div class="nft-creator">
                                    <i class="fas fa-paint-brush"></i>
                                    Created by You
                                </div>
                                <div class="nft-price-row">
                                    <div>
                                        <div class="nft-price-label">Last Sale</div>
                                        <div class="nft-price-value">
                                            <%# string.Format("{0:0.00}", Eval("LastSalePrice")) %>
                                            <small>PNC</small>
                                        </div>
                                    </div>
                                    <div class="text-end">
                                        <span class='status-badge <%# GetStatusClass(Eval("Status")) %>'>
                                            <%# Eval("StatusName") %>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnlNoCreated" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-paint-brush"></i>
                <h4>No NFTs Created Yet</h4>
                <p>Mint your first NFT and start selling to collectors worldwide.</p>
                <a href="<%= ResolveUrl("~/User/MintNFT.aspx") %>" class="btn btn-primary-glow">
                    <i class="fas fa-plus me-2"></i> Create Your First NFT
                </a>
            </div>
        </asp:Panel>
    </div>

    <!-- ACTIVITY TAB -->
    <div id="tab-activity" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="stat-card-mini" style="padding: 24px;">
                    <div class="summary-label">Total Purchases</div>
                    <div style="font-size: 2rem; font-weight: 800; color: var(--accent);">
                        <asp:Literal ID="litTotalPurchases" runat="server" Text="0.00"></asp:Literal>
                        <small style="font-size: 0.9rem; color: var(--text-gray);"> PNC</small>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card-mini" style="padding: 24px;">
                    <div class="summary-label">Total Sales</div>
                    <div style="font-size: 2rem; font-weight: 800; color: var(--gold);">
                        <asp:Literal ID="litTotalSalesActivity" runat="server" Text="0.00"></asp:Literal>
                        <small style="font-size: 0.9rem; color: var(--text-gray);"> PNC</small>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card-mini" style="padding: 24px;">
                    <div class="summary-label">Minting Fees</div>
                    <div style="font-size: 2rem; font-weight: 800; color: #9C27B0;">
                        <asp:Literal ID="litMintingFees" runat="server" Text="0.00"></asp:Literal>
                        <small style="font-size: 0.9rem; color: var(--text-gray);"> PNC</small>
                    </div>
                </div>
            </div>
        </div>

        <div class="chart-card">
            <div class="chart-header">
                <h5 class="chart-title">
                    <i class="fas fa-history" style="color: #9C27B0;"></i>
                    All Activity
                </h5>
            </div>
            <asp:Repeater ID="rptAllActivity" runat="server">
                <ItemTemplate>
                    <div class="activity-item">
                        <div class='activity-icon <%# Eval("TypeClass") %>'>
                            <i class='<%# Eval("Icon") %>'></i>
                        </div>
                        <div class="activity-info">
                            <div class="activity-title"><%# Eval("Title") %></div>
                            <div class="activity-meta">
                                <%# Eval("NFTTitle") %> · <%# Convert.ToDateTime(Eval("CreatedDate")).ToString("MMM dd, yyyy 'at' hh:mm tt") %>
                            </div>
                        </div>
                        <div class='activity-amount <%# Convert.ToDecimal(Eval("Amount")) >= 0 ? "positive" : "negative" %>'>
                            <%# (Convert.ToDecimal(Eval("Amount")) >= 0 ? "+" : "") + string.Format("{0:0.00}", Eval("Amount")) %> PNC
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoActivity" runat="server" Visible="false">
                <div class="empty-state">
                    <i class="fas fa-history"></i>
                    <h4>No Activity Yet</h4>
                    <p>Your NFT transactions will appear here.</p>
                </div>
            </asp:Panel>
        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Tab switching
            var tabs = document.querySelectorAll('.nft-tab');
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

            // Value Chart
            var valueData = <%= GetValueChartData() %>;
            var valueCtx = document.getElementById('valueChart');
            if (valueCtx && valueData.labels.length > 0) {
                new Chart(valueCtx, {
                    type: 'line',
                    data: {
                        labels: valueData.labels,
                        datasets: [{
                            label: 'Portfolio Value (PNC)',
                            data: valueData.values,
                            borderColor: '#9C27B0',
                            backgroundColor: 'rgba(156, 39, 176, 0.1)',
                            fill: true,
                            tension: 0.4,
                            pointRadius: 0,
                            pointHoverRadius: 6,
                            borderWidth: 2
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { display: false },
                            tooltip: {
                                backgroundColor: 'rgba(11, 19, 43, 0.95)',
                                borderColor: '#9C27B0',
                                borderWidth: 1,
                                callbacks: {
                                    label: function(ctx) { return ctx.parsed.y.toLocaleString() + ' PNC'; }
                                }
                            }
                        },
                        scales: {
                            y: {
                                grid: { color: 'rgba(255,255,255,0.05)' },
                                ticks: { color: '#6B758D', callback: function(v) { return v.toLocaleString(); } }
                            },
                            x: { grid: { display: false }, ticks: { color: '#6B758D' } }
                        }
                    }
                });
            }

            // Collection Distribution Chart
            var collData = <%= GetCollectionChartData() %>;
            var collCtx = document.getElementById('collectionChart');
            if (collCtx && collData.labels.length > 0) {
                new Chart(collCtx, {
                    type: 'doughnut',
                    data: {
                        labels: collData.labels,
                        datasets: [{
                            data: collData.values,
                            backgroundColor: collData.colors,
                            borderColor: 'rgba(7, 17, 31, 0.8)',
                            borderWidth: 3
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        cutout: '70%',
                        plugins: { legend: { display: false } }
                    }
                });

                // Build legend
                var legendHtml = '';
                for (var i = 0; i < collData.labels.length; i++) {
                    legendHtml += '<div class="d-flex align-items-center gap-2 mb-1">' +
                        '<span style="width: 10px; height: 10px; border-radius: 50%; background: ' + collData.colors[i] + '; display: inline-block;"></span>' +
                        '<span class="text-gray small flex-grow-1">' + collData.labels[i] + '</span>' +
                        '<span class="text-white small fw-bold">' + collData.values[i] + '</span>' +
                        '</div>';
                }
                document.getElementById('collectionLegend').innerHTML = legendHtml;
            }
        });

        // Filter NFTs
        function filterNFTs() {
            var collection = document.getElementById('filterCollection').value;
            var rarity = document.getElementById('filterRarity').value;
            var search = document.getElementById('searchNFT').value.toLowerCase();

            var cards = document.querySelectorAll('#tab-owned [data-collection]');
            cards.forEach(function(card) {
                var matchCollection = collection === 'all' || card.dataset.collection === collection;
                var matchRarity = rarity === 'all' || card.dataset.rarity === rarity;
                var matchSearch = search === '' || card.dataset.title.indexOf(search) !== -1;
                card.style.display = (matchCollection && matchRarity && matchSearch) ? '' : 'none';
            });
        }
    </script>
</asp:Content>