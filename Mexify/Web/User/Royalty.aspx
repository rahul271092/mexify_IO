<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="Royalty.aspx.cs" Inherits="Mexify.Web.User.Licenses" %>

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
        }
        .license-tab.active {
            background: linear-gradient(135deg, var(--gold), #FFA500);
            color: #000;
            box-shadow: 0 4px 12px rgba(255, 215, 0, 0.3);
        }
        .license-tab:hover:not(.active) {
            background: rgba(255, 255, 255, 0.05);
            color: var(--text-white);
        }

        .current-license-card {
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.1), rgba(255, 165, 0, 0.05));
            border: 1px solid rgba(255, 215, 0, 0.3);
            border-radius: var(--radius-xl);
            padding: 40px;
            position: relative;
            overflow: hidden;
            margin-bottom: 32px;
        }
        .current-license-card.silver {
            background: linear-gradient(135deg, rgba(192, 192, 192, 0.1), rgba(169, 169, 169, 0.05));
            border-color: rgba(192, 192, 192, 0.3);
        }
        .current-license-card.platinum {
            background: linear-gradient(135deg, rgba(229, 228, 226, 0.1), rgba(168, 169, 173, 0.05));
            border-color: rgba(229, 228, 226, 0.3);
        }

        .license-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 14px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 50px;
            color: var(--text-white);
            font-weight: 700;
            font-size: 0.9rem;
            margin-bottom: 16px;
        }
        .license-badge.silver i { color: #C0C0C0; }
        .license-badge.gold i { color: var(--gold); }
        .license-badge.platinum i { color: #E5E4E2; }

        .summary-label {
            color: var(--text-gray);
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            margin-bottom: 8px;
        }
        .summary-value {
            font-size: 2rem;
            font-weight: 800;
            color: var(--text-white);
            margin-bottom: 4px;
        }

        .benefits-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-top: 24px;
        }
        .benefit-item {
            background: rgba(0, 0, 0, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            padding: 16px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .benefit-item i {
            font-size: 1.2rem;
            color: var(--gold);
        }
        .benefit-item.locked { opacity: 0.5; }
        .benefit-item.locked i { color: var(--text-muted); }
        .benefit-text { font-size: 0.9rem; color: var(--text-white); }

        .countdown-timer {
            display: inline-flex;
            gap: 8px;
            padding: 8px 14px;
            background: rgba(255, 215, 0, 0.08);
            border: 1px solid rgba(255, 215, 0, 0.2);
            border-radius: var(--radius-sm);
            margin-top: 16px;
        }
        .countdown-unit { text-align: center; min-width: 40px; }
        .countdown-unit .value {
            display: block;
            color: var(--gold);
            font-size: 1.1rem;
            font-weight: 800;
        }
        .countdown-unit .label {
            font-size: 0.65rem;
            color: var(--text-muted);
            text-transform: uppercase;
        }

        .tier-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 32px;
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        .tier-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.3);
        }
        .tier-card.active-tier {
            border: 2px solid var(--gold);
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.05), transparent);
        }
        .tier-icon {
            width: 64px; height: 64px;
            margin: 0 auto 16px;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.8rem;
        }
        .tier-icon.silver { background: linear-gradient(135deg, #C0C0C0, #A9A9A9); color: #fff; }
        .tier-icon.gold { background: linear-gradient(135deg, #FFD700, #FFA500); color: #000; }
        .tier-icon.platinum { background: linear-gradient(135deg, #E5E4E2, #A8A9AD); color: #000; }
        .tier-name {
            color: var(--text-white);
            font-weight: 700;
            font-size: 1.3rem;
            margin-bottom: 8px;
        }
        .tier-price {
            font-size: 2.5rem;
            font-weight: 800;
            color: var(--text-white);
            margin-bottom: 4px;
        }
        .tier-price small {
            font-size: 0.9rem;
            color: var(--text-muted);
        }
        .tier-duration {
            color: var(--text-gray);
            margin-bottom: 24px;
        }
        .tier-benefits {
            list-style: none;
            padding: 0;
            margin: 0 0 24px 0;
            text-align: left;
            flex-grow: 1;
        }
        .tier-benefits li {
            padding: 8px 0;
            color: var(--text-gray);
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 8px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }
        .tier-benefits li:last-child { border-bottom: none; }
        .tier-benefits li i { color: var(--gold); }
        .tier-btn {
            width: 100%;
            padding: 12px;
            border-radius: 50px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
        }
        .tier-btn.primary {
            background: linear-gradient(135deg, var(--gold), #FFA500);
            color: #000;
        }
        .tier-btn.primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 215, 0, 0.4);
        }
        .tier-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none;
        }

        .history-table {
            width: 100%;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            overflow: hidden;
        }
        .history-table table { width: 100%; color: var(--text-gray); }
        .history-table th {
            background: rgba(255, 215, 0, 0.08);
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
        .status-active { background: rgba(0, 255, 178, 0.15); color: var(--accent); }
        .status-expired { background: rgba(255, 59, 92, 0.15); color: #ff3b5c; }

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
        .alert-box i { margin-top: 2px; flex-shrink: 0; }

        @media (max-width: 768px) {
            .summary-value { font-size: 1.5rem; }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Header -->
    <div class="license-header" data-aos="fade-up">
        <div>
            <h2>License & Membership</h2>
            <p class="text-gray mb-0">Manage your subscription and unlock premium benefits</p>
        </div>
    </div>

    <!-- Tabs -->
    <div class="license-tabs" data-aos="fade-up">
        <button class="license-tab active" data-tab="current">Current License</button>
        <button class="license-tab" data-tab="upgrade">Upgrade</button>
        <button class="license-tab" data-tab="history">History</button>
    </div>

    <!-- CURRENT LICENSE TAB -->
    <div id="tab-current" class="tab-content" data-aos="fade-up">
        
        <asp:Panel ID="pnlNoLicense" runat="server" Visible="false">
            <div class="alert-box warning">
                <i class="fas fa-exclamation-triangle"></i>
                <div>
                    <strong class="text-white">No Active License</strong><br>
                    You currently don't have a license. Upgrade to unlock higher earning potential and premium benefits.
                </div>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlActiveLicense" runat="server">
            <div class="current-license-card <%# CurrentLicenseClass %>" data-aos="fade-up">
                <div class="row align-items-center">
                    <div class="col-lg-8">
                        <div class="license-badge <%# CurrentLicenseClass %>">
                            <i class='<%# CurrentLicenseIcon %>'></i>
                            <asp:Literal ID="litCurrentTierName" runat="server" Text="None"></asp:Literal> Member
                        </div>
                        
                        <div class="summary-label">Status</div>
                        <div class="summary-value text-white mb-2">
                            <asp:Literal ID="litLicenseStatus" runat="server" Text="Active"></asp:Literal>
                        </div>

                        <div class="row g-4 mt-2">
                            <div class="col-6 col-md-4">
                                <div class="summary-label">Valid Until</div>
                                <div style="font-size: 1.2rem; font-weight: 600; color: var(--text-white);">
                                    <asp:Literal ID="litExpiryDate" runat="server"></asp:Literal>
                                </div>
                            </div>
                            <div class="col-6 col-md-4">
                                <div class="summary-label">Days Remaining</div>
                                <div style="font-size: 1.2rem; font-weight: 600; color: var(--gold);">
                                    <asp:Literal ID="litDaysRemaining" runat="server" Text="0"></asp:Literal> Days
                                </div>
                            </div>
                            <div class="col-6 col-md-4">
                                <div class="summary-label">Auto-Renew</div>
                                <div style="font-size: 1.2rem; font-weight: 600; color: var(--accent);">
                                    <asp:Literal ID="litAutoRenew" runat="server" Text="OFF"></asp:Literal>
                                </div>
                            </div>
                        </div>

                        <div class="countdown-timer" data-end='<%# CurrentLicenseExpiryIso %>'>
                            <div class="countdown-unit">
                                <span class="value cd-days">00</span>
                                <span class="label">Days</span>
                            </div>
                            <div class="countdown-unit">
                                <span class="value cd-hours">00</span>
                                <span class="label">Hrs</span>
                            </div>
                            <div class="countdown-unit">
                                <span class="value cd-mins">00</span>
                                <span class="label">Mins</span>
                            </div>
                        </div>

                        <div class="d-flex gap-3 mt-4 flex-wrap">
                            <asp:Button ID="btnRenew" runat="server" Text="Renew Now" CssClass="btn btn-primary-glow" OnClick="btnRenew_Click" />
                            <a href="<%= ResolveUrl("~/WEb/User/Royalty.aspx") %>?tab=upgrade" class="btn btn-outline-glass" onclick="document.querySelector('[data-tab=upgrade]').click()">Upgrade Tier</a>
                        </div>
                    </div>
                    <div class="col-lg-4 mt-4 mt-lg-0">
                        <h4 class="text-white mb-3">Unlocked Benefits</h4>
                        <asp:Literal ID="litBenefits" runat="server"></asp:Literal>
                    </div>
                </div>
            </div>
        </asp:Panel>
    </div>

    <!-- UPGRADE TAB -->
    <div id="tab-upgrade" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <div class="alert-box info">
            <i class="fas fa-info-circle"></i>
            <div>
                <strong class="text-white">Upgrade your license</strong> to access higher referral commissions, reduced fees, and premium investment pools.
            </div>
        </div>

        <asp:Panel ID="pnlUpgradeError" runat="server" Visible="false">
            <div class="alert-box error">
                <i class="fas fa-exclamation-circle"></i>
                <asp:Literal ID="litUpgradeError" runat="server"></asp:Literal>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlUpgradeSuccess" runat="server" Visible="false">
            <div class="alert-box success">
                <i class="fas fa-check-circle"></i>
                <asp:Literal ID="litUpgradeSuccess" runat="server"></asp:Literal>
            </div>
        </asp:Panel>

        <div class="row g-4">
            <!-- Silver Tier -->
            <div class="col-md-4">
                <div class="tier-card <%# IsSilverActive ? "active-tier" : "" %>" data-aos="fade-up">
                    <div class="tier-icon silver"><i class="fas fa-medal"></i></div>
                    <div class="tier-name">Silver License</div>
                    <div class="tier-price">
                        500 <small>USDT</small>
                    </div>
                    <div class="tier-duration">Valid for 30 Days</div>
                    <ul class="tier-benefits">
                        <li><i class="fas fa-check"></i> 5% Direct Referral Bonus</li>
                        <li><i class="fas fa-check"></i> Standard Deposit Fees</li>
                        <li><i class="fas fa-check"></i> Basic Support Access</li>
                        <li><i class="fas fa-times" style="color: #ff3b5c;"></i> Premium Pools</li>
                    </ul>
                    <asp:Button ID="btnBuySilver" runat="server" Text='<%# IsSilverActive ? "Current Plan" : "Buy Silver" %>' CssClass='tier-btn <%# IsSilverActive ? "btn-secondary" : "tier-btn primary" %>' OnClick="btnBuySilver_Click" Enabled='<%# !IsSilverActive %>' />
                </div>
            </div>

            <!-- Gold Tier -->
            <div class="col-md-4">
                <div class="tier-card <%# IsGoldActive ? "active-tier" : "" %>" data-aos="fade-up" data-aos-delay="100">
                    <div class="tier-icon gold"><i class="fas fa-crown"></i></div>
                    <div class="tier-name">Gold License</div>
                    <div class="tier-price">
                        1,500 <small>USDT</small>
                    </div>
                    <div class="tier-duration">Valid for 90 Days</div>
                    <ul class="tier-benefits">
                        <li><i class="fas fa-check"></i> <strong>10%</strong> Direct Referral Bonus</li>
                        <li><i class="fas fa-check"></i> <strong>15% Off</strong> Deposit Fees</li>
                        <li><i class="fas fa-check"></i> Priority Support</li>
                        <li><i class="fas fa-check"></i> Access to 2 Premium Pools</li>
                    </ul>
                    <asp:Button ID="btnBuyGold" runat="server" Text='<%# IsGoldActive ? "Current Plan" : "Buy Gold" %>' CssClass='tier-btn <%# IsGoldActive ? "btn-secondary" : "tier-btn primary" %>' OnClick="btnBuyGold_Click" Enabled='<%# !IsGoldActive %>' />
                </div>
            </div>

            <!-- Platinum Tier -->
            <div class="col-md-4">
                <div class="tier-card <%# IsPlatinumActive ? "active-tier" : "" %>" data-aos="fade-up" data-aos-delay="200">
                    <div class="tier-icon platinum"><i class="fas fa-gem"></i></div>
                    <div class="tier-name">Platinum License</div>
                    <div class="tier-price">
                        5,000 <small>USDT</small>
                    </div>
                    <div class="tier-duration">Valid for 365 Days</div>
                    <ul class="tier-benefits">
                        <li><i class="fas fa-check"></i> <strong>15%</strong> Direct Referral Bonus</li>
                        <li><i class="fas fa-check"></i> <strong>50% Off</strong> Deposit Fees</li>
                        <li><i class="fas fa-check"></i> Dedicated Account Manager</li>
                        <li><i class="fas fa-check"></i> Access to ALL Premium Pools</li>
                    </ul>
                    <asp:Button ID="btnBuyPlatinum" runat="server" Text='<%# IsPlatinumActive ? "Current Plan" : "Buy Platinum" %>' CssClass='tier-btn <%# IsPlatinumActive ? "btn-secondary" : "tier-btn primary" %>' OnClick="btnBuyPlatinum_Click" Enabled='<%# !IsPlatinumActive %>' />
                </div>
            </div>
        </div>
    </div>

    <!-- HISTORY TAB -->
    <div id="tab-history" class="tab-content" style="display: none;" data-aos="fade-up">
        
        <div class="history-table">
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>License</th>
                            <th>Amount</th>
                            <th>Purchase Date</th>
                            <th>Expiry Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptHistory" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <i class='<%# GetLicenseIcon(Eval("LicenseType")) %>' style='color: <%# GetLicenseColor(Eval("LicenseType")) %>'></i>
                                            <span class="text-white"><%# Eval("LicenseName") %></span>
                                        </div>
                                    </td>
                                    <td><%# string.Format("{0:0}", Eval("Amount")) %> USDT</td>
                                    <td class="text-muted"><%# Convert.ToDateTime(Eval("PurchaseDate")).ToString("MMM dd, yyyy") %></td>
                                    <td class="text-muted"><%# Convert.ToDateTime(Eval("ExpiryDate")).ToString("MMM dd, yyyy") %></td>
                                    <td>
                                        <span class='status-badge <%# Convert.ToBoolean(Eval("IsActive")) ? "status-active" : "status-expired" %>'>
                                            <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Expired" %>
                                        </span>
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
                <i class="fas fa-file-invoice"></i>
                <h4>No License History</h4>
                <p>Your license purchases will appear here.</p>
            </div>
        </asp:Panel>
    </div>

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Tab switching
            var tabs = document.querySelectorAll('.license-tab');
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

            // Check for tab in URL
            var urlParams = new URLSearchParams(window.location.search);
            var tabParam = urlParams.get('tab');
            if (tabParam && document.querySelector('[data-tab="' + tabParam + '"]')) {
                document.querySelector('[data-tab="' + tabParam + '"]').click();
            }

            // Countdown timers
            document.querySelectorAll('.countdown-timer').forEach(function(el) {
                var endDate = new Date(el.dataset.end).getTime();
                function update() {
                    var now = new Date().getTime();
                    var distance = endDate - now;
                    if (distance < 0) return;
                    var d = Math.floor(distance / (1000 * 60 * 60 * 24));
                    var h = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                    var m = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                    el.querySelector('.cd-days').textContent = String(d).padStart(2, '0');
                    el.querySelector('.cd-hours').textContent = String(h).padStart(2, '0');
                    el.querySelector('.cd-mins').textContent = String(m).padStart(2, '0');
                }
                update();
                setInterval(update, 1000);
            });
        });
    </script>
</asp:Content>