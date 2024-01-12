## Staking721Implementation

**Below are my summary of Staking721's implementation**

*  The core features includes stake many tokenIds, withdraw many tokenIds, get StakeInfo, withdraw all rewards and the  admin/authorized-account can change the stakingConditions which will change the acutal rewards.

* How to calculate the user's rewards?
    * based on three factors: tokenId nums, the time, stakingCondition(can define timeUnit and rewardsPerUnitTime)
    * if the admin/authorized-account changed the stakingCondition while token are staking, which can also change the user rewards.


*  when updating the user rewards?
    * Each time ther user stake, withdraw, claimRewards(all these have changed the stake tokenIds and stake timestamp), which changes the staker's Info as below. the conditionId will use the current conditonId. and will update the  unclaimedRewards based on the interaction time。 
        ```
            struct Staker {
            uint64 amountStaked;
            uint64 conditionIdOflastUpdate;
            uint128 timeOfLastUpdate;
            uint256 unclaimedRewards;
            }
        ```
* The complex scenario. How to calculate the rewards if user was staking but the admin/authorized-account changing the stakingConditions many times
    * Calculating all rewards based on all stakingConditions from the the user's current conditonId to the nextConditionId-1
    ```
        for (uint256 i = _stakerConditionId; i < _nextConditionId; i += 1) {
            StakingCondition memory condition = stakingConditions[i];

            uint256 startTime = i != _stakerConditionId ? condition.startTimestamp : staker.timeOfLastUpdate;
            uint256 endTime = condition.endTimestamp != 0 ? condition.endTimestamp : block.timestamp;

            (bool noOverflowProduct, uint256 rewardsProduct) = SafeMath.tryMul(
                (endTime - startTime) * staker.amountStaked,
                condition.rewardsPerUnitTime
            );
            (bool noOverflowSum, uint256 rewardsSum) = SafeMath.tryAdd(_rewards, rewardsProduct / condition.timeUnit);

            _rewards = noOverflowProduct && noOverflowSum ? rewardsSum : _rewards;
        }
    
    ```
    * one possible issue? While calculating the rewards, if overflow, will return zero. perhaps will encounter one scenario, the acutal rewards will less than the user's expected amount.

* variable isStaking.  When receiving the NFT, for the Staking721 contract check the transfer is by the stake funciton, preventing other ways transferring NFT to Staking721 contract.
    ```
            function onERC721Received(address, address, uint256, bytes calldata) external view override returns (bytes4) {
                require(isStaking == 2, "Direct transfer");
                return this.onERC721Received.selector;
            }
    ```

* Can send user rewards by implement the  `function _mintRewards(address _staker, uint256 _rewards) internal virtual;`


* Considering the  above implementation, This implementation of  [StakingContract](https://github.com/sodexx7/Week2_NFT_Staking_Security/blob/main/src/SmartContractTrio/StakingContract.sol) can adjust

