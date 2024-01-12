
# Security issues and the confusion of the buisness logic

## 1.release Function
* The goal of this funciton is release the required ERC20 token to the beneficiary address, but don't check who can call this function and don't check the token address.
    * For my understanding, this function should only called by the beneficiary address.
    * If the token address is not the required address, the beneficiary address will get other token if that token exists.

* This funciton should add reentrance check, otherwise if beneficiary is smart contract, which can reentrance this function and get more token than the config.


```Solidity 
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

```



## 2. _vestedAmount Function
* This function calculate how much token can be released to beneficiary address, but the currentBalance can be effected by others `uint256 currentBalance = token.balanceOf(address(this));`, suppose one send the token to this address while calling this function, then the totalBalance will be greater than the config. So my thought is the balance should be recorded in advance.
```
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
```

## 3. Precious problem

For the calculation `(totalBalance * (uint64(block.timestamp) - _start)) / _duration;` which don't consider the precious problem, what's the precious of this formula? if totalBalance * (uint64(block.timestamp) - _start) < _duration, how to deal with it?

```
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
```


## 4. The confusion of the business logic

***revoke and emergencyRevoke funciton***
* The goal of emergencyRevoke is revoke all balance, but if call revoke fistly, which will send the balance except the vested token to the owner. then call emergencyRevoke, the owner can't get any left balance.

* related function(_vestedAmount), conflict logic: no matter the owner call revoke or emergencyRevoke, _revoked[address(token)] will be true. The blance have reduced, so based on this balance doesn't satisfy the vest requirements. For my understanding, the release amount should based on the total balance, shouldn't substract the revokedToken and if revoke all token, it's unnecsssary to release.

```
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

```

* Based on above, I think the release and revoke logic should make it more clean. 

## 5. The confusion of the ERC20 token logic

 * For the ERC20 token, can't sure only accept one ERC20 token or many ERC20 token; if only accept one ERC20 token, Inputting the erc20 token address is unnecessary. If accept many ERC20 tokens. I think for different ERC20 tokens should have different vesting config, but current code only support one fixed time plan.


This is my try to solve some of the above issues [TokenVestingNewOptimal](contracts/TokenVestingNewOptimal.sol), which doesn't test.