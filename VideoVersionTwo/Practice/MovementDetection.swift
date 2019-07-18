//
//  MovementDetection.swift
//  VideoVersionTwo
//
//  Created by Indra Sumawi on 17/07/19.
//  Copyright © 2019 Georgius Yoga Dewantama. All rights reserved.
//

import Foundation
import UIKit


extension ARViewController: PanDelegate {
    
    func panLeftHit(_ status: Bool) {
        panStatus = 2
    }
    
    func panRightHit(_ status: Bool) {
        panStatus = 3
    }
    
    func panSuccess(_ status: Bool) {
        pan.stopGyros()
        panStatus = 0
        currentLesson = ARViewController.LessonEnum(rawValue: 2)!
        DispatchQueue.main.async {
            self.buttonStart.sendActions(for: .touchUpInside)
        }
        panStatus = 4
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Success", message: "You did PAN", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.deleteLabel()
            }))
            self.present(alert, animated: true)
        }
        buildLabel(data: 2)
    }
}

extension ARViewController: DollyDelegate {
    
    func dollyHit(_ status: Bool) {
        DispatchQueue.main.async {
            self.buttonStart.sendActions(for: .touchUpInside)
        }
        currentLesson = ARViewController.LessonEnum(rawValue: 4)!
        dollyCheck =  false
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Success", message: "You did DOLY", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}

extension ARViewController: TrackingDelegate {
    
    func trackingHit(_ status: Bool) {
        trackingCheck = false
        currentLesson = ARViewController.LessonEnum(rawValue: 1)!
        DispatchQueue.main.async {
            self.buttonStart.sendActions(for: .touchUpInside)
        }
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Success", message: "You did TRACKING", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func distanceTooClose(_ status: Bool) {
        print("TOO CLOSEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE")
    }
    
    func distanceTooFar(_ status: Bool) {
        print("TOO FARRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR")
    }
}

extension ARViewController: TiltDelegate {
    
    func tiltUpHit(_ status: Bool) {
        tiltStatus = 2
    }
    
    func tiltDownHit(_ status: Bool) {
        tiltStatus = 3
    }
    
    func tiltuccess(_ status: Bool) {
        tiltStatus = 0
        tilt.stopGyros()
        currentLesson = ARViewController.LessonEnum(rawValue: 3)!
        DispatchQueue.main.async {
            self.buttonStart.sendActions(for: .touchUpInside)
        }
        tiltStatus = 4
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Success", message: "You did TILT", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}

extension ARViewController: ShotDelegate {
    func closeUpShot(_ status: Bool) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Success", message: "You did CLOSE UP SHOT", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        shotCheck = false
    }
    
    func mediumShot(_ status: Bool) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Success", message: "You did MEDIUM SHOT", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        shotCheck = false
    }
}

extension ARViewController: AngleDelegate {
    func lowAngleHit(_ status: Bool) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Success", message: "You did LOW ANGLE", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func highAngleHit(_ status: Bool) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Success", message: "You did HIGH ANGLE", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
