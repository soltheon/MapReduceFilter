// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

import {Test, console, stdError} from "forge-std/Test.sol";
import {Map, Reduce, Filter} from "../src/MapReduceFilter.sol";
import {Common} from "../src/Common.sol";
import {Helper, TestFunctions} from "./Utils.sol";

contract ReduceTest is Test, TestFunctions, Common {
    using Reduce for *;

    Helper helper;

    function setUp() public {
        helper = new Helper();
    }

    function test_fuzz_reduceUintsSum(uint256[] memory uints) public {
        try helper.sumUints(uints) returns (uint256 val) {
            assertEq(uints.reduce(Common.sum), val);
        } catch (bytes memory) {
            vm.expectRevert(stdError.arithmeticError);
            uints.reduce(Common.sum);
        }
    }

    function test_reduce_uintsSum() public {
        uint256[] memory uints = new uint256[](5);
        uints[0] = 1;
        uints[1] = 2;
        uints[2] = 3;
        uints[3] = 4;
        uints[4] = 5;

        assertEq(uints.reduce(Common.sum), 15);
    }

    function test_reduce_emptyArray() public {
        uint256[] memory a = new uint256[](0);
        assertEq(a.reduce(Common.sum), 0);
    }

    function test_fuzz_doesntMutate(uint256[] calldata uints) public {
        uint256[] memory copy = new uint256[](uints.length);

        for (uint256 i = 0; i < uints.length; i++) {
            copy[i] = uints[i];
        }

        uint256 arrayLen = uints.length;
        uints.reduce(TestFunctions.mod);
        assertEq(uints.length, arrayLen);
        assertEq(copy.length, arrayLen);

        for (uint256 i = 0; i < uints.length; i++) {
            assertEq(copy[i], uints[i]);
        }
    }
}
