// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20Token.sol"; // Import the ERC20Token contract

contract BusinessLogic {
    ERC20Token public tokenContract;
    address public owner;
    address public unspentAddress; // An example burn address
    string public symboll;
    mapping(address => bool) public purchaseValidated;

    event TokensAwarded(address indexed customer, uint256 amount);
    event DiscountUsed(address indexed customer, uint256 discount);

    constructor(address _tokenContract) {
        tokenContract = ERC20Token(_tokenContract);
        owner = msg.sender;
        unspentAddress = owner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function  test() public view returns(uint256){
        return tokenContract.balanceOf(address(msg.sender));
    }
    // function test1() public{
    //     tokenContract.approve(msg.sender, 10000000000000000);
    // }
    function test2(address _to, uint256 _value) public payable {
        tokenContract.transferFrom(msg.sender, _to, _value);
        emit TokensAwarded(_to, _value);
    }
    function validatePurchase(address customer, uint256 amount) external payable onlyOwner {
        //, uint256 amount
        require(!purchaseValidated[customer], "Purchase already validated");
        purchaseValidated[customer] = true;
        // Award tokens after purchase validation
        require(tokenContract.transferFrom(msg.sender,customer, amount), "Token transfer failed");
        // emit TokensAwarded(customer, amount);
    }

    function useDiscount(address customer, uint256 tokenAmount) external {
        require(purchaseValidated[customer], "Purchase not validated");
        require(tokenContract.balanceOf(customer) >= tokenAmount, "Insufficient tokens");

        // Calculate discount based on token amount
        uint256 discount = 0;
        if (tokenAmount == 10) {
            discount = 10;
        } else if (tokenAmount == 20) {
            discount = 25;
        } // Add more conditions here

        require(tokenContract.transferFrom(customer, unspentAddress, tokenAmount), "Token deduction from customer failed");
        emit DiscountUsed(customer, discount);
    }
}
