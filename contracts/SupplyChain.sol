// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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

    Consumer[] public consumers;
    Processor[] public processors;
    Retailer[] public retailers;
    Logistics[] public logistics;
    Driver[] public drivers;
    Importer[] public importers;
    Distributor[] public distributors;
    Warehouse[] public warehouses;
    Producer[] public producers;





    /**

    there will be different states for the supply chain process, such as:
    intransit
    processed
    isbeingprocessed
    isAvailable
    isDelivered
    isSold
    isActive
    isGoodForSale
    isAvailableForSale
    isAvailableForPurchase
    isAvailableForDelivery
    isAvailableForProcessing
    isAvailableForRetail
    isAvailableForLogistics
    isAvailableForImport
     */

    enum SupplyChainState {
        InTransit,
        Processed,
        IsBeingProcessed,
        IsAvailable,
        IsDelivered,
        IsSold,
        IsActive,
        IsGoodForSale,
        IsAvailableForSale,
        IsAvailableForPurchase,
        IsAvailableForDelivery,
        IsAvailableForProcessing,
        IsAvailableForRetail,
        IsAvailableForLogistics,
        IsAvailableForImport
    }

    event SupplyChainEvent(
        string indexed eventType,
        uint256 indexed itemId,
        address indexed actor,
        string details,
        SupplyChainState state,
        uint256 timestamp
    );

    event ProductAdded(
        uint256 indexed productId,
        string productName,
        uint256 producerId,
        uint256 price,
        bool isAvailable
    );

    event ProductUpdated(
        uint256 indexed productId,
        string productName,
        uint256 producerId,
        uint256 price,
        bool isAvailable
    );
    event ProductDeleted(uint256 indexed productId, uint256 producerId);
    event ConsumerAdded(
        uint256 indexed consumerId,
        string consumerName,
        string location,
        address consumerAddress
    );
    event ConsumerUpdated(
        uint256 indexed consumerId,
        string consumerName,
        string location,
        address consumerAddress
    );
    event ConsumerDeleted(uint256 indexed consumerId);
    event ProducerAdded(
        uint256 indexed producerId,
        string producerName,
        string location,
        address producerAddress 
    );
    event ProducerUpdated(
        uint256 indexed producerId,
        string producerName,
        string location,
        address producerAddress
    );
    event ProducerDeleted(uint256 indexed producerId);

    event ProcessorAdded(
        uint256 indexed processorId,
        string processorName,
        string location,
        address processorAddress
    );
    event ProcessorUpdated(
        uint256 indexed processorId,
        string processorName,
        string location,
        address processorAddress
    );
    event ProcessorDeleted(uint256 indexed processorId);
    event RetailerAdded(
        uint256 indexed retailerId,
        string retailerName,
        string location,
        address retailerAddress
    );
    event RetailerUpdated(
        uint256 indexed retailerId,
        string retailerName,
        string location,
        address retailerAddress
    );
    event RetailerDeleted(uint256 indexed retailerId);
    event LogisticsAdded(
        uint256 indexed logisticsId,
        string logisticsName,
        string currentLocation,
        string destinationLocation,
        uint256 estimatedDeliveryTime,
        uint256 deliveryFee,
        address logisticsAddress
    );
    event LogisticsUpdated(
        uint256 indexed logisticsId,
        string logisticsName,
        string currentLocation,
        string destinationLocation,
        uint256 estimatedDeliveryTime,
        uint256 deliveryFee,
        address logisticsAddress
    );
    event LogisticsDeleted(uint256 indexed logisticsId);
    event DriverAdded(
        uint256 indexed driverId,
        string driverName,
        string licenseNumber,
        address driverAddress
    );
    event DriverUpdated(
        uint256 indexed driverId,
        string driverName,
        string licenseNumber,
        address driverAddress
    );
    event DriverDeleted(uint256 indexed driverId);
    event ImporterAdded(
        uint256 indexed importerId,
        string importerName,
        string location,
        address importerAddress
    );
    event ImporterUpdated(
        uint256 indexed importerId,
        string importerName,
        string location,
        address importerAddress
    );
    event ImporterDeleted(uint256 indexed importerId);
    event DistributorAdded(
        uint256 indexed distributorId,
        string distributorName,
        string location,
        address distributorAddress
    );
    event DistributorUpdated(
        uint256 indexed distributorId,
        string distributorName,
        string location,
        address distributorAddress
    );
    event DistributorDeleted(uint256 indexed distributorId);
    event WarehouseAdded(
        uint256 indexed warehouseId,
        string warehouseName,
        string location,
        address warehouseAddress
    );
    event WarehouseUpdated(
        uint256 indexed warehouseId,
        string warehouseName,
        string location,
        address warehouseAddress
    );
    event WarehouseDeleted(uint256 indexed warehouseId);

    SupplyChainState public currentState;
}