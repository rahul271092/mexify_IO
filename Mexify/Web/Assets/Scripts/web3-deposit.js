// Web3 Deposit Integration using ethers.js
class Web3DepositManager {
    constructor() {
        this.provider = null;
        this.signer = null;
        this.account = null;
        this.chainId = null;
        this.networks = {
            ethereum: { chainId: 1, name: 'Ethereum Mainnet', rpcUrl: 'https://mainnet.infura.io/v3/YOUR_INFURA_KEY' },
            bsc: { chainId: 56, name: 'BNB Smart Chain', rpcUrl: 'https://bsc-dataseed.binance.org/' },
            polygon: { chainId: 137, name: 'Polygon', rpcUrl: 'https://polygon-rpc.com/' }
        };
        
        // Token contract addresses (replace with actual addresses)
        this.tokenContracts = {
            ethereum: {
                USDT: '0xdAC17F958D2ee523a2206206994597C13D831ec7',
                USDC: '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48'
            },
            bsc: {
                USDT: '0x55d398326f99059fF775485246999027B3197955',
                BUSD: '0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56',
                PNC: '0xYOUR_PNC_TOKEN_ADDRESS_ON_BSC'
            },
            polygon: {
                USDT: '0xc2132D05D31c914a87C6611C10748AEb04B58e8F',
                USDC: '0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174'
            }
        };
    }

    // Check if MetaMask is installed
    isMetaMaskInstalled() {
        return typeof window.ethereum !== 'undefined' && window.ethereum.isMetaMask;
    }

    // Connect to MetaMask
    async connectWallet() {
        if (!this.isMetaMaskInstalled()) {
            throw new Error('MetaMask is not installed. Please install MetaMask extension.');
        }

        try {
            // Request account access
            const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
            
            if (accounts.length === 0) {
                throw new Error('No accounts found. Please unlock MetaMask.');
            }

            this.account = accounts[0];
            
            // Initialize ethers provider
            this.provider = new ethers.providers.Web3Provider(window.ethereum);
            this.signer = this.provider.getSigner();
            
            // Get chain ID
            const network = await this.provider.getNetwork();
            this.chainId = network.chainId;

            console.log('Wallet connected:', this.account);
            console.log('Chain ID:', this.chainId);

            return {
                account: this.account,
                chainId: this.chainId,
                provider: this.provider
            };
        } catch (error) {
            console.error('Failed to connect wallet:', error);
            throw error;
        }
    }

    // Switch to required network
    async switchNetwork(networkName) {
        const network = this.networks[networkName.toLowerCase()];
        if (!network) {
            throw new Error(`Network ${networkName} not supported`);
        }

        const targetChainId = '0x' + network.chainId.toString(16);

        try {
            await window.ethereum.request({
                method: 'wallet_switchEthereumChain',
                params: [{ chainId: targetChainId }],
            });
        } catch (switchError) {
            // Network not added, add it
            if (switchError.code === 4902) {
                try {
                    await window.ethereum.request({
                        method: 'wallet_addEthereumChain',
                        params: [{
                            chainId: targetChainId,
                            chainName: network.name,
                            rpcUrls: [network.rpcUrl],
                            nativeCurrency: {
                                name: networkName === 'bsc' ? 'BNB' : 'ETH',
                                symbol: networkName === 'bsc' ? 'BNB' : 'ETH',
                                decimals: 18
                            },
                            blockExplorerUrls: [this.getBlockExplorerUrl(networkName)]
                        }],
                    });
                } catch (addError) {
                    throw new Error('Failed to add network to MetaMask');
                }
            } else {
                throw switchError;
            }
        }

        // Reconnect after network switch
        await this.connectWallet();
    }

    // Get block explorer URL
    getBlockExplorerUrl(networkName) {
        switch (networkName.toLowerCase()) {
            case 'ethereum': return 'https://etherscan.io';
            case 'bsc': return 'https://bscscan.com';
            case 'polygon': return 'https://polygonscan.com';
            default: return 'https://etherscan.io';
        }
    }

    // Get token balance
    async getTokenBalance(tokenSymbol, network) {
        if (!this.provider || !this.account) {
            throw new Error('Wallet not connected');
        }

        try {
            // Native token (ETH, BNB, MATIC)
            if (['ETH', 'BNB', 'MATIC'].includes(tokenSymbol.toUpperCase())) {
                const balance = await this.provider.getBalance(this.account);
                return ethers.utils.formatEther(balance);
            }

            // ERC20 token
            const contractAddress = this.tokenContracts[network.toLowerCase()]?.[tokenSymbol.toUpperCase()];
            if (!contractAddress) {
                throw new Error(`Token ${tokenSymbol} not found on ${network}`);
            }

            const tokenContract = new ethers.Contract(
                contractAddress,
                ['function balanceOf(address owner) view returns (uint256)', 'function decimals() view returns (uint8)'],
                this.provider
            );

            const balance = await tokenContract.balanceOf(this.account);
            const decimals = await tokenContract.decimals();
            
            return ethers.utils.formatUnits(balance, decimals);
        } catch (error) {
            console.error('Failed to get token balance:', error);
            throw error;
        }
    }

    // Transfer tokens to platform deposit address
    async depositTokens(tokenSymbol, amount, depositAddress, network) {
        if (!this.signer || !this.account) {
            throw new Error('Wallet not connected');
        }

        try {
            let tx;

            // Native token transfer
            if (['ETH', 'BNB', 'MATIC'].includes(tokenSymbol.toUpperCase())) {
                tx = await this.signer.sendTransaction({
                    to: depositAddress,
                    value: ethers.utils.parseEther(amount.toString())
                });
            } else {
                // ERC20 token transfer
                const contractAddress = this.tokenContracts[network.toLowerCase()]?.[tokenSymbol.toUpperCase()];
                if (!contractAddress) {
                    throw new Error(`Token ${tokenSymbol} not found on ${network}`);
                }

                const tokenContract = new ethers.Contract(
                    contractAddress,
                    ['function transfer(address to, uint256 amount) returns (bool)', 'function decimals() view returns (uint8)'],
                    this.signer
                );

                const decimals = await tokenContract.decimals();
                const amountWei = ethers.utils.parseUnits(amount.toString(), decimals);

                tx = await tokenContract.transfer(depositAddress, amountWei);
            }

            console.log('Transaction sent:', tx.hash);

            // Wait for confirmation
            const receipt = await tx.wait();

            console.log('Transaction confirmed:', receipt.transactionHash);

            return {
                txHash: receipt.transactionHash,
                blockNumber: receipt.blockNumber,
                gasUsed: receipt.gasUsed.toString(),
                gasPrice: receipt.effectiveGasPrice.toString(),
                status: receipt.status
            };
        } catch (error) {
            console.error('Failed to deposit tokens:', error);
            throw error;
        }
    }

    // Get transaction details
    async getTransactionDetails(txHash) {
        if (!this.provider) {
            throw new Error('Provider not initialized');
        }

        try {
            const tx = await this.provider.getTransaction(txHash);
            const receipt = await this.provider.getTransactionReceipt(txHash);
            const currentBlock = await this.provider.getBlockNumber();

            return {
                txHash: tx.hash,
                blockNumber: receipt.blockNumber,
                from: tx.from,
                to: tx.to,
                value: ethers.utils.formatEther(tx.value),
                gasUsed: receipt.gasUsed.toString(),
                gasPrice: tx.gasPrice.toString(),
                confirmations: currentBlock - receipt.blockNumber,
                status: receipt.status
            };
        } catch (error) {
            console.error('Failed to get transaction details:', error);
            throw error;
        }
    }
}

// Initialize global instance
window.web3Deposit = new Web3DepositManager();