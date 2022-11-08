//
//  Bopp_Music_PlayerApp.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-06-06.
//

import SwiftUI
import UIKit
import Firebase
import GoogleSignIn

@main
struct Bopp_Music_PlayerApp: App {
    
    @ObservedObject var dataList = MarketCap.sharedInstance
    
    @StateObject var viewModel = AuthenticationViewModel()

   
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
 
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
    
    
}

class AppDelegate: NSObject,UIApplicationDelegate{
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        return true
    }
}


