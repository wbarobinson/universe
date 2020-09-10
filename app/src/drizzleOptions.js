import Web3 from "web3";
import Universe from "./contracts/Universe.json";


const options = {
  web3: {
    block: false,
    customProvider: new Web3("ws://localhost:8545"),
  },
  contracts: [Universe],
  events: {
    //what dis?
    Universe: ["LogNewPoem"],
  },
};

export default options;
