//
//  Home.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-06-06.
//

import SwiftUI
import AVFoundation
import MediaPlayer

struct Home: View {
    
    @StateObject var player = MusicPlayerViewModel()
  
    @GestureState var gestureOffset: CGFloat = 0
    
    @ObservedObject var playController = playControl.sharedInstance
    
    @ObservedObject var audio = AudioSetup()
    
    @State var states : Bool = false


    
    
    var body: some View {
        
        ZStack(alignment: .bottom, content: {
          
            NavigationView {
                
               // List(landmarks, id: \.name) { landmark in
                
                List{
//let array = Array(landmarks).sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
                    
                ForEach(landmarks, id: \.id) { landmark in
                
                HStack(spacing: 15){
                    
                    LandmarkRow(landmark: landmark)
                    .padding(.horizontal)
                    .onTapGesture {
                        withAnimation{
                            
                            playController.showPlayer = true
                            
                            print("I was Tapped")
                            
                            playController.isPlaying = true
                            
                            playController.position = landmark.id - 1
                            
                            AudioPlayer.sharedInstance.playSong()
                            
                            HapticFeedBack.shared.hit(0.3)
                        
                            }
                        }
                    
                    Button(action: {
                        
                        HapticFeedBack.shared.hit(0.3)
                    
                        playController.showPlayer = true
                        
                        print("I was Tapped")
                        
                        playController.isPlaying = true
                        
                        player.positions = landmark.id - 1
                        
                        playController.position = landmark.id - 1
                        
                        AudioPlayer.sharedInstance.playSong()
                        
                 
                            
                    }, label: {
                        
                            Image(systemName: "")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            
                    }
                    )
                    
                    
                    Spacer()
                    
                    Button(action: {}) {
                        
                        Image(systemName: "ellipsis")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }.frame(width: 50, height: 50, alignment: .trailing)
                    .offset(x: 5)
                    
                
                }
                 
                }
                }
                .offset(y: playController.isMini ? -100 : 0)
                
                .navigationBarTitle(Text("Songs"), displayMode: .automatic)
           
                
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
             
               player.soundLevel =  AVAudioSession.sharedInstance().outputVolume
                
                
                AudioPlayer.sharedInstance.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
                
                playController.playValue = AudioPlayer.sharedInstance.player?.currentTime ?? 0
                
      
                print(playController.playValue, "You Back??!!")
         
            }
            
            
            /*
            if playControl.sharedInstance.showPlayer {
                Miniplayer()
                    .zIndex(2.0)
                .transition(.move(edge: .bottom))
                    .offset(y: player.offset)
                    .gesture(DragGesture().updating($gestureOffset, body: { (value, state, _) in
                        
                        state = value.translation.height
                        
                       
                       
                    })
                    .onEnded(onEnd(value:)
                    
                    
                    ))
            }*/
            })
        .onChange(of: gestureOffset, perform: { value in
        onChanged()
            
    }
 
 )
        //.environmentObject(player)
        
        
}
    
    
    func onChanged(){
        
        if gestureOffset > 0 && !playController.isMini && playController.offset + 180 <= playController.height{
        
            playController.offset = gestureOffset
        }
    }
    
    func onEnd(value: DragGesture.Value){
        withAnimation(.default){

            if !playController.isMini{
                
                playController.offset = 0
                
                // Closing View...
          if value.translation.height > UIScreen.main.bounds.height / 3
                {
                    
            playController.isMini = true
                    
                    
                }
                else{
                    playController.isMini = false
                    
                 
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
