## TARGET SMART CONTRACT
*  [Staking721.sol](contracts/extension/Staking721.sol)
*  test file
    * forge gas test --mc StakingExtensionTest TODO CHECK
    * [StakingExtension.t.sol](./src/test/sdk/extension/StakingExtension.t.sol)

## ENVIRONMENT INFO
* evm version london
* solidity compiler 0.8.23 config `{ enabled: true, runs: 20 }.`


## PROTOCOL INTRODUCTION
> Thirdweb is a complete web3 development framework that provides everything you need to connect your apps and games to decentralized networks.
* Staking721 is a basic template contract, user staking NFT then get rewards. More features can build on this contract according to their demands, such as how to send rewards.  
* The main features about this contract are recording/calculating user's rewards, updating StakingCondition, supporting stake many token each time. **Now, for _calculateRewards perhaps there are some problem?**
* The related contracts
    1. Depend on which contracts？
        * IStaking721，ERC721,ReentrancyGuard
    2. Which contracts based on this contract?
        * Staking721Base, just a demo contract using Staking721，ERC721

**TODO check this logic:test_state_setTimeUnit in [StakingExtension.t.sol](./src/test/sdk/extension/StakingExtension.t.sol)**
## GAS COST(CURRENT)
- OriginalConsumedGas
  <img src="OriginalConsumedGas.png" alt="external_result" width="1000"/>


## GAS COST(AFTER OPTIMISING)




## GAS OPTIMAL LIST











## PROTOCOL MATERIALS
1. based on below commit hash: 
    *   https://github.com/thirdweb-dev/contracts 9d33ac18a61cf84e165c83aa2bc596e80a8379a2
2. [Offical web](https://portal.thirdweb.com/contracts)
3. [Staking721](contracts/extension/Staking721.sol)
    * https://portal.thirdweb.com/solidity/extensions/erc721staking
    * https://portal.thirdweb.com/solidity/base-contracts/staking/staking721base
    

