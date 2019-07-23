//
//  Global.swift
//  Smart_Attender
//
//  Created by Rajith Kumar on 19/12/16.
//  Copyright © 2016 Colan. All rights reserved.
//

import UIKit
import SystemConfiguration
import CoreMotion

let motionManager = CMMotionManager()
var arrayglobalTimestampActual:[String] = []
var arrayglobalETCTask:[String] = []
var arrayglobalTimestampETA:[String] = []
var arrayglobalTimestampEfficiency:[String] = []
var arrayGlobalMachineName:[String] = []
var arrayGlobalDeviceIDwtfMachineName:[Int64] = []
var isDashboardHomePage = true



class Global: NSObject {
    // MARK: - Machinestatus Enum
    enum machine_status:Int{
        case Stopped=0
        case Running
        case Idle
        case Other
        
        var stringvalue:String{
            switch self {
            case .Stopped: return "Stopped"
            case .Running: return "Running"
            case .Idle: return "Idle"
            case .Other: return "Other"
            }
        }
        var color:UIColor{
            switch self {
            case .Stopped: return UIColor.init(netHex: 0xFF3430)
            case .Running: return UIColor.init(netHex: 0x79BC6A)
            case .Idle: return UIColor.init(netHex: 0xDB99D6)
            case .Other: return UIColor.init(netHex: 0x4396D8)
            }
        }
    }
    enum machineReport:String{
        case Running = "Running"
        case Downtime = "Downtime"
        
        var reportValue:String{
            switch self {
            case .Running: return "Total Running Time:"
            case .Downtime: return "Total Downtime:"
            }
        }
        
    }
    
    // MARK: - ScreenSize protocol
    enum UIUserInterfaceIdiom : Int
    {
        case Pad
        case Phone
    }
    struct ScreenSize
    {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct IS
    {
        static let IPHONE_4  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
        static let IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
    }
    
    //MARK: - User Role
    struct userType {
        static func isAdmin() -> Bool{
            let usertype:String=dfualts.value(forKey: "UserType") as? String ?? ""
            if (usertype.lowercased() == "admin")
            {
                return true
            }
            return false
        }
        static func isOperator() -> Bool{
            let usertype:String=dfualts.value(forKey: "UserType") as? String ?? ""
            if (usertype.lowercased() == "operator")
            {
                return true
            }
            return false
        }
        static func isManager() -> Bool{
            let usertype:String=dfualts.value(forKey: "UserType") as? String ?? ""
            if (usertype.lowercased() == "manager")
            {
                return true
            }
            return false
        }
        static func storeDefaults(AccountId:NSNumber,CustomerId:NSNumber)
        {
            let account:String!=AccountId.stringValue
            dfualts.setValue(account, forKey: AccountID)
            account_id=dfualts.value(forKey: AccountID) as? String
            let customer:String!=CustomerId.stringValue
            dfualts.setValue(customer, forKey: CustomerID)
            customer_id=dfualts.value(forKey: CustomerID) as? String
        }
    }
    
    // MARK: - Internet Check
    struct network
    {
        static func connectedToNetwork() -> Bool {
            
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
            zeroAddress.sin_family = sa_family_t(AF_INET)
            
            guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                    SCNetworkReachabilityCreateWithAddress(nil, $0)
                }
            }) else {
                return false
            }
            
            var flags: SCNetworkReachabilityFlags = []
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
                return false
            }
            
            let isReachable = flags.contains(.reachable)
            let needsConnection = flags.contains(.connectionRequired)
            
            return (isReachable && !needsConnection)
        }
        static func redAlert(error: NSError?,noConnection: String?) -> String
        {
            if(error == nil)
            {
                return noConnection!
            }
            else
            {
            return (error?.localizedDescription)!
            }
        }
    }
    
    // MARK: - Webservice Methods
    struct server
    {
        static func Get(path: String,jsonObj: NSMutableDictionary?,completionHandler: @escaping (Any?, NSError?, String?) -> ())
        {
            if network.connectedToNetwork()
            {
                let request = NSMutableURLRequest(url: NSURL(string: BaseApi + path) as! URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 120)
                print("requestURL",request)
                request.httpMethod = "GET"
                print("Request Url: \(request.url?.absoluteURL)")
                request.setValue("application/json",forHTTPHeaderField: "Content-Type")
                request.setValue("application/json",forHTTPHeaderField: "Accept")
                if jsonObj==nil {
                    
                }
                else
                {
                    request.httpBody = try! JSONSerialization.data(withJSONObject: jsonObj!, options: [])
                    print("Request Body: \(NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue))")
                }
                
                let config = URLSessionConfiguration.default
                config.requestCachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
                config.urlCache = nil
                let session = URLSession(configuration: config)
                let task = session.dataTask(with: request as URLRequest)
                { data, response, error in
                    DispatchQueue.main.async {
                        guard error == nil && data != nil else {
                            print("error=\(error)")
                            completionHandler(nil, error as NSError?,nil)
                            return
                        }
                        
                        let httpStatus = response as? HTTPURLResponse
                        if httpStatus?.statusCode != 200 {
                            print("statusCode should be 200, but is \(httpStatus?.statusCode)")
                        }
                        print("Api hit success status code \(httpStatus?.statusCode)")
                        do {
                            
                            if let json:Any = try JSONSerialization.jsonObject(with: data!, options: [])
                            {
                                completionHandler(json, nil, nil)
                                print("Response:====>\(json)")
                            }
                            else
                            {
                                let resp_strg=NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                print("Response is not a json or invalid json")
                                
                                completionHandler(resp_strg, nil, nil)
                                print("Nonjson Response:====>\(resp_strg)")
                            }
                        }
                        catch let parseError {
                            print("Failure:====>\(parseError)")
                            completionHandler(nil, parseError as NSError?, nil)
                        }
                    }
                }
                task.resume()
            }
            else
            {
                completionHandler(nil,nil,no_internet)
            }
        }
        
        static func Post(path: String,jsonObj:   NSMutableDictionary?,completionHandler: @escaping (Any?, NSError?,String?) -> ())
        {
            //URLCache.shared.removeAllCachedResponses();
            if network.connectedToNetwork()
            {
                let request = NSMutableURLRequest(url: NSURL(string: BaseApi + path) as! URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
                request.httpMethod = "POST"
                print("Request Url: \(request.url?.absoluteURL)")
                request.httpBody = try! JSONSerialization.data(withJSONObject: jsonObj!, options: [])
                request.setValue("application/json",forHTTPHeaderField: "Content-Type")
                request.setValue("application/json",forHTTPHeaderField: "Accept")
                print("Request Body: \(NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue))")
                
                let config = URLSessionConfiguration.default
                config.requestCachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
                let session = URLSession(configuration: config)
                let task = session.dataTask(with: request as URLRequest)
                { data, response, error in
                    DispatchQueue.main.async {
                        guard error == nil && data != nil else {
                            print("error=\(error)")
                            completionHandler(nil, error as NSError?, nil)
                            return
                        }
                        
                        if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {
                            print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        }
                        
                        do {
                            
                            if let json:Any = try JSONSerialization.jsonObject(with: data!, options: [])
                            {
                                completionHandler(json, nil, nil)
                                print("Response:====>\(json)")
                            }
                            else
                            {
                                let resp_strg=NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                print("Response is not a json or invalid json")
                                
                                completionHandler(resp_strg, nil, nil)
                                print("Nonjson Response:====>\(resp_strg)")
                            }
                        }
                        catch let parseError {
                            print("Failure:====>\(parseError)")
                            completionHandler(nil, parseError as NSError?, nil)
                        }
                    }
                }
                task.resume()
            }
            else
            {
                completionHandler(nil,nil, no_internet)
            }
        }
        
        static func PostRequestArray(path: String,jsonObj:   [NSMutableDictionary]?,completionHandler: @escaping (Any?, NSError?,String?) -> ())
        {
            //URLCache.shared.removeAllCachedResponses();
            if network.connectedToNetwork()
            {
                let request = NSMutableURLRequest(url: NSURL(string: BaseApi + path) as! URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
                request.httpMethod = "POST"
                print("Request Url: \(request.url?.absoluteURL)")
                request.httpBody = try! JSONSerialization.data(withJSONObject: jsonObj!, options: [])
                request.setValue("application/json",forHTTPHeaderField: "Content-Type")
                request.setValue("application/json",forHTTPHeaderField: "Accept")
                print("Request Body: \(NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue))")
                
                let config = URLSessionConfiguration.default
                config.requestCachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
                let session = URLSession(configuration: config)
                let task = session.dataTask(with: request as URLRequest)
                { data, response, error in
                    DispatchQueue.main.async {
                        guard error == nil && data != nil else {
                            print("error=\(error)")
                            completionHandler(nil, error as NSError?, nil)
                            return
                        }
                        
                        if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {
                            print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        }
                        
                        do {
                            
                            if let json:Any = try JSONSerialization.jsonObject(with: data!, options: [])
                            {
                                completionHandler(json, nil, nil)
                                print("Response:====>\(json)")
                            }
                            else
                            {
                                let resp_strg=NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                print("Response is not a json or invalid json")
                                
                                completionHandler(resp_strg, nil, nil)
                                print("Nonjson Response:====>\(resp_strg)")
                            }
                        }
                        catch let parseError {
                            print("Failure:====>\(parseError)")
                            completionHandler(nil, parseError as NSError?, nil)
                        }
                    }
                }
                task.resume()
            }
            else
            {
                completionHandler(nil,nil, no_internet)
            }
        }
    }
}
