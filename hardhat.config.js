require("dotenv").config();
const { utils } = require("ethers");

require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-waffle");
require("hardhat-gas-reporter");
require("solidity-coverage");

module.exports = {
  solidity: {
    version: "0.8.14",
    settings: {
      optimizer: {
        enabled: true,
        runs: 500,
      },
    },
  },
  networks: {
    hardhat: {},
    skale: {
      url: process.env.SKALE_RPC,
      accounts: [process.env.PRIVATE_KEY],
    },
    fuji: {
      url: process.env.FUJI_RPC,
      accounts: [process.env.PRIVATE_KEY],
      gasPrice: parseInt(utils.parseUnits("25", "gwei")),
    },
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  }
};
