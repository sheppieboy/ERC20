// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./IERC20.sol";

contract ERC20 is IERC20 {
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals = 18;

    mapping(address owner => uint256 amount) private _balances;
    mapping(address owner => mapping(address spender => uint256 amount)) private _allowance;

    constructor(string memory name_, string memory symbol_, uint256 totalSupply_) {
        _name = name_;
        _symbol = symbol_;
        balanceOf[msg.sender] += totalSupply_;
        _totalSupply = totalSupply_;
        _mint(msg.sender, totalSupply_);
    }

    //external functions
    function approve(address spender, uint256 value) public virtual returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, value);
        return true;
    }

    function transfer(address to, uint256 value) public virtual returns (bool) {
        address owner = msg.sender;
        _transfer(owner, to, value);
    }

    //private and internal functions

    //public view functions
    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function totalSupply() public view virtual returns (uint256) {
        return _totalSupply;
    }

    function decimals() public view virtual returns (uint256) {
        return _decimals;
    }

    function balanceOf(address account) public view virtual returns (uint256) {
        return _balances[account];
    }

    function allowance(address owner, address spender) public view virtual returns (uint256) {
        return _allowance[owner][spender];
    }
}
