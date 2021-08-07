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
    
    @AppStorage("Mnemonic") var Mnemonic = ""
    
    @AppStorage("Password") var Password = ""
    
    @ObservedObject var Avplayer = AudioPlayer.sharedInstance
    
    static let sharedInstance = GenWallet()
    
    func createAccount(){
        
        // Create keystore and account with password.
        let mnemonic = try! BIP39.generateMnemonics(bitsOfEntropy: 256)!
        
        let password = "password"
        
        self.Password = password
        
        let keystore = try!BIP32Keystore(mnemonics: mnemonic, password: password, mnemonicsPassword: " ")
        
        
        self.Mnemonic = mnemonic
        
        let account = keystore?.addresses
        
        self.AccountNumber = (account?[0].address)!
        
    }
    
    public func send(){
        
        
        print(Password)
        do{
       //  let contract = Web3.InfuraMainnetWeb3().contract(Web3.Utils.coldWalletABI, at: toAdres, abiVersion: 2)!
        /*
        let value = "0.03"
        let walletAddress = EthereumAddress(AccountNumber)!
        let toAddress = EthereumAddress("0xca1D42E55517197787Be198ED803A3c4c5631E46")!
            */
            let value: String = "1.0" // In Ether
            let walletAddress = EthereumAddress(self.AccountNumber)! // Your wallet address
            let toAddress = EthereumAddress("0xca1D42E55517197787Be198ED803A3c4c5631E46")!
            let contract = Web3.InfuraMainnetWeb3().contract(Web3.Utils.coldWalletABI, at: toAddress, abiVersion: 2)!
             
            let amount = Web3.Utils.parseToBigUInt(value, units: .eth)
            var options = TransactionOptions.defaultOptions
            options.value = amount
            options.from = walletAddress
            options.gasPrice = .automatic
            options.gasLimit = .automatic
            
            
            let tx = contract.write(
            "fallback",
            parameters: [AnyObject](),
            extraData: Data(),
            transactionOptions: options)!
    

                        // @@@ write transaction requires password, because it consumes gas
            let transaction = try tx.send( password: self.Password )
                        
            print("output", transaction.transaction.description as Any)
                    } catch(let err) {
                      print("err", err)
                    }
                
    }
    
    func balance(){
        
        do {
   let web3 = Web3.InfuraMainnetWeb3(accessToken: "667b2befe95f4d0688cbd97afeb386d3")
            
    let address = EthereumAddress(AccountNumber)!
            
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
