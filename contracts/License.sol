pragma solidity ^0.4.11;

contract License {
/***/

      // This is a mapping that works like a dictionary or associated array in other languages.
      mapping (address => bytes32[]) licenses;

      // This registers an event
      event Transfer(
                  address indexed _from,
                  address indexed _to,
                  bytes32 license,
                  string timeIssued,
                  string timeExpiration,
                  uint amount
      );

      // The contract constructor, which is called when the contract is deployed to the blockchain. 
      // The contract is persistent on the blockchain, so it remains until it is removed.
      function License( bytes32[] aLicenses ) {
            if (aLicenses.length != 0) {
                  licenses[tx.origin] = aLicenses;
            }
        }

      // This method modifies the blockchain. The sender is required to fuel the transaction in Ether.
      // only here, code to modify the chain
      /**
      *  receiver - address of the receiver who is receiving the license key
      *  license - key of the license
      *  timeIssued - issue time of the license in YYYYMMDD
      *  timeExpiration - expieration time of the license in YYYYMMDD
      *  amount - number of license keys 
       */
      function issueLicense(address receiver, bytes32 license, string timeIssued, string timeExpiration, uint amount) returns(bool sufficient) {
            licenses[receiver].push(license);
            Transfer(msg.sender, receiver, license, timeIssued, timeExpiration, amount); //opens the listener for the event, triggers the event
            return true;
      }
      // This method does not modify the blockchain, so it does not require an account to fuel for the call.
      function getLinceses(address addr) returns(bytes32[]) {
            return licenses[addr];
      }
}