const LibraryDemo = artifacts.require("LibraryDemo");

contract("LibraryDemo", accounts => {
  
    //TEST 1 - Addition works
    //Ensure that adding was correctly imported
    it("...add safely", async () => {
      const libraryDemoInstance = await LibraryDemo.deployed();
      const result = await libraryDemoInstance.demoAdd(1, 2, { from: accounts[0] })
      assert.equal(result, 3, "The result should be 3");
    });
    //TEST 2 - Subtraction works
    //Ensure that adding was correctly imported
    it("...subtract safely", async () => {
        const libraryDemoInstance = await LibraryDemo.deployed();
        const result = await libraryDemoInstance.demoSubtract(3, 1, { from: accounts[0] })
        assert.equal(result, 2, "The result should be 2");
    
      });
    //TEST 3 - Multiplication works
    //Ensure that multiplying was correctly imported
    it("...multiply safely", async () => {
        const libraryDemoInstance = await LibraryDemo.deployed();
        const result = await libraryDemoInstance.demoMultiply(2, 10, { from: accounts[0] })
        assert.equal(result, 20, "The result should be 20");
    
      });

    //TEST 4 - Division works
    //Ensure that dividing was correctly imported
    it("...divide safely", async () => {
        const libraryDemoInstance = await LibraryDemo.deployed();
        const result = await libraryDemoInstance.demoDivide(10, 2, { from: accounts[0] })
        assert.equal(result, 5, "The result should be 5");
    
      });

    //TEST 5 - Modulo works
    //Ensure that modulo was correctly imported
    it("...modulo safely", async () => {
        const libraryDemoInstance = await LibraryDemo.deployed();
        const result = await libraryDemoInstance.demoModulo(65, 10, { from: accounts[0] })
        assert.equal(result, 5, "The result should be 5");
    
      });
  });