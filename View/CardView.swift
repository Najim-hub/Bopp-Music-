//
//  CardView.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-08-08.
//

import SwiftUI

struct CardView: View {
    
    @ObservedObject var dataList = MarketCap.sharedInstance
  
    
    var body: some View {
        
        ZStack{
    
        HStack{
            
            VStack(alignment: .leading, spacing: 2) {
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
            Spacer()
            
        }
        .frame(width:325, height: 200)
        .padding()
        .background(Color.yellow)
        .cornerRadius(20)
        .shadow(radius: 10)
        .offset(y: -UIScreen.main.bounds.height/4)
        
        Spacer()
        
        HStack{
       
     
        List(dataList.MarketData, id: \.symbol) { landmark in
            WalletView(wallinfo: landmark)
                  }
            
        }.onAppear(perform: {
            dataList.getData()
            
            print(dataList.MarketData)
        })
        
    }
        
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
