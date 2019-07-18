//
//  Tracking.swift
//  VideoVersionTwo
//
//  Created by Indra Sumawi on 17/07/19.
//  Copyright © 2019 Georgius Yoga Dewantama. All rights reserved.
//

import Foundation
import ARKit

protocol TrackingDelegate {
    func trackingHit(_ status: Bool)
    func distanceTooClose(_ status: Bool)
    func distanceTooFar(_ status: Bool)
}

class Tracking {
    var delegate: TrackingDelegate!
    
    let startPoint: SCNVector3
    let objectPoint: SCNVector3
    let distanceRange: Float

    init(startPoint: SCNVector3, objectPoint: SCNVector3) {
        self.startPoint = startPoint
        self.objectPoint = objectPoint
        
        //need to keep this distance
        distanceRange = abs(GLKVector3Distance(SCNVector3ToGLKVector3(startPoint), SCNVector3ToGLKVector3(objectPoint)))
        
        print("DISTANCE RANGE \(distanceRange)")
    }
    
    func positionUpdate(updatePoint: SCNVector3) {
        let distanceFromObject = abs(GLKVector3Distance(SCNVector3ToGLKVector3(objectPoint), SCNVector3ToGLKVector3(updatePoint)))
        
        let distanceFromStartPoint = abs(GLKVector3Distance(SCNVector3ToGLKVector3(startPoint), SCNVector3ToGLKVector3(updatePoint)))
        print("DISTANCE \(distanceFromObject) - \(distanceFromStartPoint)")
        
        //too close
        if (distanceFromObject <  distanceRange - 0.2) {
            delegate.distanceTooClose(true)
        }
        else if (distanceFromObject >  distanceRange + 0.2) {
            delegate.distanceTooFar(true)
        }
        
        if distanceFromObject > 1 {
            delegate.trackingHit(true)
        }
    }
}
