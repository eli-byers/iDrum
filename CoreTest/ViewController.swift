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
    
    @IBOutlet weak var pitchLabel: UILabel!
    @IBOutlet weak var rollLabel: UILabel!
    
    // attitude variables
    var initialAttitude: (roll: Double, pitch: Double)?
    var deviceAttitude: (roll: Double, pitch: Double)?
    
    var resetFlag = false
    
    let queue = NSOperationQueue.mainQueue
    
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

    // acceleration control variables
    let limit = 5.5
    let center = 0.0
    let resetDelay = 0.2
    
    // managers
    var motionManager = CMMotionManager()
    var kickSound = AVAudioPlayer()
    var highHatSound = AVAudioPlayer()
    var snareSound = AVAudioPlayer()
    
    

    // Functions
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // attitude
        motionManager.deviceMotionUpdateInterval = 1 / 30
        
        motionManager.startDeviceMotionUpdatesToQueue(queue())
            {
                (deviceMotionData: CMDeviceMotion?, error: NSError?) in
                
                if let deviceMotionData = deviceMotionData
                {
                    if (self.initialAttitude == nil || self.resetFlag)
                    {
                        self.resetFlag = false
                        self.initialAttitude = (deviceMotionData.attitude.roll,
                            deviceMotionData.attitude.pitch)
                        
//                        self.rollLabel.text = String(Float(self.initialAttitude!.roll))
//                        self.pitchLabel.text = String(Float(self.initialAttitude!.pitch))
                        
                    }
                    
                    self.rollLabel.text = String(Float(self.initialAttitude!.roll - deviceMotionData.attitude.roll))
                    self.pitchLabel.text = String(Float(self.initialAttitude!.pitch - deviceMotionData.attitude.pitch))
                    
                }
                
        }

        
        // acceleration
        motionManager.accelerometerUpdateInterval = 0.001
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
        
        
        if noDrum() && acceleration.x < -limit {
            leftDrumMove = true
        } else if leftDrumMove && acceleration.x >= -limit {
            leftDrumMove = false
            leftDrum()
        }

        if noDrum() && acceleration.x > limit {
            rightDrumMove = true
        } else if rightDrumMove && acceleration.x <= limit {
            rightDrumMove = false
            rightDrum()
        }

        if noDrum() && acceleration.z < -limit {
            frontDrumMove = true
        } else if frontDrumMove && acceleration.z >= -limit {
            frontDrumMove = false
            frontDrum()
        }
        
        switch (acceleration.x < -limit, acceleration.z < -limit, acceleration.x > limit){
            case (false, _, _): leftDrumMove = false
            case (_, false, _): frontDrumMove = false
            case (_, _, false): rightDrumMove = false
            default: break
        }
        
    }
    
    
    
    func leftDrum() {
        highHatSound.play()
        delay(resetDelay){
            self.leftDrumMove = false
        }
        print("<")
    }
    
    func frontDrum(){
        kickSound.play()
        delay(resetDelay){
            self.frontDrumMove = false
        }
        print(" ^")
    }
    
    
    func rightDrum() {
        snareSound.play()
        delay(resetDelay){
            self.rightDrumMove = false
        }
        print("  >")
    }
    
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
        
    }
    
        
    func noDrum() -> Bool {
        if leftDrumMove || rightDrumMove || frontDrumMove {
            return false
        } else {
            return true
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

