contract VulnarableFundraiser{

   mapping(address=>uint) balances;

   // VULNERABLE
   function withdrawAllMyCoins(){
      // send back funds to the msg.sender

      uint withdrawAmount = balances[msg.sender];
      MaliciousWallet wallet = MaliciousWallet(msg.sender);
      wallet.payout(withdrawAmount);

      // Dit is de vulnerability......eerst moet balans gedaan worden en dan pas payout!!!
      balance[msg.sender] = 0;
   }


   function getBalance() constant returns(uint){
      return this.balance;
   }

   function contribute() payable{
      balances[msg.sender] = msg.value;
   }

   function() payable{ 
   }
}
