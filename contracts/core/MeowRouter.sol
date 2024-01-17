// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "./interfaces/IMeowFactory.sol";
import "./interfaces/IPriceCurve.sol";
import "./interfaces/IMeowToken.sol";

contract MeowRouter is OwnableUpgradeable {

  address public router;

  IMeowToken    public meowToken;
  IPriceCurve   public priceCurve;
  IMeowFactory  public factory;

  uint256 constant public FEE_BASE = 10000; //based-10000;

  uint256 public createFeeRate; //based-10000;
  uint256 public serviceFeeRate; //based-10000;

  uint256 public totalInvestAmount;
  uint256 public totalInvestFeeHis;

  uint256 public totalServiceFee;

  mapping(uint256 => uint256) public investFee;
  mapping(uint256 => uint256) public investVault;

  event WithdrawCreateBounty(uint256 indexed tokenId, address indexed user, uint256 bountyAmount);
  event Burn(uint256 indexed tokenId, address indexed user, uint256 amount, uint256 tradeValue, uint256 createFeeRate, uint256 serviceFeeRate);
  event Invest(uint256 indexed tokenId, address indexed user, uint256 amount, uint256 tradeValue, uint256 createFeeRate, uint256 serviceFeeRate);

  modifier onlyRouter(){
    require(msg.sender == router, "Require only router");
    _;
  }
  
  function initialize(
    address _factory,
    address _meowToken,
    address _priceCurve,
    uint256 _createFeeRate,
    uint256 _serviceFeeRate
  ) 
      initializer 
      public 
  {
    __Ownable_init();
    
    factory = IMeowFactory(_factory);
    priceCurve = IPriceCurve(_priceCurve);
    meowToken = IMeowToken(_meowToken);
    
    createFeeRate = _createFeeRate;
    serviceFeeRate= _serviceFeeRate;
  }

  function createInitMint(string memory name , uint256 mintAmount) external payable {
    uint256 tokenId = factory.create(name, msg.sender);
    invest(tokenId, mintAmount, 0);

  }

  function invest(uint256 tokenId, uint256 amount, uint256 safeOffset) public payable {
    require(factory.tokenIdAvailable(tokenId), "TokenId unavailable");
    require(meowToken.totalSupply(tokenId) <= safeOffset, "Slippage over safeOffset");
    
    uint256 investValue = priceCurve.calcMintAmount( meowToken.totalSupply(tokenId), amount);

    require(msg.value >= investValue, "Invest amount insufficient");
    uint256 createFee  = investValue * createFeeRate / FEE_BASE;
    uint256 serviceFee = investValue * serviceFeeRate / FEE_BASE;

    investFee[tokenId] = investFee[tokenId] + createFee;
    investVault[tokenId] = investVault[tokenId] + (investValue - createFee - serviceFee);

    totalInvestFeeHis += createFee;
    totalServiceFee += serviceFee;

    meowToken.mint(msg.sender, tokenId, amount, new bytes(0));

    if(msg.value > investValue) {
      payable(msg.sender).transfer(msg.value - investValue);
    }

    emit Invest(tokenId, msg.sender, amount, investValue, createFeeRate, serviceFeeRate);
  }

  function burn(uint256 tokenId, uint256 amount, uint256 safeOffset, address to) public {

    require(meowToken.totalSupply(tokenId) >= safeOffset, "Total Supply lt safeOffset");

    uint256 burnValue = priceCurve.calcBurnAmount(meowToken.totalSupply(tokenId), amount);
    meowToken.burn(msg.sender, tokenId, amount);

    uint256 createFee  = burnValue * createFeeRate / FEE_BASE;
    uint256 serviceFee = burnValue * serviceFeeRate / FEE_BASE;

    investFee[tokenId] = investFee[tokenId] + createFee;
    // sub assets form vault
    investVault[tokenId] = investVault[tokenId] - burnValue;
    // just show record
    totalInvestFeeHis += createFee;
    // platform fee
    totalServiceFee += serviceFee;
    // transfer
    payable(to).transfer(burnValue - createFee - serviceFee);
    
    emit Burn(tokenId, msg.sender, amount, burnValue, createFeeRate, serviceFeeRate);
  }

  function withdrawCreateBounty(uint256 tokenId) external {

    require(factory.tokenCreateOwner(tokenId) == msg.sender, "Only create owner");

    uint256 bountyAmount = investFee[tokenId];
    // reset
    investFee[tokenId] = 0;
    if(bountyAmount > 0 ) {
      payable(msg.sender).transfer(bountyAmount);
      emit WithdrawCreateBounty(tokenId, msg.sender, bountyAmount);
    }
  }

  function setPriceCurve(address _curve) external onlyOwner {
    priceCurve = IPriceCurve(_curve);
  }

  function setFee(uint256 _createFeeRate, uint256 _serviceFeeRate) external onlyOwner {
    createFeeRate = _createFeeRate;
    serviceFeeRate= _serviceFeeRate;
  }


  function userHolderTokens(address user) external view returns (uint256[] memory) {
    uint256 allMeowLength = factory.allMeowLength();

    uint256[] memory balances = new uint256[](allMeowLength);

    for (uint256 index = 0; index < allMeowLength; index++) {
      balances[index] = meowToken.balanceOf(user, index);
    }

    return balances;
  }

  function userHolderValue(address user) external view returns (uint256 value) {
    uint256 allMeowLength = factory.allMeowLength();

    for (uint256 index = 0; index < allMeowLength; index++) {
      uint256 bal = meowToken.balanceOf(user, index);
      if(bal > 0) {
        value = priceCurve.calcBurnAmount(meowToken.totalSupply(index), bal);
      }
    }
  }
}
