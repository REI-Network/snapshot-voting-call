import { ethers } from "hardhat";

async function main() {
  const deployer = (await ethers.getSigners())[0].address;
  const chainId = (await ethers.provider.getNetwork()).chainId;
  console.log(`deployer address is ${deployer}, chainId is ${chainId}`);
  const snapShotCall = await ethers.getContractFactory("SnapshotCall");
  const snapshotcall = await snapShotCall.deploy(
    "0x0000000000000000000000000000000000001001"
  );
  const snap = await snapshotcall.deployed();
  console.log("snapshotCall is depolyed at address", snap.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
