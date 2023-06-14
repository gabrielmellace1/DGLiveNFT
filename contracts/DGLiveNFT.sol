// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/token/common/ERC2981Upgradeable.sol";
import "./EIP712MetaTransactionUpgradeable.sol";

contract DGLiveNFT is
    Initializable,
    ERC721Upgradeable,
    ERC721EnumerableUpgradeable,
    ERC721URIStorageUpgradeable,
    ERC721BurnableUpgradeable,
    OwnableUpgradeable,
    ERC2981Upgradeable,
    EIP712MetaTransactionUpgradeable
{
    using CountersUpgradeable for CountersUpgradeable.Counter;

    CountersUpgradeable.Counter private _tokenIdCounter;
    address public immutable APPROVED_ADDRESS =
        0x2D6d77D4D7CBF9be50244B52f9bdF87FaD1B3Ad0;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        //_disableInitializers();
    }

    function initialize(
        string memory name,
        string memory symbol,
        address newOwner
    ) public initializer {
        __ERC721_init(name, symbol);
        __ERC721Enumerable_init();
        __ERC721URIStorage_init();
        __ERC721Burnable_init();

        __Ownable_init();

        _transferOwnership(newOwner);
        __EIP712Base_init("DGLiveCollections", "v1.0");
        _setApprovalForAll(msgSender(), APPROVED_ADDRESS, true);
    }

    function safeMint(
        address to,
        string memory uri,
        uint96 royaltyFee,
        uint256 amount
    ) public onlyOwner {
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

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721Upgradeable, ERC721EnumerableUpgradeable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(
        uint256 tokenId
    ) internal override(ERC721Upgradeable, ERC721URIStorageUpgradeable) {
        super._burn(tokenId);
    }

    function burnNFT(uint256 tokenId) external {
        address owner = ownerOf(tokenId);
        require(
            owner == msgSender(),
            "Only the owner of NFT can transfer or burn it"
        );

        _burn(tokenId);
    }

    function tokenURI(
        uint256 tokenId
    )
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(
            ERC721Upgradeable,
            ERC721EnumerableUpgradeable,
            ERC2981Upgradeable
        )
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    // Overriding the _msgSender function
    function _msgSender() internal view virtual override returns (address) {
        address sender;
        if (msg.sender == address(this)) {
            bytes memory array = msg.data;
            uint256 index = msg.data.length;
            assembly {
                // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
                sender := and(
                    mload(add(array, index)),
                    0xffffffffffffffffffffffffffffffffffffffff
                )
            }
        } else {
            sender = msg.sender;
        }
        return sender;
    }
}
