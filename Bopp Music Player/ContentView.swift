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
    

    @AppStorage("log_status") var log_Status = true
    
    @AppStorage("connection_status") var connection_status = false
    
    var body: some View {
  
        ZStack{
            if log_Status{
               TabBar()
                //Yellow_Portfolio()
                
            }
            else{
                Login() //*Add this back for sign in with Apple*
                
                //LoginWithGoogle()
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
