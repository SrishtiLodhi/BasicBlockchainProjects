// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

contract crowdFunding {

    mapping(address=>uint) public contributors;
    address public manager;
    uint public minimumContribution;
    uint public target;
    uint public deadline;
    uint public noOfContributors;
    uint public raisedAmount;

    constructor(uint _target, uint _deadline) {
        target = _target;
        deadline = block.timestamp + _deadline;
        minimumContribution = 100 wei;
        manager = msg.sender;
    }

    function sendEth() public payable {
        require(block.timestamp < deadline, "Deadline has passed");
        require(msg.value >= minimumContribution, "Minimum contribution limit is not met");
        if(noOfContributors == 1) {
            noOfContributors++;
        }
        contributors[msg.sender] += msg.value;
        raisedAmount += msg.value;
    } 

    function getContractBalance() public view returns(uint) {
        return address(this).balance;
    }
}
