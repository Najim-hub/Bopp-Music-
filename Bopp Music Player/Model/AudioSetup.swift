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
    
    let commandCenter = MPRemoteCommandCenter.shared()
    
    var playerDuration: TimeInterval = 0
    
    //@ObservedObject var playController = playControl.sharedInstance
    
    var playController = playControl.sharedInstance
    
    
    //var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    // Define Now Playing Info
    var nowPlayingInfo = [String : Any]()
    
    public var position : Int = 0
    
    @Published public var songs = [Landmark]()
    
    public var isPlaying : Bool = true
    
    var player = MusicPlayerViewModel()
    
    //public var ValuePlay : TimeInterval = 0.0
    
    func volumeChanged(_ notification: NSNotification) {
       if let volume = notification.userInfo!["AVSystemController_AudioVolumeNotificationParameter"] as? Float {
           print("volume: \(volume)")
       }
   }
    
    func didTapNextButton(){
        
        var Position = (position - 1) + 1
        
        print(Position, "in Next Button")
        
        print(landmarks.count, "Land Mark size")
        
         
         if Position < landmarks.count {
             
            
            Position = Position + 1
             
            print(Position, "Adding one to Position")
           
                
             print(Position,"Next Song")
            
             
         }
         
       
       }
  
    func setupRemoteTransportControls() -> Bool {
        
        let commandCenter = MPRemoteCommandCenter.shared()
      
        AudioPlayer.sharedInstance.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = landmarks[playController.position].trackName

        if let image = UIImage(named: landmarks[playController.position].imageName) {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = AudioPlayer.sharedInstance.player?.currentTime
        
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = AudioPlayer.sharedInstance.player?.duration
        
        
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = AudioPlayer.sharedInstance.player?.rate

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            
            if AudioPlayer.sharedInstance.player?.isPlaying == false {
            
                AudioPlayer.sharedInstance.player?.play()
                
                AudioPlayer.sharedInstance.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
             
                
            }
            return .commandFailed
        }

        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if AudioPlayer.sharedInstance.player?.rate == 1.0 {
                
                AudioPlayer.sharedInstance.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
                
                AudioPlayer.sharedInstance.player?.pause()
               
                
                return .success
            }
            return .commandFailed
        }
        
     return isPlaying
    }


}

class AudioPlayer:  NSObject, AVAudioPlayerDelegate {
    
    
    var player: AVAudioPlayer? = AVAudioPlayer()
    
    var playController = playControl.sharedInstance
    
    
    var MPlayer = MusicPlayerViewModel()
    
    var audio = AudioSetup()
    
    let commandCenter = MPRemoteCommandCenter.shared()
    
    var playerDuration: TimeInterval = 0
    
    var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    // Define Now Playing Info
    var nowPlayingInfo = [String : Any]()
    
    
    
    //var players = MusicPlayerViewModel()
   static let sharedInstance = AudioPlayer()
    
func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            
            AudioPlayer.sharedInstance.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
            
            playControl.sharedInstance.playValue = AudioPlayer.sharedInstance.player?.currentTime ?? 0.1
             
            if playController.position < landmarks.count - 1   {
                
            MPlayer.positions =  MPlayer.positions + 1
      
                playController.position =  playController.position + 1
           
            AudioPlayer.sharedInstance.playSong()
            
            playControl.sharedInstance.isPlaying = true
          
            }
            
            else{
                playController.position = playController.position
            }
            
        } else {
            // did not finish successfully
        }
    }
    
    func audioRouteChanged(note: Notification) {
      if let userInfo = note.userInfo {
        if let reason = userInfo[AVAudioSessionRouteChangeReasonKey] as? Int {
            if reason == AVAudioSession.RouteChangeReason.oldDeviceUnavailable.rawValue {
            // headphones plugged out
            player?.play()
          }
        }
      }
    }
    
    
    
    func playSong(){
        
        if playController.position <= landmarks.count - 1 && playController.position >= 0{
            
            
         print(playController.position)
    
    let urlString = Bundle.main.path(forResource: landmarks[playController.position].trackName, ofType: "mp3")
    
    print(playController.position, "Within position")
        
    let fileUrl = NSURL(fileURLWithPath: urlString!)
        
    
    do {
        
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        try AVAudioSession.sharedInstance().setMode(.default)
        try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)

        
    try player = AVAudioPlayer(contentsOf:fileUrl as URL)

        player?.play()
        
       
        
        playerDuration = player?.duration ?? 0.1
        
        //print("SONG time: ", player?.currentTime as Any )
        
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
        
        playControl.sharedInstance.isPlaying = true
        
        player?.delegate = self
        
    

    }
    catch {
        print("error occurred")
    
    }
        
   }
        
    }
    
   
    override private init() {
        
        print("init singletion")
    }
    
    
    
    deinit {
           print("deinit singleton")
       }
    
}


