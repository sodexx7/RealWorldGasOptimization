// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./openzeppelin-contracts-new/OwnedNew.sol";
import "./openzeppelin-contracts-new/SafeERC20New.sol";

/**
 * @title TokenVesting
 * @dev A token holder contract that can release its token balance gradually like a
 * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
 * owner.
 */
contract TokenVestingNew is OwnedNew {
    // The vesting schedule is time-based (i.e. using block timestamps as opposed to e.g. block numbers), and is
    // therefore sensitive to timestamp manipulation (which is something miners can do, to a certain degree). Therefore,
    // it is recommended to avoid using short time durations (less than a minute). Typical vesting schemes, with a
    // cliff period of a year and a duration of four years, are safe to use.
    // solhint-disable not-rely-on-time

    using SafeERC20New for IERC20;

    event TokensReleased(address token, uint256 amount);
    event TokenVestingRevoked(address token);

    // beneficiary of tokens after they are released
    address public immutable _beneficiary;

    // Durations and timestamps are expressed in UNIX time, the same units as block.timestamp.
    uint64 public _cliff;
    uint64 public _start;
    uint64 public _duration;

    bool public _revocable;

    mapping(address => uint256) private _released;
    mapping(address => bool) private _revoked;

    // custom error
    error InvalidZeroAddress(); // TokenVesting: beneficiary is the zero address

    error CliffBeyondDuration(); // "TokenVesting: cliff is longer than duration"

    error DurationIsZero();// duration is 0

    error FinalTimeBeyondCurTime(); // TokenVesting: final time is before current time"

    error NoUnreleasedToken(); // TokenVesting: no tokens are due
    
    error CannotRevoke();      //  TokenVesting: cannot revoke

    error AlreadyRevoked();  // token already revoked

    /**
     * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
     * beneficiary, gradually in a linear fashion until start + duration. By then all
     * of the balance will have vested.
     * @param beneficiary address of the beneficiary to whom vested tokens are transferred
     * @param cliffDuration duration in seconds of the cliff in which tokens will begin to vest
     * @param start the time (as Unix time) at which point vesting starts
     * @param duration duration in seconds of the period in which the tokens will vest
     * @param revocable whether the vesting is revocable or not
     */
    constructor(
        address beneficiary,
        uint64 start,
        uint64 cliffDuration,
        uint64 duration,
        bool revocable
    ) OwnedNew(msg.sender) payable {
        if(beneficiary == address(0)){
            revert InvalidZeroAddress();
        }
        // solhint-disable-next-line max-line-length
        if(cliffDuration > duration){
            revert CliffBeyondDuration();
        }
        if(duration == 0 ){
            revert DurationIsZero();
        }
        // solhint-disable-next-line max-line-length
        if(start+ duration <= block.timestamp){
            revert FinalTimeBeyondCurTime();
        }

        _beneficiary = beneficiary;
        _revocable = revocable;
        _duration = duration;
        unchecked {_cliff = start + cliffDuration;}
        _start = start;
    }


    /**
     * @return the amount of the token released.
     */
    function released(address token) public view returns (uint256) {
        return _released[token];
    }

    /**
     * @return true if the token is revoked.
     */
    function revoked(address token) public view returns (bool) {
        return _revoked[token];
    }

    /**
     * @notice Transfers vested tokens to beneficiary.
     * @param token ERC20 token which is being vested
     */
    function release(IERC20 token) external {
        uint256 unreleased = _releasableAmount(token);

        if(unreleased == 0){
            revert NoUnreleasedToken();
        }

        _released[address(token)] = _released[address(token)] + unreleased;

        token.safeTransfer(_beneficiary, unreleased);

        emit TokensReleased(address(token), unreleased);
    }

    /**
     * @notice Allows the owner to revoke the vesting. Tokens already vested
     * remain in the contract, the rest are returned to the owner.
     * @param token ERC20 token which is being vested
     */
    function revoke(IERC20 token) external payable onlyOwner {
        if(!_revocable){
            revert CannotRevoke();
        }
        if(_revoked[address(token)]){
            revert AlreadyRevoked();
        }

        uint256 balance = token.balanceOf(address(this));

        uint256 unreleased = _releasableAmount(token);
        uint256 refund = balance - unreleased;

        _revoked[address(token)] = true;

        token.safeTransfer(owner, refund);

        emit TokenVestingRevoked(address(token));
    }

    /**
     * @notice Allows owner to emergency revoke and refund entire balance,
     * including the vested amount. To be used when beneficiary cannot claim
     * anymore, e.g. when he/she has lots its private key.
     * @param token ERC20 which is being vested
     */
    function emergencyRevoke(IERC20 token) external payable onlyOwner {
        if(!_revocable){
            revert CannotRevoke();
        }
        if(_revoked[address(token)]){
            revert AlreadyRevoked();
        }

        uint256 balance = token.balanceOf(address(this));

        _revoked[address(token)] = true;

        token.safeTransfer(owner, balance);

        emit TokenVestingRevoked(address(token));
    }

    /**
     * @dev Calculates the amount that has already vested but hasn't been released yet.
     * @param token ERC20 token which is being vested
     */
    function _releasableAmount(IERC20 token) private view returns (uint256) {
        return _vestedAmount(token) - _released[address(token)];
    }

    /**
     * @dev Calculates the amount that has already vested.
     * @param token ERC20 token which is being vested
     */
    function _vestedAmount(IERC20 token) private view returns (uint256) {
        uint256 currentBalance = token.balanceOf(address(this));
        uint256 totalBalance = currentBalance + _released[address(token)];

        if (uint64(block.timestamp) < _cliff) {
            return 0;
        } else if (uint64(block.timestamp) >= _start + _duration || _revoked[address(token)]) {
            return totalBalance;
        } else {
            return (totalBalance * (uint64(block.timestamp) - _start)) / _duration;
        }
    }
}
