const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("FairFabProject Smart Contract", function () {
  let FairFabProject;
  let fairFab;
  let owner, productOwner, recipient, otherAccount;
  let mintCostMATIC = ethers.utils.parseEther("1");  // 1 MATIC for minting cost
  let commissionRate = 10; // 10% commission
  let royaltyReceiver;
  let royaltyFeeBips = 500; // 5% royalty (500 basis points)

  beforeEach(async function () {
    // Get signers
    [owner, productOwner, recipient, royaltyReceiver, otherAccount] = await ethers.getSigners();

    // Deploy the FairFabProject contract
    const FairFabProject = await ethers.getContractFactory("FairFabProject");
    fairFab = await FairFabProject.deploy();

    // Initialize the contract
    await fairFab.initialize(
      "projectInfoHashIPFS", // projectInfoIPFSHash
      "schemaHashIPFS", // schemaIPFSHash
      "https://example.com/whitepaper", // whitepaper URL
      owner.address, // owner
      productOwner.address, // product owner
      commissionRate, // commission rate
      mintCostMATIC, // mint cost
      royaltyReceiver.address, // royalty receiver
      royaltyFeeBips // royalty fee in basis points
    );
  });

  it("should initialize the contract with correct values", async function () {
    expect(await fairFab.productOwner()).to.equal(productOwner.address);
    expect(await fairFab.mintCostMATIC()).to.equal(mintCostMATIC);
    expect(await fairFab.commissionRate()).to.equal(commissionRate);
  });

  it("should mint a new NFT and transfer commission to the product owner", async function () {
    // Product owner mints an NFT and pays mintCost
    await expect(() =>
      fairFab.connect(productOwner).mintNFT(recipient.address, 1, { value: mintCostMATIC })
    ).to.changeEtherBalance(owner, mintCostMATIC.mul(commissionRate).div(100));

    expect(await fairFab.ownerOf(1)).to.equal(recipient.address);
  });

  it("should not allow non-product owner to mint an NFT", async function () {
    await expect(
      fairFab.connect(otherAccount).mintNFT(recipient.address, 1, { value: mintCostMATIC })
    ).to.be.revertedWith("Caller is not the product owner");
  });

  it("should allow NFT transfers with a commission fee", async function () {
    // Mint an NFT
    await fairFab.connect(productOwner).mintNFT(recipient.address, 1, { value: mintCostMATIC });

    // Transfer NFT from recipient to another account with transfer fee
    const transferFee = ethers.utils.parseEther("0.1"); // Fee paid during transfer
    await expect(() =>
      fairFab.connect(recipient).transferFrom(recipient.address, otherAccount.address, 1, { value: transferFee })
    ).to.changeEtherBalance(owner, transferFee.mul(commissionRate).div(100));

    expect(await fairFab.ownerOf(1)).to.equal(otherAccount.address);
  });

  it("should update project details by product owner", async function () {
    await fairFab.connect(productOwner).updateProjectDetails("newProjectInfoHashIPFS", "newSchemaHashIPFS");

    expect(await fairFab.projectInfoIPFSHash()).to.equal("newProjectInfoHashIPFS");
    expect(await fairFab.schemaIPFSHash()).to.equal("newSchemaHashIPFS");
  });

  it("should not allow non-product owner to update project details", async function () {
    await expect(
      fairFab.connect(otherAccount).updateProjectDetails("newProjectInfoHashIPFS", "newSchemaHashIPFS")
    ).to.be.revertedWith("Caller is not the product owner");
  });

  it("should correctly configure royalties using ERC2981", async function () {
    const royaltyInfo = await fairFab.royaltyInfo(1, ethers.utils.parseEther("10")); // Test with a sale price of 10 MATIC
    const expectedRoyalty = ethers.utils.parseEther("0.5"); // 5% of 10 MATIC is 0.5 MATIC
    expect(royaltyInfo[1]).to.equal(expectedRoyalty);
    expect(royaltyInfo[0]).to.equal(royaltyReceiver.address);
  });

  it("should update product owner by contract owner", async function () {
    await fairFab.connect(owner).updateProductOwner(otherAccount.address);
    expect(await fairFab.productOwner()).to.equal(otherAccount.address);
  });

  it("should not allow non-contract owner to update product owner", async function () {
    await expect(fairFab.connect(otherAccount).updateProductOwner(otherAccount.address)).to.be.revertedWith(
      "Ownable: caller is not the owner"
    );
  });
});
