// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "./IERC20.sol";

contract ERC20 is IERC20 {
    uint256 private totalSupply;
    mapping(address owner => uint256 amount) private balanceOf;
    mapping(address owner => mapping(address spender => uint256 amount)) private allowance;
    string private name;
    string private symbol;
    uint8 public decimals = 18;

    constructor(string memory _name, string memory _symbol, uint256 _totalSupply) {
        balanceOf[msg.sender] += _totalSupply;
        totalSupply = _totalSupply;
        _mint(msg.sender, _totalSupply);
    }
}
