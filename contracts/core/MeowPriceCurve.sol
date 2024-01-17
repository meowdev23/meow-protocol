// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IMeowToken.sol";
import "./interfaces/IPriceCurve.sol";

contract MeowPriceCurve is IPriceCurve  {

  function calcMintAmount(uint256 supply, uint256 amount) public override pure returns (uint256) {

    uint256 totalSupply = supply;
    uint256 mintAmount = 0;
    for (uint256 index = 1; index <= amount; index++) {
      mintAmount += (totalSupply + index) * (totalSupply + index) * 10 **18  / 19999;
    }

    return mintAmount;
  }

  function calcBurnAmount(uint256 supply, uint256 amount) public override pure returns (uint256) {
    
    uint256 totalSupply = supply;
    uint256 mintAmount = 0;
    for (uint256 index = 0; index < amount; index++) {
        mintAmount += (totalSupply - index) * (totalSupply - index) * (10 **18) / 19999;
    }
    return mintAmount * 91 / 100; // 9% fee
  }
  
}
