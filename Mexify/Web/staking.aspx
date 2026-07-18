<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="staking.aspx.cs" Inherits="Mexify.Web.staking" %>



<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="MEXIFY Flexible Staking - Earn up to 18% APY on your PNC and other crypto assets with flexible lock periods.">
    <meta name="keywords" content="staking, pnc staking, crypto staking, passive income, defi, mexify">
    <style>
        .staking-hero { min-height: 60vh; position: relative; overflow: hidden; }
        .staking-hero::before {
            content: '';
            position: absolute;
            top: -50%; left: -20%;
            width: 800px; height: 800px;
            background: radial-gradient(circle, rgba(37, 99, 235, 0.15) 0%, transparent 70%);
            animation: float 10s ease-in-out infinite;
        }
        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-30px) rotate(5deg); }
        }

        .staking-card {
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
        .staking-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 4px;
            background: linear-gradient(90deg, var(--primary), var(--accent));
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.4s ease;
        }
        .staking-card:hover::before { transform: scaleX(1); }
        .staking-card:hover {
            transform: translateY(-10px);
            border-color: var(--secondary);
            box-shadow: 0 20px 40px rgba(0, 212, 255, 0.2);
        }
        .staking-card.hot {
            border-color: var(--gold);
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.05), rgba(37, 99, 235, 0.05));
        }
        .staking-card.hot::before {
            background: linear-gradient(90deg, var(--gold), #FFA500);
            transform: scaleX(1);
        }
        .hot-badge {
            position: absolute;
            top: 16px; right: 16px;
            padding: 6px 14px;
            background: linear-gradient(135deg, var(--gold), #FFA500);
            color: #000;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .crypto-icon-lg {
            width: 80px; height: 80px;
            border-radius: 24px;
            display: flex; align-items: center; justify-content: center;
            font-size: 2.2rem;
            margin-bottom: 24px;
            position: relative;
        }
        .crypto-pnc {
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.2), rgba(255, 165, 0, 0.1));
            color: var(--gold);
            border: 1px solid rgba(255, 215, 0, 0.3);
        }
        .crypto-btc { background: linear-gradient(135deg, rgba(247, 147, 26, 0.2), rgba(247, 147, 26, 0.05)); color: #F7931A; border: 1px solid rgba(247, 147, 26, 0.3); }
        .crypto-eth { background: linear-gradient(135deg, rgba(98, 126, 234, 0.2), rgba(98, 126, 234, 0.05)); color: #627EEA; border: 1px solid rgba(98, 126, 234, 0.3); }
        .crypto-usdt { background: linear-gradient(135deg, rgba(38, 161, 123, 0.2), rgba(38, 161, 123, 0.05)); color: #26A17B; border: 1px solid rgba(38, 161, 123, 0.3); }
        .crypto-sol { background: linear-gradient(135deg, rgba(153, 69, 255, 0.2), rgba(38, 232, 181, 0.1)); color: #9945FF; border: 1px solid rgba(153, 69, 255, 0.3); }

        .apy-display {
            font-size: 3.5rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--accent), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: 16px 0;
            line-height: 1;
        }
        .apy-display small {
            font-size: 1rem;
            color: var(--text-gray);
            -webkit-text-fill-color: var(--text-gray);
        }

        .staking-details {
            margin: 24px 0;
        }
        .staking-detail-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid var(--glass-border);
            font-size: 0.9rem;
        }
        .staking-detail-row:last-child { border-bottom: none; }
        .staking-detail-row .label { color: var(--text-muted); }
        .staking-detail-row .value { color: var(--text-white); font-weight: 600; }

        .total-staked-bar {
            margin-top: 20px;
            padding: 16px;
            background: rgba(0, 0, 0, 0.2);
            border-radius: var(--radius-md);
        }
        .total-staked-bar .label {
            font-size: 0.75rem;
            color: var(--text-muted);
            text-transform: uppercase;
            margin-bottom: 6px;
        }
        .total-staked-bar .value {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--text-white);
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
            font-size: 3rem;
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

        .comparison-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 30px;
            text-align: center;
            transition: all 0.3s ease;
        }
        .comparison-card:hover {
            transform: translateY(-5px);
            border-color: var(--secondary);
        }
        .comparison-card h5 {
            color: var(--text-white);
            margin-bottom: 20px;
        }
        .comparison-card .metric {
            font-size: 2rem;
            font-weight: 700;
            color: var(--accent);
            margin: 12px 0;
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Hero -->
    <section class="staking-hero hero-section">
        <canvas id="three-canvas"></canvas>
        <div class="container position-relative" style="z-index: 2;">
            <div class="row justify-content-center text-center">
                <div class="col-lg-8 hero-content" data-aos="fade-up">
                    <div class="hero-badge">
                        <i class="fas fa-coins me-2"></i> Earn Passive Income
                    </div>
                    <h1 class="hero-title">
                        Flexible Staking with <br><span>Up to 730% APY</span>
                    </h1>
                    <p class="hero-subtitle mx-auto">
                        Stake your USDT and other crypto assets to earn predictable rewards with flexible lock periods. Auto-compound or claim manually.
                    </p>
                    <div class="d-flex gap-3 justify-content-center flex-wrap" data-aos="fade-up" data-aos-delay="200">
                        <a href="#pools" class="btn btn-primary-glow">
                            <i class="fas fa-bolt me-2"></i> Start Staking
                        </a>
                        <a href="#calculator" class="btn btn-outline-glass">
                            <i class="fas fa-calculator me-2"></i> Calculate Rewards
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Stats -->
    <section class="section-padding" style="padding-top: 40px;">
        <div class="container">
            <div class="row g-4">
                <div class="col-6 col-md-3" data-aos="fade-up">
                    <div class="glass-card p-4 text-center">
                        <h3 class="text-white mb-1">2.5M+</h3>
                        <small class="text-muted">Total Staked (USDT)</small>
                    </div>
                </div>
                <div class="col-6 col-md-3" data-aos="fade-up" data-aos-delay="100">
                    <div class="glass-card p-4 text-center">
                        <h3 class="text-white mb-1">18,500+</h3>
                        <small class="text-muted">Active Stakers</small>
                    </div>
                </div>
                <div class="col-6 col-md-3" data-aos="fade-up" data-aos-delay="200">
                    <div class="glass-card p-4 text-center">
                        <h3 class="text-white mb-1">450K+</h3>
                        <small class="text-muted">Rewards Paid (USDT)</small>
                    </div>
                </div>
                <div class="col-6 col-md-3" data-aos="fade-up" data-aos-delay="300">
                    <div class="glass-card p-4 text-center">
                        <h3 class="text-white mb-1">99.9%</h3>
                        <small class="text-muted">Uptime</small>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Staking Pools -->
    <section id="pools" class="section-padding">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">Active Staking Pools</h2>
            <p class="section-subtitle" data-aos="fade-up">Choose a pool and start earning rewards today</p>

            <div class="row g-4">
                <asp:Repeater ID="rptPools" runat="server">
                    <ItemTemplate>
                        <div class="col-md-6 col-lg-4" data-aos="fade-up">
                            <div class='staking-card <%# Convert.ToBoolean(Eval("IsHot")) ? "hot" : "" %>'>
                                <%# Convert.ToBoolean(Eval("IsHot")) ? "<span class='hot-badge'><i class='fas fa-fire me-1'></i> Hot Pool</span>" : "" %>
                                
                                <div class='crypto-icon-lg <%# GetCryptoClass(Eval("CurrencyCode")) %>'>
                                    <i class='<%# GetCryptoIcon(Eval("CurrencyCode")) %>'></i>
                                </div>

                                <h4 class="text-white mb-1"><%# Eval("PlanName") %></h4>
                                <p class="text-gray small mb-0">Stake <%# Eval("CurrencyCode") %> and earn</p>

                                <div class="apy-display">
                                    <%# string.Format("{0:0.##}", Eval("APY")) %>%
                                    <small>APY</small>
                                </div>

                                <div class="staking-details">
                                    <div class="staking-detail-row">
                                        <span class="label">Lock Period</span>
                                        <span class="value"><%# Eval("LockPeriodDays") %> Days</span>
                                    </div>
                                    <div class="staking-detail-row">
                                        <span class="label">Min Stake</span>
                                        <span class="value"><%# string.Format("{0:0.##}", Eval("MinAmount")) %> <%# Eval("CurrencyCode") %></span>
                                    </div>
                                    <div class="staking-detail-row">
                                        <span class="label">Max Stake</span>
                                        <span class="value"><%# string.Format("{0:0.##}", Eval("MaxAmount")) %> <%# Eval("CurrencyCode") %></span>
                                    </div>
                                    <div class="staking-detail-row">
                                        <span class="label">Auto-Compound</span>
                                        <span class="value" style="color: var(--accent);">
                                            <%# Convert.ToBoolean(Eval("AutoCompound")) ? "✓ Enabled" : "✗ Manual" %>
                                        </span>
                                    </div>
                                </div>

                                <div class="total-staked-bar">
                                    <div class="label">Total Staked in Pool</div>
                                    <div class="value">
                                        <i class="fas fa-coins me-2" style="color: var(--gold);"></i>
                                        <%# Eval("TotalStakedFormatted") %>
                                    </div>
                                </div>

                                <a href="<%= ResolveUrl("~/User/Staking.aspx") %>" class="btn btn-primary-glow w-100 mt-4">
                                    <i class="fas fa-bolt me-2"></i> Stake Now
                                </a>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <!-- Staking Calculator -->
    <section id="calculator" class="section-padding" style="background: var(--bg-secondary);">
        <div class="container">
            <div class="row align-items-center g-5">
                <div class="col-lg-6" data-aos="fade-right">
                    <h2 class="section-title text-start">Staking Calculator</h2>
                    <p class="text-start text-gray">Estimate your potential earnings based on stake amount and lock period.</p>

                    <div class="calculator-card mt-4">
                        <div class="mb-4">
                            <label class="form-label text-white">Stake Amount (USDT)</label>
                            <asp:TextBox ID="txtStakeAmount" runat="server" CssClass="form-control form-control-glass" TextMode="Number" Text="00"></asp:TextBox>
                        </div>
                        <div class="mb-4">

                            <label class="form-label text-white">Select Pool</label>
                            <asp:DropDownList ID="ddlPool" runat="server" CssClass="form-select form-control-glass" AutoPostBack="true" OnSelectedIndexChanged="CalculateStaking"></asp:DropDownList>
                        </div>
                        <div class="mb-4">
                            <label class="form-label text-white">Lock Period (Days)</label>
                            <asp:TextBox ID="txtDays" runat="server" CssClass="form-control form-control-glass" TextMode="Number" Text="90"></asp:TextBox>
                        </div>
                        <asp:Button ID="btnCalculate" runat="server" Text="Calculate Earnings" CssClass="btn btn-primary-glow w-100" OnClick="CalculateStaking" />

                        <div class="result-box mt-4">
                            <small class="text-muted text-uppercase">Estimated Total Rewards</small>
                            <div class="result-value">
                                <asp:Literal ID="litReward" runat="server" Text="0.00 USDT"></asp:Literal>
                            </div>
                            <small class="text-gray">
                                Effective APY: <strong class="text-white">
                                    <asp:Literal ID="litAPY" runat="server" Text="0.00%"></asp:Literal>
                                </strong>
                            </small>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6" data-aos="fade-left">
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="comparison-card">
                                <i class="fas fa-calendar-day fa-2x text-secondary mb-3"></i>
                                <h5>Daily Reward</h5>
                                <div class="metric">
                                    <asp:Literal ID="litDaily" runat="server" Text="0.00"></asp:Literal>
                                </div>
                                <small class="text-gray">
                                    <asp:Literal ID="litDailyCurrency" runat="server" Text="USDT"></asp:Literal>
                                </small>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="comparison-card">
                                <i class="fas fa-calendar-week fa-2x text-secondary mb-3"></i>
                                <h5>Weekly Reward</h5>
                                <div class="metric">
                                    <asp:Literal ID="litWeekly" runat="server" Text="0.00"></asp:Literal>
                                </div>
                                <small class="text-gray">
                                    <asp:Literal ID="litWeeklyCurrency" runat="server" Text="USDT"></asp:Literal>
                                </small>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="comparison-card">
                                <i class="fas fa-calendar-alt fa-2x text-secondary mb-3"></i>
                                <h5>Monthly Reward</h5>
                                <div class="metric">
                                    <asp:Literal ID="litMonthly" runat="server" Text="0.00"></asp:Literal>
                                </div>
                                <small class="text-gray">
                                    <asp:Literal ID="litMonthlyCurrency" runat="server" Text="USDT"></asp:Literal>
                                </small>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="comparison-card">
                                <i class="fas fa-calendar fa-2x text-secondary mb-3"></i>
                                <h5>Yearly Reward</h5>
                                <div class="metric">
                                    <asp:Literal ID="litYearly" runat="server" Text="0.00"></asp:Literal>
                                </div>
                                <small class="text-gray">
                                    <asp:Literal ID="litYearlyCurrency" runat="server" Text="USDT"></asp:Literal>
                                </small>
                            </div>
                        </div>
                    </div>

                    <div class="glass-card p-4 mt-4">
                        <h5 class="text-white mb-3">Projected Growth</h5>
                        <div style="height: 250px;">
                            <canvas id="stakingChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Why Stake with MEXIFY -->
    <section class="section-padding">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">Why Stake with MEXIFY?</h2>
            <p class="section-subtitle" data-aos="fade-up">Industry-leading staking infrastructure</p>

            <div class="row g-4">
                <div class="col-md-6 col-lg-3" data-aos="fade-up">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="benefit-icon"><i class="fas fa-shield-alt"></i></div>
                        <h5 class="text-white">Bank-Grade Security</h5>
                        <p class="text-gray small">95% of assets stored in cold wallets with multi-sig protection.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="100">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="benefit-icon"><i class="fas fa-sync-alt"></i></div>
                        <h5 class="text-white">Auto-Compound</h5>
                        <p class="text-gray small">Automatically reinvest rewards for exponential growth.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="200">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="benefit-icon"><i class="fas fa-clock"></i></div>
                        <h5 class="text-white">Flexible Terms</h5>
                        <p class="text-gray small">Choose lock periods from 7 to 365 days based on your needs.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="300">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="benefit-icon"><i class="fas fa-chart-line"></i></div>
                        <h5 class="text-white">High APY</h5>
                        <p class="text-gray small">Earn up to 18% APY on top cryptocurrencies including PNC.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- How Staking Works -->
    <section class="section-padding" style="background: var(--bg-secondary);">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">How Staking Works</h2>
            <p class="section-subtitle" data-aos="fade-up">Start earning in 4 simple steps</p>

            <div class="row g-4">
                <div class="col-md-6 col-lg-3" data-aos="fade-up">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="feature-icon mx-auto">1</div>
                        <h5 class="text-white">Choose Pool</h5>
                        <p class="text-gray small">Select a staking pool based on APY and lock period.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="100">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="feature-icon mx-auto">2</div>
                        <h5 class="text-white">Stake Assets</h5>
                        <p class="text-gray small">Deposit your PNC or other supported cryptocurrencies.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="200">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="feature-icon mx-auto">3</div>
                        <h5 class="text-white">Earn Rewards</h5>
                        <p class="text-gray small">Receive daily rewards directly to your staking wallet.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="300">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="feature-icon mx-auto">4</div>
                        <h5 class="text-white">Claim or Compound</h5>
                        <p class="text-gray small">Withdraw rewards or auto-compound for higher returns.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA -->
    <section class="section-padding">
        <div class="container">
            <div class="glass-card p-5 text-center" data-aos="zoom-in" style="background: linear-gradient(135deg, rgba(37, 99, 235, 0.2), rgba(0, 255, 178, 0.1));">
                <i class="fas fa-coins fa-3x text-warning mb-3"></i>
                <h2 class="text-white mb-3">Start Earning with USDT Staking</h2>
                <p class="text-gray mb-4 mx-auto" style="max-width: 600px;">
                    Join thousands of stakers earning passive income on their PNC holdings with MEXIFY's secure staking platform.
                </p>
                <a href="<%= ResolveUrl("~/Web/MetaMaskLogin.aspx") %>" class="btn btn-primary-glow btn-lg">
                    Create Free Account <i class="fas fa-arrow-right ms-2"></i>
                </a>
            </div>
        </div>
    </section>

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        var stakingChartData = {
            labels: <%= GetChartLabels() %>,
            data: <%= GetChartData() %>
        };

        document.addEventListener('DOMContentLoaded', () => {
            if (document.getElementById('stakingChart')) {
                const ctx = document.getElementById('stakingChart').getContext('2d');
                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: stakingChartData.labels,
                        datasets: [{
                            label: 'Staked Value',
                            data: stakingChartData.data,
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
                                ticks: { color: '#6B758D', callback: (val) => val.toLocaleString() + ' USDT' }
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