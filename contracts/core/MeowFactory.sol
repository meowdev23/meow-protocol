// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MeowFactory {

  uint256 public allMeowLength;

  mapping(bytes32 => uint256) private tokenIdByNameHash;

  mapping(uint256 => string) private tokenName;
  
  mapping(uint256 => address) private tokenOwner;
  mapping(address => uint256) private userCreate;

  event Create(uint256 indexed tokenId);

  function create(string memory name, address owner) external returns (uint256 tokenId) {

    tokenId = allMeowLength;

    bytes32 nameHash = str2Hash(name);
    require(userCreate[owner] == 0 && tokenOwner[0] != owner, "User had created");
    require(tokenIdByNameHash[nameHash] == 0 , "The name had created");

    tokenName[tokenId] = name;
    tokenOwner[tokenId] = owner;

    allMeowLength++;
    tokenIdByNameHash[nameHash] = allMeowLength;
    
    emit Create(tokenId);
  }

  function tokenIdAvailable(uint256 tokenId) public view returns (bool) {
    return tokenId < allMeowLength;
  }
  
  function getNameById(uint256 tokenId) external view returns (string memory) {
    return tokenName[tokenId];
  }

  function getTokenIdByName(string memory name) external view returns (uint256) {
      bytes32 nameHash = str2Hash(name);
      return tokenIdByNameHash[nameHash] - 1;
  }

  function tokenCreateOwner(uint256 tokenId) external view returns (address) {
    require(tokenIdAvailable(tokenId), "TokenId unavailable");
    return tokenOwner[tokenId];
  }

  function str2Hash(string memory name) public pure returns (bytes32) {
      return keccak256( bytes(name));
  }
  
}
