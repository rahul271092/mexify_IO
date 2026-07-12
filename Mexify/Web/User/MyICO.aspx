<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="MyICO.aspx.cs" Inherits="Mexify.Web.User.MyICO" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>


        .user-main{
            width:85vw;
        }

        .ico-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            flex-wrap: wrap;
            gap: 16px;
            width: 100%;
        }
        .ico-header h2 { color: var(--text-white); margin: 0; font-size: 1.8rem; }

        .ico-tabs {
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
        .ico-tab {
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
        .ico-tab.active {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: var(--text-white);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }
        .ico-tab:hover:not(.active) {
            background: rgba(255, 255, 255, 0.05);
            color: var(--text-white);
        }

        .tab-content {
            width: 100% !important;
            max-width: 100% !important;
            box-sizing: border-box;
        }

        .ico-hero {
            background: linear-gradient(135deg, rgba(123, 44, 191, 0.25), rgba(255, 215, 0, 0.1));
            border: 1px solid rgba(157, 78, 221, 0.3);
            border-radius: var(--radius-xl);
            padding: 40px;
            position: relative;
            overflow: hidden;
            margin-bottom: 32px;
            width: 100%;
            box-sizing: border-box;
        }
        .ico-hero::before {
            content: '';
            position: absolute;
            top: -50%; right: -10%;
            width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(255, 215, 0, 0.2) 0%, transparent 70%);
            animation: float 15s ease-in-out infinite;
        }
        @keyframes float {
            0%,100%{transform:translate(0,0) scale(1)}
            50%{transform:translate(20px,-20px) scale(1.1)}
        }

        .ico-title {
            font-size: 2rem;
            font-weight: 800;
            color: var(--text-white);
            margin-bottom: 8px;
        }
        .ico-subtitle {
            color: var(--text-gray);
            font-size: 1rem;
            margin-bottom: 24px;
        }

        .ico-stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 16px;
            margin-bottom: 24px;
        }
        .ico-stat-card {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 20px;
            text-align: center;
            transition: all 0.3s ease;
        }
        .ico-stat-card:hover {
            border-color: var(--accent);
            transform: translateY(-3px);
        }
        .ico-stat-label {
            color: var(--text-muted);
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 8px;
        }
        .ico-stat-value {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--text-white);
        }
        .ico-stat-value.accent { color: var(--accent); }
        .ico-stat-value.gold { color: var(--gold); }

        .progress-section {
            background: rgba(0,0,0,0.2);
            border-radius: 12px;
            padding: 20px;
            margin-top: 20px;
        }
        .progress-bar-ico {
            height: 12px;
            background: rgba(255,255,255,0.05);
            border-radius: 50px;
            overflow: hidden;
            margin: 12px 0;
        }
        .progress-fill-ico {
            height: 100%;
            background: linear-gradient(90deg, var(--accent), var(--gold));
            border-radius: 50px;
            transition: width 1s ease;
        }

        .purchase-card {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 32px;
            margin-bottom: 24px;
        }
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
        .form-group input {
            width: 100%;
            padding: 12px 14px;
            background: rgba(255,255,255,0.03);
            border: 1px solid var(--glass-border);
            border-radius: 10px;
            color: var(--text-white);
            font-size: 0.92rem;
            box-sizing: border-box;
        }
        .form-group input:focus {
            outline: none;
            border-color: var(--accent);
            background: rgba(157, 78, 221, 0.03);
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

        .btn-ico {
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
        }
        .btn-ico:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(157, 78, 221, 0.5);
        }
        .btn-ico:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .tier-table {
            width: 100%;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            overflow: hidden;
        }
        .tier-table table {
            width: 100%;
            border-collapse: collapse;
        }
        .tier-table th {
            background: rgba(139, 92, 246, 0.1);
            padding: 14px 16px;
            color: var(--text-white);
            font-weight: 600;
            font-size: 0.85rem;
            text-align: left;
            text-transform: uppercase;
        }
        .tier-table td {
            padding: 14px 16px;
            border-bottom: 1px solid var(--glass-border);
            color: var(--text-gray);
        }
        .tier-table tr:last-child td { border-bottom: none; }
        .tier-table tr.current-tier {
            background: rgba(139, 92, 246, 0.08);
            border-left: 4px solid #8B5CF6;
        }

        .tier-badge {
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 700;
            display: inline-block;
        }

        .status-badge {
            padding: 3px 10px;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
            text-transform: uppercase;
            display: inline-block;
        }
        .status-active { background: rgba(0, 255, 178, 0.15); color: var(--accent); }
        .status-locked { background: rgba(255, 59, 92, 0.15); color: #ff3b5c; }
        .status-completed { background: rgba(0, 255, 178, 0.15); color: var(--accent); }

        .chart-card {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 24px;
            margin-bottom: 24px;
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

        .commission-item {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 14px;
            background: rgba(255,255,255,0.02);
            border-radius: 10px;
            margin-bottom: 10px;
            flex-wrap: wrap;
        }
        .commission-icon {
            width: 44px; height: 44px;
            border-radius: 10px;
            background: rgba(139, 92, 246, 0.15);
            color: #8B5CF6;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            flex-shrink: 0;
        }
        .commission-info { flex: 1; min-width: 150px; }
        .commission-amount {
            color: var(--accent);
            font-weight: 700;
            font-size: 1.1rem;
            white-space: nowrap;
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
        .alert-box.warning { background: rgba(255, 215, 0, 0.1); border: 1px solid rgba(255, 215, 0, 0.3); color: var(--gold); }

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

        @media (max-width: 768px) {
            .ico-header { flex-direction: column; align-items: flex-start; }
            .ico-tabs { width: 100%; overflow-x: auto; flex-wrap: nowrap; }
            .ico-tab { flex: 0 0 auto; padding: 10px 16px; font-size: 0.8rem; }
            .ico-stats-grid { grid-template-columns: repeat(2, 1fr); }
            .tier-table table { font-size: 0.8rem; }
            .tier-table th, .tier-table td { padding: 10px 8px; }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Header -->
    <div class="ico-header" data-aos="fade-up">
        <div>
            <h2><i class="fas fa-rocket me-2" style="color: var(--gold);"></i>PNC Token ICO</h2>
            <p class="text-gray mb-0">Initial Coin Offering - 111,111,111 PNC Total Supply</p>
        </div>
    </div>

    <!-- Messages -->
    <asp:Panel ID="pnlError" runat="server" Visible="false">
        <div class="alert-box error"><i class="fas fa-exclamation-circle"></i><asp:Literal ID="litError" runat="server"></asp:Literal></div>
    </asp:Panel>
    <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
        <div class="alert-box success"><i class="fas fa-check-circle"></i><asp:Literal ID="litSuccess" runat="server"></asp:Literal></div>
    </asp:Panel>

    <!-- Tabs -->
    <div class="ico-tabs" data-aos="fade-up">
        <button type="button" class="ico-tab active" data-tab="overview">
            <i class="fas fa-info-circle me-1"></i> Overview
        </button>
        <button type="button" class="ico-tab" data-tab="purchase">
            <i class="fas fa-shopping-cart me-1"></i> Buy Tokens
        </button>
        <button type="button" class="ico-tab" data-tab="commissions">
            <i class="fas fa-layer-group me-1"></i> 15-Level Commissions
        </button>
        <button type="button" class="ico-tab" data-tab="mystats">
            <i class="fas fa-chart-line me-1"></i> My Stats
        </button>
    </div>

    <!-- =========================================
         OVERVIEW TAB
         ========================================= -->
    <div id="tab-overview" class="tab-content" data-aos="fade-up">
        
        <asp:Repeater ID="rptICOProjects" runat="server">
            <ItemTemplate>
                <div class="ico-hero">
                    <div class="position-relative" style="z-index: 2;">
                        <div class="ico-title"><%# Eval("ProjectName") %></div>
                        <div class="ico-subtitle"><%# Eval("Description") %></div>

                        <div class="ico-stats-grid">
                            <div class="ico-stat-card">
                                <div class="ico-stat-label">Total Supply</div>
                                <div class="ico-stat-value accent">
                                    <%# string.Format("{0:N0}", Eval("TotalSupply")) %>
                                </div>
                                <small class="text-muted"><%# Eval("TokenSymbol") %></small>
                            </div>
                            <div class="ico-stat-card">
                                <div class="ico-stat-label">Tokens Sold</div>
                                <div class="ico-stat-value gold">
                                    <%# string.Format("{0:N0}", Eval("TokensSold")) %>
                                </div>
                                <small class="text-muted"><%# Eval("TokenSymbol") %></small>
                            </div>
                            <div class="ico-stat-card">
                                <div class="ico-stat-label">Price per Token</div>
                                <div class="ico-stat-value">
                                    $<%# string.Format("{0:0.00}", Eval("PricePerToken")) %>
                                </div>
                                <small class="text-muted"><%# Eval("CurrencyCode") %></small>
                            </div>
                            <div class="ico-stat-card">
                                <div class="ico-stat-label">Ends In</div>
                                <div class="ico-stat-value accent">
                                    <%# GetDaysRemaining(Eval("EndDate")) %>
                                </div>
                                <small class="text-muted">Days</small>
                            </div>
                        </div>

                        <div class="progress-section">
                            <div class="d-flex justify-content-between">
                                <span class="text-muted">ICO Progress</span>
          <%--                      <span class="text-accent fw-bold"><%# string.Format("{0:0.00}", Eval("ProgressPercent")) %>%</span>
          --%>

                            </div>
                            <div class="progress-bar-ico">
                             <%--   <div class="progress-fill-ico" style='width: '<%# Eval("ProgressPercent") %>'%;'></div>--%>
                            </div>
                            <div class="d-flex justify-content-between">
                                <small class="text-muted"><%# string.Format("{0:N0}", Eval("TokensSold")) %> sold</small>
                                <small class="text-muted"><%# string.Format("{0:N0}", Eval("TokensRemaining")) %> remaining</small>
                            </div>
                        </div>

                        <div class="mt-4">
                            <button type="button" class="btn-ico" onclick="switchTab('purchase')">
                                <i class="fas fa-shopping-cart me-2"></i> Buy PNC Tokens Now
                            </button>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoICO" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-rocket"></i>
                <h4>No Active ICO</h4>
                <p>There are no active ICO projects at the moment.</p>
            </div>
        </asp:Panel>
    </div>

    <!-- =========================================
         PURCHASE TAB
         ========================================= -->
    <div id="tab-purchase" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <div class="row g-4">
            <div class="col-lg-7">
                <div class="purchase-card">
                    <h3 class="text-white mb-4">
                        <i class="fas fa-shopping-cart me-2" style="color: var(--accent);"></i>
                        Buy PNC Tokens
                    </h3>

                    <div class="alert-box warning">
                        <i class="fas fa-info-circle"></i>
                        <div>
                            <strong class="text-white">15-Level Referral Rewards:</strong> Earn up to 190% in commissions across 15 levels when your referrals buy tokens!
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Amount to Invest (USDT) <span class="required" style="color: #ff3b5c;">*</span></label>
                        <asp:TextBox ID="txtAmount" runat="server" TextMode="Number" placeholder="Enter amount in USDT" step="0.01" min="10" oninput="calculateTokens()"></asp:TextBox>
                        <small class="text-muted">Minimum: 10 USDT</small>
                    </div>

                    <div class="price-summary">
                        <div class="price-row">
                            <span>Price per PNC</span>
                            <span class="value">$<asp:Literal ID="litPricePerToken" runat="server" Text="0.10"></asp:Literal></span>
                        </div>
                        <div class="price-row">
                            <span>You'll Receive</span>
                            <span class="value"><asp:Literal ID="litTokensToReceive" runat="server" Text="0"></asp:Literal> PNC</span>
                        </div>
                        <div class="price-row total">
                            <span>Total Investment</span>
                            <span class="value"><asp:Literal ID="litTotalInvestment" runat="server" Text="0.00"></asp:Literal> USDT</span>
                        </div>
                    </div>

                    <div class="alert-box info" style="background: rgba(0, 212, 255, 0.1); border: 1px solid rgba(0, 212, 255, 0.3); color: var(--secondary);">
                        <i class="fas fa-wallet"></i>
                        <div>
                            <strong class="text-white">Your Balance:</strong>
                            <span class="text-accent fw-bold"><asp:Literal ID="litUserBalance" runat="server" Text="0.00"></asp:Literal> USDT</span>
                        </div>
                    </div>

                    <asp:Button ID="btnPurchase" runat="server" Text="🚀 Buy PNC Tokens" CssClass="btn-ico" OnClick="btnPurchase_Click" OnClientClick="return confirmPurchase();" />
                </div>
            </div>

            <div class="col-lg-5">
                <div class="chart-card">
                    <div class="chart-header">
                        <h5 class="chart-title">
                            <i class="fas fa-gift text-gold me-2"></i>
                            15-Level Commission Structure
                        </h5>
                    </div>
                    <div class="table-responsive">
                        <table class="tier-table" style="background: transparent; border: none;">
                            <thead>
                                <tr>
                                    <th>Level</th>
                                    <th>Commission</th>
                                    <th>Directs</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptTiers" runat="server">
                                    <ItemTemplate>
                                        <tr class='<%# Convert.ToBoolean(Eval("IsQualified")) ? "current-tier" : "" %>'>
                                            <td>
                                                <span class="tier-badge" style="background: rgba(139, 92, 246, 0.2); color: #8B5CF6;">
                                                    L<%# Eval("Level") %>
                                                </span>
                                            </td>
                                            <td class="text-white fw-bold"><%# string.Format("{0:0.##}", Eval("CommissionPercent")) %>%</td>
                                            <td><%# Eval("RequiredDirects") %></td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>
                    <div class="mt-3 text-center">
                        <small class="text-muted">Total Distribution: <strong class="text-gold">190%</strong></small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- =========================================
         COMMISSIONS TAB
         ========================================= -->
    <div id="tab-commissions" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <div class="chart-card">
            <div class="chart-header">
                <h5 class="chart-title">
                    <i class="fas fa-layer-group" style="color: #8B5CF6;"></i>
                    15-Level Commission Structure (190% Total)
                </h5>
                <div class="text-muted small">
                    <i class="fas fa-info-circle"></i> Level N requires N direct referrals
                </div>
            </div>
            
            <div class="table-responsive">
                <table class="tier-table">
                    <thead>
                        <tr>
                            <th>Level</th>
                            <th>Commission %</th>
                            <th>Directs Required</th>
                            <th>Your Directs</th>
                            <th>Status</th>
                            <th>Times Earned</th>
                            <th>Total Earned</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptCommissionLevels" runat="server">
                            <ItemTemplate>
                                <tr class='<%# Convert.ToBoolean(Eval("IsQualified")) ? "current-tier" : "" %>'>
                                    <td>
                                        <span class="tier-badge" style="background: rgba(139, 92, 246, 0.2); color: #8B5CF6;">
                                            Level <%# Eval("Level") %>
                                        </span>
                                    </td>
                                    <td class="text-white fw-bold"><%# string.Format("{0:0.##}", Eval("CommissionPercent")) %>%</td>
                                    <td><%# Eval("RequiredDirects") %> Directs</td>
                                    <td class="text-accent"><%# Eval("CurrentDirects") %></td>
                                    <td>
                                        <%# Convert.ToBoolean(Eval("IsQualified")) 
                                            ? "<span class='status-badge status-active'><i class='fas fa-check'></i> Qualified</span>" 
                                            : "<span class='status-badge status-locked'><i class='fas fa-lock'></i> Locked</span>" %>
                                    </td>
                                    <td><%# Eval("TimesEarned") %></td>
                                    <td class="text-gold fw-bold">$<%# string.Format("{0:0.00}", Eval("LevelTotal")) %></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Recent Commissions -->
        <div class="chart-card">
            <div class="chart-header">
                <h5 class="chart-title">
                    <i class="fas fa-history" style="color: var(--accent);"></i>
                    Recent Commission Earnings
                </h5>
            </div>
            
            <asp:Repeater ID="rptCommissionHistory" runat="server">
                <ItemTemplate>
                    <div class="commission-item">
                        <div class="commission-icon">
                            L<%# Eval("Level") %>
                        </div>
                        <div class="commission-info">
                            <div class="text-white fw-bold">
                                <%# Eval("FromUserName") %> 
                                <small class="text-muted">invested $<%# string.Format("{0:0.00}", Eval("PurchaseAmount")) %></small>
                            </div>
                            <div class="text-muted small">
                                <%# Convert.ToDateTime(Eval("CreatedDate")).ToString("MMM dd, yyyy hh:mm tt") %> · 
                                <%# string.Format("{0:0.##}", Eval("CommissionPercent")) %>% commission
                            </div>
                        </div>
                        <div class="commission-amount">
                            +$<%# string.Format("{0:0.00}", Eval("CommissionAmount")) %>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoCommissions" runat="server" Visible="false">
                <div class="empty-state">
                    <i class="fas fa-coins"></i>
                    <h4>No Commissions Yet</h4>
                    <p>When your referrals buy ICO tokens, you'll earn commissions across 15 levels.</p>
                </div>
            </asp:Panel>
        </div>
    </div>

    <!-- =========================================
         MY STATS TAB
         ========================================= -->
    <div id="tab-mystats" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <div class="ico-stats-grid mb-4">
            <div class="ico-stat-card">
                <div class="ico-stat-label">PNC Tokens Held</div>
                <div class="ico-stat-value accent">
                    <asp:Literal ID="litMyTokens" runat="server" Text="0"></asp:Literal>
                </div>
                <small class="text-muted">PNC</small>
            </div>
            <div class="ico-stat-card">
                <div class="ico-stat-label">Total Invested</div>
                <div class="ico-stat-value gold">
                    $<asp:Literal ID="litMyInvested" runat="server" Text="0.00"></asp:Literal>
                </div>
                <small class="text-muted">USDT</small>
            </div>
            <div class="ico-stat-card">
                <div class="ico-stat-label">Commission Earned</div>
                <div class="ico-stat-value accent">
                    $<asp:Literal ID="litMyCommission" runat="server" Text="0.00"></asp:Literal>
                </div>
                <small class="text-muted">USDT</small>
            </div>
            <div class="ico-stat-card">
                <div class="ico-stat-label">Direct Referrals</div>
                <div class="ico-stat-value">
                    <asp:Literal ID="litMyReferrals" runat="server" Text="0"></asp:Literal>
                </div>
                <small class="text-muted">Active users</small>
            </div>
            <div class="ico-stat-card">
                <div class="ico-stat-label">Total Purchases</div>
                <div class="ico-stat-value">
                    <asp:Literal ID="litMyPurchases" runat="server" Text="0"></asp:Literal>
                </div>
                <small class="text-muted">Transactions</small>
            </div>
            <div class="ico-stat-card">
                <div class="ico-stat-label">Team Size</div>
                <div class="ico-stat-value gold">
                    <asp:Literal ID="litMyDownlines" runat="server" Text="0"></asp:Literal>
                </div>
                <small class="text-muted">Unique investors</small>
            </div>
        </div>

        <!-- Purchase History -->
        <div class="chart-card">
            <div class="chart-header">
                <h5 class="chart-title">
                    <i class="fas fa-receipt text-accent me-2"></i>
                    My Purchase History
                </h5>
            </div>
            <div class="table-responsive">
                <table class="tier-table" style="background: transparent; border: none;">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Tokens</th>
                            <th>Amount</th>
                            <th>Price/Token</th>
                            <th>TX Hash</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptMyPurchases" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td class="text-muted"><%# Convert.ToDateTime(Eval("PurchaseDate")).ToString("MMM dd, yyyy HH:mm") %></td>
                                    <td class="text-accent fw-bold"><%# string.Format("{0:0.00}", Eval("TokensPurchased")) %> PNC</td>
                                    <td>$<%# string.Format("{0:0.00}", Eval("AmountPaid")) %></td>
                                    <td>$<%# string.Format("{0:0.00}", Eval("PricePerToken")) %></td>
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
    </div>

    <asp:HiddenField ID="hfActiveTab" runat="server" Value="overview" />
    <asp:HiddenField ID="hfICOId" runat="server" />
    <asp:HiddenField ID="hfPricePerToken" runat="server" Value="0.10" />

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        function switchTab(tabName) {
            var tabs = document.querySelectorAll('.ico-tab');
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
            var tabs = document.querySelectorAll('.ico-tab');
            tabs.forEach(function(tab) {
                tab.addEventListener('click', function(e) {
                    e.preventDefault();
                    switchTab(this.getAttribute('data-tab'));
                });
            });

            var savedTab = document.getElementById('<%= hfActiveTab.ClientID %>').value;
            if (savedTab && savedTab !== 'overview') {
                switchTab(savedTab);
            }
        });

        function calculateTokens() {
            var amount = parseFloat(document.getElementById('<%= txtAmount.ClientID %>').value) || 0;
            var price = parseFloat('<%= PricePerToken %>') || 0.10;
            var tokens = amount / price;

            document.getElementById('<%= litTokensToReceive.ClientID %>').innerText = tokens.toFixed(2);
            document.getElementById('<%= litTotalInvestment.ClientID %>').innerText = amount.toFixed(2);
        }

        function confirmPurchase() {
            var amount = parseFloat(document.getElementById('<%= txtAmount.ClientID %>').value) || 0;
            if (amount < 10) {
                alert('Minimum purchase is 10 USDT');
                return false;
            }
            return confirm('Are you sure you want to invest ' + amount.toFixed(2) + ' USDT in PNC tokens?');
        }
    </script>
</asp:Content>
