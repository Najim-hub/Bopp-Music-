//
//  ConnectWallet.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-06-15.
//

import SwiftUI
import UIKit
import BigInt
import TrustSDK
import CryptoSwift
import WalletCore


struct ConnectWallet: View {
    
    @State private var showDetails = false
    
    let meta = TrustSDK.SignMetadata.dApp(name: "Test", url: URL(string: "https://dapptest.com"))
    
    let wallet = HDWallet(mnemonic: "ripple scissors kick mammal hire column oak again sun offer wealth tomorrow wagon turn fatal", passphrase: "")
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
                   Button("Sign Transaction")
                   {
                    //TransactionSign()
                      signSimpleEthTx()
                   }
            
        }
    }
    
    func TransactionSign(){
        
        let signerInput = EthereumSigningInput.with {
            $0.chainID = Data(hexString: "01")!
            $0.gasPrice = Data(hexString: "d693a400")! // decimal 3600000000
            $0.gasLimit = Data(hexString: "5208")! // decimal 21000
            $0.toAddress = "0xC37054b3b48C3317082E7ba872d7753D13da4986"
            $0.amount = Data(hexString: "0348bca5a16000")!
            $0.privateKey = wallet.getKeyForCoin(coin: .ethereum).data
        }
        let output: EthereumSigningOutput = AnySigner.sign(input: signerInput, coin: .ethereum)
        print(" data:   ", output.encoded.hexString)
        
    }
    
    func genBinanceAddr(){
        let addressBNB = wallet.getAddressForCoin(coin: .binance)
    }
    
    func signSimpleEthTx() {
        let tx = TrustSDK.Transaction(
            asset: UniversalAssetID(coin: .ethereum, token: ""),
            to: "0xca1D42E55517197787Be198ED803A3c4c5631E46",
            amount: "0.001",
            action: .transfer,
            confirm: .sign,
            from: nil,
            nonce: 447,
            feePrice: "2112000000",
            feeLimit: "21000"
        )
        TrustSDK.Signer(coin: .ethereum).sign(tx) { result in
            print(result)
        }
    }
    
}


struct ConnectWallet_Previews: PreviewProvider {
    static var previews: some View {
        ConnectWallet()
    }
}
