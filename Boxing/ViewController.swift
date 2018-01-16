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
    var backGroundPlayer1 = AVAudioPlayer()
    let opQueue = OperationQueue()
    var health = 100
    

    
    @IBOutlet weak var ReadyToFightLabel: UILabel!
    
    @IBOutlet weak var buttonPressed: UIButton!
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        backGroundPlayer.play()
        ReadyToFightLabel.text = "FIGHT!"
        buttonPressed.isHidden = false
        health = 100
        if buttonPressed.isHidden == true{
            buttonPressed.isHidden = false
        }
        else{
            buttonPressed.isHidden = true
            
        }
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
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                            print("\(self.health)")
                            print("Jab!")
                        }
                        else if yMotion > 1 {
                            self.health = self.health - 10
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                            print("\(self.health)")
                            print("Uppercut!")
                        }
                        else if zMotion > 1 {
                            self.health = self.health - 20
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                            print("\(self.health)")
                            print("Hook!")
                        }
                    }
                    if self.health > 75 && self.health < 100 {
                        DispatchQueue.main.async { // Correct
                            self.ReadyToFightLabel.text = "Keep fighting- above 75%"
                        }
                        print ("Keep fighting- above 75%")
                        self.gifView.loadGif(name: "giphy-1")
                        
                    }
                    
                    else if self.health > 50 && self.health < 74  {
                        print ("Halfway there- at 50%")
                        DispatchQueue.main.async { // Correct
                            self.ReadyToFightLabel.text = "Halfway there- at 50%"
                        }
                        self.gifView.loadGif(name: "giphy-2")
                    }

                    else if self.health > 25 && self.health < 49 {
                        print ("Almost there- at 25%")
                        DispatchQueue.main.async { // Correct
                            self.ReadyToFightLabel.text = "Almost there- at 25%"
                        }
                        self.gifView.loadGif(name: "giphy-3")
                    }
                    
                    else if self.health > 1 && self.health < 24 {
                        print ("Down goes Frasier-")
                        DispatchQueue.main.async { // Correct
                            self.ReadyToFightLabel.text = "Down goes Frasier-"
                        }
                        self.gifView.loadGif(name: "giphy-4")
                    }
                    
                    if self.health <= 0 {
                        print("You win!!!!")
                        DispatchQueue.main.async { // Correct
                            self.ReadyToFightLabel.text = "KNOCKOUT!"
                            self.buttonPressed.isHidden = false
                            self.buttonPressed.setTitle("Ready To Fight Again?", for: .normal)
                        }
                        self.gifView.loadGif(name: "giphy-5")
//                        manager.stopDeviceMotionUpdates()
//                        manager.stopAccelerometerUpdates()
                            self.backGroundPlayer.stop()

                        do{
                            self.backGroundPlayer1 = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "boxing_bell", ofType: "mp3")!))
                            self.backGroundPlayer1.prepareToPlay()
                            self.backGroundPlayer1.play()
//                            self.backGroundPlayer1.numberOfLoops = 0
//
//
//                            let audioSession = AVAudioSession.sharedInstance()
//                            do{
//                                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
//                            }
//                            catch{
//                                print("cant see you plpayer1")
//                            }
                        }
                        catch {
                            print(error)
                        }
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
    
    func updateUI(){
        print("it went to the updateUI")
    }
    
    func degrees(_ radians: Double) -> Double {
        return 180/Double.pi * radians
    }
 
}

