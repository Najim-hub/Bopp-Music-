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
    @State var current = 1
    
    // Miniplayer Properties...
    @State var expand = false
    
    
    @Namespace var animation
    
    
    //@ObservedObject var audiosettings = audioSettings()
    
    
    var body: some View {
    
        // Bottom Mini Player...
        
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
            
            TabView(selection: $current){
                
                
                Text("Wallet")
                    .tag(0)
                    .tabItem {
                        
                        Image(systemName: "coloncurrencysign.circle.fill")
                        
                        Text("Wallet")
                        
                    }
                
                 Home()
                    .tag(1)
                    .tabItem {
                        
                        Image(systemName: "music.note")
                        
                        Text("Music")
                    }
                
                
               
            }
            
            
            
         

            
            
            
         
        }).onAppear(perform: {
          
        })
}
}
