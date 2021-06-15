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
    
    @GestureState var gestureOffset: CGFloat = 0
    
    var expand: Bool = false
    
    @ObservedObject var playController = playControl.sharedInstance
    
    var height = UIScreen.main.bounds.height / 3
    
    
    @ObservedObject var audio = AudioSetup()
    
    var home = Home()
    // Volume Slider...
    
    @State var volume : CGFloat = 0
    
    //@State private var soundLevel: Float = AVAudioSession.sharedInstance().outputVolume
    
    let commandCenter = MPRemoteCommandCenter.shared()
    // Define Now Playing Info
    var nowPlayingInfo = [String : Any]()
    
    
    
    
    var body: some View {
        
        
        
        VStack(){
            // Video Player...
            
            Capsule()
                .fill(Color.gray)
                .frame(width:  playController.isMini ? 0 : 45, height:  playController.isMini ? 0 : 4)
                .opacity(1)
                
            
            HStack(spacing: 16){
                
                HStack {
                    
                    Image(landmarks[playController.position].imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                        
                    .cornerRadius(5)
                       
                    .frame(width: playController.isMini ? 67 : 390, height: playController.isMini ? 55 : 365)
                 
                    .clipShape(Circle())
                                   .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                   .shadow(radius: 7)
            
                }.padding(.top, playController.isMini ? 0 : 15)
                .padding()
            }
            //.padding(.bottom, 35)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
            
                // Controls...
                VideoControls()
            )
            
            
            GeometryReader{ reader in
                
                VStack{
                    VStack(spacing: 10){
                       
                      
                        HStack{
                            
                            VStack{
                            Text(landmarks[playController.position].name)
                                .font(.title3)
                            .foregroundColor(.primary)
                              .fontWeight(.bold)
                             .frame(width: 270, height: 20, alignment: .leading)
                             .padding(.top, 55)
                                
                                Text(landmarks[playController.position].artistName)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .fontWeight(.bold)
                                .frame(width: 270, height: 20, alignment: .leading)
                                //.padding(.top, 55)
                            }
                            
                            
                            Spacer(minLength: 0)
                             
                            
                            Button(action: {}) {
                                
                                Image(systemName: "ellipsis.circle")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                            }.padding(.top, 55)
                      
                    }
                    .padding(.top,90)
                    
                        
                        // Audio time String...
                        
                        //Spacer(minLength: 0)
           HStack(spacing: 15){
                            
            Slider(value: $playController.playValue
                , in: TimeInterval(0.0)...AudioPlayer.sharedInstance.playerDuration, onEditingChanged: { _ in
                                changeSliderValue()
           })
           .accentColor(.yellow)
          
            .introspectSlider { UISlider in
                UISlider.setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
            }.onReceive(AudioPlayer.sharedInstance.timer) { _ in
                if playController.isPlaying {
                   //print(AudioPlayer.sharedInstance.playerDuration,"Player Duration")
                     if let currentTime =  AudioPlayer.sharedInstance.player?.currentTime {
                        
           playController.playValue = currentTime
                        
          
                        
             if currentTime == TimeInterval(0.0) {
                playController.isPlaying = false
               
                                                    }}}
                                            else {
                                                playController.isPlaying = false
                                                AudioPlayer.sharedInstance.timer.upstream.connect().cancel()
                                            }
                                        
                                  }
           .onTapGesture {
               withAnimation{
                
                AudioPlayer.sharedInstance.player?.pause()
                
               } }
                      }.padding(20)
                        
                        HStack(spacing: 280){
                            Text(String(transToMinSec(time: Float(playController.playValue)) ))
                            .font(.system(size: 15))
                            
                            Text("-" + String(transToMinSec(time: Float(AudioPlayer.sharedInstance.playerDuration -  playController.playValue))))
                                .font(.system(size: 15))
                            
                        }
                        
                        // Main Play Button...
                        HStack(spacing: 15){
                            
                            Button(action: {
                                
                                HapticFeedBack.shared.hit(0.3)
                                
                                playController.playValue = 0.0
                            
                                
                            if playController.position <= landmarks.count - 1 && playController.position != 0 {
                                
                                //print(Position.sharedInstance.position)
                                
                                //player.positions =  player.positions - 1
                                
                               // print("tapped back button")
                              
                                playController.position =  playController.position - 1
                                
                                //print(Position.sharedInstance.position, "New position")
                                
                                AudioPlayer.sharedInstance.playSong()
                                
                                playController.isPlaying = true
                                }
                                
                                else{
                                    
                                }
                                
                            
                                
                            }) {
                                
                                Image(systemName: "backward.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.primary)
                            }
                            
                            .padding(10)
                            
                            Button(action:
                                {
                                    
                                    HapticFeedBack.shared.hit(0.3)
                                
                                   
                                
                                if AudioPlayer.sharedInstance.player?.isPlaying == true{
                                    AudioPlayer.sharedInstance.player?.pause()
                                   
                                    playControl.sharedInstance.isPlaying = false
                                    
                                    AudioPlayer.sharedInstance.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
                                    
                                    audio.setupRemoteTransportControls()
                                    
                                                                    }
                                
                                else
                                  {
                                    AudioPlayer.sharedInstance.player?.play()
                                    
                                    playController.isPlaying = true
                                    
                                    AudioPlayer.sharedInstance.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
                                    
                                    
                                    
                                   }
                                
                                    
                            }, label: {
                                
                                if AudioPlayer.sharedInstance.player?.isPlaying == true && audio.setupRemoteTransportControls()
                                
                                {
                                    Image(systemName: "pause.fill")
                                        .font(.system(size: 60, weight: .bold))
                                        .foregroundColor(.primary)
                                        
                                }
                                
                                else{
                                    
                                    Image(systemName: "play.fill")
                                        .font(.system(size: 60, weight: .bold))
                                        .foregroundColor(.primary)
                                    
                                }
                                    
                                }
                            ).onTapGesture {
                               
                            }
                           
                            .padding(10)
                            .padding(.bottom,5)
                            
                            Button(action: {
                                
                                HapticFeedBack.shared.hit(0.3)
                                
                                playController.playValue = 0.0
                            
                                
                                if playController.position < landmarks.count - 1   {
                                    
                                //    print(landmarks.count, "Json file length")
                                
                              //  print(Position.sharedInstance.position)
                                
                                    //playController.position =  playController.position + 1
                                
                               // print("tapped next button")
                              
                                    playController.position =  playController.position + 1
                                
                             //   print(Position.sharedInstance.position, "New position")
                                
                                AudioPlayer.sharedInstance.playSong()
                                
                                    playController.isPlaying = true
                              
                                }
                                
                                else{
                                    playController.position = playController.position
                                }
                                //AudioPlayer.sharedInstance.player?.play()
                                
                                
                            }, label: {
                                Image(systemName: "forward.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.primary)
                            })
                            
                        }.frame(width: 80, height: 40, alignment: .center)
                        .padding(.bottom, 50)
                        .padding(.trailing, 15)
                        
                    HStack(spacing: 15){
                        
                        Image(systemName: "speaker.fill")
                        
                        Slider(value: $playController.soundLevel, in: 0...1,step: 0.0625, onEditingChanged: { data in
                    
                            
                            MPVolumeView.setVolume(self.playController.soundLevel)
                            
                            _ = MPVolumeView(frame: CGRect.zero)
                         
                          
                        })
                            .accentColor(.gray)
                        
                        
                        
                        Image(systemName: "speaker.wave.2.fill")
                    }
                    .padding()
                    
                    HStack(spacing: 22){
                
                       AirplayView()
                        .frame(width: 50, height: 50)
                        
                        
                    }
                    .padding(.bottom,390)
                  
                      
                        
                    }
                   .padding()// this will give strech effect...
                   .frame(height:  0)
                   .opacity(1)
                 // expanding to full screen when clicked...
                 .frame(maxHeight: true ? .infinity : 90)
                 .onAppear(perform: {
                    playController.height = reader.frame(in: .global).height + 250
                })
                }
        } .padding(.init(top: 265, leading: 15, bottom: 40, trailing: 15))
            //.frame(width: 20, height: 20, alignment: .center)
            //.padding(.top, 350)
        //.background(Color.yellow)
        .opacity(/*player.isMiniPlayer*/ playController.isMini ? 0 : getOpacity())
        .frame(height: /*player.isMiniPlayer*/ playController.isMini ? 0 : nil)
       
        }
        
        .background(
        
        VStack(spacing: 0){
            
            BlurView()
            
            //Divider()
        }
       // .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .ignoresSafeArea(.all, edges: .all)
        .onTapGesture {
            withAnimation{
                
                playController.width = UIScreen.main.bounds.width
                
                playController.isMini.toggle()
                
            }}
     
        
            
    
        
       /* .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = !player.isMiniPlayer
        }*/
        
       )
        
        
        .background(
        Image(landmarks[playController.position].imageName)
                   .resizable()
                 
       )
    
        
        
        
    }
    
  
    
        
    
    
    // Getting Frame And Opacity While Dragging
    
    func getFrame()->CGFloat{
        
        let progress = playController.offset / (playController.height - 100)
        
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
                    
                        playController.width = videoWidth
                    }
                }
                return 70
            }
            // Preview WIll Have Animation Problems...
            DispatchQueue.main.async {
                playController.width = UIScreen.main.bounds.width
            }
            
            return videoHeight
        }
        return 250
    }
    
    func getOpacity()->Double{
        
        let progress = playController.offset / (playController.height)
        if progress <= 1{
            return Double(1 - progress)
        }
        return 1
    }
    
    func changeSliderValue() {
        
        if AudioPlayer.sharedInstance.player?.isPlaying == true {
            
            //print(AudioPlayer.sharedInstance.player?.currentTime, "current Slider Class")
            
            AudioPlayer.sharedInstance.player?.currentTime = playControl.sharedInstance.playValue
            
         //   print(player.playValue, "Change Slider Class")
        }
        
        if AudioPlayer.sharedInstance.player?.isPlaying == false {
            //player?.play()
            playController.isPlaying = true
         
            AudioPlayer.sharedInstance.player?.currentTime = playController.playValue
            
           // print(player.playValue, "Change Slider Class as false")
        }
    }
    
  
    
    func transToMinSec(time: Float) -> String
    {
        let allTime: Int = Int(time)
        //var hours = 0
        var minutes = 0
        var seconds = 0
        //var hoursText = ""
        var minutesText = ""
        var secondsText = ""
        
       
        
        minutes = allTime % 3600 / 60
        minutesText = minutes > 9 ? "\(minutes)" : "\(minutes)"
        
        seconds = allTime % 3600 % 60
        secondsText = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        
        return "\(minutesText):\(secondsText)"

    }
    

}



struct MiniPlayer_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
    
    
}


struct VideoControls: View {
    
    @EnvironmentObject var player: MusicPlayerViewModel
    
    @ObservedObject var audio = AudioSetup()
    
    @ObservedObject var playController = playControl.sharedInstance
    
    
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
            
            Image("")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width:  55, height:  55)
                .cornerRadius(15)
            
            Text(landmarks[playController.position].name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    
            
            Spacer(minLength: 0)
          
                Button(action: {
                    
                    HapticFeedBack.shared.hit(0.3)
                
                    if AudioPlayer.sharedInstance.player?.isPlaying == true{
                        AudioPlayer.sharedInstance.player?.pause()
                       
                        playController.isPlaying = false
                        
                    }
                    
                    else{
                        AudioPlayer.sharedInstance.player?.play()
                        
                     
                        
                        playController.isPlaying = true
                      
                    }
                    
                    
                }, label: {
                    if AudioPlayer.sharedInstance.player?.isPlaying == true && audio.setupRemoteTransportControls() {
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
                    
                    
                    HapticFeedBack.shared.hit(0.3)
                    
                    playController.playValue = 0.0
                
                    
                    if playController.position < landmarks.count - 1   {
                        
                    //    print(landmarks.count, "Json file length")
                    
                  //  print(Position.sharedInstance.position)
                    
                        //playController.position =  playController.position + 1
                    
                   // print("tapped next button")
                  
                        playController.position =  playController.position + 1
                    
                 //   print(Position.sharedInstance.position, "New position")
                    
                    AudioPlayer.sharedInstance.playSong()
                    
                        playController.isPlaying = true
                  
                    }
                    
                    else{
                        playController.position = playController.position
                    }
                    //AudioPlayer.sharedInstance.player?.play()
                    
                    
                  
                    
                }, label: {
                    
                    Image(systemName: "forward.fill")
                        .font(.title)
                        .foregroundColor(.primary)
                }).padding(.trailing, 15)
            
           
            }
      
        .padding(.horizontal)
        .frame(width: 390, height: 55, alignment: .center)
        
    }
    
    

}





