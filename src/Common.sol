// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;

contract Common {
    function isEven(uint256 a) public pure returns (bool) {
        return (a % 2 == 0);
    }

    function sum(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function square(uint256 a) internal pure returns (uint256) {
        return a * a;
    }
}
