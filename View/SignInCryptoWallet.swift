//
//  SignInCryptoWallet.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-06-21.
//

import SwiftUI

struct SignInCryptoWallet: View {
    
    @State private var showingAlert = false

    var body: some View {
        
        VStack{
            
            /*
            Image("Big")
                .cornerRadius(75)
                .offset(y: -90)*/
            
        Text("Connect Your Wallet")
                .font(.system(size: 35))
                .fontWeight(.heavy)
                .offset(y: -90)
            
            Text("You can not change or modify your wallet\n once registered")
                .multilineTextAlignment(.center)
                .offset(y: -40)

        Button(action: {showingAlert = true}){
            
            
            HStack{
            
              Image("metamask")
               .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 95, height: 95, alignment: .center)
            .offset(x: -50)
            
              Text("MetaMask")
                    .font(.system(size: 25))
                    .fontWeight(.heavy)
                    .offset(x: -40)
                    
           }
            .frame(width: UIScreen.main.bounds.width/1.5, height: 45, alignment: .center)
            
           
          
            
        }.padding()
                .background(Color.yellow)
            .foregroundColor(.black)
            .cornerRadius(15)
            .alert(isPresented: $showingAlert) { () -> Alert in
                        Alert(title: Text("Currently Unavailable"))
        
    }
            
            
            Button(action: { showingAlert = true}){
                
                
            
            HStack{
            
              Image("TWT")
               .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 55, height: 95, alignment: .center)
            .offset(x: -40)
            
              Text("TrustWallet")
                    .font(.system(size: 25))
                    .fontWeight(.heavy)
                    .offset(x: -20)
                    
            }
            .frame(width: UIScreen.main.bounds.width/1.5, height: 45, alignment: .center)
        }.padding()
                .background(Color.yellow)
                .foregroundColor(.black)
                .cornerRadius(15)
                .offset(y: 25)
                .alert(isPresented: $showingAlert) { () -> Alert in
                            Alert(title: Text("Currently Unavailable"))
            
        }
            
            
            Text("By tapping ")
                .multilineTextAlignment(.center)
        }
        
    }
}

struct SignInCryptoWallet_Previews: PreviewProvider {
    static var previews: some View {
        SignInCryptoWallet()
    }
}
