//This is to demonstrate the appropriate use of a libary
pragma solidity >=0.4.22;
import "@openzeppelin/contracts/math/SafeMath.sol";

contract LibraryDemo {
  using SafeMath for uint8;
  uint8 NUMBERONE = 1;
  uint8 NUMBERTWO = 2;
  
  function demo() public view pure returns(uint8) {
  uint8 numberThree = NUMBERONE.add(NUMBERTWO); 
  return numberThree;
  }
  
}
