

pragma solidity ^0.8.0;

// https://docs.synthetix.io/contracts/source/contracts/owned
contract OwnedNew {
    address public owner;
    address public nominatedOwner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
     error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
     error OwnableInvalidOwner(address owner);

    constructor(address _owner) payable {
        if(_owner == address(0)){
            revert OwnableInvalidOwner(address(0));
        }
        owner = _owner;
        emit OwnerChanged(address(0), _owner);
    }

    function nominateNewOwner(address _owner) external onlyOwner {
        nominatedOwner = _owner;
        emit OwnerNominated(_owner);
    }

    function acceptOwnership() external {
        if(msg.sender != nominatedOwner){
            revert OwnableUnauthorizedAccount(msg.sender);
        }

        
        emit OwnerChanged(owner, nominatedOwner);
        owner = nominatedOwner;
        nominatedOwner = address(0);
    }

    modifier onlyOwner {
        if(msg.sender != owner){
            revert OwnableInvalidOwner(msg.sender);
        }
        _;
    }


    event OwnerNominated(address newOwner);
    event OwnerChanged(address oldOwner, address newOwner);
}

