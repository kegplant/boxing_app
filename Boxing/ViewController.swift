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
    var isFighting=false
    var axes:[Double]=[]
    var isPunching=false
    
    @IBOutlet weak var ReadyToFightLabel: UILabel!
    
    @IBOutlet weak var buttonPressed: UIButton!
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        health = 100
        if(!isFighting){
            isFighting=true
            buttonPressed.setTitle("Stop",for:.normal)
            backGroundPlayer.play()
            ReadyToFightLabel.text = "FIGHT!"
            fight()
        }else{
            isFighting=false
            buttonPressed.setTitle("Push to Start",for:.normal)
            if let manager = motionManager {
                print ("stopping motion manager")
                if manager.isDeviceMotionAvailable && manager.isAccelerometerAvailable {
                    print("stopping motion and accel")
                    manager.stopDeviceMotionUpdates()
                    manager.stopAccelerometerUpdates()
                }
            }
        }
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
    }
    func fight(){
        if let manager = motionManager {
            print ("we are in motion manager")
            if manager.isDeviceMotionAvailable && manager.isAccelerometerAvailable {
                print("we have motion and accel")
                
                let myQ = OperationQueue()
                
                manager.deviceMotionUpdateInterval =  0.01
                motionManager?.accelerometerUpdateInterval = 0.01
                
                manager.startDeviceMotionUpdates(to: myQ, withHandler: { (data: CMDeviceMotion?, error: Error?) in
//                    if let mydata = data {
//                        let attitude = mydata.attitude
//                        print (attitude)
//                    }
                    if let myAccelData = data
                    {
                        let xMotion = myAccelData.userAcceleration.x
                        print ("forward", xMotion)
                        
                        if xMotion > 0.1 {
                            
                            
                            
                            
                            
                            
                            self.health = self.health - 5
                            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                            print("\(self.health)")
                            print("Jab!")
                            self.dealDamage(damage: 26.0)
                        }
                        
                    }
                    if let myerror = error {
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
    func dealDamage(damage:Double){
        self.health -= Int(damage)
        self.checkHealth()
    }
    func checkHealth(){
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
    }
    func updateUI(){
        print("it went to the updateUI")
    }
}

