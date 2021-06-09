//
//  Miniplayer.swift
//  AppleMusic
//
//  Created by Balaji on 16/11/20.
//

import SwiftUI
import AVFoundation
import MediaPlayer


struct Miniplayer: View {
    
    // ScreenHeight..
    @EnvironmentObject var player: MusicPlayerViewModel
    
    var expand: Bool = false
    
    
    var height = UIScreen.main.bounds.height / 3
    
    
    @ObservedObject var audio = AudioSetup()
    
    var home = Home()
    // Volume Slider...
    
    @State var volume : CGFloat = 0
    
    
    var body: some View {
        
        
        
        VStack(){
            // Video Player...
            
            Capsule()
                .fill(Color.gray)
                .frame(width: player.isMiniPlayer ? 0 : 45, height: player.isMiniPlayer ? 0 : 4)
                .opacity(1)
                .padding(.bottom, 15)
                //.padding(.vertical, 30)*/
            
            HStack(spacing: 16){
                
                //Spacer(minLength: 0)
                //Spacer(minLength: 0)
                HStack {
                    
                    Image(landmarks[player.positions].imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                        //.frame(width: expand ? height : 55, height: expand ? height : 55)
                        .cornerRadius(5)
                        //.frame(width: 350, height: 350, alignment: .top)
                        // .padding(.top, 45)
                    .frame(width: player.isMiniPlayer ? 67 : 390, height: player.isMiniPlayer ? 55 : 365)
                    //.padding(.init(top: 45, leading: 35, bottom: 25, trailing: 35))
                    //.padding(.trailing, 17)
                        .clipShape(Circle())
                                   .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                   .shadow(radius: 7)
               // Spacer(minLength: 0)
                
                }.padding()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
            
                // Controls...
                VideoControls()
            )
            
            
            GeometryReader{ reader in
                
                VStack{
                    VStack(spacing: 10){
                       
                      
                        HStack{
                           
                            Text(landmarks[Position.sharedInstance.position].name)
                          .font(.title3)
                        .foregroundColor(.primary)
                          .fontWeight(.bold)
                         .frame(width: 270, height: 100, alignment: .leading)
                                .padding(.top, 55)
                            Spacer(minLength: 0)
                             
                            
                            Button(action: {}) {
                                
                                Image(systemName: "ellipsis.circle")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                            }.padding(.top, 55)
                      
                    }
                    .padding(.top,30)
                    
                        
                        // Audio time String...
                        
                        //Spacer(minLength: 0)
                        HStack(spacing: 15){
                            
                            Slider(value: $volume)
                            .accentColor(.yellow)
                                
                            
                        }.padding(20)
                        
                        HStack(spacing: 280){
                         
                        }
                        
                        // Main Play Button...
                        HStack(spacing: 15){
                            
                            Button(action: {
                                
                                if Position.sharedInstance.position <= landmarks.count - 1 && Position.sharedInstance.position != 0 {
                                
                                print(Position.sharedInstance.position)
                                
                                player.positions =  player.positions - 1
                                
                                print("tapped back button")
                              
                                Position.sharedInstance.position =  Position.sharedInstance.position - 1
                                
                                print(Position.sharedInstance.position, "New position")
                                
                                AudioPlayer.sharedInstance.playSong()
                                
                                player.isPlaying = true
                                }
                                
                                else{
                                    
                                }
                                
                            
                                
                            }) {
                                
                                Image(systemName: "backward.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.primary)
                            }
                            
                            .padding(10)
                            
                            Button(action: {
                                
                                
                                if AudioPlayer.sharedInstance.player?.isPlaying == true{
                                    AudioPlayer.sharedInstance.player?.pause()
                                   
                                    player.isPlaying = false
                                    
                                }
                                
                                else{
                                    AudioPlayer.sharedInstance.player?.play()
                                    
                                    player.isPlaying = true
                                  
                                }
                                
                                    
                            }, label: {
                                
                                if player.isPlaying {
                                    Image(systemName: "pause.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.primary)
                                }
                                
                                else{
                                    
                                    Image(systemName: "play.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.primary)
                                    
                                }
                                    
                                }
                            )
                            .padding(20)
                            .padding(.bottom,5)
                            
                            Button(action: {
                                
                                if Position.sharedInstance.position < landmarks.count - 1   {
                                    
                                    print(landmarks.count, "Json file length")
                                
                                print(Position.sharedInstance.position)
                                
                                player.positions =  player.positions + 1
                                
                                print("tapped next button")
                              
                                Position.sharedInstance.position =  Position.sharedInstance.position + 1
                                
                                print(Position.sharedInstance.position, "New position")
                                
                                AudioPlayer.sharedInstance.playSong()
                                
                                player.isPlaying = true
                              
                                }
                                
                                else{
                                    player.positions = Position.sharedInstance.position
                                }
                                //AudioPlayer.sharedInstance.player?.play()
                                
                                
                            }, label: {
                                Image(systemName: "forward.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.primary)
                            })
                            
                        }
                          
                    HStack(spacing: 15){
                        
                        Image(systemName: "speaker.fill")
                        
                        Slider(value: $volume)
                            .accentColor(.gray)
                        Image(systemName: "speaker.wave.2.fill")
                    }
                    .padding()
                    
                    HStack(spacing: 22){} .padding(.bottom,390)
                  
                        
                    }
                    .padding()// this will give strech effect...
                   .frame(height:  0)
                   .opacity( 1 )
                 // expanding to full screen when clicked...
                 .frame(maxHeight: true ? .infinity : 90)
                 .onAppear(perform: {
                    player.height = reader.frame(in: .global).height + 250
                })
                }
        } .padding(.init(top: 265, leading: 15, bottom: 0, trailing: 15))
            //.frame(width: 20, height: 20, alignment: .center)
            //.padding(.top, 350)
        //.background(Color.yellow)
        .opacity(player.isMiniPlayer ? 0 : getOpacity())
        .frame(height: player.isMiniPlayer ? 0 : nil)
       
       }.background(
        
        VStack(spacing: 0){
            
            BlurView()
            
            Divider()
        }.ignoresSafeArea(.all, edges: .all)
        .onTapGesture {
            withAnimation{
                
                print("YOU CALLED?")
                
                player.width = UIScreen.main.bounds.width
                
                player.isMiniPlayer.toggle()
                
               
            }
            
        }


        
          //Color.gray
        //LinearGradient(gradient: Gradient(colors: [.white, .gray, .black]), startPoint: .top, endPoint: .bottom)
            
        
            
        
        
        
       )
        
    }
        
    
    
    // Getting Frame And Opacity While Dragging
    
    func getFrame()->CGFloat{
        
        let progress = player.offset / (player.height - 100)
        
        if (1 - progress) <= 1.0{
         
            let videoHeight : CGFloat = (1 - progress) * 250
            
            // stopping height at 70...
            if videoHeight <= 70{
                
                // Decresing Width...
                let percent = videoHeight / 70
                let videoWidth : CGFloat = percent * UIScreen.main.bounds.width
                DispatchQueue.main.async {
                    // Stopping At 150...
                    if videoWidth >= 150{
                    
                        player.width = videoWidth
                    }
                }
                return 70
            }
            // Preview WIll Have Animation Problems...
            DispatchQueue.main.async {
                player.width = UIScreen.main.bounds.width
            }
            
            return videoHeight
        }
        return 250
    }
    
    func getOpacity()->Double{
        
        let progress = player.offset / (player.height)
        if progress <= 1{
            return Double(1 - progress)
        }
        return 1
    }
}

struct MiniPlayer_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}


struct VideoControls: View {
    
    @EnvironmentObject var player: MusicPlayerViewModel
    
    var body: some View{
        /*
        
        HStack(spacing: 15){
            //Spacer()
            // Video View...
            Rectangle()
                .frame(width: 90, height: 55)
                .opacity(1)
            
           
            Text(landmarks[player.position - 1].name)
                .font(.title)
                .foregroundColor(.yellow)
                 .lineLimit(1)
                 .padding(.leading, 185)
            
            
            Button(action: {}, label: {
                Image(systemName: "play.fill")
                    .font(.largeTitle)
                    .foregroundColor(.yellow)
                
                    //.frame(width: 20, height: 75)
            }).padding(.leading, 185)
            
            Button(action: {
                //withAnimation{
                    player.showPlayer.toggle()
                    player.offset = 0
                    player.isMiniPlayer.toggle()
                //}
            }, label: {
                Image(systemName: "xmark")
                    .font(.title)
                    .foregroundColor(.white)
                    //.padding(.leading, 45)
                    
            })
            
            Spacer()
        } //.frame(width: 655, height: 55)
          
        .padding(.trailing)*/
        
        HStack(spacing: 15){
            
            // centering IMage...
            
            //if expand{Spacer(minLength: 0)}
            
            Image("pic")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width:  55, height:  55)
                .cornerRadius(15)
            
            Text(landmarks[Position.sharedInstance.position].name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    
            
            Spacer(minLength: 0)
          
                Button(action: {
                    if AudioPlayer.sharedInstance.player?.isPlaying == true{
                        AudioPlayer.sharedInstance.player?.pause()
                       
                        player.isPlaying = false
                        
                    }
                    
                    else{
                        AudioPlayer.sharedInstance.player?.play()
                        
                     
                        
                        player.isPlaying = true
                      
                    }
                    
                    
                }, label: {
                    if player.isPlaying {
                        Image(systemName: "pause.fill")
                            .font(.title)
                            .foregroundColor(.primary)
                    }
                    
                    else {
                        
                        Image(systemName: "play.fill")
                            .font(.title)
                            .foregroundColor(.primary)
                        
                    }
                })
                
                Button(action: {
                    print(Position.sharedInstance.position)
                    
                    player.positions =  player.positions + 1
                    
                    print("tapped next button")
                  
                    Position.sharedInstance.position =  Position.sharedInstance.position + 1
                    
                    print(Position.sharedInstance.position, "New position")
                    
                    AudioPlayer.sharedInstance.playSong()
                    
                    player.isPlaying = true
                  
                    //AudioPlayer.sharedInstance.player?.play()
                    
                    
                    
                    
                }, label: {
                    
                    Image(systemName: "forward.fill")
                        .font(.title)
                        .foregroundColor(.primary)
                }).padding(.trailing, 15)
            
           
            }.padding(.horizontal)
        .frame(width: 390, height: 55, alignment: .center)
        
    }

}



