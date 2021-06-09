//
//  MusicListView.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-06-06.
//

import SwiftUI

struct MusicListView: View {
    
    var landmark: Landmark
    
    var body: some View {
        NavigationView {
            
            List(landmarks, id: \.name) { landmark in
              
                LandmarkRow(landmark: landmark)
                
                
                Spacer()
                Button(action:
                {
                    
                    
                }) {
                    Image(systemName: "play.fill")
                        .foregroundColor(.yellow)
                }
                
            }
            .navigationTitle("Songs")
            
            
            
            //Miniplayer(animation: animation, expand: $expand, isPlaying: false, isPlayingExt: false, SongImage: "", Artist: "", SongName: "")
        }
        
    }
}

struct MusicListView_Previews: PreviewProvider {
    static var previews: some View {
       Home()
    }
}
