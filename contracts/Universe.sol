// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;
import "@openzeppelin/contracts/math/SafeMath.sol";

contract Universe {
    using SafeMath for uint;
    //Total votes cast
    uint public totalVotes = 0;
    //Maximum number of votes that can be cast
    uint constant public MAXVOTES = 100000;
    //Balance of votes cast by poem judges
    mapping (address => unit) public judgeBalances;
    //The maximum number of poems
    uint constant public MAXPOEMS = 100;
    //The array of all poems
    bytes32[MAXPOEMS] public poems;
    //A mask for selecting half of the poems
    bytes32 mask = 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff;
    //A mask to be used when selecting the other half
    bytes32 mask2 = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    
    //An event to log all newly made poems
    event LogNewPoem(uint rejectedPoemId, bytes32 newPoem);

    /*
     * constructor that creates the initial set of poems
     * @emits new poems
    */ 
    constructor() public {
        //Create the first poem, using the contract creator's address as a random seed
        poems[0] = keccak256(abi.encodePacked(msg.sender));
        emit LogNewPoem(0, msg.sender, poems[0]);
        //Create the remaining poems
        for(uint i=1; i<poems.length; i++) {
            poems[i] = keccak256(abi.encodePacked(poems[i-1]));
            emit LogNewPoem(i, poems[i]);
        }
    }
     /*
     * A function that will delete a poem from the array of poems and
     * in its place will go a new poem created by evolvePoem function
     * @param _selectedPoemId is the index of the poem in the array poems that will be spliced   
     * @param _rejectedPoemId is the index of the poem in the array poems that will be deleted
     * @emits _rejectedPoemId, msg.sender and new poem
     * @returns nothing
    */   
    function selectPoem(uint _selectedPoemId, uint _rejectedPoemId) public {
        require(_selectedPoemId >= 0 && _selectedPoemId < MAXPOEMS && _rejectedPoemId >= 0 && _rejectedPoemId < MAXPOEMS && _selectedPoemId != _rejectedPoemId);
        require(totalVotes < MAXVOTES);
        bytes32 newPoem = evolvePoem(_selectedPoemId);
        poems[_rejectedPoemId] = newPoem;
        //Is this the correct method for incrementing the Balance of msg.sender?
        judgeBalances[msg.sender] = judgeBalances[msg.sender] + 1;
        totalVotes = totalVotes + 1;
        emit LogNewPoem(_rejectedPoemId, newPoem);
    }
    /*
     * A function to get all poems
     * @returns the array of all poems
    */
    function getPoems() view public returns (bytes32[MAXPOEMS] memory) {
        return poems;
    }
    /*
     * A function to get a poem at a given index
     * @param id is the index of the poem in the array poems
     * @returns the poem at the index specified
    */
    function getPoem(uint id) view public returns (bytes32) {
        return poems[id];
    }
     /*
     * An internal function to get the splice of two poems
     * @returns one new poem
    */   
    function evolvePoem(uint _selectedPoemId) internal view returns (bytes32) {
        //Get an arbitrary number
        uint arbitraryMate = uint(block.timestamp.mod(MAXPOEMS));
        //Move the mask to pick a random 128 contiguous bits
        uint arbitraryGeneShare = uint(block.timestamp.mod(128));
        //Move the mask
        bytes32 tempMask1 = mask << arbitraryGeneShare;
        //Create the opposite mask
        bytes32 tempMask2 = mask2 ^ tempMask1;
        //Mask selected poem to keep half
        bytes32 keep1 = poems[_selectedPoemId] & tempMask1;
        //Mask arbitrary poem to keep opposite half
        bytes32 keep2 = poems[arbitraryMate] & tempMask2;
        //Merge poems by masking one with the other
        bytes32 evolvedPoem = keep1 | keep2;

        return evolvedPoem;
    }
}
