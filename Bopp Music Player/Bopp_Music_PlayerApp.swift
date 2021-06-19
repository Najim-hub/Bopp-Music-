//
//  Bopp_Music_PlayerApp.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-06-06.
//

import SwiftUI
import UIKit
import Firebase

@main
struct Bopp_Music_PlayerApp: App {
    
   var data = MusicData()
    
    init(){
       
        FirebaseApp.configure()
        
        //data.loadSongs()
        
    }
    

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    
}
