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


