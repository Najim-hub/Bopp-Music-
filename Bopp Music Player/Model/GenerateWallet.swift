//
//  GenerateWallet.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-08-03.
//

import Foundation
import WebKit
import Firebase
import web3swift
import SwiftUI

class GenWallet : ObservableObject {
    
    @AppStorage("AccountNumber") var AccountNumber = ""
    
    @AppStorage("AccountBalance") var AccountBalance = ""
    
    @AppStorage("ValidAddress") var ValidAddress = false
    
    @AppStorage("walletConnected") var walletConnected = false
    
    @ObservedObject var Avplayer = AudioPlayer.sharedInstance
    
    static let sharedInstance = GenWallet()
    
    
    public func send(){
       
    }
    
    func isValid(){
        
        
        guard let addr = EthereumAddress(self.AccountNumber) else {
            
        //self.AccountNumber = ""
        ValidAddress = false
        
            walletConnected = false
        print("False Address, ", AccountNumber)
               return
           }
        
        print(AccountNumber)
        ValidAddress = true
        walletConnected = true
        print("True Address")
        
    }
    /*
    func getFullTransaction(){
     
            let response = await fetch("https://api.etherscan.io/api?module=account&action=txlist&address=" + address + "&startblock=0&page=1&offset=10&sort=asc");
            let data = await response.json();

            return data.result[0].blockNumber;
        

        // Given an address and a range of blocks, query the Ethereum blockchain for the ETH balance across the range
      
            // Number of points to fetch between block range
            var pointCount = 50;

            // Calculate the step size given the range of blocks and the number of points we want
            var step = Math.floor((endBlock - startBlock) / pointCount)
            // Make sure step is at least 1
            if (step < 1) {
                step = 1;
            }

            // Store the final result here
            var balances = []

            // Loop over the blocks, using the step value
            for (let i = startBlock; i < endBlock; i = i + step) {
                // Get the ETH value at that block
                let wei = await promisify(cb => web3.eth.getBalance(address, i, cb));
                let ether = parseFloat(web3.fromWei(wei, 'ether'))
                // Add result to final output
                balances.push({
                    block: i,
                    balance: ether
                });
            }

       

    }*/
    
    func balance(){
        
        do {
   let web3 = Web3.InfuraMainnetWeb3(accessToken: "667b2befe95f4d0688cbd97afeb386d3")
            
           // AccountNumber =   "0x7a27a20f6a489882700db0c86be063f12a4f6bf2"
            
            guard let address = EthereumAddress(AccountNumber) else {
              
                print("Empty!")
                       return
                   }
            
    let balance = try web3.eth.getBalance(address: address)
            
    let balanceString = Web3.Utils.formatToEthereumUnits(balance, toUnits: .eth, decimals: 5)
            
      
            AccountBalance = balanceString!
            
            print(balanceString ?? " ")
            
            print("BALANCEEEE")
        }
        
        catch let errors {
            print(errors)
            print("Unable to get Balance")
        }
        
    }
 
    init(){}
   
}
