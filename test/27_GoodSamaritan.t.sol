// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {GoodSamaritan} from "../src/contracts/27_GoodSamaritan.sol";
import {GoodSamaritanAttacker} from "../src/attackers/27_GoodSamaritanAttacker.sol";

contract DoubleEntryPointTest is Test {
    address private owner = makeAddr("owner");
    address private attacker = makeAddr("attacker");
    GoodSamaritan private goodSamaritan;
    GoodSamaritanAttacker private goodSamaritanAttacker;

    function setUp() public {
        vm.prank(owner);
        goodSamaritan = new GoodSamaritan();

        vm.prank(attacker);
        goodSamaritanAttacker = new GoodSamaritanAttacker(
            address(goodSamaritan)
        );
    }

    function test_GoodSamaritanExploitVulnerability() public {
        vm.startPrank(attacker);
        goodSamaritanAttacker.attack();
        vm.stopPrank();

        address walletAddr = address(goodSamaritan.wallet());

        assertEq(goodSamaritan.coin().balances(walletAddr), 0);
        assertEq(
            goodSamaritan.coin().balances(address(goodSamaritanAttacker)),
            10 ** 6
        );
    }
}
