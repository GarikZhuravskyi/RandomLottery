const { expect } = require("chai");
const { ethers } = require("hardhat");

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
    RandomLottery = await ethers.getContractFactory("RandomLottery");
    [owner, addr1, addr2, ...addrss] = await ethers.getSigners();
    hardhat = await RandomLottery.deploy(); 
  })

  describe("Deployment", function(){
    it("Should set the right owner", async function(){
      expect(await hardhat.owner()).to.equal(owner.address);
    })
  })
});
