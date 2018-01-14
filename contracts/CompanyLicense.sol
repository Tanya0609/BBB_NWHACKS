//pragma solidity ^0.4.11;
pragma experimental ABIEncoderV2;

contract CompanyLicense {

      struct License {
            uint256 licenseKey;
            uint256 timeIssued;
            uint256 timeExpiration;
      }
      // This is a mapping that works like a dictionary or associated array in other languages.
      mapping (address => License[]) licenses;

      // This registers an event
      event Transfer(
            address indexed _from,
            address indexed _to,
            uint amount
      );

      // The contract constructor, which is called when the contract is deployed to the blockchain.
      // The contract is persistent on the blockchain, so it remains until it is removed.
      address public sender;

      function CompanyLicense(uint256[] aLicenseKeys, address companyKey){
            sender = companyKey;
            if (aLicenseKeys.length > 0) {
                    for (uint i= 0; i < aLicenseKeys.length; i++) {
                        licenses[companyKey].push(License({
                        licenseKey: aLicenseKeys[i],
                         timeIssued : 0,
                          timeExpiration : 0
                          }));
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
      *
      *
      */
      function issueLicenses(address receiver, uint amount) public returns(bool sufficient) {
            uint oneLicense;
            if (amount > 0 && licenses[sender].length >= amount) {
                oneLicense = licenses[sender].length-1;
                  for (uint i = 0; i < amount; i++) {
                    licenses[receiver].push(License({
                      licenseKey: licenses[sender][oneLicense].licenseKey,
                      timeIssued : block.timestamp,
                      timeExpiration : block.timestamp + 30*24*60*60 //unit for timestamp is seconds
                      }));
                      delete licenses[sender][oneLicense];
                      licenses[sender].length--;
                  }

                  Transfer(msg.sender, receiver, amount); //opens the listener for the event, triggers the event
                  return true;
            }
      }

      // This method does not modify the blockchain, so it does not require an account to fuel for the call.
      // notes: return an array of struct only valid when the function is internal
      function getLicenses(address addr) internal returns(License[]) {
            return licenses[addr];
      }

      // Check the validity of the license via time expiration stamps
      function checkLicenseExpiration(address addr) returns(bool licenseValid) {
            if(licenses[addr].length >0){
              for(uint i = 0; i < licenses[addr].length; i++) {
                  if(licenses[addr][i].timeExpiration >= block.timestamp && licenses[addr][i].timeIssued <= block.timestamp){
                      return true;
                  }else{
                      return false;
                  }
            }
      }

    }
}
