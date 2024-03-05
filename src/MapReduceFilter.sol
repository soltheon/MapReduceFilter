// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;

library Map {
    function map(uint256[] memory self, function(uint256) pure returns (uint256) callback)
        internal
        pure
        returns (uint256[] memory)
    {
        uint256[] memory result = new uint256[](self.length);

        uint256 len = self.length;
        for (uint256 i = 0; i < len;) {
            result[i] = callback(self[i]);
            unchecked {
                i++;
            }
        }

        return result;
    }
}

library Reduce {
    function reduce(uint256[] memory self, function(uint256, uint256) pure returns (uint256) callback)
        internal
        pure
        returns (uint256 result)
    {
        uint256 len = self.length;

        if (len > 0) {
            result = self[0];

            for (uint256 i = 1; i < len;) {
                result = callback(result, self[i]);
                unchecked {
                    i++;
                }
            }
        }
    }
}

library Filter {
    function filter(uint256[] memory self, function(uint256) pure returns (bool) callback)
        internal
        pure
        returns (uint256[] memory)
    {
        uint256 len = self.length;
        uint256[] memory result = new uint256[](len);
        uint256 resultIndex = 0;

        for (uint256 i = 0; i < len;) {
            if (callback(self[i])) {
                result[resultIndex] = self[i];
                resultIndex++;
            }
            unchecked {
                i++;
            }
        }

        assembly {
            mstore(result, resultIndex)
        }

        return result;
    }

    function filter(address[] memory self, function(address) pure returns (bool) callback)
        internal
        pure
        returns (address[] memory)
    {
        uint256 len = self.length;
        address[] memory result = new address[](len);
        uint256 resultIndex = 0;

        for (uint256 i = 0; i < len;) {
            if (callback(self[i])) {
                result[resultIndex] = self[i];
                resultIndex++;
            }
            unchecked {
                i++;
            }
        }

        assembly {
            mstore(result, resultIndex)
        }

        return result;
    }

    function filter(address[] memory self, function(address) view  returns (bool) callback)
        internal
        view
        returns (address[] memory)
    {
        uint256 len = self.length;
        address[] memory result = new address[](len);
        uint256 resultIndex = 0;

        for (uint256 i = 0; i < len;) {
            if (callback(self[i])) {
                result[resultIndex] = self[i];
                resultIndex++;
            }
            unchecked {
                i++;
            }
        }

        assembly {
            mstore(result, resultIndex)
        }

        return result;
    }
}
