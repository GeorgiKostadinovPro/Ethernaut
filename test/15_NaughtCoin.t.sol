// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {NaughtCoin} from "../src/contracts/15_NaughtCoin.sol";
import {NaughtCoinAttacker} from "../src/attackers/15_NaughtCoinAttacker.sol";

contract NaughtCoinTest is Test {
    uint256 private constant INITIAL_SUPPLY = 1000000 * (10 ** 18);
    address private player = makeAddr("player");
    NaughtCoin private naughtCoin;
    NaughtCoinAttacker private naughtCoinAttacker;

    function setUp() public {
        naughtCoin = new NaughtCoin(player);
        naughtCoinAttacker = new NaughtCoinAttacker(address(naughtCoin));
    }

    function test_NuaghtCoinExploitVulnerability() public {
        vm.startPrank(player);
        naughtCoin.approve(address(naughtCoinAttacker), INITIAL_SUPPLY);
        naughtCoinAttacker.attack();
        vm.stopPrank();

        assertEq(
            naughtCoin.balanceOf(address(naughtCoinAttacker)),
            INITIAL_SUPPLY
        );
        assertEq(naughtCoin.balanceOf(player), 0);
    }
}
