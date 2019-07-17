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
    
    // membuat data label instruktur tutorial
    var labelAR = UILabel()
    let labelsContent = ["Welcome to Videlo, tap the screen to spawn Object","Press Start and Panning your Phone","Tilt your Phone by follow the Object",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.debugOptions = [.showFeaturePoints]
        sceneView.delegate = self
        
        buildLabel(data: 0)
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
        
        let alert = UIAlertController(title: "Want to go Learning Path ?", message: "Your activity will be not saved", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:{_ in
            self.performSegue(withIdentifier: "goToLearningPath", sender: nil)
        }))
        self.present(alert, animated: true)
        
        //createCube()
        
    }
    @IBAction func StartActionButton(_ sender: UIButton) {
        pan.delegate = self as! PanDelegate
        
        tilt.delegate = self as! TiltDelegate
        // mengubah image pada tombol start menjadi stop
        if buttonStart.currentBackgroundImage == UIImage(named: "StartButton") {
            
            buttonStart.setBackgroundImage(UIImage(named: "StopButton"), for: .normal)
            pan.startGyros()
            
            panStatus = 1
            deleteLabel()
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
    
    // setting label untuk instruksi AR
    func buildLabel (data : Int) {
        
        labelAR.frame = CGRect(x: self.view.frame.width/4, y: 20, width: 400, height: 50)
        labelAR.text = labelsContent[data]
        labelAR.textAlignment = .center
        labelAR.alpha = 0
        labelAR.textColor = UIColor.white
        labelAR.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        labelAR.layer.masksToBounds = true
        labelAR.layer.cornerRadius = 10
        labelAR.font = UIFont.systemFont(ofSize: 13)
        self.view.addSubview(labelAR)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            self.labelAR.alpha = 1
        }, completion: nil)
        
    }
    
    func deleteLabel () {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.labelAR.alpha = 0
        }, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.labelAR.removeFromSuperview()
        }
        
    }
    
    func createBall (position : SCNVector3) {
        
        let ballShape = SCNSphere(radius: 0.05)
        let ballNode = SCNNode(geometry: ballShape)
        ballNode.position = position
        sceneView.scene.rootNode.addChildNode(ballNode)
    }
    
    func createCube () {
        
        let cube = SCNScene(named: "art.scnassets/tong.scn")! //SCNBox(width: 0.3, height: 0.3, length: 0.3, chamferRadius: 0.1)
        shape = cube.rootNode//SCNNode(geometry: cube)
        shape.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
        shape.position = sceneView.scene.rootNode.position
        shape.position.z -=  1
        sceneView.scene.rootNode.addChildNode(shape)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        deleteLabel()
        createCube()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.buildLabel(data: 1)
        }
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
