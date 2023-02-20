// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9; 

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20God is ERC20 {
    // Overrides incoming here 
    address private _godAccount;
    
    //First thing is to define who has god privleges in the constructor
    // Contracts are only allowed 1 constructor
    constructor (address godAccount_, string memory name, string memory symbol) ERC20(name, symbol) {
        _godAccount = godAccount_;
        _mint(_godAccount, 100000000);
    }

    /*this function will check to the caller to ensure it is the god mode address
    * then it will mint a preset amount (1,000,000) of tokens to address specified
    */ 
    function mintTokensToAddress(address account) public {
        require(msg.sender == _godAccount, "Sorry, you cannot mint tokens"); 
        require(account != address(0), "ERC20: cannot mint to a zero address"); 
        _mint(account, 1000000);
    }
    
    /*this function will check to the caller to ensure it is the god mode address
     * this function will change a user's balance by burning user tokens (1,000,000)
     * at the address speficied.   
    */ 
    function changeBalanceAtAddress(address account) public {
        require(msg.sender == _godAccount, "Sorry, you cannot burn tokens"); 
        require(account != address(0), "ERC20: cannot mint to a zero address"); 
        //implement a check to make sure the user has enough tokens 
        _burn(account, 1000000);
    }

    /*this function will check to the caller to ensure it is the god mode address
     * then it will transfer a users tokens (1,000,000) to the address specified
    */ 
    function authoritativeTranferFrom(address source, address destination) public {
        require(msg.sender == _godAccount, "Sorry, you cannot xfer tokens"); 
        //implement a check to make sure the user has enough tokens 
        _burn(source, 1000000);
        _mint(destination, 1000000);
    }
}

