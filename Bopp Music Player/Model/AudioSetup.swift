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
    
    //var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    // Define Now Playing Info
    var nowPlayingInfo = [String : Any]()
    
    public var position : Int = 0
    
    @Published public var songs = [Landmark]()
    
    public var isPlaying : Bool = true
    
    var player = MusicPlayerViewModel()
    
    //public var ValuePlay : TimeInterval = 0.0
    
    @objc func volumeChanged(_ notification: NSNotification) {
       if let volume = notification.userInfo!["AVSystemController_AudioVolumeNotificationParameter"] as? Float {
           print("volume: \(volume)")
       }
   }
    
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
  
    func setupRemoteTransportControls() -> Bool {
        
        let commandCenter = MPRemoteCommandCenter.shared()
      
        AudioPlayer.sharedInstance.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = landmarks[Position.sharedInstance.position].trackName

        if let image = UIImage(named: landmarks[Position.sharedInstance.position].imageName) {
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
                
                //player.isPlaying.toggle()
                
                //isPlaying = true
                
            }
            return .commandFailed
        }

        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if AudioPlayer.sharedInstance.player?.rate == 1.0 {
                
                /*
                self.audioPlayer?.pause()
 */
                AudioPlayer.sharedInstance.player?.pause()
                
                //player.isPlaying = false
                
                //isPlaying = false
                
                //layer.isPlaying.toggle()
                
                return .success
            }
            return .commandFailed
        }
        
     return isPlaying
    }


}

class AudioPlayer:  NSObject, AVAudioPlayerDelegate {
    
    var player: AVAudioPlayer? = AVAudioPlayer()
    
    var MPlayer = MusicPlayerViewModel()
    
    var audio = AudioSetup()
    
    let commandCenter = MPRemoteCommandCenter.shared()
    
    var playerDuration: TimeInterval = 0
    
    var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    // Define Now Playing Info
    var nowPlayingInfo = [String : Any]()
    
    //var players = MusicPlayerViewModel()
   static let sharedInstance = AudioPlayer()
    
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
    
    @objc func playerDidFinishPlaying(sender: Notification) {
        print("SONG ENDED")
    }
    
    
    func playSong(){
        
        if Position.sharedInstance.position <= landmarks.count - 1 && Position.sharedInstance.position >= 0{
            
            
         print(Position.sharedInstance.position)
    
    let urlString = Bundle.main.path(forResource: landmarks[Position.sharedInstance.position].trackName, ofType: "mp3")
    
    print(Position.sharedInstance.position, "Within position")
        
    let fileUrl = NSURL(fileURLWithPath: urlString!)
        
    
    do {
        
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        try AVAudioSession.sharedInstance().setMode(.default)
        try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)

        
    try player = AVAudioPlayer(contentsOf:fileUrl as URL)

        player?.play()
        
       
        
        playerDuration = player?.duration ?? 0
        
        //print("SONG time: ", player?.currentTime as Any )
        
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
        
        MPlayer.isPlaying = true
        
        player?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player)
       
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


