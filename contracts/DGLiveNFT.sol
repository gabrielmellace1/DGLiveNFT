// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./EIP712MetaTransaction.sol";

import "@openzeppelin/contracts/token/common/ERC2981.sol";

/// @title EIP-721 Metadata Update Extension
interface IERC4906 is IERC165, IERC721 {
    /// @dev This event emits when the metadata of a token is changed.
    /// So that the third-party platforms such as NFT market could
    /// timely update the images and related attributes of the NFT.
    event MetadataUpdate(uint256 _tokenId);

    /// @dev This event emits when the metadata of a range of tokens is changed.
    /// So that the third-party platforms such as NFT market could
    /// timely update the images and related attributes of the NFTs.
    event BatchMetadataUpdate(uint256 _fromTokenId, uint256 _toTokenId);
}

contract DGLiveNFT is
    ERC721,
    ERC721URIStorage,
    ERC721Burnable,
    ERC2981,
    Ownable,
    EIP712MetaTransaction,
    IERC4906
{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    event PermanentURI(string _value, uint256 indexed _id);
    address public immutable APPROVED_ADDRESS =
        0x2D6d77D4D7CBF9be50244B52f9bdF87FaD1B3Ad0;

    constructor(
        string memory name,
        string memory symbol
    ) ERC721(name, symbol) EIP712Base("DGLiveCollections", "v1.0") {
        _setApprovalForAll(msgSender(), APPROVED_ADDRESS, true);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721, ERC2981, IERC165) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function safeMint(
        address to,
        string memory uri,
        uint96 royaltyFee,
        uint256 amount
    ) external onlyOwner {
        require(amount <= 50, "Max:50 items");
        require(royaltyFee <= 10000, "Royalty overflow");

        uint256 tokenId;

        for (uint8 i = 0; i < amount; i++) {
            tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            _safeMint(to, tokenId);
            _setTokenURI(tokenId, uri);
            _setTokenRoyalty(tokenId, owner(), royaltyFee);
        }
    }

    function _burn(
        uint256 tokenId
    ) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
        _resetTokenRoyalty(tokenId);
    }

    function burnNFT(uint256 tokenId) external onlyOwner {
        address owner = ownerOf(tokenId);
        require(
            owner == msgSender(),
            "Only the owner of NFT can transfer or burn it"
        );

        _burn(tokenId);
    }

    function updateMetadata(uint256 _tokenId) external {
        emit MetadataUpdate(_tokenId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }
}
