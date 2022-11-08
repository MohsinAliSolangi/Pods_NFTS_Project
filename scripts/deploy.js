// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
 
 let NFTContracts = await hre.ethers.getContractFactory("NFTContracts");
  let  NFT = await NFTContracts.deploy();
  await NFT.deployed();
  
  console.log(
    "NFTContracts",NFT.address
  ); 

  let NFTMarket = await hre.ethers.getContractFactory("Market");
  let  Market = await NFTMarket.deploy();
  await Market.deployed();
  console.log(
    "Market",Market.address  );
  
  
saveFrontendFiles(Market , NFT)
}


function saveFrontendFiles(Market,NFT) {
  const fs = require("fs");
  const contractsDir = "./abi";

  if (!fs.existsSync(contractsDir)) {
    fs.mkdirSync(contractsDir);
  }
  let config = `
 export const NFT_addr = "${NFT.address}"
 export const Market_addr = "${Market.address}"
`
  let data = JSON.stringify(config)
  fs.writeFileSync(
    contractsDir + '/addresses.js', JSON.parse(data)

  );
  

}


// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
