const Universe = artifacts.require("Universe");

contract("Universe", accounts => {
  
  //TEST 1 - No Owner
  //Ensure that poem at index 0 is not mapped to an address at the instantiation of the contract.
  it("...get poem owner", async () => {
    const universeInstance = await Universe.deployed();

    //ensure there is no poem owner, make sure this happens before 0 is killed.
    var poemOwner = await universeInstance.getPoemOwner(0);
    console.log("Owner of poem 0 is", poemOwner);

    assert.equal(poemOwner, 0, "PoemOwner should not be set");

  });
  
 //TEST 2 - Poem Death
 //This test is designed to see if poems are successfully overwritten, whenever they are rejected/killed.
 //It does this by first recording the value of the poem at index 0 as poem0. 
 //Then it selects an aribtrary poem (in this case poem at index 1) to evolve and the poem at index 0 to kill.
 //The value of the poem at index 0 is once again recorded as newPoem0.
 //The test checks to see that poem0 != newPoem0.
  it("...should overwrite first poem.", async () => {
    const universeInstance = await Universe.deployed();

    var poem0 = await universeInstance.getPoem();
    console.log("First poem at start", poem0)

    //evolved a poem by selecting it against another
    await universeInstance.selectPoem(1, 0, { from: accounts[0] });

    var newPoem0 = await universeInstance.getPoem();
    console.log("First poem after being overwritte", newPoem0);

    assert.notEqual(poem0, newPoem0, "The first poem was not overwritten despite being killed.");

  });

//TEST 3 - All Poems Present
//This test is designed to ensure that all the poems that were intended to be created were in fact created.
//MAXPOEMS is the constant global variable in the solidity contract. It is currently set to 10 for testing reasons.
  it("...should create MAXPOEMS poems.", async () => {
    const universeInstance = await Universe.deployed();

    var poems = await universeInstance.getPoems();
    console.log("all poems", poems)

    assert.equal(poems.length, 10, "Ten poems should have been created.")

  });
  
//TEST 4 - Evolved != Killed
//It is important that a user does not select and also kill the same poem, as that is a meaningless act that adds needless complexity.
//This test checks that the logic of choosing two pseudo-random poems does result in the same poem being called every time.
//If this test is run many times, then it will provide comfort that the same poem is never selected twice by getTwoPoems().
  it("...should get two different poems when getTwoPoems is called.", async () => {
    const universeInstance = await Universe.deployed();

    //get 2 different poems
    var poems = await universeInstance.getTwoPoems();
    console.log("Two poems", poems["1"], poems["3"]);

    assert.notEqual(poems["1"], poems["2"], "Two poems sourced should be different.");

  });
//TEST 5 - Poem Index Ownership  
//This test is designed to check that a newly created poem gets mapped to an address.
  it("...get poem owner", async () => {
    const universeInstance = await Universe.deployed();

    //ensure there is a poem owner, make sure this happens after 0 is killed.
    var poemOwner = await universeInstance.getPoemOwner(0);
    console.log("Owner of poem 0 is", poemOwner);

    assert.notEqual(poemOwner, null, "PoemOwner should be set");

  });
//TEST 6 - Change of Poem Index Ownership  
//This test is designed to check that a newly created poem gets mapped to a new address.
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
