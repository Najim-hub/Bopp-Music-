/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A representation of a single landmark.
*/

import Foundation
import SwiftUI
import CoreLocation

struct Landmark: Hashable, Codable, Identifiable {
    
    var id: Int
    var name: String
    var albumName : String
    var artistName : String
    var trackName : String
    var file : String
    var imageName: String
    
    var image: Image {
        Image(imageName)
    }

}

struct Song : Hashable, Codable{
    
    let id: Int
    let name: String
    let albumName : String
    let artistName : String
    let imageName : String
    let trackName : String
    
  
}


