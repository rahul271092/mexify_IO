<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="P2P.aspx.cs" Inherits="Mexify.Web.User.P2P" %>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="text-white"><i class="fas fa-handshake text-gold me-2"></i>P2P Marketplace</h2>
        <a href="CreateAd.aspx" class="btn btn-primary-glow"><i class="fas fa-plus me-2"></i> Create Ad</a>
    </div>

    <!-- Filters -->
    <div class="glass-card p-3 mb-4">
        <div class="row g-3">
            <div class="col-md-4">
                <select class="form-select bg-dark text-white border-secondary" id="selCurrency">
                    <option value="USDT">USDT</option>
                    <option value="PNC">PNC</option>
                </select>
            </div>
            <div class="col-md-4">
                <div class="btn-group w-100">
                    <button class="btn btn-outline-secondary active" onclick="filterType('SELL')">Buy Crypto</button>
                    <button class="btn btn-outline-secondary" onclick="filterType('BUY')">Sell Crypto</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Ads List -->
    <asp:Repeater ID="rptP2PAds" runat="server">
        <ItemTemplate>
            <div class="glass-card p-4 mb-3" data-aos="fade-up">
                <div class="d-flex justify-content-between align-items-start flex-wrap gap-3">
                    <div>
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class='badge <%# Eval("TypeBadge") %>'><%# Eval("AdType") %></span>
                            <h5 class="text-white mb-0"><%# Eval("CurrencyCode") %> / <%# Eval("FiatCurrency") %></h5>
                        </div>
                        <div class="text-gold fs-4 fw-bold mb-2">$ <%# Eval("Price", "{0:0.00}") %></div>
                        <div class="text-muted small">
                            <i class="fas fa-wallet me-1"></i> Limits: <%# Eval("MinLimit", "{0:0.00}") %> - <%# Eval("MaxLimit", "{0:0.00}") %> <%# Eval("FiatCurrency") %><br>
                            <i class="fas fa-credit-card me-1"></i> <%# Eval("PaymentMethods") %>
                        </div>
                    </div>
                    <div class="text-end">
                        <div class="text-muted small mb-2">Merchant: <strong class="text-white"><%# Eval("UserName") %></strong></div>
                        <asp:LinkButton ID="btnTrade" runat="server" CssClass="btn btn-primary-glow btn-sm" 
                            CommandArgument='<%# Eval("AdId") %>' OnCommand="btnTrade_Command">
                            Trade Now
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>
</asp:Content>