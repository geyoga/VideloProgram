//
//  Angle.swift
//  VideoVersionTwo
//
//  Created by Indra Sumawi on 18/07/19.
//  Copyright © 2019 Georgius Yoga Dewantama. All rights reserved.
//

import Foundation
import CoreMotion

protocol AngleDelegate: class {
    func lowAngleHit(_ status: Bool)
    func highAngleHit(_ status: Bool)
}

class Angle {
    weak var delegate: AngleDelegate?
    
    var motion: CMMotionManager!
    
    //roll
    let tiltUpper: Double = -60
    let tiltLower: Double = -110
    
    init() {
        self.motion  = CMMotionManager()
    }
    
    func startGyros() {
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0 / 1.0
            self.motion.startDeviceMotionUpdates(to: .main) { (data, error) in
                if let trueData = data {
                    let roll = trueData.attitude.roll.radiansToDegree()
                    print(roll)
                    
                    //TILT
                    if roll <= self.tiltLower {
                        print("YEY2")
                        self.delegate?.lowAngleHit(true)
                    }
                    
                    if roll >= self.tiltUpper {
                        self.delegate?.highAngleHit(true)
                        
                    }
                }
            }
        }
    }
    
    func stopGyros() {
        self.motion.stopDeviceMotionUpdates()
    }
}
