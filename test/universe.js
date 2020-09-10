const Universe = artifacts.require("Universe");

contract("Universe", accounts => {
  it("...should create 500 poems.", async () => {
    const universeInstance = await Universe.deployed();
    
    //get 2 poems before they are modified
    var poemData3 = await universeInstance.getPoem(2);
    var poemData4 = await universeInstance.getPoem(3);
    console.log("Poem 3", poemData3, "Poem 4", poemData4)

    //evolved a poem by selecting it against another
    await universeInstance.selectPoem(2, 3, { from: accounts[0] });
    var poemData3 = await universeInstance.getPoem(2);
    var poemData4 = await universeInstance.getPoem(3);
    console.log("Poem 3", poemData3, "Poem 4", poemData4)


    //get poemData0, the first poem, which is the keccack of the deployer address
    const poemData0 = await universeInstance.getPoem(0);
    assert.equal(poemData0, "0x984f41eb67eb23e42139410eade1008a90b01a018ce2577fea44262c6fc16ce3", "The first poem was not the keccak of the deployer's address");
  });
});
