## TARGET SMART CONTRACT
*  [TokenVestingNew](contracts/TokenVestingNew.sol) based on [TokenVesting](contracts/TokenVesting.sol)
*  test file
    * yarn test:gas test/TokenVestingNew.test.ts
    * [TokenVestingNew.test.ts](test/TokenVestingNew.test.ts)


## CHANGED POINTS FOR CONVERTING COMPILER VERSION 
1. solidity compiler chaning from ^0.6.0 to ^0.8.0
2. Using a new version of [Ownable](contracts/openzeppelin-contracts-new/OwnedNew.sol), [SafeERC20](contracts/openzeppelin-contracts-new/SafeERC20New.sol), which is OpenZeppelin Contracts v4.4.1
3. delete SafeMath,TokenVesting => TokenVestingNew 

## ENVIRONMENT INFO
* evm version istanbul
* solidity compiler 0.8.0 config `{ enabled: true, runs: 200 }.`


## PROTOCOL INTRODUCTION
* As offical web introduction: One-stop-shop decentralized trading on Avalanche. 

* **For the TokenVesting, whose main feature is released the token( TokenVesting holds) to the beneficiary address according to limited period.If in the duration, released the token in a linear fashion, if beyond the start+duration,relased all the vested balance.(this logic seems wired, todo check). Meanwhile the owner can revoke the given token's balance either portion or all.**

* TokenVesting use below contracts
    1. Safe or Privilege management. SafeERC20 Owned

* Quesiton. Now doesn't see other smart contracts are using this contract meanwhile doesn't find this contract have been deployed.


## GAS COST(CURRENT)
* OriginalConsumedGas
<img src="OriginalConsumedGas.png" alt="external_result" width="1000"/>

- related code version: 9c61416c8068d7050e8999cb66ef352795e04a7f

## GAS COST(AFTER OPTIMISING)




## GAS OPTIMAL LIST

* [GasOptimalList](GasOptimalList.md)









## PROTOCOL MATERIALS
1. based on below commit hash: 
    * https://github.com/traderjoe-xyz/joe-core 5bec2f3d86500bfd81038c99afe702ee7e67af3e
2. [Offical web](https://traderjoexyz.com/)
3. on-chain address   https://github.com/traderjoe-xyz/joe-core/tree/5bec2f3d86500bfd81038c99afe702ee7e67af3e/deployments todo
    * ethereeum no address?

