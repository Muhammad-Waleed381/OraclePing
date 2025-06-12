# 🟦 OraclePing – On-Chain Crypto Price Alert DApp

![Ethereum](https://img.shields.io/badge/Ethereum-3C3C3D?style=for-the-badge&logo=ethereum&logoColor=white)
![Chainlink](https://img.shields.io/badge/Chainlink-375BD2?style=for-the-badge&logo=chainlink&logoColor=white)
![Solidity](https://img.shields.io/badge/Solidity-363636?style=for-the-badge&logo=solidity&logoColor=white)
![React](https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB)
![Ethers.js](https://img.shields.io/badge/Ethers.js-1C1C1C?style=for-the-badge&logo=ethereum&logoColor=purple)

---

## ⚡ Overview

**OraclePing** is a decentralized application that lets users set real-time crypto price alerts (like ETH, BTC) on-chain. It leverages:

- 🟦 **Chainlink Price Feeds** for live crypto prices  
- 🔁 **Chainlink Automation (Keepers)** to monitor conditions  
- 🔐 **Ethereum smart contracts** for logic and storage  
- 🌐 **React + Ethers.js** frontend for smooth UX  

> Set your price. Get pinged. Stay on chain.

---

## 🛠 Tech Stack

| Layer | Tech |
|--|--|
| **Smart Contract** | Solidity, Chainlink Price Feeds, Chainlink Automation |
| **Frontend** | React, Ethers.js, MetaMask |
| **Network** | Ethereum Testnet (e.g., Sepolia or Goerli) |

---

## 📦 Features

- ✅ Wallet connection via MetaMask  
- 🧾 Add alerts with custom price thresholds  
- 🔗 Real-time price monitoring using Chainlink  
- ⚙️ Chainlink Automation for background checks  
- 📬 On-chain alert trigger logic

---

Here's the corrected and properly formatted version of that section:

````markdown
## 🚀 Getting Started

### 🔧 Install Dependencies

```bash
npm install
````

### 🧪 Run Local Development

```bash
npm run dev
```

### 📤 Deploy Smart Contract (via Hardhat)

```bash
npx hardhat compile
npx hardhat deploy --network sepolia
```

---

### 🔗 Smart Contract Architecture

```
┌──────────────┐
│ User Wallet  │
└─────┬────────┘
      │
      ▼
┌──────────────┐
│  React UI    │
└─────┬────────┘
      ▼
┌──────────────┐
│  Ethers.js   │
└─────┬────────┘
      ▼
┌──────────────────────┐
│ Smart Contract (ETH) │
│ - Price Feed Oracle  │
│ - Alert Registry     │
│ - Trigger Logic      │
└─────┬────────────────┘
      ▼
┌────────────────────┐
│ Chainlink Keepers  │
└────────────────────┘
```

```




