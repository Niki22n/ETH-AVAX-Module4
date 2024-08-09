// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "hardhat/console.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {

    event RedeemTokens(address indexed redeemer, uint256 amount, string item);

    struct artifact {
        string name;
        uint256 price;
        uint256 stock;
    }

    artifact[] public artifactCatalog;

    mapping(uint256 => uint256) public artifactStock;
    mapping(address => mapping(uint256 => uint256)) public userArtifacts;

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
        _setArtifacts();
    }

    function _setArtifacts() internal {
        artifactCatalog.push(artifact("1. DGN Necklace", 250, 100));
        artifactCatalog.push(artifact("2. DGN Ring ", 280, 50));
        artifactCatalog.push(artifact("3. DGN Softtoy ", 380, 20));
        artifactCatalog.push(artifact("4. DGN Earring", 420, 30));
        artifactCatalog.push(artifact("5. DGN Cap", 180, 80));
        artifactCatalog.push(artifact("6. DGN Backpack", 550, 10));
        artifactCatalog.push(artifact("7. DGN Purse", 350, 50));
        artifactCatalog.push(artifact("8. DGN Belt", 300, 40));
        artifactCatalog.push(artifact("9. DGN Headphone", 350, 25));
        artifactCatalog.push(artifact("10. DGN Headband", 100, 150));

        // stock mapping
        for (uint256 i = 0; i < artifactCatalog.length; i++) {
            artifactStock[i] = artifactCatalog[i].stock;
        }
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function getBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function transferTokens(address _receiver, uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "You are not having enough Degen Tokens to transfer");
        transfer(_receiver, _value);
    }

    function burnTokens(uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "You do not have enough Degen Tokens to burn");
        burn(_value);
    }

    function redeemTokens(uint256 _id) external {
        require(_id > 0 && _id <= artifactCatalog.length, "Invalid id of artifact");
        artifact storage Artifact = artifactCatalog[_id - 1];
        require(artifactStock[_id - 1] > 0, "Item is out of stock");
        require(balanceOf(msg.sender) >= Artifact.price, "You do not have enough Degen Tokens to redeem this item! try another.");

        _burn(msg.sender, Artifact.price);
        emit RedeemTokens(msg.sender, Artifact.price, Artifact.name);

        artifactStock[_id - 1]--;

        userArtifacts[msg.sender][_id - 1]++;
    }

    function artifactStore() external view returns (artifact[] memory) {
        return artifactCatalog;
    }

    function getUserArtifacts(address _user) external view returns (uint256[] memory) {
        uint256[] memory ownedArtifacts = new uint256[](artifactCatalog.length);
        for (uint256 i = 0; i < artifactCatalog.length; i++) {
            ownedArtifacts[i] = userArtifacts[_user][i];
        }
        return ownedArtifacts;
    }
}
