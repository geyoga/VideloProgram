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
        panStatus = 4
        labelMovementDetection(labelName: "You did Pan")
        moveToNextLesson()
    }
}

extension ARViewController: DollyDelegate {
    
    func dollyHit(_ status: Bool) {
        addToHistoryTechnique(techniqueName: "Dolly")
        dollyCheck =  false
        labelMovementDetection(labelName: "You did Dolly")
        moveToNextLesson()
    }
}

extension ARViewController: TrackingDelegate {
    
    func trackingHit(_ status: Bool) {
        addToHistoryTechnique(techniqueName: "Tracking")
        trackingCheck = false
        labelMovementDetection(labelName: "You did Tracking")
        moveToNextLesson()
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
        tiltStatus = 4
        labelMovementDetection(labelName: "You did Tilt")
        moveToNextLesson()
    }
}

extension ARViewController: ShotDelegate {
    func closeUpShot(_ status: Bool) {
        addToHistoryTechnique(techniqueName: "Shot")
        labelMovementDetection(labelName: "You did Close Up Shot")
        moveToNextLesson()
        shotCheck = false
    }
    
    func mediumShot(_ status: Bool) {
        addToHistoryTechnique(techniqueName: "Shot")
        labelMovementDetection(labelName: "You did Medium Shot")
        moveToNextLesson()
        shotCheck = false
    }
}

extension ARViewController: AngleDelegate {
    func lowAngleHit(_ status: Bool) {
        addToHistoryTechnique(techniqueName: "Angle")
        angle.stopGyros()
        labelMovementDetection(labelName: "You did Low Angle")
        moveToNextLesson()
    }
    
    func highAngleHit(_ status: Bool) {
        addToHistoryTechnique(techniqueName: "Angle")
        angle.stopGyros()
        labelMovementDetection(labelName: "You did High Angle")
        moveToNextLesson()
    }
}

extension ARViewController {
    func addToHistoryTechnique(techniqueName: String) {
        DataController.addHistory(techniqueName: techniqueName)
    }
    
    func labelMovementDetection(labelName: String) {
        DispatchQueue.main.async {
            self.view.makeToast(labelName, duration: 1.5, position: .top)
        }
    }
}

