
## Staking Considerrations

1. **Rewards staking Config**
    * Some protocol just based on the time the staker have staked, Some add more configs such as the applicableTime, only in the applicableTime can have the rewards, Some make the stakingConfig more flexible, can specify arbitrary periods, each periods can specify the rewards and the more details.
    like Looksrare config StakingPeriod, each period have different rewards and different blocks. third-web have applied same logic but based on the block.timestamp. joe-contract just directly based on the applicableTime.

    * More flexibility:
    The stakingConfig makes the rewards distribution more flexibility, and the owner or authorized-account can modify the config,, which make the rewards distributation more complex. Such as third-web `_calculateRewards`, LooksRare,  `calculatePendingRewards`. 

2. **The source of rewards**
    * The rewards either was minted from the stakingContract or was send to stakingContract by other contract. such as synchetix have  RewardsDistribution sending the rewards. LooksRare was minted by the stakingContract's itself.

    * security point:
    If the rewards was from other contract, stakingContract have recorded the amountRewardsToken, so should keep the consisitant between the record amount and the acutal amount.  Like synthetix how to deal with it. [SecurityConsiderations](synthetix/SecurityConsiderations.md)

3. **How to calculate rewards**
    * Each time the user interactive with  the stakingContract, will update the pending rewards with the latest block.timestamp or lastest block. 
    More details can see the PROTOCOL INTRODUCTION in each protocal.

    * security point:
    Precision problems, synchetix and LooksRare all have dealed this problem

4. **Staking token vs rewards token**
    * Stakinig token can be NFT or ERC20 token, for ERC20 token, sometimes the staking token and the rewards token are the same toekn, like Looksrare, in this situation, people can harvestAndCompound.

