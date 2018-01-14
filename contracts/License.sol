pragma solidity ^0.4.11;

contract License {
   address user;
   uint timestamp;

   // Creates the contract
   function License(){
      user = msg.sender;
      timestamp = now; // Timestamp of when contract is made
   }

   // Destroy contract
   function kill(){
      if(msg.sender == user)
         selfdestruct(userId);
   }
}