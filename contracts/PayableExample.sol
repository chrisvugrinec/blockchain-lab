pragma solidity ^0.4.15;

contract TestConcert{

   address owner;
   uint public tickets;
   uint constant price = 1 ether;
   mapping (address => uint) public purchasers;


    function TestConcert(){
        owner = msg.sender;
        tickets = 5;
    }

    event log(string message);

    function() payable{
        
        buyTickets(1);
    }

    function buyTickets(uint amount) payable {
       if(msg.value != (amount * price) || amount > tickets) {
          log("test");
        }

        purchasers[msg.sender] += amount;
        tickets -= amount;

        if(tickets == 0){
           selfdestruct(owner);
        }
    }

}
