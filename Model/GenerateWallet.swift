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
    
    
    @ObservedObject var Avplayer = AudioPlayer.sharedInstance
    
    static let sharedInstance = GenWallet()
    
    
    public func send(){
       
    }
    
    func isValid(){
        
        
        guard let addr = EthereumAddress(self.AccountNumber) else {
            
       // self.AccountNumber = ""
        
        self.ValidAddress = false
        
        
        print("False Address, ", AccountNumber)
               return
           }
        
        print(AccountNumber)
        self.ValidAddress = true
        print("True Address")
        
    }
    
    func balance(){
        
        do {
   let web3 = Web3.InfuraMainnetWeb3(accessToken: "667b2befe95f4d0688cbd97afeb386d3")
            
            guard let address = EthereumAddress(AccountNumber) else {
              
                print("Empty!")
                       return
                   }
            
    let balance = try web3.eth.getBalance(address: address)
      
    let balanceString = Web3.Utils.formatToEthereumUnits(balance, toUnits: .eth, decimals: 5)
            
      
            self.AccountBalance = balanceString!
            
            print(balanceString ?? " ")
            
            
        }
        
        catch let errors {
            print(errors)
        
        }
        
    }
 
    init(){}
   
}
