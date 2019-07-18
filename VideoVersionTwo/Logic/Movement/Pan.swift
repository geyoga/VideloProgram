//
//  Pan.swift
//  VideoVersionTwo
//
//  Created by Indra Sumawi on 15/07/19.
//  Copyright © 2019 Georgius Yoga Dewantama. All rights reserved.
//

import Foundation
import CoreMotion

protocol PanDelegate: class {
    func panLeftHit(_ status: Bool)
    func panRightHit(_ status: Bool)
    func panSuccess(_ status: Bool)
}

class Pan {
    weak var delegate: PanDelegate?
    
    var motion = CMMotionManager()
    
    var panCounter: Int = 0
    //yaw
    let panUpper: Double = 35
    let panLower: Double = -35
    var checkPanUpHit = false
    var checkPanDownHit = false
    
    init() {
        DispatchQueue.main.async {
            self.motion  = CMMotionManager()
        }
    }
    
    func startGyros() {
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0 / 1.0
            self.motion.startDeviceMotionUpdates(to: .main) { (data, error) in
                if let trueData = data {
                    let yaw = trueData.attitude.yaw.radiansToDegree()
                    print(yaw)
                    
                    //PAN
                    if self.checkPanUpHit == false && yaw >= self.panUpper {
                        self.checkPanUpHit = true
                        self.delegate?.panLeftHit(true)
                        print("YEY")
                    }
                    
                    if self.checkPanUpHit && self.checkPanDownHit == false && yaw <= self.panLower {
                        self.checkPanDownHit = true
                        self.delegate?.panRightHit(true)
                        print("YEY2")
                    }
                    
                    if self.checkPanUpHit && self.checkPanDownHit {
                        print("YEY3")
                        self.checkPanUpHit = false
                        self.checkPanDownHit = false
                        self.panCounter += 1
                        self.delegate?.panSuccess(true)
                        print("Pan Counter: \(self.panCounter)")
                    }
                }
            }
        }
    }
    
    func stopGyros() {
        self.motion.stopDeviceMotionUpdates()
    }
    
}

extension Double {
    func radiansToDegree() -> Double {
        return (180/M_PI) * self
    }
}
