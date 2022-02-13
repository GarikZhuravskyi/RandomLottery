const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("RandomLottery", function () {
  it("Should return the new greeting once it's changed", async function () {
    const Greeter = await ethers.getContractFactory("RandomLottery");
  });
});
