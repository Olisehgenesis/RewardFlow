// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract RewardFlow is Ownable, ReentrancyGuard {
    IERC20 public cusdToken;

    struct Business {
        address owner;
        uint256 totalSales;
        mapping(address => uint256) customerSpending;
        mapping(address => uint256) customerPoints;
    }

    mapping(address => Business) public businesses;
    mapping(address => bool) public registeredBusinesses;

    event BusinessRegistered(
        address indexed businessAddress,
        address indexed owner
    );
    event Purchase(
        address indexed business,
        address indexed customer,
        uint256 amount,
        uint256 pointsEarned
    );
    event PointsRedeemed(
        address indexed business,
        address indexed customer,
        uint256 points,
        uint256 amount
    );

    constructor(address _cusdTokenAddress) {
        cusdToken = IERC20(_cusdTokenAddress);
    }

    function registerBusiness(address _businessAddress) external {
        require(
            !registeredBusinesses[_businessAddress],
            "Business already registered"
        );

        Business storage newBusiness = businesses[_businessAddress];
        newBusiness.owner = msg.sender;

        registeredBusinesses[_businessAddress] = true;

        emit BusinessRegistered(_businessAddress, msg.sender);
    }

    function makePayment(
        address _businessAddress,
        uint256 _amount
    ) external nonReentrant {
        require(
            registeredBusinesses[_businessAddress],
            "Business not registered"
        );
        require(_amount > 0, "Invalid purchase amount");

        Business storage business = businesses[_businessAddress];

        require(
            cusdToken.transferFrom(msg.sender, _businessAddress, _amount),
            "Transfer failed"
        );

        business.totalSales += _amount;
        business.customerSpending[msg.sender] += _amount;

        // 1 point per dollar (assuming cUSD has 18 decimals)
        uint256 pointsEarned = _amount / 1e18;
        business.customerPoints[msg.sender] += pointsEarned;

        emit Purchase(_businessAddress, msg.sender, _amount, pointsEarned);
    }

    function redeemPoints(
        address _businessAddress,
        address _customer,
        uint256 _points
    ) external nonReentrant {
        require(
            registeredBusinesses[_businessAddress],
            "Business not registered"
        );
        require(
            businesses[_businessAddress].owner == msg.sender,
            "Not the business owner"
        );

        Business storage business = businesses[_businessAddress];
        require(
            business.customerPoints[_customer] >= _points,
            "Insufficient points"
        );

        uint256 redeemAmount = _points * 1e18; // 1 point = 1 cUSD
        require(
            cusdToken.balanceOf(_businessAddress) >= redeemAmount,
            "Insufficient balance for redemption"
        );

        business.customerPoints[_customer] -= _points;
        require(
            cusdToken.transfer(_customer, redeemAmount),
            "Redemption transfer failed"
        );

        emit PointsRedeemed(_businessAddress, _customer, _points, redeemAmount);
    }

    function getCustomerSpending(
        address _businessAddress,
        address _customer
    ) external view returns (uint256) {
        return businesses[_businessAddress].customerSpending[_customer];
    }

    function getCustomerPoints(
        address _businessAddress,
        address _customer
    ) external view returns (uint256) {
        return businesses[_businessAddress].customerPoints[_customer];
    }

    function getCustomerTotalPoints(
        address _customer
    ) external view returns (uint256) {
        uint256 totalPoints = 0;
        for (uint i = 0; i < registeredBusinesses.length; i++) {
            if (registeredBusinesses[i]) {
                totalPoints += businesses[i].customerPoints[_customer];
            }
        }
        return totalPoints;
    }
}
