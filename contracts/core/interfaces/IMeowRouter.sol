// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 1*1/19999
interface IMeowRouter {

 function createInitMint(string memory name , uint256 mintAmount) external payable;

  function invest(uint256 tokenId, uint256 amount, uint256 safeOffset) external payable;

  function burn(uint256 tokenId, uint256 amount, uint256 safeOffset, address to) external;

  function withdrawCreateBounty(uint256 tokenId) external;

  function userHolderTokens(address user) external view returns (uint256[] memory);
}