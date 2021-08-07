//
//  SignInCryptoWallet.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-06-21.
//

import SwiftUI
import Foundation
import AlertX
import IGIdenticon

struct SignInCryptoWallet: View {
    
    @State private var showingAlert = false
    
    @State var showAlertX: Bool = false
    
    @ObservedObject var gen = GenWallet.sharedInstance
    
    @AppStorage("AccountNumber") var AccountNumber = ""
    
    @AppStorage("AccountBalance") var AccountBalance = ""
    
    @AppStorage("Mnemonic") var Mnemonic = ""
    
    

    var body: some View {
        
        ZStack {
            
            var image = Identicon().icon(from: AccountNumber, size: CGSize(width: 325, height: 325))
            
            if AccountNumber == ""{
        
        VStack{
            
        Text("Create Your Wallet")
                .font(.system(size: 35))
                .fontWeight(.heavy)
                .offset(y: -90)
                 .accentColor(.yellow)
            
            Text("You can not change or modify your wallet\n once registered")
                .multilineTextAlignment(.center)
                .offset(y: -40)

            Button(action: {gen.createAccount()}){
            
            
            HStack{
            
              Image("Etheruem_")
               .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 75, height: 65, alignment: .center)
            .offset(x: -40)
            
              Text("Create Wallet")
                    .font(.system(size: 25))
                    .fontWeight(.heavy)
                    .offset(x: -40)
                    
                    
           }.frame(width: UIScreen.main.bounds.width/1.5, height: 45, alignment: .center)
            
           
        }.padding()
            .background(Color.yellow)
            .foregroundColor(.black)
            .cornerRadius(15)
            .alert(isPresented: $showingAlert) { () -> Alert in
                        Alert(title: Text("Currently Unavailable"))
        
    }
            Text("By tapping connecting your wallet you accept all our terms and conditions")
                .multilineTextAlignment(.center)
                .offset(y: 70)
                .font(.caption)
            
        }.padding(.bottom, 65)
                
            }
            else{
                
                NavigationView {
                
                VStack{
                    
                    Image(uiImage: image!)
                     .resizable()
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.orange, lineWidth: 9))
                        .overlay(Circle().stroke(Color.primary, lineWidth: 2))
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 225, height: 225, alignment: .center)
                   .offset(y:  -UIScreen.main.bounds.height/6)
                     
                    Button(action: {
                        
                  UIPasteboard.general.string = self.AccountNumber
                        
                   self.showAlertX = true
                        
                  print("Copied to Clipboard")
                        
                    }){
                        Text(self.AccountNumber)
                        .font(.system(size: 15))
                        .fontWeight(.heavy)
                            .truncationMode(.middle)
                            .lineLimit(2)
                            .padding(5)
                            .accentColor(.black)
                            .frame(width: 120)
                            .background(Color.yellow)
                            .cornerRadius(60)
                           
                          
                        
                    }.offset(y: -UIScreen.main.bounds.height/7)
                    .alertX(isPresented: $showAlertX, content: {
                        AlertX(title: Text("Copied to clipboard"),
                                primaryButton: .cancel(),
                    
                                theme:.graphite(withTransparency: true, roundedCorners: true),
                                animation: .classicEffect()
                        
                        )

                    })
                   
                 Spacer()
                   
                    Button(action: {gen.send()}) {
                      
                        
                            
                            Text("Send ETH")
                                .fontWeight(.semibold)
                                .font(.title)
                                .padding()
                                .background(Color.yellow)
                                .cornerRadius(8)
                                .foregroundColor(.black)
                            
                            
                       
                    }.offset(y: -UIScreen.main.bounds.height/8)
                    //.shadow(color: Color.yellow, radius: 10, y: 2)
                   
                        
               }
                .onAppear(perform: {
                    gen.balance()
                    print( Mnemonic)
                })
                .frame(width: UIScreen.main.bounds.width/1.5, height: 45, alignment: .center)
                .navigationBarTitle( Text("Wallet") , displayMode: .automatic)
                .navigationBarItems(trailing:
                                        HStack{
                 Image("Etheruem_")
                        .resizable()
                    .frame(width: 25, height: 25, alignment: .center)
                                            
                        
                                Text(AccountBalance + " ETH")
                                      .font(.system(size: 25))
                                      .fontWeight(.light)
                                    
                                        }
                          
                    )
                
                }
                
                
            }
            
            
        }
        
    }
    
    
}


struct SignInCryptoWallet_Previews: PreviewProvider {
    static var previews: some View {
        SignInCryptoWallet()
    }
}
