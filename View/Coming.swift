//
//  Coming.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-06-18.
//

import SwiftUI
import AVKit
import Foundation
import UIKit
import AVFoundation

struct PlayerView: UIViewRepresentable {
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
    }

    func makeUIView(context: Context) -> UIView {
        return LoopingPlayerUIView(frame: .zero)
    }
}

class LoopingPlayerUIView: UIView {
private let playerLayer = AVPlayerLayer()
private var playerLooper: AVPlayerLooper?

required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

override init(frame: CGRect) {
    super.init(frame: frame)

    // Load the resource
    let fileUrl = Bundle.main.url(forResource: "Coming", withExtension: "mp4")!
    let asset = AVAsset(url: fileUrl)
    let item = AVPlayerItem(asset: asset)
    
    // Setup the player
    let player = AVQueuePlayer()
    playerLayer.player = player
    playerLayer.videoGravity = .resizeAspectFill
    player.isMuted = true
    layer.addSublayer(playerLayer)
     
    // Create a new player looper with the queue player and template item
    playerLooper = AVPlayerLooper(player: player, templateItem: item)
  
    // Start the movie
    player.play()
}

    override func layoutSubviews() {
        super.layoutSubviews()
    playerLayer.frame = bounds
}
}

struct Coming: View {
    
   
    var body: some View {
        PlayerView()
    
    }
}

struct Coming_Previews: PreviewProvider {
    static var previews: some View {
        Coming()
    }
}
