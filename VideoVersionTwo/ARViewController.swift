//
//  ARViewController.swift
//  VideoVersionTwo
//
//  Created by Georgius Yoga Dewantama on 12/07/19.
//  Copyright © 2019 Georgius Yoga Dewantama. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ARViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    
    //var
    var shape: SCNNode!
    //1 start
    //2 left hit
    //3 right hit
    //4 success
    var panStatus: Int = 0
    var tiltStatus: Int = 0
    
    var pan = Pan()
    var tilt = Tilt()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.debugOptions = [.showFeaturePoints]
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    // coba nampilin kubus AR
    @IBAction func LearnPathButton(_ sender: UIButton) {
        
        createCube()
        
    }
    @IBAction func StartActionButton(_ sender: UIButton) {
        pan.delegate = self as! PanDelegate
        
        tilt.delegate = self as! TiltDelegate
        // mengubah image pada tombol start menjadi stop
        if buttonStart.currentBackgroundImage == UIImage(named: "StartButton") {
            
            buttonStart.setBackgroundImage(UIImage(named: "StopButton"), for: .normal)
            pan.startGyros()
            
            panStatus = 1
        }
        else {
            buttonStart.setBackgroundImage(UIImage(named: "StartButton"), for: .normal)
            pan.stopGyros()
            tilt.stopGyros()
            print("STOP")
            
            panStatus = 0
            tiltStatus = 0
            shape.position = sceneView.scene.rootNode.position
            shape.position.z -=  1
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        //for pan, move object periodically
        let speed: Float = 0.005
        let rotationValue: Float = 0.1
        if panStatus == 1 {
            self.shape.position.x -= speed
            self.shape.eulerAngles.y += rotationValue
        }
        else if panStatus == 2 {
            self.shape.position.x += speed
            self.shape.eulerAngles.y -= rotationValue
        }
        
        if tiltStatus == 1 {
            self.shape.position.y += speed
            self.shape.eulerAngles.x += rotationValue
        }
        else if tiltStatus == 2 {
            self.shape.position.y -= speed
            self.shape.eulerAngles.x -= rotationValue
        }
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        
    }
    
    func createBall (position : SCNVector3) {
        
        let ballShape = SCNSphere(radius: 0.05)
        let ballNode = SCNNode(geometry: ballShape)
        ballNode.position = position
        sceneView.scene.rootNode.addChildNode(ballNode)
    }
    
    func createCube () {
        
        var cube = SCNScene(named: "art.scnassets/tong.scn")! //SCNBox(width: 0.3, height: 0.3, length: 0.3, chamferRadius: 0.1)
        shape = cube.rootNode//SCNNode(geometry: cube)
        shape.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
        shape.position = sceneView.scene.rootNode.position
        shape.position.z -=  1
        sceneView.scene.rootNode.addChildNode(shape)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

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
        }))
        
        self.present(alert, animated: true)
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
    }
    
    
}
