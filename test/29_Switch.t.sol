// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Switch} from "../src/contracts/29_Switch.sol";
import {SwitchAttacker} from "../src/attackers/29_SwitchAttacker.sol";

contract SwitchTest is Test {
    address private owner = makeAddr("owner");
    address private attacker = makeAddr("attacker");
    Switch private switchContract;
    SwitchAttacker private switchAttacker;

    function setUp() public {
        vm.prank(owner);
        switchContract = new Switch();

        vm.prank(attacker);
        switchAttacker = new SwitchAttacker(address(switchContract));
    }

    function test_SwitchExploitVulnerability() public {
        vm.prank(attacker);
        switchAttacker.attack();

        assertTrue(switchContract.switchOn());
    }
}
