// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "./IERC20.sol";

contract ERC20 is IERC20 {
    uint256 private totalSupply;
    mapping(address owner => uint256 amount) private balances;
    mapping(address owner => mapping(address spender => uint256 amount)) private allowance;
    string private name;
    string private symbol;
    uint8 public decimals = 18;

    constructor(string memory _name, string memory _symbol, uint256 _totalSupply) {
        balanceOf[msg.sender] += _totalSupply;
        totalSupply = _totalSupply;
        _mint(msg.sender, _totalSupply);
    }

    //external functions
    function approve(address spender, uint256 value) public virtual returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, value);
        return true;
    }

    //private and internal functions

    //public view functions
    function name() public view virtual returns (string memory) {
        return name;
    }

    function symbol() public view virtual returns (string memory) {
        return symbol;
    }

    function totalSupply() public view virtual returns (uint256) {
        return totalSupply;
    }

    function decimals() public view virtual returns (uint256) {
        return decimals;
    }

    function balanceOf(address account) public view virtual returns (uint256) {
        return balances[account];
    }

    function allowance(address owner, address spender) public view virtual returns (uint256) {
        return allowance[owner][spender];
    }
}
