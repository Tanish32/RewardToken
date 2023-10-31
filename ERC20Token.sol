// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC20Token {
    string public name = "RewardToken";
    string public symbol = "RTK";
    uint8 public decimals = 18;
    uint256 public totalSupply = 1000000 * 10 ** uint256(decimals);
    address public owner;
    address businessLogicContract;
    mapping(address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        balanceOf[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function businessLogicAddress(address _businessLogicContract) external onlyOwner{
        businessLogicContract = _businessLogicContract;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require( _from == msg.sender || msg.sender == businessLogicContract,"Cannot use another person's funds");
        require(balanceOf[_from] >= _value);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}
