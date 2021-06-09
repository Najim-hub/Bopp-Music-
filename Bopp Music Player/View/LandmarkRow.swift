/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A single row to be displayed in a list of landmarks.
*/

import SwiftUI

struct LandmarkRow: View {
    var landmark: Landmark

    var body: some View {
        HStack {
            landmark.image
                .resizable()
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 3)
          {
            Text(landmark.name)
                .font(.headline)
                
            Text(landmark.artistName)
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

struct LandmarkRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LandmarkRow(landmark: landmarks[3])
            LandmarkRow(landmark: landmarks[4])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
