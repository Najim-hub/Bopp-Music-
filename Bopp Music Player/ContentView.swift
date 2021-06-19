//
//  ContentView.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-06-06.
//

import SwiftUI


struct ContentView: View {
    
    @EnvironmentObject var player: MusicPlayerViewModel
    
    var data = MusicData()
     
    
    var body: some View {
     //Home()
       TabBar()
        .onAppear(){ perform: do {
            //data.loadSongs()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
