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
    
    // random angka float
    func randomFloat(min: Float, max: Float) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
    
    // coba nampilin kubus AR
    @IBAction func LearnPathButton(_ sender: UIButton) {
        
        createCube()
        
    }
    @IBAction func StartActionButton(_ sender: UIButton) {
        
        // mengubah image pada tombol start menjadi stop
        if buttonStart.currentBackgroundImage == UIImage(named: "StartButton") {
            
            buttonStart.setBackgroundImage(UIImage(named: "StopButton"), for: .normal)
        }
        else {
            buttonStart.setBackgroundImage(UIImage(named: "StartButton"), for: .normal)
        }
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        
    }
    
    // melakukan konversi dari titik tekan menjadi titik lokasi AR
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        
        let result = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint])
        
        guard let hitResult = result.last else { return }
        
        let hitTransform = SCNMatrix4.init(hitResult.worldTransform)
        
        let hitVector = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        createBall(position: hitVector)
    }
    
    func createBall (position : SCNVector3) {
        
        let ballShape = SCNSphere(radius: 0.05)
        let ballNode = SCNNode(geometry: ballShape)
        ballNode.position = position
        sceneView.scene.rootNode.addChildNode(ballNode)
    }
    
    func createCube () {
        
        let zPos = randomFloat(min: -2, max: -0.2)
        let cubeNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        cubeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
        cubeNode.position = SCNVector3(0, 0, zPos)
        sceneView.scene.rootNode.addChildNode(cubeNode)
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
