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
import CoreData
import Toast_Swift

class ARViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var indicatorDataOverlay: UIImageView!
    @IBOutlet weak var orangeIndicator: UIImageView!
    @IBOutlet weak var indicatorBar: UIImageView!
    //var
    var shape: SCNNode!
    var plane: SCNNode!
    //1 start
    //2 left hit
    //3 right hit
    //4 success
    var panStatus: Int = 0
    var tiltStatus: Int = 0
    
    var name: String = ""  //object name
    
    enum LessonEnum: Int {
        case Pan = 1
        case Tilt
        case Dolly
        case Tracking
        case Shot
        case Angle
    }

    var listLessons: [LessonEnum] = []
    var lessonCounter = 0
    var choosenLesson: Lessons!
    
    var firstObjectPosition: SCNVector3!
    var firstStartPosition: GLKVector3!
    
    var dollyCheck: Bool = true
    var trackingCheck: Bool = true
    var shotCheck: Bool = true
    var angleCheck: Bool = true
    
    var pan: Pan!
    var tilt: Tilt!
    var dolly: Dolly!
    var tracking: Tracking!
    var  angle: Angle!
    var shot: Shot!
    
    var checkPlaneCreated = false
    var animationViewPlane: AnimationView!
    
    //related to  speed indicator
    var firstTime : TimeInterval!
    var nextTime : TimeInterval!
    var checkTime: Bool = false
    let batchTime = 300 //in ms
    let maxHeight: CGFloat = 225
    //end
    
    var labels = [String : [String]]()
    
    // membuat data label instruktur tutorial
    var counterLabel = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabel()
        
        if choosenLesson.type == "Course" {
            indicatorBar.isHidden = false
            indicatorDataOverlay.isHidden = false
            orangeIndicator.isHidden = false
        }
        
        print(listLessons)
    
        sceneView.debugOptions = [.showFeaturePoints]
        sceneView.delegate = self
        
        ToastManager.shared.isQueueEnabled = true
        
        self.view.makeToast("Welcome to this Lesson", duration: 3.0, position: .top) { didTap in
            if didTap {
                print("completion from tap")
            } else {
                self.view.makeToast("Move your Phone to find flat surface", duration: 3.0, position: .top)
            }
        }
        
        //add techniques
        for tech in Array(choosenLesson!.learn_use!) as! [Techniques] {
            switch tech.name {
            case "Pan":
                listLessons.append(.Pan)
                break
            case "Tilt":
                listLessons.append(.Tilt)
                break
            case "Dolly":
                listLessons.append(.Dolly)
                break
            case "Tracking":
                listLessons.append(.Tracking)
                break
            case "Close Up Shot", "Medium Shot":
                listLessons.append(.Shot)
                break
            case "Low Angle", "High Angle":
                listLessons.append(.Angle)
                break
            default:
                break
            }
        }
        
        animationViewPlane = showLottie(name: "PlaneAnimation", loopMode: .loop)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = [.horizontal]
            var environmentTexture: ARWorldTrackingConfiguration.EnvironmentTexturing  = .automatic
            configuration.environmentTexturing = environmentTexture
            self.sceneView.session.run(configuration)
        }
    }
    
    func showLabel()  {
        if labels["\(self.choosenLesson.name!)"]!.count > counterLabel {
            self.view.makeToast(labels["\(self.choosenLesson.name!)"]![counterLabel], duration: 2.0, position: .top)
        }
    }
    
    func moveToNextLabel() {
        counterLabel += 1
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if (checkPlaneCreated == false) {
            DispatchQueue.main.async {
                if let planeAnchor = anchor as? ARPlaneAnchor {
                    self.plane = Plane(planeAnchor)
                    node.addChildNode(self.plane)
                    
                    //add object
                    var scale: SCNVector3 = SCNVector3(0.003, 0.003, 0.003)
                    print(self.listLessons[self.lessonCounter])
                    
                    self.name = "art.scnassets/\(self.choosenLesson.objectName!)"
                    
                    if self.choosenLesson.name == "Introduction to Angle" {
                        scale  = SCNVector3(0.05,0.05,0.05)
                    }
                    
                    if self.choosenLesson.name == "Introduction to Movement" {
                        if self.listLessons[self.lessonCounter] == .Tilt {
                            self.name = "art.scnassets/climbFixed.scn"
                        }
                    }
                    else if self.choosenLesson.name == "Circle the Object" {
                        scale = SCNVector3(0.006, 0.006, 0.006)
                    }
                    else if self.choosenLesson.name == "Tutorial" {
                        scale = SCNVector3(0.2, 0.2, 0.2)
                    }
                    
                    print(self.name)
                    
                    self.addObject(name: self.name, position: SCNVector3.init(0, 0, 0), scale: scale)
                
                    self.animationViewPlane.stop()
                    self.animationViewPlane.removeFromSuperview()
                    self.checkPlaneCreated = true
                    
                    //show label 1
                    self.showLabel()
                    self.moveToNextLabel()
                }
            }
        }
    }

    func moveToNextLesson() {
        moveToNextLabel()
        showLabel()
        moveToNextLabel()
        DispatchQueue.main.async {
            self.buttonStart.sendActions(for: .touchUpInside)
        }
        if (lessonCounter+1 == listLessons.count) {
            //dismiss(animated: true, completion: nil)
            /*if (choosenLesson.name != "Tutorial") {
                self.view.makeToast("You have finish this lesson, Click on the Left-Top button to take another lesson", duration: 3.0, position: .top)
            }*/
            
            let alert = UIAlertController(title: "Congratulation", message: "You have done this lesson", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Back to home", style: .default, handler: { action in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
        }
        else {
            lessonCounter += 1
            
            if choosenLesson.name != "Introduction to Movement" {
                return
            }
            
            var tempName = ""
            //if movement
            if self.listLessons[self.lessonCounter] == .Tilt {
                tempName = "art.scnassets/floatFix.scn"
            }
            else {
                tempName = "art.scnassets/Walking copy 2.scn"
            }
            
            print(name)
            print(tempName)
            
            if name != tempName {
                name = tempName
                if shape != nil {
                    shape.removeFromParentNode()
                }
                self.addObject(name: name, position: SCNVector3.init(0, 0, 0), scale: SCNVector3(0.003, 0.003, 0.003))
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    @IBAction func LearnPathButton(_ sender: UIButton) {
        doHaptic()
        let alert = UIAlertController(title: "Want to go Learning Path ?", message: "Your activity will be not saved", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:{_ in                                                  
            self.performSegue(withIdentifier: "goToLearningPath", sender: nil)
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func StartActionButton(_ sender: UIButton) {
        doHaptic()
        print("STOP BUTTON")
        
        if shape == nil {
            print("Shape not detected")
            return
        }
        var labelName = ""
        // mengubah image pada tombol start menjadi stop
        if buttonStart.currentBackgroundImage == UIImage(named: "StartButton") {
            showLabel()
            buttonStart.setBackgroundImage(UIImage(named: "StopButton"), for: .normal)
            
            var animationName: String = ""
            switch listLessons[lessonCounter] {
            case .Pan:
                //labelName = self.labelMovement[1]
                animationName = "PanningMove4"
                pan = Pan.init()
                pan.delegate = self as! PanDelegate
                
                pan.startGyros()
                panStatus = 1
                break
            case .Tilt:
                //labelName = self.labelMovement[3]
                animationName = "Tilt"
                tilt = Tilt.init()
                tilt.delegate = self as! TiltDelegate
                
                tiltStatus = 1
                tilt.startGyros()
                break
            case .Dolly:
                //labelName = self.labelMovement[5]
                animationName = "DOLLY IN"
                dolly = Dolly(startPoint: self.sceneView!.pointOfView!.position)
                dolly.delegate = self as! DollyDelegate
                dollyCheck = true
                break
            case .Tracking:
                //labelName = self.labelMovement[7]
                animationName = "PAN"
                tracking = Tracking(startPoint: sceneView.pointOfView!.position, objectPoint: shape.position, totalDistance: 1.5)
                tracking.delegate = self as! TrackingDelegate
                trackingCheck = true
                break
            case .Shot:
                animationName = "DOLLY IN"
                //cannot use position because it will use parent (which is plane detector 0,0,0). If we use world position, it will be  relative to the real scene
                shot = Shot(objectPoint: shape.worldPosition)
                shot.delegate = self as! ShotDelegate
                shotCheck = true
                break
            case .Angle:
                animationName = "Tilt"
                angle = Angle.init()
                angle.delegate = self as! AngleDelegate
                angle.startGyros()
                break
            }

            showLottie(name: animationName, loopMode: .playOnce)
        }
        else {
            buttonStart.setBackgroundImage(UIImage(named: "StartButton"), for: .normal)
            //relative to plane
            shape.position = SCNVector3(0, 0, 0)
            self.shape.eulerAngles.x = 0
            self.shape.eulerAngles.y = 0
            
            switch listLessons[lessonCounter] {
            case .Pan:
                //if stop before move next lesson
                if pan != nil {
                    pan.stopGyros()
                    panStatus = 0
                }
                break
            case .Tilt:
                //stop after move to next lesson
                if pan != nil {
                    pan.stopGyros()
                    panStatus = 0
                }
                
                if tilt != nil {
                    tiltStatus = 0
                    tilt.stopGyros()
                }
                break
            case .Dolly:
                dollyCheck = false
                break
            case .Tracking:
                trackingCheck = false
                break
            case .Angle:
                if angle != nil {
                    angle.stopGyros()
                }
            case .Shot:
                shotCheck = false
                break
            }
            print("CURRENT: \(listLessons[lessonCounter])")
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        updateIndicator(time: time)
        let speed: Float = 0.005
        let rotationValue: Float = 0.1
        
        switch listLessons[lessonCounter] {
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
            break
        case .Tilt:
            if tiltStatus == 1 {
                self.shape.position.y += speed
            }
            else if tiltStatus == 2 {
                self.shape.position.y -= speed
            }
            break
        case .Dolly:
            if dolly != nil && dollyCheck == true {
                dolly.positionUpdate(updatePoint: sceneView!.pointOfView!.position)
            }
            break
        case .Tracking:
            if tracking != nil && trackingCheck == true {
                tracking.positionUpdate(updatePoint: sceneView!.pointOfView!.position)
            }
            break
        case .Shot:
            if shot != nil && shotCheck == true {
                shot.positionUpdate(updatePoint: sceneView!.pointOfView!.position)
            }
            break
        case .Angle:
            break
        }
    }
    
    func sessionWasInterrupted(_ session: ARSession) {}
    
    func sessionInterruptionEnded(_ session: ARSession) {}
    
    func session(_ session: ARSession, didFailWithError error: Error) {}
}

