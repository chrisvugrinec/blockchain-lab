pragma solidity ^0.4.0;

/*
    Title: SimpleLottery
    Author: Chris Vugrinec
    Description: Simple demo (not for production) showing you how to create a simple smart contract
                 with basic transactions, like deducting Ether from your wallet and adding that to the (smart) contract.
                 In the end you can always win your eth back of course...only test this on one of the test networks

*/
contract SimpleLottery {

    uint256 nrOfTickets;
    uint ticketsSold;
    bytes32 test;
    bool lotteryWon;
    uint timesDrawn;
    WinningLotteryClient[] winners;
    mapping (address => uint) balances;


    modifier noWinnerDrawnYet() {
        require(soldLotteryNumbers.length == nrOfTickets);
        require(!lotteryWon);
        _;
    }

    modifier ticketsAvailable() {
        require(ticketsSold < nrOfTickets);
        _;
    }


    struct LotteryClient {
        string name;
        uint lotteryNumber;
        address clientAddress;
    }

    struct WinningLotteryClient {
        string name;
        uint ticketNr;
        uint price;
    }

    uint[] private unsoldLotteryTickets;
    LotteryClient[] private soldLotteryNumbers;
    
    function showWinners() public constant returns(WinningLotteryClient[]){
        return winners;
    }

    function SimpleLottery(uint _nrOfTickets)  public payable{
        nrOfTickets = _nrOfTickets;
        ticketsSold = 0;
        timesDrawn = 0;
        lotteryWon = false;

        // Initialize the unsoldLotteryNumbers with a Lottery Number
        for (uint i=1; i<=nrOfTickets; i++){
              unsoldLotteryTickets.push( randomLotteryNumber(i));
        }
    }
    
    function showContractEth() constant public returns (uint){
        return balances[this];
    }


    function buyTicket(string _name) public ticketsAvailable payable{
        
        //  Ticket price is 1 ether
        if(msg.value != 1 ether){
            revert();
        }else{
    
            uint ticketNumber = unsoldLotteryTickets[ticketsSold];
            delete unsoldLotteryTickets[ticketsSold];
            ticketsSold += 1;
            
            //test = block.blockhash(block.number);
            soldLotteryNumbers.push( LotteryClient(_name, ticketNumber,msg.sender));
            logTicketBuy(_name," has bought a ticket with lotteryticketnr: ",ticketNumber);
            
            // Add money to pricemoney
            balances[this] += msg.value;

        }
    }
    
    function() payable public{
    }


    //  Only draw when all tickets are sold and no winner yet ..hence the required modifier
    function getWinner() public noWinnerDrawnYet payable{


        // Draw lucky winner:
        uint winningNumber = randomLotteryNumber(block.number);

        //  Iterate over all users until winningNumber is
        //  owned by 1 or more users
        for(uint i=0; i<soldLotteryNumbers.length; i++){

            //  If user has winning number add to tmpArray of winningNames
            //  Contratz
            if(soldLotteryNumbers[i].lotteryNumber == winningNumber){

                logWinMessage("we have a winner for this ticketNumber ",winningNumber, " the Eth addres is: ", soldLotteryNumbers[i].clientAddress );

                winners.push(WinningLotteryClient(soldLotteryNumbers[i].name, soldLotteryNumbers[i].lotteryNumber,showContractEth()));
                lotteryWon=true;
            }
        }
        if( lotteryWon ){
            //  Divide price and change state
            uint nrOfWinners = winners.length;
            uint price = showContractEth()/nrOfWinners;
            for(uint j=0; j<nrOfWinners; j++){
                logWinnerMessage(winners[j].name," wins pricemoney ",price, " with ticketnr: ", winners[j].ticketNr);
                balances[this] -= price;
                balances[soldLotteryNumbers[j].clientAddress] += price;
                //  Sending the actual ether to the wallets
                soldLotteryNumbers[j].clientAddress.transfer(price);
            }
        }else{
            timesDrawn++;
            logNobodyWinsMessage("Redraw needed: nobody has this winning ticketnr, :", winningNumber, " times drawn: ",timesDrawn);
        }
    }
    
    //  Events : message with calling interface
    event logTicketBuy(string message, string message2, uint ticketNr);
    event logNobodyWinsMessage(string message, uint ticketNr,string message2, uint timesDrawnNr);
    event logWinMessage(string message, uint ticketNr, string message2, address addr);
    event logWinnerMessage(string message, string submessage, uint price, string submessage2, uint ticketNr);


    function randomLotteryNumber(uint seed) private constant returns (uint randomNumber) {
            return(uint(keccak256(block.blockhash(block.number-1), seed ))%10);
    }

}

