// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20God is ERC20 {
    address private _godAccount;

    //create an array for the admin and blockList with a size of 3 to start
    //Can dynamically add using push later
    address[] private _admins;
    address[] private _blockList;

    //First thing is to define who has god privleges in the constructor
    //then we can add them to _admins list as well before _mint
    constructor(
        address godAccount_,
        string memory name,
        string memory symbol
    ) ERC20(name, symbol) {
        _godAccount = godAccount_;
        _admins.push(godAccount_);
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
    function authoritativeTranferFrom(
        address source,
        address destination
    ) public {
        require(msg.sender == _godAccount, "Sorry, you cannot xfer tokens");
        //implement a check to make sure the user has enough tokens
        _burn(source, 1000000);
        _mint(destination, 1000000);
    }

    /*this function will check to the account address passed in against the
     * admins list and return a bool
     */
    function isAdmin(address account) public view returns (bool) {
        bool accountAdmin = false;
        for (uint i = 0; i < _admins.length; i++) {
            if (_admins[i] == account) accountAdmin = true;
        }
        return accountAdmin;
    }

    /*this function will add the account address passed in to the admins list
     * must be an admin to use
     */
    function addAdmins(address account) public {
        require((isAdmin(msg.sender)), "Sorry, only admins can add");
        _admins.push(account);
    }

    /*this function will add the account address passed in to the Blocked list
     * must be an admin to use
     */
    function addBlockList(address account) public {
        require(
            (isAdmin(msg.sender)),
            "Sorry, only admins can add to the blocked list"
        );
        _blockList.push(account);
    }

    /*this function will check to the account address passed in against the
     * blockedlist and return a bool
     */
    function isBlocked(address account) public view returns (bool) {
        bool accountBlocked = false;
        for (uint i = 0; i < _blockList.length; i++) {
            if (_blockList[i] == account) accountBlocked = true;
        }
        return accountBlocked;
    }
}
