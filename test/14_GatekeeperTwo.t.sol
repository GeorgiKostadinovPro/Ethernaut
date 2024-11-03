// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {GatekeeperTwo} from "../src/contracts/14_GatekeeperTwo.sol";
import {GatekeeperTwoAttacker} from "../src/attackers/14_GatekeeperTwoAttacker.sol";

contract GatekeeperTwoTest is Test {
    GatekeeperTwo private gateKeeperTwo;
    GatekeeperTwoAttacker private gateKeeperTwoAttacker;

    function setUp() public {
        gateKeeperTwo = new GatekeeperTwo();
    }

    function test_GatekeeperTwoExploitVulnerability() public {
        address attacker = makeAddr("attacker");

        vm.startBroadcast(attacker);
        gateKeeperTwoAttacker = new GatekeeperTwoAttacker(
            address(gateKeeperTwo)
        );
        vm.stopBroadcast();

        assertEq(
            gateKeeperTwo.entrant(),
            attacker,
            "Attack unsuccessful - entrant not set"
        );
    }
}
