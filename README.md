# RewardToken & BusinessLogic Contracts

## Overview

This project consists of two Solidity contracts:

1. **ERC20Token**: Implements the ERC-20 standard token with a few additional features.
2. **BusinessLogic**: Executes business logic, such as customer registration, product purchasing, and discount application.

These contracts are developed using Solidity version 0.8.0 and are suitable for deployment on any Ethereum-compatible blockchain. The project is built and tested using the Remix web IDE.

## Contracts

### ERC20Token

This contract serves as the token used within the ecosystem. It includes:

- Standard ERC-20 functions (`transferFrom`).
- Custom permissions (`onlyOwner`).
- Interface to set a business logic contract (`businessLogicAddress`).

#### Key Functions:

- `transferFrom`: Transfers tokens from one account to another. It also ensures that only the sender or the business logic contract can execute the transfer.
  
### BusinessLogic

This contract handles:

- User registration (`register`).
- Product purchasing (`purchaseProduct`).
- Discount management (`useDiscount`).

#### Key Functions:

- `validatePurchase`: Internal function to validate purchase and reward customer.
- `purchaseProduct`: Facilitates the product purchasing mechanism.
- `useDiscount`: Applies discount based on the tokens owned by the customer.

## Setup

### Requirements

- Remix Web IDE
- MetaMask or another Web3 provider
- Ether for testing

### Installation

1. Open Remix IDE and create new Solidity files for both contracts.
2. Paste the contract codes.
3. Compile both contracts using the Remix IDE.
4. Deploy `ERC20Token` first, then `BusinessLogic`, providing the `ERC20Token`'s address as a constructor argument.

## Usage

1. Register as a customer using the `register` function.
2. Use the `useDiscount` function to get a discount on your next purchase.
3. Use the `purchaseProduct` function to buy a product.

## Events

- `TokensAwarded`: Emitted when tokens are awarded to a customer.
- `DiscountUsed`: Emitted when a customer uses their tokens for a discount.
- `ProductPurchased`: Emitted when a product is purchased.

## Security

The contracts use the `onlyOwner` modifier to restrict access to critical functions.

## License

This project is licensed under the MIT License.
  
**Note**: Please thoroughly test and review the contracts before using them in production.
