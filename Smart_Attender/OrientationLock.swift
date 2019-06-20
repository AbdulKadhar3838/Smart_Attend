//
//  OriientationLock.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 06/10/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit
import CoreMotion


var globalPitchCalculation:Double = 0.0
var globalYawCalculation:Double = 0.0
var globalRollCalculation:Double = 0.0

class OrientationLock {
    
   class func motionCalculation()
    {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(
                to: OperationQueue.current!, withHandler: {
                    (deviceMotion, error) -> Void in
                    
                    if(error == nil) {
                        self.handleDeviceMotionUpdate(deviceMotion: deviceMotion!)
                    } else {
                        //handle the error
                    }
            })
        }
    }
    
  class func handleDeviceMotionUpdate(deviceMotion:CMDeviceMotion) {
        let attitude = deviceMotion.attitude
        let roll = degrees(radians: attitude.roll)
        let pitch = degrees(radians: attitude.pitch)
        let yaw = degrees(radians: attitude.yaw)
    
        globalPitchCalculation = pitch
        globalYawCalculation = (yaw * (-1 ))
        globalRollCalculation = roll
     //   print("attitude--->>\(attitude),roll--->>>>\(roll),pitch---->\(pitch),yaw---->\(yaw)")
    }
    
  class func degrees(radians:Double) -> Double {
        return 180 / M_PI * radians
    }
    
 class  func topassLineorientationTopiechart(tosetLandcaperightorleft:String) {
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
            print("HomeBtnright")
        }
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
            
            print("HomeBtnleft")
            if tosetLandcaperightorleft == "HomeBtnright" {
        //        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
            }
        }
        
        if   (UIDevice.current.orientation == UIDeviceOrientation.portrait){
            print("portrait")
            
        }
        if UIDevice.current.orientation.isFlat {
            print("Flat")
            
        }
        if motionManager.isDeviceMotionAvailable
        {
            if  (globalPitchCalculation > 9)  && (globalRollCalculation < 10) && (globalRollCalculation > -10) || (UIDevice.current.orientation.isPortrait )
            {
                // Its portrait mode
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            }
            if (tosetLandcaperightorleft == "HomeBtnright" ) && UIDevice.current.orientation.isFlat  {
                
             //   UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
            }
        }
    }
    
    
}
