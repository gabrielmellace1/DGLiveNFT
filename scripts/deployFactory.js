const hre = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    // Deploy SimpleNFT
    const SimpleNFT = await hre.ethers.getContractFactory("DGLiveNFT");
    const simpleNFT = await SimpleNFT.deploy();
    await simpleNFT.deployed();
    console.log("SimpleNFT deployed to:", simpleNFT.address);

    // Deploy ERC721Factory
    const ERC721Factory = await hre.ethers.getContractFactory("DGLiveNFTFactory");
    const erc721Factory = await ERC721Factory.deploy(simpleNFT.address);
    await erc721Factory.deployed();
    console.log("ERC721Factory deployed to:", erc721Factory.address);

    // Create new ERC721 token
    await erc721Factory.createERC721("My Token", "MTK","art", "0xEA5Fed1D0141F14DE11249577921b08783d6A360");
    const filter = erc721Factory.filters.NewERC721Contract();
    const events = await erc721Factory.queryFilter(filter, erc721Factory.address);
    const newTokenAddress = events[0].args[1];
    console.log("New ERC721 Token Address:", newTokenAddress);

    // Interact with the new token
    const DGLiveNFT = await hre.ethers.getContractFactory("DGLiveNFT");
    const newTokenContract = await DGLiveNFT.attach(newTokenAddress);
 

    // Mint tokens for the new NFT collection
    await newTokenContract.safeMint(deployer.address, "https://example.com/tokenURI", 500, 3);
    console.log("Tokens minted for the new NFT collection");

    const name = await newTokenContract.name();
    const symbol = await newTokenContract.symbol();
    console.log("New Token Name:", name);
    console.log("New Token Symbol:", symbol);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
