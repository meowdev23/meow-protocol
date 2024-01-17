// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IMeowToken {

  function mint(address to, uint256 id, uint256 value, bytes memory data) external;

  function burn(address from, uint256 id, uint256 value) external;


  function totalSupply(uint256 id) external view returns (uint256);

  function totalSupply() external view returns (uint256);

  function exists(uint256 id) external view returns (bool);

  function balanceOf(address account, uint256 id) external view returns (uint256);

}
