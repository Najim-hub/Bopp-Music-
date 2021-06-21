//
//  Logout.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-06-20.
//

import SwiftUI
import Firebase

struct Logout: View {
    
    @AppStorage("log_status") var log_Status = false
    
    @AppStorage("Name") var Name = ""
    
    @ObservedObject var Avplayer = AudioPlayer.sharedInstance
    
    var body: some View {
        
      
        NavigationView{
            
            
            VStack(spacing: 20){
                
              
                Text("Click the logout button to exit")
                
                Button(action: {
                    // Logging Out User...
                    DispatchQueue.global(qos: .background).async {
                        
                        try? Auth.auth().signOut()
                        
                        Avplayer.player?.rate = 0
                    }
                    
                    // Setting Back View To Login...
                    withAnimation(.easeInOut){
                        log_Status = false
                    }
                    
                }, label: {
                    
                    Text("Log Out")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical,12)
                        .frame(width: UIScreen.main.bounds.width / 2)
                        .background(Color.yellow)
                        .clipShape(Capsule())
                })
            }
            .navigationTitle("Hello, " + " \(Name)")
        }
    }
}

struct Logout_Previews: PreviewProvider {
    static var previews: some View {
        Logout()
    }
}
