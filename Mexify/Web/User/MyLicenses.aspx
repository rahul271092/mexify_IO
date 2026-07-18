<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="MyLicenses.aspx.cs" Inherits="Mexify.Web.User.MyLicenses" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>

        .user-main{
            width:85vw;
        }

        .license-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            flex-wrap: wrap;
            gap: 16px;
            width: 100%;
        }
        .license-header h2 { color: var(--text-white); margin: 0; font-size: 1.8rem; }

        .license-tabs {
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
        .license-tab {
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
        .license-tab.active {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: var(--text-white);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }
        .license-tab:hover:not(.active) {
            background: rgba(255, 255, 255, 0.05);
            color: var(--text-white);
        }

        .tab-content {
            width: 100% !important;
            max-width: 100% !important;
            box-sizing: border-box;
        }

        /* License Cards */
        .license-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 24px;
            margin-bottom: 32px;
            width: 100%;
        }
        .license-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-xl);
            padding: 32px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }
        .license-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(157, 78, 221, 0.2);
        }
        .license-card.silver { border-color: #C0C0C0; }
        .license-card.gold { border-color: var(--gold); }
        .license-card.platinum { border-color: #E5E4E2; background: linear-gradient(135deg, rgba(229, 228, 226, 0.05), rgba(157, 78, 221, 0.05)); }
        
        .license-card.featured::before {
            content: 'MOST POPULAR';
            position: absolute;
            top: 16px; right: -30px;
            background: linear-gradient(135deg, var(--gold), #FFA500);
            color: #000;
            font-size: 0.65rem;
            font-weight: 800;
            padding: 4px 40px;
            transform: rotate(45deg);
            letter-spacing: 1px;
        }

        .license-icon {
            width: 64px; height: 64px;
            border-radius: 16px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.8rem;
            margin-bottom: 20px;
        }
        .license-icon.silver { background: linear-gradient(135deg, rgba(192, 192, 192, 0.2), rgba(192, 192, 192, 0.1)); color: #C0C0C0; border: 1px solid rgba(192, 192, 192, 0.3); }
        .license-icon.gold { background: linear-gradient(135deg, rgba(255, 215, 0, 0.2), rgba(255, 165, 0, 0.1)); color: var(--gold); border: 1px solid rgba(255, 215, 0, 0.3); }
        .license-icon.platinum { background: linear-gradient(135deg, rgba(229, 228, 226, 0.2), rgba(192, 192, 192, 0.1)); color: #E5E4E2; border: 1px solid rgba(229, 228, 226, 0.3); }

        .license-name {
            color: var(--text-white);
            font-size: 1.5rem;
            font-weight: 800;
            margin-bottom: 8px;
        }
        .license-price {
            font-size: 2.5rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--accent), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: 12px 0;
            line-height: 1;
        }
        .license-price small {
            font-size: 1rem;
            color: var(--text-gray);
            -webkit-text-fill-color: var(--text-gray);
        }
        .license-roi {
            display: inline-block;
            padding: 6px 14px;
            background: rgba(0, 255, 178, 0.15);
            border: 1px solid rgba(0, 255, 178, 0.3);
            border-radius: 50px;
            color: var(--accent);
            font-weight: 700;
            font-size: 0.9rem;
            margin-bottom: 20px;
        }
        .license-features {
            list-style: none;
            padding: 0;
            margin: 16px 0;
            flex: 1;
        }
        .license-features li {
            color: var(--text-gray);
            font-size: 0.85rem;
            padding: 8px 0;
            display: flex;
            align-items: center;
            gap: 10px;
            border-bottom: 1px solid var(--glass-border);
        }
        .license-features li:last-child { border-bottom: none; }
        .license-features li i { color: var(--accent); font-size: 0.9rem; }

        .license-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            padding: 16px 0;
            border-top: 1px solid var(--glass-border);
            margin: 16px 0;
        }
        .license-stat {
            text-align: center;
        }
        .license-stat-label {
            color: var(--text-muted);
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }
        .license-stat-value {
            color: var(--text-white);
            font-weight: 700;
            font-size: 1rem;
        }
        .license-stat-value.accent { color: var(--accent); }
        .license-stat-value.gold { color: var(--gold); }

        .btn-license {
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
            margin-top: auto;
        }
        .btn-license:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(157, 78, 221, 0.5);
        }
        .btn-license:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        .btn-license.silver { background: linear-gradient(135deg, #C0C0C0, #A9A9A9); }
        .btn-license.gold { background: linear-gradient(135deg, var(--gold), #FFA500); color: #000; }
        .btn-license.platinum { background: linear-gradient(135deg, #E5E4E2, #C0C0C0); color: #000; }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-bottom: 32px;
            width: 100%;
        }
        .stat-card {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 24px;
            text-align: center;
            transition: all 0.3s ease;
        }
        .stat-card:hover {
            border-color: var(--accent);
            transform: translateY(-3px);
        }
        .stat-label {
            color: var(--text-muted);
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 8px;
        }
        .stat-value {
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--text-white);
            line-height: 1.2;
        }
        .stat-value.accent { color: var(--accent); }
        .stat-value.gold { color: var(--gold); }
        .stat-value.secondary { color: var(--secondary); }

        /* Chart Card */
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
            flex-wrap: wrap;
            gap: 12px;
        }
        .chart-title {
            color: var(--text-white);
            font-weight: 700;
            font-size: 1.1rem;
            margin: 0;
        }

        /* Tables */
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
            background: rgba(139, 92, 246, 0.2);
            color: #8B5CF6;
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
        .status-completed { background: rgba(255, 215, 0, 0.15); color: var(--gold); }

        /* Commission Items */
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

        /* License Cards (User's) */
        .my-license-card {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 24px;
            margin-bottom: 16px;
            position: relative;
            overflow: hidden;
        }
        .my-license-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0;
            width: 4px; height: 100%;
            background: linear-gradient(180deg, var(--accent), var(--secondary));
        }
        .my-license-card.silver::before { background: linear-gradient(180deg, #C0C0C0, #A9A9A9); }
        .my-license-card.gold::before { background: linear-gradient(180deg, var(--gold), #FFA500); }
        .my-license-card.platinum::before { background: linear-gradient(180deg, #E5E4E2, #C0C0C0); }

        .license-header-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 16px;
            flex-wrap: wrap;
            gap: 12px;
        }
        .license-info { display: flex; align-items: center; gap: 14px; }
        .license-icon-small {
            width: 48px; height: 48px;
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.3rem;
            flex-shrink: 0;
        }

        .progress-bar-license {
            height: 6px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50px;
            overflow: hidden;
            margin: 16px 0 8px;
        }
        .progress-fill-license {
            height: 100%;
            background: linear-gradient(90deg, var(--accent), var(--secondary));
            border-radius: 50px;
            transition: width 1s ease;
        }

        /* Alert Boxes */
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
        .alert-box.info { background: rgba(0, 212, 255, 0.1); border: 1px solid rgba(0, 212, 255, 0.3); color: var(--secondary); }

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
            .license-header { flex-direction: column; align-items: flex-start; }
            .license-tabs { width: 100%; overflow-x: auto; flex-wrap: nowrap; }
            .license-tab { flex: 0 0 auto; padding: 10px 16px; font-size: 0.8rem; }
            .license-grid { grid-template-columns: 1fr; }
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Header -->
    <div class="license-header" data-aos="fade-up">
        <div>
            <h2><i class="fas fa-crown me-2" style="color: var(--gold);"></i>Royalty Partner Licenses</h2>
            <p class="text-gray mb-0">Become a Royalty Partner and earn daily assured returns + 10-level direct income</p>
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
    <div class="license-tabs" data-aos="fade-up">
        <button type="button" class="license-tab active" data-tab="packages">
            <i class="fas fa-gem me-1"></i> Packages
        </button>
        <button type="button" class="license-tab" data-tab="mylicenses">
            <i class="fas fa-id-card me-1"></i> My Licenses
            (<asp:Literal ID="litMyLicenseCount" runat="server" Text="0"></asp:Literal>)
        </button>
        <button type="button" class="license-tab" data-tab="earnings">
            <i class="fas fa-coins me-1"></i> Earnings
        </button>
        <button type="button" class="license-tab" data-tab="commissions">
            <i class="fas fa-layer-group me-1"></i> 10-Level Income
        </button>
    </div>

    <!-- =========================================
         PACKAGES TAB
         ========================================= -->
    <div id="tab-packages" class="tab-content" data-aos="fade-up">
        
        <div class="alert-box info">
            <i class="fas fa-info-circle"></i>
            <div>
                <strong class="text-white">Become a Royalty Partner:</strong> Purchase any license to unlock daily assured returns, 10-level direct income, and exclusive royalty incentives. Total 10-level distribution: <strong class="text-accent">25%</strong>
            </div>
        </div>

        <div class="license-grid">
            <asp:Repeater ID="rptPackages" runat="server">
                <ItemTemplate>
                    <div class='license-card <%# Eval("PackageName").ToString().ToLower() %> <%# Eval("PackageName").ToString() == "Gold" ? "featured" : "" %>'>
                        <div class='license-icon <%# Eval("PackageName").ToString().ToLower() %>'>
                            <%# GetLicenseIcon(Eval("PackageName")) %>
                        </div>
                        <h3 class="license-name"><%# Eval("PackageName") %> License</h3>
                        <div class="license-price">
                            $<%# string.Format("{0:0.00}", Eval("Price")) %>
                            <small>USDT</small>
                        </div>
                        <div class="license-roi">
                            <i class="fas fa-chart-line me-1"></i>
                            <%# string.Format("{0:0.##}", Eval("DailyROI")) %>% Monthly Return
                        </div>

                        <ul class="license-features">
                            <li><i class="fas fa-check"></i> Royalty Partner Status</li>
                            <li><i class="fas fa-check"></i> 10-Level Direct Income (25%)</li>
                            <li><i class="fas fa-check"></i> <%# string.Format("{0:0.##}", Eval("DailyROI")) %>% Monthly Assured Returns</li>
                            <li><i class="fas fa-check"></i> <%# Eval("DurationDays") %> Days Duration</li>
                            <li><i class="fas fa-check"></i> Monthly Royalty Payouts</li>
                            <li><i class="fas fa-check"></i> Exclusive Partner Benefits</li>
                        </ul>

                        <div class="license-stats">
                            <div class="license-stat">
                                <div class="license-stat-label">Expected Return</div>
                                <div class="license-stat-value accent">$<%# string.Format("{0:0.00}", Eval("TotalReturn")) %></div>
                            </div>
                            <div class="license-stat">
                                <div class="license-stat-label">Active Partners</div>
                                <div class="license-stat-value gold"><%# Eval("ActivePartners") %></div>
                            </div>
                        </div>

                        <button type="button" class='btn-license <%# Eval("PackageName").ToString().ToLower() %>' 
                                onclick='purchaseLicense(<%# Eval("PackageId") %>, "<%# Eval("PackageName") %>", <%# Eval("Price") %>)'>
                            <i class="fas fa-crown me-2"></i> Become <%# Eval("PackageName") %> Partner
                        </button>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnlNoPackages" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-gem"></i>
                <h4>No Packages Available</h4>
                <p>Check back soon for new license packages.</p>
            </div>
        </asp:Panel>
    </div>

    <!-- =========================================
         MY LICENSES TAB
         ========================================= -->
    <div id="tab-mylicenses" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <asp:Repeater ID="rptMyLicenses" runat="server">
            <ItemTemplate>
                <div class='my-license-card <%# Eval("PackageName").ToString().ToLower() %>'>
                    <div class="license-header-row">
                        <div class="license-info">
                            <div class='license-icon-small <%# Eval("PackageName").ToString().ToLower() %>' 
                                 style='background: linear-gradient(135deg, <%# GetLicenseColor(Eval("PackageName")) %>);'>
                                <%# GetLicenseIcon(Eval("PackageName")) %>
                            </div>
                            <div>
                                <div class="text-white fw-bold fs-5"><%# Eval("PackageName") %> License</div>
                                <div class="text-muted small">
                                    License #<%# Eval("LicenseId") %> · 
                                    Started <%# Convert.ToDateTime(Eval("StartDate")).ToString("MMM dd, yyyy") %>
                                </div>
                            </div>
                        </div>
                        <div class="text-end">
                            <div class="text-accent fw-bold fs-5">$<%# string.Format("{0:0.00}", Eval("PurchasePrice")) %></div>
                            <span class='status-badge <%# Eval("Status").ToString() == "1" ? "status-active" : "status-completed" %>'>
                                <%# Eval("Status").ToString() == "1" ? "● Active" : "Completed" %>
                            </span>
                        </div>
                    </div>

                    <div class="license-stats">
                        <div class="license-stat">
                            <div class="license-stat-label">Daily ROI</div>
                            <div class="license-stat-value accent"><%# string.Format("{0:0.##}", Eval("DailyROI")) %>%</div>
                        </div>
                        <div class="license-stat">
                            <div class="license-stat-label">Total Return</div>
                            <div class="license-stat-value gold">$<%# string.Format("{0:0.00}", Eval("TotalReturn")) %></div>
                        </div>
                        <div class="license-stat">
                            <div class="license-stat-label">Earned So Far</div>
                            <div class="license-stat-value accent">$<%# string.Format("{0:0.00}", Eval("TotalEarned")) %></div>
                        </div>
                        <div class="license-stat">
                            <div class="license-stat-label">Progress</div>
                            <div class="license-stat-value"><%# Eval("ProgressPercent") %>%</div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mt-3">
                        <div>
                            <small class="text-muted">Expires on</small>
                            <div class="text-white fw-bold"><%# Convert.ToDateTime(Eval("EndDate")).ToString("MMMM dd, yyyy") %></div>
                        </div>
                        <div>
                            <small class="text-muted"><%# Eval("DaysElapsed") %> / <%# Eval("DurationDays") %> days</small>
                            <div class="text-accent fw-bold"><%# Eval("DaysRemaining") %> days remaining</div>
                        </div>
                    </div>

                    <div class="progress-bar-license">
                        <div class="progress-fill-license" style="width: <%# Eval("ProgressPercent") %>%;"></div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoLicenses" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-id-card"></i>
                <h4>No Active Licenses</h4>
                <p>Purchase a license to become a Royalty Partner and start earning daily returns.</p>
                <button type="button" class="btn-license" onclick="switchTab('packages')" style="max-width: 300px; margin: 0 auto;">
                    <i class="fas fa-gem me-2"></i> View Packages
                </button>
            </div>
        </asp:Panel>
    </div>

    <!-- =========================================
         EARNINGS TAB
         ========================================= -->
    <div id="tab-earnings" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-label">Total ROI Earned</div>
                <div class="stat-value accent">$<asp:Literal ID="litTotalROI" runat="server" Text="0.00"></asp:Literal></div>
                <small class="text-muted">USDT</small>
            </div>
            <div class="stat-card">
                <div class="stat-label">Today's ROI</div>
                <div class="stat-value gold">$<asp:Literal ID="litTodayROI" runat="server" Text="0.00"></asp:Literal></div>
                <small class="text-muted">USDT</small>
            </div>
            <div class="stat-card">
                <div class="stat-label">Daily Projection</div>
                <div class="stat-value secondary">$<asp:Literal ID="litDailyProjection" runat="server" Text="0.00"></asp:Literal></div>
                <small class="text-muted">USDT / day</small>
            </div>
            <div class="stat-card">
                <div class="stat-label">Direct Income</div>
                <div class="stat-value accent">$<asp:Literal ID="litDirectIncome" runat="server" Text="0.00"></asp:Literal></div>
                <small class="text-muted">USDT</small>
            </div>
        </div>

        <!-- Recent ROI -->
        <div class="chart-card">
            <div class="chart-header">
                <h5 class="chart-title">
                    <i class="fas fa-chart-line text-accent me-2"></i>
                    Recent Daily ROI Payments
                </h5>
            </div>
            <div class="table-responsive">
                <table class="tier-table" style="background: transparent; border: none;">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>License</th>
                            <th>ROI %</th>
                            <th>Amount</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptRecentROI" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td class="text-muted"><%# Convert.ToDateTime(Eval("EarnedDate")).ToString("MMM dd, yyyy HH:mm") %></td>
                                    <td class="text-white"><%# Eval("PackageName") %></td>
                                    <td class="text-accent"><%# string.Format("{0:0.##}", Eval("ROIPercent")) %>%</td>
                                    <td class="text-gold fw-bold">+$<%# string.Format("{0:0.00}", Eval("ReturnAmount")) %></td>
                                    <td><span class="status-badge status-active">Credited</span></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- =========================================
         10-LEVEL COMMISSIONS TAB
         ========================================= -->
    <div id="tab-commissions" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <div class="chart-card">
            <div class="chart-header">
                <h5 class="chart-title">
                    <i class="fas fa-layer-group" style="color: #8B5CF6;"></i>
                    10-Level Direct Income Structure (25% Total)
                </h5>
                <div class="text-muted small">
                    <i class="fas fa-info-circle"></i> Earn from every referral's license purchase
                </div>
            </div>
            
            <div class="table-responsive">
                <table class="tier-table">
                    <thead>
                        <tr>
                            <th>Level</th>
                            <th>Commission %</th>
                            <th>Times Earned</th>
                            <th>Total Earned</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptCommissionLevels" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <span class="tier-badge">
                                            Level <%# Eval("Level") %>
                                        </span>
                                    </td>
                                    <td class="text-white fw-bold"><%# string.Format("{0:0.##}", Eval("CommissionPercent")) %>%</td>
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
                    Recent Direct Income
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
                                <small class="text-muted">purchased $<%# string.Format("{0:0.00}", Eval("PurchaseAmount")) %> license</small>
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
                    <h4>No Direct Income Yet</h4>
                    <p>When your referrals purchase licenses, you'll earn direct income across 10 levels.</p>
                </div>
            </asp:Panel>
        </div>
    </div>

    <asp:HiddenField ID="hfActiveTab" runat="server" Value="packages" />

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        function switchTab(tabName) {
            var tabs = document.querySelectorAll('.license-tab');
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
            var tabs = document.querySelectorAll('.license-tab');
            tabs.forEach(function(tab) {
                tab.addEventListener('click', function(e) {
                    e.preventDefault();
                    switchTab(this.getAttribute('data-tab'));
                });
            });

            var savedTab = document.getElementById('<%= hfActiveTab.ClientID %>').value;
            if (savedTab && savedTab !== 'packages') {
                switchTab(savedTab);
            }
        });

        function purchaseLicense(packageId, packageName, price) {
            if (confirm('Are you sure you want to purchase the ' + packageName + ' License for $' + price.toFixed(2) + ' USDT?\n\nYou will become a Royalty Partner and start earning daily returns!')) {
                // Trigger server-side purchase
                __doPostBack('purchaseLicense', packageId);
            }
        }
    </script>
</asp:Content>