// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts@4.8.0/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.8.0/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts@4.8.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.8.0/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts@4.8.0/token/ERC721/utils/ERC721Holder.sol";

// After deploying this contract and the ERC721 tokens
// Need to use the setApprovalForAll method in the ERC721 contracto to allow the ERC20 contract to control it
// Pass the collection id and the token id of the ERC721
// along wirh the amount of ERC20 tokens to mint 
// now the ERC20 contract owns the ERC721 contract
contract MyToken is ERC20, Ownable, ERC20Permit {
    IERC721 public collection;
    uint256 public tokenId;
    bool public initialized = false;
    bool public forSale = false;
    uint256 public salePrice;
    bool canRedeem = false;




    constructor() ERC20("MyToken", "MTK") ERC20Permit("MyToken") {}

    function initialize(address _collection, uint256 _tokenId, uint256 _amount) external onlyOwner {
        require (!initialized, "Already initialized");
        require(_amount > 0, "");
        collection = IERC721(_collection);
        collection.safeTransferFrom(msg.sender, address(this), _tokenId);
        tokenId = _tokenId;
        initialized = true;
        _mint(msg.sender, _amount);
    }
    
    function putForSale (uint256 price) external onlyOwner {
        salePrice = price;
        forSale = true;
    }

    function purchase() external payable {
        require (forSale, "Not for sale");
        require (msg.value >= salePrice, "Not enough ether sent");
        collection.transferFrom(address(this), msg.sender, tokenId);
        forSale = false;
        canRedeem = true;
    }

    function redeem(uint256 _amount) external {
        require (canRedeem, "Redemtion not available");
        uint256 totalEther = address(this).balance;
        uint256 toRedeem = _amount * totalEther / totalSupply();

        _burn(msg.sender, _amount);
        payable(msg.sender).transfer(toRedeem);
    }
}
