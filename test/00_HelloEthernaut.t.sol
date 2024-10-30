// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Instance} from "../src/contracts/00_HelloEthernaut.sol";

contract InstanceTest is Test {
    string private constant PASSWORD = "ethernaut0";
    Instance private instance;

    function setUp() public {
        instance = new Instance(PASSWORD);
    }

    function test_AuthenticateWithPassword() public {
        string memory passkey = instance.password();
        instance.authenticate(passkey);

        assertEq(PASSWORD, passkey);
        assertTrue(instance.getCleared());
    }
}
