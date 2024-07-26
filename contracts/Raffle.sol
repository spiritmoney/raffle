// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";

// interface VRFCoordinatorV2Interface {
//     /**
//      * @notice Get configuration relevant for making requests
//      * @return minimumRequestConfirmations global min for request confirmations
//      * @return maxGasLimit global max for request gas limit
//      * @return s_provingKeyHashes list of registered key hashes
//      */
//     function getRequestConfig()
//         external
//         view
//         returns (
//             uint16,
//             uint32,
//             bytes32[] memory
//         );

//     /**
//      * @notice Request a set of random words.
//      * @param keyHash - Corresponds to a particular oracle job which uses
//      * that key for generating the VRF proof. Different keyHash's have different gas price
//      * ceilings, so you can select a specific one to bound your maximum per request cost.
//      * @param subId  - The ID of the VRF subscription. Must be funded
//      * with the minimum subscription balance required for the selected keyHash.
//      * @param minimumRequestConfirmations - How many blocks you'd like the
//      * oracle to wait before responding to the request. See SECURITY CONSIDERATIONS
//      * for why you may want to request more. The acceptable range is
//      * [minimumRequestBlockConfirmations, 200].
//      * @param callbackGasLimit - How much gas you'd like to receive in your
//      * fulfillRandomWords callback. Note that gasleft() inside fulfillRandomWords
//      * may be slightly less than this amount because of gas used calling the function
//      * (argument decoding etc.), so you may need to request slightly more than you expect
//      * to have inside fulfillRandomWords. The acceptable range is
//      * [0, maxGasLimit]
//      * @param numWords - The number of uint256 random values you'd like to receive
//      * in your fulfillRandomWords callback. Note these numbers are expanded in a
//      * secure way by the VRFCoordinator from a single random value supplied by the oracle.
//      * @return requestId - A unique identifier of the request. Can be used to match
//      * a request to a response in fulfillRandomWords.
//      */
//     function requestRandomWords(
//         bytes32 keyHash,
//         uint64 subId,
//         uint16 minimumRequestConfirmations,
//         uint32 callbackGasLimit,
//         uint32 numWords
//     ) external returns (uint256 requestId);

//     /**
//      * @notice Create a VRF subscription.
//      * @return subId - A unique subscription id.
//      * @dev You can manage the consumer set dynamically with addConsumer/removeConsumer.
//      * @dev Note to fund the subscription, use transferAndCall. For example
//      * @dev  LINKTOKEN.transferAndCall(
//      * @dev    address(COORDINATOR),
//      * @dev    amount,
//      * @dev    abi.encode(subId));
//      */
//     function createSubscription() external returns (uint64 subId);

//     /**
//      * @notice Get a VRF subscription.
//      * @param subId - ID of the subscription
//      * @return balance - LINK balance of the subscription in juels.
//      * @return reqCount - number of requests for this subscription, determines fee tier.
//      * @return owner - owner of the subscription.
//      * @return consumers - list of consumer address which are able to use this subscription.
//      */
//     function getSubscription(uint64 subId)
//         external
//         view
//         returns (
//             uint96 balance,
//             uint64 reqCount,
//             address owner,
//             address[] memory consumers
//         );

//     /**
//      * @notice Request subscription owner transfer.
//      * @param subId - ID of the subscription
//      * @param newOwner - proposed new owner of the subscription
//      */
//     function requestSubscriptionOwnerTransfer(uint64 subId, address newOwner)
//         external;

//     /**
//      * @notice Request subscription owner transfer.
//      * @param subId - ID of the subscription
//      * @dev will revert if original owner of subId has
//      * not requested that msg.sender become the new owner.
//      */
//     function acceptSubscriptionOwnerTransfer(uint64 subId) external;

//     /**
//      * @notice Add a consumer to a VRF subscription.
//      * @param subId - ID of the subscription
//      * @param consumer - New consumer which can use the subscription
//      */
//     function addConsumer(uint64 subId, address consumer) external;

//     /**
//      * @notice Remove a consumer from a VRF subscription.
//      * @param subId - ID of the subscription
//      * @param consumer - Consumer to remove from the subscription
//      */
//     function removeConsumer(uint64 subId, address consumer) external;

//     /**
//      * @notice Cancel a subscription
//      * @param subId - ID of the subscription
//      * @param to - Where to send the remaining LINK to
//      */
//     function cancelSubscription(uint64 subId, address to) external;

//     /*
//      * @notice Check to see if there exists a request commitment consumers
//      * for all consumers and keyhashes for a given sub.
//      * @param subId - ID of the subscription
//      * @return true if there exists at least one unfulfilled request for the subscription, false
//      * otherwise.
//      */
//     function pendingRequestExists(uint64 subId) external view returns (bool);
// }

// abstract contract VRFConsumerBaseV2 {
//     error OnlyCoordinatorCanFulfill(address have, address want);
//     address private immutable vrfCoordinator;

//     /**
//      * @param _vrfCoordinator address of VRFCoordinator contract
//      */
//     constructor(address _vrfCoordinator) {
//         vrfCoordinator = _vrfCoordinator;
//     }

//     /**
//      * @notice fulfillRandomness handles the VRF response. Your contract must
//      * @notice implement it. See "SECURITY CONSIDERATIONS" above for important
//      * @notice principles to keep in mind when implementing your fulfillRandomness
//      * @notice method.
//      *
//      * @dev VRFConsumerBaseV2 expects its subcontracts to have a method with this
//      * @dev signature, and will call it once it has verified the proof
//      * @dev associated with the randomness. (It is triggered via a call to
//      * @dev rawFulfillRandomness, below.)
//      *
//      * @param requestId The Id initially returned by requestRandomness
//      * @param randomWords the VRF output expanded to the requested number of words
//      */
//     function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords)
//         internal
//         virtual;

//     // rawFulfillRandomness is called by VRFCoordinator when it receives a valid VRF
//     // proof. rawFulfillRandomness then calls fulfillRandomness, after validating
//     // the origin of the call
//     function rawFulfillRandomWords(
//         uint256 requestId,
//         uint256[] memory randomWords
//     ) external {
//         if (msg.sender != vrfCoordinator) {
//             revert OnlyCoordinatorCanFulfill(msg.sender, vrfCoordinator);
//         }
//         fulfillRandomWords(requestId, randomWords);
//     }
// }

// interface AutomationCompatibleInterface {
//     /**
//      * @notice method that is simulated by the keepers to see if any work actually
//      * needs to be performed. This method does does not actually need to be
//      * executable, and since it is only ever simulated it can consume lots of gas.
//      * @dev To ensure that it is never called, you may want to add the
//      * cannotExecute modifier from KeeperBase to your implementation of this
//      * method.
//      * @param checkData specified in the upkeep registration so it is always the
//      * same for a registered upkeep. This can easily be broken down into specific
//      * arguments using `abi.decode`, so multiple upkeeps can be registered on the
//      * same contract and easily differentiated by the contract.
//      * @return upkeepNeeded boolean to indicate whether the keeper should call
//      * performUpkeep or not.
//      * @return performData bytes that the keeper should call performUpkeep with, if
//      * upkeep is needed. If you would like to encode data to decode later, try
//      * `abi.encode`.
//      */
//     function checkUpkeep(bytes calldata checkData)
//         external
//         returns (bool upkeepNeeded, bytes memory performData);

//     /**
//      * @notice method that is actually executed by the keepers, via the registry.
//      * The data returned by the checkUpkeep simulation will be passed into
//      * this method to actually be executed.
//      * @dev The input to this method should not be trusted, and the caller of the
//      * method should not even be restricted to any single registry. Anyone should
//      * be able call it, and the input should be validated, there is no guarantee
//      * that the data passed in is the performData returned from checkUpkeep. This
//      * could happen due to malicious keepers, racing keepers, or simply a state
//      * change while the performUpkeep transaction is waiting for confirmation.
//      * Always validate the data passed in.
//      * @param performData is the data which was passed back from the checkData
//      * simulation. If it is encoded, it can easily be decoded into other types by
//      * calling `abi.decode`. This data should not be trusted, and should be
//      * validated against the contract's current state.
//      */
//     function performUpkeep(bytes calldata performData) external;
// }

// interface KeeperCompatibleInterface is AutomationCompatibleInterface {}

// interface IERC165 {
//     /**
//      * @dev Returns true if this contract implements the interface defined by
//      * `interfaceId`. See the corresponding
//      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
//      * to learn more about how these ids are created.
//      *
//      * This function call must use less than 30 000 gas.
//      */
//     function supportsInterface(bytes4 interfaceId) external view returns (bool);
// }

// interface IERC721 is IERC165 {
//     /**
//      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
//      */
//     event Transfer(
//         address indexed from,
//         address indexed to,
//         uint256 indexed tokenId
//     );

//     /**
//      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
//      */
//     event Approval(
//         address indexed owner,
//         address indexed approved,
//         uint256 indexed tokenId
//     );

//     /**
//      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
//      */
//     event ApprovalForAll(
//         address indexed owner,
//         address indexed operator,
//         bool approved
//     );

//     /**
//      * @dev Returns the number of tokens in ``owner``'s account.
//      */
//     function balanceOf(address owner) external view returns (uint256 balance);

//     /**
//      * @dev Returns the owner of the `tokenId` token.
//      *
//      * Requirements:
//      *
//      * - `tokenId` must exist.
//      */
//     function ownerOf(uint256 tokenId) external view returns (address owner);

//     /**
//      * @dev Safely transfers `tokenId` token from `from` to `to`.
//      *
//      * Requirements:
//      *
//      * - `from` cannot be the zero address.
//      * - `to` cannot be the zero address.
//      * - `tokenId` token must exist and be owned by `from`.
//      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
//      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon
//      *   a safe transfer.
//      *
//      * Emits a {Transfer} event.
//      */
//     function safeTransferFrom(
//         address from,
//         address to,
//         uint256 tokenId,
//         bytes calldata data
//     ) external;

//     /**
//      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
//      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
//      *
//      * Requirements:
//      *
//      * - `from` cannot be the zero address.
//      * - `to` cannot be the zero address.
//      * - `tokenId` token must exist and be owned by `from`.
//      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or
//      *   {setApprovalForAll}.
//      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon
//      *   a safe transfer.
//      *
//      * Emits a {Transfer} event.
//      */
//     function safeTransferFrom(
//         address from,
//         address to,
//         uint256 tokenId
//     ) external;

//     /**
//      * @dev Transfers `tokenId` token from `from` to `to`.
//      *
//      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
//      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
//      * understand this adds an external call which potentially creates a reentrancy vulnerability.
//      *
//      * Requirements:
//      *
//      * - `from` cannot be the zero address.
//      * - `to` cannot be the zero address.
//      * - `tokenId` token must be owned by `from`.
//      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
//      *
//      * Emits a {Transfer} event.
//      */
//     function transferFrom(
//         address from,
//         address to,
//         uint256 tokenId
//     ) external;

//     /**
//      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
//      * The approval is cleared when the token is transferred.
//      *
//      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
//      *
//      * Requirements:
//      *
//      * - The caller must own the token or be an approved operator.
//      * - `tokenId` must exist.
//      *
//      * Emits an {Approval} event.
//      */
//     function approve(address to, uint256 tokenId) external;

//     /**
//      * @dev Approve or remove `operator` as an operator for the caller.
//      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
//      *
//      * Requirements:
//      *
//      * - The `operator` cannot be the address zero.
//      *
//      * Emits an {ApprovalForAll} event.
//      */
//     function setApprovalForAll(address operator, bool approved) external;

//     /**
//      * @dev Returns the account approved for `tokenId` token.
//      *
//      * Requirements:
//      *
//      * - `tokenId` must exist.
//      */
//     function getApproved(uint256 tokenId)
//         external
//         view
//         returns (address operator);

//     /**
//      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
//      *
//      * See {setApprovalForAll}
//      */
//     function isApprovedForAll(address owner, address operator)
//         external
//         view
//         returns (bool);
// }

// interface IERC721Enumerable is IERC721 {
//     /**
//      * @dev Returns the total amount of tokens stored by the contract.
//      */
//     function totalSupply() external view returns (uint256);

//     /**
//      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
//      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
//      */
//     function tokenOfOwnerByIndex(address owner, uint256 index)
//         external
//         view
//         returns (uint256);

//     /**
//      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
//      * Use along with {totalSupply} to enumerate all tokens.
//      */
//     function tokenByIndex(uint256 index) external view returns (uint256);
// }

error Raffle__UpkeepNotNeeded(uint256 currentBalance, uint256 numPlayers, uint256 raffleState);
error Raffle__TransferFailed();
error Raffle__SendMoreToEnterRaffle();
error Raffle__RaffleNotOpen();

/**
 * @dev This implements the Chainlink VRF Version 2
 */
contract Raffle is VRFConsumerBaseV2, KeeperCompatibleInterface {
    /* Type declarations */
    enum RaffleState {
        OPEN,
        CALCULATING
    }
    /* State variables */
    // Chainlink VRF Variables
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    uint64 private immutable i_subscriptionId;
    bytes32 private immutable i_gasLane;
    uint32 private immutable i_callbackGasLimit;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;

    // Lottery Variables
    uint256 private i_interval;
    uint256 private s_lastTimeStamp;
    address private s_recentWinner;
    uint256 private i_entranceFee;
    address payable[] private s_players;
    RaffleState private s_raffleState;

    /* Events */
    event RequestedRaffleWinner(uint256 indexed requestId);
    event RaffleEnter(address indexed player);
    event WinnerPicked(address indexed player);

    // NFT Variables
    IERC721Enumerable public nftReward;
    uint256 public nftTokenId;
    address private owner;
    address private nftRewardAddress;
    uint256[] public nftTokenIds;

    /* Functions */
    constructor(
        address vrfCoordinatorV2,
        uint64 subscriptionId,
        bytes32 gasLane, // keyHash
        uint256 interval,
        uint256 entranceFee,
        uint32 callbackGasLimit,
        address _nftRewardAddress
    ) VRFConsumerBaseV2(vrfCoordinatorV2) {
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        i_gasLane = gasLane;
        i_interval = interval;
        i_subscriptionId = subscriptionId;
        i_entranceFee = entranceFee;
        s_raffleState = RaffleState.OPEN;
        s_lastTimeStamp = block.timestamp;
        i_callbackGasLimit = callbackGasLimit;
        nftRewardAddress = _nftRewardAddress;
        nftReward = IERC721Enumerable(nftRewardAddress);
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    /**
     * @notice Allows the contract owner to change the entrance fee.
     * @param newEntranceFee The new entrance fee in wei.
     */
    function setEntranceFee(uint256 newEntranceFee) public onlyOwner {
        i_entranceFee = newEntranceFee;
    }

    /**
     * @notice Allows the contract owner to change the interval.
     * @param newInterval The new interval in seconds.
     */
    function setInterval(uint256 newInterval) public onlyOwner {
        i_interval = newInterval;
    }

    /**
     * @notice Allows the contract owner to set the NFT reward token IDs.
     * @param tokenIds The array of NFT token IDs.
     */
    function setNftTokenIds(uint256[] calldata tokenIds) public onlyOwner {
        require(tokenIds.length <= 5, "Cannot set more than 5 NFTs");
        nftTokenIds = tokenIds;
    }

    /**
     * @notice Allows the contract owner to change the NFT reward address.
     * @param newNftRewardAddress The new NFT reward contract address.
     */
    function setNftRewardAddress(address newNftRewardAddress) public onlyOwner {
        nftRewardAddress = newNftRewardAddress;
        nftReward = IERC721Enumerable(newNftRewardAddress);
    }

    function enterRaffle() public payable {
        // require(msg.value >= i_entranceFee, "Not enough value sent");
        // require(s_raffleState == RaffleState.OPEN, "Raffle is not open");
        if (msg.value < i_entranceFee) {
            revert Raffle__SendMoreToEnterRaffle();
        }
        if (s_raffleState != RaffleState.OPEN) {
            revert Raffle__RaffleNotOpen();
        }
        s_players.push(payable(msg.sender));
        // Emit an event when we update a dynamic array or mapping
        // Named events with the function name reversed
        emit RaffleEnter(msg.sender);
    }

    /**
     * @dev This is the function that the Chainlink Keeper nodes call
     * they look for `upkeepNeeded` to return True.
     * the following should be true for this to return true:
     * 1. The time interval has passed between raffle runs.
     * 2. The lottery is open.
     * 3. The contract has ETH.
     * 4. Implicity, your subscription is funded with LINK.
     */
    function checkUpkeep(
        bytes memory /* checkData */
    )
        public
        view
        override
        returns (
            bool upkeepNeeded,
            bytes memory /* performData */
        )
    {
        bool isOpen = RaffleState.OPEN == s_raffleState;
        bool timePassed = ((block.timestamp - s_lastTimeStamp) > i_interval);
        bool hasPlayers = s_players.length > 0;
        bool hasBalance = address(this).balance > 0;
        upkeepNeeded = (timePassed && isOpen && hasBalance && hasPlayers);
        return (upkeepNeeded, "0x0"); // can we comment this out?
    }

    /**
     * @dev Once `checkUpkeep` is returning `true`, this function is called
     * and it kicks off a Chainlink VRF call to get a random winner.
     */
    function performUpkeep(
        bytes calldata /* performData */
    ) external override {
        (bool upkeepNeeded, ) = checkUpkeep("");
        // require(upkeepNeeded, "Upkeep not needed");
        if (!upkeepNeeded) {
            revert Raffle__UpkeepNotNeeded(
                address(this).balance,
                s_players.length,
                uint256(s_raffleState)
            );
        }
        s_raffleState = RaffleState.CALCULATING;
        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane,
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );
        // Quiz... is this redundant?
        emit RequestedRaffleWinner(requestId);
    }

    /**
     * @dev This is the function that Chainlink VRF node
     * calls to send the money to the random winner.
     */
    function fulfillRandomWords(
        uint256, /* requestId */
        uint256[] memory randomWords
    ) internal override {
        // s_players size 10
        // randomNumber 202
        // 202 % 10 ? what's doesn't divide evenly into 202?
        // 20 * 10 = 200
        // 2
        // 202 % 10 = 2
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable recentWinner = s_players[indexOfWinner];
        s_recentWinner = recentWinner;
        s_players = new address payable[](0);
        s_raffleState = RaffleState.OPEN;
        s_lastTimeStamp = block.timestamp;
        (bool success, ) = recentWinner.call{value: address(this).balance}("");
        // require(success, "Transfer failed");
        if (!success) {
            revert Raffle__TransferFailed();
        }

         // Select a random NFT from the provided list
        uint256 nftIndex = randomWords[0] % nftTokenIds.length;
        uint256 nftTokenIdToTransfer = nftTokenIds[nftIndex];

        // Transfer the NFT to the winner
        nftReward.transferFrom(address(this), recentWinner, nftTokenIdToTransfer);

        emit WinnerPicked(recentWinner);
    }

    /** Getter Functions */

    function getRaffleState() public view returns (RaffleState) {
        return s_raffleState;
    }

    function getNumWords() public pure returns (uint256) {
        return NUM_WORDS;
    }

    function getRequestConfirmations() public pure returns (uint256) {
        return REQUEST_CONFIRMATIONS;
    }

    function getRecentWinner() public view returns (address) {
        return s_recentWinner;
    }

    function getPlayer(uint256 index) public view returns (address) {
        return s_players[index];
    }

    function getLastTimeStamp() public view returns (uint256) {
        return s_lastTimeStamp;
    }

    function getInterval() public view returns (uint256) {
        return i_interval;
    }

    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }

    function getNumberOfPlayers() public view returns (uint256) {
        return s_players.length;
    }
}

