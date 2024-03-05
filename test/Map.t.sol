// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

import {Test, console, stdError} from "forge-std/Test.sol";
import {Map} from "../src/MapReduceFilter.sol";
import {Common} from "../src/Common.sol";
import {Helper, TestFunctions} from "./Utils.sol";

contract MapTest is Test, TestFunctions, Common {
    using Map for *;

    Helper helper;

    function setUp() public {
        helper = new Helper();
    }

    function test_map_square() public {
        uint256[] memory a = new uint256[](3);
        a[0] = 0;
        a[1] = 1;
        a[2] = 2;

        uint256[] memory res = a.map(Common.square);
        assertEq(res.length, a.length);
        assertEq(res[0], 0);
        assertEq(res[1], 1);
        assertEq(res[2], 4);
    }

    function test_fuzz_mapAddOne(uint256[] memory uints) public {
        // reduce uint if it is uint.max
        uint256[] memory a = uints.map(TestFunctions.subOneIfMax);
        assertEq(a.length, uints.length);

        uint256[] memory res = a.map(TestFunctions.addOne);
        assertEq(res.length, a.length);

        uint256[] memory check = helper.addOne(a);
        assertEq(check.length, a.length);

        for (uint256 i = 0; i < res.length; i++) {
            assertEq(res[i], check[i]);
        }
    }

    function test_map_emptyArray() public {
        uint256[] memory a = new uint256[](0);
        assertEq(a.map(TestFunctions.addOne), a);
    }
}
