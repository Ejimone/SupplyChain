// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/*
A supply chain is the entire network of individuals, organizations, resources, activities, and technology involved in the creation and sale of a product. It's the journey from the very first raw material to the final product in a customer's hands.
 */

contract SupplyChain {
    struct Producer {
        string name;
        string location;
        uint256 id;
        bool isActive;
        Product[] products;
        uint256 totalProduced;
        uint256 totalSold;
        uint256 totalRevenue;
        address payable producerAddress;
    }
    struct Product {
        string name;
        uint256 id;
        uint256 producerId;
        uint256 price;
        bool isAvailable;
    }
    struct Consumer {
        string name;
        string location;
        uint256 id;
        bool isActive;
        string[] purchasedProducts;
        uint256 totalSpent;
        uint256 walletBalance;
        address payable walletAddress;
    }
    struct Processor {
        string name;
        string location;
        uint256 id;
        bool isActive;
        Product[] products;
        uint256 totalProcessed;
        uint256 totalRevenue;
        uint256 processingFee;
        address payable processorAddress;
        bool isGoodForSale;
    }

    struct Retailer {
        string name;
        string location;
        uint256 id;
        bool isActive;
        Product[] products;
        uint256 totalSold;
        uint256 totalRevenue;
        uint256 retailFee;
        uint256 productPrice;
        address payable retailerAddress;
    }
}