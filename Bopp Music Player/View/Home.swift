//
//  Home.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-06-06.
//

import SwiftUI

struct Home: View {
    
    @StateObject var player = MusicPlayerViewModel()
  
    @GestureState var gestureOffset: CGFloat = 0
    
    @ObservedObject var audio = AudioSetup()
    
    var body: some View {
        
        ZStack(alignment: .bottom, content: {
          
            NavigationView {
                
                List(landmarks, id: \.name) { landmark in
                 
                HStack(spacing: 15){
             
                LandmarkRow(landmark: landmark)
                    .padding(.horizontal)
                    .onTapGesture {
                        withAnimation{
                            
                            player.showPlayer = true
                            
                            print("I was Tapped")
                            
                            player.isPlaying = true
                            
                            player.positions = landmark.id - 1
                            
                           
                            //audio.playSound(SongPosition: player.position)
                            
                            Position.sharedInstance.position = landmark.id - 1
                            
                            
                            //AudioPlayer.sharedInstance.player?.play()
                            
                            AudioPlayer.sharedInstance.playSong()
                          
                            
                            //print(player.position, "IN HOME View")
                          }
                        
                    }
                    Button(action: {
                        
                        //audio.stop()
                            
                    }, label: {
                        
                            Image(systemName: "play.fill")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            
                        }
                    )
                
                }
                    
                }.navigationTitle("Songs")
               
            }
            
            
            if player.showPlayer{
                Miniplayer()
                // Move From Bottom...
                    .transition(.move(edge: .bottom))
                    .offset(y: player.offset)
                    .gesture(DragGesture().updating($gestureOffset, body: { (value, state, _) in
                        
                        state = value.translation.height
                        
                       
                        print("WE GOING UP OR DOWN?")
                    })
                    .onEnded(onEnd(value:)))
            }
            }).onChange(of: gestureOffset, perform: { value in
        onChanged()
    })
        .environmentObject(player)
        
        
}
    
    func onChanged(){
        
        if gestureOffset > 0 && !player.isMiniPlayer && player.offset + 180 <= player.height{
        
            player.offset = gestureOffset
        }
    }
    
    func onEnd(value: DragGesture.Value){
        withAnimation(.default){

            if !player.isMiniPlayer{
                
                player.offset = 0
                
                // Closing View...
                if value.translation.height > UIScreen.main.bounds.height / 3{
                    
                    player.isMiniPlayer = true
                    
                    print("WE SUPPOSSED TO END")
                }
                else{
                    player.isMiniPlayer = false
                }
            }
        }
    }

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
}
