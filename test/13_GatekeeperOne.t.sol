// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {GatekeeperOne} from "../src/contracts/13_GatekeeperOne.sol";
import {GatekeeperOneAttacker} from "../src/attackers/13_GatekeeperOneAttacker.sol";

contract GatekeeperOneTest is Test {
    GatekeeperOne private gateKeeperOne;
    GatekeeperOneAttacker private gateKeeperOneAttacker;

    function setUp() public {
        gateKeeperOne = new GatekeeperOne();
        gateKeeperOneAttacker = new GatekeeperOneAttacker(
            address(gateKeeperOne)
        );
    }

    function test_GatekeeperOneExploitVulnerability() public {
        address attacker = makeAddr("attacker");

        vm.startBroadcast(attacker);
        gateKeeperOneAttacker.attack();
        vm.stopBroadcast();

        assertEq(
            gateKeeperOne.entrant(),
            attacker,
            "Attack unsuccessful - entrant not set"
        );
    }
}
