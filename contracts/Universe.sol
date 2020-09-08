// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

contract Universe {
    //The register of poem owners
    mapping (uint => address) public poemOwners;
    //The set of current poems
    bytes32[500] poems;
    bytes32 mask = 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff;
    bytes32 mask2 = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

    event LogNewPoem(uint rejectedPoemId, address owner, bytes32 newPoem);

    constructor() {
        //Create the first poem, using the contract creator's address as a random seed
        poems[0] = keccak256(abi.encodePacked(msg.sender));
        //Create the remaining poems
        for(uint i=1; i<poems.length; i++) {
            poems[i] = keccak256(abi.encodePacked(poems[i-1]));
        }
    }

    function selectPoem(uint _selectedPoemId, uint _rejectedPoemId) public {
        require(_selectedPoemId != _rejectedPoemId);
        bytes32 newPoem = evolvePoem(_selectedPoemId);
        poems[_rejectedPoemId] = newPoem;
        poemOwners[_rejectedPoemId] = msg.sender;
        emit LogNewPoem(_rejectedPoemId, msg.sender, newPoem);
    }

    function evolvePoem(uint _selectedPoemId) internal view returns (bytes32) {
        //Get an arbitrary number... undesired behavior: if too many calls in same block, the same poem will used each time and kill biodiversity
        uint8 arbitraryMate = uint8(block.timestamp % 500);
        uint8 arbitraryGeneShare = uint8(block.timestamp % 16);
        //Move the mask
        bytes32 tempMask1 = mask << 2 ** arbitraryGeneShare;
        bytes32 tempMask2 = mask2 ^ tempMask1;
        bytes32 keep1 = poems[_selectedPoemId] & tempMask1;
        bytes32 keep2 = poems[arbitraryMate] & tempMask2;
        bytes32 evolvedPoem = keep1 & keep2;
        return evolvedPoem;
    }

}
