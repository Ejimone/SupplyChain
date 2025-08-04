// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/*
A supply chain is the entire network of individuals, organizations, resources, activities, and technology involved in the creation and sale of a product. It's the journey from the very first raw material to the final product in a customer's hands.
 */
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract SupplyChain is Ownable {
    constructor() Ownable(msg.sender) {}
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

    struct Logistics {
        string name;
        string currentLocation;
        string destinationLocation;
        uint256 estimatedDeliveryTime; // in hours
        uint256 deliveryFee;
        uint256 itemId;
        bool isActive;
        Product[] products;
        uint256 totalDelivered;
        uint256 totalRevenue;
        address payable logisticsAddress;
        bool isDelivered;
        Product[] deliveredProducts;
        Producer[] producers;
        Consumer[] consumers;
        Processor[] processors;
        Retailer[] retailers;
        Driver[] drivers;
    }
    struct Driver {
        string name;
        string licenseNumber;
        uint256 id;
        bool isActive;
        Logistics[] logisticsTasks;
        uint256 totalDelivered;
        uint256 totalRevenue;
        address payable driverAddress;
    }
    struct Importer {
        string name;
        string location;
        uint256 id;
        bool isActive;
        Product[] products;
        uint256 totalImported;
        uint256 totalRevenue;
        address payable importerAddress;
    }

    struct Distributor {
        string name;
        string location;
        uint256 id;
        bool isActive;
        Product[] products;
        uint256 totalDistributed;
        uint256 totalRevenue;
        address payable distributorAddress;
    }

    struct Warehouse {
        string name;
        string location;
        uint256 id;
        bool isActive;
        Product[] products;
        uint256 totalStored;
        uint256 totalRevenue;
        address payable warehouseAddress;
    }


    struct Payment {
        address from;
        address to;
        uint256 amount;
        uint256 timestamp;
        string description;
    }
    struct PaymentHistory {
        Payment[] payments;
        uint256 totalPayments;
        uint256 totalAmount;
    }


}

