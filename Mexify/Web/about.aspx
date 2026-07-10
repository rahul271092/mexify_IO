<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="about.aspx.cs" Inherits="Mexify.Web.about" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <meta name="description" content="Learn about MEXIFY - Institutional-grade crypto asset management platform with enterprise mining, staking, NFTs, and royalty income solutions.">
    <meta name="keywords" content="about mexify, crypto company, blockchain firm, institutional crypto">
    <style>
        .vision-mission-card {
            position: relative;
            overflow: hidden;
        }
        .vision-mission-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 4px;
            background: linear-gradient(90deg, var(--primary), var(--accent));
        }
        .vm-icon {
            width: 80px; height: 80px;
            display: flex; align-items: center; justify-content: center;
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.2), rgba(0, 255, 178, 0.1));
            border-radius: 20px;
            font-size: 2rem;
            color: var(--secondary);
            margin-bottom: 24px;
            border: 1px solid rgba(0, 212, 255, 0.2);
        }
        .team-member { text-align: center; }
        .team-photo {
            width: 140px; height: 140px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid var(--secondary);
            box-shadow: 0 0 30px rgba(0, 212, 255, 0.3);
            margin-bottom: 20px;
            transition: transform 0.4s ease;
        }
        .team-member:hover .team-photo { transform: scale(1.05); }
        .team-name { color: var(--text-white); font-size: 1.2rem; margin-bottom: 4px; }
        .team-role { color: var(--secondary); font-size: 0.9rem; margin-bottom: 12px; }
        .team-social a {
            width: 36px; height: 36px;
            display: inline-flex; align-items: center; justify-content: center;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 50%;
            color: var(--text-gray);
            margin: 0 4px;
            transition: all 0.3s ease;
        }
        .team-social a:hover {
            background: var(--primary);
            color: var(--text-white);
            border-color: var(--primary);
            transform: translateY(-3px);
        }
        .timeline { position: relative; padding: 40px 0; }
        .timeline::before {
            content: '';
            position: absolute;
            left: 50%; top: 0; bottom: 0;
            width: 2px;
            background: linear-gradient(180deg, var(--primary), var(--accent));
            transform: translateX(-50%);
        }
        .timeline-item {
            position: relative;
            width: 50%;
            padding: 20px 40px;
            margin-bottom: 20px;
        }
        .timeline-item.left { left: 0; text-align: right; }
        .timeline-item.right { left: 50%; text-align: left; }
        .timeline-item::after {
            content: '';
            position: absolute;
            top: 30px;
            width: 20px; height: 20px;
            background: var(--accent);
            border: 4px solid var(--bg-primary);
            border-radius: 50%;
            box-shadow: 0 0 20px var(--accent);
        }
        .timeline-item.left::after { right: -10px; }
        .timeline-item.right::after { left: -10px; }
        .timeline-year {
            display: inline-block;
            padding: 6px 16px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 50px;
            color: var(--text-white);
            font-weight: 700;
            margin-bottom: 12px;
        }
        .certificate-card {
            text-align: center;
            padding: 30px 20px;
        }
        .certificate-icon {
            width: 80px; height: 80px;
            margin: 0 auto 20px;
            display: flex; align-items: center; justify-content: center;
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.15), rgba(255, 215, 0, 0.05));
            border: 1px solid rgba(255, 215, 0, 0.3);
            border-radius: 20px;
            font-size: 2rem;
            color: var(--gold);
        }
        @media (max-width: 768px) {
            .timeline::before { left: 20px; }
            .timeline-item { width: 100%; padding-left: 60px; padding-right: 20px; text-align: left !important; }
            .timeline-item.right { left: 0; }
            .timeline-item::after { left: 10px !important; right: auto !important; }
        }


        section.section-padding:last-of-type .glass-card {
  opacity: 1 !important;
  transform: none !important;
}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

      <!-- =========================================
         1. HERO BANNER
         ========================================= -->
    <section class="hero-section" style="min-height: 60vh;">
        <canvas id="three-canvas"></canvas>
        <div class="container">
            <div class="row justify-content-center text-center">
                <div class="col-lg-8 hero-content" data-aos="fade-up">
                    <div class="hero-badge">
                        <i class="fas fa-building me-2"></i> About MEXIFY
                    </div>
                    <h1 class="hero-title">
                        Building the Future of <br><span>Digital Asset Management</span>
                    </h1>
                    <p class="hero-subtitle mx-auto">
                        We are a team of blockchain pioneers, financial experts, and technology innovators dedicated to making institutional-grade crypto investments accessible to everyone.
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- =========================================
         2. COMPANY PROFILE
         ========================================= -->
    <section class="section-padding">
        <div class="container">
            <div class="row align-items-center g-5">
                <div class="col-lg-6" data-aos="fade-right">
                    <h2 class="section-title text-start">Who We Are</h2>
                    <p class="text-gray mt-4">
                        Founded in 2024, <strong class="text-white">MEXIFY</strong> has rapidly emerged as a global leader in crypto asset management. We combine cutting-edge blockchain technology with traditional financial expertise to deliver secure, transparent, and high-yield investment solutions.
                    </p>
                    <p class="text-gray">
                        Our platform serves over 150,000 investors across 120+ countries, managing more than $2.5 billion in digital assets. From 2X ROI plans and enterprise mining to NFT marketplaces and royalty licensing, we offer a comprehensive ecosystem for every type of digital investor.
                    </p>
                    <div class="row g-3 mt-4">
                        <div class="col-6">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-check-circle text-accent me-2 fa-2x"></i>
                                <div>
                                    <h5 class="text-white mb-0">Regulated</h5>
                                    <small class="text-muted">Fully Licensed</small>
                                </div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-shield-alt text-accent me-2 fa-2x"></i>
                                <div>
                                    <h5 class="text-white mb-0">Secure</h5>
                                    <small class="text-muted">Bank-Grade Security</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6" data-aos="fade-left">
                    <div class="glass-card p-2">
                        <img src="<%= ResolveUrl("~/Assets/images/about-company.jpg") %>" 
                             alt="MEXIFY Company" 
                             class="img-fluid rounded-3"
                             onerror="this.src='https://images.unsplash.com/photo-1639762681485-074b7f938ba0?w=800'">
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- =========================================
         3. VISION & MISSION
         ========================================= -->
    <section class="section-padding" style="background: var(--bg-secondary);">
        <div class="container">
            <div class="row g-4">
                <div class="col-lg-6" data-aos="fade-up">
                    <div class="glass-card vision-mission-card p-5 h-100">
                        <div class="vm-icon"><i class="fas fa-eye"></i></div>
                        <h3 class="text-white mb-3">Our Vision</h3>
                        <p class="text-gray">
                            To become the world's most trusted and innovative crypto asset management platform, democratizing access to institutional-grade investment opportunities and empowering individuals to achieve financial freedom through blockchain technology.
                        </p>
                    </div>
                </div>
                <div class="col-lg-6" data-aos="fade-up" data-aos-delay="200">
                    <div class="glass-card vision-mission-card p-5 h-100">
                        <div class="vm-icon"><i class="fas fa-bullseye"></i></div>
                        <h3 class="text-white mb-3">Our Mission</h3>
                        <p class="text-gray">
                            To deliver secure, transparent, and high-performance investment solutions by leveraging AI-driven strategies, enterprise infrastructure, and a commitment to regulatory compliance — ensuring every investor achieves sustainable, long-term growth.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- =========================================
         4. COMPANY STATISTICS
         ========================================= -->
    <section class="section-padding">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">Our Impact in Numbers</h2>
            <p class="section-subtitle" data-aos="fade-up">Trusted by investors worldwide</p>
            
            <div class="row g-4">
                <div class="col-6 col-md-3" data-aos="fade-up">
                    <div class="glass-card p-4 text-center">
                        <i class="fas fa-users fa-2x text-secondary mb-3"></i>
                        <h2 class="text-white counter" data-target="150000">0</h2>
                        <p class="text-gray mb-0">Active Investors</p>
                    </div>
                </div>
                <div class="col-6 col-md-3" data-aos="fade-up" data-aos-delay="100">
                    <div class="glass-card p-4 text-center">
                        <i class="fas fa-dollar-sign fa-2x text-accent mb-3"></i>
                        <h2 class="text-white">$<span class="counter" data-target="2500">0</span>M+</h2>
                        <p class="text-gray mb-0">Assets Managed</p>
                    </div>
                </div>
                <div class="col-6 col-md-3" data-aos="fade-up" data-aos-delay="200">
                    <div class="glass-card p-4 text-center">
                        <i class="fas fa-globe fa-2x text-primary mb-3"></i>
                        <h2 class="text-white counter" data-target="120">0</h2>
                        <p class="text-gray mb-0">Countries</p>
                    </div>
                </div>
                <div class="col-6 col-md-3" data-aos="fade-up" data-aos-delay="300">
                    <div class="glass-card p-4 text-center">
                        <i class="fas fa-award fa-2x text-warning mb-3"></i>
                        <h2 class="text-white counter" data-target="25">0</h2>
                        <p class="text-gray mb-0">Industry Awards</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- =========================================
         5. LEADERSHIP TEAM (DYNAMIC)
         ========================================= -->
    <section class="section-padding" style="background: var(--bg-secondary);">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">Meet Our Leadership</h2>
            <p class="section-subtitle" data-aos="fade-up">Industry veterans driving innovation</p>
            
            <div class="row g-4">
                <asp:Repeater ID="rptTeam" runat="server">
                    <ItemTemplate>
                        <div class="col-md-6 col-lg-3" data-aos="fade-up">
                            <div class="glass-card team-member p-4 h-100">
                                <img src='<%# Eval("PhotoUrl") %>' 
                                     alt='<%# Eval("FullName") %>' 
                                     class="team-photo"
                                     onerror="this.src='https://ui-avatars.com/api/?name=<%# Eval("FullName") %>&background=2563EB&color=fff&size=200'">
                                <h5 class="team-name"><%# Eval("FullName") %></h5>
                                <p class="team-role"><%# Eval("Designation") %></p>
                                <p class="text-gray small"><%# Eval("Bio") %></p>
                                <div class="team-social mt-3">
                                    <a href='<%# Eval("LinkedInUrl") %>' target="_blank"><i class="fab fa-linkedin-in"></i></a>
                                    <a href='<%# Eval("TwitterUrl") %>' target="_blank"><i class="fab fa-twitter"></i></a>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <!-- =========================================
         6. TIMELINE / ROADMAP (DYNAMIC)
         ========================================= -->
    <section class="section-padding">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">Our Journey</h2>
            <p class="section-subtitle" data-aos="fade-up">Key milestones in the MEXIFY story</p>
            
            <div class="timeline">
                <asp:Repeater ID="rptTimeline" runat="server">
                    <ItemTemplate>
                        <div class='timeline-item <%# Container.ItemIndex % 2 == 0 ? "left" : "right" %>' data-aos='<%# Container.ItemIndex % 2 == 0 ? "fade-right" : "fade-left" %>'>
                            <div class="glass-card p-4">
                                <span class="timeline-year"><%# Eval("Year") %></span>
                                <h4 class="text-white mt-2"><%# Eval("Title") %></h4>
                                <p class="text-gray mb-0"><%# Eval("Description") %></p>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <!-- =========================================
         7. COMPLIANCE & CERTIFICATES (DYNAMIC)
         ========================================= -->
    <section class="section-padding" style="background: var(--bg-secondary);">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">Compliance & Certifications</h2>
            <p class="section-subtitle" data-aos="fade-up">Meeting the highest global standards</p>
            
            <div class="row g-4">
                <asp:Repeater ID="rptCertificates" runat="server">
                    <ItemTemplate>
                        <div class="col-md-6 col-lg-3" data-aos="fade-up">
                            <div class="glass-card certificate-card h-100">
                                <div class="certificate-icon">
                                    <i class='<%# Eval("IconClass") %>'></i>
                                </div>
                                <h5 class="text-white"><%# Eval("Title") %></h5>
                                <p class="text-gray small"><%# Eval("Description") %></p>
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
                <h2 class="text-white mb-3">Join the MEXIFY Revolution</h2>
                <p class="text-gray mb-4 mx-auto" style="max-width: 600px;">
                    Be part of a global community of forward-thinking investors shaping the future of finance.
                </p>
                <div class="d-flex gap-3 justify-content-center flex-wrap">
                    <a href="<%= ResolveUrl("~/register.aspx") %>" class="btn btn-primary-glow">
                        Get Started <i class="fas fa-arrow-right ms-2"></i>
                    </a>
                    <a href="<%= ResolveUrl("~/contact.aspx") %>" class="btn btn-outline-glass">
                        Contact Us
                    </a>
                </div>
            </div>
        </div>
    </section>


</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
      <script>
        // Animated Counters
        document.addEventListener('DOMContentLoaded', () => {
            const counters = document.querySelectorAll('.counter');
            const speed = 200;
            counters.forEach(counter => {
                const updateCount = () => {
                    const target = +counter.getAttribute('data-target');
                    const count = +counter.innerText.replace(/[^0-9]/g, '') || 0;
                    const inc = target / speed;
                    if (count < target) {
                        counter.innerText = Math.ceil(count + inc).toLocaleString();
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
