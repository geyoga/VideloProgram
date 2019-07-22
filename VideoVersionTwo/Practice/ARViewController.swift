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
    
    // membuat data label instruktur tutorial
    var labelAR = UILabel()
    let labelsTutorial = ["Great ! now there will be a Barrel in front of you",
                          "Stay there and direct your phone corresponding to the Barrel",
                          "Nice ! this is one of the interaction during this lesson",
                          "Move your phone close to The Barrel",
                          "Great ! you can also move forward and backward",
                          "You have finished this Tutorial, Click on the Left-Top button to start you Journey"]
    
    let labelMovement = [
        "First, you will learn Panning. Press Start button to Begin",
        "Stay there, move left and right corresponding with the Object",
        "Next, you will learn Tilting. Press Start button to Begin",
        "Stay there, move up and down corresponding with the Object",
        "Now, you will laern Dolly. Press Start button to Begin",
        "Move close up to the Object",
        "Finally, you will learn Tracking. Press Start button to Begin",
        "Move around the Object, by keeeping your distance",
        "Press Left-Top Button to back to your journey]"]
    var counterLabelMovement = 2
    
    let labelCourse = [
        "First, Move around the Plant by keeeping your distance",
        "Second, Move your Phone to the Top and look down to the Plant",
        "Third, Move close up to the Plant"
    ]
    var counterLabelCourse = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if choosenLesson.name == "Circle the Object" {
            indicatorBar.isHidden = false
            indicatorDataOverlay.isHidden = false
            orangeIndicator.isHidden = false
        }
        
        print(listLessons)
    
        sceneView.debugOptions = [.showFeaturePoints]
        sceneView.delegate = self
        
        /*DispatchQueue.global().asyncAfter(deadline: .now()) {
            self.buildLabel(data: self.labelsContent[0])
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            self.buildLabel(data: self.labelsContent[1], deleteLabel: false)
        }*/
        
        /*self.view.makeToast(self.labelsContent[0], duration: 3.0, position: .top)
        self.view.makeToast(self.labelsContent[1], duration: 3.0, position: .top)*/
        
        self.view.makeToast("Welcome to this Lesson", duration: 3.0, position: .top) { didTap in
            if didTap {
                print("completion from tap")
            } else {
                self.view.makeToast("Move your Phone to find flat surface", duration: 3.0, position: .top)
            }
        }
        
        let technique: [Techniques] = Array(choosenLesson!.learn_use!) as! [Techniques]
        //add techniques
        for tech in technique {
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
        
        //lottie to notice user to get plane flat surface
        animationViewPlane = AnimationView( name: "PlaneAnimation")
        if animationViewPlane != nil {
            animationViewPlane.frame = CGRect(x: 100, y: 100, width: 400, height: 400)
            animationViewPlane.center = CGPoint.init(x: 450.0, y: 200)
            animationViewPlane.contentMode = .scaleAspectFill
            animationViewPlane.loopMode = .loop
            view.addSubview(animationViewPlane)
            
            animationViewPlane.play()
        }
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
                    
                    self.deleteLabel()
                    self.animationViewPlane.stop()
                    self.animationViewPlane.removeFromSuperview()
                    self.checkPlaneCreated = true
                    
                    //show label 1
                    if self.choosenLesson.name == "Tutorial" {
                        self.view.makeToast(self.labelsTutorial[0], duration: 3.0, position: .top) { didTap in
                            if didTap {}
                            else {
                                self.view.makeToast(self.labelsTutorial[1], duration: 3.0, position: .top)
                            }
                        }
                    }
                    else if self.choosenLesson.name == "Introduction to Movement" {
                        self.view.makeToast(self.labelMovement[0], duration: 3.0, position: .top)
                    }
                    else if self.choosenLesson.name == "Circle the Object" {
                        self.view.makeToast(self.labelCourse[0], duration: 3.0, position: .top)
                    }
                }
            }
        }
    }
    
    func updateIndicator(time: TimeInterval) {
        //check if its time to move next batch (batchTime)
        if checkTime == false {
            //store time when first batch
            firstTime = time
            //store first position when first batch
            firstStartPosition = SCNVector3ToGLKVector3(sceneView!.pointOfView!.position)
            //prevent to update "first variable" until batchTime
            checkTime = true
        }
        
        //keep update time when still before batchTime
        nextTime = time
        
        //calculate difference in time
        let diffMs = abs(nextTime.toMs() - firstTime.toMs())
        
        if diffMs > batchTime {
            //update new position when reach batchTime
            let positionTwo = SCNVector3ToGLKVector3(sceneView!.pointOfView!.position)
            //when batchTime reach, calculate current distance between first point and last point
            let distance = abs(GLKVector3Distance(firstStartPosition, positionTwo))
            
            //calculate speed in cm/s
            let speed  = distance*100/(Float(self.batchTime)/1000)
            
            /*
             range
             <10 cm/s  = super slow
             10-20 cm/s  = slow
             20-30 cm/s = good
             30-40 cm/s = fast
             > 40cm/s = super fast
             */
            
            var height: CGFloat = 0.0
          
            if speed < 50 {
                height = maxHeight * CGFloat(speed/50.0)
            }
            else {
                height = maxHeight
            }
            //print(height)
            
            DispatchQueue.main.async {
                //self.speed.text  =  "\(speed) cm/s"
                //print("\(speed) cm/s")
                UIView.animate(withDuration: TimeInterval(Float(self.batchTime)/1000.0), delay: 0, options: .curveEaseInOut, animations: {
                    //self.inidicatorData.
                    self.indicatorDataOverlay.frame.size.height = self.maxHeight - height
                }, completion: nil)
            }
            
            //move next batch\
            checkTime = false
        }
    }

    func moveToNextLesson() {
        DispatchQueue.main.async {
            self.buttonStart.sendActions(for: .touchUpInside)
        }
        if (lessonCounter+1 == listLessons.count) {
            //dismiss(animated: true, completion: nil)
            if (choosenLesson.name != "Tutorial") {
                self.view.makeToast("You have finish this lesson, Click on the Left-Top button to take another lesson", duration: 3.0, position: .top)
            }
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
            
            buttonStart.setBackgroundImage(UIImage(named: "StopButton"), for: .normal)
            deleteLabel()
            
            var animationName: String = ""
            switch listLessons[lessonCounter] {
            case .Pan:
                labelName = self.labelMovement[1]
                animationName = "PanningMove4"
                pan = Pan.init()
                pan.delegate = self as! PanDelegate
                
                pan.startGyros()
                panStatus = 1
                break
            case .Tilt:
                labelName = self.labelMovement[3]
                animationName = "Tilt"
                tilt = Tilt.init()
                tilt.delegate = self as! TiltDelegate
                
                tiltStatus = 1
                tilt.startGyros()
                break
            case .Dolly:
                labelName = self.labelMovement[5]
                animationName = "DOLLY IN"
                dolly = Dolly(startPoint: self.sceneView!.pointOfView!.position)
                dolly.delegate = self as! DollyDelegate
                dollyCheck = true
                break
            case .Tracking:
                labelName = self.labelMovement[7]
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
        
            //show label 2
            self.view.makeToast(labelName, duration: 3.0, position: .top)
            
            let animationView = AnimationView(name: animationName)
            if animationView != nil {
                let imageProvider = BundleImageProvider(bundle: .main, searchPath: "images")
                animationView.imageProvider = imageProvider
                animationView.frame = CGRect(x: 100, y: 100, width: 400, height: 400)
                animationView.center = CGPoint.init(x: 450.0, y: 100.0)
                animationView.contentMode = .scaleAspectFill
                animationView.loopMode = .playOnce
                view.addSubview(animationView)
                
                animationView.play()
            }
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
                //self.shape.eulerAngles.x += rotationValue
            }
            else if tiltStatus == 2 {
                self.shape.position.y -= speed
                //self.shape.eulerAngles.x -= rotationValue
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
    
    // setting label untuk instruksi AR
    func buildLabel (data : String, deleteLabel: Bool = true) {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.labelAR.frame = CGRect(x: self.view.frame.width/4, y: 20, width: 400, height: 100)
                self.labelAR.text = data
                self.labelAR.textAlignment = .center
                self.labelAR.alpha = 0
                self.labelAR.numberOfLines = 0
                self.labelAR.textColor = UIColor.white
                self.labelAR.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                self.labelAR.layer.masksToBounds = true
                self.labelAR.layer.cornerRadius = 10
                self.labelAR.font = UIFont.systemFont(ofSize: 13)
                self.view.addSubview(self.labelAR)
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
                    DispatchQueue.main.async {
                        self.labelAR.alpha = 1
                    }
                }, completion: nil)
                
                if deleteLabel {
                    DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(3), execute: {
                        self.deleteLabel()
                    })
                }
            }
        }
    }
    
    func deleteLabel ()  {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            DispatchQueue.main.async {
                if self.labelAR != nil {
                    self.labelAR.alpha = 0
                }
            }
        }, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.labelAR != nil {
                self.labelAR.removeFromSuperview()
            }
        }
    }
    
    func createBall (position : SCNVector3) {
        
        let ballShape = SCNSphere(radius: 0.05)
        let ballNode = SCNNode(geometry: ballShape)
        ballNode.position = position
        sceneView.scene.rootNode.addChildNode(ballNode)
    }
    
    func addObject(name: String, position: SCNVector3, scale:  SCNVector3) {
        
        let node = SCNScene(named: name)!
        shape = node.rootNode
        print(plane.position)
        print(position)
        //shape.position = plane.worldPosition //position
        shape.scale = scale
        plane.addChildNode(shape)
        //sceneView.scene.rootNode.addChildNode(shape)
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
        //deleteLabel()
        //createCube()
        
        /*guard let touch = touches.first else {return}
        let result = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint ])
        
        guard let hitResult = result.last else {return}
        //return scene matrix
        let hitTransform = SCNMatrix4.init(hitResult.worldTransform)
        //matrix m41, 42, 43 is about position (x,y,z)
        let hitVector = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        addHuman(position: hitVector)
        firstObjectPosition = hitVector
        */
        /*DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.buildLabel(data: self.labelsContent[1])
        }*/
    }
}

extension TimeInterval {
    
    func toMs() -> Int {
        return Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
    }
    
    func stringFromTimeInterval() -> String {
        
        let time = NSInteger(self)
        
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
        
    }
}
