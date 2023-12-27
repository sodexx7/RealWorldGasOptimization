
## Target smart contract: TokenVestingNew  
* based on the TokenVesting, changed points. for compatibling with current projects, add suffix(New)
    1. solidity compiler chaning from ^0.6.0 to ^0.8.0
    2. Using a new version of Ownable, SafeERC20, which is OpenZeppelin Contracts v4.4.1
    3. delete SafeMath
* compiler
    1. Old version is 0.6.12, but for TokenVestingNew is 0.8.0
    2. setting
        ```
         optimizer: {
            enabled: true,
            runs: 200,
          },
        ```
* test files
    * yarn test:gas test/TokenVestingNew.test.ts



* OriginalConsumedGas
<img src="OriginalConsumedGas.png" alt="external_result" width="1000"/>

## project Info
1. 5bec2f3d86500bfd81038c99afe702ee7e67af3e https://github.com/traderjoe-xyz/joe-core
2. offical web  https://traderjoexyz.com/
3. on-chain address   https://github.com/traderjoe-xyz/joe-core/tree/5bec2f3d86500bfd81038c99afe702ee7e67af3e/deployments todo
    * ethereeum no address?
4. 

