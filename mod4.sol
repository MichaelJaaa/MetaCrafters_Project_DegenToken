// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts@4.9.0/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.9.0/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {

    enum DegenType { None, Acceleration, Healing, Intelligence }

    struct DegenPotion {
        string potionName;
        uint256 potionCost;
        uint256 potionQuantity;
    }

    mapping(address => uint256) public userInventory;
    DegenPotion[] public degenPotions;

    constructor() ERC20("Degen", "DGN") {
        degenPotions.push(DegenPotion("Acceleration", 50, 100));
        degenPotions.push(DegenPotion("Healing", 30, 100));
        degenPotions.push(DegenPotion("Intelligence", 300, 100));
    }

    function createDegen(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function destroyDegen(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    function transferDegen(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function getPotionQuantity() public view returns (uint256) {
        return degenPotions.length;
    }

    function purchasePotion(uint256 index) public {
        require(index < degenPotions.length, "Invalid potion index");
        require(balanceOf(msg.sender) >= degenPotions[index].potionCost, "Not enough tokens to buy potion");
        require(degenPotions[index].potionQuantity > 0, "Potion out of stock");

        userInventory[msg.sender] += 1;
        degenPotions[index].potionQuantity -= 1;
        _burn(msg.sender, degenPotions[index].potionCost);
    }

}
