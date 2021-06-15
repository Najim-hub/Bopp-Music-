//
//  HapticFeedBack.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-06-10.
//

import Foundation
import UIKit

class HapticFeedBack{
    
    static let shared = HapticFeedBack()
    
    let softHammer =  UIImpactFeedbackGenerator(style: .light)
    let hardHammer = UIImpactFeedbackGenerator(style: .heavy)
    
    init(){
        softHammer.prepare()
        hardHammer.prepare()
    }
    
    func hit(_ intensity: CGFloat = 1.0)  {
        hardHammer.impactOccurred(intensity: intensity)
    }
    
    func softRoll(_ intensity: CGFloat = 1.0)  {
        softHammer.impactOccurred(intensity: intensity)
    }
    
    
    
    
    
}
