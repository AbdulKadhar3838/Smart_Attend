//
//  CreatePartList.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 13/12/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

class CreatePartListModel {
    var isSuccess:Bool?
    var arrayList:[PartList]?
    
    static func valueInitialization(jsonData:[String:AnyObject]) -> CreatePartListModel {
        let createPartList = CreatePartListModel()
        
        if let isSuccess = jsonData["IsSuccess"]
        {
            createPartList.isSuccess = isSuccess as? Bool
        }
        if let responseList = jsonData["LstPartModel"] as? [AnyObject]  {
            print(responseList)
            createPartList.arrayList = responseList.map({PartList.valuePassing(dict: $0)})
        }
        
        return createPartList
    }
}
class PartList {
    
    var groupID:String?
    var partNo:String?
    var cavity:Int?
    var cycleTime:String?
    var description:String?
    var partID:Int64?
    
    static func valuePassing(dict:AnyObject) -> PartList {
            let list = PartList()
            list.groupID = dict["GroupID"] as? String  ?? ""
            list.partNo = dict["PartNumber"]  as? String ?? ""
            list.cavity = dict["Cavity"] as? Int ?? 0
            list.cycleTime = dict["CycleTime"] as? String ?? ""
            list.description = dict["Description"] as? String ?? ""
        list.partID = dict["PartId"] as? Int64 ?? 0
            return list
    }
}
