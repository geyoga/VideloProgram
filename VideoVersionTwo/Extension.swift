//
//  Extension.swift
//  VideoVersionTwo
//
//  Created by Georgius Yoga Dewantama on 19/07/19.
//  Copyright © 2019 Georgius Yoga Dewantama. All rights reserved.
//
import UIKit
import Foundation

class Extension: UIViewController {
    
}

extension UIViewController {
    func doHaptic () {
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred()
    }
}

extension TimeInterval {
    
    func toMs() -> Int {
        return Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
    }
    
    func stringFromTimeInterval() -> String {
        
        let time = NSInteger(self)
        
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
        
    }
}
