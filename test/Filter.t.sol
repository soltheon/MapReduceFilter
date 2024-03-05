// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

import {Test, console, stdError} from "forge-std/Test.sol";
import {Map, Reduce, Filter} from "../src/MapReduceFilter.sol";
import {Common} from "../src/Common.sol";
import {Helper, TestFunctions} from "./Utils.sol";

contract FilterTest is Test, TestFunctions, Common {
    using Filter for uint256[];
    using Filter for address[];

    Helper helper;

    function setUp() public {
        helper = new Helper();
    }

    function test_filter_uints() public {
        uint256[] memory input = new uint256[](5);
        input[0] = 1;
        input[1] = 2;
        input[2] = 3;
        input[3] = 4;
        input[4] = 5;

        uint256[] memory expected = new uint256[](2);
        expected[0] = 2;
        expected[1] = 4;

        uint256[] memory result = input.filter(Common.isEven);
        assertEq(result.length, expected.length);

        for (uint256 i = 0; i < expected.length; i++) {
            assertEq(result[i], expected[i]);
        }
    }

    function test_filter_addresses() public {
        address[] memory input = new address[](5);
        input[0] = address(0x1);
        input[1] = address(0x2);
        input[2] = address(0x3);
        input[3] = address(0x4);
        input[4] = address(0x5);

        address[] memory expected = new address[](2);
        expected[0] = address(0x2);
        expected[1] = address(0x5);

        TestFunctions.setWhitelist(expected);

        address[] memory result = input.filter(isWhitelisted);
        assertEq(result.length, expected.length);

        for (uint256 i = 0; i < expected.length; i++) {
            assertEq(result[i], expected[i]);
        }
    }

    function test_fuzz_filterWhitelist(address[] memory addresses) public {
        TestFunctions.setWhitelist(addresses);
        address[] memory res = addresses.filter(TestFunctions.isWhitelisted);
        assertEq(res.length, addresses.length);

        for (uint256 i = 0; i < res.length; i++) {
            assertEq(res[i], addresses[i]);
        }
    }

    function test_fuzz_filterIsEven(uint256[] memory uints) public {
        uint256[] memory res = uints.filter(Common.isEven);
        uint256[] memory check = helper.returnEven(uints);

        assertEq(res.length, check.length);
        for (uint256 i = 0; i < res.length; i++) {
            assertEq(res[i], check[i]);
        }
    }

    function test_fuzz_doesntMutate(uint256[] calldata uints) public {
        uint256[] memory copy = new uint256[](uints.length);

        for (uint256 i = 0; i < uints.length; i++) {
            copy[i] = uints[i];
        }

        uint256 arrayLen = uints.length;
        uints.filter(Common.isEven);
        assertEq(uints.length, arrayLen);
        assertEq(copy.length, arrayLen);

        for (uint256 i = 0; i < uints.length; i++) {
            assertEq(copy[i], uints[i]);
        }
    }

    function test_filter_empty_array() public {
        uint256[] memory input = new uint256[](0);
        uint256[] memory res = input.filter(Common.isEven);
        assertEq(input.length, 0);
        assertEq(res.length, 0);
    }
}
