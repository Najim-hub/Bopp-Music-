//
//  ControlCenter.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-06-20.
//

import Foundation
import UIKit
import AVFoundation
import MediaPlayer


class ControlCenter: ObservableObject{
    
     var Avplayer = AudioPlayer.sharedInstance
    
     var songList = loadInfo.sharedInstance
    
     var playController = playControl.sharedInstance
    
     var val = playVal.sharedInstance
    
 
 
}
