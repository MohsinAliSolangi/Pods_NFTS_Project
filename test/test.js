const { expect } = require("chai");
const { ethers } = require("hardhat");

//describe for deploy the smart contract
describe("This Is MarketPlace", function () {

  let NFTMarket;
  let Market;
  let NFT;
  let NFTContracts;
  


  it ("All Smart Contract Deplooy here :", async function(){
    
    [per1,per2,per3,per4] = await ethers.getSigners()


  NFTContracts = await hre.ethers.getContractFactory("NFTContracts");
  NFT = await NFTContracts.deploy();
  
  console.log(
    "NFTContracts",NFT.address
  ); 

  NFTMarket = await hre.ethers.getContractFactory("Market");
  Market = await NFTMarket.deploy();
  console.log(
    "Market",Market.address
  );

  }),

//here we calll Mint function for create a token
it("call Mint Function Of Erc721 :", async function(){
  let mintToken = await NFT.safeMint(per1.address,"0x00");
  balance = await NFT.balanceOf(per1.address);
  console.log("after Mint NFT Balance Cheek : ",balance.toString());
  });

it("call Mint Function Of Erc721 :", async function(){
    let mintToken = await NFT.safeMint(per1.address,"0x00");
    balance = await NFT.balanceOf(per1.address);
    console.log("after Mint NFT Balance Cheek : ",balance.toString());
    });

    it("call Approve For All Function Of Erc721 :", async function(){
    let Approve = await NFT.setApprovalForAll(Market.address,true);
  });
  

//Now make setSalePrice of the NFT
it ("now call create Market sale :", async function(){
  let create = await Market.createMarketItem(NFT.address,0,10); 
  let getPrice = await Market.ownerOf(1);
  console.log("After setPrice Get values :",getPrice.toString()); 
  console.log("this is sender address",per1.address);
  });

  it ("now call create Market sale :", async function(){
    let create = await Market.createMarketItem(NFT.address,1,10); 
    let getPrice = await Market.ownerOf(1);
    console.log("After setPrice Get values :",getPrice.toString()); 
    console.log("this is sender address",per1.address);
    });
 

// it ("Setoction to my nft NFT :", async function(){
    
//     balance = await NFT.balanceOf(per2.address);
//     console.log("Before puchase nft balance", balance);
//     let createMarketSale = await Market.connect(per2).createMarketSale(NFT.address,1,{ value: 10 });
//     balance = await NFT.balanceOf(per2.address);
//     console.log("after puchase nft balance", balance);
     
//     });


//Buy Function Call SuperRareBaazar
it ("buy Funct%%%%%%%%%%%%%:", async function(){
  let getPrice = await Market.connect(per2).ownerOf(1);
  console.log("After setPrice Get values :",getPrice.toString());  
  });

it ("fatch all markey items:", async function(){
    let itmes = await Market.fetchMarketItems();
    console.log("fatch all markey items :",itmes.toString());  
    });

it ("get Listed NFT on market:", async function(){
      let itmes = await Market.getListedNFT(1);
      console.log("get Listed NFT on market :",itmes.toString());  
      });
      
it ("fetch My NFTs on market:", async function(){
        let itmes = await Market.fetchMyNFTs();
        console.log("fetch My NFTs on market :",itmes.toString());  
        });

});  