## Target Smart contract Staking721.sol 

* third-web intro
    https://portal.thirdweb.com/contracts 

1. compiler ^0.8.11
2. set
    ```
    solc-version = "0.8.23"
    evm_version = 'london'
    optimizer = true
    optimizer_runs = 20
    ```
3. test FILE
    [StakingExtension](./src/test/sdk/extension/StakingExtension.t.sol)
    * forge gas test --mc StakingExtensionTest TODO CHECK

- OriginalConsumedGas
  <img src="OriginalConsumedGas.png" alt="external_result" width="1000"/>


## Project Info
* commit 9d33ac18a61cf84e165c83aa2bc596e80a8379a2 https://github.com/thirdweb-dev/contracts
* [Staking721](contracts/extension/Staking721.sol)
    * https://portal.thirdweb.com/solidity/extensions/erc721staking
    * https://portal.thirdweb.com/solidity/base-contracts/staking/staking721base


TODO check the gas consume