// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;

contract TestFunctions {
    mapping(address => bool) whitelist;

    function setWhitelist(address[] memory addresses) public {
        for (uint256 i = 0; i < addresses.length; i++) {
            whitelist[addresses[i]] = true;
        }
    }

    function isWhitelisted(address addr) public view returns (bool) {
        return whitelist[addr];
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

    function mod(uint256 a, uint256 b) public pure returns (uint256) {
        b = b == 0 ? 1 : b;
        return a % b;
    }
}

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
