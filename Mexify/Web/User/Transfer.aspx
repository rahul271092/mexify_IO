<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="Transfer.aspx.cs" Inherits="Mexify.Web.User.Transfer" %>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex justify-content-between align-items-center mb-4" data-aos="fade-up">
        <div>
            <h2 class="text-white mb-1"><i class="fas fa-paper-plane text-gold me-2"></i>Send Funds</h2>
            <p class="text-muted mb-0">Transfer crypto instantly to another MEXIFY user.</p>
        </div>
        <a href="Receive.aspx" class="btn btn-outline-glass">
            <i class="fas fa-qrcode me-2"></i> Receive
        </a>
    </div>

    <!-- Success Message -->
    <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
        <div class="glass-card p-4 mb-4 text-center" style="border-color: rgba(0, 255, 178, 0.3);">
            <i class="fas fa-check-circle fa-3x text-accent mb-3"></i>
            <h4 class="text-white">Transfer Successful!</h4>
            <p class="text-muted"><asp:Literal ID="litSuccessMessage" runat="server" /></p>
            <div class="d-flex justify-content-center gap-3 mt-3">
                <a href="Transfer.aspx" class="btn btn-primary-glow">Send Another</a>
                <a href="Transactions.aspx" class="btn btn-outline-glass">View History</a>
            </div>
        </div>
    </asp:Panel>

    <!-- Transfer Form -->
    <asp:Panel ID="pnlForm" runat="server">
        <div class="row g-4">
            <!-- Left: Form -->
            <div class="col-lg-7" data-aos="fade-up">
                <div class="glass-card p-4">
                    <h5 class="text-white mb-4">Transfer Details</h5>

                    <!-- Currency Selection -->
                    <div class="mb-3">
                        <label class="form-label text-muted small">Currency</label>
                        <asp:DropDownList ID="ddlCurrency" runat="server" CssClass="form-select bg-dark text-white border-secondary" AutoPostBack="true" OnSelectedIndexChanged="ddlCurrency_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>

                    <!-- Recipient Address -->
                    <div class="mb-3">
                        <label class="form-label text-muted small">Recipient Wallet Address</label>
                        <asp:TextBox ID="txtRecipientAddress" runat="server" CssClass="form-control bg-dark text-white border-secondary" placeholder="MX-USDT-XXXXXXXX" style="font-family: 'Courier New', monospace; text-transform: uppercase;"></asp:TextBox>
                        <small class="text-muted mt-1 d-block">Enter the recipient's MEXIFY wallet address</small>
                        <asp:RequiredFieldValidator ID="rfvAddress" runat="server" ControlToValidate="txtRecipientAddress" ErrorMessage="Recipient address is required" ForeColor="#ff3b5c" Display="Dynamic" />
                    </div>

                    <!-- Amount -->
                    <div class="mb-3">
                        <label class="form-label text-muted small">Amount</label>
                        <div class="input-group">
                            <asp:TextBox ID="txtAmount" runat="server" CssClass="form-control bg-dark text-white border-secondary" TextMode="Number" placeholder="0.00" step="0.0001"></asp:TextBox>
                            <span class="input-group-text bg-secondary text-white border-secondary">
                                <asp:Literal ID="litCurrencyCode" runat="server" Text="USDT" />
                            </span>
                        </div>
                        <div class="d-flex justify-content-between mt-1">
                            <small class="text-muted">Available: <strong class="text-gold"><asp:Literal ID="litAvailableBalance" runat="server" Text="0.00" /></strong></small>
                            <a href="#" class="text-secondary small" onclick="setMaxAmount(); return false;">Max</a>
                        </div>
                        <asp:RequiredFieldValidator ID="rfvAmount" runat="server" ControlToValidate="txtAmount" ErrorMessage="Amount is required" ForeColor="#ff3b5c" Display="Dynamic" />
                    </div>

                    <!-- Memo (Optional) -->
                    <div class="mb-4">
                        <label class="form-label text-muted small">Memo (Optional)</label>
                        <asp:TextBox ID="txtMemo" runat="server" CssClass="form-control bg-dark text-white border-secondary" TextMode="MultiLine" Rows="2" placeholder="Add a note (optional)"></asp:TextBox>
                    </div>

                    <!-- Fee Info -->
                    <div class="p-3 mb-4" style="background: rgba(0, 212, 255, 0.05); border: 1px solid rgba(0, 212, 255, 0.2); border-radius: 12px;">
                        <div class="d-flex justify-content-between mb-2">
                            <small class="text-muted">Transfer Fee</small>
                            <small class="text-accent fw-600">FREE</small>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <small class="text-muted">Processing Time</small>
                            <small class="text-white fw-600">Instant</small>
                        </div>
                        <div class="d-flex justify-content-between">
                            <small class="text-muted">Network</small>
                            <small class="text-white fw-600">MEXIFY Internal</small>
                        </div>
                    </div>

                    <!-- Error Message -->
                    <asp:Panel ID="pnlError" runat="server" Visible="false">
                        <div class="alert alert-danger mb-3" style="background: rgba(255, 59, 92, 0.1); border: 1px solid rgba(255, 59, 92, 0.3); color: #ff3b5c;">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            <asp:Literal ID="litErrorMessage" runat="server" />
                        </div>
                    </asp:Panel>

                    <!-- Submit Button -->
                    <asp:Button ID="btnSend" runat="server" Text="Send Funds" CssClass="btn btn-primary-glow w-100 py-3" OnClick="btnSend_Click" />
                </div>
            </div>

            <!-- Right: Your Addresses -->
            <div class="col-lg-5" data-aos="fade-up" data-aos-delay="100">
                <div class="glass-card p-4 h-100">
                    <h5 class="text-white mb-3"><i class="fas fa-address-card text-gold me-2"></i>Your Wallet Addresses</h5>
                    <p class="text-muted small mb-3">Share these addresses to receive funds from other MEXIFY users.</p>
                    
                    <asp:Repeater ID="rptMyAddresses" runat="server">
                        <ItemTemplate>
                            <div class="p-3 mb-2" style="background: rgba(255, 255, 255, 0.02); border: 1px solid var(--glass-border); border-radius: 10px;">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <strong class="text-white"><%# Eval("CurrencyCode") %></strong>
                                    <span class="text-gold small"><%# string.Format("{0:0.00}", Eval("Balance")) %></span>
                                </div>
                                <div class="d-flex justify-content-between align-items-center">
                                    <code class="text-secondary small" style="font-size: 0.75rem;"><%# Eval("WalletAddress") %></code>
                                    <button type="button" class="btn btn-sm btn-outline p-1 px-2" onclick="copyToClipboard('<%# Eval("WalletAddress") %>')">
                                        <i class="fas fa-copy"></i>
                                    </button>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
    </asp:Panel>

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        function setMaxAmount() {
            const balance = '<%= litAvailableBalance.Text %>';
            document.getElementById('<%= txtAmount.ClientID %>').value = balance;
        }

        function copyToClipboard(text) {
            navigator.clipboard.writeText(text).then(() => {
                alert('Address copied!');
            });
        }
    </script>
</asp:Content>