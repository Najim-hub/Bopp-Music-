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
import FirebaseStorage

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


class imageText: ObservableObject{
    
    @Published var imageURL = URL(string: "")
    
    static let sharedInstance = imageText()
    
    init(){
        
    }
    
}



class loadInfo: ObservableObject{
    
    //@State var imageURL = URL(string: "")
    @AppStorage("AppVersion") var AppVersion = ""
  
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
                
                    
       loadInfo.sharedInstance.songs.append(Landmark(id: id, name: name, albumName: albumName, artistName: artistName, trackName: trackName, file: file, imageName: imageName))
              }
            }else{
                print(error as Any)
            }
        }
        
        Firestore.firestore().collection("Version").getDocuments{ (snapshot, error) in
            if error == nil{
                for document in snapshot!.documents{
                    
   let CurrentVersion = document.data()["CurrentVersion"] as? String ?? "error"
    
                    self.AppVersion = CurrentVersion
                    
                    print(self.AppVersion)
              }
            }else{
                print(error as Any)
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
    
    // Audio session object
     private let session = AVAudioSession.sharedInstance()

     // Observer
     private var progressObserver: NSKeyValueObservation!

    
    static let sharedInstance = playControl()
    
    func subscribe() {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                try session.setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
                print("cannot activate session")
            }

            progressObserver = session.observe(\.outputVolume) { [self] (session, value) in
                DispatchQueue.main.async {
                    self.soundLevel = session.outputVolume
                }
            }
        }

        func unsubscribe() {
            self.progressObserver.invalidate()
        }

        init() {
            subscribe()
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
