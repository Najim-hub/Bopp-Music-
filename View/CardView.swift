//
//  CardView.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-08-08.
//

import SwiftUI

struct CardView: View {
    
    @ObservedObject var dataList = MarketCap.sharedInstance
    
    
    @AppStorage("MarketData") var MarketData: [Wallet] = []
    var body: some View {
        
        ZStack{
            
            NavigationView{
    
            VStack{
                VStack(alignment: .center, spacing: 2) {
                
                Text("Placeholder")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
                Text("Example")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
                
                Text("Example")
                    .font(.body)
                    .foregroundColor(Color(.black))
                
                
            }
        .frame(width:370, height: 300)
       .background(Color.yellow)
        .cornerRadius(20)
        .offset(y: -UIScreen.main.bounds.height/5)
     
        List(MarketData, id: \.symbol) { landmark in
            WalletView(wallinfo: landmark)
                  }
        
        .listStyle(PlainListStyle())
        .offset(y: -UIScreen.main.bounds.height/45)
            
        .onAppear(perform: {
           
          // dataList.getEtherLastPrice()
            
        })
        .onDisappear(perform: {
            
            dataList.getData()
        })
        
                
            }
                
            }
        }
        
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
