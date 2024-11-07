// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {SimpleTrick, GatekeeperThree} from "../src/contracts/28_GatekeeperThree.sol";
import {GatekeeperThreeAttacker} from "../src/attackers/28_GatekeeperThreeAttacker.sol";

contract GatekeeperThreeTest is Test {
    address private owner = makeAddr("owner");
    address private attacker = makeAddr("attacker");
    GatekeeperThree private gatekeeperThree;
    GatekeeperThreeAttacker private gatekeeperThreeAttacker;

    function setUp() public {
        vm.startPrank(owner);
        gatekeeperThree = new GatekeeperThree();
        gatekeeperThree.construct0r();
        gatekeeperThree.createTrick();
        vm.stopPrank();

        vm.prank(attacker);
        deal(attacker, 0.0011 ether);
        gatekeeperThreeAttacker = new GatekeeperThreeAttacker(
            address(gatekeeperThree)
        );
    }

    function test_GatekeeperThreeExploitVulnerability() public {
        vm.startBroadcast(attacker);
        gatekeeperThreeAttacker.attack{value: 0.0011 ether}();
        vm.stopBroadcast();

        assertEq(gatekeeperThree.entrant(), attacker);
    }
}
