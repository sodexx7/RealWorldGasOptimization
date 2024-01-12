
## notifyRewardAmount 
* This is fine. no problem. Just shows my check logic.

```Solidity
    function notifyRewardAmount(uint256 reward) external onlyRewardsDistribution updateReward(address(0)) override(RewardsDistributionRecipientNew){
            uint64 _rewardsDuration = rewardsDuration;
            if (block.timestamp >= periodFinish) {
                rewardRate = reward/ _rewardsDuration ;
            } else {
                uint256 remaining;
                unchecked{ remaining =  periodFinish - block.timestamp;}
                uint256 leftover = remaining * rewardRate;
                rewardRate = (reward + leftover) / _rewardsDuration;
            }

            // Ensure the provided reward amount is not more than the balance in the contract.
            // This keeps the reward rate in the right range, preventing overflows due to
            // very high values of rewardRate in the earned and rewardsPerToken functions;
            // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
            uint balance = rewardsToken.balanceOf(address(this));
            if(rewardRate > balance / _rewardsDuration ){
                revert ProvidedRewardTooHigh();
            }

            lastUpdateTime = uint64(block.timestamp);
            periodFinish = uint64(block.timestamp) + _rewardsDuration;
            emit RewardAdded(reward);
        }
```

* For my understanding, this is the only entry that sends the rewards. This function can only be called by the RewardsDistribution, which firstly transfer the rewards token to the StakingRewards contract, then call notifyRewardAmount to modify the rewardRate.

* One check, `ProvidedRewardTooHigh`, which guarantee the reward amount must not beyond the current balance of the rewading token in the StakingRewards contract. 
    * Otherwise the rewardsRate will be higher comparing the actual rewards balance. such as reward amount is 10000, acutal amount 5000, assume rewardsDuration = 1000 seconds. rewardRate = 10, but the acutal rewardRate = 5. So for users there are no enough rewards token based on the rewardRate  when want to get the rewards. 

* Another check is guarantee Reward + leftover must be less than 2^256 / 10^18, Of course if beyond periodFinish, rewards should also satisfy this requirement. And this should checked by RewardsDistribution contract.
    * Such as if the Reward + leftover is 2^256 / 10^18 + 1, one possible scenario is when calculating the rewardPerToken. `(lastTimeRewardApplicable() - lastUpdateTime) * rewardRate * 1e18` will overflow if the periods the staker have staked beyond the rewardsDuration. Then as the overflow error, the user can't get the rewards in this scenario.

```
function rewardPerToken() public view returns (uint256) {
        if (_totalSupply == 0) {
            return rewardPerTokenStored;
        }
        return
            rewardPerTokenStored + ((lastTimeRewardApplicable() - lastUpdateTime) * rewardRate * 1e18 / _totalSupply);

    }
```

* There are other possibilities that others can send rewards to the StakingRewards conctact, though, which don't effect the rewardsRate because which is controlled by the RewardsDistribution contract. But It seems that if this contract has more balance than RewardsDistribution send, Seems there are two ways can withdraw all the excess rewards. 
    * For the RewardsDistribution, because notifyRewardAmount is called by it under the distributeRewards funcitons. So can't directly call notifyRewardAmount without sending rewards.
    * Another ways is calling recoverERC20 by owner can withdraw the excess rewards.