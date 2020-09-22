// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;
import "@openzeppelin/contracts/math/SafeMath.sol";

contract Universe {
    using SafeMath for uint;
    //The register of poem owners
    mapping (uint => address) public poemOwners;
    //The set of current poems
    uint constant public MAXPOEMS = 10;
    bytes32[MAXPOEMS] public poems;
    bytes32 mask = 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff;
    bytes32 mask2 = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    
    //The IPFS hash of the words
    string URL = "https://ipfs.io/ipfs/QmZVoGsGAmCDRFAZYoeiNpbgD4j3Qgdde66XXVj1WYS3q";

    event LogNewPoem(uint rejectedPoemId, address owner, bytes32 newPoem);
    //event LogData(string explainer, bytes32 mask);

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
    
    function getDictionary() view public returns (string memory) {
        return URL;
    }
    
    function selectPoem(uint _selectedPoemId, uint _rejectedPoemId) public {
        require(_selectedPoemId >= 0 && _selectedPoemId < MAXPOEMS && _rejectedPoemId >= 0 && _rejectedPoemId < MAXPOEMS && _selectedPoemId != _rejectedPoemId);
        bytes32 newPoem = evolvePoem(_selectedPoemId);
        poems[_rejectedPoemId] = newPoem;
        poemOwners[_rejectedPoemId] = msg.sender;
        emit LogNewPoem(_rejectedPoemId, msg.sender, newPoem);
    }

    function getPoems() view public returns (bytes32[MAXPOEMS] memory) {
        return poems;
    }

    function getPoem() view public returns (bytes32) {
        return poems[0];
    }
    function getPoemOwner(uint id) view public returns (address poemOwner) {
        require(id <= MAXPOEMS);
        return poemOwners[id];
    }
    function getTwoPoems() view public returns (uint IDofFirstPoem, bytes32 poemA, uint IDofSecondPoem, bytes32 poemB) {
        //Get one arbitrary poem ID using timestamp
        uint arbitraryPoem1 = uint(block.timestamp.mod(MAXPOEMS));
        //Get a second, but different arbitrary poem ID using block height
        if(block.number.mod(MAXPOEMS) != block.timestamp.mod(MAXPOEMS)) {
        uint arbitraryPoem2 = block.number.mod(MAXPOEMS);
        } else {
        uint arbitraryPoem2 = block.number.mod(MAXPOEMS) + 1;
        }
        return (arbitraryPoem1, poems[arbitraryPoem1], arbitraryPoem2, poems[arbitraryPoem2]);
    }

    function evolvePoem(uint _selectedPoemId) internal returns (bytes32) {
        //Get an arbitrary number... undesired behavior: if too many calls in same block, the same poem will used each time and kill biodiversity
        uint arbitraryMate = uint(block.timestamp.mod(MAXPOEMS));
        //Move the mask to pick a random 32 contiguous bytes
        uint arbitraryGeneShare = uint(block.timestamp.mod(128));
        //emit LogData("mask", mask);
        //Move the mask
        bytes32 tempMask1 = mask << arbitraryGeneShare;
        //emit LogData("tempMask1", tempMask1);
        //Create the opposite mask
        bytes32 tempMask2 = mask2 ^ tempMask1;
        //emit LogData("tempMask2", tempMask2);
        //
        bytes32 keep1 = poems[_selectedPoemId] & tempMask1;
        //emit LogData("keep1", keep1);
        bytes32 keep2 = poems[arbitraryMate] & tempMask2;
        //emit LogData("keep2", keep2);
        bytes32 evolvedPoem = keep1 | keep2;
        //emit LogData("evolvedPoem", evolvedPoem);
        return evolvedPoem;
    }
}
