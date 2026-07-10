<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="mining.aspx.cs" Inherits="Mexify.Web.mining" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="MEXIFY Enterprise Crypto Mining - Cloud mining with institutional-grade hardware. Earn BTC, ETH, and PNC rewards.">
    <meta name="keywords" content="crypto mining, cloud mining, bitcoin mining, gpu mining, asic mining, mexify">
    <style>
        .mining-hero { min-height: 60vh; position: relative; overflow: hidden; }
        .mining-hero::before {
            content: '';
            position: absolute;
            top: -50%; right: -20%;
            width: 800px; height: 800px;
            background: radial-gradient(circle, rgba(0, 255, 178, 0.12) 0%, transparent 70%);
            animation: float 10s ease-in-out infinite;
        }
        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-30px) rotate(5deg); }
        }

        .mining-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-xl);
            padding: 36px;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            overflow: hidden;
            height: 100%;
        }
        .mining-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 4px;
            background: linear-gradient(90deg, var(--primary), var(--accent));
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.4s ease;
        }
        .mining-card:hover::before { transform: scaleX(1); }
        .mining-card:hover {
            transform: translateY(-10px);
            border-color: var(--secondary);
            box-shadow: 0 20px 40px rgba(0, 212, 255, 0.2);
        }
        .mining-card.featured {
            border-color: var(--gold);
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.05), rgba(37, 99, 235, 0.05));
        }
        .mining-card.featured::before {
            background: linear-gradient(90deg, var(--gold), #FFA500);
            transform: scaleX(1);
        }
        .featured-badge {
            position: absolute;
            top: 20px; right: -35px;
            background: linear-gradient(135deg, var(--gold), #FFA500);
            color: #000;
            padding: 6px 40px;
            font-size: 0.75rem;
            font-weight: 700;
            transform: rotate(45deg);
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .mining-icon-lg {
            width: 80px; height: 80px;
            border-radius: 24px;
            display: flex; align-items: center; justify-content: center;
            font-size: 2.2rem;
            margin-bottom: 24px;
        }
        .mining-icon-btc { background: linear-gradient(135deg, rgba(247, 147, 26, 0.2), rgba(247, 147, 26, 0.05)); color: #F7931A; border: 1px solid rgba(247, 147, 26, 0.3); }
        .mining-icon-eth { background: linear-gradient(135deg, rgba(98, 126, 234, 0.2), rgba(98, 126, 234, 0.05)); color: #627EEA; border: 1px solid rgba(98, 126, 234, 0.3); }
        .mining-icon-pnc { background: linear-gradient(135deg, rgba(255, 215, 0, 0.2), rgba(255, 165, 0, 0.1)); color: var(--gold); border: 1px solid rgba(255, 215, 0, 0.3); }
        .mining-icon-cloud { background: linear-gradient(135deg, rgba(0, 212, 255, 0.2), rgba(37, 99, 235, 0.1)); color: var(--secondary); border: 1px solid rgba(0, 212, 255, 0.3); }

        .hashrate-display {
            font-size: 2.5rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--accent), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: 16px 0;
            line-height: 1;
        }
        .hashrate-display small {
            font-size: 1rem;
            color: var(--text-gray);
            -webkit-text-fill-color: var(--text-gray);
        }

        .mining-details { margin: 24px 0; }
        .mining-detail-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid var(--glass-border);
            font-size: 0.9rem;
        }
        .mining-detail-row:last-child { border-bottom: none; }
        .mining-detail-row .label { color: var(--text-muted); }
        .mining-detail-row .value { color: var(--text-white); font-weight: 600; }

        .price-tag {
            margin-top: 20px;
            padding: 20px;
            background: rgba(0, 0, 0, 0.2);
            border-radius: var(--radius-md);
            text-align: center;
        }
        .price-tag .label {
            font-size: 0.75rem;
            color: var(--text-muted);
            text-transform: uppercase;
            margin-bottom: 6px;
        }
        .price-tag .value {
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--gold);
        }

        .calculator-card {
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.1), rgba(0, 255, 178, 0.05));
            border: 1px solid rgba(0, 212, 255, 0.3);
            border-radius: var(--radius-xl);
            padding: 50px;
        }
        .result-box {
            background: linear-gradient(135deg, rgba(0, 255, 178, 0.1), rgba(0, 212, 255, 0.05));
            border: 1px solid rgba(0, 255, 178, 0.3);
            border-radius: var(--radius-lg);
            padding: 30px;
            text-align: center;
        }
        .result-value {
            font-size: 2.5rem;
            font-weight: 800;
            color: var(--accent);
            margin: 12px 0;
        }

        .benefit-icon {
            width: 70px; height: 70px;
            margin: 0 auto 20px;
            display: flex; align-items: center; justify-content: center;
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.2), rgba(0, 212, 255, 0.1));
            border-radius: 20px;
            font-size: 1.8rem;
            color: var(--secondary);
            border: 1px solid rgba(0, 212, 255, 0.2);
        }

        .live-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-top: 24px;
        }
        .live-stat-item {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-md);
            padding: 20px;
            text-align: center;
        }
        .live-stat-item .label {
            font-size: 0.75rem;
            color: var(--text-muted);
            text-transform: uppercase;
            margin-bottom: 8px;
        }
        .live-stat-item .value {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-white);
        }
        .live-stat-item .sub {
            font-size: 0.8rem;
            color: var(--accent);
            margin-top: 4px;
        }

        .algorithm-badge {
            display: inline-block;
            padding: 4px 12px;
            background: rgba(0, 212, 255, 0.1);
            border: 1px solid rgba(0, 212, 255, 0.3);
            border-radius: 50px;
            font-size: 0.75rem;
            color: var(--secondary);
            font-weight: 600;
            margin-bottom: 12px;
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Hero -->
    <section class="mining-hero hero-section">
        <canvas id="three-canvas"></canvas>
        <div class="container position-relative" style="z-index: 2;">
            <div class="row justify-content-center text-center">
                <div class="col-lg-8 hero-content" data-aos="fade-up">
                    <div class="hero-badge">
                        <i class="fas fa-server me-2"></i> Enterprise Cloud Mining
                    </div>
                    <h1 class="hero-title">
                        Mine Crypto with <br><span>Institutional Hardware</span>
                    </h1>
                    <p class="hero-subtitle mx-auto">
                        Access state-of-the-art mining farms with ASIC and GPU hardware. No equipment, no electricity bills — just pure mining rewards delivered to your wallet.
                    </p>
                    <div class="d-flex gap-3 justify-content-center flex-wrap" data-aos="fade-up" data-aos-delay="200">
                        <a href="#plans" class="btn btn-primary-glow">
                            <i class="fas fa-hammer me-2"></i> Start Mining
                        </a>
                        <a href="#calculator" class="btn btn-outline-glass">
                            <i class="fas fa-calculator me-2"></i> Profit Calculator
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Live Network Stats -->
    <section class="section-padding" style="padding-top: 40px;">
        <div class="container">
            <h2 class="section-title text-center" data-aos="fade-up">Live Network Statistics</h2>
            <div class="live-stats" data-aos="fade-up" data-aos-delay="100">
                <div class="live-stat-item">
                    <div class="label">Total Hashrate</div>
                    <div class="value">485 EH/s</div>
                    <div class="sub">+12.5% this week</div>
                </div>
                <div class="live-stat-item">
                    <div class="label">Active Miners</div>
                    <div class="value">12,847</div>
                    <div class="sub">Across 45 countries</div>
                </div>
                <div class="live-stat-item">
                    <div class="label">BTC Mined (24h)</div>
                    <div class="value">142.5 BTC</div>
                    <div class="sub">≈ 8.2M PNC</div>
                </div>
                <div class="live-stat-item">
                    <div class="label">Rewards Paid</div>
                    <div class="value">15.8M PNC</div>
                    <div class="sub">All-time total</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Mining Plans -->
    <section id="plans" class="section-padding">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">Mining Contracts</h2>
            <p class="section-subtitle" data-aos="fade-up">Choose a contract and start mining instantly</p>

            <div class="row g-4">
                <asp:Repeater ID="rptPlans" runat="server">
                    <ItemTemplate>
                        <div class="col-md-6 col-lg-4" data-aos="fade-up">
                            <div class='mining-card <%# Convert.ToBoolean(Eval("IsFeatured")) ? "featured" : "" %>'>
                                <%# Convert.ToBoolean(Eval("IsFeatured")) ? "<span class='featured-badge'>Best Value</span>" : "" %>
                                
                                <div class='mining-icon-lg <%# GetMiningIconClass(Eval("Algorithm")) %>'>
                                    <i class='<%# GetMiningIcon(Eval("Algorithm")) %>'></i>
                                </div>

                                <span class="algorithm-badge"><%# Eval("Algorithm") %></span>
                                <h4 class="text-white mb-1"><%# Eval("PlanName") %></h4>
                                <p class="text-gray small mb-0">Cloud mining contract</p>

                                <div class="hashrate-display">
                                    <%# Eval("HashrateFormatted") %>
                                </div>

                                <div class="mining-details">
                                    <div class="mining-detail-row">
                                        <span class="label">Duration</span>
                                        <span class="value"><%# Eval("DurationDays") %> Days</span>
                                    </div>
                                    <div class="mining-detail-row">
                                        <span class="label">Daily Reward (est.)</span>
                                        <span class="value" style="color: var(--accent);">
                                            <%# string.Format("{0:0.########}", Eval("ExpectedDailyReward")) %> <%# Eval("RewardCurrency") %>
                                        </span>
                                    </div>
                                    <div class="mining-detail-row">
                                        <span class="label">Power Consumption</span>
                                        <span class="value"><%# Eval("PowerConsumption") %></span>
                                    </div>
                                    <div class="mining-detail-row">
                                        <span class="label">Maintenance Fee</span>
                                        <span class="value"><%# Eval("MaintenanceFeeFormatted") %></span>
                                    </div>
                                </div>

                                <div class="price-tag">
                                    <div class="label">Contract Price</div>
                                    <div class="value">
                                        <%# string.Format("{0:0.##}", Eval("Price")) %> PNC
                                    </div>
                                    <small class="text-muted">
                                        ROI in <%# Eval("RoiDays") %> days
                                    </small>
                                </div>

                                <a href="<%= ResolveUrl("~/User/Mining.aspx") %>" class='btn <%# Convert.ToBoolean(Eval("IsFeatured")) ? "btn-primary-glow" : "btn-outline-glass" %> w-100 mt-4'>
                                    <i class="fas fa-hammer me-2"></i> Purchase Contract
                                </a>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <!-- Mining Calculator -->
    <section id="calculator" class="section-padding" style="background: var(--bg-secondary);">
        <div class="container">
            <div class="row align-items-center g-5">
                <div class="col-lg-6" data-aos="fade-right">
                    <h2 class="section-title text-start">Mining Profit Calculator</h2>
                    <p class="text-start text-gray">Estimate your mining profitability based on hashrate and current network conditions.</p>

                    <div class="calculator-card mt-4">
                        <div class="mb-4">
                            <label class="form-label text-white">Select Mining Contract</label>
                            <asp:DropDownList ID="ddlContract" runat="server" CssClass="form-select form-control-glass" AutoPostBack="true" OnSelectedIndexChanged="CalculateMining"></asp:DropDownList>
                        </div>
                        <div class="mb-4">
                            <label class="form-label text-white">Number of Contracts</label>
                            <asp:TextBox ID="txtContracts" runat="server" CssClass="form-control form-control-glass" TextMode="Number" Text="1" min="1"></asp:TextBox>
                        </div>
                        <div class="mb-4">
                            <label class="form-label text-white">Current Reward Currency Price (PNC)</label>
                            <asp:TextBox ID="txtRewardPrice" runat="server" CssClass="form-control form-control-glass" TextMode="Number" Text="57500" step="0.01"></asp:TextBox>
                            <small class="text-muted">1 BTC ≈ 57,500 PNC (update as needed)</small>
                        </div>
                        <asp:Button ID="btnCalculate" runat="server" Text="Calculate Profit" CssClass="btn btn-primary-glow w-100" OnClick="CalculateMining" />

                        <div class="result-box mt-4">
                            <small class="text-muted text-uppercase">Estimated Total Profit</small>
                            <div class="result-value">
                                <asp:Literal ID="litTotalProfit" runat="server" Text="0.00 PNC"></asp:Literal>
                            </div>
                            <small class="text-gray">
                                Net ROI: <strong class="text-white">
                                    <asp:Literal ID="litROI" runat="server" Text="0.00%"></asp:Literal>
                                </strong>
                            </small>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6" data-aos="fade-left">
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="glass-card p-3 text-center">
                                <small class="text-muted d-block">Daily Revenue</small>
                                <h5 class="text-white mb-0">
                                    <asp:Literal ID="litDailyRevenue" runat="server" Text="0.00 PNC"></asp:Literal>
                                </h5>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="glass-card p-3 text-center">
                                <small class="text-muted d-block">Daily Cost</small>
                                <h5 class="text-white mb-0">
                                    <asp:Literal ID="litDailyCost" runat="server" Text="0.00 PNC"></asp:Literal>
                                </h5>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="glass-card p-3 text-center">
                                <small class="text-muted d-block">Daily Profit</small>
                                <h5 class="text-accent mb-0">
                                    <asp:Literal ID="litDailyProfit" runat="server" Text="0.00 PNC"></asp:Literal>
                                </h5>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="glass-card p-3 text-center">
                                <small class="text-muted d-block">Break-Even</small>
                                <h5 class="text-white mb-0">
                                    <asp:Literal ID="litBreakEven" runat="server" Text="0 days"></asp:Literal>
                                </h5>
                            </div>
                        </div>
                    </div>

                    <div class="glass-card p-4 mt-4">
                        <h5 class="text-white mb-3">Projected Earnings</h5>
                        <div style="height: 250px;">
                            <canvas id="miningChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Why Mine with MEXIFY -->
    <section class="section-padding">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">Why Mine with MEXIFY?</h2>
            <p class="section-subtitle" data-aos="fade-up">Enterprise-grade infrastructure, zero hassle</p>

            <div class="row g-4">
                <div class="col-md-6 col-lg-3" data-aos="fade-up">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="benefit-icon"><i class="fas fa-microchip"></i></div>
                        <h5 class="text-white">Latest Hardware</h5>
                        <p class="text-gray small">Bitmain Antminer S21, Whatsminer M60, and latest GPU rigs.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="100">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="benefit-icon"><i class="fas fa-bolt"></i></div>
                        <h5 class="text-white">Cheap Electricity</h5>
                        <p class="text-gray small">$0.04/kWh industrial rates in our tier-3 data centers.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="200">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="benefit-icon"><i class="fas fa-shield-alt"></i></div>
                        <h5 class="text-white">99.9% Uptime</h5>
                        <p class="text-gray small">Redundant power, cooling, and network infrastructure.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="300">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="benefit-icon"><i class="fas fa-wallet"></i></div>
                        <h5 class="text-white">Daily Payouts</h5>
                        <p class="text-gray small">Mining rewards delivered to your wallet every 24 hours.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- How It Works -->
    <section class="section-padding" style="background: var(--bg-secondary);">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">How Cloud Mining Works</h2>
            <p class="section-subtitle" data-aos="fade-up">Start mining in 4 simple steps</p>

            <div class="row g-4">
                <div class="col-md-6 col-lg-3" data-aos="fade-up">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="feature-icon mx-auto">1</div>
                        <h5 class="text-white">Choose Contract</h5>
                        <p class="text-gray small">Select a mining plan based on hashrate and budget.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="100">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="feature-icon mx-auto">2</div>
                        <h5 class="text-white">Pay with PNC</h5>
                        <p class="text-gray small">Purchase your contract using PNC from your wallet.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="200">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="feature-icon mx-auto">3</div>
                        <h5 class="text-white">Start Mining</h5>
                        <p class="text-gray small">Contract activates instantly. Monitor hashrate in real-time.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="300">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="feature-icon mx-auto">4</div>
                        <h5 class="text-white">Earn Rewards</h5>
                        <p class="text-gray small">Receive daily mining rewards in BTC, ETH, or PNC.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- FAQ -->
    <section class="section-padding">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">Mining FAQs</h2>
            <p class="section-subtitle" data-aos="fade-up">Common questions about cloud mining</p>

            <div class="accordion accordion-flush" id="miningFAQ">
                <div class="accordion-item glass-card mb-3 border-0" data-aos="fade-up">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed bg-transparent text-white" type="button" data-bs-toggle="collapse" data-bs-target="#mfaq1">
                            What is cloud mining?
                        </button>
                    </h2>
                    <div id="mfaq1" class="accordion-collapse collapse" data-bs-parent="#miningFAQ">
                        <div class="accordion-body text-gray">
                            Cloud mining allows you to rent mining hardware hosted in our data centers. You don't need to buy equipment, pay electricity bills, or manage hardware — we handle everything while you earn mining rewards.
                        </div>
                    </div>
                </div>
                <div class="accordion-item glass-card mb-3 border-0" data-aos="fade-up">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed bg-transparent text-white" type="button" data-bs-toggle="collapse" data-bs-target="#mfaq2">
                            How are mining rewards calculated?
                        </button>
                    </h2>
                    <div id="mfaq2" class="accordion-collapse collapse" data-bs-parent="#miningFAQ">
                        <div class="accordion-body text-gray">
                            Rewards depend on your contract hashrate, the network difficulty, and block rewards. We calculate estimated daily rewards based on current conditions and update them in real-time.
                        </div>
                    </div>
                </div>
                <div class="accordion-item glass-card mb-3 border-0" data-aos="fade-up">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed bg-transparent text-white" type="button" data-bs-toggle="collapse" data-bs-target="#mfaq3">
                            What is the maintenance fee?
                        </button>
                    </h2>
                    <div id="mfaq3" class="accordion-collapse collapse" data-bs-parent="#miningFAQ">
                        <div class="accordion-body text-gray">
                            A small daily maintenance fee covers electricity, cooling, and hardware upkeep. This fee is automatically deducted from your daily mining rewards before payout.
                        </div>
                    </div>
                </div>
                <div class="accordion-item glass-card mb-3 border-0" data-aos="fade-up">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed bg-transparent text-white" type="button" data-bs-toggle="collapse" data-bs-target="#mfaq4">
                            Can I withdraw my mining rewards?
                        </button>
                    </h2>
                    <div id="mfaq4" class="accordion-collapse collapse" data-bs-parent="#miningFAQ">
                        <div class="accordion-body text-gray">
                            Yes! Mining rewards are credited to your wallet daily. You can withdraw them to an external wallet, convert to PNC, or reinvest in new contracts at any time.
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA -->
    <section class="section-padding" style="background: var(--bg-secondary);">
        <div class="container">
            <div class="glass-card p-5 text-center" data-aos="zoom-in" style="background: linear-gradient(135deg, rgba(37, 99, 235, 0.2), rgba(0, 255, 178, 0.1));">
                <i class="fas fa-server fa-3x text-secondary mb-3"></i>
                <h2 class="text-white mb-3">Start Mining Today</h2>
                <p class="text-gray mb-4 mx-auto" style="max-width: 600px;">
                    Join thousands of miners earning passive income with MEXIFY's enterprise-grade cloud mining infrastructure.
                </p>
                <a href="<%= ResolveUrl("~/register.aspx") %>" class="btn btn-primary-glow btn-lg">
                    Create Free Account <i class="fas fa-arrow-right ms-2"></i>
                </a>
            </div>
        </div>
    </section>

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        var miningChartData = {
            labels: <%= GetChartLabels() %>,
            data: <%= GetChartData() %>
        };

        document.addEventListener('DOMContentLoaded', () => {
            if (document.getElementById('miningChart')) {
                const ctx = document.getElementById('miningChart').getContext('2d');
                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: miningChartData.labels,
                        datasets: [{
                            label: 'Cumulative Profit (PNC)',
                            data: miningChartData.data,
                            borderColor: '#00FFB2',
                            backgroundColor: 'rgba(0, 255, 178, 0.1)',
                            fill: true,
                            tension: 0.4,
                            pointRadius: 0,
                            pointHoverRadius: 6
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: { legend: { display: false } },
                        scales: {
                            y: {
                                grid: { color: 'rgba(255,255,255,0.05)' },
                                ticks: { color: '#6B758D', callback: (val) => val.toLocaleString() + ' PNC' }
                            },
                            x: {
                                grid: { display: false },
                                ticks: { color: '#6B758D' }
                            }
                        }
                    }
                });
            }
        });
    </script>
</asp:Content>