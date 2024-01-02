pragma solidity ^0.8.0;

// Inheritance
import "./openzeppelin-contracts-new/OwnedNew.sol";

// https://docs.synthetix.io/contracts/source/contracts/rewardsdistributionrecipient
abstract contract RewardsDistributionRecipientNew is OwnedNew {
    address public rewardsDistribution;

    error CallerNotRewardsDistribution();

    function notifyRewardAmount(uint256 reward) external virtual;

    modifier onlyRewardsDistribution() {
        if(msg.sender != rewardsDistribution){
            revert CallerNotRewardsDistribution();
        }
        _;
    }

    function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {
        rewardsDistribution = _rewardsDistribution;
    }
}
