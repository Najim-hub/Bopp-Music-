//
//  MusicPlayerViewModel.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-06-06.
//

import Foundation
import SwiftUI
import AVFoundation
import MediaPlayer

class MusicPlayerViewModel: ObservableObject {

    // MiniPlayer Properties...
    @Published var showPlayer = false
    
    // Gesture Offset..
    @Published var offset: CGFloat = 0
    @Published var width: CGFloat = UIScreen.main.bounds.width / 3
    @Published var height : CGFloat = UIScreen.main.bounds.height / 3
    
    @Published var isMiniPlayer = false
    
    @Published var positions: Int = 0
    
    @Published var AudioSong: [Landmark] = []
    
    @Published var isPlaying = false

     
}

class Position {
    
    @Published var position: Int = 0
    
    static let sharedInstance = Position()
    
    init() {
        
        
        
    }
    
}
