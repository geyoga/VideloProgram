//
//  Dolly.swift
//  VideoVersionTwo
//
//  Created by Indra Sumawi on 17/07/19.
//  Copyright © 2019 Georgius Yoga Dewantama. All rights reserved.
//

import Foundation
import ARKit

protocol DollyDelegate: class {
    func dollyHit(_ status: Bool)
}

class Dolly {
    weak var delegate: DollyDelegate!
    
    let startPoint: SCNVector3
    init(startPoint: SCNVector3) {
        self.startPoint = startPoint
    }
    
    func positionUpdate(updatePoint: SCNVector3) {
        let distance = abs(GLKVector3Distance(SCNVector3ToGLKVector3(startPoint), SCNVector3ToGLKVector3(updatePoint)))
        print("DISTANCE \(distance)")
        
        if (distance > 0.5) {
            delegate.dollyHit(true)
        }
    }
}
