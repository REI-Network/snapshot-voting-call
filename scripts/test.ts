import { ethers } from "hardhat";

async function main() {
  const deployer = (await ethers.getSigners())[0].address;
  console.log(`deployer address is ${deployer}`);
  const testcontract = await ethers.getContractFactory("Test");
  const test = await testcontract.deploy();
  await test.deployed();
  console.log("test is depolyed at address", test.address);
  const result = await test.testCall();
  console.log("result is", result);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
