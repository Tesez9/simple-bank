// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Bank} from "../src/Bank.sol";
import {InsufficientBalance, AccountNotActive} from "../src/Errors.sol";

contract BankTest is Test {
    Bank public bank;

    // новый банк перед каждым тестом
    function setUp() public {
        bank = new Bank();
    }

    // активация аккаунта
    function test_ActivateAccount() public {
        bank.activate();
        (, bool isActive) = bank.account();
        assertTrue(isActive);
    }

    // пополнение баланса
    function test_DepositSuccess() public {
        bank.activate();
        bank.deposit(100);
        assertEq(bank.getBalance(), 100);
    }

    // снятие средств
    function test_WithdrawSuccess() public {
        bank.activate();
        bank.deposit(100);
        bank.withdraw(40);
        assertEq(bank.getBalance(), 60);
    }

    // пополнение баланса неактивного аккаунта выдает ошибку
    function test_RevertWhen_DepositOnInactiveAccount() public {
        vm.expectRevert(AccountNotActive.selector);
        bank.deposit(100);
    }

    // снятие баланса с неактивного аккаунта выдает ошибку
    function test_RevertWhen_WithdrawOnInactiveAccount() public {
        vm.expectRevert(AccountNotActive.selector);
        bank.withdraw(100);
    }

    // снятие больше баланса выдает ошибку
    function test_RevertWhen_WithdrawMoreThanBalance() public {
        bank.activate();
        bank.deposit(100);
        vm.expectRevert(InsufficientBalance.selector);
        bank.withdraw(150);
    }

    // баланс меняется после нескольких операций
    function test_BalanceChangesCorrectlyAfterOperations() public {
        bank.activate();

        bank.deposit(200);
        assertEq(bank.getBalance(), 200);

        bank.withdraw(50);
        assertEq(bank.getBalance(), 150);

        bank.deposit(30);
        assertEq(bank.getBalance(), 180);
    }
}
