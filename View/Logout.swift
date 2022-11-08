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
    
    @AppStorage("AccountNumber") var AccountNumber = ""
    
    @AppStorage("AccountBalance") var AccountBalance = ""
    
    
    @AppStorage("ValidAddress") var ValidAddress = false
    
    var body: some View {
        
        if Name != ""{
        NavigationView{
            
            VStack(spacing: 20){
                
                Image("alien")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width/1.5, height: UIScreen.main.bounds.height/3, alignment: .center)
                    .shadow(color: Color.yellow, radius: 20, x: 50, y: 50)
                    .offset(y:  -UIScreen.main.bounds.height/25)
                
                Text("Click the logout button to exit")
                    .offset(y:  -UIScreen.main.bounds.height/25)
                
                Button(action: {
                    DispatchQueue.global(qos: .background).async {
                        
                        try? Auth.auth().signOut()
                        
                        Avplayer.player?.rate = 0
                    }
                    
                    withAnimation(.easeInOut){
                        log_Status = false
                    }
                    
                }){
                
               
                
                  Text("Log Out")
                    
                        .font(.system(size: 20))
                        .offset(x: -30)
                        
                        
               }.frame(width: UIScreen.main.bounds.width/1.5, height: 45, alignment: .center)
              .padding()
                .background(Color.yellow)
                .foregroundColor(.black)
                .cornerRadius(15)
            .offset(y:-UIScreen.main.bounds.height/25)
          
        
                
                Spacer()
                
                Button(action: {
                    
                    AccountNumber = ""
                    
                    AccountBalance = ""
                    
                    ValidAddress = false
                    
                }, label: {
                    
                    Text("Disconnect Wallet")
                        .background(Color.yellow)
                        .frame(width: UIScreen.main.bounds.width/1.5, height: 45, alignment: .center)
                        .font(.system(size: 20))
                        .padding()
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(15)
                        .offset(y:  -UIScreen.main.bounds.height/25)
                       
                    
                        
                }
                )
                
                
                
             
            }
             .padding(.bottom, 65)
             .navigationTitle("Hello " + " \(Name)")
            
        }
    }
        
        else{
        
        NavigationView{
            
            VStack(spacing: 20){
                
                Image("alien")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width/1.5, height: UIScreen.main.bounds.height/3, alignment: .center)
                    .shadow(color: Color.yellow, radius: 20, x: 50, y: 50)
                    .offset(y:  -UIScreen.main.bounds.height/25)
                
                Text("Click the logout button to exit")
                    .offset(y:  -UIScreen.main.bounds.height/25)
                
                Button(action: {
                    
                    DispatchQueue.global(qos: .background).async {
                        
                        try? Auth.auth().signOut()
                        
                        Avplayer.player?.rate = 0
                    }
                    
                    withAnimation(.easeInOut){
                        log_Status = false
                    }
                    
                }, label: {
                    
                    Text("Log Out")
                       
                        .background(Color.yellow)
                        .frame(width: UIScreen.main.bounds.width/1.5, height: 25, alignment: .center)
                        .font(.system(size: 20))
                        .padding()
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(15)
                        .offset(y:  -UIScreen.main.bounds.height/25)
                        })
                
                Button(action: {
                    
                    AccountNumber = ""
                    
                    AccountBalance = ""
                    
                    ValidAddress = false
                    
                }, label: {
                    
                    Text("Disconnect Wallet")
                   
                        .background(Color.yellow)
                        .frame(width: UIScreen.main.bounds.width/1.5, height: 25, alignment: .center)
                        .font(.system(size: 20))
                        .padding()
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(15)
                        .offset(y:  -UIScreen.main.bounds.height/25)
                       
                    
                        
                }
                )
            }
             .padding(.bottom, 65)
            
            
        }
        
    }
    }
}

struct Logout_Previews: PreviewProvider {
    static var previews: some View {
        Logout()
    }
}
