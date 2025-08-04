// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract SupplyChain is Ownable {
    bool public isActive;
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
    modifier onlyOwner() override {
        require(msg.sender == owner(), "Only owner can call this function");
        _;
    }
    modifier onlyConsumer() {
        require(isConsumer(msg.sender), "Only consumer can call this function");
        _;
    }
    modifier onlyProducer() {
        require(isProducer(msg.sender), "Only producer can call this function");
        _;
        }
    modifier onlyProcessor() {
        require(isProcessor(msg.sender), "Only processor can call this function");
        _;
    }
    modifier onlyRetailer() {
        require(isRetailer(msg.sender), "Only retailer can call this function");
        _;
    }
    modifier onlyLogistics() {
        require(isLogistics(msg.sender), "Only logistics can call this function");
        _;
    }
    modifier onlyDriver() {
        require(isDriver(msg.sender), "Only driver can call this function");
        _;
    }
    modifier onlyImporter() {
        require(isImporter(msg.sender), "Only importer can call this function");
        _;
    }
    modifier onlyDistributor() {
        require(isDistributor(msg.sender), "Only distributor can call this function");
        _;
    }
    modifier onlyWarehouse() {
        require(isWarehouse(msg.sender), "Only warehouse can call this function");
        _;
    }
    // Helper functions for modifiers
    function isConsumer(address _address) internal view returns (bool) {
        for (uint i = 0; i < consumers.length; i++) {
            if (consumers[i].walletAddress == _address) {
                return true;
            }
        }
        return false;
    }

    function isProducer(address _address) internal view returns (bool) {
        for (uint i = 0; i < producers.length; i++) {
            if (producers[i].producerAddress == _address) {
                return true;
            }
        }
        return false;
    }

    function isProcessor(address _address) internal view returns (bool) {
        for (uint i = 0; i < processors.length; i++) {
            if (processors[i].processorAddress == _address) {
                return true;
            }
        }
        return false;
    }

    function isRetailer(address _address) internal view returns (bool) {
        for (uint i = 0; i < retailers.length; i++) {
            if (retailers[i].retailerAddress == _address) {
                return true;
            }
        }
        return false;
    }

    function isLogistics(address _address) internal view returns (bool) {
        for (uint i = 0; i < logistics.length; i++) {
            if (logistics[i].logisticsAddress == _address) {
                return true;
            }
        }
        return false;
    }

    function isDriver(address _address) internal view returns (bool) {
        for (uint i = 0; i < drivers.length; i++) {
            if (drivers[i].driverAddress == _address) {
                return true;
            }
        }
        return false;
    }

    function isImporter(address _address) internal view returns (bool) {
        for (uint i = 0; i < importers.length; i++) {
            if (importers[i].importerAddress == _address) {
                return true;
            }
        }
        return false;
    }

    function isDistributor(address _address) internal view returns (bool) {
        for (uint i = 0; i < distributors.length; i++) {
            if (distributors[i].distributorAddress == _address) {
                return true;
            }
        }
        return false;
    }

    function isWarehouse(address _address) internal view returns (bool) {
        for (uint i = 0; i < warehouses.length; i++) {
            if (warehouses[i].warehouseAddress == _address) {
                return true;
            }
        }
        return false;
    }
    
    function isParticipantActive(address participant) internal view returns (bool) {
        // Implementation will check if the participant is active in any role
        return true; // Placeholder implementation
    }

    function isProductAvailable(address product) internal view returns (bool) {
        // Implementation will check if the product is available
        return true; // Placeholder implementation
    }

    function isProductDelivered(address product) internal view returns (bool) {
        // Implementation will check if the product is delivered
        return true; // Placeholder implementation
    }

    function isProductSold(address product) internal view returns (bool) {
        // Implementation will check if the product is sold
        return true; // Placeholder implementation
    }

    modifier onlyActive() {
        require(isParticipantActive(msg.sender), "Only active participants can call this function");
        _;
    }

    modifier onlyInactive() {
        require(!isParticipantActive(msg.sender), "Only inactive participants can call this function");
        _;
    }

    modifier onlyAvailable() {
        require(isProductAvailable(msg.sender), "Only available products can call this function");
        _;
    }

    modifier onlyNotAvailable() {
        require(!isProductAvailable(msg.sender), "Only unavailable products can call this function");
        _;
    }

    modifier onlyDelivered() {
        require(isProductDelivered(msg.sender), "Only delivered products can call this function");
        _;
    }

    modifier onlyNotDelivered() {
        require(!isProductDelivered(msg.sender), "Only undelivered products can call this function");
        _;
    }

    modifier onlySold() {
        require(isProductSold(msg.sender), "Only sold products can call this function");
        _;
    }

    modifier onlyNotSold() {
        require(!isProductSold(msg.sender), "Only unsold products can call this function");
        _;
    }





    modifier onlyInTransit() {
        require(currentState == SupplyChainState.InTransit, "Only in transit state can call this function");
        _;
    }
    modifier onlyProcessed() {
        require(currentState == SupplyChainState.Processed, "Only processed state can call this function");
        _;
    }
    modifier onlyBeingProcessed() {
        require(currentState == SupplyChainState.IsBeingProcessed, "Only being processed state can call this function");
        _;
    }
}