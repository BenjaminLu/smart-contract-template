# Smart Contract Template

1. [ERC20](https://github.com/ethereum/eips/issues/20) - A general token contract work with ICOs contract.
P.S. [DAICO](https://github.com/petros789/daico)
2. [ERC223](https://github.com/ethereum/EIPs/issues/223) - Avoid ERC20 token transferred to a contract that is not implemented any withdraw function. When a tokenFallback function doesn't be implemented but there is a working fallback function. That may cause a false positive result.
3. [EIP165](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md) - Standard Interface Detection via
```
supportsInterface(bytes4 interfaceID) external view returns (bool)
```
4. [EIP820](https://github.com/ethereum/EIPs/blob/ea5b7b32fe7f959bb79c04731d62725e7b0a50df/EIPS/eip-820.md) & [ERC777]() - Rescue ERC223 with Metadata Registry
5. [ERC865](https://github.com/ethereum/EIPs/issues/865) - Pay transfers in tokens instead of gas, in one transaction.
6. [ERC721](https://github.com/ethereum/eips/issues/721), [ERC841](https://github.com/ethereum/EIPs/pull/841) - Non-fungible token.
7. [ERC821](https://github.com/ethereum/EIPs/issues/821) - Distinguishable Assets Registry