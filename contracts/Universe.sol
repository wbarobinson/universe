// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

contract Universe {
    //The register of poem owners
    mapping (uint => address) public poemOwners;
    //The set of current poems
    uint MAXPOEMS = 10;
    bytes32[10] poems;
    bytes32 mask = 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff;
    bytes32 mask2 = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

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

    function selectPoem(uint _selectedPoemId, uint _rejectedPoemId) public {
        require(_selectedPoemId >= 0 && _selectedPoemId < MAXPOEMS && _rejectedPoemId >= 0 && _rejectedPoemId < MAXPOEMS);
        require(_selectedPoemId != _rejectedPoemId);
        bytes32 newPoem = evolvePoem(_selectedPoemId);
        poems[_rejectedPoemId] = newPoem;
        poemOwners[_rejectedPoemId] = msg.sender;
        emit LogNewPoem(_rejectedPoemId, msg.sender, newPoem);
    }

    function getPoem(uint _selectedPoemId) view public returns (bytes32) {
        return poems[_selectedPoemId];
    }

    function evolvePoem(uint _selectedPoemId) internal returns (bytes32) {
        //Get an arbitrary number... undesired behavior: if too many calls in same block, the same poem will used each time and kill biodiversity
        uint arbitraryMate = uint(block.timestamp % MAXPOEMS);
        //Move the mask to pick a random 32 contiguous bytes
        uint arbitraryGeneShare = uint(block.timestamp % 128);
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
