//
//  PartAssignModel.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 07/11/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

class PartAssignModel {
    var arrayAssignedList: Array<ArrayAssignedList>?
    var isSuccess:  Bool?
    var message: String?
    var assignedPart : String?
    
    static func valueInitialization(jsonData:[String:AnyObject]) -> PartAssignModel {
        let partAssignModel = PartAssignModel()
        if let isSuccess = jsonData["IsSuccess"],
            let message = jsonData["Message"]
        {
            partAssignModel.isSuccess = isSuccess as? Bool
            partAssignModel.message = message as? String
        }
        if let assignList = jsonData["LstAssignedPartModel"] as? [AnyObject]  {
            
            partAssignModel.arrayAssignedList = assignList.map({ArrayAssignedList.valuePassing(dict: $0)})
        }

        return partAssignModel
    }
}
    
    class ArrayAssignedList {
        var id: Int64?
        var scrap:Int64?
        var partNumber:  String?
        var deviceID: Int64?
        var deviceName : String?
        var cavity: Int64?
        var cycleTime:  String?
        var startDate: String?
        var requiredQuantity : Int64?
        var partId : Int64?
        
        static func valuePassing(dict:AnyObject) -> ArrayAssignedList {
            let arrayAssignedList = ArrayAssignedList()
            
            if  let id = dict["Id"] {
                arrayAssignedList.id = id as? Int64
            }
            if let partNumber = dict["PartNumber"] {
                arrayAssignedList.partNumber = partNumber as? String
            }
            if let deviceID = dict["DeviceID"] {
                arrayAssignedList.deviceID = deviceID as? Int64
            }
            if let deviceName = dict["DeviceName"] {
                arrayAssignedList.deviceName = deviceName as? String
            }
            if let cavity = dict["Cavity"] {
                arrayAssignedList.cavity = cavity as? Int64
            }
            if let cycleTime = dict["CycleTime"] {
                arrayAssignedList.cycleTime = cycleTime as? String
            }
            if let startDate = dict["StartDateTime"] {
                arrayAssignedList.startDate = startDate as? String
            }
            if let requiredQuantity = dict["RequiredQuantity"] {
                arrayAssignedList.requiredQuantity = requiredQuantity as? Int64
            }
            if let partId = dict["PartId"] {
                arrayAssignedList.partId = partId as? Int64
            }
            if let scrap = dict["Scrap"] {
                arrayAssignedList.scrap = scrap as? Int64
            }
            return arrayAssignedList
        }
}

