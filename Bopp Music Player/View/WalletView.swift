//
//  WalletView.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-08-08.
//

import SwiftUI

import BlockiesSwift



struct WalletView: View {
    
    @ObservedObject var dataList = MarketCap.sharedInstance
    
    var wallinfo: Wallet
    
    var body: some View {
        
        let blockies = Blockies(seed: wallinfo.address)
        let img = blockies.createImage()
        
        HStack() {
            
          VStack(alignment: .leading, spacing: 0){
            HStack(){
            if let myImage = UIImage(named: wallinfo.address) {
        Image(wallinfo.address)
             .resizable()
             .frame(width: 25, height: 25)
           
            .cornerRadius(25)
          
                
                Text(wallinfo.name)
                    .font(Font.custom("HelveticaNeue Bold", size: 15))
                   
            }
            
            else{
                Image(uiImage: img!)
                       .resizable()
                       .frame(width: 25, height: 25)
                       .cornerRadius(25)
                        
                Text(wallinfo.name)
                    .font(Font.custom("HelveticaNeue Bold", size: 15))
                   
                    }
                
            }.padding(.bottom, 10)
          
           
            HStack(spacing: 3)
          {
              Text(String(wallinfo.symbol.filter { !" \n\t\r".contains($0) }))
            
                .foregroundColor(.secondary)
               
                .font(.caption)
                
                Text("|")
                 
                    .foregroundColor(.secondary)
                    .font(.caption)
                
                Text(wallinfo.amount)
                   
                    .foregroundColor(.secondary)
                    .font(.caption)
                
            }
            
          }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 0){
                Text("$\( dataList.returnValue(Symbol: wallinfo.symbol, Amount: Double(wallinfo.rawAmount)!, Name: wallinfo.name))")
            .font(Font.custom("SF Pro", size: 15))
            }
            
            
        }.padding(5)
        
        
        
    }
}

struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
        WalletView(wallinfo:  MarketCap.sharedInstance.MarketData[0])
        WalletView(wallinfo: MarketCap.sharedInstance.MarketData[1])
            
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
