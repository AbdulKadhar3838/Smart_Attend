//
//  Constants.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 23/10/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

let developmentBaseApi:String = "http://smartattend.colanonline.net/service/api/" // Development Purpose
let preprodBaseApi:String = "http://preprod.smartattendtest.com//service/api/" //PreProduction
let prodBaseApi:String = "http://smartattendtest.com/service/api/" // App Store live

var BaseApi:String = developmentBaseApi

var isPreprodBaseURL:Bool = true {
    didSet {
        BaseApi = isPreprodBaseURL == true ? preprodBaseApi : prodBaseApi
    }
}


let navheight:CGFloat=62
let dfualts=UserDefaults.standard
let AccountID:String = "AccountID"
let CustomerID:String = "CustomerID"
let no_internet:String="This operation could not be completed. Please connect to the internet and try again."
let defalts:UserDefaults = UserDefaults.standard
var customer_id:String?
var account_id:String!
var account_email:String!

let orientation = UIDevice.current.orientation
var portraitHeight:CGFloat! = orientation.isPortrait ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.width
var portraitWidth:CGFloat! = orientation.isPortrait ? UIScreen.main.bounds.size.width : UIScreen.main.bounds.size.height
var isNewVersionAvailable:Bool = false
let appStoreAppID = "1210100664"
var releaseVersion = ""
var currentAppVersion = ""

class Constants: NSObject {
    
}
