# ETH-AVAX-Module4
This is a smart contract in the form of Token for Degen Gaming where several functionalities can be performed.

# Getting Started
Executing program
Steps to be followed inorder to run the contract seamlessly:

First we have to take test credit in the form of AVAX tokens in the Avalanche Fuji C-Chain.
Now we will go to core web app to request for Tokens and there we have to enter the coupon code
We will get 0.5 AVAX per day and after that we can use those to test our contract.
Now we will go back to Remix and then choose Environment as Injected Provider - Metamask and after that deploy the contract.
Now we wil copy the address of the deployed contract and then paste it in Snowtrace Testnet and then click on verify and publish contracts.
Then we will click on verify and then select chain as Fuji, enter the address of the new contract and then select the compiler version mentioned in the solidity file. 
After all is done we will now perform transaction in the contract and those will be logged in the Snowtrace.

# code
```
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

```

# Working
After the Contract is deployed we can perform the following operations in it:

Minting Tokens: Creating new Tokens (can only be done by the ownwer).
Burning Tokens: Burn the Tokens from the whole Smart Contract.
RedeemTokens: Buy different merchandise by using Tokens.
Transfer Tokens: Transfer Token from a particular address to another address.
GetBalance: Check the balance of a particular address at a particular time.

Apart from it we also have to flatten the file because the JSON format has to be adaptible as normal import statements are not compatible in the verification portal.

Authors
Nikita

License
This project is licensed under the MIT License
