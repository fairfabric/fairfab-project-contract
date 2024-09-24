# 🏭 FairFabProject Smart Contract

FairFabProject Token (FAIRFAB-P) is an ERC-721 NFT representing ownership of a project within the FairFabric ecosystem. This contract emphasizes **decentralization**, **on-chain governance**, **solidarity economy**, and the **freedom of exchange** within the FairFabric ecosystem, ensuring flexibility and growth potential.

The FairFabProject smart contract is deployed on the **Polygon blockchain**, offering low transaction costs, scalability, and full compatibility with Ethereum.

## Table of Contents

- [Synopsis](#synopsis)
- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Compiling the Contract](#compiling-the-contract)
  - [Running Tests](#running-tests)
  - [Deploying the Contract](#deploying-the-contract)
- [Smart Contract Structure](#smart-contract-structure)
- [Testing](#testing)
- [Version](#version)
- [License](#license)

## Synopsis

FairFabProject is an ERC721 NFT-based project with support for royalties via the ERC2981 standard. This smart contract enables the minting, transferring, and management of NFTs while enforcing commission payments and royalties for creators. It is designed to be **upgradeable** and adheres to common standards to facilitate interoperability with marketplaces and wallets.

As part of the **FairFabric ecosystem**, the project aligns with values of **economic solidarity** and **on-chain decentralized operations**, giving users the freedom to exchange and manage their digital assets securely and transparently.

More details about the project can be found in the [Whitepaper](https://fairfabric.github.io/fairfab-project-contract/WHITEPAPER).

### Legal Disclaimer

The NFTs issued by this smart contract are **utility tokens** and are **not intended** to be speculative investment assets. However, they remain **exchangeable** in accordance with the applicable rules governing the exchange of digital assets. Holders of these tokens must comply with all relevant national and international cryptocurrency regulations, including but not limited to anti-money laundering (AML) and know-your-customer (KYC) requirements.

## Features

- **ERC721 NFT**: Supports minting and transferring non-fungible tokens.
- **Upgradeable Contract**: Built using OpenZeppelin's upgradeable contracts for future flexibility.
- **Royalties (ERC2981)**: Supports automatic royalty payments on secondary sales.
- **Commission Payments**: Ensures commission is paid to the product owner during minting and transfers.
- **IPFS Support**: Stores project metadata and schemas on IPFS.
- **Event Logging**: Tracks significant events such as NFT minting, transferring, and project updates.
- **Access Control**: Product owner and contract owner can update specific aspects of the contract.

As part of the **FairFabric ecosystem**, the project aligns with values of **economic solidarity** and **on-chain decentralized operations**, giving users the freedom to exchange and manage their digital assets securely and transparently.

## Getting Started

### Prerequisites

Ensure you have the following installed:

- Node.js (>=16.x.x)
- npm (>=7.x.x)
- Hardhat

### Installation

Clone the repository:

```bash
git clone https://github.com/fairfabric/fairfab-project.git
cd fairfab-project
```

Install dependencies:

```bash
npm install
```

### Compiling the Contract

To compile the smart contract, run:

```bash
npx hardhat compile
```

### Running Tests

To run the unit tests:

```bash
npx hardhat test
```

### Deploying the Contract

Configure your environment settings in `.env`:

```bash
INFURA_API_KEY=<Your Infura API Key>
PRIVATE_KEY=<Your Wallet Private Key>
```

Deploy the contract to a network (e.g., Polygon):

```bash
npx hardhat run scripts/deploy.js --network polygon
```

## Smart Contract Structure

- **FairFabProject.sol**: Main contract for minting, transferring, and managing NFTs with commission and royalty logic.
- **Events**: Important actions such as `NFTMinted`, `NFTTransferred`, `ProjectUpdated` are logged for tracking.
- **Functions**:
  - `initialize`: Initializes the contract with essential parameters.
  - `mintNFT`: Allows the product owner to mint NFTs with a commission.
  - `transferFrom`: Overrides ERC721's transfer function to include a commission payment.
  - `updateProjectDetails`: Allows the product owner to update the IPFS hash for project metadata.
  - `updateProductOwner`: Allows the contract owner to change the product owner.
  - `supportsInterface`: Supports ERC2981 for royalties and ERC721 for NFTs.

## Testing

Tests are written using the Hardhat framework and Chai for assertions. The tests include:

- Initialization and correct parameter settings.
- Minting NFTs and ensuring proper commission handling.
- Transfers that ensure fees are paid.
- Access control tests for functions restricted to the product owner and contract owner.
- Royalties testing in compliance with ERC2981.

## Version

We are currently in **version 1** of the FairFabProject smart contract. Future updates will include additional features that further align with the **decentralized and evolutionary** nature of the FairFabric ecosystem.

## License

> 
> Copyright 2024 Tamia SAS, France
> 
> Licensed under the Apache License, Version 2.0 (the "License");
> you may not use this file except in compliance with the License.
> You may obtain a copy of the License at
> 
>     http://www.apache.org/licenses/LICENSE-2.0
> 
> Unless required by applicable law or agreed to in writing, software
> distributed under the License is distributed on an "AS IS" BASIS,
> WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
> See the License for the specific language governing permissions and
> limitations under the License.
> 
