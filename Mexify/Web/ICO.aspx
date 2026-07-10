
<%@ Page Title="ICO Launchpad" Language="C#" MasterPageFile="~/Web/MasterPages/Site.master" AutoEventWireup="true" CodeBehind="ICO.aspx.cs" Inherits="Mexify.Web.ICO" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="MEXIFY ICO Launchpad - Get early access to high-potential blockchain projects and token sales.">
    <style>
        .project-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            height: 100%;
        }
        .project-card:hover {
            transform: translateY(-10px);
            border-color: var(--secondary);
            box-shadow: 0 20px 40px rgba(0, 212, 255, 0.2);
        }
        .project-banner {
            height: 180px;
            background-size: cover;
            background-position: center;
            position: relative;
        }
        .project-banner::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(180deg, transparent 50%, rgba(7, 17, 31, 0.9) 100%);
        }
        .project-status {
            position: absolute;
            top: 16px; left: 16px;
            padding: 6px 14px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            z-index: 2;
        }
        .status-live {
            background: linear-gradient(135deg, #00FFB2, #00D4FF);
            color: #000;
            animation: pulse 2s ease-in-out infinite;
        }
        .status-upcoming {
            background: rgba(255, 215, 0, 0.2);
            color: var(--gold);
            border: 1px solid rgba(255, 215, 0, 0.4);
        }
        .status-completed {
            background: rgba(108, 117, 125, 0.3);
            color: var(--text-gray);
            border: 1px solid var(--glass-border);
        }
        @keyframes pulse {
            0%, 100% { box-shadow: 0 0 0 0 rgba(0, 255, 178, 0.4); }
            50% { box-shadow: 0 0 0 10px rgba(0, 255, 178, 0); }
        }
        .project-logo {
            position: absolute;
            bottom: -30px; left: 24px;
            width: 70px; height: 70px;
            border-radius: 18px;
            background: var(--bg-primary);
            border: 3px solid var(--bg-primary);
            object-fit: cover;
            z-index: 3;
        }
        .project-body {
            padding: 45px 24px 24px;
        }
        .project-title {
            color: var(--text-white);
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 4px;
        }
        .project-symbol {
            color: var(--secondary);
            font-size: 0.85rem;
            font-weight: 600;
            margin-bottom: 16px;
        }
        .project-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin: 20px 0;
            padding: 16px;
            background: rgba(0, 0, 0, 0.2);
            border-radius: var(--radius-md);
        }
        .project-stat-label {
            font-size: 0.7rem;
            color: var(--text-muted);
            text-transform: uppercase;
            margin-bottom: 4px;
        }
        .project-stat-value {
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--text-white);
        }
        .progress-wrap {
            margin: 16px 0;
        }
        .progress-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            font-size: 0.8rem;
        }
        .progress-info .raised { color: var(--accent); font-weight: 600; }
        .progress-info .goal { color: var(--text-muted); }
        .progress-bar-wrap {
            height: 10px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50px;
            overflow: hidden;
        }
        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--primary), var(--accent));
            border-radius: 50px;
            transition: width 1s ease;
            position: relative;
            overflow: hidden;
        }
        .progress-bar-fill::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            animation: shimmer 2s infinite;
        }
        @keyframes shimmer {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
        }
        .countdown-mini {
            display: flex;
            gap: 8px;
            margin-top: 12px;
        }
        .countdown-mini .unit {
            flex: 1;
            text-align: center;
            padding: 8px 4px;
            background: rgba(255, 215, 0, 0.05);
            border: 1px solid rgba(255, 215, 0, 0.2);
            border-radius: var(--radius-sm);
        }
        .countdown-mini .value {
            font-size: 1rem;
            font-weight: 700;
            color: var(--gold);
            display: block;
        }
        .countdown-mini .label {
            font-size: 0.6rem;
            color: var(--text-muted);
            text-transform: uppercase;
        }
        .featured-ico {
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.2), rgba(0, 255, 178, 0.1));
            border: 1px solid rgba(0, 212, 255, 0.3);
            border-radius: var(--radius-xl);
            padding: 40px;
            position: relative;
            overflow: hidden;
        }
        .featured-ico::before {
            content: '';
            position: absolute;
            top: -50%; right: -20%;
            width: 600px; height: 600px;
            background: radial-gradient(circle, rgba(0, 212, 255, 0.15) 0%, transparent 70%);
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Hero -->
    <section class="hero-section" style="min-height: 55vh;">
        <canvas id="three-canvas"></canvas>
        <div class="container position-relative" style="z-index: 2;">
            <div class="row justify-content-center text-center">
                <div class="col-lg-8 hero-content" data-aos="fade-up">
                    <div class="hero-badge">
                        <i class="fas fa-rocket me-2"></i> Token Launchpad
                    </div>
                    <h1 class="hero-title">
                        Invest in the Next <br><span>Generation of Blockchain</span>
                    </h1>
                    <p class="hero-subtitle mx-auto">
                        Get exclusive early access to vetted, high-potential blockchain projects before they hit public exchanges.
                    </p>
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
                        <h3 class="text-white mb-1">$48M+</h3>
                        <small class="text-muted">Total Raised</small>
                    </div>
                </div>
                <div class="col-6 col-md-3" data-aos="fade-up" data-aos-delay="100">
                    <div class="glass-card p-4 text-center">
                        <h3 class="text-white mb-1">45+</h3>
                        <small class="text-muted">Projects Launched</small>
                    </div>
                </div>
                <div class="col-6 col-md-3" data-aos="fade-up" data-aos-delay="200">
                    <div class="glass-card p-4 text-center">
                        <h3 class="text-white mb-1">12</h3>
                        <small class="text-muted">Live Projects</small>
                    </div>
                </div>
                <div class="col-6 col-md-3" data-aos="fade-up" data-aos-delay="300">
                    <div class="glass-card p-4 text-center">
                        <h3 class="text-white mb-1">98%</h3>
                        <small class="text-muted">Success Rate</small>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Featured ICO -->
    <section class="section-padding" style="padding-top: 40px;">
        <div class="container">
            <asp:Repeater ID="rptFeatured" runat="server">
                <ItemTemplate>
                    <div class="featured-ico" data-aos="zoom-in">
                        <div class="row align-items-center g-4 position-relative" style="z-index: 2;">
                            <div class="col-lg-7">
                                <span class="project-status status-live mb-3 d-inline-block">
                                    <i class="fas fa-circle me-1" style="font-size: 0.5rem;"></i> LIVE NOW
                                </span>
                                <h2 class="text-white mb-2"><%# Eval("ProjectName") %></h2>
                                <p class="text-gray mb-4"><%# Eval("Description") %></p>
                                
                                <div class="progress-wrap">
                                    <div class="progress-info">
                                        <span class="raised"><%# Eval("RaisedFormatted") %> Raised</span>
                                        <span class="goal">Goal: <%# Eval("HardCapFormatted") %></span>
                                    </div>
                                    <div class="progress-bar-wrap">
                                        <div class="progress-bar-fill" style="width: <%# Eval("ProgressPercent") %>%;"></div>
                                    </div>
                                </div>

                                <div class="row g-3 mt-2">
                                    <div class="col-4">
                                        <small class="text-muted d-block">Token Price</small>
                                        <strong class="text-white">$<%# string.Format("{0:0.####}", Eval("TokenPrice")) %></strong>
                                    </div>
                                    <div class="col-4">
                                        <small class="text-muted d-block">Min Investment</small>
                                        <strong class="text-white">$100</strong>
                                    </div>
                                    <div class="col-4">
                                        <small class="text-muted d-block">Chain</small>
                                        <strong class="text-white">Ethereum</strong>
                                    </div>
                                </div>

                                <div class="d-flex gap-3 mt-4 flex-wrap">
                                    <a href="#" class="btn btn-primary-glow">
                                        <i class="fas fa-bolt me-2"></i> Participate Now
                                    </a>
                                    <a href="#" class="btn btn-outline-glass">
                                        <i class="fas fa-file-alt me-2"></i> Whitepaper
                                    </a>
                                </div>
                            </div>
                            <div class="col-lg-5 text-center">
                                <img src='<%# Eval("LogoUrl") %>' 
                                     alt='<%# Eval("ProjectName") %>'
                                     class="img-fluid" 
                                     style="max-width: 280px; border-radius: 30px; box-shadow: 0 20px 60px rgba(0,0,0,0.5);"
                                     onerror="this.src='https://ui-avatars.com/api/?name=<%# Eval("TokenSymbol") %>&background=2563EB&color=fff&size=280&rounded=true'">
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </section>

    <!-- All Projects -->
    <section class="section-padding" style="background: var(--bg-secondary);">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">All ICO Projects</h2>
            <p class="section-subtitle" data-aos="fade-up">Discover upcoming, live, and completed token sales</p>

            <!-- Filter Tabs -->
            <div class="category-tabs mb-5" data-aos="fade-up">
                <span class="category-tab active" data-filter="all">All Projects</span>
                <span class="category-tab" data-filter="live">🔴 Live</span>
                <span class="category-tab" data-filter="upcoming">🟡 Upcoming</span>
                <span class="category-tab" data-filter="completed">⚪ Completed</span>
            </div>

            <div class="row g-4">
                <asp:Repeater ID="rptProjects" runat="server">
                    <ItemTemplate>
                        <div class="col-md-6 col-lg-4 ico-project" data-status='<%# GetStatusSlug(Eval("Status")) %>'>
                            <div class="project-card">
                                <div class="project-banner" style='background-image: url("<%# Eval("BannerUrl") %>");'>
                                    <span class='project-status <%# GetStatusClass(Eval("Status")) %>'>
                                        <%# GetStatusLabel(Eval("Status")) %>
                                    </span>
                                    <img src='<%# Eval("LogoUrl") %>' 
                                         alt='<%# Eval("ProjectName") %>'
                                         class="project-logo"
                                         onerror="this.src='https://ui-avatars.com/api/?name=<%# Eval("TokenSymbol") %>&background=2563EB&color=fff&size=100'">
                                </div>
                                <div class="project-body">
                                    <h4 class="project-title"><%# Eval("ProjectName") %></h4>
                                    <div class="project-symbol">
                                        <%# Eval("TokenSymbol") %> · <%# Eval("TokenName") %>
                                    </div>
                                    <p class="text-gray small"><%# Eval("ShortDescription") %></p>

                                    <div class="project-stats">
                                        <div>
                                            <div class="project-stat-label">Token Price</div>
                                            <div class="project-stat-value">$<%# string.Format("{0:0.####}", Eval("TokenPrice")) %></div>
                                        </div>
                                        <div>
                                            <div class="project-stat-label">Total Supply</div>
                                            <div class="project-stat-value"><%# Eval("TotalSupplyFormatted") %></div>
                                        </div>
                                        <div>
                                            <div class="project-stat-label">Soft Cap</div>
                                            <div class="project-stat-value"><%# Eval("SoftCapFormatted") %></div>
                                        </div>
                                        <div>
                                            <div class="project-stat-label">Hard Cap</div>
                                            <div class="project-stat-value"><%# Eval("HardCapFormatted") %></div>
                                        </div>
                                    </div>

                                    <div class="progress-wrap">
                                        <div class="progress-info">
                                            <span class="raised"><%# Eval("ProgressPercent") %>%</span>
                                            <span class="goal"><%# Eval("RaisedFormatted") %></span>
                                        </div>
                                        <div class="progress-bar-wrap">
                                            <div class="progress-bar-fill" style="width: <%# Eval("ProgressPercent") %>%;"></div>
                                        </div>
                                    </div>

                                    <asp:Panel runat="server" Visible='<%# Convert.ToInt32(Eval("Status")) == 1 %>'>
                                        <div class="countdown-mini" data-end='<%# Eval("EndDateIso") %>'>
                                            <div class="unit">
                                                <span class="value cd-days">00</span>
                                                <span class="label">Days</span>
                                            </div>
                                            <div class="unit">
                                                <span class="value cd-hours">00</span>
                                                <span class="label">Hours</span>
                                            </div>
                                            <div class="unit">
                                                <span class="value cd-mins">00</span>
                                                <span class="label">Mins</span>
                                            </div>
                                            <div class="unit">
                                                <span class="value cd-secs">00</span>
                                                <span class="label">Secs</span>
                                            </div>
                                        </div>
                                    </asp:Panel>

                                    <a href="#" class='btn <%# Convert.ToInt32(Eval("Status")) == 1 ? "btn-primary-glow" : "btn-outline-glass" %> w-100 mt-3'>
                                        <%# GetButtonLabel(Eval("Status")) %>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <!-- How to Participate -->
    <section class="section-padding">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">How to Participate</h2>
            <p class="section-subtitle" data-aos="fade-up">Join token sales in 4 simple steps</p>

            <div class="row g-4">
                <div class="col-md-6 col-lg-3" data-aos="fade-up">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="feature-icon mx-auto">1</div>
                        <h5 class="text-white">Complete KYC</h5>
                        <p class="text-gray small">Verify your identity to participate in token sales.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="100">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="feature-icon mx-auto">2</div>
                        <h5 class="text-white">Fund Wallet</h5>
                        <p class="text-gray small">Deposit USDT, ETH, or other supported tokens.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="200">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="feature-icon mx-auto">3</div>
                        <h5 class="text-white">Choose Project</h5>
                        <p class="text-gray small">Select an ICO project and review the whitepaper.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="300">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="feature-icon mx-auto">4</div>
                        <h5 class="text-white">Receive Tokens</h5>
                        <p class="text-gray small">Get tokens distributed based on vesting schedule.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            // Filter tabs
            const tabs = document.querySelectorAll('.category-tab');
            const items = document.querySelectorAll('.ico-project');
            tabs.forEach(tab => {
                tab.addEventListener('click', () => {
                    tabs.forEach(t => t.classList.remove('active'));
                    tab.classList.add('active');
                    const filter = tab.dataset.filter;
                    items.forEach(item => {
                        if (filter === 'all' || item.dataset.status === filter) {
                            item.style.display = '';
                        } else {
                            item.style.display = 'none';
                        }
                    });
                });
            });

            // Countdowns for live projects
            document.querySelectorAll('.countdown-mini').forEach(el => {
                const endDate = new Date(el.dataset.end).getTime();
                function update() {
                    const now = new Date().getTime();
                    const distance = endDate - now;
                    if (distance < 0) return;
                    const d = Math.floor(distance / (1000 * 60 * 60 * 24));
                    const h = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                    const m = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                    const s = Math.floor((distance % (1000 * 60)) / 1000);
                    el.querySelector('.cd-days').textContent = String(d).padStart(2, '0');
                    el.querySelector('.cd-hours').textContent = String(h).padStart(2, '0');
                    el.querySelector('.cd-mins').textContent = String(m).padStart(2, '0');
                    el.querySelector('.cd-secs').textContent = String(s).padStart(2, '0');
                }
                update();
                setInterval(update, 1000);
            });
        });
    </script>
</asp:Content>