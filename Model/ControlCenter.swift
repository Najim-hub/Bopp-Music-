//
//  ControlCenter.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-06-20.
//
import Foundation
import UIKit
import AVFoundation
import MediaPlayer
import SwiftUI
import Combine

extension Publishers {
   
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
      
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}
