<%@ Page Title="NFT Marketplace" Language="C#" MasterPageFile="~/Web/MasterPages/Site.master" AutoEventWireup="true" CodeBehind="nft.aspx.cs" Inherits="Mexify.Web.nft" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="MEXIFY NFT Marketplace - Discover, mint, and trade premium digital collectibles, fine art, and exclusive blockchain assets.">
    <meta name="keywords" content="nft marketplace, digital art, crypto collectibles, blockchain art, mexify nft">
    <style>
        /* =========================================
           NFT MARKETPLACE STYLES
           ========================================= */
        .nft-hero {
            position: relative;
            padding: 160px 0 80px;
            overflow: hidden;
        }
        .nft-hero::before {
            content: '';
            position: absolute;
            top: -50%; left: -50%;
            width: 200%; height: 200%;
            background: radial-gradient(circle at 30% 50%, rgba(37, 99, 235, 0.15) 0%, transparent 50%),
                        radial-gradient(circle at 70% 50%, rgba(0, 255, 178, 0.1) 0%, transparent 50%);
            animation: pulse 15s ease-in-out infinite;
        }
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }

        /* Category Tabs */
        .category-tabs {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            justify-content: center;
            margin: 40px 0;
        }
        .category-tab {
            padding: 10px 24px;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 50px;
            color: var(--text-gray);
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 500;
        }
        .category-tab:hover, .category-tab.active {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: var(--text-white);
            border-color: transparent;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.3);
        }

        /* NFT Card */
        .nft-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
        }
        .nft-card:hover {
            transform: translateY(-10px);
            border-color: var(--secondary);
            box-shadow: 0 20px 40px rgba(0, 212, 255, 0.2);
        }
        .nft-image-wrap {
            position: relative;
            aspect-ratio: 1;
            overflow: hidden;
            background: var(--bg-tertiary);
        }
        .nft-image-wrap img {
            width: 100%; height: 100%;
            object-fit: cover;
            transition: transform 0.6s ease;
        }
        .nft-card:hover .nft-image-wrap img {
            transform: scale(1.1);
        }
        .nft-badge {
            position: absolute;
            top: 12px; left: 12px;
            padding: 6px 12px;
            background: rgba(0, 0, 0, 0.7);
            backdrop-filter: blur(10px);
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--accent);
            border: 1px solid rgba(0, 255, 178, 0.3);
        }
        .nft-badge.auction {
            color: var(--gold);
            border-color: rgba(255, 215, 0, 0.3);
        }
        .nft-like-btn {
            position: absolute;
            top: 12px; right: 12px;
            width: 36px; height: 36px;
            background: rgba(0, 0, 0, 0.7);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: 50%;
            color: var(--text-white);
            display: flex; align-items: center; justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .nft-like-btn:hover, .nft-like-btn.liked {
            background: #ff3b5c;
            border-color: #ff3b5c;
            transform: scale(1.1);
        }
        .nft-body {
            padding: 20px;
        }
        .nft-collection {
            font-size: 0.8rem;
            color: var(--secondary);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 8px;
            font-weight: 600;
        }
        .nft-title {
            color: var(--text-white);
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 12px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .nft-creator {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 16px;
            font-size: 0.85rem;
            color: var(--text-gray);
        }
        .nft-creator img {
            width: 24px; height: 24px;
            border-radius: 50%;
            border: 2px solid var(--secondary);
        }
        .nft-price-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 16px;
            border-top: 1px solid var(--glass-border);
        }
        .nft-price-label {
            font-size: 0.75rem;
            color: var(--text-muted);
            text-transform: uppercase;
            margin-bottom: 4px;
        }
        .nft-price {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--text-white);
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .nft-price .crypto-icon {
            width: 20px; height: 20px;
            border-radius: 50%;
        }
        .nft-bid-btn {
            padding: 8px 16px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            border-radius: 50px;
            color: var(--text-white);
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .nft-bid-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.4);
        }

        /* Auction Countdown */
        .auction-countdown {
            display: flex;
            gap: 8px;
            margin-top: 12px;
            padding: 10px;
            background: rgba(255, 215, 0, 0.05);
            border: 1px solid rgba(255, 215, 0, 0.2);
            border-radius: var(--radius-sm);
        }
        .countdown-unit {
            flex: 1;
            text-align: center;
        }
        .countdown-value {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--gold);
            display: block;
        }
        .countdown-label {
            font-size: 0.65rem;
            color: var(--text-muted);
            text-transform: uppercase;
        }

        /* Collection Card */
        .collection-card {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 24px;
            transition: all 0.4s ease;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }
        .collection-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 4px;
            background: linear-gradient(90deg, var(--primary), var(--accent));
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.4s ease;
        }
        .collection-card:hover::before { transform: scaleX(1); }
        .collection-card:hover {
            transform: translateY(-8px);
            border-color: var(--secondary);
            box-shadow: 0 20px 40px rgba(0, 212, 255, 0.15);
        }
        .collection-header {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 20px;
        }
        .collection-avatar {
            width: 70px; height: 70px;
            border-radius: 20px;
            object-fit: cover;
            border: 2px solid var(--secondary);
        }
        .collection-rank {
            position: absolute;
            top: 16px; right: 16px;
            width: 32px; height: 32px;
            background: linear-gradient(135deg, var(--gold), #FFA500);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-weight: 700;
            color: #000;
            font-size: 0.9rem;
        }
        .collection-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            padding-top: 16px;
            border-top: 1px solid var(--glass-border);
        }
        .stat-item .stat-label {
            font-size: 0.7rem;
            color: var(--text-muted);
            text-transform: uppercase;
            margin-bottom: 4px;
        }
        .stat-item .stat-value {
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--text-white);
        }

        /* Search & Filter Bar */
        .filter-bar {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 20px;
            margin-bottom: 40px;
        }
        .search-input-wrap {
            position: relative;
        }
        .search-input-wrap i {
            position: absolute;
            left: 16px; top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
        }
        .search-input-wrap input {
            width: 100%;
            padding: 12px 16px 12px 44px;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--glass-border);
            border-radius: 50px;
            color: var(--text-white);
        }
        .search-input-wrap input:focus {
            outline: none;
            border-color: var(--secondary);
            box-shadow: 0 0 0 3px rgba(0, 212, 255, 0.15);
        }
        .sort-select {
            padding: 12px 16px;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--glass-border);
            border-radius: 50px;
            color: var(--text-white);
            cursor: pointer;
        }


        /* =========================================
   NFT HERO SECTION - FIXED
   ========================================= */
.nft-hero {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    position: relative;
    padding: 140px 0 80px;
    overflow: hidden;
    text-align: center;
}

/* Animated gradient background */
.nft-hero::before {
    content: '';
    position: absolute;
    top: -50%;
    left: -50%;
    width: 200%;
    height: 200%;
    background: 
        radial-gradient(circle at 30% 40%, rgba(37, 99, 235, 0.25) 0%, transparent 45%),
        radial-gradient(circle at 70% 60%, rgba(0, 255, 178, 0.15) 0%, transparent 45%),
        radial-gradient(circle at 50% 50%, rgba(0, 212, 255, 0.1) 0%, transparent 60%);
    animation: nftPulse 15s ease-in-out infinite;
    z-index: 0;
    pointer-events: none;
}

@keyframes nftPulse {
    0%, 100% { 
        transform: scale(1) rotate(0deg); 
        opacity: 1;
    }
    33% { 
        transform: scale(1.1) rotate(2deg); 
        opacity: 0.8;
    }
    66% { 
        transform: scale(1.05) rotate(-2deg); 
        opacity: 0.9;
    }
}

/* Three.js canvas positioning */
.nft-hero #three-canvas {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 1;
    opacity: 0.5;
    pointer-events: none;
}

/* Hero content layer */
.nft-hero .container {
    position: relative;
    z-index: 2;
}

/* NFT-specific hero badge */
.nft-hero .hero-badge {
    display: inline-flex;
    align-items: center;
    padding: 8px 20px;
    background: rgba(0, 212, 255, 0.1);
    border: 1px solid rgba(0, 212, 255, 0.3);
    border-radius: 50px;
    color: var(--secondary);
    font-size: 0.875rem;
    font-weight: 600;
    margin-bottom: 24px;
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
}

/* NFT hero title */
.nft-hero .hero-title {
    font-size: clamp(2.5rem, 5vw, 4.5rem);
    margin-bottom: 24px;
    background: linear-gradient(135deg, #fff 0%, #a0aabf 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    line-height: 1.2;
    font-weight: 800;
}

.nft-hero .hero-title span {
    background: linear-gradient(135deg, var(--secondary) 0%, var(--accent) 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    display: inline-block;
}

/* NFT hero subtitle */
.nft-hero .hero-subtitle {
    font-size: 1.15rem;
    color: var(--text-gray);
    margin-bottom: 40px;
    max-width: 700px;
    margin-left: auto;
    margin-right: auto;
    line-height: 1.7;
}

/* Stats row in hero */
.nft-hero .hero-stats {
    margin-top: 60px;
    padding-top: 40px;
    border-top: 1px solid rgba(255, 255, 255, 0.08);
}

.nft-hero .hero-stats .glass-card {
    padding: 20px 16px;
    background: rgba(255, 255, 255, 0.03);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: var(--radius-md);
    transition: all 0.3s ease;
}

.nft-hero .hero-stats .glass-card:hover {
    border-color: rgba(0, 212, 255, 0.3);
    transform: translateY(-3px);
}

.nft-hero .hero-stats h3 {
    font-size: 1.8rem;
    font-weight: 800;
    margin-bottom: 4px;
    background: linear-gradient(135deg, var(--text-white), var(--secondary));
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

.nft-hero .hero-stats small {
    color: var(--text-muted);
    font-size: 0.8rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

/* Floating NFT preview cards (decorative) */
.nft-floating-cards {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    z-index: 1;
    overflow: hidden;
}

.floating-card {
    position: absolute;
    width: 120px;
    height: 120px;
    border-radius: 20px;
    background: linear-gradient(135deg, rgba(37, 99, 235, 0.3), rgba(0, 255, 178, 0.2));
    border: 1px solid rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
    animation: floatCard 20s ease-in-out infinite;
    opacity: 0.4;
}

.floating-card:nth-child(1) {
    top: 15%;
    left: 8%;
    animation-delay: 0s;
    background-image: url('https://images.unsplash.com/photo-1634973357973-f2ed2058a20c?w=200');
    background-size: cover;
}

.floating-card:nth-child(2) {
    top: 25%;
    right: 10%;
    width: 100px;
    height: 100px;
    animation-delay: -5s;
    background-image: url('https://images.unsplash.com/photo-1634986666676-ec8fd927c23d?w=200');
    background-size: cover;
}

.floating-card:nth-child(3) {
    bottom: 20%;
    left: 12%;
    width: 90px;
    height: 90px;
    animation-delay: -10s;
    background-image: url('https://images.unsplash.com/photo-1635322966219-b75edf7b4970?w=200');
    background-size: cover;
}

.floating-card:nth-child(4) {
    bottom: 15%;
    right: 8%;
    animation-delay: -15s;
    background-image: url('https://images.unsplash.com/photo-1614149162883-504ce4d13909?w=200');
    background-size: cover;
}

@keyframes floatCard {
    0%, 100% { 
        transform: translateY(0) rotate(0deg); 
    }
    25% { 
        transform: translateY(-30px) rotate(5deg); 
    }
    50% { 
        transform: translateY(-15px) rotate(-3deg); 
    }
    75% { 
        transform: translateY(-25px) rotate(2deg); 
    }
}

/* Hide floating cards on mobile for performance */
@media (max-width: 768px) {
    .nft-floating-cards {
        display: none;
    }
    .nft-hero {
        padding: 120px 0 60px;
    }
    .nft-hero .hero-stats h3 {
        font-size: 1.4rem;
    }
}

        /* Featured Banner */
        .featured-nft-banner {
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.2), rgba(0, 255, 178, 0.1));
            border: 1px solid rgba(0, 212, 255, 0.3);
            border-radius: var(--radius-xl);
            padding: 40px;
            position: relative;
            overflow: hidden;
        }
        .featured-nft-banner::before {
            content: '';
            position: absolute;
            top: -50%; right: -20%;
            width: 600px; height: 600px;
            background: radial-gradient(circle, rgba(0, 212, 255, 0.15) 0%, transparent 70%);
            animation: float 8s ease-in-out infinite;
        }
        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-30px) rotate(10deg); }
        }
        .featured-image {
            width: 100%;
            border-radius: var(--radius-lg);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
            border: 2px solid var(--secondary);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .nft-hero { padding: 120px 0 60px; }
            .featured-nft-banner { padding: 24px; }
        }


        section.section-padding:last-of-type .glass-card {
  opacity: 1 !important;
  transform: none !important;
}
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- =========================================
     1. NFT HERO SECTION - FIXED
     ========================================= -->
<section class="nft-hero">
    <!-- Three.js Background Canvas -->
    <canvas id="three-canvas"></canvas>
    
    <!-- Floating NFT Preview Cards (Decorative) -->
    <div class="nft-floating-cards">
        <div class="floating-card"></div>
        <div class="floating-card"></div>
        <div class="floating-card"></div>
        <div class="floating-card"></div>
    </div>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-9" data-aos="fade-up" data-aos-duration="1000">
                <div class="hero-badge">
                    <i class="fas fa-cube me-2"></i> Premium Digital Collectibles
                </div>
                <h1 class="hero-title">
                    Discover, Collect & <br>
                    <span>Sell Extraordinary NFTs</span>
                </h1>
                <p class="hero-subtitle">
                    The world's largest NFT marketplace. Buy, sell, and discover exclusive digital assets powered by blockchain technology. Trade with PNC, ETH, and 20+ cryptocurrencies.
                </p>
                <div class="d-flex gap-3 justify-content-center flex-wrap" data-aos="fade-up" data-aos-delay="200">
                    <a href="#explore" class="btn btn-primary-glow">
                        <i class="fas fa-compass me-2"></i> Explore NFTs
                    </a>
                    <a href="<%= ResolveUrl("~/User/MintNFT.aspx") %>" class="btn btn-outline-glass">
                        <i class="fas fa-plus-circle me-2"></i> Create NFT
                    </a>
                </div>
            </div>
        </div>

        <!-- Stats Row -->
        <div class="row g-3 hero-stats" data-aos="fade-up" data-aos-delay="400">
            <div class="col-6 col-md-3">
                <div class="glass-card text-center">
                    <h3>300K+</h3>
                    <small>NFTs Listed</small>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="glass-card text-center">
                    <h3>85K+</h3>
                    <small>Artists</small>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="glass-card text-center">
                    <h3>1.2M+</h3>
                    <small>PNC Volume</small>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="glass-card text-center">
                    <h3>120+</h3>
                    <small>Collections</small>
                </div>
            </div>
        </div>
    </div>
</section>
    <!-- =========================================
         2. FEATURED NFT (LIVE AUCTION)
         ========================================= -->
    <section class="section-padding" style="padding-top: 40px;">
        <div class="container">
            <div class="featured-nft-banner" data-aos="zoom-in">
                <div class="row align-items-center g-4 position-relative" style="z-index: 2;">
                    <div class="col-lg-5">
                        <span class="hero-badge mb-3">
                            <i class="fas fa-fire me-2"></i> Featured Auction
                        </span>
                        <h2 class="text-white mb-3">Cosmic Dreams #001</h2>
                        <p class="text-gray mb-4">
                            A one-of-a-kind digital masterpiece by renowned artist Alex Rivera. Part of the exclusive "Cosmic Series" collection — only 10 pieces ever created.
                        </p>
                        <div class="d-flex align-items-center gap-3 mb-4">
                            <img src="https://ui-avatars.com/api/?name=Alex+Rivera&background=2563EB&color=fff" 
                                 class="rounded-circle" width="40" height="40" alt="Creator">
                            <div>
                                <small class="text-muted d-block">Created by</small>
                                <strong class="text-white">Alex Rivera</strong>
                            </div>
                        </div>

                        <!-- Countdown -->
                        <div class="auction-countdown mb-4">
                            <div class="countdown-unit">
                                <span class="countdown-value" id="days">02</span>
                                <span class="countdown-label">Days</span>
                            </div>
                            <div class="countdown-unit">
                                <span class="countdown-value" id="hours">14</span>
                                <span class="countdown-label">Hours</span>
                            </div>
                            <div class="countdown-unit">
                                <span class="countdown-value" id="minutes">36</span>
                                <span class="countdown-label">Minutes</span>
                            </div>
                            <div class="countdown-unit">
                                <span class="countdown-value" id="seconds">52</span>
                                <span class="countdown-label">Seconds</span>
                            </div>
                        </div>

                        <div class="d-flex gap-3 flex-wrap">
                            <button class="btn btn-primary-glow">
                                <i class="fas fa-gavel me-2"></i> Place Bid
                            </button>
                            <button class="btn btn-outline-glass">
                                <i class="fas fa-heart me-2"></i> Favorite
                            </button>
                        </div>
                    </div>
                    <div class="col-lg-7">
                        <img src="https://images.unsplash.com/photo-1634986666676-ec8fd927c23d?w=800" 
                             alt="Featured NFT" class="featured-image">
                        <div class="d-flex justify-content-between mt-3">
                            <div>
                                <small class="text-muted">Current Bid</small>
                                <h4 class="text-white mb-0">
                                    <i class="fab fa-ethereum text-secondary"></i> 12.5 ETH
                                </h4>
                                <small class="text-gray">≈ $31,250</small>
                            </div>
                            <div class="text-end">
                                <small class="text-muted">Ends in</small>
                                <h4 class="text-gold mb-0" style="color: var(--gold);">2d 14h</h4>
                                <small class="text-gray">12 bids</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- =========================================
         3. TRENDING COLLECTIONS
         ========================================= -->
    <section class="section-padding">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center mb-4" data-aos="fade-up">
                <div>
                    <h2 class="section-title text-start mb-2">Trending Collections</h2>
                    <p class="text-gray mb-0">Top collections over the last 7 days</p>
                </div>
                <a href="#" class="btn btn-outline-glass">
                    View All <i class="fas fa-arrow-right ms-2"></i>
                </a>
            </div>

            <div class="row g-4">
                <asp:Repeater ID="rptCollections" runat="server">
                    <ItemTemplate>
                        <div class="col-md-6 col-lg-3" data-aos="fade-up">
                            <div class="collection-card">
                                <span class="collection-rank"><%# Container.ItemIndex + 1 %></span>
                                <div class="collection-header">
                                    <img src='<%# Eval("LogoUrl") %>' 
                                         alt='<%# Eval("Name") %>' 
                                         class="collection-avatar"
                                         onerror="this.src='https://ui-avatars.com/api/?name=<%# Eval("Name") %>&background=2563EB&color=fff&size=100'">
                                    <div>
                                        <h5 class="text-white mb-1"><%# Eval("Name") %></h5>
                                        <small class="text-muted">By <%# Eval("CreatorName") %></small>
                                    </div>
                                </div>
                                <div class="collection-stats">
                                    <div class="stat-item">
                                        <div class="stat-label">Floor Price</div>
                                        <div class="stat-value"><%# Eval("FloorPriceFormatted") %></div>
                                    </div>
                                    <div class="stat-item">
                                        <div class="stat-label">Volume</div>
                                        <div class="stat-value"><%# Eval("VolumeFormatted") %></div>
                                    </div>
                                    <div class="stat-item">
                                        <div class="stat-label">Items</div>
                                        <div class="stat-value"><%# Eval("TotalItems") %></div>
                                    </div>
                                    <div class="stat-item">
                                        <div class="stat-label">Owners</div>
                                        <div class="stat-value"><%# Eval("OwnersCount") %></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <!-- =========================================
         4. EXPLORE NFTs (WITH FILTERS)
         ========================================= -->
    <section id="explore" class="section-padding" style="background: var(--bg-secondary);">
        <div class="container">
            <h2 class="section-title text-center" data-aos="fade-up">Explore NFTs</h2>
            <p class="section-subtitle" data-aos="fade-up">Discover the most unique digital assets</p>

            <!-- Filter Bar -->
            <div class="filter-bar" data-aos="fade-up">
                <div class="row g-3 align-items-center">
                    <div class="col-md-6">
                        <div class="search-input-wrap">
                            <i class="fas fa-search"></i>
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search NFTs, collections, or artists..."></asp:TextBox>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select sort-select" AutoPostBack="true" OnSelectedIndexChanged="FilterNFTs">
                            <asp:ListItem Value="all" Text="All Categories" Selected="True"></asp:ListItem>
                            <asp:ListItem Value="art" Text="Art"></asp:ListItem>
                            <asp:ListItem Value="photography" Text="Photography"></asp:ListItem>
                            <asp:ListItem Value="music" Text="Music"></asp:ListItem>
                            <asp:ListItem Value="gaming" Text="Gaming"></asp:ListItem>
                            <asp:ListItem Value="virtual-world" Text="Virtual World"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <asp:DropDownList ID="ddlSort" runat="server" CssClass="form-select sort-select" AutoPostBack="true" OnSelectedIndexChanged="FilterNFTs">
                            <asp:ListItem Value="recent" Text="Recently Listed" Selected="True"></asp:ListItem>
                            <asp:ListItem Value="price-low" Text="Price: Low to High"></asp:ListItem>
                            <asp:ListItem Value="price-high" Text="Price: High to Low"></asp:ListItem>
                            <asp:ListItem Value="popular" Text="Most Popular"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <!-- Category Tabs -->
            <div class="category-tabs" data-aos="fade-up">
                <span class="category-tab active" data-category="all">All</span>
                <span class="category-tab" data-category="art">🎨 Art</span>
                <span class="category-tab" data-category="photography">📷 Photography</span>
                <span class="category-tab" data-category="music">🎵 Music</span>
                <span class="category-tab" data-category="gaming">🎮 Gaming</span>
                <span class="category-tab" data-category="virtual-world">🌐 Virtual World</span>
            </div>

            <!-- NFT Grid -->
            <div class="row g-4" id="nftGrid">
                <asp:Repeater ID="rptNFTs" runat="server">
                    <ItemTemplate>
                        <div class="col-md-6 col-lg-4 col-xl-3 nft-item" data-category='<%# Eval("Category") %>'>
                            <div class="nft-card">
                                <div class="nft-image-wrap">
                                    <img src='<%# Eval("ImageUrl") %>' 
                                         alt='<%# Eval("Name") %>'
                                         onerror="this.src='https://images.unsplash.com/photo-1634973357973-f2ed2058a20c?w=400'">
                                    
                                    <%# Eval("IsAuction").ToString() == "True" 
                                        ? "<span class='nft-badge auction'><i class='fas fa-gavel me-1'></i> Live Auction</span>" 
                                        : "<span class='nft-badge'><i class='fas fa-tag me-1'></i> Buy Now</span>" %>
                                    
                                    <button class="nft-like-btn" onclick="toggleLike(this, event)">
                                        <i class="far fa-heart"></i>
                                    </button>
                                </div>
                                <div class="nft-body">
                                    <div class="nft-collection"><%# Eval("CollectionName") %></div>
                                    <h5 class="nft-title"><%# Eval("Name") %></h5>
                                    
                                    <div class="nft-creator">
                                        <img src='<%# Eval("CreatorPhoto") %>' 
                                             alt="Creator"
                                             onerror="this.src='https://ui-avatars.com/api/?name=U&background=00D4FF&color=fff'">
                                        <span>@<%# Eval("CreatorUsername") %></span>
                                    </div>

                                    <%--<%# Eval("IsAuction").ToString() == "True" ? Mexify.Web.nft.RenderCountdown(Eval("AuctionEndDate")) : "" %>--%>

                                    <div class="nft-price-row">
                                        <div>
                                            <div class="nft-price-label">
                                                <%# Eval("IsAuction").ToString() == "True" ? "Current Bid" : "Price" %>
                                            </div>
                                            <div class="nft-price">
                                                <i class='<%# GetCryptoIcon(Eval("CurrencyCode")) %>'></i>
                                      <%--          <%# string.Format("{0:0.####}", Eval("Price")) %> <%# Eval("CurrencyCode") %>--%>
                                            </div>
                                        </div>
                                        <button class="nft-bid-btn">
                                            <%# Eval("IsAuction").ToString() == "True" ? "Place Bid" : "Buy Now" %>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <!-- Load More -->
            <div class="text-center mt-5" data-aos="fade-up">
                <asp:Button ID="btnLoadMore" runat="server" Text="Load More NFTs" 
                            CssClass="btn btn-outline-glass" OnClick="btnLoadMore_Click" />
            </div>
        </div>
    </section>

    <!-- =========================================
         5. HOW TO BUY NFTs
         ========================================= -->
    <section class="section-padding">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">How to Buy NFTs</h2>
            <p class="section-subtitle" data-aos="fade-up">Get started in 4 simple steps</p>

            <div class="row g-4">
                <div class="col-md-6 col-lg-3" data-aos="fade-up">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="feature-icon mx-auto"><i class="fas fa-wallet"></i></div>
                        <h5 class="text-white">1. Setup Wallet</h5>
                        <p class="text-gray small">Connect your MetaMask or any Web3 wallet securely.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="100">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="feature-icon mx-auto"><i class="fas fa-coins"></i></div>
                        <h5 class="text-white">2. Add Funds</h5>
                        <p class="text-gray small">Deposit ETH, USDT, or other supported cryptocurrencies.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="200">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="feature-icon mx-auto"><i class="fas fa-search"></i></div>
                        <h5 class="text-white">3. Browse NFTs</h5>
                        <p class="text-gray small">Explore thousands of unique digital assets.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="300">
                    <div class="glass-card p-4 text-center h-100">
                        <div class="feature-icon mx-auto"><i class="fas fa-check-circle"></i></div>
                        <h5 class="text-white">4. Make Purchase</h5>
                        <p class="text-gray small">Buy instantly or place your bid in live auctions.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- =========================================
         6. CTA - CREATE YOUR NFT
         ========================================= -->
    <section class="section-padding" style="background: var(--bg-secondary);">
        <div class="container">
            <div class="glass-card p-5 text-center" data-aos="zoom-in" style="background: linear-gradient(135deg, rgba(37, 99, 235, 0.2), rgba(0, 255, 178, 0.1));">
                <i class="fas fa-magic fa-3x text-secondary mb-4"></i>
                <h2 class="text-white mb-3">Become an NFT Creator</h2>
                <p class="text-gray mb-4 mx-auto" style="max-width: 600px;">
                    Mint your own digital art, music, or collectibles and sell them to a global audience of collectors.
                </p>
                <a href="<%= ResolveUrl("~/User/MintNFT.aspx") %>" class="btn btn-primary-glow btn-lg">
                    Start Creating <i class="fas fa-rocket ms-2"></i>
                </a>
            </div>
        </div>
    </section>

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        // Category Tab Filtering
        document.addEventListener('DOMContentLoaded', () => {
            const tabs = document.querySelectorAll('.category-tab');
            const items = document.querySelectorAll('.nft-item');

            tabs.forEach(tab => {
                tab.addEventListener('click', () => {
                    tabs.forEach(t => t.classList.remove('active'));
                    tab.classList.add('active');

                    const category = tab.dataset.category;
                    items.forEach(item => {
                        if (category === 'all' || item.dataset.category === category) {
                            item.style.display = '';
                            item.style.animation = 'fadeIn 0.5s ease';
                        } else {
                            item.style.display = 'none';
                        }
                    });
                });
            });

            // Featured Auction Countdown
            startCountdown();
        });

        function startCountdown() {
            // Set end date to 2 days, 14 hours, 36 minutes from now
            const endDate = new Date();
            endDate.setDate(endDate.getDate() + 2);
            endDate.setHours(endDate.getHours() + 14);
            endDate.setMinutes(endDate.getMinutes() + 36);

            function update() {
                const now = new Date().getTime();
                const distance = endDate.getTime() - now;

                if (distance < 0) return;

                const days = Math.floor(distance / (1000 * 60 * 60 * 24));
                const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                const seconds = Math.floor((distance % (1000 * 60)) / 1000);

                const dEl = document.getElementById('days');
                const hEl = document.getElementById('hours');
                const mEl = document.getElementById('minutes');
                const sEl = document.getElementById('seconds');

                if (dEl) dEl.textContent = String(days).padStart(2, '0');
                if (hEl) hEl.textContent = String(hours).padStart(2, '0');
                if (mEl) mEl.textContent = String(minutes).padStart(2, '0');
                if (sEl) sEl.textContent = String(seconds).padStart(2, '0');
            }

            update();
            setInterval(update, 1000);
        }

        function toggleLike(btn, event) {
            event.preventDefault();
            event.stopPropagation();
            btn.classList.toggle('liked');
            const icon = btn.querySelector('i');
            if (btn.classList.contains('liked')) {
                icon.classList.remove('far');
                icon.classList.add('fas');
            } else {
                icon.classList.remove('fas');
                icon.classList.add('far');
            }
        }



        // Parallax effect for NFT hero
        document.addEventListener('DOMContentLoaded', () => {
            const hero = document.querySelector('.nft-hero');
            if (hero) {
                window.addEventListener('scroll', () => {
                    const scrolled = window.pageYOffset;
                    const canvas = hero.querySelector('#three-canvas');
                    const floatingCards = hero.querySelector('.nft-floating-cards');

                    if (canvas && scrolled < window.innerHeight) {
                        canvas.style.transform = `translateY(${scrolled * 0.3}px)`;
                    }
                    if (floatingCards && scrolled < window.innerHeight) {
                        floatingCards.style.transform = `translateY(${scrolled * 0.5}px)`;
                    }
                });
            }
        });
    </script>
</asp:Content>