<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Mexify.Web.Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
     <meta name="description" content="MEXIFY - The future of institutional-grade crypto asset management. AI-driven portfolio, enterprise mining, staking, NFTs, and royalty income.">
    <meta name="keywords" content="crypto, bitcoin, staking, mexify, nft, mining, defi, roi">
    <style>
        /* Page specific CSS overrides if needed */
        .swiper-pagination-bullet { background: var(--text-gray); opacity: 0.5; }
        .swiper-pagination-bullet-active { background: var(--secondary); opacity: 1; }

        section.section-padding:last-of-type .glass-card {
  opacity: 1 !important;
  transform: none !important;
}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

      <!-- =========================================
         1. HERO SECTION
         ========================================= -->
    <section class="hero-section">
        <canvas id="three-canvas"></canvas>
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-7 hero-content" data-aos="fade-right" data-aos-duration="1000">
                    <div class="hero-badge">
                        <i class="fas fa-shield-alt me-2"></i> Institutional-Grade Security
                    </div>
                    <h1 class="hero-title">
                        The Future of <br><span>Crypto Asset Management</span>
                    </h1>
                    <p class="hero-subtitle">
                        Institutional-grade crypto investment solutions with AI-driven portfolio management, enterprise mining, staking, NFTs, ICO participation, and royalty income.
                    </p>
                    <div class="d-flex gap-3 flex-wrap">
                        <a href="<%= ResolveUrl("~/register.aspx") %>" class="btn btn-primary-glow">
                            Start Investing <i class="fas fa-arrow-right ms-2"></i>
                        </a>
                        <a href="#features" class="btn btn-outline-glass">
                            <i class="fas fa-play-circle me-2"></i> Explore Platform
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- =========================================
         2. COMPANY STATS (Animated Counters)
         ========================================= -->
   <%-- <section class="section-padding bg-secondary" style="background: var(--bg-secondary);">
        <div class="container">
            <div class="row g-4 text-center">
                <div class="col-6 col-md-3" data-aos="fade-up">
                    <div class="glass-card p-4">
                        <h2 class="text-white counter" data-target="150000">0</h2>
                        <p class="text-gray mb-0">Global Investors</p>
                    </div>
                </div>
                <div class="col-6 col-md-3" data-aos="fade-up" data-aos-delay="100">
                    <div class="glass-card p-4">
                        <h2 class="text-white">$<span class="counter" data-target="2500">0</span>M+</h2>
                        <p class="text-gray mb-0">Assets Managed</p>
                    </div>
                </div>
                <div class="col-6 col-md-3" data-aos="fade-up" data-aos-delay="200">
                    <div class="glass-card p-4">
                        <h2 class="text-white counter" data-target="120">0</h2>
                        <p class="text-gray mb-0">Countries Supported</p>
                    </div>
                </div>
                <div class="col-6 col-md-3" data-aos="fade-up" data-aos-delay="300">
                    <div class="glass-card p-4">
                        <h2 class="text-white counter" data-target="99">0</h2>
                        <p class="text-gray mb-0">Uptime %</p>
                    </div>
                </div>
            </div>
        </div>
    </section>--%>


    <!-- Company Stats Section -->
<section class="section-padding bg-secondary" style="background-color: rgba(0,212,255,0.2)!important">
    <div class="container">
        <div class="row g-4 text-center">
            <div class="col-6 col-md-3" data-aos="fade-up">
                <div class="glass-card p-4">
                    <h2 class="text-white counter" data-target="150000">0</h2>
                    <p class="text-gray mb-0">Global Investors</p>
                </div>
            </div>
            <div class="col-6 col-md-3" data-aos="fade-up" data-aos-delay="100">
                <div class="glass-card p-4">
                    <h2 class="text-white"><span class="counter" data-target="2500">0</span>M+ PNC</h2>
                    <p class="text-gray mb-0">Assets Managed</p>
                </div>
            </div>
            <div class="col-6 col-md-3" data-aos="fade-up" data-aos-delay="200">
                <div class="glass-card p-4">
                    <h2 class="text-white counter" data-target="120">0</h2>
                    <p class="text-gray mb-0">Countries Supported</p>
                </div>
            </div>
            <div class="col-6 col-md-3" data-aos="fade-up" data-aos-delay="300">
                <div class="glass-card p-4">
                    <h2 class="text-white counter" data-target="99">0</h2>
                    <p class="text-gray mb-0">Uptime %</p>
                </div>
            </div>
        </div>
    </div>
</section>

    <!-- =========================================
         3. FEATURES ECOSYSTEM
         ========================================= -->
    <section id="features" class="section-padding">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">Comprehensive Investment Ecosystem</h2>
            <p class="section-subtitle" data-aos="fade-up">Diversify your portfolio across multiple high-yield digital asset classes.</p>
            
            <div class="row g-4">
                <div class="col-md-6 col-lg-4" data-aos="fade-up" data-aos-delay="100">
                    <div class="glass-card p-4 h-100">
                        <div class="feature-icon"><i class="fas fa-chart-line"></i></div>
                        <h4>2X ROI Plans</h4>
                        <p>Accelerate wealth with intelligent, automated daily ROI investment strategies.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4" data-aos="fade-up" data-aos-delay="200">
                    <div class="glass-card p-4 h-100">
                        <div class="feature-icon"><i class="fas fa-coins"></i></div>
                        <h4>Flexible Staking</h4>
                        <p>Stake digital assets with flexible lock periods and high APY rewards.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4" data-aos="fade-up" data-aos-delay="300">
                    <div class="glass-card p-4 h-100">
                        <div class="feature-icon"><i class="fas fa-server"></i></div>
                        <h4>Enterprise Mining</h4>
                        <p>Institutional cloud mining powered by enterprise-grade infrastructure.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4" data-aos="fade-up" data-aos-delay="400">
                    <div class="glass-card p-4 h-100">
                        <div class="feature-icon"><i class="fas fa-cube"></i></div>
                        <h4>NFT Marketplace</h4>
                        <p>Invest, mint, and trade curated digital collectibles and fine art.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4" data-aos="fade-up" data-aos-delay="500">
                    <div class="glass-card p-4 h-100">
                        <div class="feature-icon"><i class="fas fa-rocket"></i></div>
                        <h4>ICO Launchpad</h4>
                        <p>Get early access to high-potential blockchain projects and token sales.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4" data-aos="fade-up" data-aos-delay="600">
                    <div class="glass-card p-4 h-100">
                        <div class="feature-icon"><i class="fas fa-certificate"></i></div>
                        <h4>Royalty Licenses</h4>
                        <p>Earn passive income through fractional digital asset licensing.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- =========================================
         4. INVESTMENT PLANS (DATABOUND FROM SQL)
         ========================================= -->
    <section id="plans" class="section-padding" style="background: var(--bg-secondary);">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">Choose Your Investment Plan</h2>
            <p class="section-subtitle" data-aos="fade-up">Tailored strategies for every portfolio size.</p>
            
            <div class="row g-4 justify-content-center">
                <asp:Repeater ID="rptPlans" runat="server">
                    <ItemTemplate>
                        <div class="col-md-6 col-lg-4" data-aos="fade-up">
                            <div class="glass-card pricing-card <%# Eval("PlanName").ToString() == "Gold" ? "featured" : "" %>">
                                <h4 class="text-white"><%# Eval("PlanName") %></h4>
                                <div class="price-tag my-3">
                                    <%# string.Format("{0:0.##}", Eval("DailyROI")) %>%
                                    <span>% Daily ROI</span>
                                </div>
                                <p class="text-gray">Duration: <%# Eval("DurationDays") %> Days</p>
                                <ul class="list-unstyled my-4 text-start">
                                    <li class="mb-2"><i class="fas fa-check text-accent me-2"></i> Min: $<%# string.Format("{0:0.##}", Eval("MinAmount")) %></li>
                                    <li class="mb-2"><i class="fas fa-check text-accent me-2"></i> Max: $<%# string.Format("{0:0.##}", Eval("MaxAmount")) %></li>
                                    <li class="mb-2"><i class="fas fa-check text-accent me-2"></i> Capital Return: <%# Eval("CapitalReturnPercent") %>%</li>
                                    <li class="mb-2"><i class="fas fa-check text-accent me-2"></i> Risk Level: <%# Eval("RiskLevel") %></li>
                                </ul>
                                <a href='<%# ResolveUrl("~/register.aspx?plan=" + Eval("PlanId")) %>' class="btn btn-primary-glow w-100">Invest Now</a>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <!-- =========================================
         5. ROI CALCULATOR (INTERACTIVE JS)
         ========================================= -->
    <section class="section-padding">
        <div class="container">
            <div class="row align-items-center g-5">
                <div class="col-lg-6" data-aos="fade-right">
                    <h2 class="section-title text-start">Calculate Your Potential Returns</h2>
                    <p class="text-start">Use our advanced calculator to project your earnings across our premium investment plans.</p>
                    
                    <div class="glass-card calculator-card mt-4">
                        <div class="mb-4">
                            <label class="form-label text-white">Investment Amount (USDT)</label>
                            <input type="number" id="calcAmount" class="form-control form-control-glass" value="10000" min="100">
                        </div>
                        <div class="mb-4">
                            <label class="form-label text-white">Select Plan</label>
                            <select id="calcPlan" class="form-select form-control-glass">
                                <option value="1.5" data-days="30">Starter (1.5% Daily / 30 Days)</option>
                                <option value="2.0" data-days="60">Silver (2.0% Daily / 60 Days)</option>
                                <option value="2.5" data-days="90" selected>Gold (2.5% Daily / 90 Days)</option>
                                <option value="3.0" data-days="120">Platinum (3.0% Daily / 120 Days)</option>
                            </select>
                        </div>
                        
                        <div class="row g-3 mt-2">
                            <div class="col-6">
                                <small class="text-muted">Total Profit</small>
                                <h3 class="text-white mb-0" id="resultProfit">$0.00</h3>
                            </div>
                            <div class="col-6">
                                <small class="text-muted">Total Payout</small>
                                <h3 class="text-accent mb-0" id="resultTotal">$0.00</h3>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6" data-aos="fade-left">
                    <div class="glass-card p-4">
                        <h5 class="text-white mb-3">Projected Growth</h5>
                        <div style="height: 300px;">
                            <canvas id="roiChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- =========================================
         6. TESTIMONIALS (DATABOUND SWIPER SLIDER)
         ========================================= -->
    <section class="section-padding" style="background: var(--bg-secondary);">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">Trusted by Global Investors</h2>
            <div class="swiper testimonial-swiper mt-5" data-aos="fade-up">
                <div class="swiper-wrapper">
                    <asp:Repeater ID="rptTestimonials" runat="server">
                        <ItemTemplate>
                            <div class="swiper-slide">
                                <div class="glass-card p-4 h-100">
                                    <div class="d-flex align-items-center mb-3">
                                        <img src='<%# Eval("PhotoUrl") %>' alt='<%# Eval("Name") %>' class="rounded-circle me-3" width="50" height="50" style="object-fit: cover;">
                                        <div>
                                            <h6 class="text-white mb-0"><%# Eval("Name") %></h6>
                                            <small class="text-muted"><%# Eval("Designation") %></small>
                                        </div>
                                    </div>
                                    <p class="text-gray fst-italic">"<%# Eval("Message") %>"</p>
                                    <div class="text-warning">
                                <%--        <%# RenderStars(Eval("Rating")) %>--%>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <div class="swiper-pagination"></div>
            </div>
        </div>
    </section>

    <!-- =========================================
         7. FAQ (DATABOUND ACCORDION)
         ========================================= -->
    <section id="faq" class="section-padding">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">Frequently Asked Questions</h2>
            <div class="accordion accordion-flush mt-5" id="faqAccordion" data-aos="fade-up">
                <asp:Repeater ID="rptFAQs" runat="server">
                    <ItemTemplate>
                        <div class="accordion-item glass-card mb-3 border-0">
                            <h2 class="accordion-header">
                                <button class="accordion-button collapsed bg-transparent text-white" type="button" data-bs-toggle="collapse" data-bs-target='#<%# "collapse" + Eval("FAQId") %>'>
                                    <%# Eval("Question") %>
                                </button>
                            </h2>
                            <div id='<%# "collapse" + Eval("FAQId") %>' class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                                <div class="accordion-body text-gray">
                                    <%# Eval("Answer") %>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <!-- =========================================
         8. CALL TO ACTION
         ========================================= -->
    <section class="section-padding">
        <div class="container">
            <div class="glass-card p-5 text-center" data-aos="zoom-in" style="background: linear-gradient(135deg, rgba(37, 99, 235, 0.2), rgba(0, 255, 178, 0.1));">
                <h2 class="text-white mb-3">Ready to Start Your Crypto Journey?</h2>
                <p class="text-gray mb-4 mx-auto" style="max-width: 600px;">Join over 150,000 investors globally who trust MEXIFY for secure, high-yield digital asset management.</p>
                <a href="<%= ResolveUrl("~/register.aspx") %>" class="btn btn-primary-glow btn-lg">Create Free Account</a>
            </div>
        </div>
    </section>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">

     <script src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.js"></script>
    <script>
        // Initialize Testimonial Swiper
        document.addEventListener('DOMContentLoaded', () => {
            if (document.querySelector('.testimonial-swiper')) {
                new Swiper('.testimonial-swiper', {
                    slidesPerView: 1,
                    spaceBetween: 30,
                    loop: true,
                    autoplay: { delay: 5000, disableOnInteraction: false },
                    pagination: { el: '.swiper-pagination', clickable: true },
                    breakpoints: {
                        768: { slidesPerView: 2 },
                        1024: { slidesPerView: 3 }
                    }
                });
            }

            // Initialize Animated Counters
            const counters = document.querySelectorAll('.counter');
            const speed = 200;
            counters.forEach(counter => {
                const updateCount = () => {
                    const target = +counter.getAttribute('data-target');
                    const count = +counter.innerText.replace(/[^0-9]/g, '');
                    const inc = target / speed;
                    if (count < target) {
                        counter.innerText = Math.ceil(count + inc);
                        setTimeout(updateCount, 20);
                    } else {
                        counter.innerText = target.toLocaleString();
                    }
                };
                updateCount();
            });
        });
    </script>

</asp:Content>
