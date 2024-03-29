/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A single row to be displayed in a list of landmarks.
*/

import SwiftUI
import SDWebImageSwiftUI
struct LandmarkRow: View {
    var landmark: Landmark
    

    var body: some View {
        HStack {
            
            landmark.image
                .resizable()
                .frame(width: 85, height: 85)
                .cornerRadius(5)
            
            VStack(alignment: .leading, spacing: 3)
          {
            Text(landmark.name)
                .font(.headline)
                
            Text(landmark.artistName)
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
        }
    }
}

struct LandmarkRow_Previews: PreviewProvider {
    

    static var previews: some View {
        Group {
            LandmarkRow(landmark: loadInfo.sharedInstance.songs[0])
            LandmarkRow(landmark: loadInfo.sharedInstance.songs[1])
            
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
