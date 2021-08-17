/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A representation of a single landmark.
*/

import Foundation
import SwiftUI
import CoreLocation
import SDWebImageSwiftUI

struct Landmark: Hashable, Codable, Identifiable {
    
    var id: Int
    var name: String
    var albumName : String
    var artistName : String
    var trackName : String
    var file : String
    var imageName : String //URL(string: "")
    
    
    var image: WebImage {
        WebImage(url:URL(string:imageName))
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

struct Wallet : Hashable, Codable{
    
    let name: String
    
    let symbol: String
    let amount : String
    let address: String
    
    let rawAmount: String
    
    let decimal: String
  
}

struct Price: Hashable, Codable{
    
    let name: String
    
    let symbols: String
    
    let price: Double
    
}



