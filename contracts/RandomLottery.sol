//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract RandomLottery{

    // Params of the lottery
    address payable owner;
    address payable winner;
    uint reward = address(this).balance;
    uint token;
    uint tokens;
    uint time;

    constructor (uint tokenCost, uint lotteryTime, uint tokenAmount){
        owner = payable(msg.sender);
        token = tokenCost;
        time = lotteryTime + block.timestamp;
        tokens = tokenAmount;
    }

    address[] public players;
    mapping(address => uint) playerBalances;

    /// Switch to true when the lottery ends
    bool ended;

    // Declaring an event for an appropriate ending
    event LotteryEnded(address winner, uint amount);

    function buyTicket() external payable {

        // Next two lines should check if a user can afford the lottery ticket and the lottery is still going.
        require(msg.sender.balance >= token, "Sorry, you can not afford the ticket");
        require(tokens > 0 && time > 0, "Sorry, the lottery is over");
        reward += msg.value;
        tokens -= 1;

        // If a user is already participating in the lottery, this means he's buying additional ticket.
        // In this case, we're gonna add the new ticket price to already collected.
        // Thus player can buy as many tickets as he wants to increase his own chance of winning.
        if(playerBalances[msg.sender] == 0)
            players.push(msg.sender);
        
        playerBalances[msg.sender] += msg.value;
    }

    // Using a pseudorandom to determine a winner among the player
    function DetermineWinner() private{
        /// We must add 1 to make this work, 'cause it goes from 0 to N in programming, but we need an AMOUNT.
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % reward + 1;
        unchecked{
            for(uint i=0; i<players.length; i++){
                if(playerBalances[players[i]]>=random){
                    winner = payable(players[i]);
                    break;
                }
                random -= playerBalances[players[i]];
            }
        }
    }

    function EndLottery() external{

        require(payable(msg.sender) == owner);

        ended = true;

        uint playerReward = reward/10 * 9;
        uint fee = reward - playerReward;

        /// Publicly declaring the winner and his prize.
        emit LotteryEnded(winner, playerReward);

        winner.transfer(playerReward);
        owner.transfer(fee);
    }
}
