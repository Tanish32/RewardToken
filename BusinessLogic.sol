// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20Token.sol";  // Import the ERC20Token contract

contract BusinessLogic {
    ERC20Token public tokenContract;
    address public owner;
    address public unspentAddress;  // Burn or store address
    mapping(address => bool) public purchaseValidated;
    mapping(address => uint256) public discountRate;  // Maps customer address to discount rate

    event TokensAwarded(address indexed customer, uint256 amount);
    event DiscountUsed(address indexed customer, uint256 discount);
    event ProductPurchased(address indexed customer, uint256 finalPrice);

    constructor(address _tokenContract) {
        tokenContract = ERC20Token(_tokenContract);
        owner = msg.sender;
        unspentAddress = owner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // Owner validates the purchase
    function validatePurchase(address customer, uint256 amount) internal {
        // require(!purchaseValidated[customer], "Purchase already validated");
        if(purchaseValidated[customer] = true){
            require(tokenContract.transferFrom(owner, customer, amount), "Token transfer failed");
            emit TokensAwarded(customer, amount);
            purchaseValidated[customer] = false;
        }
        
    }

    // To be called when a customer purchases a product
 function purchaseProduct() external payable {
        // require(purchaseValidated[msg.sender], "Purchase not validated");

        uint256 originalPrice = 1 ether;  // Assuming 1 product costs 1 Ether
        uint256 discount = discountRate[msg.sender];
        uint256 finalPrice = originalPrice * (100 - discount) / 100;

        require(msg.value >= finalPrice, "Insufficient funds sent");

        // Transfer extra Ether back to the customer
        if (msg.value > finalPrice) {
            payable(msg.sender).transfer(msg.value - finalPrice);
        }

        // Set validation as the purchase has been completed
        purchaseValidated[msg.sender] = true;
        emit ProductPurchased(msg.sender, finalPrice);
        
        //rewarding the customer with 10 tokens
        validatePurchase(msg.sender, 10);
    }

    // To be called when a customer wants to use tokens for a discount . i.e to be called before purcaseProduct
    function useDiscount() external {
        uint256 tokenCount = tokenContract.balanceOf(msg.sender);
        uint256 discount = 0;

        // Calculate discount based on token count
        if (tokenCount >= 20) {
            discount = 25;
        } else if (tokenCount >= 10) {
            discount = 10;
        }

        // Update discount rate
        discountRate[msg.sender] = discount;

        // Deduct tokens from customer and send to unspentAddress
        require(tokenContract.transferFrom(msg.sender, unspentAddress, tokenCount), "Token transfer failed");

        emit DiscountUsed(msg.sender, discount);
    }
}
