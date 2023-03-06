// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Shinchan {
    struct People {
        string name;
        address wallet;
    }

    uint private totalPeople;

    People[] public myPeople;

    function addPeople(string memory _name, address _wallet) public {
        totalPeople++;
        myPeople.push(People(_name, _wallet));
    }

    function getTotalPeople() public view returns (uint) {
        return totalPeople;
    }
}
