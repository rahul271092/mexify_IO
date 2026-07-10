<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="royalty.aspx.cs" Inherits="Mexify.Web.royalty" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="MEXIFY Royalty Licenses - Earn passive income through digital asset licensing, patents, software rights, and fractional ownership certificates.">
    <meta name="keywords" content="royalty licensing, digital assets, patent licensing, software licensing, passive income, mexify">
    <style>
        .royalty-hero { min-height: 60vh; position: relative; overflow: hidden; }
        .royalty-hero::before {
            content: '';
            position: absolute;
            top: -50%; right: -20%;
            width: 800px; height: 800px;
            background: radial-gradient(circle, rgba(255, 215, 0, 0.15) 0%, transparent 70%);
            animation: float 10s ease-in-out infinite;
        }
        @keyframes float { 0%,100%{transform:translateY(0) rotate(0deg)} 50%{transform:translateY(-30px) rotate(5deg)} }

        .license-card {
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
        .license-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 4px;
            background: linear-gradient(90deg, var(--gold), #FFA500);
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.4s ease;
        }
        .license-card:hover::before { transform: scaleX(1); }
        .license-card:hover {
            transform: translateY(-10px);
            border-color: var(--gold);
            box-shadow: 0 20px 40px rgba(255, 215, 0, 0.15);
        }
        .license-badge {
            position: absolute;
            top: 16px; right: 16px;
            padding: 6px 14px;
            background: linear-gradient(135deg, var(--gold), #FFA500);
            color: #000;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
        }
        .license-icon {
            width: 80px; height: 80px;
            margin: 0 auto 24px;
            display: flex; align-items: center; justify-content: center;
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.2), rgba(255, 165, 0, 0.1));
            border-radius: 24px;
            font-size: 2.2rem;
            color: var(--gold);
            border: 1px solid rgba(255, 215, 0, 0.3);
        }
        .royalty-rate {
            font-size: 3rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--gold), #FF8C00);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: 16px 0;
            line-height: 1;
        }
        .royalty-rate small {
            font-size: 1rem;
            color: var(--text-gray);
            -webkit-text-fill-color: var(--text-gray);
        }
        .license-details { margin: 24px 0; }
        .license-detail-row {
            display: flex; justify-content: space-between;
            padding: 12px 0; border-bottom: 1px solid var(--glass-border);
            font-size: 0.9rem;
        }
        .license-detail-row:last-child { border-bottom: none; }
        .license-detail-row .label { color: var(--text-muted); }
        .license-detail-row .value { color: var(--text-white); font-weight: 600; }

        .ownership-badge {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 6px 12px;
            background: rgba(255, 215, 0, 0.1);
            border: 1px solid rgba(255, 215, 0, 0.3);
            border-radius: 50px;
            color: var(--gold);
            font-size: 0.75rem;
            font-weight: 600;
            margin-top: 16px;
        }

        .calculator-card {
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.1), rgba(37, 99, 235, 0.05));
            border: 1px solid rgba(255, 215, 0, 0.3);
            border-radius: var(--radius-xl);
            padding: 50px;
        }
        .result-box {
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.15), rgba(0, 212, 255, 0.05));
            border: 1px solid rgba(255, 215, 0, 0.4);
            border-radius: var(--radius-lg);
            padding: 30px;
            text-align: center;
        }
        .result-value {
            font-size: 3rem;
            font-weight: 800;
            color: var(--gold);
            margin: 12px 0;
        }

        .benefit-icon {
            width: 70px; height: 70px;
            margin: 0 auto 20px;
            display: flex; align-items: center; justify-content: center;
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.2), rgba(255, 165, 0, 0.1));
            border-radius: 20px;
            font-size: 1.8rem;
            color: var(--gold);
            border: 1px solid rgba(255, 215, 0, 0.3);
        }

        /* Reuse FAQ fix */
        .accordion-item { background: transparent !important; border: none !important; margin-bottom: 12px; border-radius: var(--radius-lg) !important; overflow: hidden; background: var(--glass-bg) !important; border: 1px solid var(--glass-border) !important; }
        .accordion-button { background: transparent !important; color: var(--text-white) !important; box-shadow: none !important; padding: 20px 24px !important; font-weight: 500; }
        .accordion-button:focus { box-shadow: none !important; }
        .accordion-button::after { background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='%23FFD700'%3e%3cpath fill-rule='evenodd' d='M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z'/%3e%3c/svg%3e") !important; filter: drop-shadow(0 0 4px rgba(255, 215, 0, 0.5)); }
        .accordion-button:not(.collapsed)::after { transform: rotate(-180deg); filter: drop-shadow(0 0 6px rgba(255, 165, 0, 0.7)); }
        .accordion-button:not(.collapsed) { background: linear-gradient(135deg, rgba(255, 215, 0, 0.1), rgba(37, 99, 235, 0.05)) !important; color: var(--gold) !important; }
        .accordion-body { background: rgba(0, 0, 0, 0.2) !important; color: var(--text-gray) !important; padding: 20px 24px !important; border-top: 1px solid var(--glass-border); }

        @media (max-width: 768px) { .royalty-hero { padding: 120px 0 60px; } }


        /* Ensure the accordion items are visible against the dark background */
#royaltyFAQ .accordion-item {
    background-color: transparent;
    border-bottom: 1px solid rgba(160, 170, 191, 0.2);
}

#royaltyFAQ .accordion-button {
    background-color: transparent;
    color: #ffffff;
    box-shadow: none;
}

#royaltyFAQ .accordion-button:not(.collapsed) {
    color: #64ffda; /* Example accent color */
    background-color: rgba(100, 255, 218, 0.05);
}

#royaltyFAQ .accordion-body {
    color: #a0aabf;
}



     section.section-padding:last-of-type .glass-card {
  opacity: 1 !important;
  transform: none !important;
}
    
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Hero -->
    <section class="royalty-hero hero-section">
        <canvas id="three-canvas"></canvas>
        <div class="container position-relative" style="z-index: 2;">
            <div class="row justify-content-center text-center">
                <div class="col-lg-8 hero-content" data-aos="fade-up">
                    <div class="hero-badge">
                        <i class="fas fa-file-contract me-2"></i> Digital Asset Licensing
                    </div>
                    <h1 class="hero-title">
                        Earn Passive Income with <br><span>Royalty Licenses</span>
                    </h1>
                    <p class="hero-subtitle mx-auto">
                        Fractional ownership in patents, software rights, media catalogs, and digital assets. Earn predictable royalty revenue with blockchain-backed transparency.
                    </p>
                    <div class="d-flex gap-3 justify-content-center flex-wrap" data-aos="fade-up" data-aos-delay="200">
                        <a href="#licenses" class="btn btn-primary-glow">
                            <i class="fas fa-search me-2"></i> Browse Licenses
                        </a>
                        <a href="<%= ResolveUrl("~/User/SubmitLicense.aspx") %>" class="btn btn-outline-glass">
                            <i class="fas fa-plus-circle me-2"></i> List Your Asset
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
                        <h3 class="text-white mb-1">4,200+</h3>
                        <small class="text-muted">Licenses Issued</small>
                    </div>
                </div>
                <div class="col-6 col-md-3" data-aos="fade-up" data-aos-delay="100">
                    <div class="glass-card p-4 text-center">
                        <h3 class="text-white mb-1">850K+</h3>
                        <small class="text-muted">PNC Distributed</small>
                    </div>
                </div>
                <div class="col-6 col-md-3" data-aos="fade-up" data-aos-delay="200">
                    <div class="glass-card p-4 text-center">
                        <h3 class="text-white mb-1">12%</h3>
                        <small class="text-muted">Avg. Royalty Yield</small>
                    </div>
                </div>
                <div class="col-6 col-md-3" data-aos="fade-up" data-aos-delay="300">
                    <div class="glass-card p-4 text-center">
                        <h3 class="text-white mb-1">100%</h3>
                        <small class="text-muted">Blockchain Verified</small>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- License Categories -->
    <section id="categories" class="section-padding">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">Licensing Categories</h2>
            <p class="section-subtitle" data-aos="fade-up">Diversify your royalty portfolio across asset classes</p>

            <div class="row g-4">
                <div class="col-md-6 col-lg-3" data-aos="fade-up">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="benefit-icon"><i class="fas fa-lightbulb"></i></div>
                        <h5 class="text-white">Patent Licensing</h5>
                        <p class="text-gray small">Fractional ownership in technology patents and IP portfolios.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="100">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="benefit-icon"><i class="fas fa-code"></i></div>
                        <h5 class="text-white">Software Rights</h5>
                        <p class="text-gray small">SaaS platforms, APIs, and enterprise software licensing revenue.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="200">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="benefit-icon"><i class="fas fa-music"></i></div>
                        <h5 class="text-white">Media Catalogs</h5>
                        <p class="text-gray small">Music rights, film royalties, and digital content licensing.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="300">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="benefit-icon"><i class="fas fa-building"></i></div>
                        <h5 class="text-white">Real Estate</h5>
                        <p class="text-gray small">Tokenized property leases and commercial rental income.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Available Licenses -->
    <section id="licenses" class="section-padding" style="background: var(--bg-secondary);">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">Available Licenses</h2>
            <p class="section-subtitle" data-aos="fade-up">Verified digital assets with transparent revenue sharing</p>

            <div class="row g-4">
                <asp:Repeater ID="rptLicenses" runat="server">
                    <ItemTemplate>
                        <div class="col-md-6 col-lg-4" data-aos="fade-up">
                            <div class="license-card">
                                <%# Convert.ToBoolean(Eval("IsPremium")) ? "<span class='license-badge'>Premium</span>" : "" %>
                                
                                <div class="license-icon">
                                    <i class='<%# GetLicenseIcon(Eval("AssetType")) %>'></i>
                                </div>

                                <h4 class="text-white mb-1"><%# Eval("Title") %></h4>
                                <p class="text-gray small"><%# Eval("Description") %></p>

                                <div class="royalty-rate">
                                    <%# string.Format("{0:0.##}", Eval("RoyaltyRate")) %>%
                                    <small>Annual Yield</small>
                                </div>

                                <div class="license-details">
                                    <div class="license-detail-row">
                                        <span class="label">Asset Type</span>
                                        <span class="value"><%# Eval("AssetType") %></span>
                                    </div>
                                    <div class="license-detail-row">
                                        <span class="label">Share Price</span>
                                        <span class="value" style="color: var(--gold);">
                                            <%# string.Format("{0:0.##}", Eval("SharePrice")) %> PNC
                                        </span>
                                    </div>
                                    <div class="license-detail-row">
                                        <span class="label">Available Shares</span>
                                        <span class="value"><%# Eval("SharesAvailable") %></span>
                                    </div>
                                    <div class="license-detail-row">
                                        <span class="label">Revenue Period</span>
                                        <span class="value">Quarterly</span>
                                    </div>
                                </div>

                                <div class="ownership-badge">
                                    <i class="fas fa-certificate"></i> Blockchain Ownership Certificate
                                </div>

                                <a href='<%# ResolveUrl("~/User/PurchaseLicense.aspx?id=" + Eval("LicenseId")) %>' class="btn btn-primary-glow w-100 mt-4">
                                    <i class="fas fa-hand-holding-usd me-2"></i> Invest Now
                                </a>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <!-- Royalty Calculator -->
    <section id="calculator" class="section-padding">
        <div class="container">
            <div class="row align-items-center g-5">
                <div class="col-lg-6" data-aos="fade-right">
                    <h2 class="section-title text-start">Royalty Revenue Calculator</h2>
                    <p class="text-start text-gray">Estimate your passive income based on share investment and annual yield.</p>

                    <div class="calculator-card mt-4">
                        <div class="mb-4">
                            <label class="form-label text-white">Number of Shares</label>
                            <asp:TextBox ID="txtShares" runat="server" CssClass="form-control form-control-glass" TextMode="Number" Text="50"></asp:TextBox>
                        </div>
                        <div class="mb-4">
                            <label class="form-label text-white">Select License</label>
                            <asp:DropDownList ID="ddlLicense" runat="server" CssClass="form-select form-control-glass" AutoPostBack="true" OnSelectedIndexChanged="CalculateRoyalty"></asp:DropDownList>
                        </div>
                        <asp:Button ID="btnCalculate" runat="server" Text="Calculate Returns" CssClass="btn btn-primary-glow w-100" OnClick="CalculateRoyalty" />

                        <div class="result-box mt-4">
                            <small class="text-muted text-uppercase">Estimated Annual Income</small>
                            <div class="result-value">
                                <asp:Literal ID="litAnnual" runat="server" Text="0.00 PNC"></asp:Literal>
                            </div>
                            <small class="text-gray">
                                Quarterly Payout: <strong class="text-white">
                                    <asp:Literal ID="litQuarterly" runat="server" Text="0.00 PNC"></asp:Literal>
                                </strong>
                            </small>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6" data-aos="fade-left">
                    <div class="glass-card p-4 mb-4">
                        <h5 class="text-white mb-3">Revenue Distribution Timeline</h5>
                        <div style="height: 300px;">
                            <canvas id="royaltyChart"></canvas>
                        </div>
                    </div>
                    <div class="glass-card p-4">
                        <h5 class="text-white mb-3">How Royalties Work</h5>
                        <ul class="list-unstyled text-gray" style="line-height: 2;">
                            <li><i class="fas fa-check text-gold me-2"></i> Buy fractional shares of licensed assets</li>
                            <li><i class="fas fa-check text-gold me-2"></i> Receive quarterly royalty distributions</li>
                            <li><i class="fas fa-check text-gold me-2"></i> Trade shares on secondary marketplace</li>
                            <li><i class="fas fa-check text-gold me-2"></i> Blockchain-verified ownership certificates</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- FAQ -->
    <section class="section-padding" style="background: var(--bg-secondary);">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">Royalty Licensing FAQs</h2>
            <p class="section-subtitle" data-aos="fade-up">Common questions about digital asset royalties</p>

            <div class="accordion accordion-flush" id="royaltyFAQ">
                <asp:Repeater ID="rptFAQs" runat="server">
                    <ItemTemplate>
                        <div class="accordion-item" data-aos="fade-up">
                            <h2 class="accordion-header">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target='#<%# "collapse" + Eval("FAQId") %>'>
                                    <i class="fas fa-question-circle text-gold me-3"></i>
                                    <%# Eval("Question") %>
                                </button>
                            </h2>
                            <div id='<%# "collapse" + Eval("FAQId") %>' class="accordion-collapse collapse" data-bs-parent="#royaltyFAQ">
                                <div class="accordion-body">
                                    <%# Eval("Answer") %>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <!-- CTA -->
    <section class="section-padding">
        <div class="container">
            <div class="glass-card cta-card p-5 text-center" data-aos="zoom-in">
                <i class="fas fa-certificate fa-3x mb-3"></i>
                <h2 class="mb-3">Start Earning Passive Royalties</h2>
                <p class="text-gray mb-4 mx-auto" style="max-width: 600px;">
                    Join thousands of investors building wealth through verified digital asset licensing and fractional ownership.
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
        var royaltyChartData = {
            labels: <%= GetChartLabels() %>,
            data: <%= GetChartData() %>
        };

        document.addEventListener('DOMContentLoaded', () => {
            if (document.getElementById('royaltyChart')) {
                const ctx = document.getElementById('royaltyChart').getContext('2d');
                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: royaltyChartData.labels,
                        datasets: [{
                            label: 'Quarterly Royalty Payout (PNC)',
                            data: royaltyChartData.data,
                            backgroundColor: 'rgba(255, 215, 0, 0.6)',
                            borderColor: '#FFD700',
                            borderWidth: 2,
                            borderRadius: 8,
                            hoverBackgroundColor: '#FFA500'
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
