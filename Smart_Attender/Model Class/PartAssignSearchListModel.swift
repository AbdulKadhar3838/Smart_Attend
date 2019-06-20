//
//  PartAssignListModel.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 13/11/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

class PartAssignSearchListModel{
    
  var isSuccess:  Bool?
    var arrayPartNumberList: Array<PartNumberList>?
    
    static func valueInitialization(jsonData:[String:AnyObject]) -> PartAssignSearchListModel {
        
        let partAssignSearchListModel = PartAssignSearchListModel()
        if let isSuccess = jsonData["IsSuccess"] {
            partAssignSearchListModel.isSuccess = isSuccess as? Bool
        }
        if let assignList = jsonData["lstPart"] as? [AnyObject]  {
            
            partAssignSearchListModel.arrayPartNumberList = assignList.map({PartNumberList.valuePassing(dict: $0)})
        }
        
        return partAssignSearchListModel
    }
    
    
    
}

class PartNumberList {
    
    var partNumber:  String?
    var description : String?
    var cavity: Int64?
    var cycleTime: Double?
    var partId: Int64?
    
    
    static func valuePassing(dict:AnyObject) -> PartNumberList {
        let partNumberList = PartNumberList()
        
        if  let partId = dict["PartId"] {
            partNumberList.partId = partId as? Int64
        }
        if let partNumber = dict["PartNumber"] {
            partNumberList.partNumber = partNumber as? String
        }
        if let cavity = dict["Cavity"] {
            partNumberList.cavity = cavity as? Int64
        }
        if let cycleTime = dict["CycleTime"] {
            partNumberList.cycleTime = cycleTime as? Double
        }
        if let description = dict["Description"] {
            partNumberList.description = description as? String
        }
        return partNumberList

}
}
