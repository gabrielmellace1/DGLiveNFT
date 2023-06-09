const { ethers } = require("hardhat");
const hre = require("hardhat");

async function main() {
  // Compile the contracts
  await hre.run("compile");

  // Deploy the contract
  const DGLiveNFT = await ethers.getContractFactory("DGLiveNFT");
  const name = "DGCollections";
  const symbol = "DGNFT";
  const dglivenft = await DGLiveNFT.deploy(name, symbol);

  await dglivenft.deployed();
  console.log("DGLiveNFT deployed to:", dglivenft.address);

/*
 address to,
        string memory uri,
        uint96 royaltyFee,
        uint256 amount
*/
  
  // Interact with the contract by calling safeMint
  const to = "0xEA5Fed1D0141F14DE11249577921b08783d6A360"; // Replace with the actual recipient address
  const uri = "https://example.com/token-uri";
  const royaltyFee = 500; // 5% royalty fee in basis points
  const amount = 3; // Mint 3 NFTs

  await dglivenft.safeMint(to, uri, royaltyFee, amount);
  console.log(`Minted ${amount} NFTs with URI: ${uri} and royalty fee of ${royaltyFee / 100}%`);

  // Call royaltyInfo function for the minted token
  const tokenId = 0;
  const salePrice = ethers.utils.parseEther("0.5"); // 0.5 ETH in wei

  const [recipient, royaltyAmount] = await dglivenft.royaltyInfo(tokenId, salePrice);
  console.log(
    `Token ID: ${tokenId}, Recipient: ${recipient}, Royalty Amount: ${ethers.utils.formatEther(royaltyAmount)} ETH`
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
