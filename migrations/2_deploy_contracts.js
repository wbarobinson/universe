
const Universe = artifacts.require("Universe");

module.exports = function(deployer) {
  deployer.deploy(Universe);
  deployer.deploy(LibraryDemo);
};
