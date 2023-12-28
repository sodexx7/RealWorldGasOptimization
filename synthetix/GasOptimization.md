## TARGET SMART CONTRACT
*  [StakingRewardsNew](contracts/StakingRewardsNew.sol) based on [StakingRewards](contracts/StakingRewards.sol)
*  test file
    * REPORT_GAS=true npx hardhat test test/contracts/StakingRewardsNew.js
    * [StakingRewardsNew.js](test/contracts/StakingRewardsNew.js)
## CHANGED POINTS FOR CONVERTING COMPILER VERSION 
* [changed points](./AdjustCompilerVersion.md) 

## ENVIRONMENT INFO
* evm version london
* solidity compiler 0.8.14 set `{ enabled: true, runs: 200 }.`


## PROTOCOL INTRODUCTION

## GAS COST(CURRENT)
- OriginalConsumedGas
  * ***As StakingRewardsNew based on many contracts(I have delete these contracts in the blew table) which use another compiler version(0.5.16), the blew compiler version shows 0.8.14, but the optimizer setting{ enabled: true, runs: 200 } doesn't show.  perhaps there are some compitable problem with these. The blew just give rough estimatation***
  <img src="OriginalConsumedGas.png" alt="external_result" width="1000"/>


## GAS COST(AFTER OPTIMISING)




## GAS OPTIMAL LIST











## PROTOCOL MATERIALS

1. based on below commit hash: 
    * https://github.com/Synthetixio/synthetix/tree/develop 365764b265a2ee2f55d08d5d3147a6ece0224cfe
2. [Offical web](https://synthetix.io/)
3. on-chain address 
    * [addresses.md](https://github.com/Synthetixio/synthetix-docs/blob/master/content/addresses.md)
    * [StakingRewardsiBTC on-chain(Ethereum) address]( https://etherscan.io/address/0x167009dcDA2e49930a71712D956f02cc980DcC1b#code) 

