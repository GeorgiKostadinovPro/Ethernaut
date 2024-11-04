// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {MagicNum} from "../src/contracts/18_MagicNum.sol";

contract MagicNumTest is Test {
    MagicNum private magicNum;

    function setUp() public {
        magicNum = new MagicNum();
    }

    function test_MagicNumExploitVulnerability() public {
        // The bytecode for the solver contract that returns the number 42
        bytes
            memory bytecode = hex"600a600c600039600a6000f3602a60005260206000f3";

        //  602a        v: push1 0x2a (value is 0x2a)
        //  6000        p: push1 0x00 (memory slot is 0x00)
        //  52          mstore
        //  6020        s: push1 0x20 (value is 32 bytes in size)
        //  6000        p: push1 0x00 (value was stored in slot 0x00)
        //  f3          return

        address solverAddress;

        // deploy the contract using low level assembly
        assembly {
            solverAddress := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        magicNum.setSolver(solverAddress);

        assertEq(magicNum.solver(), solverAddress);

        // Call the whatIsTheMeaningOfLife function to retrieve the answer
        (bool success, bytes memory returnData) = solverAddress.call(
            abi.encodeWithSignature("whatIsTheMeaningOfLife()")
        );

        uint256 answer;

        assembly {
            // here we add 0x20 in order to skip the first 32 bytes of returnData
            // we load only the actual value which is stored right after the length of 32 bytes
            answer := mload(add(returnData, 0x20))
        }

        assertEq(answer, 42, "Solver did not return the correct answer");
    }
}
