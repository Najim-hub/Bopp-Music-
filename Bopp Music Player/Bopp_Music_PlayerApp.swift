//
//  Bopp_Music_PlayerApp.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-06-06.
//

import SwiftUI
import UIKit
import TrustSDK
import Firebase



@main
struct Bopp_Music_PlayerApp: App {
    
    init(){
       
        TrustSDK.initialize(with: TrustSDK.Configuration(scheme: "trustsdk"))
          
        FirebaseApp.configure()
        
        func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
          return TrustSDK.application(app, open: url, options: options)
        }
    }
    

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    
}
