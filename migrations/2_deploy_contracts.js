
const Universe = artifacts.require("Universe");
const LibraryDemo = artifacts.require("LibraryDemo");

module.exports = function(deployer) {
  deployer.deploy(Universe);
  deployer.deploy(LibraryDemo);
};
