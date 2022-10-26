import { ethers } from "hardhat";

async function main() {
  const deployer = (await ethers.getSigners())[0].address;
  console.log(`deployer address is ${deployer}`);
  const snapshot = await ethers.getContractAt(
    "SnapshotCall",
    "0xde2c8d2A1BA896Da81ECe706bac5Fa0dfE6BFBe0"
  );
  const tx = await snapshot.setRule([1, 2], [100, 110, 120]);
  await tx.wait();
  console.log("setRule is called", tx.hash);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
