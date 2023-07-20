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
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public virtual returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, value);
        _transfer(form, to, value);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 requestedDecrease) public virtual returns (bool) {
        address owner = msg.sender;
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance < requestedDecrease) {
            revert FailedDecreaseAllowance(spender, currentAllowance - requestedDecrease);
        }

        unchecked {
            _approve(owner, spender, currentAllowance - requestedDecrease);
        }

        return true;
    }

    //private and internal functions

    function _transfer(address from, address to, uint256 value) internal {
        if (from == address(0)) {
            revert InvalidAddress(address(0));
        }
        if (to == address(0)) {
            revert InvalidAddress(address(0));
        }
        _update(from, to, value);
    }

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
