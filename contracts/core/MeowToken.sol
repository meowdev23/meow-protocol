// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


contract MeowToken is ERC1155Supply, Ownable {

  address public router;

  modifier onlyRouter(){
    require(msg.sender == router, "Require only router");
    _;
  }
  
  constructor(
    string memory uri_
  ) 
    ERC1155(uri_) 
    // Ownable(msg.sender)
  {
  }

  function setRouter(address _router) external onlyOwner {
      router = _router;
  }

  function mint(address to, uint256 id, uint256 value, bytes memory data) external onlyRouter {
    _mint(to, id, value, data);
  }

  function burn(address from, uint256 id, uint256 value) external {
    require(from == tx.origin, "Only burn by self");
    _burn(from, id, value);
  }

}
