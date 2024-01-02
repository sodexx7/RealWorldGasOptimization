## GasOptimizationList

1. **Deployment gas cost vs Runtime gas cost**
    * For the StakingRewards contract's main goal is user will frequently interacting with this contract, So should put more attention on running time Optimization. Now using the defalue setting `runs: 200 `. So can improve this number to save more gas while user interacting with this contract. Reference:[smart-contract-creation-cost](https://www.rareskills.io/post/smart-contract-creation-cost)

2. All error string changed to the custom error type meanwhile SafeERC20 using latest version v5.0.0. 
    * memory just using 32 bytes, TODO when add param ？？？
    ** comparing customError, seems sometimes its's more readable for using long error message.
    ```
    /* ========== CUSTOMER ERROR ========== */
    error StakeAmountMustGTZero();

    error WithDrawAmountMustGTZero();

    error ProvidedRewardTooHigh();

    error UnableWithDarawStakingToken();

    error PreviousRewardsShouldDoneBeforeChangDuration();
    
    ```

3. Visibility and init value check
 ```solidity
    IERC20 public rewardsToken;               => IERC20 public immutable  rewardsToken; 
    IERC20 public stakingToken;               => IERC20 public immutable  stakingToken;
    uint256 public periodFinish;          
    uint256 public rewardRate = 0;            => uint256 public rewardRate = 1; //from non-zero =>non-zero which save more gas than from zero=>non-zero. but which seems make the code less readable 
    uint256 public rewardsDuration = 7 days; 
    uint256 public lastUpdateTime;            => uint256 private lastUpdateTime;
    uint256 public rewardPerTokenStored;      => uint256 private rewardPerTokenStored;

 ```
 
 4. Most depended lib has used the latest pratice, such as ReentrancyGuardNew

 ```solidity
 ReentrancyGuardNew
     uint256 private constant _NOT_ENTERED = 1;
     uint256 private constant _ENTERED = 2;

      uint256 private _status = _NOT_ENTERED;
 ```

5. make constructors payable, which save deployment gas cost

**Gas Cost Beginning**
<img src="OriginalConsumedGas.png" alt="external_result" width="1000"/>

**Gas Cost build on above change**
<img src="ConsumedGas_V1.png" alt="external_result" width="1000"/>

**Gas costAll for function and deployed  have reduced**

