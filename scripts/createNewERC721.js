const hre = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Interacting with contracts using the account:", deployer.address);

    // Replace this with the address of your already deployed ERC721Factory
    const factoryAddress = '0x0E4Eb91695eC67f827FA22f7404886CA5a1Eb97a';

    // Attach to the deployed ERC721Factory
    const ERC721Factory = await hre.ethers.getContractFactory("DGLiveNFTFactory");
    const erc721Factory = await ERC721Factory.attach(factoryAddress);

    // Create new ERC721 token and log the gas used
    const createTx = await erc721Factory.createERC721("Another Token", "ATK","art","0xEA5Fed1D0141F14DE11249577921b08783d6A360");
    const receipt = await createTx.wait();
    console.log("Gas used in createERC721:", receipt.gasUsed.toString());

    // Retrieve the address of the new token contract
    const events = receipt.events.filter(x => x.event === "NewERC721Contract");
    console.log(events);
    const newTokenAddress = events[0].args[0];
    console.log("New ERC721 Token Address:", newTokenAddress);

    // Interact with the new token
    const ISimpleNFT = await hre.ethers.getContractAt("ISimpleNFT", newTokenAddress);
    const name = await ISimpleNFT.name();
    const symbol = await ISimpleNFT.symbol();
    console.log("New Token Name:", name);
    console.log("New Token Symbol:", symbol);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
