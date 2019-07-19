//
//  Shot.swift
//  VideoVersionTwo
//
//  Created by Indra Sumawi on 18/07/19.
//  Copyright © 2019 Georgius Yoga Dewantama. All rights reserved.
//

import Foundation
import ARKit

protocol ShotDelegate: class {
    func closeUpShot(_ status: Bool)
    func mediumShot(_ status: Bool)
}

class Shot {
    weak var delegate: ShotDelegate!
    let objectPoint: SCNVector3
    
    init(objectPoint: SCNVector3) {
        self.objectPoint = objectPoint
    }
    
    func positionUpdate(updatePoint: SCNVector3) {
        let distance = abs(GLKVector3Distance(SCNVector3ToGLKVector3(objectPoint), SCNVector3ToGLKVector3(updatePoint)))
        print("DISTANCE \(distance)")
        
        if (distance < 1.2) {
            delegate.closeUpShot(true)
        }
        else if (distance >  2.5 && distance < 3) {
            delegate.mediumShot(true)
        }
    }
}
