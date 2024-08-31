// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract DegenGaming {

    address public admin;
    
    string public tokenName = "Degen";
    string public symbol = "DGN";
    uint public totalSupply = 0;
    
    constructor() {
        admin = msg.sender;
        rewards[0] = Reward("Silver Boots", 4);
        rewards[1] = Reward("Silver Sword", 6);
        rewards[2] = Reward("Name Change Card", 8);
    }
   
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can mint tokens");
        _;
    }
    
    mapping(address => uint256) private balances;
    mapping(uint256 => Reward) public rewards;
    mapping(address => string[]) public redeemedItems;
    
    struct Reward {
        string name;
        uint256 cost;
    }

    function mint(uint256 amount, address recipient) external onlyAdmin {
        require(amount > 0, "Mint amount must be greater than 0");
        totalSupply += amount;
        balances[recipient] += amount;
    }

    function transfer(uint256 amount, address recipient) external {
        require(amount <= balances[msg.sender], "Insufficient balance for transfer");
        balances[recipient] += amount;
        balances[msg.sender] -= amount;
    }

    function burn(uint256 amount) external {
        require(amount <= balances[msg.sender], "Insufficient balance to burn");
        balances[msg.sender] -= amount;
    }

    function checkBalance(address user) external view returns (uint256) {
        return balances[user];
    }

    function redeem(uint256 rewardId) external returns (string memory) {
        require(rewards[rewardId].cost <= balances[msg.sender], "Insufficient balance to redeem");
        require(rewardId >= 0 && rewardId <= 2, "Invalid reward ID");
        
        redeemedItems[msg.sender].push(rewards[rewardId].name);
        balances[msg.sender] -= rewards[rewardId].cost;
        return rewards[rewardId].name;
    }

    function getRedeemedItems(address user) external view returns (string[] memory) {
        return redeemedItems[user];
    }
}
