const path = require("path");
var HDWalletProvider = require("truffle-hdwallet-provider");
const MNEMONIC = "secret"

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_build_directory: path.join(__dirname, "app/src/contracts"),
  networks: {
    // develop: { // default with truffle unbox is 7545, but we can use develop to test changes, ex. truffle migrate --network develop
    //   host: "127.0.0.1",
    //   port: 8545,
    //   network_id: "*"
    // },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(MNEMONIC, "https://ropsten.infura.io/v3/8eaa8e1b34a04ab4bb59e3d10b985fd6")
      },
      network_id: 3,
      gas: 4000000      //make sure this gas allocation isn't over 4M, which is the max
    }
  }
};
