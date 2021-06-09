//
//  AudioSetup.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-06-07.
//

import Foundation
import UIKit
import AVFoundation
import MediaPlayer




class AudioSetup: ObservableObject {
    
    //public var ifPlaying : Bool = false
    
    //public var audioPlayer: AVAudioPlayer? = nil
    
    
    public var position : Int = 0
    
    @Published public var songs = [Landmark]()
    
    public var isPlaying : Bool = false
    
    var player = MusicPlayerViewModel()
    
    public var ValuePlay : TimeInterval = 0.0
    
    func didTapNextButton(){
        
       // var Position  = Position
        var Position = (position - 1) + 1
        
        print(Position, "in Next Button")
        
        print(landmarks.count, "Land Mark size")
        
       // player.audioPlayer?.stop()
         
         if Position < landmarks.count {
             
            
            Position = Position + 1
             
            print(Position, "Adding one to Position")
           
         
            //audioPlayer?.stop()
            
            //playSound(SongPosition: Position)
            
            //audioPlayer?.play()
                
             print(Position,"Next Song")
            
             
         }
         
  
         
         
     }
    
    
}

class AudioPlayer {
    
    var player: AVAudioPlayer? = AVAudioPlayer()
    
    var MPlayer = MusicPlayerViewModel()
    
    var audio = AudioSetup()
    
  var playerDuration: TimeInterval = 0
    
   var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()

    //var players = MusicPlayerViewModel()
   static let sharedInstance = AudioPlayer()
    
    
    class func destroy() {
        sharedInstance.player = nil
      }
    
    
    func playSong(){
        
        if Position.sharedInstance.position <= landmarks.count - 1 && Position.sharedInstance.position >= 0{
            
            print(Position.sharedInstance.position)
    
    let urlString = Bundle.main.path(forResource: landmarks[Position.sharedInstance.position].trackName, ofType: "mp3")
    
    print(Position.sharedInstance.position, "Within position")
        
        //Position.sharedInstance.position = Position.sharedInstance.position
    
    let fileUrl = NSURL(fileURLWithPath: urlString!)
    
        //player.audioPlayer?.stop()
    
    do {
        
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        try AVAudioSession.sharedInstance().setMode(.default)
        try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)

        
    try player = AVAudioPlayer(contentsOf:fileUrl as URL)

        player?.play()
        
        playerDuration = player?.duration ?? 0
        
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
        
        MPlayer.isPlaying = true
        
    
    }
    
    catch {
        print("error occurred")
    
    }
        }
   }
    
    private init() {
        
        print("init singletion")
    }
    
    
    
    deinit {
           print("deinit singleton")
       }
    
}
