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
                
                Image("alien")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width/1.5, height: UIScreen.main.bounds.height/3, alignment: .center)
                    .shadow(color: Color.yellow, radius: 20, x: 50, y: 50)
                Text("Click the logout button to exit")
                    .offset(y:-22)
                
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
                        .fontWeight(.heavy)
                        .background(Color.yellow)
                        .frame(width: UIScreen.main.bounds.width/1.5, height: 45, alignment: .center)
                        .font(.system(size: 25))
                        .padding()
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(15)
                        
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
