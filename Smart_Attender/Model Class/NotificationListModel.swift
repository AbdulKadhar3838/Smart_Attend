//
//  NotificationListModel.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 05/12/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

class NotificationListModel {
    var isSuccess:Bool?
    var arrayList:[ListDescription]?
    
    static func valueInitialization(jsonData:[String:AnyObject]) -> NotificationListModel {
        let notificationListModel = NotificationListModel()
        
        if let isSuccess = jsonData["IsSuccess"] as? Bool
        {
            notificationListModel.isSuccess = isSuccess
        }
        if let responseList = jsonData["lstDescription"] as? [AnyObject]  {
            
            notificationListModel.arrayList = responseList.map({ListDescription.valuePassing(dict: $0)})
        }
        
        return notificationListModel
    }
}

class ListDescription {
    var description:String?
    var deviceID:Int64?
    var entityType:Int?
    var id:Int64?
    var plannedShutdownMasterID:Int64?
    
    
    static func valuePassing(dict:AnyObject) -> ListDescription {
        let list = ListDescription()
        
        if  let description = dict["Description"] as? String{
            list.description = description
        }
        if let deviceID = dict["DeviceID"] as? Int64{
            list.deviceID = deviceID
        }
        if let entityType = dict["EntityType"] as? Int{
            list.entityType = entityType
        }
        if let id = dict["Id"] as? Int64{
            list.id = id
        }
        if let plannedShutdownMasterID = dict["PlannedShutdownMasterID"] as? Int64 {
            list.plannedShutdownMasterID = plannedShutdownMasterID
        }
        
        
        return list
    }
}
