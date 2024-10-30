// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {CoinFlip} from "../src/contracts/03_CoinFlip.sol";
import {CoinFlipAttacker} from "../src/attackers/03_CoinFlipAttacker.sol";

contract CoinFlipTest is Test {
    CoinFlip private coinFlip;
    CoinFlipAttacker private coinFlipAttacker;

    function setUp() public {
        coinFlip = new CoinFlip();
        coinFlipAttacker = new CoinFlipAttacker(address(coinFlip));
    }

    function test_CoinFlipExploitVulnerability() public {
        for (uint256 i = 0; i < 10; i++) {
            coinFlipAttacker.attack();
            vm.roll(block.number + 1);
        }

        assertEq(
            coinFlip.consecutiveWins(),
            10,
            "Attacker should make 10 consecutive wins"
        );
    }
}
