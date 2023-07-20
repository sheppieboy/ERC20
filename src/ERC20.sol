// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

error InvalidAddress(address);
error InsufficientBalance();
error FailedDecreaseAllowance(address, uint256);
error InsufficientAllowance(address, uint256, uint256);

contract ERC20 {
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);

    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals = 18;

    mapping(address owner => uint256 amount) private _balances;
    mapping(address owner => mapping(address spender => uint256 amount)) private _allowance;

    constructor(string memory name_, string memory symbol_, uint256 totalSupply_) {
        _name = name_;
        _symbol = symbol_;
        _balances[msg.sender] += totalSupply_;
        _totalSupply = totalSupply_;
        //_mint(msg.sender, totalSupply_);
    }

    //external functions
    function approve(address spender, uint256 value) public virtual returns (bool) {
        address owner = msg.sender;
        return _approve(owner, spender, value);
    }

    function transfer(address to, uint256 value) public virtual returns (bool) {
        address owner = msg.sender;
        return _transfer(owner, to, value);
    }

    function transferFrom(address from, address to, uint256 value) public virtual returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, value);
        return _transfer(from, to, value);
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = msg.sender;
        return _approve(owner, spender, allowance(owner, spender) + addedValue);
    }

    function decreaseAllowance(address spender, uint256 requestedDecrease) public virtual returns (bool) {
        address owner = msg.sender;
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance < requestedDecrease) {
            revert FailedDecreaseAllowance(spender, currentAllowance - requestedDecrease);
        }

        unchecked {
            return _approve(owner, spender, currentAllowance - requestedDecrease);
        }
    }

    //private and internal functions

    function _transfer(address _from, address _to, uint256 _value) internal virtual returns (bool) {
        if (_from == address(0)) {
            revert InvalidAddress(address(0));
        }
        if (_to == address(0)) {
            revert InvalidAddress(address(0));
        }
        _update(_from, _to, _value);
        //transfer
        (bool success,) = _to.call{value: _value}("");
        require(success, "Failed to transfer ERC20 token");
        return success;
    }

    function _update(address from, address to, uint256 value) internal virtual {
        uint256 fromBalance = _balances[from];
        if (fromBalance < value) {
            revert InsufficientBalance();
        }
        _balances[from] -= value;
        _balances[to] += value;
        emit Transfer(from, to, value);
    }

    function _approve(address owner, address spender, uint256 value) internal virtual returns (bool) {
        if (owner == address(0)) {
            revert InvalidAddress(address(0));
        }
        if (spender == address(0)) {
            revert InvalidAddress(address(0));
        }
        _allowance[owner][spender] = value;
        emit Approval(owner, spender, value);
        return true;
    }

    function _spendAllowance(address owner, address spender, uint256 value) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance < value) {
            revert InsufficientAllowance(spender, currentAllowance, value);
        }
        unchecked {
            _approve(owner, spender, currentAllowance - value);
        }
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
