//
//  StoppedDeviceListModel.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 17/11/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

class StoppedDeviceListModel {
    var isSuccess:Bool?
    var arrayList:[List]?
    
    static func valueInitialization(jsonData:[String:AnyObject]) -> StoppedDeviceListModel {
        let stoppedDeviceListModel = StoppedDeviceListModel()
        
        if let isSuccess = jsonData["IsSuccess"]
        {
            stoppedDeviceListModel.isSuccess = isSuccess as? Bool
        }
        if let responseList = jsonData["Response"] as? [AnyObject]  {
            
            stoppedDeviceListModel.arrayList = responseList.map({List.valuePassing(dict: $0)})
        }
        
        return stoppedDeviceListModel
    }
}

class List {
    var deviceID:Int64?
    var deviceName:String?
    var machineShutdown:Int64?
    var plannedDescription:Int64?
    var machineDowntime:Int64?
    
    
    static func valuePassing(dict:AnyObject) -> List {
        let list = List()
        
        if  let deviceID = dict["DeviceID"] {
            list.deviceID = deviceID as? Int64
        }
        if let deviceName = dict["DeviceName"] {
            list.deviceName = deviceName as? String
        }
        if let machineShutdown = dict["MachineShutdown"] {
            list.machineShutdown = machineShutdown as? Int64
        }
        if let plannedDescription = dict["PlannedDescription"] {
            list.plannedDescription = plannedDescription as? Int64
        }
        if let machineDowntime = dict["MachineDowntime"] {
            list.machineDowntime = machineDowntime as? Int64
        }
        
        
        return list
    }
}
