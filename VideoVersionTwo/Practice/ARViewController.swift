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
import Lottie

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
    
    enum LessonEnum: Int {
        case Pan = 1
        case Tilt
        case Dolly
        case Tracking
    }
    var currentLesson:  LessonEnum = .Pan
    
    var firstObjectPosition: SCNVector3!
    
    var dollyCheck: Bool = true
    var trackingCheck: Bool = true
    
    var pan: Pan!
    var tilt: Tilt!
    var dolly: Dolly!
    var tracking: Tracking!
    
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
        
        DispatchQueue.main.async {
            let configuration = ARWorldTrackingConfiguration()
            //configuration.planeDetection = [.horizontal]
            self.sceneView.session.run(configuration)
        }
    }
    
    /*func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                let plane = Plane(planeAnchor)
                node.addChildNode(plane)
            }
        }
    }*/

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    @IBAction func LearnPathButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Want to go Learning Path ?", message: "Your activity will be not saved", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:{_ in
            self.performSegue(withIdentifier: "goToLearningPath", sender: nil)
        }))
        self.present(alert, animated: true)
    }
    @IBAction func StartActionButton(_ sender: UIButton) {
        
        print("STOP BUTTON")
        
        // mengubah image pada tombol start menjadi stop
        if buttonStart.currentBackgroundImage == UIImage(named: "StartButton") {
            
            buttonStart.setBackgroundImage(UIImage(named: "StopButton"), for: .normal)
            deleteLabel()
            
            var animationName: String = ""
            switch currentLesson {
            case .Pan:
                animationName = "PAN"
                pan = Pan.init()
                pan.delegate = self as! PanDelegate
                
                pan.startGyros()
                panStatus = 1
            case .Tilt:
                animationName = "Tilt"
                tilt = Tilt.init()
                tilt.delegate = self as! TiltDelegate
                
                tiltStatus = 1
                tilt.startGyros()
            case .Dolly:
                animationName = "DOLLY IN"
                dolly = Dolly(startPoint: self.sceneView!.pointOfView!.position)
                dolly.delegate = self as! DollyDelegate
                dollyCheck = true
            case .Tracking:
                animationName = "PAN"
                tracking = Tracking(startPoint: sceneView.pointOfView!.position, objectPoint: shape.position)
                tracking.delegate = self as!  TrackingDelegate
                trackingCheck = true
            }
            
            let animationView = AnimationView(name: animationName)
            if animationView != nil {
                let imageProvider = BundleImageProvider(bundle: .main, searchPath: "images")
                animationView.imageProvider = imageProvider
                animationView.frame = CGRect(x: 100, y: 100, width: 400, height: 400)
                animationView.center = CGPoint.init(x: 200.0, y: 100.0)
                animationView.contentMode = .scaleAspectFill
                animationView.loopMode = .playOnce
                view.addSubview(animationView)
                
                animationView.play()
            }
        }
        else {
            buttonStart.setBackgroundImage(UIImage(named: "StartButton"), for: .normal)
            shape.position = firstObjectPosition
            self.shape.eulerAngles.x = 0
            self.shape.eulerAngles.y = 0
            
            if currentLesson == .Pan {
                
            }
            else if currentLesson == .Tilt {
                pan.stopGyros()
                panStatus = 0
            }
            else if currentLesson == .Dolly {
                tiltStatus = 0
                tilt.stopGyros()
            }
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let speed: Float = 0.005
        let rotationValue: Float = 0.1
        
        switch currentLesson {
        case .Pan:
            //for pan, move object periodically
            if panStatus == 1 {
                self.shape.position.x -= speed
                self.shape.eulerAngles.y += rotationValue
            }
            else if panStatus == 2 {
                self.shape.position.x += speed
                self.shape.eulerAngles.y -= rotationValue
            }
        case .Tilt:
            if tiltStatus == 1 {
                self.shape.position.y += speed
                self.shape.eulerAngles.x += rotationValue
            }
            else if tiltStatus == 2 {
                self.shape.position.y -= speed
                self.shape.eulerAngles.x -= rotationValue
            }
        case .Dolly:
            if dolly != nil && dollyCheck == true {
                dolly.positionUpdate(updatePoint: sceneView!.pointOfView!.position)
            }
        case .Tracking:
            if tracking != nil && trackingCheck == true {
                tracking.positionUpdate(updatePoint: sceneView!.pointOfView!.position)
            }
        }
    }
    
    func sessionWasInterrupted(_ session: ARSession) {}
    
    func sessionInterruptionEnded(_ session: ARSession) {}
    
    func session(_ session: ARSession, didFailWithError error: Error) {}
    
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
    
    func addHuman(position: SCNVector3) {
        let cube = SCNScene(named: "art.scnassets/Walking copy.scn")!
        shape = cube.rootNode
        shape.position = position
        shape.scale = SCNVector3(0.001, 0.001, 0.001)
        sceneView.scene.rootNode.addChildNode(shape)
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
        //createCube()
        
        guard let touch = touches.first else {return}
        let result = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint ])
        
        guard let hitResult = result.last else {return}
        //return scene matrix
        let hitTransform = SCNMatrix4.init(hitResult.worldTransform)
        //matrix m41, 42, 43 is about position (x,y,z)
        let hitVector = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        addHuman(position: hitVector)
        firstObjectPosition = hitVector
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.buildLabel(data: 1)
        }
    }
}
