// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IMeowFactory {

  function create(string memory name, address owner) external returns (uint256 tokenId);

  function allMeowLength() external view returns (uint256);
  function getTokenIdByName(string memory name) external view returns (uint256);

  function tokenNameAvailable(string memory name) external view returns (bool);

  function tokenIdAvailable(uint256 tokenId) external view returns (bool);
  
  function tokenCreateOwner(uint256 tokenId) external view returns (address);
  
  function getNameById(uint256 tokenId) external view returns (string memory name);
}
