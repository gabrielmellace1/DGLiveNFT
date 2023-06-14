const hre = require("hardhat");
const ethers = hre.ethers;

async function main() {
    // Define the signer (e.g. default Hardhat Network account)
    const signer = (await ethers.getSigners())[0];

    // Define the address of the deployed NFT Contract (collection)
    const nftContractAddress = '0x7d50311c1b9818F93a6A766d42FF2629198580E5';

    // Define the ABI of the NFT Contract to interact with the owner() function
    const nftContractAbi = [
        // ERC721 OwnableUpgradeable contract's owner function
        'function owner() external view returns (address)'
    ];

    // Create a contract instance
    const nftContract = new ethers.Contract(nftContractAddress, nftContractAbi, signer);

    // Call the owner function to get the owner's address
    const ownerAddress = await nftContract.owner();
    console.log('Owner of the NFT Contract is:', ownerAddress);
}

// Execute the script using Hardhat
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
