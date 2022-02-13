//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract RandomLottery{

    // Параметры лотереи
    address payable owner;
    address payable winner;
    uint reward = address(this).balance;
    uint token;

    constructor(address payable ownerAddress, uint tokenCost){
        owner = ownerAddress;
        token = tokenCost;
    }

    address[] public players;
    mapping(address => uint) playerBalances;

    /// Switch to true when the lottery ends
    bool ended;

    event LotteryEnded(address winner, uint amount);

    function buyTicket() external payable {

        require(msg.sender.balance >= token, "Sorry, you can not afford the ticket");
        require(reward + msg.value <= 1000 ether, "Sorry, maximum amount of ether is exceeded");
        reward += msg.value;

        if(playerBalances[msg.sender] == 0){
            players.push(msg.sender);
            playerBalances[msg.sender] += msg.value;
        }
    }

    // Using a pseudorandom to determine a winner among the players
    function DetermineWinner() private{
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % reward + 1;
        winner = payable(players[random]);
    }

    function EndLottery() external{

        ended = true;

        uint playerReward = reward/10 * 9;

        uint fee = reward - playerReward;
        emit LotteryEnded(winner, playerReward);

        winner.transfer(playerReward);
        owner.transfer(fee);
    }
}
