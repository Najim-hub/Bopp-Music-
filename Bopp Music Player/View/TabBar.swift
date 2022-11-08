//
//  TabBar.swift
//  Bop Music
//
//  Created by Balaji on 16/11/20.
//

import SwiftUI


struct TabBar: View {
    // Selected Tab Index...
    // Default is third...
    @State var current = 3
    
    // Miniplayer Properties...
    @State var expand = false
    
    @GestureState var gestureOffset: CGFloat = 0
    
    @ObservedObject var playController = playControl.sharedInstance
    
    @Namespace var animation
    
    //@EnvironmentObject var player: MusicPlayerViewModel
    
    @StateObject var player = MusicPlayerViewModel()
    
    @State var searchText: String = ""
    
    @State var cornerRad = 25
    
    
    @State var versionAlert = false
    
    // 1.
    //@ObservedObject var audiosettings = audioSettings()
   
    @AppStorage("AppVersion") var AppVersion = ""
    
    var body: some View {
    
        // Bottom Mini Player...
        
   
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
       
            
            TabView(selection: $current){
                
                
                //SignInCryptoWallet()
               // CardView()
               // Yellow_Portfolio()
               TicketListView()
                    .tag(1)
                    .tabItem {
                        
                        //Image(systemName: "ticket")
                        Image(systemName: "wallet.pass")
                            .foregroundColor(Color.yellow)
                        
                       // Text("Events")
                        Text("Portfolio")
                        
                    }
                
                Coming()
        
                    .tag(2)
                    .tabItem {
                        
                        Image(systemName: "bag")
                            .foregroundColor(Color.yellow)
                        
                    Text("Marketplace")
                        //Text("Pass")
                        
                    }
                
                 Home()
                    .tag(3)
                    .tabItem {
                        
                        Image(systemName: "music.note")
                            .foregroundColor(Color.yellow)
                        
                        Text("Music")
                    }
                
                SettingsView()
               // SettingsFake()
             // Logout()
                    .tag(4)
                    .tabItem {
                       Image(systemName: "gearshape.fill")
                            .foregroundColor(Color.yellow)
                        
                        Text("Settings")
                        
                    }
                
                
                
                
                
                
                
               
            }
            .alert(isPresented:$versionAlert) {
                    Alert(
                    title: Text("Update"),
                    message: Text("Theres a new update available"),
                        primaryButton: .default(Text("Update Now!")){
                     
                            versionAlert = false
                            
                            let webURL = NSURL(string: "https://apps.apple.com/ca/app/bopp-music/id1573437750?fbclid=IwAR3l8Iex5Xlk-ULKy2GTMB8d6ZcX8b_ZZibKZQgN02rOs26J2w7xQd1tL4k")!

                            let application = UIApplication.shared

                            application.open(webURL as URL)
                            
                            
                       
                                        },
                    secondaryButton: .cancel()
                                    )
                                }
            .onAppear(perform: {
                let InAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                
                let versionInt = (InAppVersion as! NSString).doubleValue
                
                let AppVersionInt = (AppVersion as! NSString).doubleValue
                print(versionInt)
                
                print("Current Version: ", AppVersionInt)
                if AppVersionInt != versionInt{
                    versionAlert = true
                }
            })
            .introspectTabBarController { (UITabBarController) in
                if playController.isMini || !playController.showPlayer{
            UITabBarController.tabBar.shadowImage = UIImage()
              
            UITabBarController.tabBar.barTintColor = .clear
            UITabBarController.tabBar.backgroundImage = UIImage()
                }
            }
           
            if !playController.isMini{
            if playController.showPlayer {
                Miniplayer()
                  
                   // .cornerRadius(CGFloat(cornerRad))
                .introspectTabBarController { (UITabBarController) in
                  
                    
                        if !playController.isMini{
                    UITabBarController.tabBar.layer.zPosition = -1
                    UITabBarController.tabBar.isUserInteractionEnabled = false;
                            cornerRad = 0
                        }
                        
                        else{
                     UITabBarController.tabBar.layer.zPosition = -0
                     UITabBarController.tabBar.isUserInteractionEnabled = true;
                            cornerRad = 35
                        }
                    
                  
                    }
                    //.environmentObject(player)
                    .padding(.bottom, playController.isMini ? 47 : 0)
                     .zIndex(1.0)
                    .transition(.move(edge: .bottom))
                    .offset(y: playController.offset)
                    
                    .gesture(DragGesture().updating($gestureOffset, body: { value, state, transaction in
                        if value.translation.height > 0 {
                            state = value.translation.height
                            
                            
                        }
                    })
                    .onEnded(onEnd(value:))
                    )
            }//end of if
            
            }
            
            else{
                if playController.showPlayer {
                    Miniplayer()
                      
                        .cornerRadius(CGFloat(cornerRad))
                    .introspectTabBarController { (UITabBarController) in
                      
                        
                            if !playController.isMini{
                        UITabBarController.tabBar.layer.zPosition = -1
                        UITabBarController.tabBar.isUserInteractionEnabled = false;
                                cornerRad = 0
                            }
                            
                            else{
                         UITabBarController.tabBar.layer.zPosition = -0
                         UITabBarController.tabBar.isUserInteractionEnabled = true;
                                cornerRad = 35
                            }
                        
                      
                        }
                        .padding(.bottom, playController.isMini ? 47 : 0)
                         .zIndex(1.0)
                        .transition(.move(edge: .bottom))
                        .offset(y: playController.offset)
                        
                        .gesture(DragGesture().updating($gestureOffset, body: { value, state, transaction in
                            if value.translation.height > 0 {
                                state = value.translation.height
                                
                                
                            }
                        })
                        .onEnded(onEnd(value:))
                        )
                }
            }
            })
            .ignoresSafeArea(.keyboard)
        .onChange(of: gestureOffset, perform: { value in
           onChanged()
        })
        
        
      
        
    
        
}
    
    func onChanged(){
        
        if gestureOffset > 0 && !playController.isMini && playController.offset + 180 <= playController.height{
        
            playController.offset = gestureOffset
        }
    }
    
    func onEnd(value: DragGesture.Value){
        withAnimation(.default){

            if !playController.isMini{
                
                playController.offset = 0
                
                // Closing View...
          if value.translation.height > UIScreen.main.bounds.height / 3
                {
                    
            playController.isMini = true
                    
                    
                }
                else{
                    playController.isMini = false
                    
                 
            }
        }
    }
    }
}



