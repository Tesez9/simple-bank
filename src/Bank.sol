// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Account} from "./Types.sol";
import {Deposited, Withdrawn} from "./Events.sol";
import {InsufficientBalance, AccountNotActive} from "./Errors.sol";

contract Bank {
    Account public account;

    function activate() public {
        account.isActive = true;
    }

    function deposit(uint256 amount) public {
        if (!account.isActive) revert AccountNotActive();

        account.balance += amount;
        emit Deposited(amount);
    }

    function withdraw(uint256 amount) public {
        if (!account.isActive) revert AccountNotActive();
        if (amount > account.balance) revert InsufficientBalance();

        account.balance -= amount;
        emit Withdrawn(amount);
    }

    function getBalance() public view returns (uint256) {
        return account.balance;
    }
}