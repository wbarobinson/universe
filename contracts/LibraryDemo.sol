//This is to demonstrate the appropriate use of a libary
pragma solidity >=0.4.22;
import "@openzeppelin/contracts/math/SafeMath.sol";

contract LibraryDemo {
  using SafeMath for uint;

  
  function demoAdd(uint a, uint b) public pure returns(uint) {
  uint c = a.add(b); 
  return c;
  }

  function demoSubtract(uint a, uint b) public pure returns(uint) {
  uint c = a.sub(b); 
  return c;
  }

  function demoDivide(uint a, uint b) public pure returns(uint) {
  uint c = a.div(b); 
  return c;
  }

  function demoMultiply(uint a, uint b) public pure returns(uint) {
  uint c = a.mul(b); 
  return c;
  }

  function demoModulo(uint a, uint b) public pure returns(uint) {
  uint c = a.mod(b); 
  return c;
  }
  
}
