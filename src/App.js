import React, { Component } from 'react'
import SimpleStorageContract from '../build/contracts/SimpleStorage.json'
import getWeb3 from './utils/getWeb3'

import './css/oswald.css'
import './css/open-sans.css'
import './css/pure-min.css'
import './App.css'

class App extends Component {
/*
  constructor(props) {
    super(props)

    this.state = {
      storageValue: 0,
      web3: null
    }
  }
*/
  constructor(props){
  super(props)
  this.state = {}
  var Web3 = require("web3");

  const contract = require('truffle-contract')

  var account1 = "0x0279Ef4619c0382369581b9cA539E61DD437b3c0"; //receiver
  var contractAddress = "0x79df76615db516b4fddebd58bbd393f670616b56"; //contract address from Remix


 this.web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
  const myCoinContract = contract([
  {
    "constant": true,
    "inputs": [],
    "name": "sender",
    "outputs": [
      {
        "name": "",
        "type": "address"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "name": "_from",
        "type": "address"
      },
      {
        "indexed": true,
        "name": "_to",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "amount",
        "type": "uint256"
      }
    ],
    "name": "Transfer",
    "type": "event"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "addr",
        "type": "address"
      }
    ],
    "name": "checkLicenseExpiration",
    "outputs": [
      {
        "name": "licenseValid",
        "type": "bool"
      }
    ],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "receiver",
        "type": "address"
      },
      {
        "name": "amount",
        "type": "uint256"
      }
    ],
    "name": "issueLicenses",
    "outputs": [
      {
        "name": "sufficient",
        "type": "bool"
      }
    ],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "name": "aLicenseKeys",
        "type": "uint256[]"
      },
      {
        "name": "companyKey",
        "type": "address"
      }
    ],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "constructor"
  }
])
myCoinContract.setProvider(this.web3.currentProvider);
// myCoinContract.deployed().then(instance=>{
//   this.myCoinInstance = instance;
// })
 this.myCoinInstance = myCoinContract.at(contractAddress);

}

transaction(){
  var transferEvent = this.myCoinInstance.Transfer( {}, {fromBlock: 0, toBlock: 'latest'});
  this.myCoinInstance.issueLicenses(this.input.value, this.input2.value);
}

  render() {
    return (
      <div className="App">
        <nav className="navbar pure-menu pure-menu-horizontal">
            <a href="#" className="pure-menu-heading pure-menu-link">Truffle Box</a>
        </nav>

        <main className="container">

              <h1>License Issue for Customer</h1>
              <div>
                <input
                  placeholder="User Public Key"
                  ref={(input)=>this.input=input} />
                <input
                  placeholder="amount of licenses"
                  ref={(input)=>this.input2=input} />
                <button onClick={()=>this.transaction()}>Issue License</button>
             </div>

              <div>
                <h4>Check if the user has valid licenses</h4>
                <input
                  placeholder="User Public Key"
                  ref={(input)=>this.input3=input} />
                <button onClick={()=>this.myCoinInstance.checkLicenseExpiration(this.input3.value)}>Licenses Check</button>
              </div>
        </main>
      </div>
    );
  }
}
export default App
