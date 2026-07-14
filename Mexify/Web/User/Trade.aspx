<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="Trade.aspx.cs" Inherits="Mexify.Web.User.Trade" %>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Trade ID hidden -->
    <asp:HiddenField ID="hfTradeId" runat="server" />
    <asp:HiddenField ID="hfUserRole" runat="server" />
    <asp:HiddenField ID="hfMinutesRemaining" runat="server" />

    <!-- Unauthorized Access -->
    <asp:Panel ID="pnlUnauthorized" runat="server" Visible="false">
        <div class="glass-card text-center p-5">
            <i class="fas fa-lock fa-3x text-danger mb-3"></i>
            <h4 class="text-white">Access Denied</h4>
            <p class="text-muted">You are not authorized to view this trade.</p>
            <a href="P2P.aspx" class="btn btn-primary-glow">Back to Marketplace</a>
        </div>
    </asp:Panel>

    <!-- Main Trade Interface -->
    <asp:Panel ID="pnlTrade" runat="server" Visible="false">
        
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3" data-aos="fade-up">
            <div>
                <h2 class="text-white mb-1">
                    <i class="fas fa-handshake text-gold me-2"></i>
                    Trade #<asp:Literal ID="litTradeId" runat="server" />
                </h2>
                <p class="text-muted mb-0">
                    <span class='badge <%# "" %>' runat="server" ID="badgeStatus"></span>
                    <asp:Literal ID="litStatusName" runat="server" />
                </p>
            </div>
            <div>
                <span class="badge badge-gold fs-6">
                    <i class="fas fa-user-tag me-1"></i> You are the <strong><asp:Literal ID="litUserRole" runat="server" /></strong>
                </span>
            </div>
        </div>

        <div class="row g-4">
            <!-- LEFT: Trade Details -->
            <div class="col-lg-8">
                
                <!-- Countdown Timer (Buyer only, Status 0) -->
                <asp:Panel ID="pnlCountdown" runat="server" Visible="false">
                    <div class="glass-card p-4 mb-4" style="border-color: rgba(255, 215, 0, 0.4); background: linear-gradient(135deg, rgba(255, 215, 0, 0.05), rgba(255, 165, 0, 0.02));">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h5 class="text-white mb-1"><i class="fas fa-clock text-gold me-2"></i>Payment Window</h5>
                                <small class="text-muted">Send payment within the time limit</small>
                            </div>
                            <div class="text-end">
                                <div class="display-4 text-gold fw-bold" id="countdownTimer">--:--</div>
                                <small class="text-muted">minutes remaining</small>
                            </div>
                        </div>
                    </div>
                </asp:Panel>

                <!-- Trade Summary Card -->
                <div class="glass-card p-4 mb-4" data-aos="fade-up">
                    <h5 class="text-white mb-4"><i class="fas fa-file-invoice text-gold me-2"></i>Trade Summary</h5>
                    
                    <div class="row g-3">
                        <div class="col-md-6">
                            <small class="text-muted d-block">You Send (Fiat)</small>
                            <div class="fs-3 text-white fw-bold">$<asp:Literal ID="litFiatAmount" runat="server" /></div>
                        </div>
                        <div class="col-md-6">
                            <small class="text-muted d-block">You Receive (Crypto)</small>
                            <div class="fs-3 text-gold fw-bold"><asp:Literal ID="litCryptoAmount" runat="server" /> <asp:Literal ID="litCurrency" runat="server" /></div>
                        </div>
                        <div class="col-md-6">
                            <small class="text-muted d-block">Price per Unit</small>
                            <div class="text-white fw-600">$<asp:Literal ID="litPrice" runat="server" /> / <asp:Literal ID="litCurrency2" runat="server" /></div>
                        </div>
                        <div class="col-md-6">
                            <small class="text-muted d-block">Payment Method</small>
                            <div class="text-white fw-600"><i class="fas fa-credit-card me-1"></i><asp:Literal ID="litPaymentMethod" runat="server" /></div>
                        </div>
                        <div class="col-12">
                            <small class="text-muted d-block">Trade Created</small>
                            <div class="text-white"><asp:Literal ID="litCreatedDate" runat="server" /></div>
                        </div>
                    </div>
                </div>

                <!-- Counterparty Info -->
                <div class="glass-card p-4 mb-4" data-aos="fade-up">
                    <h5 class="text-white mb-3"><i class="fas fa-user-circle text-gold me-2"></i>Trading With</h5>
                    <div class="d-flex align-items-center gap-3">
                        <div class="wallet-icon pnc" style="width: 60px; height: 60px; font-size: 1.8rem;">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="flex-grow-1">
                            <div class="text-white fw-bold fs-5"><asp:Literal ID="litCounterpartyName" runat="server" /></div>
                            <div class="d-flex gap-3 mt-1">
                                <small class="text-muted">
                                    <i class="fas fa-check-circle text-accent me-1"></i>
                                    <asp:Literal ID="litCounterpartyTrades" runat="server" /> trades completed
                                </small>
                                <small class="text-muted">
                                    <i class="fas fa-bolt text-gold me-1"></i>
                                    Avg: <asp:Literal ID="litCounterpartyAvg" runat="server" /> min
                                </small>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Status Timeline -->
                <div class="glass-card p-4 mb-4" data-aos="fade-up">
                    <h5 class="text-white mb-4"><i class="fas fa-tasks text-gold me-2"></i>Trade Progress</h5>
                    <asp:Repeater ID="rptTimeline" runat="server">
                        <ItemTemplate>
                            <div class="d-flex gap-3 mb-3">
                                <div class='activity-icon <%# Convert.ToBoolean(Eval("IsCompleted")) ? "gold" : "muted" %>'>
                                    <i class='<%# Eval("StepIcon") %>'></i>
                                </div>
                                <div class="flex-grow-1">
                                    <div class='fw-600 <%# Convert.ToBoolean(Eval("IsCompleted")) ? "text-white" : "text-muted" %>'>
                                        <%# Eval("StepTitle") %>
                                    </div>
                                    <small class="text-muted"><%# Eval("StepDescription") %></small>
                                    <%# Eval("StepDate") != DBNull.Value ? "<div class='text-gold small mt-1'>" + Convert.ToDateTime(Eval("StepDate")).ToString("MMM dd, yyyy HH:mm") + "</div>" : "" %>
                                </div>
                                <%# Convert.ToBoolean(Eval("IsCompleted")) ? "<i class='fas fa-check-circle text-accent fs-4'></i>" : "<i class='far fa-circle text-muted fs-4'></i>" %>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <!-- Buyer: Payment Proof Upload -->
                <asp:Panel ID="pnlPaymentProof" runat="server" Visible="false">
                    <div class="glass-card p-4 mb-4" data-aos="fade-up">
                        <h5 class="text-white mb-3"><i class="fas fa-receipt text-gold me-2"></i>Payment Proof</h5>
                        <asp:TextBox ID="txtPaymentProof" runat="server" CssClass="form-control bg-dark text-white border-secondary" 
                            TextMode="MultiLine" Rows="3" placeholder="Paste transaction reference, screenshot URL, or payment details..."></asp:TextBox>
                        <small class="text-muted mt-1 d-block">Optional but recommended - helps seller verify your payment faster</small>
                    </div>
                </asp:Panel>

                <!-- Seller: View Payment Proof -->
                <asp:Panel ID="pnlViewProof" runat="server" Visible="false">
                    <div class="glass-card p-4 mb-4" data-aos="fade-up" style="border-color: rgba(0, 212, 255, 0.3);">
                        <h5 class="text-white mb-3"><i class="fas fa-eye text-secondary me-2"></i>Payment Proof from Buyer</h5>
                        <div class="p-3" style="background: rgba(0, 212, 255, 0.05); border-radius: 10px;">
                            <asp:Literal ID="litPaymentProof" runat="server" />
                        </div>
                        <div class="alert alert-warning mt-3 mb-0" style="background: rgba(255, 193, 7, 0.1); border: 1px solid rgba(255, 193, 7, 0.3); color: #ffc107;">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <small><strong>Important:</strong> Verify the payment has arrived in your bank/payment account BEFORE releasing funds. Once released, it cannot be reversed.</small>
                        </div>
                    </div>
                </asp:Panel>

                <!-- Ad Terms -->
                <asp:Panel ID="pnlTerms" runat="server" Visible="false">
                    <div class="glass-card p-4 mb-4" data-aos="fade-up">
                        <h5 class="text-white mb-3"><i class="fas fa-file-contract text-gold me-2"></i>Trade Terms</h5>
                        <div class="p-3" style="background: rgba(255, 255, 255, 0.02); border-radius: 10px;">
                            <asp:Literal ID="litAdTerms" runat="server" />
                        </div>
                    </div>
                </asp:Panel>
            </div>

            <!-- RIGHT: Action Panel -->
            <div class="col-lg-4">
                <div class="glass-card p-4 sticky-top" style="top: 20px;" data-aos="fade-left">
                    
                    <!-- Status Badge -->
                    <div class="text-center mb-4">
                        <div class='badge badge-gold fs-5 px-4 py-2' id="tradeStatusBadge">
                            <asp:Literal ID="litStatusBadge" runat="server" />
                        </div>
                    </div>

                    <!-- BUYER Actions -->
                    <asp:Panel ID="pnlBuyerActions" runat="server" Visible="false">
                        <!-- Status 0: Mark as Paid -->
                        <asp:Panel ID="pnlMarkAsPaid" runat="server" Visible="false">
                            <div class="alert alert-info mb-3" style="background: rgba(0, 212, 255, 0.1); border: 1px solid rgba(0, 212, 255, 0.3); color: var(--secondary);">
                                <i class="fas fa-info-circle me-2"></i>
                                Send <strong>$<asp:Literal ID="litFiatAmount2" runat="server" /></strong> to the seller via <strong><asp:Literal ID="litPaymentMethod2" runat="server" /></strong>, then click below.
                            </div>
                            <asp:Button ID="btnMarkAsPaid" runat="server" Text="✓ I Have Sent Payment" 
                                CssClass="btn btn-primary-glow w-100 py-3 mb-2" OnClick="btnMarkAsPaid_Click"
                                OnClientClick="return confirm('Have you actually sent the payment? False claims may result in account suspension.');" />
                        </asp:Panel>

                        <!-- Status 1: Waiting -->
                        <asp:Panel ID="pnlBuyerWaiting" runat="server" Visible="false">
                            <div class="text-center py-3">
                                <i class="fas fa-hourglass-half fa-3x text-gold mb-3"></i>
                                <h5 class="text-white">Payment Confirmed</h5>
                                <p class="text-muted">Waiting for seller to release funds...</p>
                            </div>
                        </asp:Panel>

                        <!-- Status 2: Completed -->
                        <asp:Panel ID="pnlBuyerCompleted" runat="server" Visible="false">
                            <div class="text-center py-3">
                                <i class="fas fa-check-circle fa-3x text-accent mb-3"></i>
                                <h5 class="text-white">Trade Complete!</h5>
                                <p class="text-muted"><asp:Literal ID="litCryptoReceived" runat="server" /> <asp:Literal ID="litCurrencyReceived" runat="server" /> added to your wallet.</p>
                                <a href="Wallet.aspx" class="btn btn-primary-glow w-100">View Wallet</a>
                            </div>
                        </asp:Panel>
                    </asp:Panel>

                    <!-- SELLER Actions -->
                    <asp:Panel ID="pnlSellerActions" runat="server" Visible="false">
                        <!-- Status 0: Waiting for payment -->
                        <asp:Panel ID="pnlSellerWaitingPayment" runat="server" Visible="false">
                            <div class="text-center py-3">
                                <i class="fas fa-hourglass-start fa-3x text-gold mb-3"></i>
                                <h5 class="text-white">Awaiting Payment</h5>
                                <p class="text-muted">Waiting for buyer to send <strong>$<asp:Literal ID="litFiatAmount3" runat="server" /></strong>...</p>
                            </div>
                        </asp:Panel>

                        <!-- Status 1: Release Funds -->
                        <asp:Panel ID="pnlReleaseFunds" runat="server" Visible="false">
                            <div class="alert alert-success mb-3" style="background: rgba(0, 255, 178, 0.1); border: 1px solid rgba(0, 255, 178, 0.3); color: var(--accent);">
                                <i class="fas fa-bell me-2"></i>
                                <strong>Buyer claims payment sent!</strong> Verify the funds in your account before releasing.
                            </div>
                            <asp:Button ID="btnReleaseFunds" runat="server" Text="🔓 Release Funds to Buyer" 
                                CssClass="btn btn-success w-100 py-3 mb-2" OnClick="btnReleaseFunds_Click"
                                OnClientClick="return confirm('Have you verified the payment in your account? This action cannot be undone.');" />
                        </asp:Panel>

                        <!-- Status 2: Completed -->
                        <asp:Panel ID="pnlSellerCompleted" runat="server" Visible="false">
                            <div class="text-center py-3">
                                <i class="fas fa-check-circle fa-3x text-accent mb-3"></i>
                                <h5 class="text-white">Trade Complete!</h5>
                                <p class="text-muted">You received <strong>$<asp:Literal ID="litFiatReceived" runat="server" /></strong> from the buyer.</p>
                                <a href="P2P.aspx" class="btn btn-primary-glow w-100">Back to Marketplace</a>
                            </div>
                        </asp:Panel>
                    </asp:Panel>

                    <!-- Cancel Button (Both roles, Status 0 or 1) -->
                    <asp:Panel ID="pnlCancelTrade" runat="server" Visible="false">
                        <hr style="border-color: var(--glass-border);" class="my-3">
                        <asp:Button ID="btnCancelTrade" runat="server" Text="Cancel Trade" 
                            CssClass="btn btn-outline-danger w-100" OnClick="btnCancelTrade_Click"
                            OnClientClick="return confirm('Are you sure you want to cancel this trade?');" />
                    </asp:Panel>

                    <!-- Completed/Cancelled States -->
                    <asp:Panel ID="pnlFinalState" runat="server" Visible="false">
                        <div class="text-center py-3">
                            <i class="fas fa-flag-checkered fa-3x text-muted mb-3"></i>
                            <h5 class="text-white">Trade Closed</h5>
                            <p class="text-muted"><asp:Literal ID="litFinalStatus" runat="server" /></p>
                            <a href="P2P.aspx" class="btn btn-outline-glass w-100 mt-2">Back to Marketplace</a>
                        </div>
                    </asp:Panel>

                    <!-- Support / Dispute -->
                    <hr style="border-color: var(--glass-border);" class="my-3">
                    <div class="text-center">
                        <small class="text-muted d-block mb-2">Need help?</small>
                        <a href="#" class="text-secondary small" onclick="openDispute(); return false;">
                            <i class="fas fa-gavel me-1"></i> Open Dispute
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        // Countdown Timer
        document.addEventListener('DOMContentLoaded', function() {
            const minutesRemaining = parseInt('<%= hfMinutesRemaining.Value %>');
            const timerEl = document.getElementById('countdownTimer');
            
            if (minutesRemaining > 0 && timerEl) {
                let totalSeconds = minutesRemaining * 60;
                
                function updateTimer() {
                    const mins = Math.floor(totalSeconds / 60);
                    const secs = totalSeconds % 60;
                    timerEl.textContent = `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
                    
                    if (totalSeconds <= 300) {
                        timerEl.style.color = '#ff3b5c'; // Red when < 5 min
                    }
                    
                    if (totalSeconds <= 0) {
                        timerEl.textContent = 'EXPIRED';
                        clearInterval(timerInterval);
                        setTimeout(() => location.reload(), 2000);
                    }
                    totalSeconds--;
                }
                
                updateTimer();
                const timerInterval = setInterval(updateTimer, 1000);
            }
        });

        function openDispute() {
            if (confirm('Opening a dispute will freeze this trade. Admin will review within 24 hours. Continue?')) {
                alert('Dispute feature coming soon. Please contact support@yourdomain.com');
            }
        }
    </script>
</asp:Content>