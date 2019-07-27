//
//  ARUtilities.swift
//  VideoVersionTwo
//
//  Created by Indra Sumawi on 25/07/19.
//  Copyright © 2019 Georgius Yoga Dewantama. All rights reserved.
//

import Foundation
import ARKit
import Lottie

extension ARViewController {
    
    func addObject(name: String, position: SCNVector3, scale:  SCNVector3) {
        
        let node = SCNScene(named: name)!
        shape = node.rootNode
        print(plane.position)
        print(position)
        shape.scale = scale
        plane.addChildNode(shape)
    }
    
    func showLottie(name: String, loopMode: LottieLoopMode) -> AnimationView {
        let animationView = AnimationView(name: name)
        if animationView != nil {
            let imageProvider = BundleImageProvider(bundle: .main, searchPath: "images")
            animationView.imageProvider = imageProvider
            animationView.frame = CGRect(x: 100, y: 100, width: 400, height: 400)
            animationView.center = CGPoint.init(x: 450.0, y: 100.0)
            animationView.contentMode = .scaleAspectFill
            animationView.loopMode = loopMode
            view.addSubview(animationView)
            
            animationView.play()
        }
        return animationView
    }
    
    func setupLabel() {
        labels["Tutorial"] =
            ["Great ! now there will be a Barrel in front of you",
             "Stay there and direct your phone corresponding to the Barrel",
             "Nice ! this is one of the interaction during this lesson",
             "Move your phone close to The Barrel",
             "Great ! you can also move forward and backward",
             "You have finished this Tutorial, Click on the Left-Top button to start you Journey"]
        
        labels["Introduction to Movement"] =
            ["First, you will learn Panning. Press Start button to Begin",
             "Stay there, move left and right corresponding with the Object",
             "Next, you will learn Tilting. Press Start button to Begin",
             "Stay there, move up and down corresponding with the Object",
             "Now, you will laern Dolly. Press Start button to Begin",
             "Move close up to the Object",
             "Finally, you will learn Tracking. Press Start button to Begin",
             "Move around the Object, by keeeping your distance",
             "Press Left-Top Button to back to your journey]"]
        
        labels["Circle the Object"] =
            ["You will combine techniques that you have learn. Press Start button to Begin",
             "First, Move around the Plant by keeeping your distance",
             "Second, Move your Phone to the Top and look down to the Plant",
             "Third, Move close up to the Plant"]
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
                //print("\(speed) cm/s")
                UIView.animate(withDuration: TimeInterval(Float(self.batchTime)/1000.0), delay: 0, options: .curveEaseInOut, animations: {
                    self.indicatorDataOverlay.frame.size.height = self.maxHeight - height
                }, completion: nil)
            }
            
            //move next batch\
            checkTime = false
        }
    }
}
