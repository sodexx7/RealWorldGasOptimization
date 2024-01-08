// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./openzeppelin-contracts-new/SafeERC20New.sol";
import  "./openzeppelin-contracts-new/IERC20.sol";
import  "./openzeppelin-contracts-new/PausableNew.sol";
import  "./openzeppelin-contracts-new/OwnedNew.sol";
import  "./openzeppelin-contracts-new/ReentrancyGuardNew.sol";

// Inheritance
import "./interfaces/IStakingRewardsNew.sol";
import "./RewardsDistributionRecipientNew.sol";

// https://docs.synthetix.io/contracts/source/contracts/stakingrewards
contract StakingRewardsNew is IStakingRewardsNew, RewardsDistributionRecipientNew, ReentrancyGuardNew, PausableNew {
    using SafeERC20New for IERC20;

    /* ========== STATE VARIABLES ========== */

    IERC20  public immutable  rewardsToken;
    IERC20  public immutable  stakingToken;

    uint256 public  rewardRate = 1;
    uint64 public  periodFinish;
    uint64 public  rewardsDuration = 7 days;

    uint64 private lastUpdateTime;
    uint256 private rewardPerTokenStored;

    mapping(address => uint256) private userRewardPerTokenPaid;
    mapping(address => uint256) private rewards;

    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;

    /* ========== CUSTOMER ERROR ========== */
    error StakeAmountMustGTZero();

    error WithDrawAmountMustGTZero();

    error ProvidedRewardTooHigh();

    error UnableWithDarawStakingToken();

    error PreviousRewardsShouldDoneBeforeChangDuration();

    /* ========== CONSTRUCTOR ========== */

    constructor(
        address _owner,
        address _rewardsDistribution,
        address _rewardsToken,
        address _stakingToken
    ) OwnedNew(_owner) payable {
        rewardsToken = IERC20(_rewardsToken);
        stakingToken = IERC20(_stakingToken);
        rewardsDistribution = _rewardsDistribution;
    }

    /* ========== VIEWS ========== */
    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    function lastTimeRewardApplicable() public view returns (uint64) {
        uint64 _periodFinish = periodFinish; // cache periodFinish
        return uint64(block.timestamp) < _periodFinish ? uint64(block.timestamp) : _periodFinish;
    }

    function rewardPerToken() public view returns (uint256) {
        if (_totalSupply == 0) {
            return rewardPerTokenStored;
        }
        return
            rewardPerTokenStored + ((lastTimeRewardApplicable() - lastUpdateTime) * rewardRate * 1e18 / _totalSupply);

    }

    function earned(address account) public view returns (uint256) {
        return (_balances[account] * (rewardPerToken() - userRewardPerTokenPaid[account])) / 1e18 + (rewards[account]);

    }

    function getRewardForDuration() external view returns (uint256) {
        return rewardRate * rewardsDuration;
    }

    /* ========== MUTATIVE FUNCTIONS ========== */

    function stake(uint256 amount) external nonReentrant whenNotPaused updateReward(msg.sender) {
        assembly{
            if iszero(amount){
                mstore(0x00,0xbdfa336600000000000000000000000000000000000000000000000000000000) //0xbdfa3366
                revert(0x00,0x04)  
            }
        }

        _totalSupply = _totalSupply + amount;
        _balances[msg.sender] = _balances[msg.sender] + amount;
        stakingToken.safeTransferFrom(msg.sender, address(this), amount);
       
        emit Staked(msg.sender, amount);
    }

    function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
        if(amount == 0){
            revert WithDrawAmountMustGTZero();
        }

        _totalSupply = _totalSupply - amount;
        _balances[msg.sender] = _balances[msg.sender] - amount;
        stakingToken.safeTransfer(msg.sender, amount);
        emit Withdrawn(msg.sender, amount);
    }

    function getReward() public nonReentrant updateReward(msg.sender) {
        uint256 reward = rewards[msg.sender];
        if (reward > 0) {
            rewards[msg.sender] = 0;
            rewardsToken.safeTransfer(msg.sender, reward);
            emit RewardPaid(msg.sender, reward);
        }
    }

    function exit() external {
        withdraw(_balances[msg.sender]);
        getReward();
    }

    /* ========== RESTRICTED FUNCTIONS ========== */

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

    // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
    function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
        if(tokenAddress == address(stakingToken)){
            revert UnableWithDarawStakingToken();
        }
        IERC20(tokenAddress).safeTransfer(owner, tokenAmount);
        emit Recovered(tokenAddress, tokenAmount);
    }

    function setRewardsDuration(uint64 _rewardsDuration) external payable  onlyOwner {
       
        if(block.timestamp <= periodFinish){
            revert PreviousRewardsShouldDoneBeforeChangDuration();
        }
        rewardsDuration = _rewardsDuration;
        emit RewardsDurationUpdated(rewardsDuration);
    }

    /* ========== MODIFIERS ========== */

    modifier updateReward(address account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = lastTimeRewardApplicable();
        if (account != address(0)) {
            rewards[account] = earned(account);
            userRewardPerTokenPaid[account] = rewardPerTokenStored;
        }
        _;
    }

    /* ========== EVENTS ========== */

    event RewardAdded(uint256 reward);
    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);
    event RewardsDurationUpdated(uint256 newDuration);
    event Recovered(address token, uint256 amount);
}
