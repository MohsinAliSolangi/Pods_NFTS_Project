require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-waffle");
require('hardhat-abi-exporter');
require('dotenv').config({path: __dirname+'/.env'});
require("@nomiclabs/hardhat-etherscan");
require('hardhat-contract-sizer');

// Go to https://www.alchemyapi.io, sign up, create
// a new App in its dashboard, and replace "KEY" with its key
const ALCHEMY_API_KEY =process.env.ALCHEMY_API_KEY;

// Replace this private key with your Goerli account private key
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Beware: NEVER put real Ether into testing accounts
const GOERLI_PRIVATE_KEY =process.env.GOERLI_PRIVATE_KEY;

module.exports = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [GOERLI_PRIVATE_KEY]
    }
  },


abiExporter: {
    path: './abi',
    runOnCompile: true,
    clear: true,
    only: [':Market$',':NFTContracts$'],
    flat: true,
    spacing: 2,
    pretty: true,
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: "3WP9SDKDTK473KJCJCG4RJGS4H1DTEW1Z3"
  },
  mocha: {
    timeout: 1000000
  }

 // npx hardhat verify --network goerli 

};
