### Build & Compile

```
> yarn install
> npx hardhat compile
```

### About MEOW

MEOW is based ERC1155 protocol, and mint/burn run with the ` Price Curve ` list following;

1. Team Clicking: Soon, you'll be able to create teams in Popcat. Users will be able to create their own teams and the clicks of the teams will be compounded.
 
2. Team Value: As more users and clicks join a team, its value goes up. You can also buy or sell MEOWS, the tickets to enter a team.
 
3. MEOW Price: The value of the meows will follow a bonding curve that reflects the value of each MEOW depending on its popularity


### Mint price

- Bonding Curve's Function => f(price) = (supply^2)/19999.
Price refers to the current ETH rate at which user can purchase the next key/vote.
- Supply refers to the outstanding amount of keys that holders currently own.
- Example calculation => for the supply of 200 keys, price equals 0.2 ETH.

- createFee: 4.5% buy/sell fee for the creator of MEOW scope， 4.5% fee for platform 