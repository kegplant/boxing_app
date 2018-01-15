//
//  ViewController.swift
//  Boxing
//
//  Created by Lilian Tashiro on 1/14/18.
//  Copyright © 2018 Apple, Inc. All rights reserved.
//


//vibration
//
//gif functions


import UIKit
import CoreMotion
import AVFoundation
import AudioToolbox

//AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);


class ViewController: UIViewController {

    @IBOutlet weak var gifView: UIImageView!
    var motionManager : CMMotionManager?
    var backGroundPlayer = AVAudioPlayer()
    let opQueue = OperationQueue()
    var health = 100

    
    @IBOutlet weak var ReadyToFightLabel: UILabel!
    
    @IBOutlet weak var buttonPressed: UIButton!
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        backGroundPlayer.play()
        ReadyToFightLabel.text = "FIGHT!"
        buttonPressed.setTitle("Reset", for: .normal)
        print("button pressed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gifView.loadGif(name: "giphy-tumblr")
        do{
            backGroundPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "MommaSayKnockYouOut", ofType: "mp3")!))
            backGroundPlayer.prepareToPlay()
            backGroundPlayer.numberOfLoops = -1
            
            let audioSession = AVAudioSession.sharedInstance()
            do{
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            }
            catch{
            }
        }
        catch {
            print(error)
        }
        motionManager = CMMotionManager()
        
        if let manager = motionManager {
            print ("we are in motion manager")
            if manager.isDeviceMotionAvailable && manager.isAccelerometerAvailable {
                print("we have motion and accel")
                
                let myQ = OperationQueue()
                
                manager.deviceMotionUpdateInterval =  1
                motionManager?.accelerometerUpdateInterval = 1
                
                manager.startDeviceMotionUpdates(to: myQ, withHandler: { (data: CMDeviceMotion?, error: Error?) in
                    if let mydata = data {
                        
                        let attitude = mydata.attitude
                        print (attitude)
                        
                    }
                    if let myAccelData = data
                    {
                        let xMotion = myAccelData.userAcceleration.x
                        print ("forward", xMotion)
                        
                        let yMotion = myAccelData.userAcceleration.y
                        print("upward", yMotion)
                        
                        let zMotion = myAccelData.userAcceleration.z
                        print("round", zMotion)
                        
                        if xMotion > 1 {
                            self.health = self.health - 5
                            print("\(self.health)")
                            print("Jab!")
                        }
                        else if yMotion > 1 {
                            self.health = self.health - 10
                            print("\(self.health)")
                            print("Uppercut!")
                        }
                        else if zMotion > 1 {
                            self.health = self.health - 20
                            print("\(self.health)")
                            print("Hook!")
                        }
                    }
                    if self.health == 0 {
                        print("You win!!!!")
                        manager.stopDeviceMotionUpdates()
                        manager.stopAccelerometerUpdates()
                            self.backGroundPlayer.stop()
                        
                        
                    }
                    if let myerror = error {
                        // if we get an error, then we'll stop our device from trying to update.
                        // it would be nice to send an error message ot the user
                        print("myerror", myerror)
                        manager.stopDeviceMotionUpdates()
                        manager.stopAccelerometerUpdates()
                    }
                })
            }
            else {
                print("Cannot detect device motion")
            }
        }
        else {
            print("We do not have a motion manager.")
        }
    }
    
    
    func degrees(_ radians: Double) -> Double {
        return 180/Double.pi * radians
    }
   
//    override func viewDidAppear(_ animated: Bool)
//    {
//        motionManager?.accelerometerUpdateInterval = 1 //update every 0.2 sec
//        motionManager?.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in// tracking the motion, access current (not a function, getting two variable.  data or an error.
//            if let myFightData = data  //checking to get data and set it to data
//            {
//                if myFightData.acceleration.x > 2  //x shaking back and forth
//                {
//                    //                    self.healthStatus -= 5
//                    print("left and right noted")  ///x  shaking back and forth.  y z @ something
//                }
//                if myFightData.acceleration.y > 2
//                {
//                    print("up and down noted")
//                    
//                }
//                if myFightData.acceleration.y > 2
//                {
//                    print("side noted")
//                }
//            }
//        }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//

}

