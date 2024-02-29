// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console, stdError} from "forge-std/Test.sol";
import {FunctionalUtils} from "../src/FunctionalUtils.sol";

contract Helper {
    function sumUints(uint256[] memory uints) public pure returns (uint256 sum) {
        for (uint256 i = 0; i < uints.length; i++) {
            sum += uints[i];
        }
    }

    function addOne(uint256[] calldata a) public pure returns (uint256[] memory b) {
        b = new uint256[](a.length);
        for (uint256 i = 0; i < a.length; i++) {
            b[i] = a[i] + 1;
        }
    }

    function returnEven(uint256[] calldata a) public pure returns (uint256[] memory b) {
        b = new uint256[](a.length);

        uint256 bLen;
        for (uint256 i = 0; i < a.length; i++) {
            if (a[i] % 2 == 0) {
                b[bLen++] = a[i];
            }
        }

        // resize array
        assembly {
            mstore(b, bLen)
        }
    }
}

contract FunctionalUtilsTest is Test {
    using FunctionalUtils for *;

    Helper helper;

    function setUp() public {
        helper = new Helper();
    }

    function test_fuzz_reduceUintsSum(uint256[] memory uints) public {
        try helper.sumUints(uints) returns (uint256 val) {
            assertEq(uints.reduce(FunctionalUtils.sum), val);
        } catch (bytes memory) {
            vm.expectRevert(stdError.arithmeticError);
            uints.reduce(FunctionalUtils.sum);
        }
    }


    function test_fuzz_mapAddOne(uint256[] memory uints) public {
        uint256[] memory a = uints.map(subOneIfMax);
        assertEq(a.length, uints.length);

        uint256[] memory res = a.map(addOne);
        assertEq(res.length, a.length);

        uint256[] memory check = helper.addOne(a);
        assertEq(check.length, a.length);

        for (uint256 i = 0; i < res.length; i++) {
            assertEq(res[i], check[i]);
        }
    }

    function test_fuzz_filterIsEven(uint256[] memory uints) public {
        uint256[] memory res = uints.filter(isEven);
        uint256[] memory check = helper.returnEven(uints);

        assertEq(res.length, check.length);
        for (uint256 i = 0; i < res.length; i++) {
            assertEq(res[i], check[i]);
        }
    }

    function test_emptyArray() public {
        uint256[] memory a = new uint256[](0);
        assertEq(a.map(addOne), a);
        assertEq(a.reduce(FunctionalUtils.sum), 0);
    }

    function test_fuzz_doesntMutate(uint[] calldata uints) public {
        uint[] memory copy = new uint[](uints.length);
        for (uint i = 0; i < uints.length; i++) {
            copy[i] = uints[i];
        }

        uint arrayLen = uints.length;
        uint[] memory res = uints.map(subOneIfMax);
        uint[] memory res2 = uints.filter(isEven);
        uint res3 = uints.reduce(mod);
        assertEq(res.length, arrayLen);
        assertEq(uints.length, arrayLen);

        for (uint i = 0; i < uints.length; i++) {
            assertEq(copy[i], uints[i]);
        }
    }

    function isEven(uint256 a) public pure returns (bool) {
        return (a % 2 == 0);
    }

    function addOne(uint256 a) public pure returns (uint256) {
        return a + 1;
    }

    function subOneIfMax(uint256 a) public pure returns (uint256) {
        if (a == type(uint256).max) {
            return a - 1;
        }
        return a;
    }

    function mod(uint a, uint b) public pure returns (uint) {
        b = b == 0 ? 1 : b;
        return a % b;
    }
}
