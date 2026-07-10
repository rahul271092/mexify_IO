<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="roi.aspx.cs" Inherits="Mexify.Web.roi" %>
<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="MEXIFY 2X ROI Plans - Earn up to 3.5% daily ROI with our institutional-grade investment plans.">
    <meta name="keywords" content="roi plans, daily returns, crypto investment, passive income, mexify">
    <style>
        .roi-hero { min-height: 60vh; position: relative; overflow: hidden; }
        .roi-hero::before {
            content: '';
            position: absolute;
            top: -50%; right: -20%;
            width: 800px; height: 800px;
            background: radial-gradient(circle, rgba(0, 255, 178, 0.1) 0%, transparent 70%);
            animation: float 10s ease-in-out infinite;
        }
        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-30px) rotate(5deg); }
        }

        .roi-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-xl);
            padding: 40px;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            overflow: hidden;
            height: 100%;
        }
        .roi-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 5px;
            background: linear-gradient(90deg, var(--primary), var(--accent));
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.4s ease;
        }
        .roi-card:hover::before { transform: scaleX(1); }
        .roi-card:hover {
            transform: translateY(-10px);
            border-color: var(--secondary);
            box-shadow: 0 20px 40px rgba(0, 212, 255, 0.2);
        }
        .roi-card.featured {
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.15), rgba(0, 255, 178, 0.08));
            border: 2px solid var(--primary);
            transform: scale(1.03);
        }
        .roi-card.featured:hover { transform: scale(1.03) translateY(-10px); }

        .roi-badge {
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

        .roi-icon {
            width: 90px; height: 90px;
            margin: 0 auto 24px;
            display: flex; align-items: center; justify-content: center;
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.2), rgba(0, 212, 255, 0.1));
            border-radius: 24px;
            font-size: 2.5rem;
            color: var(--secondary);
            border: 1px solid rgba(0, 212, 255, 0.2);
        }

        .roi-rate {
            font-size: 4rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--accent), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: 16px 0;
            line-height: 1;
        }
        .roi-rate small {
            font-size: 1.2rem;
            color: var(--text-gray);
            -webkit-text-fill-color: var(--text-gray);
        }

        .roi-features {
            list-style: none;
            padding: 0;
            margin: 24px 0;
            text-align: left;
        }
        .roi-features li {
            padding: 12px 0;
            border-bottom: 1px solid var(--glass-border);
            color: var(--text-gray);
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .roi-features li:last-child { border-bottom: none; }
        .roi-features i { color: var(--accent); font-size: 1.1rem; }

        .risk-badge {
            display: inline-block;
            padding: 6px 16px;
            border-radius: 50px;
            font-size: 0.8rem;
            font-weight: 600;
            margin-bottom: 16px;
        }
        .risk-low { background: rgba(0, 255, 178, 0.15); color: var(--accent); border: 1px solid rgba(0, 255, 178, 0.3); }
        .risk-medium { background: rgba(255, 215, 0, 0.15); color: var(--gold); border: 1px solid rgba(255, 215, 0, 0.3); }
        .risk-high { background: rgba(255, 59, 92, 0.15); color: #ff3b5c; border: 1px solid rgba(255, 59, 92, 0.3); }

        .roi-calculator {
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.1), rgba(0, 255, 178, 0.05));
            border: 1px solid rgba(0, 212, 255, 0.3);
            border-radius: var(--radius-xl);
            padding: 50px;
        }
        .result-display {
            background: linear-gradient(135deg, rgba(0, 255, 178, 0.1), rgba(0, 212, 255, 0.05));
            border: 1px solid rgba(0, 255, 178, 0.3);
            border-radius: var(--radius-lg);
            padding: 30px;
            text-align: center;
            margin-top: 24px;
        }
        .result-value {
            font-size: 3rem;
            font-weight: 800;
            color: var(--accent);
            margin: 12px 0;
        }

        .comparison-table {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            overflow: hidden;
        }
        .comparison-table table {
            width: 100%;
            color: var(--text-gray);
        }
        .comparison-table th {
            background: rgba(37, 99, 235, 0.1);
            padding: 18px;
            color: var(--text-white);
            font-weight: 600;
            text-align: center;
        }
        .comparison-table td {
            padding: 16px;
            text-align: center;
            border-bottom: 1px solid var(--glass-border);
        }
        .comparison-table tr:hover { background: rgba(255, 255, 255, 0.02); }

        .step-card {
            text-align: center;
            padding: 30px 20px;
        }
        .step-number {
            width: 60px; height: 60px;
            margin: 0 auto 20px;
            display: flex; align-items: center; justify-content: center;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 50%;
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-white);
        }

        section.section-padding:last-of-type .glass-card {
  opacity: 1 !important;
  transform: none !important;
}
    
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Hero -->
    <section class="roi-hero hero-section">
        <canvas id="three-canvas"></canvas>
        <div class="container position-relative" style="z-index: 2;">
            <div class="row justify-content-center text-center">
                <div class="col-lg-8 hero-content" data-aos="fade-up">
                    <div class="hero-badge">
                        <i class="fas fa-chart-line me-2"></i> 2X ROI Investment Plans
                    </div>
                    <h1 class="hero-title">
                        Double Your Investment with <br><span>Daily ROI Plans</span>
                    </h1>
                    <p class="hero-subtitle mx-auto">
                        Earn up to 3.5% daily ROI with our institutional-grade investment plans. Automated daily distributions, capital return, and instant withdrawals.
                    </p>
                    <div class="d-flex gap-3 justify-content-center flex-wrap" data-aos="fade-up" data-aos-delay="200">
                        <a href="#plans" class="btn btn-primary-glow">
                            <i class="fas fa-rocket me-2"></i> Start Investing
                        </a>
                        <a href="#calculator" class="btn btn-outline-glass">
                            <i class="fas fa-calculator me-2"></i> Calculate Returns
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
                        <h3 class="text-white mb-1">$125M+</h3>
                        <small class="text-muted">Total Invested</small>
                    </div>
                </div>
                <div class="col-6 col-md-3" data-aos="fade-up" data-aos-delay="100">
                    <div class="glass-card p-4 text-center">
                        <h3 class="text-white mb-1">45K+</h3>
                        <small class="text-muted">Active Investors</small>
                    </div>
                </div>
                <div class="col-6 col-md-3" data-aos="fade-up" data-aos-delay="200">
                    <div class="glass-card p-4 text-center">
                        <h3 class="text-white mb-1">$38M+</h3>
                        <small class="text-muted">ROI Distributed</small>
                    </div>
                </div>
                <div class="col-6 col-md-3" data-aos="fade-up" data-aos-delay="300">
                    <div class="glass-card p-4 text-center">
                        <h3 class="text-white mb-1">99.9%</h3>
                        <small class="text-muted">Success Rate</small>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Investment Plans -->
    <section id="plans" class="section-padding">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">Choose Your ROI Plan</h2>
            <p class="section-subtitle" data-aos="fade-up">Tailored strategies for every investment size</p>

            <div class="row g-4 justify-content-center">
                <asp:Repeater ID="rptPlans" runat="server">
                    <ItemTemplate>
                        <div class="col-md-6 col-lg-4" data-aos="fade-up">
                            <div class='roi-card <%# Eval("PlanName").ToString().Contains("Gold") ? "featured" : "" %>'>
                                <%# Eval("PlanName").ToString().Contains("Gold") ? "<span class='roi-badge'>Most Popular</span>" : "" %>
                                
                                <div class="roi-icon">
                                    <i class='<%# GetPlanIcon(Eval("PlanName").ToString()) %>'></i>
                                </div>
                                
                                <h3 class="text-white text-center"><%# Eval("PlanName") %></h3>
                                
                                <div class="roi-rate text-center">
                                    <%# string.Format("{0:0.##}", Eval("DailyROI")) %>%
                                    <small>/day</small>
                                </div>
                                
                                <p class="text-gray text-center">Duration: <strong class="text-white"><%# Eval("DurationDays") %> Days</strong></p>
                                
                                <div class="text-center">
                                    <span class='risk-badge <%# GetRiskClass(Eval("RiskLevel")) %>'>
                                        <%# GetRiskLabel(Eval("RiskLevel")) %> Risk
                                    </span>
                                </div>

                              <ul class="roi-features">
    <li><i class="fas fa-check-circle"></i> Min: <%# string.Format("{0:0.##}", Eval("MinAmount")) %> PNC</li>
    <li><i class="fas fa-check-circle"></i> Max: <%# string.Format("{0:0.##}", Eval("MaxAmount")) %> PNC</li>
    <li><i class="fas fa-check-circle"></i> Total ROI: <%# string.Format("{0:0.##}", Eval("TotalROIPercent")) %>%</li>
    <li><i class="fas fa-check-circle"></i> Capital Return: <%# Eval("CapitalReturnPercent") %>%</li>
    <li><i class="fas fa-check-circle"></i> Daily ROI Distribution</li>
    <li><i class="fas fa-check-circle"></i> Instant Withdrawals</li>
    <li><i class="fas fa-check-circle"></i> 24/7 Support</li>
</ul>

                                <a href='<%# ResolveUrl("~/register.aspx?plan=" + Eval("PlanId")) %>' 
                                   class='btn <%# Eval("PlanName").ToString().Contains("Gold") ? "btn-primary-glow" : "btn-outline-glass" %> w-100'>
                                    Invest Now <i class="fas fa-arrow-right ms-2"></i>
                                </a>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <!-- ROI Calculator -->
    <section id="calculator" class="section-padding" style="background: var(--bg-secondary);">
        <div class="container">
            <div class="row align-items-center g-5">
                <div class="col-lg-6" data-aos="fade-right">
                    <h2 class="section-title text-start">ROI Calculator</h2>
                    <p class="text-start text-gray">Calculate your potential returns based on investment amount and plan duration.</p>

                    <div class="roi-calculator mt-4">
                        <div class="mb-4">
                            <label class="form-label text-white">Investment Amount (PNC)</label>
                            <asp:TextBox ID="txtAmount" runat="server" CssClass="form-control form-control-glass" TextMode="Number" Text="10000000" min="100"></asp:TextBox>
                        </div>
                        <div class="mb-4">
                            <label class="form-label text-white">Select Plan</label>
                            <asp:DropDownList ID="ddlPlan" runat="server" CssClass="form-select form-control-glass" AutoPostBack="true" OnSelectedIndexChanged="CalculateROI"></asp:DropDownList>
                        </div>
                        <asp:Button ID="btnCalculate" runat="server" Text="Calculate Returns" CssClass="btn btn-primary-glow w-100" OnClick="CalculateROI" />

          <div class="result-display">
    <small class="text-muted text-uppercase">Estimated Total Profit</small>
    <div class="result-value">
        <asp:Literal ID="litProfit" runat="server" Text="0.00 PNC"></asp:Literal>
    </div>
    <small class="text-gray">
        Total Payout: <strong class="text-white">
            <asp:Literal ID="litTotal" runat="server" Text="0.00 PNC"></asp:Literal>
        </strong>
    </small>
</div>
                    </div>
                </div>

                <div class="col-lg-6" data-aos="fade-left">
                    <div class="glass-card p-4">
                        <h5 class="text-white mb-3">Projected Growth</h5>
                        <div style="height: 350px;">
                            <canvas id="roiChart"></canvas>
                        </div>
                    </div>

                    <div class="row g-3 mt-3">
                        <div class="col-6">
                            <div class="glass-card p-3 text-center">
                                <small class="text-muted d-block">Daily Profit</small>
                                <h5 class="text-white mb-0">
                                    <asp:Literal ID="litDaily" runat="server" Text="$0.00"></asp:Literal>
                                </h5>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="glass-card p-3 text-center">
                                <small class="text-muted d-block">Monthly Profit</small>
                                <h5 class="text-white mb-0">
                                    <asp:Literal ID="litMonthly" runat="server" Text="$0.00"></asp:Literal>
                                </h5>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- How It Works -->
    <section class="section-padding">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">How It Works</h2>
            <p class="section-subtitle" data-aos="fade-up">Start earning in 4 simple steps</p>

            <div class="row g-4">
                <div class="col-md-6 col-lg-3" data-aos="fade-up">
                    <div class="glass-card step-card h-100">
                        <div class="step-number">1</div>
                        <h5 class="text-white">Register</h5>
                        <p class="text-gray small">Create your free MEXIFY account in minutes.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="100">
                    <div class="glass-card step-card h-100">
                        <div class="step-number">2</div>
                        <h5 class="text-white">Deposit</h5>
                        <p class="text-gray small">Fund your wallet with crypto or fiat.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="200">
                    <div class="glass-card step-card h-100">
                        <div class="step-number">3</div>
                        <h5 class="text-white">Invest</h5>
                        <p class="text-gray small">Choose your preferred ROI plan.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="300">
                    <div class="glass-card step-card h-100">
                        <div class="step-number">4</div>
                        <h5 class="text-white">Earn</h5>
                        <p class="text-gray small">Receive daily ROI directly to your wallet.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- FAQ -->
    <section class="section-padding" style="background: var(--bg-secondary);">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">ROI Plan FAQs</h2>
            <p class="section-subtitle" data-aos="fade-up">Common questions about our ROI plans</p>

            <div class="accordion accordion-flush" id="roiFAQ">
                <div class="accordion-item glass-card mb-3 border-0" data-aos="fade-up">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed bg-transparent text-white" type="button" data-bs-toggle="collapse" data-bs-target="#faq1">
                            How are ROI distributions calculated?
                        </button>
                    </h2>
                    <div id="faq1" class="accordion-collapse collapse" data-bs-parent="#roiFAQ">
                        <div class="accordion-body text-gray">
                            ROI is calculated daily based on your invested amount and the plan's daily ROI percentage. For example, if you invest $10,000 in a plan with 2% daily ROI, you'll earn $200 per day.
                        </div>
                    </div>
                </div>
                <div class="accordion-item glass-card mb-3 border-0" data-aos="fade-up">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed bg-transparent text-white" type="button" data-bs-toggle="collapse" data-bs-target="#faq2">
                            When do I receive my ROI?
                        </button>
                    </h2>
                    <div id="faq2" class="accordion-collapse collapse" data-bs-parent="#roiFAQ">
                        <div class="accordion-body text-gray">
                            ROI is distributed automatically every day at 00:00 UTC directly to your ROI wallet. You can withdraw or reinvest at any time.
                        </div>
                    </div>
                </div>
                <div class="accordion-item glass-card mb-3 border-0" data-aos="fade-up">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed bg-transparent text-white" type="button" data-bs-toggle="collapse" data-bs-target="#faq3">
                            Is my capital returned at the end?
                        </button>
                    </h2>
                    <div id="faq3" class="accordion-collapse collapse" data-bs-parent="#roiFAQ">
                        <div class="accordion-body text-gray">
                            Yes! At the end of your plan duration, your initial capital is returned to your wallet along with all accumulated ROI earnings.
                        </div>
                    </div>
                </div>
                <div class="accordion-item glass-card mb-3 border-0" data-aos="fade-up">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed bg-transparent text-white" type="button" data-bs-toggle="collapse" data-bs-target="#faq4">
                            Can I withdraw my ROI before the plan ends?
                        </button>
                    </h2>
                    <div id="faq4" class="accordion-collapse collapse" data-bs-parent="#roiFAQ">
                        <div class="accordion-body text-gray">
                            Yes, you can withdraw your accumulated ROI at any time. However, your initial investment remains locked until the plan matures.
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

  <section class="section-padding">
    <div class="container">
        <div class="glass-card cta-card p-5 text-center" data-aos="zoom-in">
            <i class="fas fa-rocket fa-3x mb-3"></i>
            <h2 class="text-white mb-3">Ready to Start Earning?</h2>
            <p class="text-gray mb-4 mx-auto" style="max-width: 600px;">
                Join thousands of investors earning daily ROI with MEXIFY's institutional-grade platform.
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
        // ROI Chart initialization will be handled by code-behind
        var roiChartData = {
            labels: <%= GetChartLabels() %>,
            data: <%= GetChartData() %>
        };

        document.addEventListener('DOMContentLoaded', () => {
            if (document.getElementById('roiChart')) {
                const ctx = document.getElementById('roiChart').getContext('2d');
                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: roiChartData.labels,
                        datasets: [{
                            label: 'Portfolio Value',
                            data: roiChartData.data,
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
                                ticks: { color: '#6B758D', callback: (val) => '$' + val.toLocaleString() }
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