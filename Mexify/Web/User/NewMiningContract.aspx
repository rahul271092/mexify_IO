<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="NewMiningContract.aspx.cs" Inherits="Mexify.Web.User.NewMiningContract" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .contract-header { margin-bottom: 32px; }
        .contract-header h2 { color: var(--text-white); margin: 0; font-size: 1.8rem; }
        
        .plan-summary-card {
            background: linear-gradient(135deg, rgba(123, 44, 191, 0.2), rgba(0, 212, 255, 0.1));
            border: 1px solid rgba(157, 78, 221, 0.3);
            border-radius: var(--radius-xl);
            padding: 32px;
            margin-bottom: 24px;
        }
        .plan-title { font-size: 1.5rem; font-weight: 700; color: var(--text-white); margin-bottom: 8px; }
        .plan-hashrate { font-size: 2.5rem; font-weight: 800; background: linear-gradient(135deg, var(--accent), var(--secondary)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        
        .detail-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-top: 24px;
        }
        .detail-item {
            background: rgba(0,0,0,0.2);
            padding: 16px;
            border-radius: 12px;
            border: 1px solid var(--glass-border);
        }
        .detail-label { color: var(--text-muted); font-size: 0.8rem; text-transform: uppercase; margin-bottom: 4px; }
        .detail-value { color: var(--text-white); font-weight: 600; font-size: 1.1rem; }

        .balance-card {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 24px;
            margin-bottom: 24px;
        }
        .balance-row { display: flex; justify-content: space-between; align-items: center; padding: 12px 0; border-bottom: 1px solid var(--glass-border); }
        .balance-row:last-child { border-bottom: none; }
        .balance-row.total { font-size: 1.2rem; font-weight: 700; color: var(--text-white); }
        
        .btn-purchase {
            padding: 14px 32px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 1rem;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
        }
        .btn-purchase.primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: var(--text-white);
            box-shadow: 0 4px 15px rgba(123, 44, 191, 0.4);
        }
        .btn-purchase.primary:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(157, 78, 221, 0.6); }
        .btn-purchase:disabled { opacity: 0.5; cursor: not-allowed; }

        .alert-box { padding: 14px 18px; border-radius: 12px; margin-bottom: 20px; display: flex; align-items: flex-start; gap: 10px; }
        .alert-box.error { background: rgba(255, 59, 92, 0.1); border: 1px solid rgba(255, 59, 92, 0.3); color: #ff3b5c; }
        .alert-box.success { background: rgba(0, 255, 178, 0.1); border: 1px solid rgba(0, 255, 178, 0.3); color: var(--accent); }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="contract-header" data-aos="fade-up">
        <a href="<%= ResolveUrl("~/Web/User/Mining.aspx") %>" class="text-muted" style="text-decoration: none; display: inline-flex; align-items: center; gap: 8px; margin-bottom: 16px;">
            <i class="fas fa-arrow-left"></i> Back to Mining
        </a>
        <h2>Purchase Mining Contract</h2>
        <p class="text-gray mb-0">Review your selected plan and confirm the purchase.</p>
    </div>

    <!-- Messages -->
    <asp:Panel ID="pnlError" runat="server" Visible="false">
        <div class="alert-box error"><i class="fas fa-exclamation-circle"></i><asp:Literal ID="litError" runat="server"></asp:Literal></div>
    </asp:Panel>
    <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
        <div class="alert-box success"><i class="fas fa-check-circle"></i><asp:Literal ID="litSuccess" runat="server"></asp:Literal></div>
    </asp:Panel>

    <div class="row g-4">
        <!-- Plan Details -->
        <div class="col-lg-7" data-aos="fade-up">
            <div class="plan-summary-card">
                <div class="d-flex justify-content-between align-items-start flex-wrap gap-3">
                    <div>
                        <div class="plan-title"><asp:Literal ID="litPlanName" runat="server" Text="Loading Plan..."></asp:Literal></div>
                        <div class="text-muted"><asp:Literal ID="litAlgorithm" runat="server" Text="SHA-256"></asp:Literal> Algorithm</div>
                    </div>
                    <div class="text-end">
                        <div class="plan-hashrate"><asp:Literal ID="litHashrate" runat="server" Text="0.00"></asp:Literal> <small style="font-size: 1rem; -webkit-text-fill-color: var(--text-gray);">TH/s</small></div>
                    </div>
                </div>

                <div class="detail-grid">
                    <div class="detail-item">
                        <div class="detail-label">Contract Duration</div>
                        <div class="detail-value"><asp:Literal ID="litDuration" runat="server" Text="0"></asp:Literal> Days</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Daily Output</div>
                        <div class="detail-value" style="color: var(--accent);"><asp:Literal ID="litDailyOutput" runat="server" Text="0.00"></asp:Literal> USDT</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Power Consumption</div>
                        <div class="detail-value"><asp:Literal ID="litPower" runat="server" Text="0"></asp:Literal> W</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Maintenance Fee</div>
                        <div class="detail-value" style="color: var(--gold);"><asp:Literal ID="litMaintenance" runat="server" Text="Included"></asp:Literal></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Payment Summary -->
        <div class="col-lg-5" data-aos="fade-up" data-aos-delay="100">
            <div class="balance-card">
                <h4 class="text-white mb-3"><i class="fas fa-receipt me-2" style="color: var(--secondary);"></i>Payment Summary</h4>
                
                <div class="balance-row">
                    <span class="text-muted">Plan Price</span>
                    <span class="text-white">$<asp:Literal ID="litPrice" runat="server" Text="0.00"></asp:Literal> USDT</span>
                </div>
                <div class="balance-row">
                    <span class="text-muted">Network Fee</span>
                    <span class="text-white">$0.00 USDT</span>
                </div>
                <div class="balance-row total">
                    <span>Total to Pay</span>
                    <span style="color: var(--accent);">$<asp:Literal ID="litTotal" runat="server" Text="0.00"></asp:Literal> USDT</span>
                </div>

                <div class="mt-4 mb-3" style="background: rgba(0, 212, 255, 0.05); padding: 12px; border-radius: 8px; border: 1px solid rgba(0, 212, 255, 0.2);">
                    <div class="text-muted" style="font-size: 0.8rem;">Your USDT Balance</div>
                    <div class="text-white fw-bold fs-5">$<asp:Literal ID="litUserBalance" runat="server" Text="0.00"></asp:Literal> USDT</div>
                </div>

                <asp:Button ID="btnPurchase" runat="server" Text="Confirm & Pay" CssClass="btn-purchase primary" OnClick="btnPurchase_Click" />
                
                <div class="text-center mt-3">
                    <small class="text-muted">By clicking confirm, you agree to the mining terms and conditions.</small>
                </div>
            </div>
        </div>
    </div>
</asp:Content>