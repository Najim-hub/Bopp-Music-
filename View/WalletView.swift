//
//  WalletView.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-08-08.
//

import SwiftUI

struct WalletView: View {
    
    var wallinfo: Wallet
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 3)
      {
            Text(wallinfo.symbol)
            .font(.headline)
            
            Text(wallinfo.amount)
            .font(.caption)
            .foregroundColor(.secondary)
        }
        
        
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
