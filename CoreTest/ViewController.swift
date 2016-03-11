//
//  ViewController.swift
//  CoreMotion
//
//  Created by Eli Byers on 3/11/16.
//  Copyright © 2016 Eli Byers. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    //    Instance Variables
    var currentMaxAccelX = 0.0
    var currentMaxAccelY = 0.0
    var currentMaxAccelZ = 0.0
    var currentMaxRotX = 0.0
    var currentMaxRotY = 0.0
    var currentMaxRotZ = 0.0
    
    var motionManager = CMMotionManager()
    
    // Outlets
    @IBOutlet weak var accX: UILabel!
    @IBOutlet weak var accY: UILabel!
    @IBOutlet weak var accZ: UILabel!
    @IBOutlet weak var maxAccX: UILabel!
    @IBOutlet weak var maxAccY: UILabel!
    @IBOutlet weak var maxAccZ: UILabel!
    @IBOutlet weak var rotX: UILabel!
    @IBOutlet weak var rotY: UILabel!
    @IBOutlet weak var rotZ: UILabel!
    @IBOutlet weak var maxRotX: UILabel!
    @IBOutlet weak var maxRotY: UILabel!
    @IBOutlet weak var maxRotZ: UILabel!
    
    
    @IBAction func resetMaxValues() {
        currentMaxAccelX = 0.0
        currentMaxAccelY = 0.0
        currentMaxAccelZ = 0.0
        currentMaxRotX = 0.0
        currentMaxRotY = 0.0
        currentMaxRotZ = 0.0
    }
    
    //Functions
    override func viewDidLoad() {
        
        self.resetMaxValues()
        
        motionManager.gyroUpdateInterval = 0.2
        motionManager.accelerometerUpdateInterval = 0.2
        
        //Start Recording Data
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!) { (accelerometerData: CMAccelerometerData?, NSError) -> Void in
            
            self.outputAccData(accelerometerData!.acceleration)
            if(NSError != nil) {
                print("\(NSError)")
            }
        }
        
        motionManager.startGyroUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: { (gyroData: CMGyroData?, NSError) -> Void in
            self.outputRotData(gyroData!.rotationRate)
            if (NSError != nil){
                print("\(NSError)")
            }
            
            
        })
        
    }
    
    func outputAccData(acceleration: CMAcceleration){
        
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
    
    func outputRotData(rotation: CMRotationRate){
        
        
        rotX?.text = "\(rotation.x).2fr/s"
        if fabs(rotation.x) > fabs(currentMaxRotX){
            currentMaxRotX = rotation.x
        }
        
        rotY?.text = "\(rotation.y).2fr/s"
        if fabs(rotation.y) > fabs(currentMaxRotY){
            currentMaxRotY = rotation.y
        }
        
        rotZ?.text = "\(rotation.z).2fr/s"
        if fabs(rotation.z) > fabs(currentMaxRotZ){
            currentMaxRotZ = rotation.z
        }
        
        
        
        
        maxRotX?.text = "\(currentMaxRotX).2f"
        maxRotY?.text = "\(currentMaxRotY).2f"
        maxRotZ?.text = "\(currentMaxRotZ).2f"
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

