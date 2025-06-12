// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.8/automation/AutomationCompatible.sol";

contract PriceAlert is AutomationCompatibleInterface {
    // State variables
    address public owner;
    AggregatorV3Interface internal dataFeed;

    struct Alert {
        address user;
        uint256 targetPrice;
        bool active;
        bool triggered; // To ensure an alert is triggered only once
    }

    mapping(uint256 => Alert) public alerts;
    uint256 public alertCounter;

    event AlertSet(uint256 indexed alertId, address indexed user, uint256 targetPrice);
    event AlertTriggered(uint256 indexed alertId, address indexed user, uint256 currentPrice);

    /**
     * @notice Constructor initializes the contract with the price feed address.
     * @param _priceFeedAddress The address of the Chainlink Price Feed.
     */
    constructor(address _priceFeedAddress) {
        owner = msg.sender;
        dataFeed = AggregatorV3Interface(_priceFeedAddress);
    }

    /**
     * @notice Allows users to set a new price alert.
     * @param _targetPrice The target price for the alert.
     */
    function setAlert(uint256 _targetPrice) external {
        require(_targetPrice > 0, "Target price must be greater than zero");
        alertCounter++;
        alerts[alertCounter] = Alert({
            user: msg.sender,
            targetPrice: _targetPrice,
            active: true,
            triggered: false
        });
        emit AlertSet(alertCounter, msg.sender, _targetPrice);
    }

    /**
     * @notice Gets the latest price from the Chainlink Price Feed.
     * @return price The latest price.
     */
    function getLatestPrice() public view returns (int) {
        (, int price, , , ) = dataFeed.latestRoundData();
        return price;
    }

    /**
     * @notice Chainlink Automation compatible method to check if upkeep is needed.
     * @param /* checkData * / Bytes memory /* checkData */ // Not used in this example
     * @return upkeepNeeded True if upkeep is needed, false otherwise.
     * @return performData Bytes memory to be passed to performUpkeep.
     */
    function checkUpkeep(bytes calldata /* checkData */)
        external
        view
        override
        returns (bool upkeepNeeded, bytes memory performData)
    {
        upkeepNeeded = false;
        // Iterate through active alerts to find one that can be triggered
        // For simplicity, we check only one alert per upkeep. 
        // A more robust solution might involve checking multiple or managing a list of checkable alerts.
        for (uint256 i = 1; i <= alertCounter; i++) {
            if (alerts[i].active && !alerts[i].triggered) {
                int currentPrice = getLatestPrice();
                // Assuming targetPrice is in the same decimals as the price feed
                // And that price feed returns positive values
                if (currentPrice > 0 && uint256(currentPrice) >= alerts[i].targetPrice) {
                    upkeepNeeded = true;
                    performData = abi.encode(i); // Pass the alertId to performUpkeep
                    break; 
                }
            }
        }
        return (upkeepNeeded, performData);
    }

    /**
     * @notice Chainlink Automation compatible method to perform upkeep.
     * @param performData Bytes memory data passed from checkUpkeep (contains alertId).
     */
    function performUpkeep(bytes calldata performData) external override {
        uint256 alertId = abi.decode(performData, (uint256));
        Alert storage alertToTrigger = alerts[alertId];

        // Double check conditions before execution
        require(alertToTrigger.active, "Alert is not active");
        require(!alertToTrigger.triggered, "Alert already triggered");
        
        int currentPrice = getLatestPrice();
        require(currentPrice > 0 && uint256(currentPrice) >= alertToTrigger.targetPrice, "Target price not met");

        alertToTrigger.triggered = true;
        alertToTrigger.active = false; // Deactivate after triggering, or manage re-activation logic

        // Placeholder for notification or dummy payout
        // For example, emit an event
        emit AlertTriggered(alertId, alertToTrigger.user, uint256(currentPrice));

        // In a real DApp, you might integrate with a notification service or trigger a payout here.
    }

    /**
     * @notice Allows the owner to withdraw any ETH sent to the contract.
     */
    receive() external payable {}

    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        payable(owner).transfer(address(this).balance);
    }
}
