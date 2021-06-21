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
import Firebase




class AudioPlayer:  NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    var timeNow = currentTime.sharedInstance
    
    let url = Bundle.main.url(forResource: "Coming", withExtension: "mp4")
    
    var player: AVPlayer? = AVPlayer()
    
    var playController = playControl.sharedInstance
    
    var songList = loadInfo.sharedInstance
    
    var MPlayer = MusicPlayerViewModel()
    
    var played: Bool = false
    
    var audio = AudioSetup()
    
//    let commandCenter = MPRemoteCommandCenter.shared()
    
    var playerDuration: CMTime = CMTimeMake(value: 0, timescale: 0);
    
    var floatTime : Float = 0.0
    
    var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    //var nowPlayingInfo = [String : Any]()
    
    var val = playVal.sharedInstance
    
    
    let commandCenter = MPRemoteCommandCenter.shared()
    
    @Published var nowPlayingInfo = [String : Any]()
    
     static let sharedInstance = AudioPlayer()
    
   
     func setupCommandCenter() {
       
        nowPlayingInfo[MPMediaItemPropertyTitle] = songList.songs[playController.position].name

        if let image = UIImage(named: songList.songs[playController.position].imageName) {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
                return image
            }
        }
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = val.playValue - 1
        print("From setup, ", val.playValue)
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = AudioPlayer.sharedInstance.floatTime - 1
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player!.rate
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo

        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.player?.play()
            self?.nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self?.val.playValue
            return .success
        }
        commandCenter.pauseCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.player?.pause()
            self?.nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self?.val.playValue
            return .success
        }
    }
    
    func audioRouteChanged(note: Notification) {
      if let userInfo = note.userInfo {
        if let reason = userInfo[AVAudioSessionRouteChangeReasonKey] as? Int {
            if reason == AVAudioSession.RouteChangeReason.oldDeviceUnavailable.rawValue {
            // headphones plugged out
            player?.pause()
          }
        }
      }
    }
    
    func setupNowPlaying() {
        // Define Now Playing Info
      
        nowPlayingInfo[MPMediaItemPropertyTitle] = songList.songs[playController.position].name

        if let image = UIImage(named: songList.songs[playController.position].imageName) {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
                return image
            }
        }
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = val.playValue
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = AudioPlayer.sharedInstance.floatTime
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player!.rate

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()

        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            //print("Play command - is playing: \(self.player.isPlaying)")
            if self.player!.rate == 0 {
                self.player!.play()
                return .success
            }
            return .commandFailed
        }

        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
           // print("Pause command - is playing: \(self.player.isPlaying)")
            if self.player!.rate > 0  {
                self.player!.pause()
                return .success
            }
            return .commandFailed
        }
    }

    
    
    
    
    
    func playSong(){
        
        
        if playController.position <= songList.songs.count - 1 && playController.position >= 0{
            
            
         print(playController.position)
     
            print(playController.position, "Within position")
    
            let storage = Storage.storage().reference(forURL: songList.songs[playController.position].file)
        
            storage.downloadURL(completion: { [self](url, error) in
            
            if error != nil {
                print(error)
            }
            
            else {
                
                do {
                    
            _ = try
                    AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                    
                    UIApplication.shared.beginReceivingRemoteControlEvents()
                    
                    try AVAudioSession.sharedInstance().setMode(.default)
                    try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                   

                    print("Url, ", url!)
                
                    self.player = AVPlayer(url:url!)

                    self.player?.currentItem?.preferredPeakBitRate = 0
                   
                    self.player?.play()
                
                    self.playerDuration = (self.player?.currentItem?.asset.duration)!
                    
                    self.floatTime =   Float(CMTimeGetSeconds(self.playerDuration))
                    
                    self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
                 
                    self.playController.isPlaying = true
                    
                    NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)

                    
                    debugPrint("AVAudioSession is Active and Category Playback is set")
                            UIApplication.shared.beginReceivingRemoteControlEvents()
                    
                            setupCommandCenter()
                    
    NotificationCenter.default.addObserver(forName: .AVPlayerItemNewAccessLogEntry,
                                                           object:  self.player?.currentItem,
                                                                 queue: nil) { [weak self] notification in
            if let event = self?.player?.currentItem!.accessLog()?.events.last {
                              
        let bitsTransferred = Double(event.numberOfBytesTransferred * 8)
        let bitrate =  bitsTransferred / Double(event.segmentsDownloadedDuration)
                              
        print("Calculated Bit Rate: \(bitrate)")
                              
                              // This gives the same value as Anurag's answer
        print("Average Bit Rate: \(event.averageAudioBitrate)")
                            }
                    }
                 
             }
             catch let errors {
                 print(errors)
             
             }
                 
                
            }
            
            
            
        })
        
        
        
        
       
   }
        
    }
    
    
     @objc func playerDidFinishPlaying(note: NSNotification) {
         print("Song Finished")
        
        val.playValue = 0
        
        if playController.position < songList.songs.count - 1   {
            
            player?.rate = 0
            
            playController.position =  playController.position + 1
        
            val.playValue = 0

        
             playSong()
            
            
        
            playController.isPlaying = true
      
        }
        
        else{
            playController.position = playController.position
        }
     }
     
   
   
    override private init() {
        
        print("init singletion")
    }
    
    
    
    deinit {
           print("deinit singleton")
       }
    
}


