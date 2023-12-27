## Target Smart contract StakingRewardsNew
[StakingRewardsNew](contracts/StakingRewardsNew.sol)

# Changed points
1. Based on the StakingRewards [StakingRewards](contracts/StakingRewards.sol)
2. Compiler version changing from ^0.5.16 to ^0.8.0;
3. For compatibling with version 0.8.14. have changed some points of StakingRewards and its imported libraries.
    1. add  ***New(suffix) for the changed files
    2. delete SafeMath in StakingRewardsNew
    3. add new files(**below are using OpenZeppelin Contracts v4.4.1.**)
        * SafeERC20 => SafeERC20New
        * ReentrancyGuard => ReentrancyGuardNew
        * IERC20 
        * Address
        * ReentrancyGuardNew
        * SafeERC20New
        * **below are just convert compiler version to ^0.8.0**
        * IStakingRewardsNew
        * RewardsDistributionRecipientNew
        * OwnedNew
        * PausableNew
4. Test file
    * StakingRewardsNew.js, which only converts StakingRewards to StakingRewardsNew, ReentrancyGuard to ReentrancyGuardNew,Owned to OwnedNew.
5. Some problem I have came across
    * The Arithmetic operation order should notice while deleting the SafeMath and using the typical arithmetic operations 
    ```
        rewardPerTokenStored.add(
                lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
        );

        ❌ Wrong Order:
        rewardPerTokenStored + (lastTimeRewardApplicable() - (lastUpdateTime) * (rewardRate) * (1e18) / _totalSupply);

        ✅ Right Order:
        rewardPerTokenStored + ((lastTimeRewardApplicable() - lastUpdateTime) * rewardRate * 1e18 / _totalSupply);

    ```        
* Acutally compiler version version: '0.8.14'        


* test file
    * npx hardhat test test/contracts/StakingRewardsNew.js
    [StakingRewardsNew.js](test/contracts/StakingRewardsNew.js)

## Project Info
1. based on the commit: 
    * https://github.com/Synthetixio/synthetix/tree/develop 365764b265a2ee2f55d08d5d3147a6ece0224cfe
2. official web
    * https://synthetix.io/
3. on-chain address
    * https://github.com/Synthetixio/synthetix-docs/blob/master/content/addresses.md 
    * StakingRewardsiBTC on-chain(Ethereum) address: https://etherscan.io/address/0x167009dcDA2e49930a71712D956f02cc980DcC1b#code


TODO
1. OVERFLOW check


Default EVM Version  shanghai
