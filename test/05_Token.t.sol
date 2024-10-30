// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {Token} from "../src/contracts/05_Token.sol";
import {TokenAttacker} from "../src/attackers/05_TokenAttacker.sol";

contract TokenTest is Test {
    address private owner = makeAddr("owner");
    Token private token;
    TokenAttacker private tokenAttacker;

    function setUp() public {
        vm.prank(owner);
        token = new Token(20);

        tokenAttacker = new TokenAttacker(address(token));
    }

    function test_TokenExploitVulnerability() public {
        address attacker = makeAddr("attacker");

        vm.prank(attacker);
        tokenAttacker.attack();

        assertEq(
            token.balanceOf(attacker),
            type(uint256).max,
            "Attacker should get much more tokens than there are"
        );
    }
}
