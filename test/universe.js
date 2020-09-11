const Universe = artifacts.require("Universe");

contract("Universe", accounts => {
  
  
  it("...should overwrite first poem.", async () => {
    const universeInstance = await Universe.deployed();

    var poem0 = await universeInstance.getPoem();
    console.log("First poem at start", poem0)

    //evolved a poem by selecting it against another
    await universeInstance.selectPoem(2, 0, { from: accounts[0] });

    var newPoem0 = await universeInstance.getPoem();
    console.log("First poem after being overwritte", newPoem0);

    assert.notEqual(poem0, newPoem0, "The first poem was not overwritten despite being killed.");

  });



  it("...should create MAXPOEMS poems.", async () => {
    const universeInstance = await Universe.deployed();

    var poems = await universeInstance.getPoems();
    console.log("all poems", poems)

    assert.equal(poems.length, 10, "Ten poems should have been created.")

  });

  it("...should get two different poems when getTwoPoems is called.", async () => {
    const universeInstance = await Universe.deployed();

    //get 2 different poems
    var poems = await universeInstance.getTwoPoems();
    console.log("Two poems", poems["1"], poems["3"]);

    assert.notEqual(poems["1"], poems["2"], "Two poems sourced should be different.");

  });

  it("...get poem owner", async () => {
    const universeInstance = await Universe.deployed();

    //ensure there is a poem owner, make sure this happens after 0 is killed.
    var poemOwner = await universeInstance.getPoemOwner(0);
    console.log("Owner of poem 0 is", poemOwner);

    assert.notEqual(poemOwner, null, "PoemOwner should be set");

  });

  it("...ownership of array ID of poems can change", async () => {
    const universeInstance = await Universe.deployed();

    //ensure that ownership can change
    await universeInstance.selectPoem(2, 3, { from: accounts[1] });
    var poemOwner1 = await universeInstance.getPoemOwner(3);
    await universeInstance.selectPoem(2, 3, { from: accounts[2] });
    var poemOwner2 = await universeInstance.getPoemOwner(3);

    assert.notEqual(poemOwner1, poemOwner2, "ownership of array ID did not change");

  });


});
