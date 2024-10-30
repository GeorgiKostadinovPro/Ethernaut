// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Elevator} from "../src/contracts/11_Elevator.sol";
import {ElevatorAttacker} from "../src/attackers/11_ElevatorAttacker.sol";

contract ElevatorTest is Test {
    Elevator private elevator;
    ElevatorAttacker private elevatorAttacker;

    function setUp() public {
        elevator = new Elevator();
        elevatorAttacker = new ElevatorAttacker();
    }

    function test_ElevatorExploitVulnerability() public {
        vm.prank(address(elevatorAttacker));
        elevator.goTo(1);

        assertTrue(elevator.top());
    }
}
