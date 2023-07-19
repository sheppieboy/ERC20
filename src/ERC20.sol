// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address recipient) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function transferFrom(address sender, address recipient, uint256 amount) external view returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract ERC20 is IERC20 {
    uint256 public totalSupply;
    mapping(address owner => uint256 amount) public balanceOf;
    mapping(address owner => mapping(address spender => uint256 amount)) public allowance;
    string public name = "ERCCCCCCC20000";
    string public symbol = "ERC20";
    uint8 public decimals = 18;
}
