const { ethers } = require("hardhat");

async function main() {
  const nftAddress = '0x0b05e17a21BDB36718965eE1f2A10d9BbAbfA0b6'; // The NFT contract address here
  const userWalletAddress = '0xEA5Fed1D0141F14DE11249577921b08783d6A360'; // User's wallet address here

  // The ABI of the ERC-721 contract you are interacting with
  const nftAbi = [
    // Minimum ABI required for this example
    "function balanceOf(address owner) view returns (uint256)",
    "function tokenOfOwnerByIndex(address owner, uint256 index) view returns (uint256)",
  ];

  // Use Hardhat's provider
  const [signer] = await ethers.getSigners();

  // Create contract instance
  const nftContract = new ethers.Contract(nftAddress, nftAbi, signer);

  try {
    // Get balance of tokens
    const balance = await nftContract.balanceOf(userWalletAddress);

    console.log(`User has ${balance} token(s)`);

    // Loop through tokens
    for (let i = 0; i < balance; i++) {
      const tokenId = await nftContract.tokenOfOwnerByIndex(userWalletAddress, i);
      console.log(`Token ID: ${tokenId}`);
    }
  } catch (error) {
    console.error(error);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
