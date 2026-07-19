<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="Investments.aspx.cs" Inherits="Mexify.Web.User.Investments" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
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
        .roi-card.featured {
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.15), rgba(0, 255, 178, 0.08));
            border: 2px solid var(--primary);
        }
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
        }
        .roi-rate {
            font-size: 5rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--accent), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: 16px 0;
            line-height: 1;
        }
        .roi-features { list-style: none; padding: 0; margin: 24px 0; }
        .roi-features li {
            padding: 12px 0;
            border-bottom: 1px solid var(--glass-border);
            color: var(--text-gray);
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .roi-features i { color: var(--accent); }

        .fee-breakdown {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 32px;
            margin-top: 32px;
        }
        .fee-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 14px 0;
            border-bottom: 1px solid var(--glass-border);
        }
        .fee-item:last-child { border-bottom: none; }
        .fee-item .label { color: var(--text-gray); font-size: 0.95rem; }
        .fee-item .value { color: var(--text-white); font-weight: 700; font-size: 1.05rem; }
        .fee-item .value.accent { color: var(--accent); }
        .fee-item .value.gold { color: var(--gold); }
        .fee-item .value.danger { color: #ff3b5c; }
        .fee-item.total {
            padding-top: 20px;
            margin-top: 8px;
            border-top: 2px solid var(--glass-border);
            border-bottom: none;
        }
        .fee-item.total .label { color: var(--text-white); font-weight: 700; font-size: 1.1rem; }
        .fee-item.total .value { font-size: 1.4rem; color: var(--accent); }

        .calculator-card {
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

        .reinvest-banner {
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.15), rgba(255, 165, 0, 0.08));
            border: 1px solid rgba(255, 215, 0, 0.3);
            border-radius: var(--radius-lg);
            padding: 24px;
            margin-top: 24px;
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .reinvest-icon {
            width: 60px; height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.2), rgba(255, 165, 0, 0.1));
            color: var(--gold);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.5rem;
            flex-shrink: 0;
        }
        .reinvest-title { color: var(--text-white); font-weight: 700; margin-bottom: 4px; }
        .reinvest-desc { color: var(--text-gray); font-size: 0.9rem; margin: 0; }

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

        .form-group-custom { margin-bottom: 20px; }
        .form-group-custom label { display: block; color: var(--text-white); font-size: 0.9rem; font-weight: 600; margin-bottom: 8px; }
        .input-icon-wrap { position: relative; }
        .input-icon-wrap i { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: var(--text-muted); z-index: 2; }
        .input-icon-wrap input { width: 100%; padding: 12px 14px 12px 42px; background: rgba(255, 255, 255, 0.03); border: 1px solid var(--glass-border); border-radius: 10px; color: var(--text-white); font-size: 0.95rem; }
        .input-icon-wrap input:focus { outline: none; border-color: var(--secondary); background: rgba(0, 212, 255, 0.03); }

        @media (max-width: 768px) {
            .roi-rate { font-size: 3.5rem; }
            .fee-item .value { font-size: 0.95rem; }
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
                        <i class="fas fa-chart-line me-2"></i> 2X ROI Investment Plan
                    </div>
                    <h1 class="hero-title">
                        Double Your Investment in <br><span>Just 51 Days</span>
                    </h1>
                    <p class="hero-subtitle mx-auto">
                        Invest minimum 100 USDT with unlimited maximum. Earn 1.96% daily ROI with automatic reinvestment of profits.
                    </p>
                    <div class="d-flex gap-3 justify-content-center flex-wrap" data-aos="fade-up" data-aos-delay="200">
                        <a href="~/Web/User/Salary.aspx" runat="server" class="btn btn-primary-glow">
                            <i class="fas fa-rocket me-2"></i> Salary Plan
                        </a>
                        <a href="#calculator" class="btn btn-outline-glass">
                            <i class="fas fa-calculator me-2"></i> Calculate Returns
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Main Plan Card -->
    <section id="invest" class="section-padding">
        <div class="container">
            <div class="row g-4 justify-content-center">
                <div class="col-lg-8" data-aos="fade-up">
                    <div class="roi-card featured">
                        <span class="roi-badge">Most Popular</span>
                        
                        <div class="text-center mb-4">
                            <i class="fas fa-trophy fa-3x text-gold mb-3"></i>
                            <h2 class="text-white">2X ROI Plan</h2>
                            <div class="roi-rate">2X<small> in 51 days</small></div>
                            <p class="text-gray">1.96% Daily ROI · 100% Capital Return</p>
                        </div>

                        <div class="row g-3 mb-4">
                            <div class="col-6">
                                <div class="glass-card p-3 text-center">
                                    <small class="text-muted d-block">Minimum</small>
                                    <strong class="text-white">100 USDT</strong>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="glass-card p-3 text-center">
                                    <small class="text-muted d-block">Maximum</small>
                                    <strong class="text-white">Unlimited</strong>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="glass-card p-3 text-center">
                                    <small class="text-muted d-block">Duration</small>
                                    <strong class="text-white">51 Days</strong>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="glass-card p-3 text-center">
                                    <small class="text-muted d-block">Daily ROI</small>
                                    <strong class="text-accent">1.96%</strong>
                                </div>
                            </div>
                        </div>

                        <ul class="roi-features">
                            <li><i class="fas fa-check-circle"></i> 100% profit in 51 days (2X return)</li>
                            <li><i class="fas fa-check-circle"></i> Daily ROI distribution at 00:00 UTC</li>
                            <li><i class="fas fa-check-circle"></i> 100% capital returned at maturity</li>
                            <li><i class="fas fa-check-circle"></i> Auto-reinvest profit into new 2X plan</li>
                            <li><i class="fas fa-check-circle"></i> Instant withdrawals anytime</li>
                            <li><i class="fas fa-check-circle"></i> 5% direct referral commission</li>
                            <li><i class="fas fa-check-circle"></i> No maximum investment limit</li>
                        </ul>

                        <!-- Fee Breakdown -->
                        <div class="fee-breakdown">
                            <h4 class="text-white mb-3">
                                <i class="fas fa-receipt text-secondary me-2"></i>
                                Investment Distribution
                            </h4>
                            <p class="text-gray small mb-3">How your investment is allocated:</p>
                            
                            <div class="fee-item">
                                <span class="label"><i class="fas fa-coins text-accent me-2"></i> Investment Pool</span>
                                <span class="value accent"> 200% (Generates 2X)</span>
                            </div>
                            <div class="fee-item">
                                <span class="label"><i class="fas fa-arrow-down text-secondary me-2"></i> Deposit Fee</span>
                                <span class="value">15%</span>
                            </div>
                            <div class="fee-item">
                                <span class="label"><i class="fas fa-arrow-up text-secondary me-2"></i> Withdrawal Reserve</span>
                                <span class="value">15%</span>
                            </div>
                            <div class="fee-item">
                                <span class="label"><i class="fas fa-users text-gold me-2"></i> Direct Referral</span>
                                <span class="value gold">5%</span>
                            </div>
                            <div class="fee-item">
                                <span class="label"><i class="fas fa-shield-alt text-gold me-2"></i> Admin & Charges</span>
                                <span class="value gold">5%</span>
                            </div>
                            <div class="fee-item">
                                <span class="label"><i class="fas fa-certificate text-gold me-2"></i> Royalty</span>
                                <span class="value gold">5%</span>
                            </div>
                            <div class="fee-item total">
                                <span class="label">Total Distribution</span>
                                <span class="value">100%</span>
                            </div>
                        </div>

                        <!-- Auto-Reinvest Banner -->
                        <div class="reinvest-banner">
                            <div class="reinvest-icon">
                                <i class="fas fa-redo"></i>
                            </div>
                            <div>
                                <div class="reinvest-title">Automatic Reinvestment</div>
                                <p class="reinvest-desc">
                                    After 51 days, your principal is returned to your wallet and your profit is automatically reinvested into a new 2X ROI plan. This creates compound growth over time.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Calculator -->
                <div class="col-lg-4" data-aos="fade-left">
                    <div class="calculator-card" id="calculator">
                        <h4 class="text-white mb-3">Calculate Returns</h4>

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

                        <div class="form-group-custom">
                            <label>Investment Amount (USDT)</label>
                            <div class="input-icon-wrap">
                                <asp:TextBox ID="txtAmount" runat="server" TextMode="Number" Text="1000" min="100"></asp:TextBox>
                                <i class="fas fa-coins"></i>
                            </div>
                            <small class="text-muted">Minimum: 100 USDT · No maximum</small>
                        </div>

                        <asp:Button ID="btnCalculate" runat="server" Text="Calculate" CssClass="btn btn-primary-glow w-100" OnClick="btnCalculate_Click" />

                        <div class="result-display">
                            <small class="text-muted text-uppercase">Total Return (51 days)</small>
                            <div class="result-value">
                                <asp:Literal ID="litTotalReturn" runat="server" Text="0.00 USDT"></asp:Literal>
                            </div>
                            <div class="row g-2 mt-2">
                                <div class="col-6">
                                    <small class="text-muted">Daily ROI</small>
                                    <div class="text-white fw-bold"><asp:Literal ID="litDailyROI" runat="server" Text="0.00"></asp:Literal></div>
                                </div>
                                <div class="col-6">
                                    <small class="text-muted">Net Profit</small>
                                    <div class="text-accent fw-bold"><asp:Literal ID="litProfit" runat="server" Text="0.00"></asp:Literal></div>
                                </div>
                            </div>
                        </div>

                        <asp:Button ID="btnInvest" runat="server" Text="Invest Now" CssClass="btn btn-primary-glow w-100 mt-3" OnClick="btnInvest_Click" Visible="false" />
                    </div>
                </div>
            </div>
        </div>
    </section>

</asp:Content>