// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.27;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockTRONUSDT is ERC20 {
    constructor() ERC20("Tether USD", "USDT") {}

    function name() public pure override returns (string memory) {
        return "Tether USD";
    }

    function symbol() public pure override returns (string memory) {
        return "USDT";
    }

    function decimals() public pure override returns (uint8) {
        return 6;
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    uint256 public feeBps;

    function setFeeBps(uint256 feeBps_) external {
        feeBps = feeBps_;
    }

    // Override transfer to return false on success to mimic TRON USDT
    function transfer(address to, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, to, amount);
        return false;
    }

    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        if (feeBps > 0) {
            uint256 fee = (amount * feeBps) / 10000;
            _spendAllowance(from, msg.sender, amount);
            _transfer(from, to, amount - fee);
            return true;
        }
        return super.transferFrom(from, to, amount);
    }
}
