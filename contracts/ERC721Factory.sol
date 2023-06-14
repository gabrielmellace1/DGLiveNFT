// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "./DGLiveNFT.sol";
import "./EIP712MetaTransaction.sol";

contract DGLiveNFTFactory is EIP712MetaTransaction {
    address private tokenImplementation;

    event NewERC721Contract(
        address owner,
        address contractAddress,
        string name,
        string symbol,
        string category
    );

    constructor(
        address _tokenImplementation
    ) EIP712Base("DGLiveNFTFactory", "v1.0") {
        tokenImplementation = _tokenImplementation;
    }

    function createERC721(
        string memory name,
        string memory symbol,
        string memory category,
        address newOwner
    ) external {
        address clone = Clones.clone(tokenImplementation);

        // Initializing the cloned contract
        DGLiveNFT(clone).initialize(name, symbol, newOwner);

        // Transfer ownership of the newly created contract to the newOwner
        //DGLiveNFT(clone).transferOwnership(newOwner);

        // Emit event
        emit NewERC721Contract(newOwner, clone, name, symbol, category);
    }
}
