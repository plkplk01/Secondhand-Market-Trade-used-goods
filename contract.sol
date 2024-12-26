// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PredictionMarket {
    // Struct to represent a prediction event
    struct PredictionEvent {
        string eventDescription;
        uint256 totalYesBets;
        uint256 totalNoBets;
        mapping(address => uint256) yesBets;
        mapping(address => uint256) noBets;
        bool isResolved;
        bool outcome; // true for Yes, false for No
        uint256 expirationTime;
    }

    // Mapping to store prediction events
    mapping(uint256 => PredictionEvent) public events;
    
    // Counter for event IDs
    uint256 public eventCounter;

    // Event to log when a new prediction event is created
    event EventCreated(
        uint256 indexed eventId, 
        string eventDescription, 
        uint256 expirationTime
    );

    // Event to log when a bet is placed
    event BetPlaced(
        uint256 indexed eventId, 
        address indexed bettor, 
        bool prediction, 
        uint256 amount
    );

    // Event to log when an event is resolved
    event EventResolved(
        uint256 indexed eventId, 
        bool outcome
    );

    // Create a new prediction event
    function createPredictionEvent(
        string memory _eventDescription, 
        uint256 _expirationTime
    ) public returns (uint256) {
        require(_expirationTime > block.timestamp, "Expiration time must be in the future");

        // Create new event
        eventCounter++;
        PredictionEvent storage newEvent = events[eventCounter];
        
        // Initialize event details
        newEvent.eventDescription = _eventDescription;
        newEvent.expirationTime = _expirationTime;
        newEvent.isResolved = false;

        // Emit event creation log
        emit EventCreated(eventCounter, _eventDescription, _expirationTime);

        return eventCounter;
    }

    // Place a bet on an event
    function placeBet(
        uint256 _eventId, 
        bool _prediction
    ) public payable {
        PredictionEvent storage predictionEvent = events[_eventId];
        
        // Check if event exists and is not resolved
        require(!predictionEvent.isResolved, "Event is already resolved");
        require(block.timestamp < predictionEvent.expirationTime, "Event has expired");
        require(msg.value > 0, "Bet amount must be greater than 0");

        // Place the bet
        if (_prediction) {
            predictionEvent.yesBets[msg.sender] += msg.value;
            predictionEvent.totalYesBets += msg.value;
        } else {
            predictionEvent.noBets[msg.sender] += msg.value;
            predictionEvent.totalNoBets += msg.value;
        }

        // Emit bet placement log
        emit BetPlaced(_eventId, msg.sender, _prediction, msg.value);
    }

    // Resolve the prediction event
    function resolveEvent(
        uint256 _eventId, 
        bool _outcome
    ) public {
        PredictionEvent storage predictionEvent = events[_eventId];
        
        // Check if event exists and is not already resolved
        require(!predictionEvent.isResolved, "Event is already resolved");
        require(block.timestamp >= predictionEvent.expirationTime, "Event cannot be resolved before expiration");

        // Set the outcome
        predictionEvent.isResolved = true;
        predictionEvent.outcome = _outcome;

        // Emit event resolution log
        emit EventResolved(_eventId, _outcome);
    }

    // Claim winnings for a resolved event
    function claimWinnings(uint256 _eventId) public {
        PredictionEvent storage predictionEvent = events[_eventId];
        
        // Check if event is resolved
        require(predictionEvent.isResolved, "Event is not resolved");

        uint256 userBet;
        uint256 totalWinningBets;
        uint256 totalLosingBets;

        // Determine user's bet and total bets based on the outcome
        if (predictionEvent.outcome) {
            userBet = predictionEvent.yesBets[msg.sender];
            totalWinningBets = predictionEvent.totalYesBets;
            totalLosingBets = predictionEvent.totalNoBets;
        } else {
            userBet = predictionEvent.noBets[msg.sender];
            totalWinningBets = predictionEvent.totalNoBets;
            totalLosingBets = predictionEvent.totalYesBets;
        }

        // Ensure user has a bet to claim
        require(userBet > 0, "No winnings to claim");

        // Calculate winnings
        uint256 winnings = userBet + (userBet * totalLosingBets / totalWinningBets);

        // Reset user's bet to prevent double claiming
        if (predictionEvent.outcome) {
            predictionEvent.yesBets[msg.sender] = 0;
        } else {
            predictionEvent.noBets[msg.sender] = 0;
        }

        // Transfer winnings
        payable(msg.sender).transfer(winnings);
    }

    // View function to get event details
    function getEventDetails(uint256 _eventId) public view returns (
        string memory description,
        uint256 totalYesBets,
        uint256 totalNoBets,
        bool isResolved,
        bool outcome,
        uint256 expirationTime
    ) {
        PredictionEvent storage predictionEvent = events[_eventId];
        return (
            predictionEvent.eventDescription,
            predictionEvent.totalYesBets,
            predictionEvent.totalNoBets,
            predictionEvent.isResolved,
            predictionEvent.outcome,
            predictionEvent.expirationTime
        );
    }
}