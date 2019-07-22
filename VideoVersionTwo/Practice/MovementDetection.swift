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
        addToHistoryTechnique(techniqueName: "Pan")
        pan.stopGyros()
        panStatus = 0
        moveToNextLesson()
        panStatus = 4
        
        if choosenLesson.name == "Tutorial" {
            self.view.makeToast(labelsTutorial[2], duration: 3.0, position: .top) { didTap in
                if didTap {}
                else {
                    self.view.makeToast(self.labelsTutorial[3], duration: 3.0, position: .top)
                }
            }
        }
        else if choosenLesson.name == "Circle the Object" {
            
        }
        else {
            labelMovementDetection(labelName: "You did Pan")
        }
    }
}

extension ARViewController: DollyDelegate {
    
    func dollyHit(_ status: Bool) {
        addToHistoryTechnique(techniqueName: "Dolly")
        moveToNextLesson()
        dollyCheck =  false
        if choosenLesson.name == "Tutorial" {
            self.view.makeToast(labelsTutorial[4], duration: 3.0, position: .top) {
                didTap in
                if didTap {}
                else {
                    self.view.makeToast(self.labelsTutorial[5], duration: 3.0, position: .top)
                }
            }
        }
        else if choosenLesson.name == "Circle the Object" {
            
        }
        else {
            labelMovementDetection(labelName: "You did Dolly")
        }
    }
}

extension ARViewController: TrackingDelegate {
    
    func trackingHit(_ status: Bool) {
        addToHistoryTechnique(techniqueName: "Tracking")
        trackingCheck = false
        moveToNextLesson()
        
        if choosenLesson.name == "Circle the Object" {
            self.view.makeToast(labelCourse[1], duration: 3.0, position: .top)
        }
        else {
            labelMovementDetection(labelName: "You did Tracking")
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
        addToHistoryTechnique(techniqueName: "Tilt")
        tiltStatus = 0
        tilt.stopGyros()
        moveToNextLesson()
        
        tiltStatus = 4
        labelMovementDetection(labelName: "You did Tilt")
    }
}

extension ARViewController: ShotDelegate {
    func closeUpShot(_ status: Bool) {
        addToHistoryTechnique(techniqueName: "Shot")
        moveToNextLesson()
        labelMovementDetection(labelName: "You did Close Up Shot")
        shotCheck = false
    }
    
    func mediumShot(_ status: Bool) {
        addToHistoryTechnique(techniqueName: "Shot")
        moveToNextLesson()
        labelMovementDetection(labelName: "You did Medium Shot")
        shotCheck = false
    }
}

extension ARViewController: AngleDelegate {
    func lowAngleHit(_ status: Bool) {
        addToHistoryTechnique(techniqueName: "Angle")
        angle.stopGyros()
        moveToNextLesson()
        labelMovementDetection(labelName: "You did Low Angle")
    }
    
    func highAngleHit(_ status: Bool) {
        addToHistoryTechnique(techniqueName: "Angle")
        angle.stopGyros()
        moveToNextLesson()
            /*let alert = UIAlertController(title: "Success", message: "You did HIGH ANGLE", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)*/
        if choosenLesson.name == "Circle the Object" {
            self.view.makeToast(labelCourse[2], duration: 3.0, position: .top)
        }
        else {
            labelMovementDetection(labelName: "You did High Angle")
        }
    }
}

extension ARViewController {
    func addToHistoryTechnique(techniqueName: String) {
        DataController.addHistory(techniqueName: techniqueName)
    }
    
    func labelMovementDetection(labelName: String) {
        self.view.makeToast(labelName, duration: 3.0, position: .top) { didTap in
            if didTap {}
            else {
                self.view.makeToast(self.labelMovement[self.counterLabelMovement], duration: 3.0, position: .top)
                self.counterLabelMovement += 2
            }
        }
    }
}
