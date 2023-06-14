const hre = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Using the account:", deployer.address);

    // Set the address of the ERC721 contract you want to interact with
    const erc721Address = "0x59a7aEd81C30c3591fB3118e0134Ce43c7623119";

    // Interact with the existing ERC721 token contract
    const DGLiveNFT = await hre.ethers.getContractFactory("DGLiveNFT");
    const erc721Contract = await DGLiveNFT.attach(erc721Address);

    // Mint tokens for the existing NFT collection
    // (Assuming the function parameters are: to, uri, royaltyFee, amount)
    await erc721Contract.safeMint(deployer.address, "https://example.com/tokenURI", 500, 3);
    console.log("Tokens minted for the existing NFT collection");

    const name = await erc721Contract.name();
    const symbol = await erc721Contract.symbol();
    console.log("Token Name:", name);
    console.log("Token Symbol:", symbol);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
