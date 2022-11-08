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
import SDWebImageSwiftUI
import AVKit
import Cache
import SystemConfiguration
import web3swift

class ToggleShuffle: ObservableObject{
    
    
    var toggleShuffle: Bool = false
    
    
    static let sharedInstance = ToggleShuffle()
    
    
    init(){}
   
    
}


class AudioPlayer:  NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    var timeNow = currentTime.sharedInstance
    
    let url = Bundle.main.url(forResource: "Coming", withExtension: "mp4")
    
    var player: AVPlayer? = AVPlayer()
    
    let diskConfig = DiskConfig(name: "DiskCache")
    
    let memoryConfig = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)

    var playController = playControl.sharedInstance
    
    var songList = loadInfo.sharedInstance
    
    var MPlayer = MusicPlayerViewModel()
    
    var played: Bool = false
    
    var audio = AudioSetup()
    
    var playerDuration: CMTime = CMTimeMake(value: 0, timescale: 0);
    
    var floatTime : Float = 0.0
    
    var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var val = playVal.sharedInstance
    
    var isShuffled = ToggleShuffle.sharedInstance
    
    let commandCenter = MPRemoteCommandCenter.shared()
    
    @Published var nowPlayingInfo = [String : Any]()
    
     static let sharedInstance = AudioPlayer()
    
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.apple.com")
    
    
     func contract(_ abiString: String, at: EthereumAddress? = nil, abiVersion: Int = 2) -> String? {
        return "web3contract(web3: self, abiString: abiString, at: at, transactionOptions: self.transactionOptions, abiVersion: abiVersion)"
    }
    
   
     func setupCommandCenter() {
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = songList.songs[playController.position].name

        nowPlayingInfo[MPMediaItemPropertyArtist] = songList.songs[playController.position].artistName
    
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = val.playValue
        
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = AudioPlayer.sharedInstance.floatTime - 1
        
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player!.rate
         
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo

        let commandCenter = MPRemoteCommandCenter.shared()
         
        commandCenter.stopCommand.isEnabled = true
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.isEnabled = true
        
        commandCenter.playCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            
        self?.player?.play()
          
            MPNowPlayingInfoCenter.default().nowPlayingInfo =  self?.nowPlayingInfo
            
            
            self?.nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self?.val.playValue
            
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            
            self?.nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0
            
            self?.player?.pause()
           
            self?.nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self?.val.playValue
            
            MPNowPlayingInfoCenter.default().nowPlayingInfo =  self?.nowPlayingInfo

            return .success
        }

    }
    
    func audioRouteChanged(note: Notification) {
      if let userInfo = note.userInfo {
        
        if let reason = userInfo[AVAudioSessionRouteChangeReasonKey] as? Int {
            
            if reason == AVAudioSession.RouteChangeReason.oldDeviceUnavailable.rawValue {
     
            player?.pause()
                
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = val.playValue
                
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
          }
        }
      }
    }
    
    func setupRemoteTransportControls() {
        
        
        // Get the shared MPRemoteCommandCenter
        commandCenter.nextTrackCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
           
                self?.player?.rate = 0
            
           // self?.player?.automaticallyWaitsToMinimizeStalling = true
            
            if (self?.playController.position)! < (self?.songList.songs.count)! - 1  {
                
   
                
                self?.playController.position+=1
                
                print("FIRST!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", self?.playController.position as Any)
            
                self?.val.playValue = 0.0
                
                self?.playController.isPlaying = true
                
                 self?.playSong()
             
          
            }
            
            else{
                
                print(self?.playController.position ?? 1)
                
                self?.val.playValue = 0.0
             
            }
            
                return .success
            }
        
        
        
        commandCenter.previousTrackCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
           
            self?.player?.automaticallyWaitsToMinimizeStalling = true
            
            self?.player?.rate = 0
            
            if (self?.playController.position)! <= (self?.songList.songs.count)! - 1 && self?.playController.position != 0  {
                
                self?.val.playValue = 0.0
                
                self?.playController.position-=1
                
                self?.playSong()
            
              
                
                self?.playController.isPlaying = true
          
            }
            
            else{
                
                self?.val.playValue = 0.0
                
                self?.playController.position = 0
                
                //self?.playSong()
            }
            
                return .success
            }
        
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { [unowned self] event in
           
            if self.player!.rate == 0 {
                self.player!.play()
                return .success
            }
            return .commandFailed
        }

        commandCenter.pauseCommand.addTarget { [unowned self] event in
          
            if self.player!.rate > 0  {
                self.player!.pause()
                return .success
            }
            return .commandFailed
        }
    }

    
    func playSong(){
        
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(self.reachability!, &flags)
        
        if self.isNetworkReachable(with: flags){
        
        
        if playController.position <= songList.songs.count - 1 && playController.position >= 0{
            
            let storage = Storage.storage().reference(forURL: songList.songs[playController.position].file)
        
            storage.downloadURL(completion: { [self](url, error) in
            
            if error != nil {
                print(error as Any)
            }
            
            else {
                
                do {
                    
            _ = try
                    AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                    
                    UIApplication.shared.beginReceivingRemoteControlEvents()
                    
                    try AVAudioSession.sharedInstance().setMode(.default)
                    try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                   
                  
                    let imageData = try Data(contentsOf: (URL(string: songList.songs[playController.position].imageName) ?? URL(string:"https://firebasestorage.googleapis.com/v0/b/bopp-15e3c.appspot.com/o/StockAlbumArtwork%2FUntitled%20design.jpg?alt=media&token=65a7e44f-0b97-466b-8b51-20a254f95489"))!)
                    
                      if let image = UIImage(data: imageData) {
                       nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
                           return image
                       }
                   }
                   
                    
                    let asset = try AVAsset(url: url!)
                    
                    let keys: [String] = ["playable"]
                    
                    asset.loadValuesAsynchronously(forKeys: keys, completionHandler: {
                        
                        
                        var error: NSError? = nil
                            let status = asset.statusOfValue(forKey: "playable", error: &error)
                            switch status {
                               case .loaded:
                                    DispatchQueue.main.async {
                                      let item = AVPlayerItem(asset: asset)
                                        
                                      self.player? = AVPlayer(playerItem: item)
                                        
                                        self.player?.automaticallyWaitsToMinimizeStalling = true;
                                        
                                        self.player?.playImmediately(atRate: 1.0)
                                        
                                     
                                       
                                        NotificationCenter.default.addObserver(self,
                                                                                   selector: #selector(animationDidFinish(_:)),
                                                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                                                   object: player?.currentItem)
                                    
                                        self.playerDuration = (self.player?.currentItem?.asset.duration)!
                                        
                                        self.floatTime =   Float(CMTimeGetSeconds(self.playerDuration))
                                        
                                        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
                                     
                                        self.playController.isPlaying = true
                                        
                                        
                                        debugPrint("AVAudioSession is Active and Category Playback is set")
                                         UIApplication.shared.beginReceivingRemoteControlEvents()
                                        
                                           //setupCommandCenter()
                                        // self.player?.play()
                                                 }
                                break
                            case .failed:
                                 DispatchQueue.main.async {
                                     //do something, show alert, put a placeholder image etc.
                                     
                                     print("Oh no failed to load asset")
                                }
                                break
                             case .cancelled:
                                DispatchQueue.main.async {
                                    //do something, show alert, put a placeholder image etc.
                                }
                                break
                             default:
                                break
                       }
                    })
                
                 
             }
             catch let errors {
                 print(errors)
             
             }
                 
                
            }
            
            
            
        })
        
        
        
        
       
   }
        }
        else{
            
            
            print("Not Connected to the Internet")
            
     
            
        }
        
    }
    
    private func isNetworkReachable(with flags : SCNetworkReachabilityFlags) -> Bool{
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        
        let canConnectWithoutInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        
        return isReachable && (!needsConnection || canConnectWithoutInteraction)
        
      
    }
    
    @objc func animationDidFinish(_ notification: NSNotification) {
         print("Song did finish")
        
        val.playValue = 0
        
        if playController.position < songList.songs.count - 1   {
            
            player?.rate = 0
            
            playController.position =  playController.position + 1
        
             playSong()
            
           
            playController.isPlaying = true
      
        }
        
        else{
            playController.position = 0
            
            playSong()
           
        }
        
     }
    
    @objc func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      NotificationCenter.default.addObserver(self, selector: Selector(("volumeDidChanged:")), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
        
        print("Changed")
      return true
    }

    @objc func volumeDidChange(notification: NSNotification) {
        playControl.sharedInstance.soundLevel = notification.userInfo!["AVSystemController_AudioVolumeNotificationParameter"] as! Float
            
        
        print(playControl.sharedInstance.soundLevel)
      
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
        NotificationCenter.default.removeObserver(self)
       }
    
}


