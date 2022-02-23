const { inputToConfig } = require("@ethereum-waffle/compiler");
const { expect } = require("chai");
const { ethers, waffle } = require("hardhat");
const provider = waffle.provider;

describe("RandomLottery", function () {
  let owner;
  let addr1;
  let addr2;
  let RandomLottery;
  let token;
  let tokens;
  let time;
  let addrss = [];
  let hardhat;

  beforeEach(async function(){

    const RandomLottery = await ethers.getContractFactory("RandomLottery");
    [owner, addr1, addr2, ...addrss] = await ethers.getSigners();
    hardhat = await RandomLottery.deploy(15,3600,3);
  })

  describe("Deployment", function(){

    it("Should set the right owner", async function(){
      expect(await hardhat.owner()).to.equal(owner.address);
    })
  })

  describe("Buying ticket", function(){

    it("Should revert a transaction if a user tries to buy a ticket with lesser price", async function(){

      await expect(hardhat.connect(addr1).buyTicket({value: "10"})).to.be.revertedWith("Sorry, you can not afford the ticket");
      await expect(hardhat.connect(addr1).buyTicket({value: "0"})).to.be.revertedWith("Sorry, you can not afford the ticket");
      await expect(hardhat.connect(addr1).buyTicket({value: "16"})).to.be.revertedWith("Sorry, you can not afford the ticket");
    })

    it("Should revert the transaction if all the tickets are sold", async function(){

      await hardhat.connect(addr1).buyTicket({value:"15"});
      await hardhat.connect(addr1).buyTicket({value:"15"});
      await hardhat.connect(addr1).buyTicket({value:"15"});

      await expect(hardhat.connect(addr1).buyTicket({value: "15"})).to.be.revertedWith("Sorry, bets are off");
    })

    it("Should revert the transaction if the time is over", async function(){

      await network.provider.send("evm_increaseTime", [36000]);
      await expect(hardhat.connect(addr1).buyTicket({value: "15"})).to.be.revertedWith("Sorry, the time is over");
    })

    it("Should check if the contract balance is updating", async function(){

      await hardhat.connect(addr1).buyTicket({value:"15"});
      expect(await provider.getBalance(hardhat.address)).to.be.equal("15");
      await hardhat.connect(addr1).buyTicket({value:"15"});
      expect(await provider.getBalance(hardhat.address)).to.be.equal("30");
    })

    it("Should push the player into in array if he bought the ticket", async function(){

      await hardhat.connect(addr1).buyTicket({value:"15"});
      await hardhat.players.push(addr1);
      expect(hardhat.players.length).to.be.equal(1);
    })
  })
});
