//
//  CardViewed.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-08-12.
//

import Foundation
import SwiftUI
import Foundation
import AlertX
import IGIdenticon
import WKView
import SystemConfiguration
import Shiny

struct CardViewed: View {
    
    @ObservedObject var dataList = MarketCap.sharedInstance
    @ObservedObject var playController = playControl.sharedInstance
    @State private var showAlert = false
    
    @State var flipped = false
    
    @ObservedObject var gen = GenWallet.sharedInstance
    
    @AppStorage("MarketData") var MarketData: [Wallet] = []
    
    @AppStorage("AccountNumber") var AccountNumber = ""
    
    @AppStorage("AccountBalance") var AccountBalance = ""
    
    @AppStorage("ValidAddress") var ValidAddress = false
    
    @AppStorage("EtherPrice") var EtherPrice: Double = 0
    
    @AppStorage("TotalValue") var TotalValue: String = ""
    
    @AppStorage("Chart") var Chart : [ String ] = []
    
    @State private var showingAlert = false
    
    @State private var isSheetPresented = false
    
    @State var showAlertX: Bool = false
    
    @State var show: Bool = false
    
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.apple.com")
    
    @AppStorage("walletConnected") var walletConnected = false
    
    @AppStorage("currentValue") private var currentValue: Double = 0
    
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("Name") var Name = ""
    
    
 
    var body: some View {
        
       
        ZStack {
            
            if walletConnected == false{
            
                VStack{
                    
                Text("Setup Ethereum Wallet")
                        .font(.system(size: 25))
                        .fontWeight(.heavy)
                        .offset(y: -90)
                       .accentColor(.accentColor)
                    
                    HStack {
                        
                        Image("user")
                            .resizable()
                            .frame(width: 26, height: 26)
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
                        var flags = SCNetworkReachabilityFlags()
                        SCNetworkReachabilityGetFlags(self.reachability!, &flags)
                        
                        if self.isNetworkReachable(with: flags){
                        gen.isValid()
                        showingAlert = !ValidAddress
                            
                        }
                        
                        else{
                            showAlert = true
                        }
                        
                    }){
                    
                    
                    HStack{
                    
                      Image("ethereum")
                       .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 55, height: 55, alignment: .center)
                    .offset(x: -40)
                    
                      Text("Connect Wallet")
                        
                            .font(.system(size: 20))
                            .offset(x: -30)
                            
                            
                   }
                    .frame(width: UIScreen.main.bounds.width/1.5, height: 45, alignment: .center)
                    
                   
                }.padding()
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(15)
                    .alert(isPresented: $showingAlert) { () -> Alert in
                        Alert(title: Text("Please input a valid Address"))
                        
                    }
                    .alert(isPresented: self.$showAlert){
                     Alert(title: Text("No Internet Connection"), message: Text("Please enable WiFi or Cellular Data Connection"), dismissButton: .default(Text("Ok")))}
            
        }.padding(.bottom, 65)
                .onAppear(perform: {
                    if Chart != [] {
                        Chart = []
                    }
                    if  MarketData != []{
                        MarketData = []
                    }
                })
                
            }
            else{
            
            NavigationView{
    
            VStack{
                
                HStack(spacing: 15){
               
                    if (Name != ""){
                Text("Hi \(Name)" + "! 👋")
                 .fontWeight(.bold)
                 .font(Font.custom("Helvetica Bold", size: 20))
                    .offset(x: -UIScreen.main.bounds.height/6.5, y: -UIScreen.main.bounds.height/15)
                    
                    }
                
                }
            
                HStack{
                    if self.flipped == false{
                VStack(alignment: .leading) {
                
                  
                Text("Portfolio")
                  .fixedSize()
                    .padding(.bottom, 15)
                    .padding(.top, 55)
                    .font(Font.custom("HelveticaNeue  Bold", size: 19))
                    .foregroundColor(Color(.black))
                    
                      
                        
                    
                   
                Text("ETH Value")
                    .fixedSize()
                    .font(Font.custom("HelveticaNeue Bold", size: 15))
                    .foregroundColor(Color(.black))
                       
                    HStack{
                    Text("$\(currentValue.delimiter)")
                    .font(.system(size: 30))
                    .fontWeight(.heavy)
                    .foregroundColor(Color(.black))
                    
                    }
                    
                    HStack{
                        
                Text("Historic change")
                    .font(.system(size: 11))
                   .padding(.top, 5)
                    .foregroundColor(Color(.black))
               
                Text("|")
                 
                   .font(.system(size: 11))
                    .padding(.top, 5)
                    .foregroundColor(Color(.black))
                        
                        if(Chart.last != nil || Chart.first != nil ){
                Text("\(((Double(Chart.last!)! - Double(Chart.first!)!)/Double(Chart.last!)! * 100).delimiter)%" as String)
                   
                    .font(.system(size: 11))
                    .padding(.top, 5)
                    .foregroundColor(Color(.black))
                    
                        }
                        
                        else{
                            Text("not enough chart data!" as String)
                               
                                .font(.system(size: 11))
                                .padding(.top, 5)
                                .foregroundColor(Color(.black))
                        }
                        
                        
                           
                   // .offset(x: -UIScreen.main.bounds.height/8)
                    }
                    
                    .padding(.bottom, 125)
                 
                    Divider()
                        .offset(y: -UIScreen.main.bounds.height/7.5)
                        
                    LineChartView(data: Chart.compactMap(Double.init), title: "Title", legend: "Legendary") .offset(x: -44, y: -UIScreen.main.bounds.height/7.5)
                    
                    
                }.padding(.top, 65)
                

                    }
                    
                    else{
                       
                            Button(action: {
                                isSheetPresented.toggle()
                                
                                print("Opening Webview")
                                            }, label: {
                                                
                                    HStack{
                                        HStack{
                                          
                                 Text("Swap")
                                    .font(.system(size: 55))
                                    .fontWeight(.bold).foregroundColor(colorScheme == .dark ? Color.orange : Color.yellow)
                                      }
                                     
                                          }
                                  
                                    .frame(width: 170)
                                   
                                    .background(Color.white)
                                    .cornerRadius(15)
                                    .rotation3DEffect(self.flipped ? Angle(degrees: 180): Angle(degrees: 0), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0)))
                                                .padding()
                                                //.background(Color.orange)
                                                .cornerRadius(8)
                                                .foregroundColor(.black)
                                                
                                       })
                            
                            .offset(x: UIScreen.main.bounds.width / 2.5)
                            .sheet(isPresented: $isSheetPresented, content: {
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
                                                  
                            }).offset(x: -UIScreen.main.bounds.width / 2.2)
                        
                        
                    }
                }
                
                .padding(.leading, 55)
                
                
        .frame(width: UIScreen.main.bounds.width / 1.1, height: 280)
                .background(colorScheme == .dark ? Color.orange : Color.yellow)
        .cornerRadius(20)
        .offset(y: -UIScreen.main.bounds.height/15)
                .foregroundColor(self.flipped ? .red : .blue) // change the card color when flipped
                            .padding()
                            .rotation3DEffect(self.flipped ? Angle(degrees: 180): Angle(degrees: 0), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0)))
                            .animation(.default) // implicitly applying animation
                            .onTapGesture {
                                // explicitly apply animation on toggle (choose either or)
                                //withAnimation {
                                    self.flipped.toggle()
                                //}
                        }
               
            VStack(alignment: .trailing){
                    
       Text("Holdings")
        .font(.callout)
        .foregroundColor(.secondary)
        .font(Font.custom("HelveticaNeue Bold", size: 10))
        
                }
                .offset(x:  -UIScreen.main.bounds.height/6, y: -UIScreen.main.bounds.height/17)
                
                if MarketData != []{
                
               
        List(MarketData, id: \.self) { landmark in
           
            WalletView(wallinfo: landmark)
            
                  }.id(UUID())
        
      
        .listStyle(PlainListStyle())
        .offset(y: -UIScreen.main.bounds.height/15)
       
        .onAppear(perform: {
           
           // gen.balance()
           //dataList.getEtherLastPrice()
           // dataList.getData()
           
            
        })
                  
                    
                }
                else{
                    VStack{
                        
                        
                    Text("No Holdings")
                        .offset(y: -UIScreen.main.bounds.height/20)
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .font(Font.custom("HelveticaNeue Bold", size: 10))
                        
                    }
                    .padding(.top, UIScreen.main.bounds.height/5)
                    .padding(.bottom, UIScreen.main.bounds.height/7)
                    
                    
                }
                
            }
                
            }.onAppear(perform: {
                var flags = SCNetworkReachabilityFlags()
                SCNetworkReachabilityGetFlags(self.reachability!, &flags)
                
                if self.isNetworkReachable(with: flags){
                gen.balance()
                dataList.getEtherLastPrice()
                dataList.getData()
                }
                
                else{
                    showAlert = true
                }
                
                
            }
            
            )
              
            
                
        }
            
        }
        
       
        
    }
    
    private func isNetworkReachable(with flags : SCNetworkReachabilityFlags) -> Bool{
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        
        let canConnectWithoutInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        
        return isReachable && (!needsConnection || canConnectWithoutInteraction)
        
      
    }
}


struct CardViewed_Previews: PreviewProvider {
    static var previews: some View {
        CardViewed()
            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                        .previewDisplayName("iPhone 8")
    }
}
