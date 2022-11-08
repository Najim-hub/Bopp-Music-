//
//  LoginWithGoogle.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2022-06-28.
//

import SwiftUI
import GoogleSignIn

struct GoogleSignInButton: UIViewRepresentable {
  @Environment(\.colorScheme) var colorScheme
  
  private var button = GIDSignInButton()

  func makeUIView(context: Context) -> GIDSignInButton {
    button.colorScheme = colorScheme == .dark ? .dark : .light
    return button
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {
    button.colorScheme = colorScheme == .dark ? .dark : .light
  }
}

struct LoginWithGoogle: View {
    
    @AppStorage("log_status") var log_Status = true
    
    @EnvironmentObject var viewModel: AuthenticationViewModel

    
    var body: some View {
        ZStack{
            
            Image("bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width)
                .overlay(Color.black)
                .ignoresSafeArea()
            
            VStack(spacing: 25){
                
                Text("Bopp")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.accentColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                  
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 30, content: {
                    
                    Text("Music\nTaken to the Next Level")
                        .font(.system(size: 45))
                        .fontWeight(.heavy)
                        .foregroundColor(Color.accentColor)
                    
                    Text("The internet's source of freely-usable music. Powered by creators everywhere for you.")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                  
                    
                })
                .padding(.horizontal,30)
                
                Spacer()
                
                
                Spacer()
                GoogleSignInButton()
                     .padding()
                     .onTapGesture {
                       viewModel.signIn()
                     }
                    
                
                }
                

            }
        }
    }


struct LoginWithGoogle_Previews: PreviewProvider {
    static var previews: some View {
        LoginWithGoogle()
    }
}
