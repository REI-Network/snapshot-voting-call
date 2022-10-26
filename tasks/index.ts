import { task } from "hardhat/config";

task("snapvote", "get stake shares as rei")
  .addParam("address", "staker address")
  .setAction(async function (args, { ethers }) {
    const snapContract = await ethers.getContractAt(
      "SnapshotCall",
      // process.env.CONTRACT_ADDRESS!
      "0x1616abD0FDEf48B58E2a44077a31E603f62d9F73"
    );
    console.log(await snapContract.getVoteNumber(args.address));
    // console.log(await snapContract.ruleMultiplier(0));
    // console.log(await snapContract.ruleMultiplier(1));
    // console.log(await snapContract.ruleMultiplier(2));
  });

task("ownerof", "get owner").setAction(async function (args, { ethers }) {});
