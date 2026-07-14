<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="Mexify.Web.User.Settings" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .settings-nav {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .settings-nav-item {
            padding: 12px 16px;
            border-radius: 10px;
            color: var(--text-muted);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 12px;
            transition: all 0.2s ease;
            cursor: pointer;
            border: 1px solid transparent;
        }
        .settings-nav-item:hover {
            background: var(--glass-bg);
            color: var(--text-white);
        }
        .settings-nav-item.active {
            background: rgba(255, 215, 0, 0.1);
            color: var(--gold);
            border-color: rgba(255, 215, 0, 0.3);
        }
        .settings-nav-item i { width: 20px; text-align: center; }
        
        .settings-section { display: none; }
        .settings-section.active { display: block; }
        
        .avatar-wrapper {
            width: 100px; height: 100px;
            border-radius: 50%;
            background: var(--glass-bg);
            border: 2px solid var(--glass-border);
            display: flex; align-items: center; justify-content: center;
            font-size: 2.5rem; color: var(--text-muted);
            margin-bottom: 16px;
            position: relative;
        }
        .avatar-wrapper img { width: 100%; height: 100%; border-radius: 50%; object-fit: cover; }
        
        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 48px; height: 24px;
        }
        .toggle-switch input { opacity: 0; width: 0; height: 0; }
        .toggle-slider {
            position: absolute; cursor: pointer;
            top: 0; left: 0; right: 0; bottom: 0;
            background: #333; border-radius: 24px;
            transition: .3s;
        }
        .toggle-slider:before {
            position: absolute; content: "";
            height: 18px; width: 18px;
            left: 3px; bottom: 3px;
            background: white; border-radius: 50%;
            transition: .3s;
        }
        input:checked + .toggle-slider { background: var(--gold); }
        input:checked + .toggle-slider:before { transform: translateX(24px); }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="d-flex justify-content-between align-items-center mb-4" data-aos="fade-up">
        <div>
            <h2 class="text-white mb-1"><i class="fas fa-cog text-gold me-2"></i>Account Settings</h2>
            <p class="text-muted mb-0">Manage your profile, security, and preferences.</p>
        </div>
    </div>

    <div class="row g-4">
        <!-- Left: Navigation -->
        <div class="col-lg-3">
            <div class="glass-card p-3 sticky-top" style="top: 20px;">
                <div class="settings-nav">
                    <div class="settings-nav-item active" onclick="showSection('profile')">
                        <i class="fas fa-user"></i> Profile
                    </div>
                    <div class="settings-nav-item" onclick="showSection('security')">
                        <i class="fas fa-shield-alt"></i> Security & Password
                    </div>
                    <div class="settings-nav-item" onclick="showSection('notifications')">
                        <i class="fas fa-bell"></i> Notifications
                    </div>
                    <div class="settings-nav-item" onclick="showSection('preferences')">
                        <i class="fas fa-sliders-h"></i> Preferences
                    </div>
                </div>
            </div>
        </div>

        <!-- Right: Content -->
        <div class="col-lg-9">
            <!-- Toast Notification -->
            <div id="toast" class="alert alert-success position-fixed" style="top: 80px; right: 20px; z-index: 9999; display: none; min-width: 300px;">
                <i class="fas fa-check-circle me-2"></i>
                <span id="toastMessage">Settings saved successfully!</span>
            </div>

            <!-- PROFILE SECTION -->
            <div id="sec-profile" class="settings-section active glass-card p-4" data-aos="fade-up">
                <h4 class="text-white mb-4">Profile Information</h4>
                
                <div class="avatar-wrapper mx-auto mb-4">
                    <i class="fas fa-user"></i>
                    <asp:Image ID="imgAvatar" runat="server" Visible="false" CssClass="rounded-circle" />
                </div>

                <asp:UpdatePanel ID="upProfile" runat="server">
                    <ContentTemplate>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label text-muted small">First Name</label>
                                <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control bg-dark text-white border-secondary" />
                                <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="txtFirstName" ErrorMessage="Required" ForeColor="#ff3b5c" Display="Dynamic" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted small">Last Name</label>
                                <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control bg-dark text-white border-secondary" />
                                <asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="txtLastName" ErrorMessage="Required" ForeColor="#ff3b5c" Display="Dynamic" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted small">Email Address</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control bg-dark text-white border-secondary" TextMode="Email" />
                                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Invalid email" ForeColor="#ff3b5c" Display="Dynamic" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted small">Phone Number</label>
                                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control bg-dark text-white border-secondary" TextMode="Phone" placeholder="+1 (555) 000-0000" />
                            </div>
                        </div>

                        <asp:Panel ID="pnlProfileMsg" runat="server" Visible="false">
                            <div class='alert <%# ProfileMessageClass %>' style="margin-top: 16px;">
                                <asp:Literal ID="litProfileMsg" runat="server" />
                            </div>
                        </asp:Panel>

                        <div class="mt-4 d-flex justify-content-end">
                            <asp:Button ID="btnSaveProfile" runat="server" Text="Save Changes" CssClass="btn btn-primary-glow" OnClick="btnSaveProfile_Click" />
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>

            <!-- SECURITY SECTION -->
            <div id="sec-security" class="settings-section glass-card p-4" data-aos="fade-up">
                <h4 class="text-white mb-4">Security & Password</h4>
                
                <!-- Wallet Info -->
                <div class="p-3 mb-4" style="background: rgba(255, 215, 0, 0.05); border: 1px solid rgba(255, 215, 0, 0.2); border-radius: 10px;">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <small class="text-muted fw-bold">Connected Wallet (MetaMask)</small>
                        <span class="badge badge-success">Connected</span>
                    </div>
                    <code class="text-white" style="word-break: break-all;"><asp:Literal ID="litWalletAddress" runat="server" Text="Not connected" /></code>
                </div>

                <!-- Change Password -->
                <h5 class="text-white mt-4 mb-3">Change Password</h5>
                <asp:UpdatePanel ID="upPassword" runat="server">
                    <ContentTemplate>
                        <div class="row g-3">
                            <div class="col-12">
                                <label class="form-label text-muted small">Current Password</label>
                                <asp:TextBox ID="txtCurrentPwd" runat="server" CssClass="form-control bg-dark text-white border-secondary" TextMode="Password" />
                                <asp:RequiredFieldValidator ID="rfvCurrentPwd" runat="server" ControlToValidate="txtCurrentPwd" ErrorMessage="Required" ForeColor="#ff3b5c" Display="Dynamic" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted small">New Password</label>
                                <asp:TextBox ID="txtNewPwd" runat="server" CssClass="form-control bg-dark text-white border-secondary" TextMode="Password" />
                                <asp:RequiredFieldValidator ID="rfvNewPwd" runat="server" ControlToValidate="txtNewPwd" ErrorMessage="Required" ForeColor="#ff3b5c" Display="Dynamic" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted small">Confirm New Password</label>
                                <asp:TextBox ID="txtConfirmPwd" runat="server" CssClass="form-control bg-dark text-white border-secondary" TextMode="Password" />
                                <asp:CompareValidator ID="cvPwdMatch" runat="server" ControlToValidate="txtConfirmPwd" ControlToCompare="txtNewPwd" Operator="Equal" Type="String" ErrorMessage="Passwords do not match" ForeColor="#ff3b5c" Display="Dynamic" />
                            </div>
                        </div>

                        <asp:Panel ID="pnlPwdMsg" runat="server" Visible="false">
                            <div class="alert alert-danger mt-3"><asp:Literal ID="litPwdMsg" runat="server" /></div>
                        </asp:Panel>

                        <div class="mt-4 d-flex justify-content-end">
                            <asp:Button ID="btnChangePwd" runat="server" Text="Update Password" CssClass="btn btn-primary-glow" OnClick="btnChangePwd_Click" />
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>

            <!-- NOTIFICATIONS SECTION -->
            <div id="sec-notifications" class="settings-section glass-card p-4" data-aos="fade-up">
                <h4 class="text-white mb-4">Notification Preferences</h4>
                <p class="text-muted mb-4">Choose how you'd like to receive updates and alerts.</p>

                <asp:UpdatePanel ID="upNotif" runat="server">
                    <ContentTemplate>
                        <div class="d-flex flex-column gap-4">
                            <div class="d-flex justify-content-between align-items-center p-3" style="background: var(--glass-bg); border-radius: 10px;">
                                <div>
                                    <div class="text-white fw-600">Email Notifications</div>
                                    <small class="text-muted">Trade confirmations, security alerts, and platform updates</small>
                                </div>
                                <label class="toggle-switch">
                                    <asp:CheckBox ID="chkEmailNotif" runat="server" CssClass="d-none" />
                                    <span class="toggle-slider"></span>
                                </label>
                            </div>

                            <div class="d-flex justify-content-between align-items-center p-3" style="background: var(--glass-bg); border-radius: 10px;">
                                <div>
                                    <div class="text-white fw-600">SMS Notifications</div>
                                    <small class="text-muted">Login alerts and critical account changes</small>
                                </div>
                                <label class="toggle-switch">
                                    <asp:CheckBox ID="chkSmsNotif" runat="server" CssClass="d-none" />
                                    <span class="toggle-slider"></span>
                                </label>
                            </div>

                            <div class="d-flex justify-content-between align-items-center p-3" style="background: var(--glass-bg); border-radius: 10px;">
                                <div>
                                    <div class="text-white fw-600">Push Notifications</div>
                                    <small class="text-muted">In-app alerts for deposits, withdrawals, and ROI</small>
                                </div>
                                <label class="toggle-switch">
                                    <asp:CheckBox ID="chkPushNotif" runat="server" CssClass="d-none" />
                                    <span class="toggle-slider"></span>
                                </label>
                            </div>
                        </div>

                        <asp:Panel ID="pnlNotifMsg" runat="server" Visible="false">
                            <div class="alert alert-success mt-3"><asp:Literal ID="litNotifMsg" runat="server" /></div>
                        </asp:Panel>

                        <div class="mt-4 d-flex justify-content-end">
                            <asp:Button ID="btnSaveNotif" runat="server" Text="Save Preferences" CssClass="btn btn-primary-glow" OnClick="btnSaveNotif_Click" />
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>

            <!-- PREFERENCES SECTION -->
            <div id="sec-preferences" class="settings-section glass-card p-4" data-aos="fade-up">
                <h4 class="text-white mb-4">Display Preferences</h4>
                
                <asp:UpdatePanel ID="upPrefs" runat="server">
                    <ContentTemplate>
                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <label class="form-label text-muted small">Interface Language</label>
                                <asp:DropDownList ID="ddlLanguage" runat="server" CssClass="form-select bg-dark text-white border-secondary">
                                    <asp:ListItem Value="en" Text="English"></asp:ListItem>
                                    <asp:ListItem Value="es" Text="Spanish"></asp:ListItem>
                                    <asp:ListItem Value="fr" Text="French"></asp:ListItem>
                                    <asp:ListItem Value="de" Text="German"></asp:ListItem>
                                    <asp:ListItem Value="hi" Text="Hindi"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted small">Default Currency Display</label>
                                <asp:DropDownList ID="ddlCurrency" runat="server" CssClass="form-select bg-dark text-white border-secondary">
                                    <asp:ListItem Value="USD" Text="USD - US Dollar"></asp:ListItem>
                                    <asp:ListItem Value="EUR" Text="EUR - Euro"></asp:ListItem>
                                    <asp:ListItem Value="GBP" Text="GBP - British Pound"></asp:ListItem>
                                    <asp:ListItem Value="PNC" Text="PNC - Platform Token"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>

                        <asp:Panel ID="pnlPrefMsg" runat="server" Visible="false">
                            <div class="alert alert-success mt-3"><asp:Literal ID="litPrefMsg" runat="server" /></div>
                        </asp:Panel>

                        <div class="mt-4 d-flex justify-content-end">
                            <asp:Button ID="btnSavePrefs" runat="server" Text="Save Preferences" CssClass="btn btn-primary-glow" OnClick="btnSavePrefs_Click" />
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>

                <hr class="my-4" style="border-color: var(--glass-border);">
                <h5 class="text-white mb-3">Danger Zone</h5>
                <div class="p-3" style="background: rgba(255, 59, 92, 0.05); border: 1px solid rgba(255, 59, 92, 0.2); border-radius: 10px;">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-white fw-600">Delete Account</div>
                            <small class="text-muted">Permanently remove your account and all associated data.</small>
                        </div>
                        <button type="button" class="btn btn-outline-danger" onclick="confirmDelete()">Delete Account</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        function showSection(id) {
            document.querySelectorAll('.settings-section').forEach(el => el.classList.remove('active'));
            document.querySelectorAll('.settings-nav-item').forEach(el => el.classList.remove('active'));
            
            document.getElementById('sec-' + id).classList.add('active');
            event.currentTarget.classList.add('active');
        }

        function showToast(message, type = 'success') {
            const toast = document.getElementById('toast');
            document.getElementById('toastMessage').textContent = message;
            toast.className = `alert alert-${type} position-fixed`;
            toast.style.display = 'block';
            setTimeout(() => toast.style.display = 'none', 4000);
        }

        function confirmDelete() {
            if (confirm('⚠️ Are you sure? This action cannot be undone. Type "DELETE" in the next prompt to confirm.')) {
                const input = prompt('Type DELETE to confirm account deletion:');
                if (input === 'DELETE') {
                    alert('Account deletion request submitted. Support will contact you within 24 hours.');
                }
            }
        }

        // Fix toggle switches on postback
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.toggle-switch input[type="checkbox"]').forEach(cb => {
                cb.addEventListener('change', function() {
                    this.closest('.toggle-switch').classList.toggle('active', this.checked);
                });
                // Init state
                cb.closest('.toggle-switch').classList.toggle('active', cb.checked);
            });
        });
    </script>
</asp:Content>