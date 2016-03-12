//
//  ViewController.swift
//  CoreMotion
//
//  Created by Eli Byers on 3/11/16.
//  Copyright © 2016 Eli Byers. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation


class ViewController: UIViewController {
    
    // drum variables
    var frontDrumAcc = 0.0
    var frontDrumMove = false
    var frontDrumHit = false
    
    var leftDrumAcc = 0.0
    var leftDrumMove = false
    var leftDrumHit = false

    var rightDrumAcc = 0.0
    var rightDrumMove = false
    var rightDrumHit = false

    // control variables
    let limit = 4.0
    let center = 1.0
    let resetDelay = 0.1
    
    // managers
    var motionManager = CMMotionManager()
    var kickSound = AVAudioPlayer()
    var highHatSound = AVAudioPlayer()
    var snareSound = AVAudioPlayer()
    
    
    // Functions
    override func viewDidLoad() {
        
        super.viewDidLoad()

        motionManager.accelerometerUpdateInterval = 0.001
        
        // Start Recording Data
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!) { (accelerometerData: CMAccelerometerData?, NSError) -> Void in
            
            self.outputAccData(accelerometerData!.acceleration)
            
            if(NSError != nil) {
                print("\(NSError)")
            }
        }

        // Kick sound
        let kick = NSBundle.mainBundle().pathForResource("Kick", ofType: "wav")
        if let kick = kick{
            let myPathURL = NSURL(fileURLWithPath: kick)
            
            do{
                try kickSound = AVAudioPlayer(contentsOfURL: myPathURL)
                //                mySound.play()
            } catch{
                print("error")
            }
        }
        
        // High Hat Sound
        let highHat = NSBundle.mainBundle().pathForResource("HighHat", ofType: "mp3")
        if let highHat = highHat{
            let myPathURL = NSURL(fileURLWithPath: highHat)
            
            do{
                try highHatSound = AVAudioPlayer(contentsOfURL: myPathURL)
                //                mySound.play()
            } catch{
                print("error")
            }
        }
        
        // Snare Sound
        let snare = NSBundle.mainBundle().pathForResource("Snare", ofType: "m4a")
        if let snare = snare{
            let myPathURL = NSURL(fileURLWithPath: snare)
            
            do{
                try snareSound = AVAudioPlayer(contentsOfURL: myPathURL)
                //                mySound.play()
            } catch{
                print("error")
            }
        }
        
        

        
    }
    
    
    func outputAccData(acceleration: CMAcceleration){
        
        // put acceleratins in object and only pass on the largest one <-- need to do
        
        switch (acceleration.x < -limit, acceleration.z < -limit, acceleration.x > limit){
            case (true, _, _):
                if (!frontDrumMove && !rightDrumMove) {
                    leftDrumMove = true
                }
            case (_, true, _):
                if (!leftDrumMove && !rightDrumMove) {
                    frontDrumMove = true
                }
            case (_, _, true):
                if (!leftDrumMove && !frontDrumMove) {
                    rightDrumMove = true
                }
            default: break
        }
        
        switch (leftDrumMove, frontDrumMove, rightDrumMove) {
            case (true, _, _):
                if acceleration.x >= -center {
                    leftDrum()
                }
            case (_, true, _):
                if acceleration.z >= center {
                    frontDrum()
                }
            case (_, _, true):
                if acceleration.x <= center {
                    rightDrum()
                }
            default: break
        }
        
    }
    
    
    
    func leftDrum() {
        highHatSound.play()
        delay(resetDelay){
            self.leftDrumMove = false
        }
        print("<--")
    }
    
    func frontDrum(){
        kickSound.play()
        delay(resetDelay){
            self.frontDrumMove = false
        }
        print("^")
    }
    
    
    func rightDrum() {
        snareSound.play()
        delay(resetDelay){
            self.rightDrumMove = false
        }
        print("-->")
    }
    
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
        
    }
    
    

        
//        func noDrum() -> Bool {
//            if leftDrumMove || rightDrumMove || frontDrumMove {
//                return false
//            } else {
//                return true
//            }
//        }
        
        
//        if noDrum() && acceleration.x < -limit {
//            leftDrumMove = true
//        } else if leftDrumMove && acceleration.x >= -center {
//            leftDrumMove = false
//            leftDrum()
//        }
//        
//        if noDrum() && acceleration.x > limit {
//            rightDrumMove = true
//        } else if rightDrumMove && acceleration.x <= center {
//            rightDrumMove = false
//            rightDrum()
//        }
//        
//        if noDrum() && acceleration.y < -limit {
//            frontDrumMove = true
//        } else if frontDrumMove && acceleration.y <= center {
//            frontDrumMove = false
//            frontDrum()
//        }
        
        
    func slap(){
//        mySound.play()
    }
    
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

