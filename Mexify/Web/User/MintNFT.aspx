<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="MintNFT.aspx.cs" Inherits="Mexify.Web.User.MintNFT" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* =========================================
           GLOBAL LAYOUT
           ========================================= */
        .tab-content {
            width: 100% !important;
            max-width: 100% !important;
            box-sizing: border-box;
        }

        /* =========================================
           HEADER & TABS
           ========================================= */
        .nft-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            flex-wrap: wrap;
            gap: 16px;
            width: 100%;
        }
        .nft-header h2 {
            color: var(--text-white);
            margin: 0;
            font-size: 1.8rem;
        }
        .nft-header .subtitle {
            color: var(--text-gray);
            font-size: 0.95rem;
            margin-top: 4px;
        }

        .nft-tabs {
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
            white-space: nowrap;
        }
        .nft-tab.active {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: var(--text-white);
            box-shadow: 0 4px 12px rgba(123, 44, 191, 0.3);
        }
        .nft-tab:hover:not(.active) {
            background: rgba(255, 255, 255, 0.05);
            color: var(--text-white);
        }

        /* =========================================
           STATS CARDS
           ========================================= */
        .nft-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 16px;
            margin-bottom: 32px;
            width: 100%;
        }
        .nft-stat-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 24px;
            text-align: center;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }
        .nft-stat-card:hover {
            border-color: var(--accent);
            transform: translateY(-3px);
        }
        .nft-stat-icon {
            width: 48px; height: 48px;
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.3rem;
            margin: 0 auto 12px;
            background: linear-gradient(135deg, rgba(157, 78, 221, 0.2), rgba(0, 212, 255, 0.1));
            color: var(--accent);
            border: 1px solid rgba(157, 78, 221, 0.3);
        }
        .nft-stat-label {
            color: var(--text-muted);
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 6px;
        }
        .nft-stat-value {
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--text-white);
            line-height: 1.2;
        }
        .nft-stat-value.accent { color: var(--accent); }
        .nft-stat-value.gold { color: var(--gold); }
        .nft-stat-value.secondary { color: var(--secondary); }

        /* =========================================
           COLLECTION CARDS
           ========================================= */
        .collection-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
            width: 100%;
        }
        .collection-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            overflow: hidden;
            transition: all 0.3s ease;
            cursor: pointer;
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        .collection-card:hover {
            transform: translateY(-5px);
            border-color: var(--accent);
            box-shadow: 0 15px 40px rgba(157, 78, 221, 0.2);
        }
        .collection-card.featured {
            border-color: var(--gold);
        }
        .collection-image {
            width: 100%;
            height: 220px;
            background: linear-gradient(135deg, rgba(157, 78, 221, 0.3), rgba(0, 212, 255, 0.2));
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }
        .collection-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .collection-image i {
            font-size: 4rem;
            color: rgba(255, 255, 255, 0.3);
        }
        .collection-badge {
            position: absolute;
            top: 12px;
            right: 12px;
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            background: rgba(255, 215, 0, 0.9);
            color: #000;
            letter-spacing: 0.5px;
        }
        .collection-content {
            padding: 20px;
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        .collection-name {
            color: var(--text-white);
            font-size: 1.1rem;
            font-weight: 700;
            margin-bottom: 6px;
            word-break: break-word;
        }
        .collection-creator {
            color: var(--text-muted);
            font-size: 0.8rem;
            margin-bottom: 16px;
        }
        .collection-meta {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            padding: 12px 0;
            border-top: 1px solid var(--glass-border);
            border-bottom: 1px solid var(--glass-border);
            margin-bottom: 16px;
        }
        .meta-item {
            text-align: center;
        }
        .meta-label {
            color: var(--text-muted);
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }
        .meta-value {
            color: var(--text-white);
            font-weight: 700;
            font-size: 0.95rem;
        }
        .meta-value.accent { color: var(--accent); }
        .meta-value.gold { color: var(--gold); }
        .collection-btn {
            margin-top: auto;
            padding: 12px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 0.9rem;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: var(--text-white);
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
            text-decoration: none;
            display: block;
        }
        .collection-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(123, 44, 191, 0.4);
        }

        /* =========================================
           MINT FORM
           ========================================= */
        .mint-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            width: 100%;
        }
        .mint-preview {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 32px;
            text-align: center;
        }
        .preview-image {
            width: 100%;
            max-width: 360px;
            aspect-ratio: 1;
            background: linear-gradient(135deg, rgba(157, 78, 221, 0.3), rgba(0, 212, 255, 0.2));
            border-radius: var(--radius-lg);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            overflow: hidden;
        }
        .preview-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .preview-image i {
            font-size: 5rem;
            color: rgba(255, 255, 255, 0.3);
        }
        .preview-title {
            color: var(--text-white);
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 8px;
        }
        .preview-description {
            color: var(--text-gray);
            font-size: 0.9rem;
            margin-bottom: 20px;
            line-height: 1.6;
        }

        .mint-form-card {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 32px;
        }
        .form-section-title {
            color: var(--text-white);
            font-size: 1.2rem;
            font-weight: 700;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .form-section-title i { color: var(--accent); }

        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            color: var(--text-white);
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 8px;
        }
        .form-group label .required { color: #ff3b5c; }
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 14px;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--glass-border);
            border-radius: 10px;
            color: var(--text-white);
            font-size: 0.92rem;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }
        .form-group select option {
            background: var(--bg-secondary);
            color: var(--text-white);
        }
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--accent);
            background: rgba(157, 78, 221, 0.03);
            box-shadow: 0 0 0 3px rgba(157, 78, 221, 0.1);
        }
        .form-group textarea {
            resize: vertical;
            min-height: 100px;
            font-family: inherit;
        }

        .price-summary {
            background: rgba(0, 255, 178, 0.05);
            border: 1px solid rgba(0, 255, 178, 0.2);
            border-radius: 12px;
            padding: 20px;
            margin: 20px 0;
        }
        .price-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            color: var(--text-gray);
            font-size: 0.9rem;
        }
        .price-row.total {
            border-top: 1px solid rgba(0, 255, 178, 0.2);
            margin-top: 8px;
            padding-top: 12px;
            color: var(--text-white);
            font-weight: 700;
            font-size: 1.1rem;
        }
        .price-row .value { color: var(--text-white); font-weight: 600; }
        .price-row.total .value { color: var(--accent); font-size: 1.2rem; }

        .btn-mint {
            width: 100%;
            padding: 14px;
            border-radius: 50px;
            font-size: 1rem;
            font-weight: 700;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: var(--text-white);
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        .btn-mint:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(157, 78, 221, 0.5);
        }
        .btn-mint:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        /* =========================================
           MY NFTs GALLERY
           ========================================= */
        .nft-gallery {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 20px;
            width: 100%;
        }
        .nft-item {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            overflow: hidden;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        .nft-item:hover {
            transform: translateY(-5px);
            border-color: var(--accent);
            box-shadow: 0 15px 40px rgba(157, 78, 221, 0.2);
        }
        .nft-item-image {
            width: 100%;
            aspect-ratio: 1;
            background: linear-gradient(135deg, rgba(157, 78, 221, 0.3), rgba(0, 212, 255, 0.2));
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        .nft-item-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .nft-item-image i {
            font-size: 3rem;
            color: rgba(255, 255, 255, 0.3);
        }
        .nft-item-content {
            padding: 16px;
        }
        .nft-item-name {
            color: var(--text-white);
            font-weight: 600;
            font-size: 0.95rem;
            margin-bottom: 4px;
            word-break: break-word;
        }
        .nft-item-collection {
            color: var(--text-muted);
            font-size: 0.75rem;
            margin-bottom: 8px;
        }
        .nft-item-id {
            color: var(--accent);
            font-size: 0.7rem;
            font-family: monospace;
            background: rgba(157, 78, 221, 0.1);
            padding: 2px 8px;
            border-radius: 50px;
            display: inline-block;
        }

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
            background: rgba(157, 78, 221, 0.08);
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
           RESPONSIVE
           ========================================= */
        @media (max-width: 992px) {
            .mint-container {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .nft-header {
                flex-direction: column;
                align-items: flex-start;
            }
            .nft-tabs {
                width: 100%;
                overflow-x: auto;
                flex-wrap: nowrap;
            }
            .nft-tab {
                flex: 0 0 auto;
                padding: 10px 16px;
                font-size: 0.8rem;
            }
            .collection-grid,
            .nft-gallery {
                grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            }
            .nft-stat-card {
                padding: 18px 12px;
            }
            .nft-stat-value {
                font-size: 1.4rem;
            }
        }

        @media (max-width: 576px) {
            .nft-header h2 {
                font-size: 1.5rem;
            }
            .collection-grid,
            .nft-gallery {
                grid-template-columns: 1fr;
            }
            .mint-form-card,
            .mint-preview {
                padding: 20px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Header -->
    <div class="nft-header" data-aos="fade-up">
        <div>
            <h2><i class="fas fa-palette me-2" style="color: var(--accent);"></i>NFT Marketplace</h2>
            <p class="subtitle">Mint, collect, and trade unique digital assets on the blockchain</p>
        </div>
        <a href="#mint" onclick="switchTab('mint'); return false;" class="btn btn-primary-glow">
            <i class="fas fa-plus me-2"></i> Mint New NFT
        </a>
    </div>

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

    <!-- Tabs -->
    <div class="nft-tabs" data-aos="fade-up">
        <button type="button" class="nft-tab active" data-tab="collections">
            <i class="fas fa-th me-1"></i> Collections
        </button>
        <button type="button" class="nft-tab" data-tab="mint">
            <i class="fas fa-hammer me-1"></i> Mint NFT
        </button>
        <button type="button" class="nft-tab" data-tab="mynfts">
            <i class="fas fa-images me-1"></i> My NFTs
            (<asp:Literal ID="litMyNFTCount" runat="server" Text="0"></asp:Literal>)
        </button>
        <button type="button" class="nft-tab" data-tab="history">
            <i class="fas fa-history me-1"></i> History
        </button>
    </div>

    <!-- =========================================
         COLLECTIONS TAB
         ========================================= -->
    <div id="tab-collections" class="tab-content" data-aos="fade-up">
        
        <!-- Stats -->
        <div class="nft-stats">
            <div class="nft-stat-card">
                <div class="nft-stat-icon"><i class="fas fa-layer-group"></i></div>
                <div class="nft-stat-label">Total Collections</div>
                <div class="nft-stat-value accent">
                    <asp:Literal ID="litTotalCollections" runat="server" Text="0"></asp:Literal>
                </div>
            </div>
            <div class="nft-stat-card">
                <div class="nft-stat-icon"><i class="fas fa-cube"></i></div>
                <div class="nft-stat-label">Total NFTs Minted</div>
                <div class="nft-stat-value gold">
                    <asp:Literal ID="litTotalMinted" runat="server" Text="0"></asp:Literal>
                </div>
            </div>
            <div class="nft-stat-card">
                <div class="nft-stat-icon"><i class="fas fa-users"></i></div>
                <div class="nft-stat-label">Total Holders</div>
                <div class="nft-stat-value secondary">
                    <asp:Literal ID="litTotalHolders" runat="server" Text="0"></asp:Literal>
                </div>
            </div>
            <div class="nft-stat-card">
                <div class="nft-stat-icon"><i class="fas fa-fire"></i></div>
                <div class="nft-stat-label">Floor Price</div>
                <div class="nft-stat-value accent">
                    <asp:Literal ID="litFloorPrice" runat="server" Text="0.00"></asp:Literal>
                </div>
                <small class="text-muted">PNC</small>
            </div>
        </div>

        <!-- Collections Grid -->
        <h4 class="text-white mb-3">
            <i class="fas fa-gem text-accent me-2"></i>
            Featured Collections
        </h4>
        <div class="collection-grid">
            <asp:Repeater ID="rptCollections" runat="server">
                <ItemTemplate>
                    <div class='collection-card <%# (Eval("IsFeatured") != null && Convert.ToBoolean(Eval("IsFeatured"))) ? "featured" : "" %>'>
                        <div class="collection-image">
                            <%# GetCollectionImage(Eval("ImageUrl"), Eval("CollectionName")) %>
                            <%# (Eval("IsFeatured") != null && Convert.ToBoolean(Eval("IsFeatured"))) ? "<span class='collection-badge'>🔥 Featured</span>" : "" %>
                        </div>
                        <div class="collection-content">
                            <h5 class="collection-name"><%# Eval("CollectionName") %></h5>
                            <div class="collection-creator">
                                by <span class="text-accent"><%# Eval("CreatorName") ?? "MEXIFY" %></span>
                            </div>
                            <div class="collection-meta">
                                <div class="meta-item">
                                    <div class="meta-label">Items</div>
                                    <div class="meta-value"><%# Eval("TotalItems") %></div>
                                </div>
                                <div class="meta-item">
                                    <div class="meta-label">Mint Price</div>
                                    <div class="meta-value gold"><%# string.Format("{0:0.##}", Eval("MintPrice")) %> PNC</div>
                                </div>
                                <div class="meta-item">
                                    <div class="meta-label">Available</div>
                                    <div class="meta-value accent"><%# Eval("AvailableItems") %></div>
                                </div>
                                <div class="meta-item">
                                    <div class="meta-label">Chain</div>
                                    <div class="meta-value"><%# Eval("Blockchain") ?? "BSC" %></div>
                                </div>
                            </div>
                            <a href='<%# ResolveUrl("~/Web/User/MintNFT.aspx?action=mint&collectionId=" + Eval("CollectionId")) %>' class="collection-btn">
                                <i class="fas fa-hammer me-1"></i> Mint Now
                            </a>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnlNoCollections" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-layer-group"></i>
                <h4>No Collections Available</h4>
                <p>Check back soon for new NFT collections.</p>
            </div>
        </asp:Panel>
    </div>

    <!-- =========================================
         MINT NFT TAB
         ========================================= -->
    <div id="tab-mint" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <div class="mint-container">
            <!-- Preview -->
            <div class="mint-preview">
                <div class="preview-image" id="mintPreviewImage">
                    <i class="fas fa-image"></i>
                </div>
                <h3 class="preview-title" id="previewTitle">Select a Collection</h3>
                <p class="preview-description" id="previewDescription">
                    Choose a collection from the dropdown to preview the NFT before minting.
                </p>
                <div class="collection-meta" style="border-top: 1px solid var(--glass-border); padding-top: 16px;">
                    <div class="meta-item">
                        <div class="meta-label">Collection</div>
                        <div class="meta-value" id="previewCollection">—</div>
                    </div>
                    <div class="meta-item">
                        <div class="meta-label">Supply</div>
                        <div class="meta-value accent" id="previewSupply">—</div>
                    </div>
                </div>
            </div>

            <!-- Mint Form -->
            <div class="mint-form-card">
                <h3 class="form-section-title">
                    <i class="fas fa-hammer"></i> Mint Your NFT
                </h3>

                <asp:Panel ID="pnlMintError" runat="server" Visible="false">
                    <div class="alert-box error">
                        <i class="fas fa-exclamation-circle"></i>
                        <asp:Literal ID="litMintError" runat="server"></asp:Literal>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlMintSuccess" runat="server" Visible="false">
                    <div class="alert-box success">
                        <i class="fas fa-check-circle"></i>
                        <asp:Literal ID="litMintSuccess" runat="server"></asp:Literal>
                    </div>
                </asp:Panel>

                <div class="form-group">
                    <label>Select Collection <span class="required">*</span></label>
                    <asp:DropDownList ID="ddlCollection" runat="server" OnSelectedIndexChanged="ddlCollection_SelectedIndexChanged" AutoPostBack="true">
                    </asp:DropDownList>
                </div>

                <div class="form-group">
                    <label>NFT Name <span class="required">*</span></label>
                    <asp:TextBox ID="txtNFTName" runat="server" placeholder="Enter a unique name for your NFT" MaxLength="100"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Description</label>
                    <asp:TextBox ID="txtNFTDescription" runat="server" TextMode="MultiLine" placeholder="Describe your NFT..." Rows="3"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Quantity <span class="required">*</span></label>
                    <asp:TextBox ID="txtQuantity" runat="server" TextMode="Number" Text="1" min="1" max="10" oninput="updateMintTotal()"></asp:TextBox>
                    <small class="text-muted">Maximum 10 per transaction</small>
                </div>

                <div class="form-group">
                    <label>Recipient Wallet Address</label>
                    <asp:TextBox ID="txtRecipientAddress" runat="server" placeholder="0x... (leave empty for your wallet)"></asp:TextBox>
                </div>

                <!-- Price Summary -->
                <div class="price-summary">
                    <div class="price-row">
                        <span>Mint Price</span>
                        <span class="value"><asp:Literal ID="litMintPrice" runat="server" Text="0.00"></asp:Literal> PNC</span>
                    </div>
                    <div class="price-row">
                        <span>Quantity</span>
                        <span class="value">× <asp:Literal ID="litQuantity" runat="server" Text="1"></asp:Literal></span>
                    </div>
                    <div class="price-row">
                        <span>Gas Fee</span>
                        <span class="value"><asp:Literal ID="litGasFee" runat="server" Text="0.50"></asp:Literal> PNC</span>
                    </div>
                    <div class="price-row total">
                        <span>Total</span>
                        <span class="value"><asp:Literal ID="litTotalPrice" runat="server" Text="0.00"></asp:Literal> PNC</span>
                    </div>
                </div>

                <div class="alert-box warning" style="margin-bottom: 20px;">
                    <i class="fas fa-info-circle"></i>
                    <div>
                        <strong class="text-white">Your Balance:</strong>
                        <span class="text-accent fw-bold"><asp:Literal ID="litUserBalance" runat="server" Text="0.00"></asp:Literal> PNC</span>
                    </div>
                </div>

                <asp:Button ID="btnMint" runat="server" Text="🔨 Mint NFT Now" CssClass="btn-mint" OnClick="btnMint_Click" OnClientClick="return confirmMint();" />
            </div>
        </div>
    </div>

    <!-- =========================================
         MY NFTS TAB
         ========================================= -->
    <div id="tab-mynfts" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <h4 class="text-white mb-3">
            <i class="fas fa-images text-accent me-2"></i>
            Your NFT Collection
        </h4>

        <div class="nft-gallery">
            <asp:Repeater ID="rptMyNFTs" runat="server">
                <ItemTemplate>
                    <div class="nft-item">
                        <div class="nft-item-image">
                            <%# GetNFTImage(Eval("ImageUrl"), Eval("NFTName")) %>
                        </div>
                        <div class="nft-item-content">
                            <div class="nft-item-name"><%# Eval("NFTName") %></div>
                            <div class="nft-item-collection"><%# Eval("CollectionName") %></div>
                            <span class="nft-item-id">#<%# Eval("TokenId") %></span>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnlNoNFTs" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-images"></i>
                <h4>No NFTs Yet</h4>
                <p>Start minting NFTs to build your collection.</p>
                <a href="#mint" onclick="switchTab('mint'); return false;" class="btn btn-primary-glow">
                    <i class="fas fa-hammer me-2"></i> Mint Your First NFT
                </a>
            </div>
        </asp:Panel>
    </div>

    <!-- =========================================
         HISTORY TAB
         ========================================= -->
    <div id="tab-history" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <h4 class="text-white mb-3">
            <i class="fas fa-history text-accent me-2"></i>
            Minting History
        </h4>

        <div class="history-table">
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>NFT</th>
                            <th>Collection</th>
                            <th>Token ID</th>
                            <th>Price</th>
                            <th>Status</th>
                            <th>TX Hash</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptHistory" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td class="text-muted"><%# Convert.ToDateTime(Eval("MintDate")).ToString("MMM dd, yyyy HH:mm") %></td>
                                    <td class="text-white"><%# Eval("NFTName") %></td>
                                    <td><%# Eval("CollectionName") %></td>
                                    <td><span class="nft-item-id">#<%# Eval("TokenId") %></span></td>
                                    <td class="text-accent fw-bold"><%# string.Format("{0:0.##}", Eval("Price")) %> PNC</td>
                                    <td>
                                        <span class='status-badge <%# GetStatusClass(Eval("Status")) %>'>
                                            <%# Eval("StatusName") %>
                                        </span>
                                    </td>
                                    <td>
                                        <small class="text-secondary" style="font-family: monospace;">
                                            <%# GetTxHashShort(Eval("TxHash")) %>
                                        </small>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>

        <asp:Panel ID="pnlNoHistory" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-history"></i>
                <h4>No Minting History</h4>
                <p>Your NFT minting transactions will appear here.</p>
            </div>
        </asp:Panel>
    </div>

    <!-- Hidden Fields -->
    <asp:HiddenField ID="hfActiveTab" runat="server" Value="collections" />
    <asp:HiddenField ID="hfMintPrice" runat="server" Value="0" />
    <asp:HiddenField ID="hfGasFee" runat="server" Value="0.5" />

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        // Tab switching
        function switchTab(tabName) {
            var tabs = document.querySelectorAll('.nft-tab');
            var contents = document.querySelectorAll('.tab-content');
            var activeTabInput = document.getElementById('<%= hfActiveTab.ClientID %>');

            tabs.forEach(function(t) { t.classList.remove('active'); });
            contents.forEach(function(c) { c.style.display = 'none'; });

            var targetTab = document.querySelector('[data-tab="' + tabName + '"]');
            var targetContent = document.getElementById('tab-' + tabName);

            if (targetTab) targetTab.classList.add('active');
            if (targetContent) targetContent.style.display = 'block';
            if (activeTabInput) activeTabInput.value = tabName;

            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        document.addEventListener('DOMContentLoaded', function() {
            var tabs = document.querySelectorAll('.nft-tab');
            tabs.forEach(function(tab) {
                tab.addEventListener('click', function(e) {
                    e.preventDefault();
                    switchTab(this.getAttribute('data-tab'));
                });
            });

            // Check URL for action
            var urlParams = new URLSearchParams(window.location.search);
            var action = urlParams.get('action');
            if (action === 'mint') {
                switchTab('mint');
            }
        });

        // Update mint total
        function updateMintTotal() {
            var price = parseFloat('<%= MintPrice %>') || 0;
            var gas = parseFloat('<%= GasFee %>') || 0.5;
            var qty = parseInt(document.getElementById('<%= txtQuantity.ClientID %>').value) || 1;
            
            if (qty < 1) qty = 1;
            if (qty > 10) qty = 10;
            
            var total = (price * qty) + gas;
            
            document.getElementById('<%= litQuantity.ClientID %>').innerText = qty;
            document.getElementById('<%= litTotalPrice.ClientID %>').innerText = total.toFixed(2);
        }

        // Confirm mint
        function confirmMint() {
            var name = document.getElementById('<%= txtNFTName.ClientID %>').value.trim();
            if (!name) {
                alert('Please enter a name for your NFT');
                return false;
            }
            return confirm('Are you sure you want to mint this NFT? This action cannot be undone.');
        }
    </script>
</asp:Content>