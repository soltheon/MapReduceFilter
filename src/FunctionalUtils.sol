// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

library FunctionalUtils {
    function map(uint256[] memory self, function(uint256) pure returns (uint256) callback)
        internal
        pure
        returns (uint256[] memory)
    {
        uint256[] memory result = new uint256[](self.length);

        for (uint256 i = 0; i < self.length; i++) {
            result[i] = callback(self[i]);
        }

        return result;
    }

    function reduce(uint256[] memory self, function(uint256, uint256) pure returns (uint256) callback)
        internal
        pure
        returns (uint256 result)
    {
        if (self.length > 0) {
            result = self[0];

            for (uint256 i = 1; i < self.length; i++) {
                result = callback(result, self[i]);
            }
        }
    }

    function filter(uint256[] memory self, function(uint256) pure returns (bool) callback)
        internal
        pure
        returns (uint256[] memory)
    {
        uint256[] memory result = new uint256[](self.length);
        uint256 resultIndex = 0;

        for (uint256 i = 0; i < self.length; i++) {
            if (callback(self[i])) {
                result[resultIndex] = self[i];
                resultIndex++;
            }
        }

        assembly {
            mstore(result, resultIndex)
        }

        return result;
    }

    function sum(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }
}
