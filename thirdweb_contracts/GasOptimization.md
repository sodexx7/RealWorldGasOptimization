## TARGET SMART CONTRACT
*  [Staking721New.sol](contracts/extension/Staking721New.sol) copy [Staking721.sol](contracts/extension/Staking721.sol)  
*  test file
    * forge test --match-contract StakingExtensionTestNew --gas-report
    * [StakingExtensionNew.t.sol](./src/test/sdk/extension/StakingExtensionNew.t.sol) copy [StakingExtension.t.sol](./src/test/sdk/extension/StakingExtension.t.sol)

## ENVIRONMENT INFO
* evm version london
* solidity compiler 0.8.23 config `{ enabled: true, runs: 20 }.`


## PROTOCOL INTRODUCTION
> Thirdweb is a complete web3 development framework that provides everything you need to connect your apps and games to decentralized networks.
* Staking721 is a basic template contract, user staking NFT then get rewards. More features can build on this contract according to their demands, such as how to send rewards.  
* The main features about this contract are recording/calculating user's rewards, updating StakingCondition, supporting stake many token each time.
* The related contracts
    1. Depend on which contracts？
        * IStaking721，ERC721,ReentrancyGuard
    2. Which contracts based on this contract?
        * Staking721Base, just a demo contract using Staking721，ERC721
* [Staking721Implementation notes](Staking721Implementation.md)
## GAS COST(CURRENT)
- OriginalConsumedGas
 * ***Because Staking721 is a template contract, should create the needed contract based on it while applying it. Current test contract is MyStakingContract, the below functions(balanceOf() / setCondition()) are MyStakingContract's functions. other are Staking721's original functions.*** 
  <img src="OriginalConsumedGas.png" alt="external_result" width="1000"/>



## GAS COST(AFTER OPTIMISING)




## GAS OPTIMAL LIST

[GasOptimizationList](GasOptimizationList.md)


## SECURITY CONSIDERATIONS
[SecurityConsiderations](SecurityConsiderations.md)



## PROTOCOL MATERIALS
1. based on below commit hash: 
    *   https://github.com/thirdweb-dev/contracts 9d33ac18a61cf84e165c83aa2bc596e80a8379a2
2. [Offical web](https://portal.thirdweb.com/contracts)
3. [Staking721](contracts/extension/Staking721.sol)
    * https://portal.thirdweb.com/contracts/build/extensions/erc-721/ERC721Staking
    * https://portal.thirdweb.com/solidity/base-contracts/staking/staking721base
    

