// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Shop} from "../src/contracts/21_Shop.sol";
import {ShopAttacker} from "../src/attackers/21_ShopAttacker.sol";

contract DenialTest is Test {
    address private owner = makeAddr("owner");
    Shop private shop;
    ShopAttacker private shopAttacker;

    function setUp() public {
        shop = new Shop();
        shopAttacker = new ShopAttacker(address(shop));
    }

    function test_ShopExploitVulnerability() public {
        shopAttacker.attack();

        assertEq(shop.price(), 0);
    }
}
