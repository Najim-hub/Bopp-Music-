//
//  MusicData.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-06-16.
//

import Foundation
import Firebase


class MusicData: ObservableObject{
   
    func loadSongs(){

        Firestore.firestore().collection("Albums").getDocuments{ (snapshot, error) in
            if error == nil{
                for document in snapshot!.documents{
                    
   let id = document.data()["id"] as? Int ?? 0
    let name = document.data()["name"] as? String ?? "error"
    let albumName = document.data()["albumName"] as? String ?? "error"
    let imageName = document.data() ["imageName"] as? String ?? "error"
    let artistName = document.data() ["artistName"] as? String ?? "error"
    let trackName = document.data() ["trackName"] as? String ?? "error"
                    
}
                
          print("Shared instance size")
         print(loadInfo.sharedInstance.songs.count)
                
                    
            }else{
                print(error as Any)
            }
        }
    }
    
    
    
}
