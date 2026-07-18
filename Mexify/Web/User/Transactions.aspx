<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="Transactions.aspx.cs" Inherits="Mexify.Web.User.Transactions" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>

        .user-main{
            width:85vw;
        }

        .trans-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            flex-wrap: wrap;
            gap: 16px;
        }
        .trans-header h2 { color: var(--text-white); margin: 0; font-size: 1.8rem; }

        .trans-tabs {
            display: flex;
            gap: 4px;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 50px;
            padding: 4px;
            margin-bottom: 28px;
            width: fit-content;
            flex-wrap: wrap;
        }
        .trans-tab {
            padding: 10px 20px;
            border-radius: 50px;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-gray);
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            background: transparent;
        }
        .trans-tab.active {
            background: linear-gradient(135deg, #6366F1, #4F46E5);
            color: #fff;
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3);
        }
        .trans-tab:hover:not(.active) {
            background: rgba(255, 255, 255, 0.05);
            color: var(--text-white);
        }

        .trans-summary {
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.15), rgba(79, 70, 229, 0.1));
            border: 1px solid rgba(99, 102, 241, 0.3);
            border-radius: var(--radius-xl);
            padding: 40px;
            position: relative;
            overflow: hidden;
            margin-bottom: 32px;
        }
        .trans-summary::before {
            content: '';
            position: absolute;
            top: -50%; right: -10%;
            width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(99, 102, 241, 0.15) 0%, transparent 70%);
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
            font-size: 2.5rem;
            font-weight: 800;
            color: var(--text-white);
            font-family: 'Space Grotesk', sans-serif;
            margin-bottom: 4px;
        }
        .summary-value small { font-size: 1rem; color: var(--text-gray); }

        .stat-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 20px;
            text-align: center;
            transition: all 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-3px);
            border-color: #6366F1;
        }
        .stat-card .value {
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--text-white);
            font-family: 'Space Grotesk', sans-serif;
        }
        .stat-card .label {
            font-size: 0.75rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-top: 4px;
        }

        .filter-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 24px;
            margin-bottom: 24px;
        }
        .filter-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            align-items: end;
        }
        .filter-group { display: flex; flex-direction: column; gap: 6px; }
        .filter-group label {
            font-size: 0.8rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
        }
        .filter-group select,
        .filter-group input {
            padding: 10px 14px;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--glass-border);
            border-radius: 8px;
            color: var(--text-white);
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }
        .filter-group select option { background: var(--bg-secondary); }
        .filter-group input:focus,
        .filter-group select:focus {
            outline: none;
            border-color: #6366F1;
            background: rgba(99, 102, 241, 0.05);
        }
        .filter-actions {
            display: flex;
            gap: 8px;
            align-items: end;
        }
        .btn-filter {
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .btn-filter.primary {
            background: linear-gradient(135deg, #6366F1, #4F46E5);
            color: #fff;
        }
        .btn-filter.primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(99, 102, 241, 0.4);
        }
        .btn-filter.secondary {
            background: rgba(255, 255, 255, 0.05);
            color: var(--text-gray);
            border: 1px solid var(--glass-border);
        }
        .btn-filter.secondary:hover {
            background: rgba(255, 255, 255, 0.1);
            color: var(--text-white);
        }
        .btn-filter.export {
            background: linear-gradient(135deg, var(--accent), #00D4FF);
            color: #000;
        }

        .transaction-table {
            width: 100%;
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            overflow: hidden;
        }
        .transaction-table table { width: 100%; color: var(--text-gray); border-collapse: collapse; }
        .transaction-table th {
            background: rgba(99, 102, 241, 0.08);
            padding: 14px 16px;
            color: var(--text-white);
            font-weight: 600;
            font-size: 0.8rem;
            text-align: left;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 1px solid var(--glass-border);
        }
        .transaction-table td {
            padding: 14px 16px;
            border-bottom: 1px solid var(--glass-border);
            font-size: 0.9rem;
            vertical-align: middle;
        }
        .transaction-table tr:last-child td { border-bottom: none; }
        .transaction-table tbody tr { transition: background 0.3s ease; }
        .transaction-table tbody tr:hover { background: rgba(99, 102, 241, 0.05); }

        .tx-type-icon {
            width: 36px; height: 36px;
            border-radius: 10px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
            margin-right: 10px;
            vertical-align: middle;
        }
        .tx-type-icon.deposit { background: rgba(0, 255, 178, 0.15); color: var(--accent); }
        .tx-type-icon.withdraw { background: rgba(255, 59, 92, 0.15); color: #ff3b5c; }
        .tx-type-icon.invest { background: rgba(99, 102, 241, 0.15); color: #6366F1; }
        .tx-type-icon.roi { background: rgba(0, 212, 255, 0.15); color: var(--secondary); }
        .tx-type-icon.staking { background: rgba(255, 215, 0, 0.15); color: var(--gold); }
        .tx-type-icon.mining { background: rgba(255, 165, 0, 0.15); color: #FFA500; }
        .tx-type-icon.referral { background: rgba(16, 185, 129, 0.15); color: #10B981; }
        .tx-type-icon.transfer { background: rgba(156, 39, 176, 0.15); color: #9C27B0; }
        .tx-type-icon.fee { background: rgba(107, 117, 141, 0.15); color: var(--text-muted); }

        .tx-type-name { font-weight: 600; color: var(--text-white); }
        .tx-type-sub { font-size: 0.75rem; color: var(--text-muted); display: block; margin-top: 2px; }

        .tx-amount { font-weight: 700; font-size: 0.95rem; }
        .tx-amount.positive { color: var(--accent); }
        .tx-amount.negative { color: #ff3b5c; }
        .tx-amount.neutral { color: var(--text-gray); }

        .tx-hash {
            font-family: 'Courier New', monospace;
            font-size: 0.75rem;
            color: var(--text-muted);
            max-width: 120px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            display: inline-block;
        }
        .tx-hash:hover { color: #6366F1; cursor: pointer; }

        .status-badge {
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-block;
        }
        .status-completed { background: rgba(0, 255, 178, 0.15); color: var(--accent); }
        .status-pending { background: rgba(255, 215, 0, 0.15); color: var(--gold); }
        .status-failed { background: rgba(255, 59, 92, 0.15); color: #ff3b5c; }
        .status-cancelled { background: rgba(107, 117, 141, 0.15); color: var(--text-muted); }

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
            flex-wrap: wrap;
            gap: 12px;
        }
        .chart-title {
            color: var(--text-white);
            font-weight: 700;
            font-size: 1.1rem;
            margin: 0;
        }

        .pagination {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
            flex-wrap: wrap;
            gap: 12px;
        }
        .pagination-info {
            color: var(--text-muted);
            font-size: 0.85rem;
        }
        .pagination-buttons {
            display: flex;
            gap: 4px;
        }
        .page-btn {
            padding: 8px 14px;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 8px;
            color: var(--text-gray);
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 0.85rem;
            font-weight: 600;
        }
        .page-btn:hover:not(:disabled) {
            background: rgba(99, 102, 241, 0.1);
            color: #6366F1;
            border-color: #6366F1;
        }
        .page-btn.active {
            background: linear-gradient(135deg, #6366F1, #4F46E5);
            color: #fff;
            border-color: transparent;
        }
        .page-btn:disabled {
            opacity: 0.4;
            cursor: not-allowed;
        }

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

        .quick-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 16px;
            margin-bottom: 24px;
        }
        .quick-stat-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-md);
            padding: 16px;
            display: flex;
            align-items: center;
            gap: 12px;
            transition: all 0.3s ease;
        }
        .quick-stat-card:hover {
            border-color: #6366F1;
            transform: translateY(-2px);
        }
        .quick-stat-icon {
            width: 44px; height: 44px;
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.1rem;
            flex-shrink: 0;
        }
        .quick-stat-icon.in { background: rgba(0, 255, 178, 0.15); color: var(--accent); }
        .quick-stat-icon.out { background: rgba(255, 59, 92, 0.15); color: #ff3b5c; }
        .quick-stat-icon.net { background: rgba(99, 102, 241, 0.15); color: #6366F1; }
        .quick-stat-icon.count { background: rgba(255, 215, 0, 0.15); color: var(--gold); }
        .quick-stat-info { flex: 1; min-width: 0; }
        .quick-stat-label { font-size: 0.7rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.5px; }
        .quick-stat-value { font-size: 1.1rem; font-weight: 700; color: var(--text-white); }

        .table-responsive { overflow-x: auto; }

        @media (max-width: 768px) {
            .summary-value { font-size: 1.8rem; }
            .filter-grid { grid-template-columns: 1fr; }
            .transaction-table { font-size: 0.85rem; }
            .transaction-table th, .transaction-table td { padding: 10px 12px; }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Header -->
    <div class="trans-header" data-aos="fade-up">
        <div>
            <h2>Transaction History</h2>
            <p class="text-gray mb-0">Complete record of all your financial activity</p>
        </div>
        <asp:Button ID="btnExportCSV" runat="server" Text="Export CSV" CssClass="btn-filter export" OnClick="btnExportCSV_Click" />
    </div>

    <!-- Tabs -->
    <div class="trans-tabs" data-aos="fade-up">
        <button class="trans-tab active" data-tab="all">
            <i class="fas fa-list me-1"></i> All Transactions
        </button>
        <button class="trans-tab" data-tab="deposits">
            <i class="fas fa-arrow-down me-1"></i> Deposits
        </button>
        <button class="trans-tab" data-tab="withdrawals">
            <i class="fas fa-arrow-up me-1"></i> Withdrawals
        </button>
        <button class="trans-tab" data-tab="earnings">
            <i class="fas fa-coins me-1"></i> Earnings
        </button>
        <button class="trans-tab" data-tab="investments">
            <i class="fas fa-chart-line me-1"></i> Investments
        </button>
    </div>

    <!-- ALL TRANSACTIONS TAB -->
    <div id="tab-all" class="tab-content" data-aos="fade-up">
        
        <!-- Summary Card -->
        <div class="trans-summary">
            <div class="row align-items-center position-relative" style="z-index: 2;">
                <div class="col-lg-6">
                    <div class="summary-label">Total Transaction Volume</div>
                    <div class="summary-value">
                        <asp:Literal ID="litTotalVolume" runat="server" Text="0.00"></asp:Literal>
                        <small> USDT</small>
                    </div>
                    <div style="color: var(--text-gray); font-size: 1.1rem;">
                        <asp:Literal ID="litTotalVolumeUSD" runat="server" Text="0.00" Visible="false"></asp:Literal> 
                    </div>
                </div>
                <div class="col-lg-6 mt-3 mt-lg-0">
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="stat-card">
                                <div class="value" style="color: #6366F1;">
                                    <asp:Literal ID="litTotalCount" runat="server" Text="0"></asp:Literal>
                                </div>
                                <div class="label">Total Transactions</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stat-card">
                                <div class="value" style="color: var(--accent);">
                                    <asp:Literal ID="litSuccessRate" runat="server" Text="0"></asp:Literal>%
                                </div>
                                <div class="label">Success Rate</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Stats -->
        <div class="quick-stats" data-aos="fade-up">
            <div class="quick-stat-card">
                <div class="quick-stat-icon in"><i class="fas fa-arrow-down"></i></div>
                <div class="quick-stat-info">
                    <div class="quick-stat-label">Total Inflow</div>
                    <div class="quick-stat-value">+<asp:Literal ID="litTotalInflow" runat="server" Text="0.00"></asp:Literal> USDT</div>
                </div>
            </div>
            <div class="quick-stat-card">
                <div class="quick-stat-icon out"><i class="fas fa-arrow-up"></i></div>
                <div class="quick-stat-info">
                    <div class="quick-stat-label">Total Outflow</div>
                    <div class="quick-stat-value">-<asp:Literal ID="litTotalOutflow" runat="server" Text="0.00"></asp:Literal> USDT</div>
                </div>
            </div>
            <div class="quick-stat-card">
                <div class="quick-stat-icon net"><i class="fas fa-balance-scale"></i></div>
                <div class="quick-stat-info">
                    <div class="quick-stat-label">Net Balance</div>
                    <div class="quick-stat-value"><asp:Literal ID="litNetBalance" runat="server" Text="0.00"></asp:Literal> USDT</div>
                </div>
            </div>
            <div class="quick-stat-card">
                <div class="quick-stat-icon count"><i class="fas fa-clock"></i></div>
                <div class="quick-stat-info">
                    <div class="quick-stat-label">Pending</div>
                    <div class="quick-stat-value"><asp:Literal ID="litPendingCount" runat="server" Text="0"></asp:Literal></div>
                </div>
            </div>
        </div>

        <!-- Charts Row -->
        <div class="row g-4 mb-4">
            <div class="col-lg-8" data-aos="fade-up">
                <div class="chart-card">
                    <div class="chart-header">
                        <h5 class="chart-title">Transaction Volume (Last 30 Days)</h5>
                    </div>
                    <div style="height: 300px;">
                        <canvas id="volumeChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-lg-4" data-aos="fade-up" data-aos-delay="100">
                <div class="chart-card h-100">
                    <div class="chart-header">
                        <h5 class="chart-title">By Type</h5>
                    </div>
                    <div style="height: 240px;">
                        <canvas id="typeChart"></canvas>
                    </div>
                    <div id="typeLegend" class="mt-3"></div>
                </div>
            </div>
        </div>

        <!-- Filters -->
        <div class="filter-card" data-aos="fade-up">
            <div class="filter-grid">
                <div class="filter-group">
                    <label>Search</label>
                    <asp:TextBox ID="txtSearch" runat="server" placeholder="Search by TX ID, hash, or address..." CssClass="filter-input"></asp:TextBox>
                </div>
                <div class="filter-group">
                    <label>Type</label>
                    <asp:DropDownList ID="ddlType" runat="server" CssClass="filter-select">
                        <asp:ListItem Value="" Text="All Types"></asp:ListItem>
                        <asp:ListItem Value="1" Text="Deposit"></asp:ListItem>
                        <asp:ListItem Value="2" Text="Withdrawal"></asp:ListItem>
                        <asp:ListItem Value="3" Text="Transfer"></asp:ListItem>
                        <asp:ListItem Value="4" Text="ROI Distribution"></asp:ListItem>
                        <asp:ListItem Value="5" Text="Investment"></asp:ListItem>
                        <asp:ListItem Value="6" Text="Staking Reward"></asp:ListItem>
                        <asp:ListItem Value="7" Text="Mining Reward"></asp:ListItem>
                        <asp:ListItem Value="8" Text="Referral Commission"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="filter-group">
                    <label>Status</label>
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="filter-select">
                        <asp:ListItem Value="" Text="All Status"></asp:ListItem>
                        <asp:ListItem Value="1" Text="Completed"></asp:ListItem>
                        <asp:ListItem Value="2" Text="Pending"></asp:ListItem>
                        <asp:ListItem Value="3" Text="Failed"></asp:ListItem>
                        <asp:ListItem Value="4" Text="Cancelled"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="filter-group">
                    <label>Currency</label>
                    <asp:DropDownList ID="ddlCurrency" runat="server" CssClass="filter-select">
                        <asp:ListItem Value="" Text="All Currencies"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="filter-group">
                    <label>From Date</label>
                    <asp:TextBox ID="txtDateFrom" runat="server" TextMode="Date" CssClass="filter-input"></asp:TextBox>
                </div>
                <div class="filter-group">
                    <label>To Date</label>
                    <asp:TextBox ID="txtDateTo" runat="server" TextMode="Date" CssClass="filter-input"></asp:TextBox>
                </div>
                <div class="filter-actions">
                    <asp:Button ID="btnApply" runat="server" Text="Apply" CssClass="btn-filter primary" OnClick="btnApply_Click" />
                    <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn-filter secondary" OnClick="btnReset_Click" />
                </div>
            </div>
        </div>

        <!-- Transaction Table -->
        <div class="transaction-table" data-aos="fade-up">
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Date & Time</th>
                            <th>Type</th>
                            <th>Amount</th>
                            <th>Fee</th>
                            <th>Net</th>
                            <th>Currency</th>
                            <th>Status</th>
                            <th>TX Hash</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptTransactions" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <div class="text-white" style="font-weight: 500;">
                                            <%# Convert.ToDateTime(Eval("CreatedDate")).ToString("MMM dd, yyyy") %>
                                        </div>
                                        <small class="text-muted">
                                            <%# Convert.ToDateTime(Eval("CreatedDate")).ToString("HH:mm:ss") %>
                                        </small>
                                    </td>
                                    <td>
                                        <span class='tx-type-icon <%# Eval("TypeClass") %>'>
                                            <i class='<%# Eval("Icon") %>'></i>
                                        </span>
                                        <span class="tx-type-name"><%# Eval("TypeName") %></span>
                                        <asp:Panel runat="server" Visible='<%# !string.IsNullOrEmpty(Eval("SubType").ToString()) %>'>
                                            <span class="tx-type-sub"><%# Eval("SubType") %></span>
                                        </asp:Panel>
                                    </td>
                                    <td>
                                        <span class='tx-amount <%# GetAmountClass(Eval("Amount")) %>'>
                                            <%# (Convert.ToDecimal(Eval("Amount")) >= 0 ? "+" : "") + string.Format("{0:0.########}", Eval("Amount")) %>
                                        </span>
                                    </td>
                                    <td class="text-muted">
                                        <%# string.Format("{0:0.########}", Eval("Fee")) %>
                                    </td>
                                    <td>
                                        <span class='tx-amount <%# GetAmountClass(Eval("NetAmount")) %>'>
                                            <%# (Convert.ToDecimal(Eval("NetAmount")) >= 0 ? "+" : "") + string.Format("{0:0.########}", Eval("NetAmount")) %>
                                        </span>
                                    </td>
                                    <td class="text-white fw-bold"><%# Eval("CurrencyCode") %></td>
                                    <td>
                                        <span class='status-badge <%# GetStatusClass(Eval("Status")) %>'>
                                            <%# Eval("StatusName") %>
                                        </span>
                                    </td>
                                    <td>
                                        <asp:Panel runat="server" Visible='<%# !string.IsNullOrEmpty(Eval("TxHash").ToString()) %>'>
                                            <span class="tx-hash" title='<%# Eval("TxHash") %>' onclick="copyHash(this)">
                                                <%# Eval("TxHash").ToString().Length > 12 ? Eval("TxHash").ToString().Substring(0, 12) + "..." : Eval("TxHash") %>
                                            </span>
                                        </asp:Panel>
                                        <asp:Panel runat="server" Visible='<%# string.IsNullOrEmpty(Eval("TxHash").ToString()) %>'>
                                            <span class="text-muted">—</span>
                                        </asp:Panel>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Pagination -->
        <div class="pagination" data-aos="fade-up">
            <div class="pagination-info">
                Showing <strong><asp:Literal ID="litShowingFrom" runat="server" Text="0"></asp:Literal></strong> to 
                <strong><asp:Literal ID="litShowingTo" runat="server" Text="0"></asp:Literal></strong> of 
                <strong><asp:Literal ID="litTotalRecords" runat="server" Text="0"></asp:Literal></strong> transactions
            </div>
            <div class="pagination-buttons" id="paginationButtons">
                <!-- Populated by code-behind -->
            </div>
        </div>

        <asp:Panel ID="pnlNoTransactions" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-receipt"></i>
                <h4>No Transactions Found</h4>
                <p>Try adjusting your filters or start by making your first deposit.</p>
                <a href="<%= ResolveUrl("~/User/Wallet.aspx?action=deposit") %>" class="btn btn-primary-glow">
                    <i class="fas fa-arrow-down me-2"></i> Make a Deposit
                </a>
            </div>
        </asp:Panel>
    </div>

    <!-- DEPOSITS TAB -->
    <div id="tab-deposits" class="tab-content" style="display: none;" data-aos="fade-up">
        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="stat-card" style="padding: 24px;">
                    <div class="summary-label">Total Deposits</div>
                    <div class="summary-value" style="color: var(--accent);">
                        <asp:Literal ID="litTotalDeposits" runat="server" Text="0.00"></asp:Literal>
                    </div>
                    <small class="text-muted">USDT</small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card" style="padding: 24px;">
                    <div class="summary-label">Deposit Count</div>
                    <div class="summary-value" style="color: #6366F1;">
                        <asp:Literal ID="litDepositCount" runat="server" Text="0"></asp:Literal>
                    </div>
                    <small class="text-muted">Transactions</small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card" style="padding: 24px;">
                    <div class="summary-label">Average Deposit</div>
                    <div class="summary-value" style="color: var(--gold);">
                        <asp:Literal ID="litAvgDeposit" runat="server" Text="0.00"></asp:Literal>
                    </div>
                    <small class="text-muted">USDT</small>
                </div>
            </div>
        </div>
        <div class="chart-card">
            <div class="chart-header">
                <h5 class="chart-title">
                    <i class="fas fa-arrow-down text-accent me-2"></i>
                    Deposit History
                </h5>
            </div>
            <asp:Repeater ID="rptDeposits" runat="server">
                <ItemTemplate>
                    <div class="commission-item">
                        <div class="tx-type-icon deposit">
                            <i class="fas fa-arrow-down"></i>
                        </div>
                        <div class="commission-info">
                            <div class="commission-title">Deposit Received</div>
                            <div class="commission-date">
                                <%# Convert.ToDateTime(Eval("CreatedDate")).ToString("MMM dd, yyyy 'at' hh:mm tt") %>
                                <span class="status-badge status-completed ms-2">Completed</span>
                            </div>
                        </div>
                        <div class="tx-amount positive">
                            +<%# string.Format("{0:0.########}", Eval("Amount")) %> <%# Eval("CurrencyCode") %>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:Panel ID="pnlNoDeposits" runat="server" Visible="false">
                <div class="empty-state">
                    <i class="fas fa-arrow-down"></i>
                    <h4>No Deposits Yet</h4>
                    <p>Your deposit history will appear here.</p>
                </div>
            </asp:Panel>
        </div>
    </div>

    <!-- WITHDRAWALS TAB -->
    <div id="tab-withdrawals" class="tab-content" style="display: none;" data-aos="fade-up">
        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="stat-card" style="padding: 24px;">
                    <div class="summary-label">Total Withdrawals</div>
                    <div class="summary-value" style="color: #ff3b5c;">
                        <asp:Literal ID="litTotalWithdrawals" runat="server" Text="0.00"></asp:Literal>
                    </div>
                    <small class="text-muted">USDT</small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card" style="padding: 24px;">
                    <div class="summary-label">Withdrawal Count</div>
                    <div class="summary-value" style="color: #6366F1;">
                        <asp:Literal ID="litWithdrawalCount" runat="server" Text="0"></asp:Literal>
                    </div>
                    <small class="text-muted">Transactions</small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card" style="padding: 24px;">
                    <div class="summary-label">Total Fees Paid</div>
                    <div class="summary-value" style="color: var(--gold);">
                        <asp:Literal ID="litTotalFees" runat="server" Text="0.00"></asp:Literal>
                    </div>
                    <small class="text-muted">USDT</small>
                </div>
            </div>
        </div>
        <div class="chart-card">
            <div class="chart-header">
                <h5 class="chart-title">
                    <i class="fas fa-arrow-up text-danger me-2"></i>
                    Withdrawal History
                </h5>
            </div>
            <asp:Repeater ID="rptWithdrawals" runat="server">
                <ItemTemplate>
                    <div class="commission-item">
                        <div class="tx-type-icon withdraw">
                            <i class="fas fa-arrow-up"></i>
                        </div>
                        <div class="commission-info">
                            <div class="commission-title">Withdrawal Request</div>
                            <div class="commission-date">
                                <%# Convert.ToDateTime(Eval("CreatedDate")).ToString("MMM dd, yyyy 'at' hh:mm tt") %>
                                <span class='status-badge <%# GetStatusClass(Eval("Status")) %> ms-2'>
                                    <%# Eval("StatusName") %>
                                </span>
                            </div>
                        </div>
                        <div class="tx-amount negative">
                            -<%# string.Format("{0:0.########}", Math.Abs(Convert.ToDecimal(Eval("Amount")))) %> <%# Eval("CurrencyCode") %>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:Panel ID="pnlNoWithdrawals" runat="server" Visible="false">
                <div class="empty-state">
                    <i class="fas fa-arrow-up"></i>
                    <h4>No Withdrawals Yet</h4>
                    <p>Your withdrawal history will appear here.</p>
                </div>
            </asp:Panel>
        </div>
    </div>

    <!-- EARNINGS TAB -->
    <div id="tab-earnings" class="tab-content" style="display: none;" data-aos="fade-up">
        <div class="row g-4 mb-4">
            <div class="col-md-3">
                <div class="stat-card" style="padding: 24px;">
                    <div class="summary-label">Total Earnings</div>
                    <div class="summary-value" style="color: var(--accent);">
                        <asp:Literal ID="litTotalEarnings" runat="server" Text="0.00"></asp:Literal>
                    </div>
                    <small class="text-muted">USDT</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card" style="padding: 24px;">
                    <div class="summary-label">ROI Rewards</div>
                    <div class="summary-value" style="color: var(--secondary);">
                        <asp:Literal ID="litROIEarnings" runat="server" Text="0.00"></asp:Literal>
                    </div>
                    <small class="text-muted">USDT</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card" style="padding: 24px;">
                    <div class="summary-label">Staking Rewards</div>
                    <div class="summary-value" style="color: var(--gold);">
                        <asp:Literal ID="litStakingEarnings" runat="server" Text="0.00"></asp:Literal>
                    </div>
                    <small class="text-muted">USDT</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card" style="padding: 24px;">
                    <div class="summary-label">Referral Commission</div>
                    <div class="summary-value" style="color: #10B981;">
                        <asp:Literal ID="litReferralEarnings" runat="server" Text="0.00"></asp:Literal>
                    </div>
                    <small class="text-muted">USDT</small>
                </div>
            </div>
        </div>
        <div class="chart-card">
            <div class="chart-header">
                <h5 class="chart-title">
                    <i class="fas fa-coins text-accent me-2"></i>
                    Earnings History
                </h5>
            </div>
            <asp:Repeater ID="rptEarnings" runat="server">
                <ItemTemplate>
                    <div class="commission-item">
                        <div class='tx-type-icon <%# Eval("TypeClass") %>'>
                            <i class='<%# Eval("Icon") %>'></i>
                        </div>
                        <div class="commission-info">
                            <div class="commission-title"><%# Eval("TypeName") %></div>
                            <div class="commission-date">
                                <%# Convert.ToDateTime(Eval("CreatedDate")).ToString("MMM dd, yyyy 'at' hh:mm tt") %>
                            </div>
                        </div>
                        <div class="tx-amount positive">
                            +<%# string.Format("{0:0.########}", Eval("Amount")) %> <%# Eval("CurrencyCode") %>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:Panel ID="pnlNoEarnings" runat="server" Visible="false">
                <div class="empty-state">
                    <i class="fas fa-coins"></i>
                    <h4>No Earnings Yet</h4>
                    <p>Start investing or staking to earn rewards.</p>
                </div>
            </asp:Panel>
        </div>
    </div>

    <!-- INVESTMENTS TAB -->
    <div id="tab-investments" class="tab-content" style="display: none;" data-aos="fade-up">
        <div class="row g-4 mb-4">
            <div class="col-md-6">
                <div class="stat-card" style="padding: 24px;">
                    <div class="summary-label">Total Invested</div>
                    <div class="summary-value" style="color: #6366F1;">
                        <asp:Literal ID="litTotalInvested" runat="server" Text="0.00"></asp:Literal>
                    </div>
                    <small class="text-muted">USDT</small>
                </div>
            </div>
            <div class="col-md-6">
                <div class="stat-card" style="padding: 24px;">
                    <div class="summary-label">Investment Count</div>
                    <div class="summary-value" style="color: var(--gold);">
                        <asp:Literal ID="litInvestmentCount" runat="server" Text="0"></asp:Literal>
                    </div>
                    <small class="text-muted">Transactions</small>
                </div>
            </div>
        </div>
        <div class="chart-card">
            <div class="chart-header">
                <h5 class="chart-title">
                    <i class="fas fa-chart-line text-secondary me-2"></i>
                    Investment History
                </h5>
            </div>
            <asp:Repeater ID="rptInvestments" runat="server">
                <ItemTemplate>
                    <div class="commission-item">
                        <div class="tx-type-icon invest">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <div class="commission-info">
                            <div class="commission-title">Investment Created</div>
                            <div class="commission-date">
                                <%# Convert.ToDateTime(Eval("CreatedDate")).ToString("MMM dd, yyyy 'at' hh:mm tt") %>
                                <span class="tx-type-sub"><%# Eval("SubType") %></span>
                            </div>
                        </div>
                        <div class="tx-amount negative">
                            -<%# string.Format("{0:0.########}", Math.Abs(Convert.ToDecimal(Eval("Amount")))) %> USDT
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:Panel ID="pnlNoInvestments" runat="server" Visible="false">
                <div class="empty-state">
                    <i class="fas fa-chart-line"></i>
                    <h4>No Investments Yet</h4>
                    <p>Start investing to grow your portfolio.</p>
                    <a href="<%= ResolveUrl("~/roi.aspx") %>" class="btn btn-primary-glow">
                        <i class="fas fa-rocket me-2"></i> Start Investing
                    </a>
                </div>
            </asp:Panel>
        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        //document.addEventListener('DOMContentLoaded', function() {
        //    // Tab switching
        //    var tabs = document.querySelectorAll('.trans-tab');
        //    var contents = document.querySelectorAll('.tab-content');

        //    tabs.forEach(function(tab) {
        //        tab.addEventListener('click', function() {
        //            tabs.forEach(function(t) { t.classList.remove('active'); });
        //            tab.classList.add('active');
        //            var target = tab.dataset.tab;
        //            contents.forEach(function(c) { c.style.display = 'none'; });
        //            document.getElementById('tab-' + target).style.display = 'block';
        //        });
        //    });


            document.addEventListener('DOMContentLoaded', function() {
                // Tab switching
                var tabs = document.querySelectorAll('.trans-tab');
                var contents = document.querySelectorAll('.tab-content');

                tabs.forEach(function(tab) {
                    tab.addEventListener('click', function(event) {
                        // ✅ CRITICAL: Prevent ASP.NET form postback/reload
                        event.preventDefault(); 
                    
                        tabs.forEach(function(t) { t.classList.remove('active'); });
                        tab.classList.add('active');
                    
                        var target = tab.dataset.tab;
                        contents.forEach(function(c) { c.style.display = 'none'; });
                    
                        var targetContent = document.getElementById('tab-' + target);
                        if (targetContent) {
                            targetContent.style.display = 'block';
                        }
                    });
                });

            // Volume Chart
            var volumeData = <%= GetVolumeChartData() %>;
            var volumeCtx = document.getElementById('volumeChart');
            if (volumeCtx && volumeData.labels.length > 0) {
                new Chart(volumeCtx, {
                    type: 'bar',
                    data: {
                        labels: volumeData.labels,
                        datasets: [
                            {
                                label: 'Inflow',
                                data: volumeData.inflow,
                                backgroundColor: 'rgba(0, 255, 178, 0.6)',
                                borderColor: '#00FFB2',
                                borderWidth: 1,
                                borderRadius: 4
                            },
                            {
                                label: 'Outflow',
                                data: volumeData.outflow,
                                backgroundColor: 'rgba(255, 59, 92, 0.6)',
                                borderColor: '#ff3b5c',
                                borderWidth: 1,
                                borderRadius: 4
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                labels: { color: '#A0AABF' }
                            },
                            tooltip: {
                                backgroundColor: 'rgba(11, 19, 43, 0.95)',
                                borderColor: '#6366F1',
                                borderWidth: 1,
                                callbacks: {
                                    label: function(ctx) { return ctx.dataset.label + ': ' + ctx.parsed.y.toLocaleString() + ' PNC'; }
                                }
                            }
                        },
                        scales: {
                            y: {
                                grid: { color: 'rgba(255,255,255,0.05)' },
                                ticks: { color: '#6B758D', callback: function(v) { return v.toLocaleString(); } }
                            },
                            x: {
                                grid: { display: false },
                                ticks: { color: '#6B758D' }
                            }
                        }
                    }
                });
            }

            // Type Distribution Chart
            var typeData = <%= GetTypeChartData() %>;
            var typeCtx = document.getElementById('typeChart');
            if (typeCtx && typeData.labels.length > 0) {
                new Chart(typeCtx, {
                    type: 'doughnut',
                    data: {
                        labels: typeData.labels,
                        datasets: [{
                            data: typeData.values,
                            backgroundColor: typeData.colors,
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
                for (var i = 0; i < typeData.labels.length; i++) {
                    legendHtml += '<div class="d-flex align-items-center gap-2 mb-1">' +
                        '<span style="width: 10px; height: 10px; border-radius: 50%; background: ' + typeData.colors[i] + '; display: inline-block;"></span>' +
                        '<span class="text-gray small flex-grow-1">' + typeData.labels[i] + '</span>' +
                        '<span class="text-white small fw-bold">' + typeData.values[i].toLocaleString() + '</span>' +
                        '</div>';
                }
                document.getElementById('typeLegend').innerHTML = legendHtml;
            }
        });

        // Copy TX Hash
        function copyHash(el) {
            var hash = el.getAttribute('title');
            navigator.clipboard.writeText(hash).then(function() {
                var originalText = el.textContent;
                el.textContent = 'Copied!';
                el.style.color = '#10B981';
                setTimeout(function() {
                    el.textContent = originalText;
                    el.style.color = '';
                }, 1500);
            });
        }
    </script>
</asp:Content>