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
    
    // drup variables
    var frontDrumAcc = 0.0
    var frontDrumMove = false
    var leftDrumAcc = 0.0
    var leftDrumMove = false
    var rightDrumAcc = 0.0
    var rightDrumMove = false
    
    
    //    Instance Variables
    var currentMaxAccelX = 0.0
    var currentMaxAccelY = 0.0
    var currentMaxAccelZ = 0.0

    
    var motionManager = CMMotionManager()
    var mySound = AVAudioPlayer()
    

    // Outlets
    @IBOutlet weak var accX: UILabel!
    @IBOutlet weak var accY: UILabel!
    @IBOutlet weak var accZ: UILabel!
    @IBOutlet weak var maxAccX: UILabel!
    @IBOutlet weak var maxAccY: UILabel!
    @IBOutlet weak var maxAccZ: UILabel!
    
    
    @IBAction func resetMaxValues() {
        currentMaxAccelX = 0.0
        currentMaxAccelY = 0.0
        currentMaxAccelZ = 0.0
    }
    
    //Functions
    override func viewDidLoad() {
        
        self.resetMaxValues()
        
        motionManager.accelerometerUpdateInterval = 0git
        
        //Start Recording Data

        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!) { (accelerometerData: CMAccelerometerData?, NSError) -> Void in
        
            self.outputAccData(accelerometerData!.acceleration)
            
            if(NSError != nil) {
                print("\(NSError)")
            }
        }
        
        super.viewDidLoad()
        
        let myPathString = NSBundle.mainBundle().pathForResource("ShortSlap", ofType: "m4a")
        if let myPathString = myPathString{
            let myPathURL = NSURL(fileURLWithPath: myPathString)
            
            do{
                try mySound = AVAudioPlayer(contentsOfURL: myPathURL)
//                mySound.play()
            } catch{
                print("error")
            }
        }

        
    }
    
    
    func outputAccData(acceleration: CMAcceleration){
        
        let limit = 4.0
        
        
        if !leftDrumMove && acceleration.x < -limit {
            leftDrumMove = true
            frontDrumMove = false
            rightDrumMove = false
        } else if leftDrumMove && acceleration.x >= 1 {
            leftDrumMove = false
            leftDrum()
        }
        
        if !rightDrumMove && acceleration.x > limit {
            rightDrumMove = true
            frontDrumMove = false
            leftDrumMove = false
        } else if rightDrumMove && acceleration.x <= 1 {
            rightDrumMove = false
            rightDrum()
        }
        
        if !frontDrumMove && acceleration.y > limit {
            frontDrumMove = true
            leftDrumMove = false
            rightDrumMove = false
        } else if frontDrumMove && acceleration.y <= 1 {
            frontDrumMove = false
            frontDrum()
        }
        
        
        
        accX?.text = "\(acceleration.x).2fg"
        if fabs(acceleration.x) > fabs(currentMaxAccelX){
            currentMaxAccelX = acceleration.x
        }
        
        accY?.text = "\(acceleration.y).2fg"
        if fabs(acceleration.y) > fabs(currentMaxAccelY){
            currentMaxAccelY = acceleration.y
        }
        
        accZ?.text = "\(acceleration.z).2fg"
        if fabs(acceleration.z) > fabs(currentMaxAccelZ){
            currentMaxAccelZ = acceleration.z
        }
        
        
        maxAccX?.text = "\(currentMaxAccelX).2f"
        maxAccY?.text = "\(currentMaxAccelY).2f"
        maxAccZ?.text = "\(currentMaxAccelZ).2f"
        
        
    }
    
    func leftDrum() {
        print("<--")
        slap()
    }
    
    func frontDrum(){
        print("^")
        slap()
    }
    
    func rightDrum() {
        print("-->")
        slap()
    }
    
    func slap(){
       mySound.play()
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

