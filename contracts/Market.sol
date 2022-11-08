// SPDX-License-Identifier: MIT


pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";
import "hardhat/console.sol";

contract Market is ReentrancyGuard , Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    Counters.Counter private _itemsSold; 
  
    uint256 totalVolume;  

event MarketItemCreated (
    uint indexed itemId,
    address indexed nftContract,
    uint256 indexed tokenId,
    address seller,
    address owner,
    uint256 price,
    bool sold
);

receive() external payable{}
fallback() external payable{}

mapping(uint256 => MarketItem) private idToMarketItem;
mapping(address => mapping (uint256 => uint256)) public tokenItemId;

struct MarketItem {
    uint itemId;
    address nftContract;
    uint256 tokenId;
    address payable seller;
    address payable owner;
    uint256 price;
    bool sold;
}


function transferNFT (
  address nftContract,
  address from,
  address to,
  uint256 tokenId
) private returns(bool){
IERC721(nftContract).transferFrom(from, to, tokenId);
return true ; 
}

//this function use for create market item or on listing at market 
function createMarketItem(
address nftContract,
uint256 tokenId,
uint256 price
) public payable nonReentrant returns(uint256) {
require(price > 0, "Price must be at least 1 wei");
_itemIds.increment();
uint256 itemId = _itemIds.current();

tokenItemId[nftContract][tokenId] = itemId;
idToMarketItem[itemId] =MarketItem(
itemId,
nftContract,
tokenId,
payable(msg.sender),
payable(address(0)),
price,
false
);

transferNFT (
nftContract,
_msgSender(),
address(this),
tokenId
);

emit MarketItemCreated(
itemId,
nftContract,
tokenId,
msg.sender,
address(0),
price,
false
);
return itemId;
}


//this function transfer nft to buyer & send funds to the buyer
function createMarketSale(
address nftContract,
uint256 itemId
) public payable nonReentrant {
uint price = idToMarketItem[itemId].price;
uint tokenId = idToMarketItem[itemId].tokenId;
require(msg.value == price, "Please submit the asking price in order to complete the purchase");
  

    idToMarketItem[itemId].seller.transfer(price);
    delete tokenItemId[nftContract][tokenId];

  transferNFT (
    nftContract,
    address(this),
    _msgSender(),
    tokenId
    );

  idToMarketItem[itemId].owner = payable(msg.sender);
  idToMarketItem[itemId].sold = true;
    _itemsSold.increment();
   totalVolume += price;
}


//this function returns nft owner/seller address   
function ownerOf(uint256 itemId) public view returns(address){
return idToMarketItem[itemId].seller;
}


//this function get all nfts on smartContract
function fetchMarketItems() public view returns (MarketItem[] memory) { 
  uint itemCount = _itemIds.current(); 
  uint unsoldItemCount = _itemIds.current() - _itemsSold.current(); 
  uint currentIndex = 0; 
  
  MarketItem[] memory items = new MarketItem[](unsoldItemCount); 
  for (uint i = 0; i < itemCount; i++) { 
  if (idToMarketItem[i + 1].owner == address(0)) { 
  uint currentId = i + 1; 
  MarketItem storage currentItem = idToMarketItem[currentId]; 
  items[currentIndex] = currentItem; 
  currentIndex += 1; 
  } 
  } 
  return items; 
  } 

  
  /* Returns only l items that a user has purchased */ 
  function fetchMyNFTs() public view returns (MarketItem[] memory) { 
  uint totalItemCount = _itemIds.current(); 
  uint itemCount = 0; 
  uint currentIndex = 0; 
  
  for (uint i = 0; i < totalItemCount; i++) { 
  if (idToMarketItem[i + 1].owner == msg.sender) { 
  itemCount += 1; 
  } 
  } 
  
  MarketItem[] memory items = new MarketItem[](itemCount); 
  for (uint i = 0; i < totalItemCount; i++) { 
  if (idToMarketItem[i + 1].owner == msg.sender) { 
  uint currentId = i + 1; 
  MarketItem storage currentItem = idToMarketItem[currentId]; 
  items[currentIndex] = currentItem; 
  currentIndex += 1; 
  } 
  } 
  return items; 
  } 
   
  /* Returns only items a user has created */
  function fetchItemsCreated() public view returns (MarketItem[] memory) { 
  uint totalItemCount = _itemIds.current(); 
  uint itemCount = 0; 
  uint currentIndex = 0; 
  
  for (uint i = 0; i < totalItemCount; i++) { 
  if (idToMarketItem[i + 1].seller == msg.sender) { 
  itemCount += 1; 
  } 
  } 
  
  MarketItem[] memory items = new MarketItem[](itemCount); 
  for (uint i = 0; i < totalItemCount; i++) { 
  if (idToMarketItem[i + 1].seller == msg.sender) { 
  uint currentId = i + 1; 
  MarketItem storage currentItem = idToMarketItem[currentId]; 
  items[currentIndex] = currentItem; 
  currentIndex += 1; 
  } 
  } 
  return items; 
  } 
  
  function getListedNFT(uint256 itemId) public view returns( MarketItem[] memory ){ 
  MarketItem[] memory items = new MarketItem[](1); 
  MarketItem storage currentItem = idToMarketItem[itemId]; 
  items[0] = currentItem; 
  return items; 
  } 
 

function cancelListed(uint256 itemId) public returns(bool){
  uint256 tokenId = idToMarketItem[itemId].tokenId; 
  MarketItem memory marketitem = idToMarketItem[itemId];
  if (marketitem.seller == msg.sender){
  
        IERC721(marketitem.nftContract).transferFrom(address(this), marketitem.seller, tokenId);
        delete tokenItemId[marketitem.nftContract][tokenId];
        idToMarketItem[itemId].sold = false;
        return true ; 
        }else{
            return false;
        }     
        
        }

}