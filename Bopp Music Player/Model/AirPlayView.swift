//
//  AirPlayView.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-06-10.
//

import SwiftUI
import AVKit
import MediaPlayer

struct AirPlayView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AirPlayView_Previews: PreviewProvider {
    static var previews: some View {
        AirPlayView()
    }
}

struct AirplayView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        
        let routePickerView = AVRoutePickerView()
        
        routePickerView.backgroundColor = UIColor.clear
        
        routePickerView.activeTintColor = UIColor.init(red: 0.588, green: 0.541, blue: 0.965, alpha: 1)
        
        routePickerView.tintColor = UIColor.black
        

        return routePickerView
        
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    
    
}
