//
//  Plane.swift
//  VideoVersionTwo
//
//  Created by Indra Sumawi on 17/07/19.
//  Copyright © 2019 Georgius Yoga Dewantama. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class Plane: SCNNode {
    var planeAnchor: ARPlaneAnchor
    
    var planeGeometry: SCNPlane
    var planeNode: SCNNode
    
    init(_ anchor: ARPlaneAnchor) {
        
        self.planeAnchor = anchor
        
        let grid = UIImage(named: "plane_grid.png")
        self.planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        let material = SCNMaterial()
        material.diffuse.contents = grid
        self.planeGeometry.materials = [material]
        
        self.planeGeometry.firstMaterial?.transparency = 0.5
        self.planeNode = SCNNode(geometry: planeGeometry)
        self.planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1, 0, 0)
        
        super.init()
        
        self.addChildNode(planeNode)
        
        self.position = SCNVector3(anchor.center.x, -0.002, anchor.center.z) // 2 mm below the origin of plane.
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
