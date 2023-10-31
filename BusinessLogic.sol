// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20Token.sol";  // Import the ERC20Token contract

contract BusinessLogic {
    ERC20Token public tokenContract;
    address public owner;
    address public unspentAddress  = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148;  // Burn or store address
    mapping(address => bool) internal purchaseValidated;
    mapping(address => uint256) public discountRate;  // Maps customer address to discount rate
    mapping(address => bool)    public reg;

    event TokensAwarded(address indexed customer, uint256 amount);
    event DiscountUsed(address indexed customer, uint256 discount);
    event ProductPurchased(address indexed customer, uint256 finalPrice);

    constructor(address _tokenContract) {
        tokenContract = ERC20Token(_tokenContract);
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // Owner validates the purchase
    function validatePurchase(address customer, uint256 amount) internal {
        // require(!purchaseValidated[customer], "Purchase already validated");
        if(purchaseValidated[customer] == true){
            require(tokenContract.transferFrom(owner, customer, amount), "Token transfer failed");
            emit TokensAwarded(customer, amount);
            purchaseValidated[customer] = false;
        }
        
    }

    // To be called when a customer purchases a product
 function purchaseProduct() external payable {
        require(reg[msg.sender]==true,"Caller not registered");
        uint256 originalPrice = 1 ether;  // Assuming 1 product costs 1 Ether
        uint256 discount = discountRate[msg.sender];
        uint256 finalPrice = originalPrice * (100 - discount) / 100;

        //Validiating payment is legitimate
        require(msg.value >= finalPrice, "Transaction not validate : Insufficient funds sent");

        // Transfer extra Ether back to the customer
        if (msg.value > finalPrice) {
            payable(msg.sender).transfer(msg.value - finalPrice);
        }

        // Set validation as the purchase has been completed
        purchaseValidated[msg.sender] = true;
        emit ProductPurchased(msg.sender, finalPrice);
        
        //rewarding the customer with 10 tokens
        validatePurchase(msg.sender, 10);
        discountRate[msg.sender] = 0;
    }

    function register() external {
        reg[msg.sender] = true;
    }

    // To be called when a customer wants to use tokens for a discount . i.e to be called before purcaseProduct
    function useDiscount(uint256 tokensToUse) external {
        require(reg[msg.sender]==true,"Caller not registered");
        uint256 tokenCount = tokenContract.balanceOf(msg.sender);
        require(tokenCount>=tokensToUse,"Not enough reward tokens!");
        // Calculate discount based on token count
        if(tokensToUse>100){
            tokensToUse=100;
        }
        uint256 discount = tokensToUse;
        // Update discount rate
        discountRate[msg.sender] = discount;

        // Deduct tokens from customer and send to unspentAddress
        require(tokenContract.transferFrom(msg.sender, unspentAddress, tokensToUse), "Token transfer failed");
        emit DiscountUsed(msg.sender, discount);
    }
}
