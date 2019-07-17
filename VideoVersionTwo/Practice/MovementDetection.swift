//
//  MovementDetection.swift
//  VideoVersionTwo
//
//  Created by Indra Sumawi on 17/07/19.
//  Copyright © 2019 Georgius Yoga Dewantama. All rights reserved.
//

import Foundation


extension ARViewController: PanDelegate {
    func panLeftHit(_ status: Bool) {
        panStatus = 2
    }
    
    func panRightHit(_ status: Bool) {
        panStatus = 3
    }
    
    func panSuccess(_ status: Bool) {
        panStatus = 4
        
        let alert = UIAlertController(title: "Success", message: "You did PAN", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.pan.stopGyros()
            self.tiltStatus = 1
            self.tilt.startGyros()
            self.deleteLabel()
        }))
        
        self.present(alert, animated: true)
        buildLabel(data: 2)
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
        tiltStatus = 4
        let alert = UIAlertController(title: "Success", message: "You did TILT", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
        
        shape.removeFromParentNode()
        
    }
    
    
}
