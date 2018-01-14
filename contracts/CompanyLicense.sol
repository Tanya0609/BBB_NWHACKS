pragma solidity ^0.4.11;

contract CompanyLicense {

      struct License {
            bytes32 licenseKey;
            uint256 timeIssued;
            uint256 timeExpiration;
      }
      // This is a mapping that works like a dictionary or associated array in other languages.
      mapping (address => License[]) licenses;

      // This registers an event
      event Transfer(
            address indexed _from,
            address indexed _to,
            License[] license,
            uint256 timeIssued,
            uint256 timeExpiration,
            uint amount
      );

      // The contract constructor, which is called when the contract is deployed to the blockchain. 
      // The contract is persistent on the blockchain, so it remains until it is removed.
      function CompanyLicense( bytes32[] aLicenseKeys ) {
            if (aLicenseKeys.length != 0) {
                  for (uint i= 0; i < aLicenseKeys.length; i++) {
                        licenses[tx.origin][i].licenseKey = aLicenseKeys[i];
                  }
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
      function issueLicenses(address receiver, uint amount, uint256 timeIssued, uint256 timeExpiration) returns(bool sufficient) {
            if (amount > 0 && licenses[msg.sender].length >= amount) {
                  License oLicenseToUser;
                  for (uint i = 0; i < amount; i++) {
                        oLicenseToUser = licenses[msg.sender][licenses[msg.sender].length-1];
                        delete licenses[msg.sender][licenses[msg.sender].length-1];
                        licenses[msg.sender].length--;
                        licenses[receiver].push(oLicenseToUser);
                  }
                  
                  Transfer(msg.sender, receiver, licenses[receiver], timeIssued, timeExpiration, amount); //opens the listener for the event, triggers the event
                  return true;
            }
      }

      // This method does not modify the blockchain, so it does not require an account to fuel for the call.
      function getLicenses(address addr) returns(License[]) {
            return licenses[addr];
      }
/*
      // Check the validity of the license via time expiration stamps
      function checkLicense(address addr) returns(bytes32[]) {
            License license = 
      }
      */
}