// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20Token.sol";

contract BusinessLogic {
    ERC20Token public token;
    mapping(address => uint256) public discounts;
    address public owner;
    address public unspentAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4; // Replace this with a proper unspent address

    constructor(address _tokenAddress) {
        token = ERC20Token(_tokenAddress);
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function rewardCustomerFromOwner(address customer,  uint256 tokensToGive) public onlyOwner {
        //uint256 amountPaid,
        // Business Logic for purchase
        // Transfer tokens to customer
        require(token.transferFrom(owner, customer, tokensToGive), "Transfer failed");

        // Calculate discounts
        if (tokensToGive >= 20) {
            discounts[customer] = 25;
        } else if (tokensToGive >= 10) {
            discounts[customer] = 10;
        }
    }

    function useDiscount(address customer) public onlyOwner {
        uint256 discountRate = discounts[customer];
        require(discountRate > 0, "No discount available");

        uint256 tokensToUse = (discountRate == 25) ? 20 : 10;

        // Transfer tokens to an unspent address
        require(token.transferFrom(customer, unspentAddress, tokensToUse), "Transfer failed");

        // Reset discount
        discounts[customer] = 0;
    }
}
