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
import Firebase

class MusicPlayerViewModel: ObservableObject {

    
    @Published var positions: Int = 0
    
    @Published var AudioSong: [Landmark] = []
    
    @Published var soundLevel: Float = AVAudioSession.sharedInstance().outputVolume
   
}

class single: ObservableObject{
    
    var urlString: String = ""
    
    static let sharedInstance = single()
    
    init(){
        
        
    }
}




class loadInfo: ObservableObject{
    
    @Published var songs : [Landmark] = []
    
    static let sharedInstance = loadInfo()
    
    init(){
        Firestore.firestore().collection("Albums").getDocuments{ (snapshot, error) in
            if error == nil{
                for document in snapshot!.documents{
                    
   let id = document.data()["id"] as? Int ?? 0
    let name = document.data()["name"] as? String ?? "error"
    let albumName = document.data()["albumName"] as? String ?? "error"
    let imageName = document.data() ["imageName"] as? String ?? "error"
    let artistName = document.data() ["artistName"] as? String ?? "error"
    let trackName = document.data() ["trackName"] as? String ?? "error"
    let file = document.data()["file"] as? String ?? "error"
                    
    //let data =  document.data()
    
        loadInfo.sharedInstance.songs.append(Landmark(id: id, name: name, albumName: albumName, artistName: artistName, trackName: trackName, file: file, imageName: imageName))
              }
                
          print("Shared instance size")
         print(loadInfo.sharedInstance.songs.count)
                
                    
            }else{
                print(error)
            }
        }
    
    }
    
    
}

class currentTime: ObservableObject{
    @Published var currTime : Float = 0
    
    @Published var value: TimeInterval = 0.1
    
    @Published var playerTime: CMTime = CMTimeMake(value: 0, timescale: 0);
    
    static let sharedInstance = currentTime()
    
    init() {
        
        
        
    }
    
}

class playControl: ObservableObject{
    
    @Published var isMini = false
    
    @Published var isPlaying = false
   
    @Published var playValue: TimeInterval = 0.1
    
    @Published var offset: CGFloat = 0
    
    @Published var width: CGFloat = UIScreen.main.bounds.width / 3
    
    @Published var height : CGFloat = UIScreen.main.bounds.height / 3
    
    @Published var soundLevel: Float = AVAudioSession.sharedInstance().outputVolume
    
    // MiniPlayer Properties...
    @Published var showPlayer: Bool = false
    
    @Published var position: Int = 0
    
    
    
    static let sharedInstance = playControl()
    
    init() {
        
        
        
    }
    
    
}


extension MPVolumeView {
    static func setVolume(_ volume: Float) -> Void {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
         }
        
        
    }
    
       
}
