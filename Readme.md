1. Secondhand Market: Trade used goods.

## Vision

The Prediction Secondhand Market smart contract is designed to revolutionize the way individuals make informed decisions and engage in event-based betting. By leveraging blockchain technology, this platform ensures transparency, immutability, and fairness in all prediction events. Users can create, bet, and resolve prediction events securely, without relying on intermediaries.

## Contract Address

The deployed contract address is: `0xc74C6f450109d93e05B0224C97c125209113956c`

## Features

- **Create Prediction Events**: Anyone can create a prediction event with a description and expiration time.  
- **Place Bets**: Participants can bet on the outcome of an event by choosing "Yes" or "No" and staking a certain amount.  
- **Resolve Events**: Events can be resolved after their expiration by providing the actual outcome.  
- **Claim Winnings**: Participants who predicted correctly can claim their winnings based on the pool's distribution.  
- **Transparency**: All event details and bet amounts are stored on-chain for full visibility.

## Future Scope

1. **Decentralized Resolution Mechanism**: Introduce a decentralized or oracle-based system for resolving prediction events.  
2. **Integration with Layer 2 Solutions**: To reduce gas fees and enhance scalability.  
3. **Support for Multiple Currencies**: Enable betting with multiple cryptocurrencies or stablecoins.  
4. **Advanced Analytics**: Provide insights and statistics on prediction trends and user performance.  
5. **User Interface (UI)**: Develop a web-based frontend for seamless interaction with the smart contract.  
6. **Governance Mechanism**: Allow the community to propose and vote on new features or changes to the platform.

## Usage Guide

### 1\. Creating a Prediction Event

To create a new prediction event:

function createPredictionEvent(string memory \_eventDescription, uint256 \_expirationTime) public returns (uint256);

- **\_eventDescription**: A brief description of the event.  
- **\_expirationTime**: UNIX timestamp for when the event expires.

### 2\. Placing a Bet

To place a bet on an existing event:

function placeBet(uint256 \_eventId, bool \_prediction) public payable;

- **\_eventId**: ID of the prediction event.  
- **\_prediction**: `true` for "Yes", `false` for "No".  
- **msg.value**: Amount of Ether to bet.

### 3\. Resolving an Event

To resolve an event after its expiration:

function resolveEvent(uint256 \_eventId, bool \_outcome) public;

- **\_eventId**: ID of the prediction event.  
- **\_outcome**: Actual outcome of the event (`true` for "Yes", `false` for "No").

### 4\. Claiming Winnings

To claim winnings for a resolved event:

function claimWinnings(uint256 \_eventId) public;

- **\_eventId**: ID of the resolved prediction event.

### 5\. Viewing Event Details

To view details of a specific event:

function getEventDetails(uint256 \_eventId) public view returns (

    string memory description,

    uint256 totalYesBets,

    uint256 totalNoBets,

    bool isResolved,

    bool outcome,

    uint256 expirationTime

);

- **\_eventId**: ID of the prediction event.

## Events

- **EventCreated**: Emitted when a new prediction event is created.  
- **BetPlaced**: Emitted when a bet is placed on an event.  
- **EventResolved**: Emitted when an event is resolved.

