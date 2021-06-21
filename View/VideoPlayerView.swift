//
//  VideoPlayerView.swift
//  Youtube Transition (iOS)
//
//  Created by Balaji on 13/01/21.
//

import SwiftUI
import AVKit
import AVFoundation
import MediaPlayer

// I'm going to use UIKit Video Player since SwiftUI Video Player is not having enough features....
struct VideoPlayerView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        
        let controller = AVPlayerViewController()
        
        //var audioPlayer: AVAudioPlayer?
    
        // Video URL...
        let bundle_url = Bundle.main.path(forResource: "video", ofType: "mp4")
        let video_url = URL(fileURLWithPath: bundle_url!)
        
        // Player...
        let player = AVPlayer(url: video_url)
        
        controller.player = player
        
        // Hiding Controls....
        controller.showsPlaybackControls = false
        controller.player?.play()
 
 /*
        let urlString = Bundle.main.path(forResource: "ATM", ofType: "mp3")
        
        let fileUrl = NSURL(fileURLWithPath: urlString!)
            

        do {
            //Doesn't stop background music
            _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            
            UIApplication.shared.beginReceivingRemoteControlEvents()
            
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)

            //playSound()

            try audioPlayer = AVAudioPlayer(contentsOf:fileUrl as URL)
           
            if audioPlayer?.isPlaying == false {
            
                audioPlayer?.play()
            
             
            }
          
        }
        catch {
            print("error occurred")
            
          
        }*/
        controller.videoGravity = .resizeAspectFill
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
        
    }
}

