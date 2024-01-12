## TokenDistributorImplementation

1. TokenDistributor contract as the only one source emitting the LooksRare Token(all  nonCirculatingSupply while this contract was deployed) for Staking users or Others(team + treasury + trading rewards)   

 
2. Staking time(blocks) considerations
    * Based on the StakingPeriod configs.  Each phase have below info.
    ```
        struct StakingPeriod {
            uint256 rewardPerBlockForStaking;
            uint256 rewardPerBlockForOthers;
            uint256 periodLengthInBlock;
        }
    ```
     Based on above info calculating the rewards. if the block.numbers passed many many phrases, should iterate all phrase calculating all rewards. This likes [Staking721 third-web](https://github.com/sodexx7/RealWorldGasOptimization/blob/19fe679a93d9a36cf4fea80043ee945f2effee52/thirdweb_contracts/contracts/extension/Staking721New.sol#L356), but which based on the block.timestamp

3. How to calculate the rewards?
    * like the [Synthetix](https://github.com/sodexx7/RealWorldGasOptimization/blob/7568b60e1af8671715de5c03bc838964c6707071/synthetix/GasOptimization.md?plain=1#L25), based on accTokenPerShare and rewardDebt calculating user's rewards. 
    * When user deposit, withdraw, withdrawAll,harvestAndCompound will update the latest  accTokenPerShare and rewardDebt. meanwhile tokenRewardForOthers will transfer to the tokenRewardForOthers contract.

4. The staking token and rewards token both are the LooksRare Token. and each time when user call deposit, withdraw, withdrawAll,harvestAndCompound will mint the corrospending rewards to the TokenDistributor contract. As staking and rewards token are same, so can call harvestAndCompound.



  