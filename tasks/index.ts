import { task } from "hardhat/config";

task("snapvote", "get stake shares as rei")
  .addParam("address", "staker address")
  .setAction(async function (args, { ethers }) {
    const snapContract = await ethers.getContractAt(
      "SnapshotCall",
      process.env.CONTRACT_ADDRESS!
    );
    console.log(await snapContract.getVoteNumber(args.address));
  });
