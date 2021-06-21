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
    
    @Published var songs : [Landmark] = []
    
    static let sharedInstance = loadInfo()
    
    init(){
        
       // let settings = FirestoreSettings()
        //settings.isPersistenceEnabled = false

        // Any additional options
        // ...

       //let db = Firestore.firestore()
        //db.settings = settings
        
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
                    
    print("ID: OUT", document.data() ["imageName"] as? String ?? "error")
        
                    
                    
    //causes issues with the array, after sometime it's almost like it skips variables
    //I do not know the cause so for now, I would be storing the link directly into
    //the firebase collection
   /* let storageRef = Storage.storage().reference(withPath: "/AlbumArtwork/\(document.data() ["imageName"] as? String ?? "error").jpg")
                    
                    print("Storage ref: ", storageRef)
                    
                     storageRef.downloadURL { (url, error) in
                                     if error != nil {
                                         print((error?.localizedDescription)!)
                                         return
                              }
                         imageText.sharedInstance.imageURL = url!
                                  
                         _ = url?.absoluteString
                         //print("ID: IN", document.data() ["imageName"] as? String ?? "error")
                        
                         
                        // print("Url: ", imageText.sharedInstance.imageURL)
                   
                         
                        }*/
                    
                   // let pathString =
                    
                    loadInfo.sharedInstance.songs.append(Landmark(id: id, name: name, albumName: albumName, artistName: artistName, trackName: trackName, file: file, imageName: imageName))
                         
                   
    
                   
              }
                
          print("Shared instance size")
         print(loadInfo.sharedInstance.songs.count)
                
                    
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
    
    
    
    static let sharedInstance = playControl()
    
    init() {}
    
    
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
