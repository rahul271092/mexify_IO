<%@ Page Title="" Language="C#" MasterPageFile="~/Web/MasterPages/UserMaster.Master" AutoEventWireup="true" CodeBehind="KYC.aspx.cs" Inherits="Mexify.Web.User.KYC" %>

<asp:Content ID="HeadContent1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .kyc-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            flex-wrap: wrap;
            gap: 16px;
        }
        .kyc-header h2 { color: var(--text-white); margin: 0; font-size: 1.8rem; }

        /* Status Banner */
        .kyc-status-banner {
            border-radius: var(--radius-xl);
            padding: 32px;
            margin-bottom: 32px;
            position: relative;
            overflow: hidden;
        }
        .kyc-status-banner.pending {
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.15), rgba(255, 165, 0, 0.1));
            border: 1px solid rgba(255, 215, 0, 0.3);
        }
        .kyc-status-banner.approved {
            background: linear-gradient(135deg, rgba(0, 255, 178, 0.15), rgba(0, 212, 255, 0.1));
            border: 1px solid rgba(0, 255, 178, 0.3);
        }
        .kyc-status-banner.rejected {
            background: linear-gradient(135deg, rgba(255, 59, 92, 0.15), rgba(255, 59, 92, 0.05));
            border: 1px solid rgba(255, 59, 92, 0.3);
        }
        .kyc-status-banner.not-started {
            background: linear-gradient(135deg, rgba(123, 44, 191, 0.15), rgba(157, 78, 221, 0.1));
            border: 1px solid rgba(157, 78, 221, 0.3);
        }
        .status-icon {
            width: 64px; height: 64px;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.8rem;
            margin-bottom: 16px;
        }
        .status-icon.pending { background: rgba(255, 215, 0, 0.2); color: var(--gold); }
        .status-icon.approved { background: rgba(0, 255, 178, 0.2); color: var(--accent); }
        .status-icon.rejected { background: rgba(255, 59, 92, 0.2); color: #ff3b5c; }
        .status-icon.not-started { background: rgba(157, 78, 221, 0.2); color: var(--secondary); }

        /* Progress Steps */
        .kyc-progress {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
            position: relative;
        }
        .kyc-progress::before {
            content: '';
            position: absolute;
            top: 24px;
            left: 10%;
            right: 10%;
            height: 2px;
            background: var(--glass-border);
            z-index: 0;
        }
        .progress-step {
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
            z-index: 1;
            flex: 1;
        }
        .step-circle {
            width: 48px; height: 48px;
            border-radius: 50%;
            background: var(--glass-bg);
            border: 2px solid var(--glass-border);
            display: flex; align-items: center; justify-content: center;
            font-weight: 700;
            color: var(--text-muted);
            margin-bottom: 8px;
            transition: all 0.3s ease;
        }
        .step-circle.active {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-color: var(--secondary);
            color: var(--text-white);
            box-shadow: 0 0 20px rgba(157, 78, 221, 0.4);
        }
        .step-circle.completed {
            background: linear-gradient(135deg, var(--accent), #00D4FF);
            border-color: var(--accent);
            color: var(--text-white);
        }
        .step-label {
            font-size: 0.8rem;
            color: var(--text-muted);
            text-align: center;
            font-weight: 500;
        }
        .step-label.active { color: var(--text-white); font-weight: 600; }
        .step-label.completed { color: var(--accent); }

        /* Form Sections */
        .kyc-section {
            background: var(--glass-bg);
            backdrop-filter: blur(var(--glass-blur));
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 32px;
            margin-bottom: 24px;
        }
        .section-title {
            color: var(--text-white);
            font-size: 1.2rem;
            font-weight: 700;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .section-title i { color: var(--secondary); }

        /* Form Inputs */
        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        .form-group { margin-bottom: 20px; }
        .form-group label {
            display: block;
            color: var(--text-white);
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 8px;
        }
        .form-group label .required { color: #ff3b5c; }
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 14px;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--glass-border);
            border-radius: 10px;
            color: var(--text-white);
            font-size: 0.92rem;
            transition: all 0.3s ease;
        }
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--secondary);
            background: rgba(157, 78, 221, 0.03);
            box-shadow: 0 0 0 3px rgba(157, 78, 221, 0.1);
        }
        .form-group select option { background: var(--bg-secondary); }
        .form-group input:disabled,
        .form-group select:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        /* File Upload */
        .upload-area {
            border: 2px dashed var(--glass-border);
            border-radius: var(--radius-md);
            padding: 32px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.02);
            position: relative;
        }
        .upload-area:hover {
            border-color: var(--secondary);
            background: rgba(157, 78, 221, 0.05);
        }
        .upload-area.has-file {
            border-color: var(--accent);
            border-style: solid;
        }
        .upload-icon {
            font-size: 2.5rem;
            color: var(--text-muted);
            margin-bottom: 12px;
        }
        .upload-text {
            color: var(--text-gray);
            font-size: 0.9rem;
            margin-bottom: 8px;
        }
        .upload-hint {
            color: var(--text-muted);
            font-size: 0.75rem;
        }
        .upload-preview {
            max-width: 100%;
            max-height: 200px;
            border-radius: 8px;
            margin-top: 12px;
        }
        .upload-input {
            position: absolute;
            inset: 0;
            opacity: 0;
            cursor: pointer;
        }

        /* Document Type Selector */
        .doc-type-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 12px;
            margin-bottom: 24px;
        }
        .doc-type-option {
            padding: 16px;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-md);
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .doc-type-option:hover {
            border-color: var(--secondary);
        }
        .doc-type-option.selected {
            border-color: var(--accent);
            background: rgba(157, 78, 221, 0.1);
        }
        .doc-type-option i {
            font-size: 1.5rem;
            color: var(--secondary);
            margin-bottom: 8px;
            display: block;
        }
        .doc-type-option span {
            font-size: 0.85rem;
            color: var(--text-gray);
        }

        /* Buttons */
        .kyc-actions {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            margin-top: 32px;
            flex-wrap: wrap;
        }
        .btn-kyc {
            padding: 12px 28px;
            border-radius: 50px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-kyc.primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: var(--text-white);
            box-shadow: 0 4px 15px rgba(123, 44, 191, 0.4);
        }
        .btn-kyc.primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(157, 78, 221, 0.6);
        }
        .btn-kyc.secondary {
            background: transparent;
            border: 1px solid var(--glass-border);
            color: var(--text-gray);
        }
        .btn-kyc.secondary:hover {
            background: var(--glass-bg);
            color: var(--text-white);
        }
        .btn-kyc:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        /* Alerts */
        .alert-box {
            padding: 14px 18px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 0.9rem;
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }
        .alert-box.error { background: rgba(255, 59, 92, 0.1); border: 1px solid rgba(255, 59, 92, 0.3); color: #ff3b5c; }
        .alert-box.success { background: rgba(0, 255, 178, 0.1); border: 1px solid rgba(0, 255, 178, 0.3); color: var(--accent); }
        .alert-box.warning { background: rgba(255, 215, 0, 0.1); border: 1px solid rgba(255, 215, 0, 0.3); color: var(--gold); }
        .alert-box.info { background: rgba(0, 212, 255, 0.1); border: 1px solid rgba(0, 212, 255, 0.3); color: var(--secondary); }

        /* Info Cards */
        .info-card {
            background: rgba(0, 212, 255, 0.05);
            border: 1px solid rgba(0, 212, 255, 0.2);
            border-radius: var(--radius-md);
            padding: 16px;
            margin-bottom: 20px;
            display: flex;
            gap: 12px;
        }
        .info-card i {
            color: var(--secondary);
            font-size: 1.2rem;
            margin-top: 2px;
        }
        .info-card-content { flex: 1; }
        .info-card-title {
            color: var(--text-white);
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 4px;
        }
        .info-card-text {
            color: var(--text-gray);
            font-size: 0.85rem;
        }

        /* Hidden sections */
        .kyc-step { display: none; }
        .kyc-step.active { display: block; }

        @media (max-width: 768px) {
            .kyc-progress { flex-wrap: wrap; gap: 16px; }
            .kyc-progress::before { display: none; }
            .form-row { grid-template-columns: 1fr; }
            .kyc-section { padding: 20px; }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Header -->
    <div class="kyc-header" data-aos="fade-up">
        <div>
            <h2>KYC Verification</h2>
            <p class="text-gray mb-0">Complete identity verification to unlock all platform features</p>
        </div>
    </div>

    <!-- Status Banner -->
    <asp:Panel ID="pnlStatusBanner" runat="server" data-aos="fade-up">
        <div id="statusBanner" class="kyc-status-banner not-started">
            <div class="row align-items-center">
                <div class="col-auto">
                    <div class="status-icon not-started" id="statusIcon">
                        <i class="fas fa-id-card"></i>
                    </div>
                </div>
                <div class="col">
                    <h4 class="text-white mb-1" id="statusTitle">
                        <asp:Literal ID="litStatusTitle" runat="server" Text="Verification Not Started"></asp:Literal>
                    </h4>
                    <p class="text-gray mb-0" id="statusMessage">
                        <asp:Literal ID="litStatusMessage" runat="server" Text="Complete the steps below to verify your identity and unlock full access to deposits, withdrawals, and trading."></asp:Literal>
                    </p>
                    <asp:Panel ID="pnlRejectionReason" runat="server" Visible="false">
                        <div class="alert-box error mt-3">
                            <i class="fas fa-exclamation-circle"></i>
                            <div>
                                <strong>Reason:</strong>
                                <asp:Literal ID="litRejectionReason" runat="server"></asp:Literal>
                            </div>
                        </div>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </asp:Panel>

    <!-- Messages -->
    <asp:Panel ID="pnlError" runat="server" Visible="false">
        <div class="alert-box error">
            <i class="fas fa-exclamation-circle"></i>
            <asp:Literal ID="litError" runat="server"></asp:Literal>
        </div>
    </asp:Panel>
    <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
        <div class="alert-box success">
            <i class="fas fa-check-circle"></i>
            <asp:Literal ID="litSuccess" runat="server"></asp:Literal>
        </div>
    </asp:Panel>

    <!-- Progress Steps -->
    <div class="kyc-progress" data-aos="fade-up">
        <div class="progress-step">
            <div class="step-circle active" id="stepCircle1">1</div>
            <div class="step-label active" id="stepLabel1">Personal Info</div>
        </div>
        <div class="progress-step">
            <div class="step-circle" id="stepCircle2">2</div>
            <div class="step-label" id="stepLabel2">ID Document</div>
        </div>
        <div class="progress-step">
            <div class="step-circle" id="stepCircle3">3</div>
            <div class="step-label" id="stepLabel3">Selfie & Address</div>
        </div>
        <div class="progress-step">
            <div class="step-circle" id="stepCircle4">4</div>
            <div class="step-label" id="stepLabel4">Review</div>
        </div>
    </div>

    <!-- =========================================
         STEP 1: PERSONAL INFORMATION
         ========================================= -->
    <div id="step1" class="kyc-step active" data-aos="fade-up">
        <div class="kyc-section">
            <h3 class="section-title">
                <i class="fas fa-user"></i> Personal Information
            </h3>

            <div class="info-card">
                <i class="fas fa-info-circle"></i>
                <div class="info-card-content">
                    <div class="info-card-title">Why do we need this?</div>
                    <div class="info-card-text">We collect this information to comply with international regulations and to keep your account secure. Your data is encrypted and never shared.</div>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>First Name <span class="required">*</span></label>
                    <asp:TextBox ID="txtFirstName" runat="server" placeholder="John"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Last Name <span class="required">*</span></label>
                    <asp:TextBox ID="txtLastName" runat="server" placeholder="Doe"></asp:TextBox>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Date of Birth <span class="required">*</span></label>
                    <asp:TextBox ID="txtDOB" runat="server" TextMode="Date"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Nationality <span class="required">*</span></label>
                    <asp:DropDownList ID="ddlNationality" runat="server">
                        <asp:ListItem Value="">Select Country</asp:ListItem>
                        <asp:ListItem Value="US">United States</asp:ListItem>
                        <asp:ListItem Value="GB">United Kingdom</asp:ListItem>
                        <asp:ListItem Value="CA">Canada</asp:ListItem>
                        <asp:ListItem Value="AU">Australia</asp:ListItem>
                        <asp:ListItem Value="DE">Germany</asp:ListItem>
                        <asp:ListItem Value="FR">France</asp:ListItem>
                        <asp:ListItem Value="JP">Japan</asp:ListItem>
                        <asp:ListItem Value="SG">Singapore</asp:ListItem>
                        <asp:ListItem Value="AE">United Arab Emirates</asp:ListItem>
                        <asp:ListItem Value="IN">India</asp:ListItem>
                        <asp:ListItem Value="BR">Brazil</asp:ListItem>
                        <asp:ListItem Value="OTHER">Other</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>

            <div class="form-group">
                <label>Residential Address <span class="required">*</span></label>
                <asp:TextBox ID="txtAddress" runat="server" placeholder="123 Main Street, Apt 4B"></asp:TextBox>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>City <span class="required">*</span></label>
                    <asp:TextBox ID="txtCity" runat="server" placeholder="New York"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>State/Province</label>
                    <asp:TextBox ID="txtState" runat="server" placeholder="NY"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Postal Code <span class="required">*</span></label>
                    <asp:TextBox ID="txtPostalCode" runat="server" placeholder="10001"></asp:TextBox>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Phone Number <span class="required">*</span></label>
                    <asp:TextBox ID="txtPhone" runat="server" placeholder="+1 555 123 4567"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Occupation</label>
                    <asp:DropDownList ID="ddlOccupation" runat="server">
                        <asp:ListItem Value="">Select Occupation</asp:ListItem>
                        <asp:ListItem Value="employed">Employed</asp:ListItem>
                        <asp:ListItem Value="self-employed">Self-Employed</asp:ListItem>
                        <asp:ListItem Value="business-owner">Business Owner</asp:ListItem>
                        <asp:ListItem Value="investor">Investor</asp:ListItem>
                        <asp:ListItem Value="student">Student</asp:ListItem>
                        <asp:ListItem Value="retired">Retired</asp:ListItem>
                        <asp:ListItem Value="other">Other</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>

            <div class="kyc-actions">
                <div></div>
                <button type="button" class="btn-kyc primary" onclick="goToStep(2)">
                    Continue <i class="fas fa-arrow-right"></i>
                </button>
            </div>
        </div>
    </div>

    <!-- =========================================
         STEP 2: ID DOCUMENT
         ========================================= -->
    <div id="step2" class="kyc-step" data-aos="fade-up">
        <div class="kyc-section">
            <h3 class="section-title">
                <i class="fas fa-id-card"></i> Identity Document
            </h3>

            <div class="info-card">
                <i class="fas fa-shield-alt"></i>
                <div class="info-card-content">
                    <div class="info-card-title">Document Requirements</div>
                    <div class="info-card-text">
                        • Document must be valid and not expired<br>
                        • All four corners must be visible<br>
                        • Image must be clear and well-lit<br>
                        • Accepted formats: JPG, PNG, PDF (Max 5MB)
                    </div>
                </div>
            </div>

            <label class="form-group" style="display:block; margin-bottom: 12px;">
                Document Type <span class="required">*</span>
            </label>
            <div class="doc-type-grid">
                <div class="doc-type-option selected" data-type="passport" onclick="selectDocType(this)">
                    <i class="fas fa-passport"></i>
                    <span>Passport</span>
                </div>
                <div class="doc-type-option" data-type="national-id" onclick="selectDocType(this)">
                    <i class="fas fa-id-card"></i>
                    <span>National ID</span>
                </div>
                <div class="doc-type-option" data-type="drivers-license" onclick="selectDocType(this)">
                    <i class="fas fa-id-badge"></i>
                    <span>Driver's License</span>
                </div>
            </div>
            <asp:HiddenField ID="hfDocType" runat="server" Value="passport" />

            <div class="form-row">
                <div>
                    <label class="form-group" style="display:block; margin-bottom: 12px;">
                        Front Side <span class="required">*</span>
                    </label>
                    <div class="upload-area" id="frontUploadArea">
                        <i class="fas fa-cloud-upload-alt upload-icon"></i>
                        <div class="upload-text">Click or drag to upload front side</div>
                        <div class="upload-hint">JPG, PNG or PDF - Max 5MB</div>
                        <img id="frontPreview" class="upload-preview" style="display:none;" />
                        <asp:FileUpload ID="fuIdFront" runat="server" CssClass="upload-input" accept="image/*,application/pdf" onchange="previewImage(this, 'frontPreview', 'frontUploadArea')" />
                    </div>
                </div>
                <div>
                    <label class="form-group" style="display:block; margin-bottom: 12px;">
                        Back Side <span class="required">*</span>
                    </label>
                    <div class="upload-area" id="backUploadArea">
                        <i class="fas fa-cloud-upload-alt upload-icon"></i>
                        <div class="upload-text">Click or drag to upload back side</div>
                        <div class="upload-hint">JPG, PNG or PDF - Max 5MB</div>
                        <img id="backPreview" class="upload-preview" style="display:none;" />
                        <asp:FileUpload ID="fuIdBack" runat="server" CssClass="upload-input" accept="image/*,application/pdf" onchange="previewImage(this, 'backPreview', 'backUploadArea')" />
                    </div>
                </div>
            </div>

            <div class="kyc-actions">
                <button type="button" class="btn-kyc secondary" onclick="goToStep(1)">
                    <i class="fas fa-arrow-left"></i> Back
                </button>
                <button type="button" class="btn-kyc primary" onclick="goToStep(3)">
                    Continue <i class="fas fa-arrow-right"></i>
                </button>
            </div>
        </div>
    </div>

    <!-- =========================================
         STEP 3: SELFIE & PROOF OF ADDRESS
         ========================================= -->
    <div id="step3" class="kyc-step" data-aos="fade-up">
        <div class="kyc-section">
            <h3 class="section-title">
                <i class="fas fa-camera"></i> Selfie & Proof of Address
            </h3>

            <div class="info-card">
                <i class="fas fa-lightbulb"></i>
                <div class="info-card-content">
                    <div class="info-card-title">Selfie Tips</div>
                    <div class="info-card-text">
                        • Hold your ID next to your face (both visible)<br>
                        • Ensure good lighting, no glare<br>
                        • Face the camera directly, no hats/sunglasses<br>
                        • Proof of address: utility bill, bank statement (last 3 months)
                    </div>
                </div>
            </div>

            <div class="form-row">
                <div>
                    <label class="form-group" style="display:block; margin-bottom: 12px;">
                        Selfie with ID <span class="required">*</span>
                    </label>
                    <div class="upload-area" id="selfieUploadArea">
                        <i class="fas fa-user-circle upload-icon"></i>
                        <div class="upload-text">Upload selfie holding your ID</div>
                        <div class="upload-hint">Both face and ID must be clearly visible</div>
                        <img id="selfiePreview" class="upload-preview" style="display:none;" />
                        <asp:FileUpload ID="fuSelfie" runat="server" CssClass="upload-input" accept="image/*" onchange="previewImage(this, 'selfiePreview', 'selfieUploadArea')" />
                    </div>
                </div>
                <div>
                    <label class="form-group" style="display:block; margin-bottom: 12px;">
                        Proof of Address
                    </label>
                    <div class="upload-area" id="addressUploadArea">
                        <i class="fas fa-file-invoice upload-icon"></i>
                        <div class="upload-text">Upload proof of address</div>
                        <div class="upload-hint">Utility bill, bank statement (last 3 months)</div>
                        <img id="addressPreview" class="upload-preview" style="display:none;" />
                        <asp:FileUpload ID="fuProofOfAddress" runat="server" CssClass="upload-input" accept="image/*,application/pdf" onchange="previewImage(this, 'addressPreview', 'addressUploadArea')" />
                    </div>
                </div>
            </div>

            <div class="kyc-actions">
                <button type="button" class="btn-kyc secondary" onclick="goToStep(2)">
                    <i class="fas fa-arrow-left"></i> Back
                </button>
                <button type="button" class="btn-kyc primary" onclick="goToStep(4)">
                    Continue <i class="fas fa-arrow-right"></i>
                </button>
            </div>
        </div>
    </div>

    <!-- =========================================
         STEP 4: REVIEW & SUBMIT
         ========================================= -->
    <div id="step4" class="kyc-step" data-aos="fade-up">
        <div class="kyc-section">
            <h3 class="section-title">
                <i class="fas fa-clipboard-check"></i> Review & Submit
            </h3>

            <div class="info-card">
                <i class="fas fa-clock"></i>
                <div class="info-card-content">
                    <div class="info-card-title">Verification Timeline</div>
                    <div class="info-card-text">Your documents will be reviewed within <strong class="text-white">24-48 hours</strong>. You'll receive an email notification once the review is complete.</div>
                </div>
            </div>

            <div style="background: rgba(255,255,255,0.02); border: 1px solid var(--glass-border); border-radius: var(--radius-md); padding: 20px; margin-bottom: 20px;">
                <h5 class="text-white mb-3">Summary</h5>
                <div class="row g-3">
                    <div class="col-md-6">
                        <small class="text-muted">Full Name</small>
                        <div class="text-white" id="reviewName">—</div>
                    </div>
                    <div class="col-md-6">
                        <small class="text-muted">Date of Birth</small>
                        <div class="text-white" id="reviewDOB">—</div>
                    </div>
                    <div class="col-md-6">
                        <small class="text-muted">Nationality</small>
                        <div class="text-white" id="reviewNationality">—</div>
                    </div>
                    <div class="col-md-6">
                        <small class="text-muted">Document Type</small>
                        <div class="text-white" id="reviewDocType">—</div>
                    </div>
                    <div class="col-12">
                        <small class="text-muted">Address</small>
                        <div class="text-white" id="reviewAddress">—</div>
                    </div>
                </div>
            </div>

            <div style="background: rgba(255, 215, 0, 0.05); border: 1px solid rgba(255, 215, 0, 0.2); border-radius: var(--radius-md); padding: 16px; margin-bottom: 20px;">
                <label style="display: flex; align-items: flex-start; gap: 10px; cursor: pointer; color: var(--text-gray); font-size: 0.9rem;">
                    <asp:CheckBox ID="chkAgree" runat="server" style="margin-top: 3px;" />
                    <span>I confirm that all information provided is accurate and complete. I understand that providing false information may result in account suspension. I agree to the <a href="#" class="text-accent">Terms of Service</a> and <a href="#" class="text-accent">Privacy Policy</a>.</span>
                </label>
            </div>

            <div class="kyc-actions">
                <button type="button" class="btn-kyc secondary" onclick="goToStep(3)">
                    <i class="fas fa-arrow-left"></i> Back
                </button>
                <asp:Button ID="btnSubmit" runat="server" Text="Submit for Verification" CssClass="btn-kyc primary" OnClick="btnSubmit_Click" OnClientClick="return validateSubmission();" />
            </div>
        </div>
    </div>

    <!-- Hidden Fields -->
    <asp:HiddenField ID="hfCurrentStep" runat="server" Value="1" />
    <asp:HiddenField ID="hfKYCId" runat="server" />

</asp:Content>

<asp:Content ID="ScriptsContent1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        let currentStep = 1;

        function goToStep(step) {
            // Validate current step before moving forward
            if (step > currentStep) {
                if (!validateStep(currentStep)) return;
            }

            // Hide all steps
            document.querySelectorAll('.kyc-step').forEach(s => s.classList.remove('active'));
            
            // Show target step
            document.getElementById('step' + step).classList.add('active');

            // Update progress indicators
            for (let i = 1; i <= 4; i++) {
                const circle = document.getElementById('stepCircle' + i);
                const label = document.getElementById('stepLabel' + i);
                circle.classList.remove('active', 'completed');
                label.classList.remove('active', 'completed');
                
                if (i < step) {
                    circle.classList.add('completed');
                    circle.innerHTML = '<i class="fas fa-check"></i>';
                    label.classList.add('completed');
                } else if (i === step) {
                    circle.classList.add('active');
                    circle.innerHTML = i;
                    label.classList.add('active');
                } else {
                    circle.innerHTML = i;
                }
            }

            currentStep = step;
            document.getElementById('<%= hfCurrentStep.ClientID %>').value = step;

            // Update review step if going to step 4
            if (step === 4) updateReview();

            // Scroll to top
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        function validateStep(step) {
            if (step === 1) {
                const firstName = document.getElementById('<%= txtFirstName.ClientID %>').value.trim();
                const lastName = document.getElementById('<%= txtLastName.ClientID %>').value.trim();
                const dob = document.getElementById('<%= txtDOB.ClientID %>').value;
                const nationality = document.getElementById('<%= ddlNationality.ClientID %>').value;
                const address = document.getElementById('<%= txtAddress.ClientID %>').value.trim();
                const city = document.getElementById('<%= txtCity.ClientID %>').value.trim();
                const postal = document.getElementById('<%= txtPostalCode.ClientID %>').value.trim();
                const phone = document.getElementById('<%= txtPhone.ClientID %>').value.trim();

                if (!firstName || !lastName || !dob || !nationality || !address || !city || !postal || !phone) {
                    alert('Please fill in all required fields.');
                    return false;
                }
            } else if (step === 2) {
                const front = document.getElementById('<%= fuIdFront.ClientID %>').files.length;
                const back = document.getElementById('<%= fuIdBack.ClientID %>').files.length;
                if (!front || !back) {
                    alert('Please upload both front and back of your ID document.');
                    return false;
                }
            } else if (step === 3) {
                const selfie = document.getElementById('<%= fuSelfie.ClientID %>').files.length;
                if (!selfie) {
                    alert('Please upload a selfie with your ID.');
                    return false;
                }
            }
            return true;
        }

        function selectDocType(el) {
            document.querySelectorAll('.doc-type-option').forEach(opt => opt.classList.remove('selected'));
            el.classList.add('selected');
            document.getElementById('<%= hfDocType.ClientID %>').value = el.dataset.type;
        }

        function previewImage(input, previewId, areaId) {
            const preview = document.getElementById(previewId);
            const area = document.getElementById(areaId);
            if (input.files && input.files[0]) {
                if (input.files[0].size > 5 * 1024 * 1024) {
                    alert('File size must be less than 5MB');
                    input.value = '';
                    return;
                }
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                    area.classList.add('has-file');
                };
                reader.readAsDataURL(input.files[0]);
            }
        }

        function updateReview() {
            const firstName = document.getElementById('<%= txtFirstName.ClientID %>').value;
            const lastName = document.getElementById('<%= txtLastName.ClientID %>').value;
            document.getElementById('reviewName').textContent = firstName + ' ' + lastName;
            
            document.getElementById('reviewDOB').textContent = document.getElementById('<%= txtDOB.ClientID %>').value;
            
            const natSelect = document.getElementById('<%= ddlNationality.ClientID %>');
            document.getElementById('reviewNationality').textContent = natSelect.options[natSelect.selectedIndex].text;
            
            const docType = document.getElementById('<%= hfDocType.ClientID %>').value;
            const docTypeMap = {
                'passport': 'Passport',
                'national-id': 'National ID',
                'drivers-license': "Driver's License"
            };
            document.getElementById('reviewDocType').textContent = docTypeMap[docType] || docType;
            
            const address = document.getElementById('<%= txtAddress.ClientID %>').value;
            const city = document.getElementById('<%= txtCity.ClientID %>').value;
            const state = document.getElementById('<%= txtState.ClientID %>').value;
            const postal = document.getElementById('<%= txtPostalCode.ClientID %>').value;
            document.getElementById('reviewAddress').textContent = `${address}, ${city}, ${state} ${postal}`;
        }

        function validateSubmission() {
            const agreed = document.getElementById('<%= chkAgree.ClientID %>').checked;
            if (!agreed) {
                alert('Please agree to the terms and conditions before submitting.');
                return false;
            }
            if (!validateStep(1) || !validateStep(2) || !validateStep(3)) {
                alert('Please complete all required fields in previous steps.');
                return false;
            }
            return confirm('Are you sure you want to submit your KYC application?');
        }
    </script>
</asp:Content>