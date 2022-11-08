//
//  Yellow Portfolio.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2022-04-30.
//

import SwiftUI
//
//  CardView.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-08-08.
//

import SwiftUI
import Foundation
import AlertX
import IGIdenticon
import WKView
import SystemConfiguration

struct Yellow_Portfolio: View {
    
    @ObservedObject var dataList = MarketCap.sharedInstance
    
    @State private var showAlert = false
    
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
    
    @State var alertTextInvalidAddressOrConnect = ""
    
    @State var width : CGFloat = UIScreen.main.bounds.width/1.5
    
    @State var height : CGFloat = UIScreen.main.bounds.height/3
    
    @State var padding = 265
    
    @ObservedObject var playController = playControl.sharedInstance
    
    @State var offList = -UIScreen.main.bounds.height/15
    
    @State var offPort = -UIScreen.main.bounds.height/15
 
    @State var offHoldingsX = -UIScreen.main.bounds.height/6
    
    @State var offHoldingsY = -UIScreen.main.bounds.height/17
    
    var body: some View {
       
       
        ZStack {
        
            if walletConnected == false{
             
                VStack{
                    
                    Image("Banner")
                        .resizable()
                        .frame(width: width, height: height)
                        .offset(y: -25)
                  
                Text("Welcome to")
                        .font(.system(size: 35))
                    .fontWeight(.bold)
                        .offset(y: -45)
                        .accentColor(.accentColor)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                   
                    Text("Bopp")
                            .font(.system(size: 35))
                        .fontWeight(.bold)
                            .offset(y: -45)
                            .accentColor(.accentColor)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                    
                    Text("Paste your Etheruem wallet address below")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .offset(y: -35)
                            .accentColor(.accentColor)
                            .foregroundColor(.secondary)
                    
                    HStack {
                        
                        Image("User")
                            .resizable()
                            .frame(width: 26, height: 26)
                        
                     TextField("Paste Wallet Address", text: self.$AccountNumber)
                        .frame(width: UIScreen.main.bounds.width/1.5, height: 45, alignment: .center)
                        .foregroundColor(.primary)
                       
                        Button(action: {
                            var flags = SCNetworkReachabilityFlags()
                            SCNetworkReachabilityGetFlags(self.reachability!, &flags)
                            
                            if self.isNetworkReachable(with: flags){
                            gen.isValid()
                            showingAlert = !ValidAddress
                                if(showingAlert == true){
                                    alertTextInvalidAddressOrConnect = "Please input a valid Address"
                                }
                                else{
                                    alertTextInvalidAddressOrConnect = ""
                                }
                                
                            }
                            
                            else{
                                showingAlert = true
                                
                                if(showingAlert == true){
                                    alertTextInvalidAddressOrConnect = "No Internet connection"
                                }
                                
                                else{
                                    showingAlert = false
                                    alertTextInvalidAddressOrConnect = ""
                                }
                            }
                            
                        }){
                        
                        Image(systemName: "arrow.right.circle")
                           .resizable()
                            .foregroundColor(.primary)
                            .frame(width: 33, height: 33)
                        }
                    }
                    
                    .padding()
                   
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    
                    Text("Click here to find out more")
                        .underline(true, color: Color.accentColor)
                        .foregroundColor(Color.accentColor)
                        .onTapGesture(perform: {
                            let webURL = NSURL(string: "https://ethereum.org/en/wallets/")!

                            let application = UIApplication.shared

                                 application.open(webURL as URL)
                        })
                    
                   
                        
                
                }
                .animation(.default)
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                           
                    padding = 0
             
                    
                        }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
                    padding = Int(UIScreen.main.bounds.height/2.5)
                    
                
                           
                        }
                .padding(.bottom, CGFloat(padding))
               
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
                
                HStack(spacing: 5){
               
                    if(Name != ""){
                Text("Hi \(Name)" + "! 👋")
                 .fontWeight(.bold)
                 .font(Font.custom("Helvetica Bold", size: 20))
                    .offset(x: -UIScreen.main.bounds.height/6.5, y: -UIScreen.main.bounds.height/15)
                    
                    }
                
                }
            
                HStack{
                VStack(alignment: .leading) {
                
                Text("Portfolio")
                  .fixedSize()
                    .padding(.bottom, 15)
                    .padding(.top, 25)
                    .font(Font.custom("HelveticaNeue  Bold", size: 19))
                    .foregroundColor(Color(.black))
                   
                Text("ETH Value")
                    .fixedSize()
                    .font(Font.custom("HelveticaNeue Bold", size: 15))
                    .foregroundColor(Color(.black))
                       
                    Text("$\(currentValue.delimiter)")
                .font(.system(size: 30))
                    .fontWeight(.heavy)
               .foregroundColor(Color(.black))
                    .fixedSize()
                    
                    
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
                        
                        
                 
                    }
                    
                    .padding(.bottom, 125)
                 
                    Divider()
                        .offset(y: -UIScreen.main.bounds.height/7.5)
                        
                    LineChartView(data: Chart.compactMap(Double.init), title: "Title", legend: "Legendary") .offset(x: -44, y: -UIScreen.main.bounds.height/7.5)
                    
                    
                }.padding(.top, 65)
                

                }.padding(.leading, 55)
                
                
        .frame(width: UIScreen.main.bounds.width / 1.1, height: 280)
        .background(colorScheme == .dark ? Color.yellow : Color.yellow)
        .cornerRadius(20)
        .offset(y: offPort)
                
               
            VStack(alignment: .trailing){
                    
       Text("Holdings")
        .font(.callout)
        .foregroundColor(.secondary)
        .font(Font.custom("HelveticaNeue Bold", size: 10))
        
                }
                .offset(x:  offHoldingsX, y: offHoldingsY)
                
                if MarketData != []{
                
               
                List {
            ForEach(MarketData, id: \.symbol) { landmark in
            WalletView(wallinfo: landmark)
              
            }
                  }
        
      
        .listStyle(PlainListStyle())
        .offset(y: offList)
        .onAppear(perform: {
           
                if !playController.isMini{
                   
                    offList = 0
                    offPort = -UIScreen.main.bounds.height/30
                     offHoldingsY = 0
                }
                
                else{
                    offList = -UIScreen.main.bounds.height/15
                   
                    offPort =  -UIScreen.main.bounds.height/15
                
                    offHoldingsY = -UIScreen.main.bounds.height/17
                }
            
            
            
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
                
                padding = 265
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

