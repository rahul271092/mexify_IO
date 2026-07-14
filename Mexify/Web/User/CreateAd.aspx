<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="CreateAd.aspx.cs" Inherits="Mexify.Web.User.CreateAd" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .ad-type-toggle {
            display: flex;
            gap: 12px;
            margin-bottom: 24px;
        }
        .ad-type-btn {
            flex: 1;
            padding: 20px;
            background: var(--glass-bg);
            border: 2px solid var(--glass-border);
            border-radius: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
            color: var(--text-white);
        }
        .ad-type-btn:hover {
            border-color: var(--secondary);
            transform: translateY(-2px);
        }
        .ad-type-btn.active-buy {
            background: linear-gradient(135deg, rgba(0, 255, 178, 0.1), rgba(0, 212, 255, 0.05));
            border-color: var(--accent);
            box-shadow: 0 0 20px rgba(0, 255, 178, 0.2);
        }
        .ad-type-btn.active-sell {
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.1), rgba(255, 165, 0, 0.05));
            border-color: var(--gold);
            box-shadow: 0 0 20px rgba(255, 215, 0, 0.2);
        }
        .ad-type-btn i {
            font-size: 2rem;
            margin-bottom: 8px;
            display: block;
        }
        .ad-type-btn .label {
            font-weight: 700;
            font-size: 1.1rem;
            margin-bottom: 4px;
        }
        .ad-type-btn .desc {
            font-size: 0.8rem;
            color: var(--text-muted);
        }

        .payment-method-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap: 10px;
        }
        .payment-method-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 14px;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .payment-method-item:hover {
            border-color: var(--secondary);
        }
        .payment-method-item.selected {
            background: rgba(255, 215, 0, 0.08);
            border-color: var(--gold);
        }
        .payment-method-item input[type="checkbox"] {
            accent-color: var(--gold);
            width: 18px;
            height: 18px;
        }
        .payment-method-item label {
            cursor: pointer;
            color: var(--text-white);
            font-size: 0.9rem;
            margin: 0;
            flex: 1;
        }

        .balance-display {
            padding: 14px 18px;
            background: rgba(255, 215, 0, 0.05);
            border: 1px solid rgba(255, 215, 0, 0.2);
            border-radius: 10px;
            margin-top: 8px;
        }
        .balance-display.insufficient {
            background: rgba(255, 59, 92, 0.05);
            border-color: rgba(255, 59, 92, 0.3);
        }

        .preview-card {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 14px;
            padding: 20px;
            margin-top: 20px;
        }
        .preview-card .preview-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }
        .preview-price {
            font-size: 1.8rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--gold), #FFA500);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .step-indicator {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
            position: relative;
        }
        .step-indicator::before {
            content: '';
            position: absolute;
            top: 20px;
            left: 0;
            right: 0;
            height: 2px;
            background: var(--glass-border);
            z-index: 0;
        }
        .step {
            position: relative;
            z-index: 1;
            text-align: center;
            flex: 1;
        }
        .step-circle {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--bg-secondary);
            border: 2px solid var(--glass-border);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 8px;
            color: var(--text-muted);
            font-weight: 700;
            transition: all 0.3s ease;
        }
        .step.active .step-circle {
            background: linear-gradient(135deg, var(--gold), #FFA500);
            border-color: var(--gold);
            color: #000;
            box-shadow: 0 0 15px rgba(255, 215, 0, 0.4);
        }
        .step.completed .step-circle {
            background: var(--accent);
            border-color: var(--accent);
            color: #000;
        }
        .step-label {
            font-size: 0.8rem;
            color: var(--text-muted);
        }
        .step.active .step-label {
            color: var(--gold);
            font-weight: 600;
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4" data-aos="fade-up">
        <div>
            <h2 class="text-white mb-1"><i class="fas fa-plus-circle text-gold me-2"></i>Create P2P Ad</h2>
            <p class="text-muted mb-0">Set up your own buy or sell offer on the marketplace.</p>
        </div>
        <a href="P2P.aspx" class="btn btn-outline-glass">
            <i class="fas fa-arrow-left me-2"></i> Back to Marketplace
        </a>
    </div>

    <!-- Step Indicator -->
    <div class="step-indicator" data-aos="fade-up">
        <div class="step active" id="step1">
            <div class="step-circle">1</div>
            <div class="step-label">Ad Type</div>
        </div>
        <div class="step" id="step2">
            <div class="step-circle">2</div>
            <div class="step-label">Details</div>
        </div>
        <div class="step" id="step3">
            <div class="step-circle">3</div>
            <div class="step-label">Payment</div>
        </div>
        <div class="step" id="step4">
            <div class="step-circle">4</div>
            <div class="step-label">Review</div>
        </div>
    </div>

    <!-- Success Message -->
    <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
        <div class="glass-card p-5 text-center" style="border-color: rgba(0, 255, 178, 0.3);">
            <i class="fas fa-check-circle fa-4x text-accent mb-3"></i>
            <h3 class="text-white">Ad Created Successfully!</h3>
            <p class="text-muted mb-4">Your P2P ad is now live on the marketplace.</p>
            <div class="d-flex justify-content-center gap-3">
                <a href="P2P.aspx" class="btn btn-primary-glow">
                    <i class="fas fa-store me-2"></i> View Marketplace
                </a>
                <a href="MyAds.aspx" class="btn btn-outline-glass">
                    <i class="fas fa-list me-2"></i> My Ads
                </a>
            </div>
        </div>
    </asp:Panel>

    <!-- Main Form -->
    <asp:Panel ID="pnlForm" runat="server">
        <div class="row g-4">
            
            <!-- LEFT: Form -->
            <div class="col-lg-8">
                
                <!-- STEP 1: Ad Type -->
                <div class="glass-card p-4 mb-4" data-aos="fade-up">
                    <h5 class="text-white mb-3"><i class="fas fa-exchange-alt text-gold me-2"></i>Step 1: Choose Ad Type</h5>
                    
                    <div class="ad-type-toggle">
                        <div class="ad-type-btn active-buy" id="btnTypeBuy" onclick="selectAdType('BUY')">
                            <i class="fas fa-arrow-down text-accent"></i>
                            <div class="label">BUY Crypto</div>
                            <div class="desc">I want to buy crypto from others</div>
                        </div>
                        <div class="ad-type-btn" id="btnTypeSell" onclick="selectAdType('SELL')">
                            <i class="fas fa-arrow-up text-gold"></i>
                            <div class="label">SELL Crypto</div>
                            <div class="desc">I want to sell my crypto</div>
                        </div>
                    </div>

                    <asp:HiddenField ID="hfAdType" runat="server" Value="BUY" />
                </div>

                <!-- STEP 2: Ad Details -->
                <div class="glass-card p-4 mb-4" data-aos="fade-up">
                    <h5 class="text-white mb-3"><i class="fas fa-cog text-gold me-2"></i>Step 2: Ad Details</h5>

                    <div class="row g-3">
                        <!-- Crypto Currency -->
                        <div class="col-md-6">
                            <label class="form-label text-muted small">Cryptocurrency</label>
                            <asp:DropDownList ID="ddlCryptoCurrency" runat="server" CssClass="form-select bg-dark text-white border-secondary" AutoPostBack="true" OnSelectedIndexChanged="ddlCryptoCurrency_SelectedIndexChanged">
                                <asp:ListItem Value="USDT" Text="USDT (Tether)"></asp:ListItem>
                                <asp:ListItem Value="PNC" Text="PNC (Platform Token)"></asp:ListItem>
                                <asp:ListItem Value="BTC" Text="BTC (Bitcoin)"></asp:ListItem>
                                <asp:ListItem Value="ETH" Text="ETH (Ethereum)"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <!-- Fiat Currency -->
                        <div class="col-md-6">
                            <label class="form-label text-muted small">Fiat Currency</label>
                            <asp:DropDownList ID="ddlFiatCurrency" runat="server" CssClass="form-select bg-dark text-white border-secondary">
                                <asp:ListItem Value="USD" Text="USD - US Dollar"></asp:ListItem>
                                <asp:ListItem Value="EUR" Text="EUR - Euro"></asp:ListItem>
                                <asp:ListItem Value="GBP" Text="GBP - British Pound"></asp:ListItem>
                                <asp:ListItem Value="INR" Text="INR - Indian Rupee"></asp:ListItem>
                                <asp:ListItem Value="NGN" Text="NGN - Nigerian Naira"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <!-- Price -->
                        <div class="col-12">
                            <label class="form-label text-muted small">Price per 1 <span id="priceCryptoLabel">USDT</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-secondary text-white border-secondary" id="priceFiatSymbol">$</span>
                                <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control bg-dark text-white border-secondary" TextMode="Number" placeholder="1.00" step="0.0001" oninput="updatePreview()"></asp:TextBox>
                            </div>
                            <small class="text-muted mt-1 d-block">Set your own price. Competitive prices attract more traders.</small>
                            <asp:RequiredFieldValidator ID="rfvPrice" runat="server" ControlToValidate="txtPrice" ErrorMessage="Price is required" ForeColor="#ff3b5c" Display="Dynamic" />
                        </div>

                        <!-- Min Limit -->
                        <div class="col-md-6">
                            <label class="form-label text-muted small">Minimum Limit</label>
                            <div class="input-group">
                                <span class="input-group-text bg-secondary text-white border-secondary">$</span>
                                <asp:TextBox ID="txtMinLimit" runat="server" CssClass="form-control bg-dark text-white border-secondary" TextMode="Number" placeholder="10.00" step="0.01" oninput="updatePreview()"></asp:TextBox>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvMinLimit" runat="server" ControlToValidate="txtMinLimit" ErrorMessage="Min limit required" ForeColor="#ff3b5c" Display="Dynamic" />
                        </div>

                        <!-- Max Limit -->
                        <div class="col-md-6">
                            <label class="form-label text-muted small">Maximum Limit</label>
                            <div class="input-group">
                                <span class="input-group-text bg-secondary text-white border-secondary">$</span>
                                <asp:TextBox ID="txtMaxLimit" runat="server" CssClass="form-control bg-dark text-white border-secondary" TextMode="Number" placeholder="1000.00" step="0.01" oninput="updatePreview()"></asp:TextBox>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvMaxLimit" runat="server" ControlToValidate="txtMaxLimit" ErrorMessage="Max limit required" ForeColor="#ff3b5c" Display="Dynamic" />
                        </div>

                        <!-- Balance Display (SELL only) -->
                        <div class="col-12">
                            <asp:Panel ID="pnlBalanceDisplay" runat="server" Visible="false">
                                <div class="balance-display" id="balanceBox">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <small class="text-muted"><i class="fas fa-wallet me-1"></i> Your Available Balance</small>
                                        <strong class="text-gold"><asp:Literal ID="litAvailableBalance" runat="server" Text="0.00" /> <asp:Literal ID="litBalanceCurrency" runat="server" Text="USDT" /></strong>
                                    </div>
                                    <small class="text-muted mt-1 d-block" id="balanceNote">Your max limit cannot exceed your available balance.</small>
                                </div>
                            </asp:Panel>
                        </div>
                    </div>
                </div>

                <!-- STEP 3: Payment Methods -->
                <div class="glass-card p-4 mb-4" data-aos="fade-up">
                    <h5 class="text-white mb-3"><i class="fas fa-credit-card text-gold me-2"></i>Step 3: Payment Methods</h5>
                    <small class="text-muted d-block mb-3">Select all payment methods you accept.</small>

                    <div class="payment-method-grid">
                        <div class="payment-method-item" onclick="togglePayment(this)">
                            <input type="checkbox" id="pm_bank" value="Bank Transfer" runat="server" />
                            <label for="pm_bank"><i class="fas fa-university me-1"></i> Bank Transfer</label>
                        </div>
                        <div class="payment-method-item" onclick="togglePayment(this)">
                            <input type="checkbox" id="pm_paypal" value="PayPal" runat="server" />
                            <label for="pm_paypal"><i class="fab fa-paypal me-1"></i> PayPal</label>
                        </div>
                        <div class="payment-method-item" onclick="togglePayment(this)">
                            <input type="checkbox" id="pm_wise" value="Wise" runat="server" />
                            <label for="pm_wise"><i class="fas fa-exchange-alt me-1"></i> Wise</label>
                        </div>
                        <div class="payment-method-item" onclick="togglePayment(this)">
                            <input type="checkbox" id="pm_revolut" value="Revolut" runat="server" />
                            <label for="pm_revolut"><i class="fas fa-credit-card me-1"></i> Revolut</label>
                        </div>
                        <div class="payment-method-item" onclick="togglePayment(this)">
                            <input type="checkbox" id="pm_venmo" value="Venmo" runat="server" />
                            <label for="pm_venmo"><i class="fas fa-mobile-alt me-1"></i> Venmo</label>
                        </div>
                        <div class="payment-method-item" onclick="togglePayment(this)">
                            <input type="checkbox" id="pm_cashapp" value="Cash App" runat="server" />
                            <label for="pm_cashapp"><i class="fas fa-dollar-sign me-1"></i> Cash App</label>
                        </div>
                        <div class="payment-method-item" onclick="togglePayment(this)">
                            <input type="checkbox" id="pm_zelle" value="Zelle" runat="server" />
                            <label for="pm_zelle"><i class="fas fa-bolt me-1"></i> Zelle</label>
                        </div>
                        <div class="payment-method-item" onclick="togglePayment(this)">
                            <input type="checkbox" id="pm_cash" value="Cash in Person" runat="server" />
                            <label for="pm_cash"><i class="fas fa-money-bill-wave me-1"></i> Cash (In Person)</label>
                        </div>
                    </div>

                    <asp:HiddenField ID="hfPaymentMethods" runat="server" />
                    <asp:CustomValidator ID="cvPaymentMethods" runat="server" ErrorMessage="Please select at least one payment method" ForeColor="#ff3b5c" Display="Dynamic" />
                </div>

                <!-- Terms & Conditions -->
                <div class="glass-card p-4 mb-4" data-aos="fade-up">
                    <h5 class="text-white mb-3"><i class="fas fa-file-contract text-gold me-2"></i>Trade Terms (Optional)</h5>
                    <asp:TextBox ID="txtTerms" runat="server" CssClass="form-control bg-dark text-white border-secondary" 
                        TextMode="MultiLine" Rows="4" placeholder="e.g., I will release funds within 10 minutes of receiving payment. No chargebacks. Please send payment within 15 minutes of trade initiation."></asp:TextBox>
                    <small class="text-muted mt-1 d-block">These terms will be shown to traders before they start a trade with you.</small>
                </div>

                <!-- Error Message -->
                <asp:Panel ID="pnlError" runat="server" Visible="false">
                    <div class="alert alert-danger" style="background: rgba(255, 59, 92, 0.1); border: 1px solid rgba(255, 59, 92, 0.3); color: #ff3b5c;">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        <asp:Literal ID="litErrorMessage" runat="server" />
                    </div>
                </asp:Panel>

                <!-- Submit Button -->
                <asp:Button ID="btnCreateAd" runat="server" Text="🚀 Publish Ad" CssClass="btn btn-primary-glow w-100 py-3" OnClick="btnCreateAd_Click" OnClientClick="return validateForm();" />
            </div>

            <!-- RIGHT: Live Preview -->
            <div class="col-lg-4">
                <div class="sticky-top" style="top: 20px;" data-aos="fade-left">
                    <div class="glass-card p-4">
                        <h5 class="text-white mb-3"><i class="fas fa-eye text-gold me-2"></i>Live Preview</h5>
                        <small class="text-muted d-block mb-3">This is how your ad will appear on the marketplace.</small>

                        <div class="preview-card">
                            <div class="preview-header">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="badge badge-accent" id="previewTypeBadge">BUY</span>
                                    <h6 class="text-white mb-0" id="previewPair">USDT / USD</h6>
                                </div>
                            </div>

                            <div class="preview-price" id="previewPrice">$1.00</div>
                            <small class="text-muted d-block mb-3">per 1 <span id="previewCrypto">USDT</span></small>

                            <div class="mb-3">
                                <small class="text-muted d-block">Limits</small>
                                <div class="text-white fw-600">
                                    $<span id="previewMin">10.00</span> - $<span id="previewMax">1000.00</span> <span id="previewFiat">USD</span>
                                </div>
                            </div>

                            <div class="mb-3">
                                <small class="text-muted d-block">Payment Methods</small>
                                <div class="text-white small" id="previewPayments">
                                    <em class="text-muted">None selected</em>
                                </div>
                            </div>

                            <div class="pt-2" style="border-top: 1px solid var(--glass-border);">
                                <div class="d-flex justify-content-between align-items-center">
                                    <small class="text-muted">Merchant</small>
                                    <strong class="text-white"><asp:Literal ID="litPreviewMerchant" runat="server" Text="You" /></strong>
                                </div>
                            </div>
                        </div>

                        <div class="mt-3 p-3" style="background: rgba(0, 212, 255, 0.05); border: 1px solid rgba(0, 212, 255, 0.2); border-radius: 10px;">
                            <small class="text-muted d-block mb-1"><i class="fas fa-info-circle me-1"></i> Tips</small>
                            <ul class="small text-muted mb-0 ps-3">
                                <li>Competitive prices get more trades</li>
                                <li>Offer multiple payment methods</li>
                                <li>Clear terms prevent disputes</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        let currentAdType = 'BUY';
        let availableBalance = parseFloat('<%= litAvailableBalance.Text.Replace(",", "") %>') || 0;

        // Select ad type
        function selectAdType(type) {
            currentAdType = type;
            document.getElementById('<%= hfAdType.ClientID %>').value = type;
            
            const buyBtn = document.getElementById('btnTypeBuy');
            const sellBtn = document.getElementById('btnTypeSell');
            
            buyBtn.classList.remove('active-buy', 'active-sell');
            sellBtn.classList.remove('active-buy', 'active-sell');
            
            if (type === 'BUY') {
                buyBtn.classList.add('active-buy');
            } else {
                sellBtn.classList.add('active-sell');
            }

            // Update step indicator
            updateStepIndicator(1);
            updatePreview();
        }

        // Toggle payment method selection
        function togglePayment(element) {
            const checkbox = element.querySelector('input[type="checkbox"]');
            checkbox.checked = !checkbox.checked;
            element.classList.toggle('selected', checkbox.checked);
            updatePaymentMethodsHidden();
            updatePreview();
        }

        // Update hidden field with selected payment methods
        function updatePaymentMethodsHidden() {
            const selected = [];
            document.querySelectorAll('.payment-method-item input[type="checkbox"]:checked').forEach(cb => {
                selected.push(cb.value);
            });
            document.getElementById('<%= hfPaymentMethods.ClientID %>').value = selected.join(', ');
        }

        // Update live preview
        function updatePreview() {
            const crypto = document.getElementById('<%= ddlCryptoCurrency.ClientID %>').value;
            const fiat = document.getElementById('<%= ddlFiatCurrency.ClientID %>').value;
            const price = document.getElementById('<%= txtPrice.ClientID %>').value || '0.00';
            const min = document.getElementById('<%= txtMinLimit.ClientID %>').value || '0.00';
            const max = document.getElementById('<%= txtMaxLimit.ClientID %>').value || '0.00';

            // Update preview elements
            document.getElementById('previewTypeBadge').textContent = currentAdType;
            document.getElementById('previewTypeBadge').className = 'badge ' + (currentAdType === 'BUY' ? 'badge-accent' : 'badge-gold');
            document.getElementById('previewPair').textContent = crypto + ' / ' + fiat;
            document.getElementById('previewPrice').textContent = (fiat === 'USD' ? '$' : fiat + ' ') + parseFloat(price || 0).toFixed(2);
            document.getElementById('previewCrypto').textContent = crypto;
            document.getElementById('previewMin').textContent = parseFloat(min || 0).toFixed(2);
            document.getElementById('previewMax').textContent = parseFloat(max || 0).toFixed(2);
            document.getElementById('previewFiat').textContent = fiat;

            // Update payment methods preview
            const selectedPayments = [];
            document.querySelectorAll('.payment-method-item input[type="checkbox"]:checked').forEach(cb => {
                selectedPayments.push(cb.value);
            });
            const paymentsEl = document.getElementById('previewPayments');
            if (selectedPayments.length === 0) {
                paymentsEl.innerHTML = '<em class="text-muted">None selected</em>';
            } else {
                paymentsEl.innerHTML = selectedPayments.map(p => '<span class="badge badge-muted me-1 mb-1">' + p + '</span>').join('');
            }

            // Validate max limit against balance for SELL ads
            if (currentAdType === 'SELL') {
                const maxVal = parseFloat(max || 0);
                const priceVal = parseFloat(price || 0);
                const cryptoNeeded = priceVal > 0 ? maxVal / priceVal : 0;
                const balanceBox = document.getElementById('balanceBox');
                const balanceNote = document.getElementById('balanceNote');
                
                if (cryptoNeeded > availableBalance && availableBalance > 0) {
                    balanceBox.classList.add('insufficient');
                    balanceNote.innerHTML = '<i class="fas fa-exclamation-triangle text-danger"></i> <span class="text-danger">Max limit requires ' + cryptoNeeded.toFixed(4) + ' ' + crypto + ' but you only have ' + availableBalance.toFixed(4) + '</span>';
                } else {
                    balanceBox.classList.remove('insufficient');
                    balanceNote.innerHTML = 'Your max limit cannot exceed your available balance.';
                }
            }
        }

        // Update step indicator
        function updateStepIndicator(currentStep) {
            for (let i = 1; i <= 4; i++) {
                const step = document.getElementById('step' + i);
                step.classList.remove('active', 'completed');
                if (i < currentStep) step.classList.add('completed');
                else if (i === currentStep) step.classList.add('active');
            }
        }

        // Validate form before submit
        function validateForm() {
            const price = parseFloat(document.getElementById('<%= txtPrice.ClientID %>').value || 0);
            const min = parseFloat(document.getElementById('<%= txtMinLimit.ClientID %>').value || 0);
            const max = parseFloat(document.getElementById('<%= txtMaxLimit.ClientID %>').value || 0);
            const payments = document.getElementById('<%= hfPaymentMethods.ClientID %>').value;

            if (price <= 0) {
                alert('Please enter a valid price.');
                return false;
            }
            if (min <= 0) {
                alert('Please enter a minimum limit.');
                return false;
            }
            if (max <= 0) {
                alert('Please enter a maximum limit.');
                return false;
            }
            if (min >= max) {
                alert('Minimum limit must be less than maximum limit.');
                return false;
            }
            if (!payments || payments.trim() === '') {
                alert('Please select at least one payment method.');
                return false;
            }

            // Check balance for SELL ads
            if (currentAdType === 'SELL') {
                const crypto = document.getElementById('<%= ddlCryptoCurrency.ClientID %>').value;
                const cryptoNeeded = max / price;
                if (cryptoNeeded > availableBalance) {
                    if (!confirm('Warning: Your max limit requires ' + cryptoNeeded.toFixed(4) + ' ' + crypto + ' but you only have ' + availableBalance.toFixed(4) + '. Continue anyway?')) {
                        return false;
                    }
                }
            }

            return confirm('Are you sure you want to publish this ad? It will be visible to all users on the marketplace.');
        }

        // Initialize on load
        document.addEventListener('DOMContentLoaded', function() {
            updatePreview();
            updatePaymentMethodsHidden();
            
            // Add change listeners to dropdowns
            document.getElementById('<%= ddlCryptoCurrency.ClientID %>').addEventListener('change', updatePreview);
            document.getElementById('<%= ddlFiatCurrency.ClientID %>').addEventListener('change', updatePreview);
        });
    </script>
</asp:Content>