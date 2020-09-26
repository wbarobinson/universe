// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;
import "@openzeppelin/contracts/math/SafeMath.sol";

contract Universe {
    using SafeMath for uint;
    //The register of poem creators
    mapping (uint => address) public poemOwners;
    //The maximum number of poems
    uint constant public MAXPOEMS = 200;
    //The array of all poems
    bytes32[MAXPOEMS] public poems;
    //A mask for selecting half of the poems
    bytes32 mask = 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff;
    //A mask to be used when selecting the other half
    bytes32 mask2 = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    
    //The IPFS hash of the words
    string URL = "https://ipfs.io/ipfs/QmQQWjbDvhHWpNvQh8yV4fu43hdSBwhrnPrZRTBXCAaWLW";
    
    //An event to log all newly made poems
    event LogNewPoem(uint rejectedPoemId, address owner, bytes32 newPoem);

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
            emit LogNewPoem(i, msg.sender, poems[i]);
        }
    }
    /*
     * A function to get hardcoded url of the dictionary
     * @returns the url of the dictionary on ipfs
    */    
    function getDictionary() view public returns (string memory) {
        return URL;
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
        bytes32 newPoem = evolvePoem(_selectedPoemId);
        poems[_rejectedPoemId] = newPoem;
        poemOwners[_rejectedPoemId] = msg.sender;
        emit LogNewPoem(_rejectedPoemId, msg.sender, newPoem);
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
     * A function to get a poem's creator
     * @param is the index of the poem in the array of poems
     * @returns the poem at the index specified
    */
    function getPoemOwner(uint id) view public returns (address poemOwner) {
        require(id < MAXPOEMS);
        return poemOwners[id];
    }
    /*
     * A function to get two different arbitrary poems
     * @returns two poems and their indices
    */
    function getTwoPoems() view public returns (uint IDofFirstPoem, bytes32 poemA, uint IDofSecondPoem, bytes32 poemB) {
        //Get one arbitrary poem ID using timestamp
        uint arbitraryPoem1 = uint(block.timestamp.mod(MAXPOEMS));
        uint arbitraryPoem2 = uint(block.number.mod(MAXPOEMS));
        //Make sure second arbitrary poem ID using block height is difference from arbitraryPoem1
        if(arbitraryPoem1 == arbitraryPoem2) {
        arbitraryPoem2++;
        }
        return (arbitraryPoem1, poems[arbitraryPoem1], arbitraryPoem2, poems[arbitraryPoem2]);
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
