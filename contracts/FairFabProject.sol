// SPDX-License-Identifier: Apache-2.0
// License 2024 Tamia SAS, Saint-Etienne, France
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/common/ERC2981Upgradeable.sol";  // Import ERC2981 for NFT royalties management

contract FairFabProject is Initializable, ERC721Upgradeable, OwnableUpgradeable, ERC2981Upgradeable {
    // Project attributes stored on IPFS
    string public projectInfoIPFSHash;  // Hash pointing to the project information stored on IPFS
    string public schemaIPFSHash;       // Hash pointing to the schema file on IPFS

    // Product owner address (also the owner of the NFT)
    address public productOwner;

    // Whitepaper URLs specific to each version of the contract
    mapping(uint256 => string) public whitepaperVersions;

    // Tracking contract versions
    uint256 public currentVersion;
    mapping(uint256 => string) public versionHistory;

    // Commission rate (defined in the NFT)
    uint256 public commissionRate;

    // Mint cost in MATIC (defined in the NFT)
    uint256 public mintCostMATIC;

    // Events for tracking project updates and NFT transfers
    event ProjectUpdated(string projectInfoIPFSHash, string schemaIPFSHash);
    event ProductOwnerUpdated(address newProductOwner);
    event VersionUpdated(uint256 version, string description, string whitepaperURL);
    event NFTMinted(uint256 tokenId, address recipient);
    event NFTTransferred(uint256 tokenId, address from, address to);

    // Modifier to restrict actions to the product owner
    modifier onlyProductOwner() {
        require(msg.sender == productOwner, "Caller is not the product owner");
        _;
    }

    // Initializer function (constructor replacement for upgradeable contracts)
    function initialize(
        string memory _projectInfoIPFSHash,
        string memory _schemaIPFSHash,
        string memory _whitepaperURL,
        address _owner,
        address _productOwner,
        uint256 _commissionRate,
        uint256 _mintCostMATIC,
        address _royaltyReceiver,
        uint96 _royaltyFeesInBips  // New argument for royalty fees in basis points (bps)
    ) public initializer {
        __Ownable_init();  
        __ERC721_init("FairFabProject", "FFP");

        // Store project data and schema
        projectInfoIPFSHash = _projectInfoIPFSHash;
        schemaIPFSHash = _schemaIPFSHash;

        // Set initial product owner and contract owner
        productOwner = _productOwner;
        transferOwnership(_owner);  // Set the contract owner

        // Set commission rate and mint cost
        commissionRate = _commissionRate;
        mintCostMATIC = _mintCostMATIC;

        // Initialize the first contract version and whitepaper URL
        currentVersion = 1;
        versionHistory[currentVersion] = "Initial version";
        whitepaperVersions[currentVersion] = _whitepaperURL;

        // Set default royalties using ERC2981 standard
        _setDefaultRoyalty(_royaltyReceiver, _royaltyFeesInBips);  // Define the address and royalty percentage
    }

    // Function to mint a new NFT and pay commission to the product owner
    function mintNFT(address recipient, uint256 tokenId) public onlyProductOwner payable {
        require(msg.value == mintCostMATIC, "Minting requires the exact mint cost");

        // Calculate commission for the product owner
        uint256 commission = (msg.value * commissionRate) / 100;
        payable(owner()).transfer(commission);  // Transfer commission to the product owner

        // Mint the NFT for the recipient
        _mint(recipient, tokenId);
        emit NFTMinted(tokenId, recipient);
    }

    // Override the transferFrom function to include commission payment during transfer
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override payable {
        require(msg.value > 0, "Transfer requires a fee");

        // Calculate the commission for the product owner
        uint256 commission = (msg.value * commissionRate) / 100;
        payable(owner()).transfer(commission);  // Transfer commission to the product owner

        // Perform the NFT transfer
        super.transferFrom(from, to, tokenId);
        emit NFTTransferred(tokenId, from, to);
    }

    // Function to update project details (only the product owner can perform this action)
    function updateProjectDetails(
        string memory _projectInfoIPFSHash,
        string memory _schemaIPFSHash
    ) public onlyProductOwner {
        projectInfoIPFSHash = _projectInfoIPFSHash;
        schemaIPFSHash = _schemaIPFSHash;

        emit ProjectUpdated(projectInfoIPFSHash, schemaIPFSHash);
    }

    // Function to update the product owner (only the current contract owner can perform this action)
    function updateProductOwner(address newProductOwner) public onlyOwner {
        productOwner = newProductOwner;
        emit ProductOwnerUpdated(newProductOwner);
    }

    // Override supportsInterface to include ERC2981 for royalties
    function supportsInterface(bytes4 interfaceId) public view override(ERC721Upgradeable, ERC2981Upgradeable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}

   
