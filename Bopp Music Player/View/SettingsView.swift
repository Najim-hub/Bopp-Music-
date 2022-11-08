//
//  SettingsView.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-08-11.
//

import SwiftUI
import Firebase

private var splashImageBackground: some View {
      GeometryReader { geometry in
        BlurView()
        Rectangle()
            .fill(Color.red)
            .frame(width: 200, height: 200)
          
      }
  }



struct SettingsView: View {
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
    
    @StateObject var loginData = LoginViewModel()
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    
    
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
                         Image("support")
                            .resizable()
                            .frame(width: 26, height: 26)
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
                        
                                Image("exclamation")
                                    .resizable()
                                    .frame(width: 26, height: 26)
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
               Image("disconnect")
                        .resizable()
                        .frame(width: 26, height: 26)
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
                                Image("logout")
                                    .resizable()
                                    .frame(width: 26, height: 26)
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
                                    
                                    viewModel.signOut()
                                    
                                    DispatchQueue.global(qos: .background).async {
                                      
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
                     
                     
                     
                     Section{
                         
                         Button(action: {
                             
                             disconnectAlert = true
                             
                                      }) {
                             
                             HStack{
                            // Image(systemName: "exclamationmark.circle") //.foregroundColor(.gray)
                                 Image("logout")
                                     .resizable()
                                     .frame(width: 26, height: 26)
                         Text("Delete Account")
                             .font(Font.custom("HelveticaNeue", size: 17))
                                 
                             }
                                             }
                         .alert(isPresented:$disconnectAlert) {
                                 Alert(
                                 title: Text("Are you sure you want to delete your account?"),
                                 message: Text(""),
                                 primaryButton: .destructive(Text("DELETE")) {
                                    
                                     disconnectAlert = false
                                     
                                     loginData.removeAccount()
                                     
                                     DispatchQueue.global(qos: .background).async {
                                      
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
                 
                    Spacer()
                    HStack(alignment: .center, spacing: 30){
                        Button(action: {
                          
                            let Username =  "boppmusicinc" // Your Instagram Username here
                            let appURL = URL(string: "instagram://user?username=\(Username)")!
                            let application = UIApplication.shared

                            if application.canOpenURL(appURL) {
                                application.open(appURL)
                            } else {
                                // if Instagram app is not installed, open URL inside Safari
                                let webURL = URL(string: "https://instagram.com/\(Username)")!
                                application.open(webURL)
                            }

                                            }) {
                                       Image("InstagramColored")
                                            .resizable()
                                            .frame(width: 30, height: 30, alignment: .center)
                        }
                        Button(action: {
                            let screenName =  "Boppmusicinc"
                               let appURL = NSURL(string: "twitter://user?screen_name=\(screenName)")!
                               let webURL = NSURL(string: "https://twitter.com/\(screenName)")!

                               let application = UIApplication.shared

                               if application.canOpenURL(appURL as URL) {
                                    application.open(appURL as URL)
                               } else {
                                    application.open(webURL as URL)
                               }
                                            }) {
                                        Image("TwitterOutlined")
                                            .resizable()
                                            .frame(width: 30, height: 30, alignment: .center)
                        }
                        Button(action: {
                            
                            //let screenName =  "Boppmusicinc"
                              // let appURL = NSURL(string: "twitter://user?screen_name=\(screenName)")!
                               let webURL = NSURL(string: "https://t.me/joinchat/eEXLQMFF6UFhNjIx")!

                               let application = UIApplication.shared

                                    application.open(webURL as URL)
                               
                            
                                            }) {
                                        Image("TelegramOutlined")
                                            .resizable()
                                            .frame(width: 30, height: 30, alignment: .center)
                        }
                        Button(action: {
                        print("Perform an action here...")
                                            }) {
                        Image("discordOutlined")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                        }
                        
                        Button(action: {
                        print("Perform an action here...")
                                            }) {
                        Image("Youtube")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                            
                        }
                        
                        Button(action: {
                        print("Perform an action here...")
                                            }) {
                        Image("redditOutlined")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                            
                        }
                    }
                    .offset(y: UIScreen.main.bounds.height/25)
                    //.padding(.top, 70)
                    
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
                                Image("support")
                                   .resizable()
                                   .frame(width: 26, height: 26)
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
                               
                                       Image("exclamation")
                                           .resizable()
                                           .frame(width: 26, height: 26)
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
                                       Image("logout")
                                           .resizable()
                                           .frame(width: 26, height: 26)
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
                           
                            
                            Section{
                                
                                Button(action: {
                                    
                                    disconnectAlert = true
                                    
                                             }) {
                                    
                                    HStack{
                                
                                Text("Delete Account")
                                    .font(Font.custom("HelveticaNeue", size: 17))
                                    .foregroundColor(Color.red)
                                    }
                                                    }
                                .alert(isPresented:$disconnectAlert) {
                                        Alert(
                                        title: Text("Are you sure you want to delete your account?"),
                                        message: Text("Your account would be deleted from our database servers in addition to any assiociated user data. Upon deletion you would be redirected to the Apple website to remove Bopp from your assiocated Apple ID in Settings please follow the instructions on the Apple website. \n NOTE: YOUR ACCOUNT CAN NOT BE RECOVERED"),
                                        primaryButton: .destructive(Text("DELETE")) {
                                           
                                            disconnectAlert = false
                                            
                                            viewModel.deleteUser()
                                            
                                            let webURL = NSURL(string: "https://support.apple.com/en-us/HT210426")!

                                            let application = UIApplication.shared

                                                 application.open(webURL as URL)
                                            
                                            
                                            
                                            DispatchQueue.global(qos: .background).async {
                                             
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
                        
                           
                           HStack(alignment: .center, spacing: 30){
                               Button(action: {
                                 
                                   let Username =  "boppmusicinc" // Your Instagram Username here
                                   let appURL = URL(string: "instagram://user?username=\(Username)")!
                                   let application = UIApplication.shared

                                   if application.canOpenURL(appURL) {
                                       application.open(appURL)
                                   } else {
                                       // if Instagram app is not installed, open URL inside Safari
                                       let webURL = URL(string: "https://instagram.com/\(Username)")!
                                       application.open(webURL)
                                   }

                                                   }) {
                                              Image("InstagramColored")
                                                   .resizable()
                                                   .frame(width: 30, height: 30, alignment: .center)
                               }
                               Button(action: {
                                   let screenName =  "Boppmusicinc"
                                      let appURL = NSURL(string: "twitter://user?screen_name=\(screenName)")!
                                      let webURL = NSURL(string: "https://twitter.com/\(screenName)")!

                                      let application = UIApplication.shared

                                      if application.canOpenURL(appURL as URL) {
                                           application.open(appURL as URL)
                                      } else {
                                           application.open(webURL as URL)
                                      }
                                                   }) {
                                               Image("TwitterOutlined")
                                                   .resizable()
                                                   .frame(width: 30, height: 30, alignment: .center)
                               }
                               Button(action: {
                                   
                                      let webURL = NSURL(string: "https://t.me/joinchat/eEXLQMFF6UFhNjIx")!

                                      let application = UIApplication.shared

                                           application.open(webURL as URL)
                                      
                                   
                                                   }) {
                                               Image("TelegramOutlined")
                                                   .resizable()
                                                   .frame(width: 30, height: 30, alignment: .center)
                               }
                               Button(action: {
                               print("Perform an action here...")
                                                   }) {
                               Image("discordOutlined")
                                   .resizable()
                                   .frame(width: 30, height: 30, alignment: .center)
                               }
                               
                               Button(action: {
                               print("Perform an action here...")
                                                   }) {
                               Image("Youtube")
                                   .resizable()
                                   .frame(width: 30, height: 30, alignment: .center)
                                   
                               }
                               
                               Button(action: {
                               print("Perform an action here...")
                                                   }) {
                               Image("redditOutlined")
                                   .resizable()
                                   .frame(width: 30, height: 30, alignment: .center)
                                   
                               }
                           }
                           .offset(y: UIScreen.main.bounds.height/5)
                    }
                }
                
                 
                 .navigationBarTitle("Settings")
             }
        
        
         
    }
}

extension UIApplication {
static var appVersion: String? {
return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
}
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                        .previewDisplayName("iPhone 8")
    }
}
