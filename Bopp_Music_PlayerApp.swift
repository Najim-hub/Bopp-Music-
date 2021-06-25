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
    
   
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    
}

class AppDelegate: NSObject,UIApplicationDelegate{
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        return true
    }
}
