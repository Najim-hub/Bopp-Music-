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
    
    var audio = AudioSetup()
    
    let commandCenter = MPRemoteCommandCenter.shared()
    
    var playerDuration: CMTime = CMTimeMake(value: 0, timescale: 0);
    
    var floatTime : Float = 0.0
    
    var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var nowPlayingInfo = [String : Any]()
    
    //var uri = single.sharedInstance
    
   static let sharedInstance = AudioPlayer()
    
    private func audioPlayerDidFinishPlaying(_ player: AVPlayer, successfully flag: Bool) {
        if flag {
            
          timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
         print("song finished")
            
    floatTime =  0.1
             
   timeNow.currTime = Float(AudioPlayer.sharedInstance.player?.currentTime() as? TimeInterval ?? 0.1)
            
            if playController.position < songList.songs.count - 1   {
                
                playController.position =  playController.position + 1
           
                playSong()
            
                playController.isPlaying = true
          
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
        
        if playController.position <= songList.songs.count - 1 && playController.position >= 0{
            
            
         print(playController.position)
     
            print(playController.position, "Within position")
    
            let storage = Storage.storage().reference(forURL: songList.songs[playController.position].file)
        
        storage.downloadURL(completion: {(url, error) in
            
            if error != nil {
                print(error)
            }
            
            else {
                
                do {
                    
                    _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                    
                    UIApplication.shared.beginReceivingRemoteControlEvents()
                    
                    try AVAudioSession.sharedInstance().setMode(.default)
                    try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)

                
             //single.sharedInstance.urlString = url
                
                print("String", single.sharedInstance.urlString)
                
                //let fileUrl = NSURL(fileURLWithPath:  single.sharedInstance.urlString)
                   
                    
                    try self.player = AVPlayer(url:url!)

                   
                    self.player?.currentItem?.preferredPeakBitRate = 0
                   // self.player?.automaticallyWaitsToMinimizeStalling = false;
                    //print(self.player?.currentItem?.preferredPeakBitRate)
                    
               if #available(iOS 15.0, *)
                    {
            
                 self.player?.currentItem?.preferredPeakBitRateForExpensiveNetworks = 64
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    self.player?.play()
                    
                   // self.player?.currentItem?.preferredPeakBitRate = 640000
                 
                    self.playerDuration = (self.player?.currentItem?.asset.duration)!
                    
                    self.floatTime =   Float(CMTimeGetSeconds(self.playerDuration))
                    
                    self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
                 
                    self.playController.isPlaying = true
                    
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
    
   
    override private init() {
        
        print("init singletion")
    }
    
    
    
    deinit {
           print("deinit singleton")
       }
    
}


