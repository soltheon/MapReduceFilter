# Map, Reduce, Filter Library
A useful library for working with arrays. I mostly use them for convenience when writing tests and keeping code readable. This library provides three functions for manipulating arrays in Solidity: map(), reduce(), and filter().

```solidity
import {Map, Reduce, Filter} from "soltheon/src/MapReduceFilter.sol";

contract Example {
    using Map for uint256[];
    using Reduce for uint256[];
    using Filter for uint256[];
    using Filter for address[];
}
```

## Map
The map() function applies a given callback function to each element of an array and returns a new array with the results. 


```solidity
function square(uint256 x) pure returns (uint256) {
    return x * x;
}

uint256[] memory arr = [1, 2, 3, 4, 5];
uint256[] memory squared = arr.map(square);
// squared is now [1, 4, 9, 16, 25]
```

`supported types: uint256[]`

## Reduce
The reduce() function applies a given callback function to each element of an array, accumulating a single result.

```solidity
function sum(uint256 a, uint256 b) pure returns (uint256) {
    return a + b;
}

uint256[] memory arr = [1, 2, 3, 4, 5];
uint256 total = arr.reduce(sum);
// total is now 15
```
`supported types: uint256[]`

## Filter
The filter() function applies a given callback function to each element of an array and returns a new array containing only the elements for which the callback returns true.
```solidity
function isEven(uint256 x) pure returns (bool) {
    return x % 2 == 0;
}

uint256[] memory arr = [1, 2, 3, 4, 5];
uint256[] memory even = arr.filter(isEven);
// even is now [2, 4]
```

The filter() function also works with arrays of address types.

```solidity
function isContract(address a) view returns (bool) {
    return a.code.length > 0;
}


address[] memory addresses = [address(this), address(0x123), address(0x456)];
address[] memory contractAddresses = addresses.filter(isContract);
// only the contracts remain in the list
```
`supported types: uint256[], address[]`


## Test

```shell
$ forge test
```

## Security

The code is tested but not audited. Use it at your own risk.

## Contributing

Contributions to the library are welcome. Please submit pull requests if you want to add more uint sizes or any other desired types.

## License

This project is licensed under the GNU General Public License v3.0 or later (GPL-3.0-or-later).

For more details visit [GNU General Public License v3.0 or later](https://www.gnu.org/licenses/gpl-3.0.en.html).
