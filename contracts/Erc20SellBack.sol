// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9; 

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20God is ERC20 {
    address private _godAccount;

    //create an array for the admin and blockList with a size of 3 to start
    //Can dynamically add using push later
    address[] private _admins;
    address[] private _blockList; 

    address payable public owner;
    
    //First thing is to define who has god privleges in the constructor
    //then we can add them to _admins list as well before _mint
    constructor (address godAccount_, string memory name, string memory symbol) ERC20(name, symbol) payable {
        _godAccount = godAccount_;
        _admins.push(godAccount_);
        owner = payable(msg.sender);
    }

    /*this function will check to the caller to ensure it is the god mode address
    * then it will mint a preset amount (1,000,000) of tokens to address specified
    */ 
    function mintTokensToAddress(address account) public {
        require(msg.sender == _godAccount, "Sorry, you cannot mint tokens"); 
        require(account != address(0), "ERC20: cannot mint to a zero address"); 
        _mint(account, 1000);
    }
    
    /*this function will check to the caller to ensure it is the god mode address
     * this function will change a user's balance by burning user tokens (1,000,000)
     * at the address speficied.   
    */ 
    function changeBalanceAtAddress(address account) public {
        require(msg.sender == _godAccount, "Sorry, you cannot burn tokens"); 
        require(account != address(0), "ERC20: cannot mint to a zero address"); 
        //implement a check to make sure the user has enough tokens 
        _burn(account, 1000);
    }

    /*this function will check to the caller to ensure it is the god mode address
     * then it will transfer a users tokens (1,000,000) to the address specified
    */ 
    function authoritativeTranferFrom(address source, address destination) public {
        require(msg.sender == _godAccount, "Sorry, you cannot xfer tokens"); 
        //implement a check to make sure the user has enough tokens 
        _burn(source, 1000);
        _mint(destination, 1000);
    }

    /*this function will check to the account address passed in against the 
     * admins list and return a bool
    */ 
    function isAdmin(address account) public view returns (bool){
        bool accountAdmin = false; 
        for (uint i=0; i < _admins.length; i++){
            if (_admins[i] == account) 
                accountAdmin = true; 
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
        require((isAdmin(msg.sender)), "Sorry, only admins can add to the blocked list"); 
        _blockList.push(account);
    }

    /*this function will check to the account address passed in against the 
     * blockedlist and return a bool
    */ 
    function isBlocked(address account) public view returns (bool){
        bool accountBlocked = false; 
        for (uint i=0; i < _blockList.length; i++){
            if (_blockList[i] == account) 
                accountBlocked = true; 
        }
        return accountBlocked;
    }

    //allows this contract to accept ether 
    function deposit() public payable{}

    //mint sale - requires 1 ether to mint 1000 tokens
    function depositToMint() public payable {
        require(msg.value >= 1 ether, "You must deposit at least 1 ether to mint");
        require(totalSupply() <= 999000, "Mint Over :( - Total supply has been reach");
        _mint(msg.sender, 1000); 
    }

    //withdraw all funds to the owner account
    function withdraw() external {
        require((isAdmin(msg.sender)), "Only admins can withdraw");
        owner.transfer(address(this).balance);
    }

    //pay users 0.5 eth for every 1000 tokens they transfer 
    function sellBack(uint _sellTokens) public {
        require((address(this).balance) >= (_weiConversion(_sellTokens)), 
            "Smart contract balance not sufficient for sale");
        
        //transfer the ERC20 to the SC
        approve(address(this), _sellTokens);
        _beforeTokenTransfer(msg.sender, address(this), _sellTokens);
        _transfer(msg.sender, address(this), _sellTokens);

        _payUser(payable(msg.sender), _weiConversion(_sellTokens));
    }

    function _payUser(address payable _to, uint amount) private {
        _to.transfer(amount);
    } 

    function _weiConversion(uint _amountTokens) private pure returns (uint){
        return(_amountTokens * (5 * 10**14)); 
    }

    //IERC20 hook 
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);
        //checks before Token Transfer here e.g.  
        require(totalSupply() <= 999000, "Mint Over :( - Total supply has been reach");
    }

    //tester function 
    function getBalance() external view returns (uint){
        return address(this).balance;
    }
}

