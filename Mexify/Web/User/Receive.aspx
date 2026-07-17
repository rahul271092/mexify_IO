<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="Receive.aspx.cs" Inherits="Mexify.Web.User.Receive" %>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex justify-content-between align-items-center mb-4" data-aos="fade-up">
        <div>
            <h2 class="text-white mb-1"><i class="fas fa-qrcode text-gold me-2"></i>Receive Funds</h2>
            <p class="text-muted mb-0">Share your wallet address to receive crypto from other MEXIFY users.</p>
        </div>
        <a href="Transfer.aspx" class="btn btn-outline-glass">
            <i class="fas fa-paper-plane me-2"></i> Send
        </a>

        &nbsp;
        <asp:LinkButton ID="CreateWalletLinkButton" runat="server" Text="Craete Wallet" CssClass="btn btn-outline-glass" OnClick="CreateWalletLinkButton_Click" />
    </div>

    <div class="row g-4">
        <asp:Repeater ID="rptAddresses" runat="server">
            <ItemTemplate>
                <div class="col-lg-6" data-aos="fade-up">
                    <div class="glass-card p-4 h-100">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <div>
                                <h5 class="text-white mb-1"><%# Eval("CurrencyName") %></h5>
                                <small class="text-muted">Balance: <strong class="text-gold"><%# string.Format("{0:0.00}", Eval("Balance")) %> <%# Eval("CurrencyCode") %></strong></small>
                            </div>
                            <span class="badge badge-accent">Active</span>
                        </div>

                        <!-- QR Code -->
                        <div class="text-center mb-3">
                            <div class='qrcode-<%# Eval("CurrencyCode") %>' style="background: #fff; padding: 12px; border-radius: 12px; display: inline-block;"></div>
                        </div>

                        <!-- Address -->
                        <div class="p-3 mb-3" style="background: rgba(255, 215, 0, 0.05); border: 1px solid rgba(255, 215, 0, 0.2); border-radius: 10px;">
                            <small class="text-muted d-block mb-1">Your <%# Eval("CurrencyCode") %> Address</small>
                            <code class="text-gold fw-700" style="font-size: 0.9rem; word-break: break-all;"><%# Eval("WalletAddress") %></code>
                        </div>

                        <!-- Actions -->
                        <div class="d-flex gap-2">
                            <button type="button" class="btn btn-primary-glow flex-fill" onclick="copyAddress('<%# Eval("WalletAddress") %>')">
                                <i class="fas fa-copy me-1"></i> Copy
                            </button>
                            <button type="button" class="btn btn-outline-glass flex-fill" onclick="shareAddress('<%# Eval("WalletAddress") %>', '<%# Eval("CurrencyCode") %>')">
                                <i class="fas fa-share me-1"></i> Share
                            </button>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <asp:Panel ID="pnlNoAddresses" runat="server" Visible="false">
        <div class="glass-card text-center p-5">
            <i class="fas fa-wallet fa-3x text-muted mb-3"></i>
            <h4 class="text-white">No Wallet Addresses</h4>
            <p class="text-muted">Wallet addresses are generated automatically when you deposit funds.</p>
        </div>
    </asp:Panel>

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/qrcodejs@1.0.0/qrcode.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('[id^="qrcode-"]').forEach(function(el) {
                const currency = el.id.replace('qrcode-', '');
                const address = el.closest('.glass-card').querySelector('code').textContent;
                new QRCode(el, {
                    text: 'mexify:' + address,
                    width: 180,
                    height: 180,
                    colorDark: '#000000',
                    colorLight: '#ffffff',
                    correctLevel: QRCode.CorrectLevel.H
                });
            });
        });

        function copyAddress(address) {
            navigator.clipboard.writeText(address).then(() => {
                showToast('Address copied to clipboard!', 'success');
            });
        }

        function shareAddress(address, currency) {
            if (navigator.share) {
                navigator.share({
                    title: 'My MEXIFY ' + currency + ' Address',
                    text: 'Send ' + currency + ' to my MEXIFY wallet: ' + address
                });
            } else {
                copyAddress(address);
            }
        }

        function showToast(message, type) {
            const toast = document.createElement('div');
            toast.className = 'alert alert-' + (type === 'success' ? 'success' : 'danger') + ' position-fixed';
            toast.style.cssText = 'bottom: 20px; right: 20px; z-index: 9999; min-width: 250px;';
            toast.innerHTML = '<i class="fas fa-' + (type === 'success' ? 'check-circle' : 'exclamation-circle') + ' me-2"></i>' + message;
            document.body.appendChild(toast);
            setTimeout(() => toast.remove(), 3000);
        }
    </script>
</asp:Content>