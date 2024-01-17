// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 1*1/19999
interface IPriceCurve {

  function calcMintAmount(uint256 supply, uint256 amount) external view returns (uint256);

  function calcBurnAmount(uint256 supply, uint256 amount) external view returns (uint256);
  
}