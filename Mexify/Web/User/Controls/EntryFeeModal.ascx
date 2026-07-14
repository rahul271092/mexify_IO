<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EntryFeeModal.ascx.cs" Inherits="Mexify.Web.User.Controls.EntryFeeModal" %>
<!-- Entry Fee Modal -->
<div id="entryFeeModal" class="modal fade" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content" style="background: var(--bg-secondary); border: 1px solid var(--glass-border); border-radius: 20px;">
            
            <!-- Header -->
            <div class="modal-header border-0 pb-0">
                <div class="text-center w-100">
                    <div style="width: 80px; height: 80px; margin: 0 auto 16px; background: linear-gradient(135deg, rgba(255, 215, 0, 0.2), rgba(255, 165, 0, 0.1)); border: 2px solid rgba(255, 215, 0, 0.3); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                        <i class="fas fa-crown" style="font-size: 2.5rem; color: var(--gold);"></i>
                    </div>
                    <h3 class="text-gradient-gold mb-2">Complete Your Registration</h3>
                    <p class="text-muted mb-0">Pay the one-time entry fee to unlock full platform access</p>
                </div>
            </div>

            <!-- Body -->
            <div class="modal-body px-4 py-4">
                
                <!-- Step 1: Payment -->
                <div id="efStep1">
                    <!-- Amount Display -->
                    <div class="text-center mb-4">
                        <div class="display-1 text-gradient-gold fw-800">$15</div>
                        <small class="text-muted">One-time entry fee · Paid in USDT</small>
                    </div>

                    <!-- Distribution Breakdown -->
                    <div class="row g-3 mb-4">
                        <div class="col-4">
                            <div class="p-3 text-center" style="background: rgba(255, 215, 0, 0.05); border: 1px solid rgba(255, 215, 0, 0.2); border-radius: 12px;">
                                <i class="fas fa-user-friends text-gold mb-2" style="font-size: 1.5rem;"></i>
                                <div class="text-white fw-700 fs-5">$5</div>
                                <small class="text-muted d-block">Direct Referral</small>
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="p-3 text-center" style="background: rgba(0, 212, 255, 0.05); border: 1px solid rgba(0, 212, 255, 0.2); border-radius: 12px;">
                                <i class="fas fa-shield-alt text-secondary mb-2" style="font-size: 1.5rem;"></i>
                                <div class="text-white fw-700 fs-5">$5</div>
                                <small class="text-muted d-block">Admin Fee</small>
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="p-3 text-center" style="background: rgba(156, 39, 176, 0.05); border: 1px solid rgba(156, 39, 176, 0.2); border-radius: 12px;">
                                <i class="fas fa-gem mb-2" style="font-size: 1.5rem; color: #9C27B0;"></i>
                                <div class="text-white fw-700 fs-5">$5</div>
                                <small class="text-muted d-block">Royalty Pool</small>
                            </div>
                        </div>
                    </div>

                    <!-- Wallet Info -->
                    <div class="mb-3 p-3" style="background: rgba(255, 255, 255, 0.02); border-radius: 12px;">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <small class="text-muted">Your Wallet</small>
                            <span class="badge badge-accent">Connected</span>
                        </div>
                        <div class="text-white fw-600" style="font-family: 'Courier New', monospace; font-size: 0.85rem; word-break: break-all;" id="efUserWallet">-</div>
                    </div>

                    <div class="mb-3 p-3" style="background: rgba(255, 255, 255, 0.02); border-radius: 12px;">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <small class="text-muted">Platform Wallet</small>
                            <span class="badge badge-muted">Receiving</span>
                        </div>
                        <div class="text-white fw-600" style="font-family: 'Courier New', monospace; font-size: 0.85rem; word-break: break-all;" id="efPlatformWallet">-</div>
                    </div>

                    <!-- Network Warning -->
                    <div class="alert alert-warning mb-3" style="background: rgba(255, 193, 7, 0.1); border: 1px solid rgba(255, 193, 7, 0.3); color: #ffc107;">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <small><strong>Important:</strong> Payment must be made on <strong>BNB Smart Chain (BSC)</strong> network. Make sure you have at least <strong>15 USDT</strong> in your wallet.</small>
                    </div>

                    <!-- Pay Button -->
                    <button type="button" id="efPayBtn" class="btn btn-primary-glow w-100 py-3" onclick="entryFeeModal.payFee()">
                        <i class="fas fa-paper-plane me-2"></i>
                        Pay $15 USDT Now
                    </button>

                    <div class="text-center mt-3">
                        <small class="text-muted">
                            <i class="fas fa-lock me-1"></i>
                            Secured by blockchain · No intermediaries
                        </small>
                    </div>
                </div>

                <!-- Step 2: Confirming -->
                <div id="efStep2" style="display: none;">
                    <div class="text-center py-4">
                        <div class="spinner-border text-gold mb-3" style="width: 4rem; height: 4rem;"></div>
                        <h4 class="text-white mb-2">Verifying Transaction</h4>
                        <p class="text-muted mb-4">Waiting for blockchain confirmations...</p>
                        
                        <div class="mb-4">
                            <div class="d-flex justify-content-between mb-2">
                                <small class="text-muted">Confirmations</small>
                                <small class="text-gold fw-700" id="efConfirmCount">0 / 12</small>
                            </div>
                            <div class="progress" style="height: 8px; background: rgba(255, 255, 255, 0.05);">
                                <div id="efConfirmBar" class="progress-bar progress-gold" style="width: 0%;"></div>
                            </div>
                        </div>

                        <div class="p-3" style="background: rgba(255, 255, 255, 0.02); border-radius: 12px;">
                            <small class="text-muted d-block mb-1">Transaction Hash</small>
                            <a href="#" id="efTxHashLink" target="_blank" class="text-gold" style="font-family: 'Courier New', monospace; font-size: 0.8rem; word-break: break-all;">-</a>
                        </div>

                        <button type="button" class="btn btn-outline mt-3" onclick="entryFeeModal.cancelPayment()">
                            Cancel
                        </button>
                    </div>
                </div>

                <!-- Step 3: Success -->
                <div id="efStep3" style="display: none;">
                    <div class="text-center py-4">
                        <div style="width: 100px; height: 100px; margin: 0 auto 24px; background: linear-gradient(135deg, rgba(0, 255, 178, 0.2), rgba(0, 212, 255, 0.1)); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                            <i class="fas fa-check-circle" style="font-size: 4rem; color: var(--accent);"></i>
                        </div>
                        <h3 class="text-white mb-2">Payment Successful!</h3>
                        <p class="text-muted mb-4">Your entry fee has been distributed:</p>

                        <div class="row g-3 mb-4">
                            <div class="col-4">
                                <div class="p-3 text-center" style="background: rgba(255, 215, 0, 0.05); border: 1px solid rgba(255, 215, 0, 0.2); border-radius: 12px;">
                                    <i class="fas fa-user-friends text-gold mb-2"></i>
                                    <div class="text-white fw-700">$5</div>
                                    <small class="text-muted">Referrer</small>
                                </div>
                            </div>
                            <div class="col-4">
                                <div class="p-3 text-center" style="background: rgba(0, 212, 255, 0.05); border: 1px solid rgba(0, 212, 255, 0.2); border-radius: 12px;">
                                    <i class="fas fa-shield-alt text-secondary mb-2"></i>
                                    <div class="text-white fw-700">$5</div>
                                    <small class="text-muted">Admin</small>
                                </div>
                            </div>
                            <div class="col-4">
                                <div class="p-3 text-center" style="background: rgba(156, 39, 176, 0.05); border: 1px solid rgba(156, 39, 176, 0.2); border-radius: 12px;">
                                    <i class="fas fa-gem mb-2" style="color: #9C27B0;"></i>
                                    <div class="text-white fw-700">$5</div>
                                    <small class="text-muted">Royalty</small>
                                </div>
                            </div>
                        </div>

                        <div class="alert" style="background: rgba(0, 255, 178, 0.05); border: 1px solid rgba(0, 255, 178, 0.3); color: var(--accent);">
                            <i class="fas fa-unlock me-2"></i>
                            <strong>Welcome to MEXIFY!</strong> You now have full access to all platform features.
                        </div>

                        <a href="Dashboard.aspx" class="btn btn-primary-glow w-100 py-3">
                            <i class="fas fa-rocket me-2"></i>
                            Go to Dashboard
                        </a>
                    </div>
                </div>

                <!-- Step 4: Error -->
                <div id="efStep4" style="display: none;">
                    <div class="text-center py-4">
                        <div style="width: 100px; height: 100px; margin: 0 auto 24px; background: rgba(255, 59, 92, 0.1); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                            <i class="fas fa-exclamation-triangle" style="font-size: 4rem; color: #ff3b5c;"></i>
                        </div>
                        <h3 class="text-white mb-2">Payment Failed</h3>
                        <p class="text-muted mb-4" id="efErrorMessage">An error occurred during payment.</p>

                        <div class="d-grid gap-2">
                            <button type="button" class="btn btn-primary-glow" onclick="entryFeeModal.resetToStep1()">
                                <i class="fas fa-redo me-2"></i>
                                Try Again
                            </button>
                            <button type="button" class="btn btn-outline" onclick="entryFeeModal.skipForNow()">
                                Skip for Now (Limited Access)
                            </button>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<script>
// Entry Fee Modal Controller
const entryFeeModal = {
    platformWallet: '<%= PlatformWalletAddress %>',
    usdtContract: '0x55d398326f99059fF775485246999027B3197955', // BSC USDT
    amount: '15',
    chainId: '0x38', // 56 = BSC Mainnet
    userWallet: '<%= UserWalletAddress %>',
    currentTxHash: null,
    verificationAttempts: 0,
    maxAttempts: 60,

    init() {
        document.getElementById('efUserWallet').textContent = this.userWallet;
        document.getElementById('efPlatformWallet').textContent = this.platformWallet;
    },

    showStep(step) {
        for (let i = 1; i <= 4; i++) {
            document.getElementById('efStep' + i).style.display = i === step ? 'block' : 'none';
        }
    },

    async payFee() {
        const btn = document.getElementById('efPayBtn');
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Processing...';

        try {
            // Check MetaMask
            if (typeof window.ethereum === 'undefined') {
                throw new Error('MetaMask not installed');
            }

            // Check network
            const chainId = await window.ethereum.request({ method: 'eth_chainId' });
            if (chainId !== this.chainId) {
                await this.switchToBSC();
            }

            // Request accounts
            const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
            const fromAddress = accounts[0];

            // Verify wallet matches
            if (fromAddress.toLowerCase() !== this.userWallet.toLowerCase()) {
                throw new Error('Please use the same wallet you registered with');
            }

            // Prepare USDT transfer
            const amount = ethers.utils.parseUnits(this.amount, 18);
            const transferABI = ['function transfer(address to, uint256 amount) returns (bool)'];
            
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            const signer = provider.getSigner();
            const contract = new ethers.Contract(this.usdtContract, transferABI, signer);

            // Send transaction
            btn.innerHTML = '<i class="fas fa-hourglass-half fa-spin me-2"></i>Confirm in MetaMask...';
            const tx = await contract.transfer(this.platformWallet, amount);
            
            this.currentTxHash = tx.hash;
            
            // Show confirmation step
            this.showStep(2);
            document.getElementById('efTxHashLink').textContent = tx.hash;
            document.getElementById('efTxHashLink').href = `https://bscscan.com/tx/${tx.hash}`;

            // Wait for transaction
            btn.innerHTML = '<i class="fas fa-hourglass-half fa-spin me-2"></i>Waiting for confirmation...';
            const receipt = await tx.wait();

            // Record pending payment
            await this.recordPendingPayment(receipt.transactionHash, fromAddress);

            // Start verification
            this.verifyTransaction();

        } catch (error) {
            console.error('Payment error:', error);
            this.showError(error.message || 'Payment failed');
        }
    },

    async switchToBSC() {
        try {
            await window.ethereum.request({
                method: 'wallet_switchEthereumChain',
                params: [{ chainId: this.chainId }],
            });
        } catch (switchError) {
            if (switchError.code === 4902) {
                await window.ethereum.request({
                    method: 'wallet_addEthereumChain',
                    params: [{
                        chainId: this.chainId,
                        chainName: 'BNB Smart Chain',
                        nativeCurrency: { name: 'BNB', symbol: 'BNB', decimals: 18 },
                        rpcUrls: ['https://bsc-dataseed.binance.org/'],
                        blockExplorerUrls: ['https://bscscan.com']
                    }],
                });
            } else {
                throw switchError;
            }
        }
    },

    async recordPendingPayment(txHash, fromWallet) {
        const formData = new FormData();
        formData.append('txHash', txHash);
        formData.append('fromWallet', fromWallet);
        formData.append('amount', this.amount);

        const response = await fetch('/Web/API/EntryFeeAPI.aspx?action=record', {
            method: 'POST',
            body: formData
        });
        const result = await response.json();

        if (!result.success) {
            throw new Error(result.message || 'Failed to record payment');
        }
    },

    async verifyTransaction() {
        this.verificationAttempts++;

        try {
            const formData = new FormData();
            formData.append('txHash', this.currentTxHash);

            const response = await fetch('/Web/API/EntryFeeAPI.aspx?action=verify', {
                method: 'POST',
                body: formData
            });
            const result = await response.json();

            if (result.success) {
                // Success!
                this.showStep(3);
                return;
            }

            // Update progress
            const match = result.message?.match(/Current: (\d+)/);
            if (match) {
                const current = parseInt(match[1]);
                const percent = (current / 12) * 100;
                document.getElementById('efConfirmCount').textContent = `${current} / 12`;
                document.getElementById('efConfirmBar').style.width = percent + '%';
            }

            if (this.verificationAttempts < this.maxAttempts) {
                setTimeout(() => this.verifyTransaction(), 5000);
            } else {
                this.showError('Verification timeout. Your payment is recorded and will be processed automatically.');
            }
        } catch (error) {
            console.error('Verification error:', error);
            if (this.verificationAttempts < this.maxAttempts) {
                setTimeout(() => this.verifyTransaction(), 5000);
            }
        }
    },

    cancelPayment() {
        if (confirm('Are you sure you want to cancel? Your transaction is still processing on the blockchain.')) {
            this.skipForNow();
        }
    },

    skipForNow() {
        // Mark as skipped in session
        fetch('/Web/API/EntryFeeAPI.aspx?action=skip', { method: 'POST' })
            .then(() => window.location.href = 'Dashboard.aspx');
    },

    resetToStep1() {
        this.showStep(1);
        document.getElementById('efPayBtn').disabled = false;
        document.getElementById('efPayBtn').innerHTML = '<i class="fas fa-paper-plane me-2"></i>Pay $15 USDT Now';
    },

    showError(message) {
        this.showStep(4);
        document.getElementById('efErrorMessage').textContent = message;
    }
};

// Initialize when modal is shown
document.addEventListener('DOMContentLoaded', function() {
    const modal = document.getElementById('entryFeeModal');
    if (modal) {
        modal.addEventListener('shown.bs.modal', () => entryFeeModal.init());
        
        // Auto-show if pending
        if (window.showEntryFeeModal) {
            const bsModal = new bootstrap.Modal(modal);
            bsModal.show();
        }
    }
});
</script>