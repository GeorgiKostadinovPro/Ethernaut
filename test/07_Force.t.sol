// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Force} from "../src/contracts/07_Force.sol";
import {ForceAttacker} from "../src/attackers/07_ForceAttacker.sol";

contract ForceTest is Test {
    address private owner = makeAddr("owner");
    Force private force;
    ForceAttacker private forceAttacker;

    function setUp() public {
        force = new Force();

        vm.prank(owner);
        deal(owner, 10 ether);
        forceAttacker = new ForceAttacker(address(force));
    }

    function test_ForceExploitVulnerability() public {
        vm.prank(owner);
        (bool success, ) = address(forceAttacker).call{value: 10 ether}("");

        if (success) {
            forceAttacker.attack();
        }

        assertEq(address(forceAttacker).balance, 0);
        assertEq(address(force).balance, 10 ether);
    }
}
