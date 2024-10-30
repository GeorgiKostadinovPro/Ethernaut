// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Telephone} from "../src/contracts/04_Telephone.sol";
import {TelephoneAttacker} from "../src/attackers/04_TelephoneAttacker.sol";

contract CoinFlipTest is Test {
    address private owner = makeAddr("owner");

    Telephone private telephone;
    TelephoneAttacker private telephoneAttacker;

    function setUp() public {
        vm.prank(owner);
        telephone = new Telephone();
        telephoneAttacker = new TelephoneAttacker(address(telephone));
    }

    function test_TelephoneExploitVulnerability() public {
        address attacker = makeAddr("attacker");

        vm.prank(attacker);
        telephoneAttacker.attack();

        assertEq(telephone.owner(), address(attacker));
    }
}
