//
//  AUdio.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-06-19.
//

import Foundation
import UIKit
import AVFoundation
import MediaPlayer
import Firebase
import SwiftUI

class playVal: ObservableObject {
    
    @Published var playValue: Float = 0.0
    
    static let sharedInstance = playVal()
    
    init(){
        
    }
     
}

class AudioSetup: ObservableObject {
    
   // let commandCenter = MPRemoteCommandCenter.shared()
    
    var playController = playControl.sharedInstance
    
    var nowPlayingInfo = [String : Any]()
    
    public var position : Int = 0
    
    var val = playVal.sharedInstance
    
  //  @Published public var songs = [Landmark]()
  var songList = loadInfo.sharedInstance
 
    var player = MusicPlayerViewModel()
 
    func volumeChanged(_ notification: NSNotification) {
       if let volume = notification.userInfo!["AVSystemController_AudioVolumeNotificationParameter"] as? Float {
           print("volume: \(volume)")
       }
   }
    
   
    func changeSliderValue() {
        
        if AudioPlayer.sharedInstance.player!.rate > 0 {
            
            AudioPlayer.sharedInstance.player!.seek(to: CMTime(seconds: Double(val.playValue), preferredTimescale: 600))
          
            print(val.playValue)
        }
        
        if AudioPlayer.sharedInstance.player!.rate == 0  {
           
            
            AudioPlayer.sharedInstance.player!.seek(to: CMTime(seconds: Double(val.playValue), preferredTimescale: 600))
            print(val.playValue)
        }
    }


}
