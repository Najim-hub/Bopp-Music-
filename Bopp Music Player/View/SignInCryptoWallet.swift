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
import WKView


struct SignInCryptoWallet: View {
    
    @State private var showingAlert = false
    
    @State private var isSheetPresented = false
    
    @State var showAlertX: Bool = false
    
    @State var show: Bool = false
    
    @ObservedObject var gen = GenWallet.sharedInstance
    
    @AppStorage("AccountNumber") var AccountNumber = ""
    
    @AppStorage("AccountBalance") var AccountBalance = ""
    
    @AppStorage("ValidAddress") var ValidAddress = false
    
    
    
    @ObservedObject var mark = MarketCap.sharedInstance

    var body: some View {
        
        ZStack {
            
            var image = Identicon().icon(from: AccountNumber, size: CGSize(width: 325, height: 325))
            
            if ValidAddress == true{
            
                VStack{
                    
                Text("Setup Ethereum Wallet")
                        .font(.system(size: 25))
                        .fontWeight(.heavy)
                        .offset(y: -90)
                       .accentColor(.accentColor)
                    
                    HStack {
                        
                        Image(systemName: "person").foregroundColor(.gray)
                     TextField("Paste Wallet Address", text: self.$AccountNumber)
                        .frame(width: UIScreen.main.bounds.width/1.5, height: 45, alignment: .center)
                      
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    
                    Text("Notice: This address has to exist in the Etheruem Blockchain")
                        .multilineTextAlignment(.center)
                        .offset(y: 220)
                        .font(.caption)
                    
                    
                    
                    Button(action: {
                        gen.isValid()
                        showingAlert = !ValidAddress
                        
                    }){
                    
                    
                    HStack{
                    
                      Image("Etheruem_")
                       .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 55, height: 55, alignment: .center)
                    .offset(x: -40)
                    
                      Text("Connect Wallet")
                        
                            .font(.system(size: 20))
                            .offset(x: -30)
                            
                            
                   }.frame(width: UIScreen.main.bounds.width/1.5, height: 45, alignment: .center)
                    
                   
                }.padding()
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(15)
                    .alert(isPresented: $showingAlert) { () -> Alert in
                        Alert(title: Text("Please input a valid Address"))
                        
                    }
            
        }.padding(.bottom, 65)
                
            }
            else{
                
                NavigationView {
                
                VStack{
                    
                    Image(uiImage: image!)
                     .resizable()
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.orange, lineWidth: 9))
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
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
                    Button(action: {isSheetPresented.toggle()
                                    }, label: {
                                        
                                        HStack{
                                            Image(systemName: "arrow.triangle.swap")
                                                .resizable()
                                                .frame(width: 35, height: 30)
                                        Text("Swap")
                                            
                                            .font(.title)
                                           
                                        
                                    }
                                        .padding()
                                        .background(Color.yellow)
                                        .cornerRadius(8)
                                        .foregroundColor(.black)
                                    }).sheet(isPresented: $isSheetPresented, content: {
                                        NavigationView {
                                          
                                WebView(url: "https://app.uniswap.org/#/swap?outputCurrency=0xdac17f958d2ee523a2206206994597c13d831ec7&amp;use=V2"
                                            ){ (onNavigationAction) in
                                                switch onNavigationAction {
                                                case .decidePolicy(let webView, let navigationAction, let policy):
                                                    print("WebView -> \(String(describing: webView.url)) -> decidePolicy navigationAction: \(navigationAction)")
                                                    switch policy {
                                                    case .cancel:
                                                        print("WebView -> \(String(describing: webView.url)) -> decidePolicy: .cancel")
                                                        isSheetPresented = false
                                                    case .allow:
                                                        print("WebView -> \(String(describing: webView.url)) -> decidePolicy: .allow")
                                                    @unknown default:
                                                        print("WebView -> \(String(describing: webView.url)) -> decidePolicy: @unknown default")
                                                    }
                                                    
                                                case .didRecieveAuthChallenge(let webView, let challenge, let disposition, let credential):
                                                    print("WebView -> \(String(describing: webView.url)) -> didRecieveAuthChallange challenge: \(challenge.protectionSpace.host)")
                                                    print("WebView -> \(String(describing: webView.url)) -> didRecieveAuthChallange disposition: \(disposition.rawValue)")
                                                    if let credential = credential {
                                                        print("WebView -> \(String(describing: webView.url)) -> didRecieveAuthChallange credential: \(credential)")
                                                    }
                                                    
                                                case .didStartProvisionalNavigation(let webView, let navigation):
                                                    print("WebView -> \(String(describing: webView.url)) -> didStartProvisionalNavigation: \(navigation)")
                                                case .didReceiveServerRedirectForProvisionalNavigation(let webView, let navigation):
                                                    print("WebView -> \(String(describing: webView.url)) -> didReceiveServerRedirectForProvisionalNavigation: \(navigation)")
                                                case .didCommit(let webView, let navigation):
                                                    print("WebView -> \(String(describing: webView.url)) -> didCommit: \(navigation)")
                                                case .didFinish(let webView, let navigation):
                                                    print("WebView -> \(String(describing: webView.url)) -> didFinish: \(navigation)")
                                                case .didFailProvisionalNavigation(let webView, let navigation, let error):
                                                    print("WebView -> \(String(describing: webView.url)) -> didFailProvisionalNavigation: \(navigation)")
                                                    print("WebView -> \(String(describing: webView.url)) -> didFailProvisionalNavigation: \(error)")
                                                case .didFail(let webView, let navigation, let error):
                                                    print("WebView -> \(String(describing: webView.url)) -> didFail: \(navigation)")
                                                    print("WebView -> \(String(describing: webView.url)) -> didFail: \(error)")
                                                }
                                            }
                                            
                                        }
                                        
                                    }).offset(y: -UIScreen.main.bounds.height/8)
                
                           
               }
                .onAppear(perform: {
                    gen.balance()
                    mark.getData()
                   
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
