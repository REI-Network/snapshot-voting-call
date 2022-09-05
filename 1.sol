pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

/**
 * @dev `Unstake` records the information of each unstake request.
 */
struct Unstake {
    // validator address
    address validator;
    // REI receiver address
    address payable to;
    // number of shares
    uint256 unstakeShares;
    // release timestamp
    uint256 timestamp;
}

/**
 * @dev `Validator` records the information of each validator.
 */
struct Validator {
    // validator unique id
    uint256 id;
    // commission share contract address
    address commissionShare;
    // commission rate
    uint256 commissionRate;
    // latest commission rate update timestamp
    uint256 updateTimestamp;
}

/**
 * @dev `ActiveValidator` records the information of each active validator,
 *      it will be updated by system in `StakeManager.afterBlock`.
 */
struct ActiveValidator {
    // validator address
    address validator;
    // proposer priority
    int256 priority;
}

/**
 * @dev see {StakeManager}
 */
interface IStakeManager {
    function validatorId() external view returns (uint256);

    function validators(address validator)
        external
        view
        returns (
            uint256,
            address,
            uint256,
            uint256
        );

    function unstakeId() external view returns (uint256);

    function unstakeQueue(uint256 id)
        external
        view
        returns (
            address,
            address payable,
            uint256,
            uint256
        );

    function totalLockedAmount() external view returns (uint256);

    function activeValidators(uint256 index)
        external
        view
        returns (address, int256);

    function indexedValidatorsLength() external view returns (uint256);

    function indexedValidatorsExists(uint256 id) external view returns (bool);

    function indexedValidatorsByIndex(uint256 index)
        external
        view
        returns (address);

    function indexedValidatorsById(uint256 id) external view returns (address);

    function getVotingPowerByIndex(uint256 index)
        external
        view
        returns (uint256);

    function getVotingPowerById(uint256 index) external view returns (uint256);

    function getVotingPowerByAddress(address validator)
        external
        view
        returns (uint256);

    function getTotalLockedAmountAndValidatorCount(address[] calldata excludes)
        external
        view
        returns (uint256, uint256);

    function activeValidatorsLength() external view returns (uint256);

    function estimateSharesToAmount(address validator, uint256 shares)
        external
        view
        returns (uint256);

    function estimateAmountToShares(address validator, uint256 amount)
        external
        view
        returns (uint256);

    function estimateUnstakeAmount(address validator, uint256 shares)
        external
        view
        returns (uint256);

    function stake(address validator, address to)
        external
        payable
        returns (uint256);

    function startUnstake(
        address validator,
        address payable to,
        uint256 shares
    ) external returns (uint256);

    function startClaim(address payable to, uint256 amount)
        external
        returns (uint256);

    function setCommissionRate(uint256 rate) external;

    function unstake(uint256 id) external returns (uint256);

    function removeIndexedValidator(address validator) external;

    function addIndexedValidator(address validator) external;

    function reward(address validator) external payable;

    function slash(address validator, uint8 reason) external returns (uint256);

    function onAfterBlock(
        address _proposer,
        address[] calldata acValidators,
        int256[] calldata priorities
    ) external;
}

pragma solidity ^0.8.0;

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
