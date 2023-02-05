//SPDX-License-Identifier: Unlicense
pragma solidity >=0.5.0 <0.9.0;

contract EventContract {
 struct Event{
    address organizer;
    string name;
    uint date;
    uint price;
    uint ticketCount;
    uint ticketRemain;
     }

     mapping(uint => Event) public events;
     mapping(address => mapping(uint => uint)) public tickets;
     uint public nextId;

     function createEvent(string memory name, uint date, uint price, uint ticketCount, uint ticketRemain) external {
         require(date > block.timestamp, "You can only organize events for future dates");
         require(ticketCount > 0, "You can organize event only if you have recognizable number of tickets");

         events[nextId] = Event(msg.sender, name, date, price, ticketCount, ticketRemain);
         nextId++;
     }

     function buyTicket(uint id, uint quantity) external payable {
         require(events[id].date != 0,"This Event does not exist");
         require(events[id].date > block.timestamp,"The event has already happened");
         Event storage _event = events[id];
         require(msg.value == (_event.price * quantity),"Ether is not enough");
         require(_event.ticketRemain >= quantity,"Not enough tickets");
         _event.ticketRemain -= quantity;
         tickets[msg.sender][id] += quantity;
     }

     function transferTicket(uint id, uint quantity, address to) external {
         require(events[id].date != 0, "This Event does not exist");
         require(events[id].date > block.timestamp, "The event has already happened");
         require(tickets[msg.sender][id] >= quantity, "You don't have enought tickets");
         tickets[msg.sender][id] -= quantity;
         tickets[to][id] += quantity;
     }
}
