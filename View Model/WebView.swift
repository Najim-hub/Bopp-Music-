//
//  WebView.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-08-07.
//

import Foundation
import SwiftUI
import WebKit

import Foundation
import Combine
class ViewModel: ObservableObject {
    var webViewNavigationPublisher = PassthroughSubject<WebViewNavigation, Never>()
    var showLoader = PassthroughSubject<Bool, Never>()
    var valuePublisher = PassthroughSubject<String, Never>()
}

enum WebViewNavigation {
    case backward, forward
}

enum WebUrl {
    case localUrl, publicUrl
}
