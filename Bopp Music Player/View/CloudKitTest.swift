//
//  CloudKitTest.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-06-16.
//

import SwiftUI
import CloudKit

struct CloudKitTest: View {
    
    private let database = CKContainer(identifier: "iCloud.BoppMusicPlayer").publicCloudDatabase
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CloudKitTest_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitTest()
    }
}
