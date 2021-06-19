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
    
    @State var gradient = [Color.white, Color.blue, Color.yellow]
    @State var startPoint = UnitPoint(x: 0, y: 0)
    @State var endPoint = UnitPoint(x: 0, y: 2)
    
    // ScreenHeight..
    @EnvironmentObject var player: MusicPlayerViewModel
    
    var timeNow = currentTime.sharedInstance
    @State var timeObserverToken: Any?
    @GestureState var gestureOffset: CGFloat = 0
    
    var expand: Bool = false
    
    @State var seeking: Bool = false
    
    @ObservedObject var playController = playControl.sharedInstance
    
    var height = UIScreen.main.bounds.height / 3
    
    @ObservedObject var audio = AudioSetup()
    
    //@ObservedObject var adjust = AudioSetup()
    
    @ObservedObject var songList = loadInfo.sharedInstance
    
    @ObservedObject var Avplayer = AudioPlayer.sharedInstance
    
    //@State var seekPos : Float = AudioSetup().playValue
    
    var home = Home()
    // Volume Slider...
    
    @State var volume : CGFloat = 0
    
    //@State private var soundLevel: Float = AVAudioSession.sharedInstance().outputVolume
    
    let commandCenter = MPRemoteCommandCenter.shared()
    // Define Now Playing Info
    var nowPlayingInfo = [String : Any]()
    
    
    @ObservedObject var val = playVal.sharedInstance
    
    var body: some View {
        
   
        VStack(){
            // Video Player...
            Capsule()
                .fill(Color.gray)
                .frame(width:  playController.isMini ? 0 : 45, height:  playController.isMini ? 0 : 4)
                .opacity(1)
                
            
            HStack(spacing: 16){
                
                HStack {
                    
                   
                    Image(songList.songs[playController.position].imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                        
                    .cornerRadius(5)
                       
                    .frame(width: playController.isMini ? 67 : 390, height: playController.isMini ? 55 : 365)
                 
                    .clipShape(Circle())
                    .overlay(Circle().stroke(LinearGradient(gradient: Gradient(colors: self.gradient), startPoint: self.startPoint, endPoint: self.endPoint), lineWidth: 4))
                    .shadow(radius: 7)
            
                }.padding(.top, playController.isMini ? 0 : 15)
                .padding()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                VideoControls()
            )
            
            
            GeometryReader{ reader in
                
                VStack{
                    VStack(spacing: 10){
                       
                      
                        HStack{
                            
                            VStack{
                            Text(songList.songs[playController.position].name)
                                .font(.title3)
                            .foregroundColor(.primary)
                              .fontWeight(.bold)
                             .frame(width: 270, height: 20, alignment: .leading)
                             .padding(.top, 55)
                                
                                Text(songList.songs[playController.position].artistName)
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
                    
                       
     HStack(spacing: 15){
                            
         Slider(value: $val.playValue,in: Float(TimeInterval(0.0))...Float(Double(AudioPlayer.sharedInstance.floatTime)) , onEditingChanged: { _ in
             
             self.audio.changeSliderValue()
             
         print("Seeking")
    
            })
           .onReceive(AudioPlayer.sharedInstance.timer) { _ in
                    if self.Avplayer.player!.rate > 0 {
                          
                self.val.playValue = Float( CMTimeGetSeconds(self.Avplayer.player!.currentTime()))
                            
                       }
                                       }
           .accentColor(.yellow)
          .introspectSlider { UISlider in
            UISlider.setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
            UISlider.isContinuous = true
          
          
           }
           .onTapGesture {
               withAnimation{
                
               //Avplayer.player?.pause()
                
               } }
                      }.padding(20)
                        
                        HStack(spacing: 280){
                            
                            Text(String(transToMinSec(time: Float(val.playValue)) ))
                            .font(.system(size: 15))
                            
                            Text("-" + String(transToMinSec(time: AudioPlayer.sharedInstance.floatTime - Float(val.playValue))))
                                .font(.system(size: 15))
                            
                        }
                        
                        // Main Play Button...
                        HStack(spacing: 15){
                            
                            Button(action: {
                                
                                HapticFeedBack.shared.hit(0.3)
                                
                                
                            if playController.position <= songList.songs.count - 1 && playController.position != 0 {
                                
                                Avplayer.player?.rate = 0
                               
                                //Avplayer.player?.pause()
                                
                                playController.position =  playController.position - 1
                                
                                
                                
                                Avplayer.playSong()
                                
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
                                
                                   
                                
                               if Avplayer.player!.rate > 0{
                                
                                 Avplayer.player?.pause()
                                   
                                playController.isPlaying = false
                                    
                                Avplayer.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
                                    
                                    //audio.setupRemoteTransportControls()
                                    
                                                                    }
                                
                                else if Avplayer.player!.rate == 0
                                  {
                                    Avplayer.player?.play()
                                    
                                    playController.isPlaying = true
                                    
                                    Avplayer.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
                                    
                                    
                                    
                                   }
                                
                                    
                            }, label: {
                                
                                if  Avplayer.player!.rate > 0 //&& audio.setupRemoteTransportControls()
                                {
                                    Image(systemName: "pause.fill")
                                        .font(.system(size: 60, weight: .bold))
                                        .foregroundColor(.primary)
                                        
                                }
                                
                                else if Avplayer.player!.rate  == 0{
                                    
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
                                
                                //seekPos = 0
                            
                                
                                if playController.position < songList.songs.count - 1   {
                                    
                                    Avplayer.player?.rate = 0
                                    
                                    playController.position =  playController.position + 1
                                
                       
                                
                                    Avplayer.playSong()
                                
                                    playController.isPlaying = true
                              
                                }
                                
                                else{
                                    playController.position = playController.position
                                }
                              
                                
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
           
        .opacity(/*player.isMiniPlayer*/ playController.isMini ? 0 : getOpacity())
        .frame(height: /*player.isMiniPlayer*/ playController.isMini ? 0 : nil)
       
        }
        .background(
        
        VStack(spacing: 0){
            
            BlurView()
            
        }
           
        .ignoresSafeArea(.all, edges: .all)
        .onTapGesture {
            withAnimation (.easeInOut(duration: 0.3)){
                
                self.startPoint = UnitPoint(x: 1, y: -1)
                self.endPoint = UnitPoint(x: 0, y: 1)
                
                playController.width = UIScreen.main.bounds.width
                
                playController.isMini.toggle()
                
            }}
     
        
       )
        
       
        .background(
        Image(songList.songs[playController.position].imageName)
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
    
    /// Return a formatter for durations.
    var durationFormatter: DateComponentsFormatter {

        let durationFormatter = DateComponentsFormatter()
        durationFormatter.allowedUnits = [.minute, .second]
        durationFormatter.unitsStyle = .positional
        durationFormatter.zeroFormattingBehavior = .pad

        return durationFormatter
    }
    func getOpacity()->Double{
        
        let progress = playController.offset / (playController.height)
        if progress <= 1{
            return Double(1 - progress)
        }
        return 1
    }
    
    func changeSliderValue() {
        
     
        
        /*
        if AudioPlayer.sharedInstance.player?.isPlaying == false {
            //player?.play()
            playController.isPlaying = true
         
            AudioPlayer.sharedInstance.player?.currentTime = playController.playValue
            
           // print(player.playValue, "Change Slider Class as false")
        }*/
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
    
    @ObservedObject var songList = loadInfo.sharedInstance
    
    @EnvironmentObject var player: MusicPlayerViewModel
    
    @ObservedObject var audio = AudioSetup()
    
    @ObservedObject var playController = playControl.sharedInstance
    
    
    var body: some View{
       
        HStack(spacing: 15){
            
            
            Image("")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width:  55, height:  55)
                .cornerRadius(15)
            
            Text(songList.songs[playController.position].name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    
            
            Spacer(minLength: 0)
          
                Button(action: {
                    
                    HapticFeedBack.shared.hit(0.3)
                
                    if  playController.isPlaying == true{
                        AudioPlayer.sharedInstance.player?.pause()
                       
                        playController.isPlaying = false
                        
                    }
                    
                    else{
                        AudioPlayer.sharedInstance.player?.play()
                        
                     
                        playController.isPlaying = true
                      
                    }
                    
                    
                }, label: {
                    if  playController.isPlaying == true //&& //audio.setupRemoteTransportControls()
                    {
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
                    
                    //playController.playValue = 0.0
                
                    
                    if playController.position < songList.songs.count - 1   {
                        
                  
                        playController.position =  playController.position + 1
                    
                 
                    
                         AudioPlayer.sharedInstance.playSong()
                    
                        playController.isPlaying = true
                  
                    }
                    
                    else{
                        playController.position = playController.position
                    }
                 
                    
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





