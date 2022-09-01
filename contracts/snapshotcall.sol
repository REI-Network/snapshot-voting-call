//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interface/IStakeManager.sol";

contract SnapshotCall {
    IStakeManager public stakemanager;

    constructor(IStakeManager sm) {
        stakemanager = sm;
    }

    function getVoteNumber(address staker) public view returns (uint256) {
        uint256 totalVote;
        uint256 validatorLength = stakemanager.activeValidatorsLength();
        for (uint256 index = 0; index < validatorLength; index++) {
            (address validator, ) = (stakemanager.activeValidators(index));
            (, address sharesAddress, , ) = stakemanager.validators(validator);
            uint256 stakerBalance = IERC20(sharesAddress).balanceOf(staker);
            if (stakerBalance > 0) {
                totalVote += stakemanager.estimateSharesToAmount(
                    validator,
                    stakerBalance
                );
            }
        }
        return totalVote;
    }
}
