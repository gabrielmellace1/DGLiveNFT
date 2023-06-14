// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

interface ISimpleNFT {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function initialize(string calldata name, string calldata symbol) external;
}
