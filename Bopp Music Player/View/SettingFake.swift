//
//  SettingsView.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-08-11.
//

import SwiftUI
import Firebase




struct SettingsFake: View {
    //@EnvironmentObject var settings: SettingsStore

    @AppStorage("ValidAddress") var ValidAddress = false
    @State var username: String = ""
    
    @State var showingAlert : Bool = false
    
    @State var disconnectAlert : Bool = false
    
    @AppStorage("walletConnected") var walletConnected = false
    
    @AppStorage("log_status") var log_Status = false
    
    @AppStorage("Name") var Name = ""
    
    @ObservedObject var Avplayer = AudioPlayer.sharedInstance
    
    @AppStorage("AccountNumber") var AccountNumber = ""
    
    @AppStorage("AccountBalance") var AccountBalance = ""
    
    @AppStorage("EtherPrice") var EtherPrice: Double = 0
    
    @AppStorage("TotalValue") var TotalValue: String = "0"
    
    @AppStorage("Chart") var Chart : [ String ] = []
    
    @AppStorage("currentValue") private var currentValue: Double = 0
    
    @AppStorage("MarketData") var MarketData: [Wallet] = []
    
   
    
    
    var body: some View {
        NavigationView {
          
            
                ZStack{
                    
                    if walletConnected {
                  
                 Form {
                    Section(header: Text("Options")) {
                        Button(action: {
                            let webURL = NSURL(string: "https://t.me/joinchat/eEXLQMFF6UFhNjIx")!

                            let application = UIApplication.shared

                                 application.open(webURL as URL)
                                            }) {
                            HStack{
                         /*Image("support")
                            .resizable()
                            .frame(width: 26, height: 26)*/
                                
                                
                        Text("Support").foregroundColor(Color.primary)
                            .font(Font.custom("HelveticaNeue", size: 17))
                                    }
                                            }
                        
                        Button(action: {
                            let webURL = NSURL(string: "https://boppmusic.net")!

                            let application = UIApplication.shared

                                 application.open(webURL as URL)
                            
                         
                                            }) {
                            HStack{
                        
                               /* Image("exclamation")
                                    .resizable()
                                    .frame(width: 26, height: 26)*/
                        Text("About us").foregroundColor(Color.primary)
                            .font(Font.custom("HelveticaNeue", size: 17))
                            }
                                            }
                    }
                    
               
                    Section{
                
            
                        
            Button(action: {
                showingAlert = true
                                }) {
                
                HStack{
               
            Text("Disconnect Wallet").foregroundColor(Color.red)
                .font(Font.custom("HelveticaNeue Bold", size: 17))
                    
                }
                                } .alert(isPresented:$showingAlert) {
                    Alert(
                    title: Text("Are you sure you want to disconnect your wallet??"),
                    message: Text("All chart data would be lost, there is no way to UNDO!!"),
                    primaryButton: .destructive(Text("Disconnect")) {
                        
                        DispatchQueue.main.async {
                        walletConnected = false
                        
                         AccountBalance = ""
                       
                         ValidAddress = false
                        
                         EtherPrice = 0
                        
                         Chart.removeAll()
                        
                         MarketData.removeAll()
                        
                         currentValue = 0
                        
                        showingAlert = false
                       
                        AccountNumber = ""
                         print("disconnected Chart Data: ", Chart )
                        
                        }
                        
                                        },
                    secondaryButton: .cancel()
                                    )
                                }
                        
                        
                    }
                    
                    Section{
                        
                        Button(action: {
                            
                            disconnectAlert = true
                            
                                     }) {
                            
                            HStack{
                           // Image(systemName: "exclamationmark.circle") //.foregroundColor(.gray)
                               /* Image("logout")
                                    .resizable()
                                    .frame(width: 26, height: 26)*/
                        Text("Log out")
                            .font(Font.custom("HelveticaNeue", size: 17))
                                
                            }
                                            }
                        .alert(isPresented:$disconnectAlert) {
                                Alert(
                                title: Text("Are you sure you want to log out?"),
                                message: Text(""),
                                primaryButton: .destructive(Text("Log out")) {
                                   disconnectAlert = false
                                    
                                    DispatchQueue.global(qos: .background).async {
                                        
                                        try? Auth.auth().signOut()
                                        
                                        Avplayer.player?.rate = 0
                                    }
                                    
                                    withAnimation(.easeInOut){
                                        log_Status = false
                                    }
                                    
                                
                                   
                                                    },
                                secondaryButton: .cancel()
                                                )
                                            }
                    
                    }
                    
                   
                 }
                    }
                    
                    else{
                        Form {
                           Section(header: Text("Options")) {
                               Button(action: {
                                   let webURL = NSURL(string: "https://t.me/joinchat/eEXLQMFF6UFhNjIx")!

                                   let application = UIApplication.shared

                                        application.open(webURL as URL)
                                                   }) {
                                   HStack{
                               /* Image("support")
                                   .resizable()
                                   .frame(width: 26, height: 26)*/
                                       
                               Text("Support").foregroundColor(Color.primary)
                                   .font(Font.custom("HelveticaNeue", size: 17))
                                           }
                                                   }
                               
                               Button(action: {
                                   let webURL = NSURL(string: "https://boppmusic.io")!

                                   let application = UIApplication.shared

                                        application.open(webURL as URL)
                                   
                                
                                                   }) {
                                   HStack{
                               
                                       /*Image("exclamation")
                                           .resizable()
                                           .frame(width: 26, height: 26)*/
                                       
                                       
                               Text("About us").foregroundColor(Color.primary)
                                   .font(Font.custom("HelveticaNeue", size: 17))
                                   }
                                                   }
                           }
                           Section{
                               
                               Button(action: {
                                   
                                   disconnectAlert = true
                                   
                                            }) {
                                   
                                   HStack{
                                  // Image(systemName: "exclamationmark.circle") //.foregroundColor(.gray)
                                       /*Image("logout")
                                           .resizable()
                                           .frame(width: 26, height: 26)*/
                                       
                               Text("Log out")
                                   .font(Font.custom("HelveticaNeue", size: 17))
                                       
                                   }
                                                   }
                               .alert(isPresented:$disconnectAlert) {
                                       Alert(
                                       title: Text("Are you sure you want to log out?"),
                                       message: Text(""),
                                       primaryButton: .destructive(Text("Log out")) {
                                          disconnectAlert = false
                                           
                                           DispatchQueue.global(qos: .background).async {
                                               
                                               try? Auth.auth().signOut()
                                               
                                               Avplayer.player?.rate = 0
                                           }
                                           
                                           withAnimation(.easeInOut){
                                               log_Status = false
                                           }
                                           
                                       
                                          
                                                           },
                                       secondaryButton: .cancel()
                                                       )
                                                   }
                           
                           }
                           
                          
                        }
                        
                          
                    }
                }
                
                 
                 .navigationBarTitle("Settings")
                 .navigationBarItems(trailing:
                               HStack{
                  
                     
                   //Bopp original
                //  Image("ethereum")
                     //    .resizable()
                     
                     
                     Image("Icon")
                             .resizable()
                     
                   .frame(width: 29, height: 29, alignment: .trailing)
                        
                     
                     //bopp original
                       //  Text(AccountBalance + " ETH")
                                  //     .font(.system(size: 15))
                                 //      .fontWeight(.light)
                                     
                                         }
                           
                     )
             }
        
        
         
    }
}

