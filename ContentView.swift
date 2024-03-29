//
//  ContentView.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-06-06.
//

import SwiftUI
import CryptoKit
import FirebaseAuth
import AuthenticationServices

struct ContentView: View {
    
    @EnvironmentObject var player: MusicPlayerViewModel
    

    @AppStorage("log_status") var log_Status = false
    
    @AppStorage("connection_status") var connection_status = false
    
    var body: some View {
  
        ZStack{
            if log_Status{
               TabBar()
            }
            else{
                Login()
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
