//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interface/IStakeManager.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// rule is like 100 200 300
// ruleMultiplier mapping is <0, 100>, <100, 200>, <200, 300>, <300, ∞>
// so ruleMultiplier length  == rule length + 1
contract SnapshotCall is Ownable {
    using SafeMath for uint256;
    using EnumerableMap for EnumerableMap.UintToUintMap;
    IStakeManager public stakemanager;

    EnumerableMap.UintToUintMap private rule;
    mapping(uint256 => uint256) public ruleMultiplier;

    constructor(IStakeManager sm) {
        stakemanager = sm;
    }

    //example: _rule = [100, 1000, 10000] _multiplier = [110, 120, 130, 140]
    function setRule(uint256[] memory _rule, uint256[] memory multiplier)
        external
        onlyOwner
    {
        require(_rule.length == multiplier.length.sub(1), "invalid rule");
        uint256 newRuleLength = _rule.length;
        uint256 oldRuleLength = rule.length();
        uint256 i = 0;
        uint256 j = 0;
        for (i; i < oldRuleLength; i++) {
            rule.remove(i);
            delete ruleMultiplier[i];
        }
        delete ruleMultiplier[i];
        for (j; j < newRuleLength; j++) {
            if (i > 0) {
                require(_rule[j] > _rule[j - 1], "rule must be ascending");
            }
            rule.set(j, _rule[j]);
            ruleMultiplier[j] = multiplier[j];
        }
        ruleMultiplier[j] = multiplier[j];
    }

    function getVoteNumber(address staker) public view returns (uint256) {
        uint256 totalVote;
        uint256 totalVoteWithMulti;
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

        uint256 ruleLength = rule.length();
        uint256 i = 0;
        for (i; i < ruleLength; i++) {
            if (totalVote < (rule.get(i)).mul(1e18)) {
                return
                    totalVoteWithMulti = (totalVote.mul(ruleMultiplier[i])).div(
                        100
                    );
            }
        }
        return totalVoteWithMulti = (totalVote.mul(ruleMultiplier[i])).div(100);
    }
}
