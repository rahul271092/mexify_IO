<script src="https://cdn.ethers.io/lib/ethers-5.7.umd.min.js"></script>
<script src="/Scripts/web3-deposit.js"></script>
<script>
    let web3Balance = 0;
let currentNetwork = 'ethereum';
let currentToken = 'ETH';

// Connect Web3 Wallet
async function connectWeb3Wallet() {
    try {
        const result = await window.web3Deposit.connectWallet();
            
        document.getElementById('web3ConnectSection').style.display = 'none';
        document.getElementById('web3ConnectedSection').style.display = 'block';
        document.getElementById('web3DepositForm').style.display = 'block';
            
        const shortAddress = result.account.substring(0, 6) + '...' + result.account.substring(38);
        document.getElementById('connectedWalletAddress').textContent = shortAddress;
            
        await updateWeb3DepositAddress();
        await loadWeb3Balance();
            
        showSuccess('Wallet connected successfully!');
    } catch (error) {
        showError('Failed to connect wallet: ' + error.message);
    }
}

// Update deposit address based on network and token
async function updateWeb3DepositAddress() {
    const network = document.getElementById('ddlWeb3Network').value;
    const token = document.getElementById('ddlWeb3Token').value;
        
    currentNetwork = network;
    currentToken = token;
        
    // Switch to selected network
    try {
        await window.web3Deposit.switchNetwork(network);
    } catch (error) {
        console.error('Failed to switch network:', error);
    }
        
    // Get platform deposit address from server
    try {
        const response = await fetch('/api/Web3/GetDepositAddress?currency=' + token + '&network=' + network);
        const data = await response.json();
            
        if (data.success) {
            document.getElementById('web3DepositAddress').textContent = data.depositAddress;
            document.getElementById('web3MinDeposit').textContent = data.minDeposit;
            document.getElementById('web3TokenName').textContent = token;
            document.getElementById('web3TokenSymbol').textContent = token;
        } else {
            showError('Failed to get deposit address');
        }
    } catch (error) {
        console.error('Failed to get deposit address:', error);
        showError('Failed to get deposit address');
    }
        
    await loadWeb3Balance();
}

// Load token balance
async function loadWeb3Balance() {
    try {
        const balance = await window.web3Deposit.getTokenBalance(currentToken, currentNetwork);
        web3Balance = parseFloat(balance);
        document.getElementById('web3TokenBalance').textContent = web3Balance.toFixed(8);
    } catch (error) {
        console.error('Failed to load balance:', error);
        document.getElementById('web3TokenBalance').textContent = '0.00';
    }
}

// Set deposit amount percentage
function setWeb3Amount(percent) {
    const amount = (web3Balance * percent / 100).toFixed(8);
    document.getElementById('txtWeb3Amount').value = amount;
}

// Execute Web3 deposit
async function executeWeb3Deposit() {
    const amount = parseFloat(document.getElementById('txtWeb3Amount').value);
    const depositAddress = document.getElementById('web3DepositAddress').textContent;
        
    if (!amount || amount <= 0) {
        showError('Please enter a valid amount');
        return;
    }
        
    if (amount > web3Balance) {
        showError('Insufficient balance');
        return;
    }
        
    const minDeposit = parseFloat(document.getElementById('web3MinDeposit').textContent);
    if (amount < minDeposit) {
        showError('Minimum deposit is ' + minDeposit + ' ' + currentToken);
        return;
    }
        
    if (!confirm('Are you sure you want to deposit ' + amount + ' ' + currentToken + '?\n\nThis will send tokens from your MetaMask wallet to the platform deposit address.')) {
        return;
    }
        
    try {
        document.getElementById('btnWeb3Deposit').disabled = true;
        document.getElementById('btnWeb3Deposit').innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i> Processing...';
            
        // Execute deposit
        const result = await window.web3Deposit.depositTokens(currentToken, amount, depositAddress, currentNetwork);
            
        // Record deposit on server
        const response = await fetch('/api/Web3/RecordDeposit', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                walletAddress: window.web3Deposit.account,
                currencyCode: currentToken,
                amount: amount,
                network: currentNetwork,
                txHash: result.txHash,
                fromAddress: window.web3Deposit.account,
                toAddress: depositAddress
            })
        });
            
        const data = await response.json();
            
        if (data.success) {
            showTransactionStatus(result.txHash, 'pending');
            showSuccess('Deposit initiated! Waiting for confirmations...');
                
            // Start monitoring confirmations
            monitorTransaction(result.txHash);
        } else {
            showError('Failed to record deposit: ' + data.message);
        }
    } catch (error) {
        console.error('Deposit failed:', error);
        showError('Deposit failed: ' + error.message);
    } finally {
        document.getElementById('btnWeb3Deposit').disabled = false;
        document.getElementById('btnWeb3Deposit').innerHTML = '<i class="fas fa-paper-plane me-2"></i> Deposit via MetaMask';
    }
}

// Monitor transaction confirmations
async function monitorTransaction(txHash) {
    const interval = setInterval(async () => {
        try {
            const details = await window.web3Deposit.getTransactionDetails(txHash);
                
            showTransactionStatus(txHash, details.status === 1 ? 'confirmed' : 'pending', details.confirmations);
                
            if (details.confirmations >= 12) {
                clearInterval(interval);
                    
                // Update server with confirmation
                await fetch('/api/Web3/ConfirmDeposit', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        txHash: txHash,
                        blockNumber: details.blockNumber,
                        gasUsed: details.gasUsed,
                        gasPrice: details.gasPrice,
                        confirmations: details.confirmations
                    })
                });
                    
                showSuccess('Deposit confirmed! Funds credited to your wallet.');
                    
                // Reload page after 3 seconds
                setTimeout(() => location.reload(), 3000);
            }
        } catch (error) {
            console.error('Failed to monitor transaction:', error);
        }
    }, 15000); // Check every 15 seconds
}

// Show transaction status
function showTransactionStatus(txHash, status, confirmations = 0) {
    document.getElementById('web3TransactionStatus').style.display = 'block';
        
    const statusHtml = `
            <div class="mb-3">
                <strong class="text-white">Transaction Hash:</strong><br>
                <a href="${window.web3Deposit.getBlockExplorerUrl(currentNetwork)}/tx/${txHash}" target="_blank" class="text-accent" style="font-family: monospace; word-break: break-all;">
                    ${txHash}
                </a>
            </div>
            <div class="mb-3">
                <strong class="text-white">Status:</strong>
                <span class="status-badge ${status === 'confirmed' ? 'status-completed' : 'status-pending'}">
                    ${status === 'confirmed' ? '✓ Confirmed' : '⏳ Pending (' + confirmations + '/12)'}
                </span>
            </div>
            ${status === 'pending' ? `
                <div class="progress-bar-stake">
                    <div class="progress-fill-stake" style="width: ${(confirmations / 12) * 100}%;"></div>
                </div>
                <small class="text-muted mt-2 d-block">${confirmations} of 12 confirmations</small>
            ` : ''}
        `;
        
    document.getElementById('transactionStatusContent').innerHTML = statusHtml;
}

    // Copy Web3 deposit address
    function copyWeb3DepositAddress() {
        const address = document.getElementById('web3DepositAddress').textContent;
        navigator.clipboard.writeText(address).then(() => {
            showSuccess('Address copied to clipboard!');
        });
    }

    // Helper functions
    function showSuccess(message) {
        alert('✓ ' + message);
    }

    function showError(message) {
        alert('✗ ' + message);
    }
    </script>