//
//  Pan.swift
//  VideoVersionTwo
//
//  Created by Indra Sumawi on 15/07/19.
//  Copyright © 2019 Georgius Yoga Dewantama. All rights reserved.
//

import Foundation
import CoreMotion

protocol TiltDelegate {
    func tiltUpHit(_ status: Bool)
    func tiltDownHit(_ status: Bool)
    func tiltuccess(_ status: Bool)
}

class Tilt {
    var delegate: TiltDelegate?
    
    var motion = CMMotionManager()
    
    var tiltCounter: Int = 0
    //roll
    let tiltUpper: Double = -40
    let tiltLower: Double = -120
    var checkTiltUpHit = false
    var checkTiltDownHit = false
    
    func startGyros() {
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0 / 1.0
            self.motion.startDeviceMotionUpdates(to: .main) { (data, error) in
                if let trueData = data {
                    let roll = trueData.attitude.roll.radiansToDegree()
                    print(roll)
                    
                    //TILT
                    if self.checkTiltUpHit == false && roll <= self.tiltLower {
                        self.checkTiltUpHit = true
                        print("YEY2")
                        self.delegate?.tiltUpHit(true)
                    }
                    
                    if self.checkTiltUpHit && self.checkTiltDownHit == false && roll >= self.tiltUpper {
                        self.checkTiltDownHit = true
                        self.delegate?.tiltDownHit(true)

                    }
                    
                    if self.checkTiltUpHit && self.checkTiltDownHit {
                        print("YEY3")
                        self.checkTiltUpHit = false
                        self.checkTiltDownHit = false
                        self.tiltCounter += 1
                        print("Tilt Counter: \(self.tiltCounter)")
                        self.delegate?.tiltuccess(true)
                    }
                }
            }
        }
    }
    
    func stopGyros() {
        self.motion.stopGyroUpdates()
    }
    
}
