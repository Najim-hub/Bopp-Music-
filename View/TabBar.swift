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
    
    // 1.
    //@ObservedObject var audiosettings = audioSettings()
    
    
    var body: some View {
    
        // Bottom Mini Player...
        
   
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
       
            
            TabView(selection: $current){
                
                
                SignInCryptoWallet()
                    .tag(1)
                    .tabItem {
                        
                        Image(systemName: "coloncurrencysign.circle.fill")
                        
                        Text("Wallet")
                        
                    }
                
                Coming()
                    .tag(2)
                    .tabItem {
                        
                        Image(systemName: "purchased")
                        
                        Text("MarketPlace")
                        
                    }
                
                 Home()
                    .tag(3)
                    .tabItem {
                        
                        Image(systemName: "music.note")
                        
                        Text("Music")
                    }
                
                Logout()
                    .tag(4)
                    .tabItem {
                       Image(systemName: "person.crop.circle")
                        
                        Text("User")
                        
                    }
                
                
                
                
               
            }
            
            
           
            if playController.showPlayer {
                Miniplayer()
                
                .introspectTabBarController { (UITabBarController) in
                        
                        if !playController.isMini{
                    UITabBarController.tabBar.layer.zPosition = -1
                    UITabBarController.tabBar.isUserInteractionEnabled = false;
                  
                        }
                        
                        else{
                     UITabBarController.tabBar.layer.zPosition = -0
                     UITabBarController.tabBar.isUserInteractionEnabled = true;
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



