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
